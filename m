Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3096EC32C
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 01:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDWXn2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Apr 2023 19:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDWXn1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Apr 2023 19:43:27 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF7810DC;
        Sun, 23 Apr 2023 16:43:24 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 686F9C01F; Mon, 24 Apr 2023 01:43:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682293402; bh=TQDHD4jI59yg5j92q8CZUXHlZNsl1jsaeFCptRogf/Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nayINonr/sB4v3HW01quRhd+xr1575UgoZGlXNPxkHRu0meWc+xGEpBqEY90gPHP8
         76XrWUKGCCJJHAc5BgkDSUrD8bJIk8M5Fql/xU50B5DBdZBo/JVG3oQFa5cy/gVoj4
         jZkJ68P1PTuWSJnRJ5S4LszBxCoL+/UmJz+DYKjwxXMy5kpiFU6QIzcZPl+iA4MLXE
         XHKJ5xZZtOXPWer934KcW5il7y7zMyTxO4sFPr2o9UuC8Bfy6Wk2nui3/3IDr6SsvY
         olITCQkJ2zg12b4dQTSIcgxH3PfFzgeucr7OWzxMscw9F7hhmn6Heo+kPBnrLjQxMS
         4yyfyFIdMnf+g==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id F0968C009;
        Mon, 24 Apr 2023 01:43:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682293401; bh=TQDHD4jI59yg5j92q8CZUXHlZNsl1jsaeFCptRogf/Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZgF5QrmaAmHNgSkif+qUnkKMyLqSqljUL0cTguaelnnOqeGcCBVylo0uZENCEK2OK
         px1O6P0Sawbks/lLuOaBtLIguspd//gxo3jSUg9HRNbbNpSr+EIVZFg4whJ7AOb6FD
         36ybP1jS7cloLsRTNhG1JVhJavATBrkwqQ51jJSW5yDIYbhT3ska57S68zUVlvY0JG
         Nh2pW/BY/4LYoHscdkLgto9pdpa8gAE6xy8qHHW2aJL4yB2VF2u4okCDSEAlVYxRHk
         05tmLz0V0PySqMuHVDY9Snl2ArWz9ofBzLBNN9StZ1r72I4lMVvT0NzfEfZFNs9oon
         GHJwQGWA9WMxQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id a40d7486;
        Sun, 23 Apr 2023 23:43:15 +0000 (UTC)
Date:   Mon, 24 Apr 2023 08:43:00 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] io_uring: add support for getdents
Message-ID: <ZEXChAJfCRPv9vbs@codewreck.org>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
 <20230423224045.GS447837@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230423224045.GS447837@dread.disaster.area>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dave Chinner wrote on Mon, Apr 24, 2023 at 08:40:45AM +1000:
> This doesn't actually introduce non-blocking getdents operations, so
> what's the point? If it just shuffles the getdents call off to a
> background thread, why bother with io_uring in the first place?

As said in the cover letter my main motivation really is simplifying the
userspace application:
 - style-wise, mixing in plain old getdents(2) or readdir(3) in the
middle of an io_uring handling loop just feels wrong; but this may just
be my OCD talking.
 - in my understanding io_uring has its own thread pool, so even if the
actual getdents is blocking other IOs can progress (assuming there is
less blocked getdents than threads), without having to build one's own
extra thread pool next to the uring handling.
Looking at io_uring/fs.c the other "metadata related" calls there also
use the synchronous APIs (renameat, unlinkat, mkdirat, symlinkat and
linkat all do), so I didn't think of that as a problem in itself.


> Filesystems like XFS can easily do non-blocking getdents calls - we
> just need the NOWAIT plumbing (like we added to the IO path with
> IOCB_NOWAIT) to tell the filesystem not to block on locks or IO.
> Indeed, filesystems often have async readahead built into their
> getdents paths (XFS does), so it seems to me that we really want
> non-blocking getdents to allow filesystems to take full advantage of
> doing work without blocking and then shuffling the remainder off to
> a background thread when it actually needs to wait for IO....

I believe that can be done without any change of this API, so that'll be
a very welcome addition when it is ready; I don't think the adding the
uring op should wait on this if we can agree a simple wrapper API is
good enough (or come up with a better one if someone has a Good Idea)

(looking at io_uring/rw.c for comparison, io_getdents() will "just" need
to be adjusted to issue an async req if IO_URING_F_NONBLOCK is set, and
the poll/retry logic sorted out)

Thanks,
-- 
Dominique Martinet | Asmadeus
