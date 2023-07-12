Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEBE750D5B
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 18:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjGLQC2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 12:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbjGLQC0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 12:02:26 -0400
X-Greylist: delayed 54531 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Jul 2023 09:02:24 PDT
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C35199E;
        Wed, 12 Jul 2023 09:02:24 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 189BEC021; Wed, 12 Jul 2023 18:02:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1689177743; bh=+s2RQfzza+02ouHBCRWMKfEdNGGN+ASvxtADuv0V8tk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=4g0gR7Jn1aaizhzV7P6PCxOPzzgbvcOEL9wlh4GnzErduxvT6L/7vhfi2NV1ILrFa
         XutizRcly78kh18xIs07DmipG8WTv/x9ob4Tj7a+2YgmvcRFh0NqqLEukahFH+0cjW
         ERh+Hti2HyrlxwpT3GeU+58otEPUp1lxTyYQTCthul/+2fYQFDCkUxnegma/MpdwXz
         ySoiBha5f+Hp+0fCQdeDiuRLYokw0MEo+cu9uVvzTb2swdLvUDNAh/1QmioMWlkE4j
         iY1sYAvpVoxDD8vbVa4JjjwHsZCXgrmNucJ+t+h7vmEYpLzP2zlDfbpK4fSWqN9+4d
         /BAmCA3humW1A==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 16A7BC009;
        Wed, 12 Jul 2023 18:02:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1689177741; bh=+s2RQfzza+02ouHBCRWMKfEdNGGN+ASvxtADuv0V8tk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WWddTbHL/4yJtkXcOhJ7wlEm7KS4KxtFhQJ/tNeDEwDi89WcoUz1SGDX7msf4tNol
         YIUKTqXBT9eZINbGzrYPrgydZhDRG+OwRmqUhnJBkhjJxqgSgQeQmHbaJZoW9E2ykx
         D4w4Y2CMZvCt2mpx6/V+8PCZGCecUWUepxQI4cDowuu2fy3+SODqRKBtvyoREq6ram
         1dlSXyWjjnYvo3115V28M2prgd0QA+29kLuhqAr9HNW9CB3tptLWWDE12zPmhY9l7f
         OFhsK+vrxaamTrbjN+vtHJFfIOt/4zDGOH47aI6fSNUYLGy7XWT59Ne5PNKWzC7D8d
         xcy7rDcgFE/eQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 4f2617d6;
        Wed, 12 Jul 2023 16:02:15 +0000 (UTC)
Date:   Thu, 13 Jul 2023 01:02:00 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 2/3] vfs_getdents/struct dir_context: add flags field
Message-ID: <ZK7OeEmsHAU7xSxQ@codewreck.org>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-3-hao.xu@linux.dev>
 <20230712-halbleiter-weder-35e042adcb30@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230712-halbleiter-weder-35e042adcb30@brauner>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

(replying as that was my code)

Christian Brauner wrote on Wed, Jul 12, 2023 at 01:31:57PM +0200:
> On Tue, Jul 11, 2023 at 07:40:26PM +0800, Hao Xu wrote:
> > diff --git a/fs/readdir.c b/fs/readdir.c
> > index 9592259b7e7f..b80caf4c9321 100644
> > --- a/fs/readdir.c
> > +++ b/fs/readdir.c
> > @@ -358,12 +358,14 @@ static bool filldir64(struct dir_context *ctx, const char *name, int namlen,
> >   * @file    : pointer to file struct of directory
> >   * @dirent  : pointer to user directory structure
> >   * @count   : size of buffer
> > + * @flags   : additional dir_context flags
> 
> Why do you need that flag argument. The ->iterate{_shared}() i_op gets
> passed the file so the filesystem can check
> @file->f_mode & FMODE_NOWAIT, no?

As far as I understand it, it's not because the fd is capable of NOWAIT
that uring will call it in NOWAIT mode:
- if the first getdents call returned -EAGAIN it'll also fall back to
waiting in a separate thread (there's no "getdents poll" implementation,
so there's no other way of rescheduling a non-blocking call)
- it's also possible for the user to specify it wants IOSQE_ASYNC in the
sqe->flags (admitedly I'm not sure why would anyone do this, but that's
useful for benchmarks at least -- it skips the initial NOWAIT call
before falling back to threaded waiting call)

Even outsides of io_uring, a call to getdents64 should block, so even if
the filesystem supports non-blocking it should be explicitely required
by the caller.


> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1719,8 +1719,16 @@ typedef bool (*filldir_t)(struct dir_context *, const char *, int, loff_t, u64,
> >  struct dir_context {
> >  	filldir_t actor;
> >  	loff_t pos;
> > +	unsigned long flags;
> >  };
> >  
> > +/*
> > + * flags for dir_context flags
> > + * DIR_CONTEXT_F_NOWAIT: Request non-blocking iterate
> > + *                       (requires file->f_mode & FMODE_NOWAIT)
> > + */
> > +#define DIR_CONTEXT_F_NOWAIT	(1 << 0)
> 
> Even if this should be needed, I don't think this needs to use a full
> flags field.

I also got a request to somehow pass back "are there more entries to
read after this call" to the caller in my v1, and I had done this as a
second flag -- in general my understanding was that it's better to add
flags than a specific boolean for extensibility but I have no opinon
here.


-- 
Dominique Martinet | Asmadeus
