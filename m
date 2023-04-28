Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B53E6F113C
	for <lists+io-uring@lfdr.de>; Fri, 28 Apr 2023 07:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345277AbjD1FGs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Apr 2023 01:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345165AbjD1FGr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Apr 2023 01:06:47 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A89A2D45
        for <io-uring@vger.kernel.org>; Thu, 27 Apr 2023 22:06:45 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1a920d4842bso69243975ad.2
        for <io-uring@vger.kernel.org>; Thu, 27 Apr 2023 22:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682658404; x=1685250404;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K+priwgVTI5G9m2IAcDviTBaPANz0KSFOmw49YgGUdI=;
        b=DdoVOedUxUiBDMPss2+elnVBPyCyJNeO8QeLYntRLaBFlrFnUj55nnP40KvPb/QaAr
         maZi1ZZfOQWs2UfwLn2KK6ptXfIYAl+vkpoN2pBTcXDhEbJfyum8KYEGrgUAFTB3AGQW
         0zUK6RP+MghQbeuKlwuyrYjV3AM+lTf8yutDYyhNp3xJrZVCkukxfHC6BanumEniBhyG
         YOGPbHdOOFhvz4j65V6ArQqZupnSWlmPapfcjS2u/5jTHCZMIW4gZcJ5jsTvrgZdFmVo
         1TPgDCV+xMiaeNdwt1RUTXybDDc/2d+VZSxN350zQhp7JynKdPV2wewFf1Oic96zDZpb
         tLew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682658404; x=1685250404;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K+priwgVTI5G9m2IAcDviTBaPANz0KSFOmw49YgGUdI=;
        b=c0kYVYidH2RoQYh98idXB4ApHZpvznOwWCKfEo+svy59WaW7IGuG0Y8Kf0N6FUC/5l
         F6gY1LRKB5Z1jrDV6H8k78l35P6EH5Nr7l9/V33XfpkV+kE70OY/HDC2s/cyjoAgC7hQ
         2P1piCHdYmI6j6sbTWHlNxOOhLP5du0HdKFw2KFsJ7wffxMC7QEanKPSMGFXF1Sk00Nz
         DLOSNQUPhHmHwCaTuovO5Fl89fPBE2mTpR+STLaSOJniGkRUWA8bgFJTR9qrK1zI9OPy
         Ax3Wpn7lFhKXV0+RpJ5iyLz2g/KJVQIy+F0TaC7dgJ6HXfmDwk5RNC8BDrZQrirV9B6M
         Rm3g==
X-Gm-Message-State: AC+VfDyzVx2geSnFjwbc+Et0bIEDtZ8N6A+FoPnGnsoPBkrH6Aes/Ayo
        5JW74u5D/uCYzxzsJqC4GQ+3Dw==
X-Google-Smtp-Source: ACHHUZ4335WaLJ0IvStVlJSpeRvka4TYtBqleZr3zv6nyrNafUFSz86H7cUtmDNEwU72UdEYNQQMuQ==
X-Received: by 2002:a17:902:b702:b0:1a6:c595:d7c3 with SMTP id d2-20020a170902b70200b001a6c595d7c3mr3692487pls.22.1682658404604;
        Thu, 27 Apr 2023 22:06:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902900900b001a514d75d16sm12405984plp.13.2023.04.27.22.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 22:06:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1psGJc-008kwW-Oy; Fri, 28 Apr 2023 15:06:40 +1000
Date:   Fri, 28 Apr 2023 15:06:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] io_uring: add support for getdents
Message-ID: <20230428050640.GA1969623@dread.disaster.area>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
 <20230423224045.GS447837@dread.disaster.area>
 <ZEXChAJfCRPv9vbs@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEXChAJfCRPv9vbs@codewreck.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 24, 2023 at 08:43:00AM +0900, Dominique Martinet wrote:
> Dave Chinner wrote on Mon, Apr 24, 2023 at 08:40:45AM +1000:
> > This doesn't actually introduce non-blocking getdents operations, so
> > what's the point? If it just shuffles the getdents call off to a
> > background thread, why bother with io_uring in the first place?
> 
> As said in the cover letter my main motivation really is simplifying the
> userspace application:
>  - style-wise, mixing in plain old getdents(2) or readdir(3) in the
> middle of an io_uring handling loop just feels wrong; but this may just
> be my OCD talking.
>  - in my understanding io_uring has its own thread pool, so even if the
> actual getdents is blocking other IOs can progress (assuming there is
> less blocked getdents than threads), without having to build one's own
> extra thread pool next to the uring handling.
> Looking at io_uring/fs.c the other "metadata related" calls there also
> use the synchronous APIs (renameat, unlinkat, mkdirat, symlinkat and
> linkat all do), so I didn't think of that as a problem in itself.

