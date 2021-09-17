Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4451140FABF
	for <lists+io-uring@lfdr.de>; Fri, 17 Sep 2021 16:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhIQOvY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Sep 2021 10:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbhIQOvY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Sep 2021 10:51:24 -0400
X-Greylist: delayed 122520 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Sep 2021 07:50:01 PDT
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE814C061574
        for <io-uring@vger.kernel.org>; Fri, 17 Sep 2021 07:50:01 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mRFBc-0053Mt-RD; Fri, 17 Sep 2021 14:49:56 +0000
Date:   Fri, 17 Sep 2021 14:49:56 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [GIT PULL] iov_iter retry fixes
Message-ID: <YUSrFBzbgLTNcSfT@zeniv-ca.linux.org.uk>
References: <9460dc73-e471-d664-7610-a10812a4da24@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9460dc73-e471-d664-7610-a10812a4da24@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 17, 2021 at 08:44:32AM -0600, Jens Axboe wrote:
> Hi Linus,
> 
> This adds a helper to save/restore iov_iter state, and modifies io_uring
> to use it. After that is done, we can kill the iter->truncated addition
> that we added for this release. The io_uring change is being overly
> cautious with the save/restore/advance, but better safe than sorry and
> we can always improve that and reduce the overhead if it proves to be of
> concern. The only case to be worried about in this regard is huge IO,
> where iteration can take a while to iterate segments.
> 
> I spent some time writing test cases, and expanded the coverage quite a
> bit from the last posting of this. liburing carries this regression test
> case now:
> 
> https://git.kernel.dk/cgit/liburing/tree/test/file-verify.c
> 
> which exercises all of this. It now also supports provided buffers, and
> explicitly tests for end-of-file/device truncation as well.
> 
> On top of that, Pavel sanitized the IOPOLL retry path to follow the
> exact same pattern as normal IO.

I can live with that; I do have problems with io-uring and its interactions
with iov_iter, but those are mostly independent from the stuff you are
doing here.

Still digging through your FSM from hell... ;-/
