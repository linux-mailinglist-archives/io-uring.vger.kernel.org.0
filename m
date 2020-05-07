Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADFB1C9956
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2020 20:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEGSbu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 May 2020 14:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgEGSbu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 May 2020 14:31:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A968C05BD43
        for <io-uring@vger.kernel.org>; Thu,  7 May 2020 11:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=e0R7K/g7eJ+kAT/Fnl6k+iKXqG131gLUmCqsUSJUgiI=; b=KAdgoZddsifmzvVYzpuT71UvV9
        V5dVNTxE9i9D12UcLANIlz1DtZ13o/3OriReDF9b7lSRIs+dkQY916XcCyPLfyAhj1+aW+iwwJKd5
        GYsjTzkKV+imEeHluBNv/kz/d83vCq5+QwD2fKAx0hvv6Se0pfo7jYK1NELU/OrtVjmcPUyZH86Wa
        vFUl2HWXOVj1IUJvDgn8RcY85qvdz1cdSV/+DNdYwC+Mf2+rLcj301nDUYI4HPB3/YmX+1JyCaFmL
        S2n9UM/FYde6F2JvGpl50DIFJYE6Lj3eQ9KqcxWUlUuyvuzhcoBZxYcImtoSgPuZkdutebUtb9euo
        0k4Zm0MTBZ4IoFFppVaOg4XKDcV4hV1N5jr/w1WiKuuINoEGjq1Wd6t52qG+MVZq385jHSAjMBoob
        IaGdTikUpwrRjd14VOpT0JekWWq87/n+w3BRKNU4ZZSxFx3YkeFFGLd/uQ7uJAT8yHdYhhesQWmRV
        YPgylw1MFoMiuo6ws7Oit6mM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jWlJC-0003Ww-Mn; Thu, 07 May 2020 18:31:47 +0000
Date:   Thu, 7 May 2020 11:31:40 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        jra@samba.org
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
Message-ID: <20200507183140.GD25085@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
 <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
 <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
 <a8152d38-8ad4-ee4c-0e69-400b503358f3@samba.org>
 <6fb9286a-db89-9d97-9ae3-d3cc08ef9039@gmail.com>
 <9c99b692-7812-96d7-5e88-67912cef6547@samba.org>
 <117f19ce-e2ef-9c99-93a4-31f9fff9e132@gmail.com>
 <97508d5f-77a0-e154-3da0-466aad2905e8@kernel.dk>
 <20200507164802.GB25085@jeremy-acer>
 <01778c43-866f-6974-aa4a-7dc364301764@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01778c43-866f-6974-aa4a-7dc364301764@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 07, 2020 at 10:50:40AM -0600, Jens Axboe wrote:
> On 5/7/20 10:48 AM, Jeremy Allison wrote:
> > On Thu, May 07, 2020 at 10:43:17AM -0600, Jens Axboe wrote:
> >>
> >> Just like for regular system calls, applications must be able to deal
> >> with short IO.
> > 
> > Thanks, that's a helpful definitive reply. Of course, the SMB3
> > protocol is designed to deal with short IO replies as well, and
> > the Samba and linux kernel clients are well-enough written that
> > they do so. MacOS and Windows however..
> 
> I'm honestly surprised that such broken clients exists! Even being
> a somewhat old timer cynic...
> 
> > Unfortunately they're the most popular clients on the planet,
> > so we'll probably have to fix Samba to never return short IOs.
> 
> That does sound like the best way forward, short IOs is possible
> with regular system calls as well, but will definitely be a lot
> more frequent with io_uring depending on the access patterns,
> page cache, number of threads, and so on.

OK, I just want to be *REALLY CLEAR* what you're telling me
(I've already written the pread/pwrite wrappers for Samba
that deal with short IO but want to ensure I understand
fully before making any changes to Samba).

You're saying that on a bog-standard ext4 disk file:

ret = pread(fd, buf, count, offset);

can return *less* than count bytes if there's no IO
error and the file size is greater than offset+count
and no one else is in the middle of a truncate etc. ?

And:

ret = pwrite(fd, buf, count, offset);

can return less* than count bytes if there's no IO
error and there's ample space on disk ?

I have to say I've *never* seen that happen, and
Samba is widely enough used that IO corruption from
short reads/writes from MacOSX and Windows clients
would have been widely reported by now.

Look at how quickly someone spotted disk corruption
because of the change in userspace-visible behavior
of the io_uring interface. We only shipped that code
03 March 2020 and someone *already* found it.

Jeremy.