I think you missed the point. getdents is not an exclusive operation
- it is run under shared locking unlike all the other direcotry
modification operations you cite above. They use exclusive locking
so there's no real benefit by trying to run them non-blocking or
as an async operation as they are single threaded and will consume
a single thread context from start to end.

Further, one of the main reasons they get punted to the per-thread
pool is so that io_uring can optimise away the lock contention
caused by running multiple work threads on exclusively locked
objects; it does this by only running one work item per inode at a
time.

This is exactly what we don't want with getdents - we want to be
able to run as many concurrent getdents and lookup operations in
parallel as we can as both all use shared locking. IOWs, getdents
and inode lookups are much closer in behaviour and application use
to concurrent buffered data reads than they are to directory
modification operations.

We can already do concurrent getdents/lookup operations on a single
directory from userspace with multiple threads, but the way this
series adds support to io_uring somewhat prevents concurrent
getdents/lookup operations on the same directory inode via io_uring.
IOWs, adding getdents support to io_uring like this is not a step
forwards for applications that use/need concurrency in directory
lookup operations.

Keep in mind that if the directory is small enough to fit in the
inode, XFS can return all the getdents information immediately as it
is guaranteed to be in memory without doing any IO at all. Why
should that fast path that is commonly hit get punted to a work
queue and suddenly cost an application at least two extra context
switches?

> > Filesystems like XFS can easily do non-blocking getdents calls - we
> > just need the NOWAIT plumbing (like we added to the IO path with
> > IOCB_NOWAIT) to tell the filesystem not to block on locks or IO.
> > Indeed, filesystems often have async readahead built into their
> > getdents paths (XFS does), so it seems to me that we really want
> > non-blocking getdents to allow filesystems to take full advantage of
> > doing work without blocking and then shuffling the remainder off to
> > a background thread when it actually needs to wait for IO....
> 
> I believe that can be done without any change of this API, so that'll be
> a very welcome addition when it is ready;

Again, I think you miss the point.

Non blocking data IO came before io_uring and we had the
infrastructure in place before io_uring took advantage of it.
Application developers asked the fs developers to add support for
non-blocking direct IO operations and because we pretty much had all
the infrastructure to support already in place it got done quickly
via preadv2/pwritev2 via RWF_NOWAIT flags.

We already pass a struct dir_context to ->iterate_shared(), so we
have a simple way to add context specific flags down the filesystem
from iterate_dir(). This is similar to the iocb for file data IO
that contains the flags field that holds the IOCB_NOWAIT context for
io_uring based IO. So the infrastructure to plumb it all the way
down the fs implementation of ->iterate_shared is already there.

XFS also has async metadata IO capability and we use that for
readahead in the xfs_readdir() implementation. hence we've got all
the parts we need to do non-blocking readdir already in place. This
is very similar to how we already had all the pieces in the IO path
ready to do non-block IO well before anyone asked for IOCB_NOWAIT
functionality....

AFAICT, the io_uring code wouldn't need to do much more other than
punt to the work queue if it receives a -EAGAIN result. Otherwise
the what the filesystem returns doesn't need to change, and I don't
see that we need to change how the filldir callbacks work, either.
We just keep filling the user buffer until we either run out of
cached directory data or the user buffer is full.

And as I've already implied, several filesystems perform async
readahead from their ->iterate_shared methods, so there's every
chance they will return some data while there is readahead IO in
progress. By the time the io_uring processing loop gets back to
issue another getdents operation, that IO will have completed and the
application will be able to read more dirents without blocking. The
filesystem will issue more readahead while processing what it
already has available, and around the loop we go.

> I don't think the adding the
> uring op should wait on this if we can agree a simple wrapper API is
> good enough (or come up with a better one if someone has a Good Idea)

It doesn't look at all hard to me. If you add a NOWAIT context flag
to the dir_context it should be relatively trivial to connect all
the parts together. If you do all the VFS, io_uring and userspace
testing infrastructure work, I should be able to sort out the
changes needed to xfs_readdir() to support nonblocking
->iterate_shared() behaviour.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
