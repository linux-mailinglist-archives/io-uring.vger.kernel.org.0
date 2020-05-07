Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2D71C9A0B
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2020 20:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgEGSzU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 May 2020 14:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728383AbgEGSzT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 May 2020 14:55:19 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F412C05BD43
        for <io-uring@vger.kernel.org>; Thu,  7 May 2020 11:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=bIxTrZTW0nE3kGTTU7WkR2Xccon09LthkePYWDjm5gc=; b=X1LtjIf7+xY1EjopMTGyZ1PWD/
        xrjz5bY3AmoUW+umXn0lIhnS8Khk7mtHXIQhUeF1VRSNxhSyonnjjMOVMPhdEgGbTUzv7V/fMpM2F
        QyXqHHND8wBXm0A7sQdFXPtKkIejlI6yTuKXjSs3/V7/B3WiRLQTo43qiC1ImR7tP0mTpY54mxqnm
        srQbsa7zbtjLp3J35TrLpQxtxc47kYtbq6m5CzSzSNkgZ8aMVXMmnbQZp7Jmk757HN1lGIPzyUnyW
        3uKCXezbDmOOzzmdF+FC0rkSKkF1MTPVXTrjOTyTPXh19Iy0CPgF7lPRaGCJOebOtW25soXAYn4CY
        QmU2e91yg3Y/BxZBwChiDptp3VPM6bwcW4OPRoCQ9FpEj43Lkmg9c8ZVmv73giMPPg7xMp9sLg9nf
        hULBl6VbpNJsZswNeA/1X03Le50z9bz30an5URH56Uw3pskkeA+BUtAggT122VthWnQ0TpfLyaoJT
        /JXZcd7ATdeZJlrJEGezvJvO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jWlfu-0003k7-J9; Thu, 07 May 2020 18:55:14 +0000
Date:   Thu, 7 May 2020 11:55:07 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        jra@samba.org
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
Message-ID: <20200507185507.GF25085@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
 <a8152d38-8ad4-ee4c-0e69-400b503358f3@samba.org>
 <6fb9286a-db89-9d97-9ae3-d3cc08ef9039@gmail.com>
 <9c99b692-7812-96d7-5e88-67912cef6547@samba.org>
 <117f19ce-e2ef-9c99-93a4-31f9fff9e132@gmail.com>
 <97508d5f-77a0-e154-3da0-466aad2905e8@kernel.dk>
 <20200507164802.GB25085@jeremy-acer>
 <01778c43-866f-6974-aa4a-7dc364301764@kernel.dk>
 <20200507183140.GD25085@jeremy-acer>
 <3130bca5-a2fb-a703-4387-65348fe1bdc8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3130bca5-a2fb-a703-4387-65348fe1bdc8@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 07, 2020 at 12:35:42PM -0600, Jens Axboe wrote:
> On 5/7/20 12:31 PM, Jeremy Allison wrote:
> > 
> > Look at how quickly someone spotted disk corruption
> > because of the change in userspace-visible behavior
> > of the io_uring interface. We only shipped that code
> > 03 March 2020 and someone *already* found it.
> 
> I _think_ that will only happen on regular files if you use RWF_NOWAIT
> or similar, for regular blocking it should not happen. So I don't think
> you're at risk there, though I do think that anyone should write
> applications with short IOs in mind or they will run into surprises down
> the line. Should have been more clear!

Well we definitely considered short IOs writing the
server code, but as the protocol allows that to be
visible to the clients (in fact it has explicit
fields meant to deal with it) it wasn't considered
vital to hide them from clients.

We'll certainly fix up short reads for the iouring
module, but it's less clear we should mess with
our existing blocking threaded pread/pwrite code
to deal with them. Possibly goes into the bucket
of "belt and braces, couldn't possibly hurt" :-).

Thanks for the clarification !
