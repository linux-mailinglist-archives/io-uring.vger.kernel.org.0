Return-Path: <io-uring+bounces-9095-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF328B2D92B
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 11:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7295C5C746E
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 09:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 414EB2E2DDD;
	Wed, 20 Aug 2025 09:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTFXohb7"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E2E29B233;
	Wed, 20 Aug 2025 09:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755682842; cv=none; b=EsqIfIwy06KLyiGZVv0oW0k67HsWk2T8LlD4JxwRdTC08b8b4MOM+M11G5m+8zCcjCY2OxSQwm2QyiD/rA/srncKTJtwbqqrSiBy2G3EchwYiOTUF/32cPAucO5YZR5YYwyBkuhISysqwbtb2PMfif6a/YhN98ahffa/SRNZmNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755682842; c=relaxed/simple;
	bh=ltG/L6we3mCVlQzjBWr+in9Aol+egLkobfWb0flWf74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDBktybvo6YwOTJTG7pWtK268mlNzSzBta+4VSzIkJr6MYvU1/b1/sH7P1MAO9y+t+l0EpG3vJxQz6YQ/OhJ58lUEd6HiGXBy6w8joINYvz/oY4peumArDsDQQQDl4Ms2PnkyBRf2y8tW4WjUn0RY73JZSCHuQxWwh/8zqwpuDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTFXohb7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845AAC4CEEB;
	Wed, 20 Aug 2025 09:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755682841;
	bh=ltG/L6we3mCVlQzjBWr+in9Aol+egLkobfWb0flWf74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dTFXohb7iMZisDMnBL0h+PyNNbKRQd1kkI+7a+nvA7m1iv+MltZfTCc+5h0JBf1TV
	 L8vr7awj0WZ0GaOUc5k51Ro3AciFBaUg44IqoJKE7tg2D/wrLtXo+065AGUnctxbOj
	 FN1gWHzU1GB7XayukPAZmdgkaITOjFZFePsDywcQypZcqMEq8NiLV2uI8KWFRzr+KN
	 ThmcFIaHdIl2Fdq+N4S/2swgD9+YvbXsswRsGJCgloQHJfl42e4oUPBW1MnxxnVedy
	 Yuqz4yMJnjKjC1PGrxRrmHuG8afYqch944YRE6dtVKd2GyuWftVdv/j40UpO0g6ULw
	 ZnfpNRHQGwIZQ==
Date: Wed, 20 Aug 2025 11:40:36 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add a FMODE_ flag to indicate IOCB_HAS_METADATA
 availability
Message-ID: <20250820-voruntersuchung-fehlzeiten-4dcf7e45c29f@brauner>
References: <20250819082517.2038819-1-hch@lst.de>
 <20250819082517.2038819-2-hch@lst.de>
 <20250819-erwirbt-freischaffend-e3d3c1e8967a@brauner>
 <20250819092219.GA6234@lst.de>
 <20250819-verrichten-bagger-d139351bb033@brauner>
 <20250819133447.GA16775@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250819133447.GA16775@lst.de>

On Tue, Aug 19, 2025 at 03:34:47PM +0200, Christoph Hellwig wrote:
> On Tue, Aug 19, 2025 at 12:14:26PM +0200, Christian Brauner wrote:
> > On Tue, Aug 19, 2025 at 11:22:19AM +0200, Christoph Hellwig wrote:
> > > On Tue, Aug 19, 2025 at 11:14:41AM +0200, Christian Brauner wrote:
> > > > It kind of feels like that f_iocb_flags should be changed so that
> > > > subsystems like block can just raise some internal flags directly
> > > > instead of grabbing a f_mode flag everytime they need to make some
> > > > IOCB_* flag conditional on the file. That would mean changing the
> > > > unconditional assigment to file->f_iocb_flags to a |= to not mask flags
> > > > raised by the kernel itself.
> > > 
> > > This isn't about block.  I will be setting this for a file system
> > > operation as well and use the same io_uring code for that.  That's
> > > how I ran into the issue.
> > 
> > Yes, I get that. That's not what this is about. If IOCB_* flags keep
> > getting added that then need an additional opt-out via an FMODE_* flag
> > it's very annoying because you keep taking FMODE_* bits.
> 
> Agreed.
> 
> > The thing is
> > that it should be possible to keep that information completely contained
> > to f_iocb_flags without polluting f_mode.
> 
> I don't really understand how that would work.  The basic problem is that
> we add optional features/flags to read and write, and we need a way to
> check that they are supported and reject them without each time having
> to update all instances.  For that VFS-level code needs some way to do
> a per-instance check of available features.

I meant something like this which should effectively be the same thing
just that we move the burden of having to use two bits completely into
file->f_iocb_flags instead of wasting a file->f_mode bit:

diff --git a/block/fops.c b/block/fops.c
index ddbc69c0922b..a90f1127d035 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -689,7 +689,7 @@ static int blkdev_open(struct inode *inode, struct file *filp)
        if (bdev_can_atomic_write(bdev))
                filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
        if (blk_get_integrity(bdev->bd_disk))
-               filp->f_mode |= FMODE_HAS_METADATA;
+               filp->f_iocb_flags |= IOCB_MAY_USE_METADATA;

        ret = bdev_open(bdev, mode, filp->private_data, NULL, filp);
        if (ret)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 601d036a6c78..a40a1bf7bad5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -149,9 +149,6 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* Expect random access pattern */
 #define FMODE_RANDOM           ((__force fmode_t)(1 << 12))

-/* Supports IOCB_HAS_METADATA */
-#define FMODE_HAS_METADATA     ((__force fmode_t)(1 << 13))
-
 /* File is opened with O_PATH; almost nothing can be done with it */
 #define FMODE_PATH             ((__force fmode_t)(1 << 14))

@@ -384,25 +381,27 @@ struct readahead_control;
 /* kiocb is a read or write operation submitted by fs/aio.c. */
 #define IOCB_AIO_RW            (1 << 23)
 #define IOCB_HAS_METADATA      (1 << 24)
+#define IOCB_MAY_USE_METADATA  (1 << 25)

 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
-       { IOCB_HIPRI,           "HIPRI" }, \
-       { IOCB_DSYNC,           "DSYNC" }, \
-       { IOCB_SYNC,            "SYNC" }, \
-       { IOCB_NOWAIT,          "NOWAIT" }, \
-       { IOCB_APPEND,          "APPEND" }, \
-       { IOCB_ATOMIC,          "ATOMIC" }, \
-       { IOCB_DONTCACHE,       "DONTCACHE" }, \
-       { IOCB_EVENTFD,         "EVENTFD"}, \
-       { IOCB_DIRECT,          "DIRECT" }, \
-       { IOCB_WRITE,           "WRITE" }, \
-       { IOCB_WAITQ,           "WAITQ" }, \
-       { IOCB_NOIO,            "NOIO" }, \
-       { IOCB_ALLOC_CACHE,     "ALLOC_CACHE" }, \
-       { IOCB_DIO_CALLER_COMP, "CALLER_COMP" }, \
-       { IOCB_AIO_RW,          "AIO_RW" }, \
-       { IOCB_HAS_METADATA,    "AIO_HAS_METADATA" }
+       { IOCB_HIPRI,                   "HIPRI" }, \
+       { IOCB_DSYNC,                   "DSYNC" }, \
+       { IOCB_SYNC,                    "SYNC" }, \
+       { IOCB_NOWAIT,                  "NOWAIT" }, \
+       { IOCB_APPEND,                  "APPEND" }, \
+       { IOCB_ATOMIC,                  "ATOMIC" }, \
+       { IOCB_DONTCACHE,               "DONTCACHE" }, \
+       { IOCB_EVENTFD,                 "EVENTFD"}, \
+       { IOCB_DIRECT,                  "DIRECT" }, \
+       { IOCB_WRITE,                   "WRITE" }, \
+       { IOCB_WAITQ,                   "WAITQ" }, \
+       { IOCB_NOIO,                    "NOIO" }, \
+       { IOCB_ALLOC_CACHE,             "ALLOC_CACHE" }, \
+       { IOCB_DIO_CALLER_COMP,         "CALLER_COMP" }, \
+       { IOCB_AIO_RW,                  "AIO_RW" }, \
+       { IOCB_HAS_METADATA,            "AIO_HAS_METADATA" }, \
+       { IOCB_MAY_USE_METADATA,        "AIO_MAY_USE_METADATA" }

 struct kiocb {
        struct file             *ki_filp;
@@ -3786,6 +3785,10 @@ static inline bool vma_is_fsdax(struct vm_area_struct *vma)
 static inline int iocb_flags(struct file *file)
 {
        int res = 0;
+
+       /* Retain flags that the kernel raises internally. */
+       res |= (file->f_iocb_flags & (IOCB_HAS_METADATA | IOCB_MAY_USE_METADATA));
+
        if (file->f_flags & O_APPEND)
                res |= IOCB_APPEND;
        if (file->f_flags & O_DIRECT)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index af5a54b5db12..23e9103c62d4 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -886,7 +886,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
        if (req->flags & REQ_F_HAS_METADATA) {
                struct io_async_rw *io = req->async_data;

-               if (!(file->f_mode & FMODE_HAS_METADATA))
+               if (!(file->f_iocb_flags & IOCB_MAY_USE_METADATA))
                        return -EINVAL;

                /*


