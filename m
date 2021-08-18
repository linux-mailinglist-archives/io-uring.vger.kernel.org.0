Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D843F09A2
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 18:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhHRQzX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 12:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhHRQzW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 12:55:22 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC0EC0613CF
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 09:54:47 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j12-20020a17090aeb0c00b00179530520b3so9365704pjz.0
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 09:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=kEu1yD86BJsqlRMd+0IevXHHJbQeM/muuNpXJL43qos=;
        b=yD0TrrCh7JoniBN9v9ohP0fNk2erpvqyabwZf988Caou/64KJMTcZXihTjXqOGPApp
         INcGAHEZAY84yenWRpfMSPhbHPcjLWOkXCCZ5FAZDDFgJGHf7GaUBHLofKLRIQ5mGaU2
         osWL7Z0BtVjiiT3GGbPe+h7hCRUH3qVgxBtC0phOIfkGwjQ6KKKZPUtn2JTZXuzAnViL
         hkfVl523kgGltWIjsYmCLsHUhDWtHBvwkgV4qoCMq5O4Vo8fARiI8ZXBCEuW5PcgtXkM
         O1SbfzcnIeegdbPSG8bUmJfc3YMfnrEyKKmN2dfISpheYYjJTnvOki6yLDC2IZeOc1PM
         XDgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=kEu1yD86BJsqlRMd+0IevXHHJbQeM/muuNpXJL43qos=;
        b=WAsavdypXNTkLsfrLDmJs5PBrX2WZLTEzoV3wafSO6ia3UacHn/ihzBUwal9K4AP+T
         fLtciOc3rbpM5V9Hm4Yt3tjTjkoS7MMiJCK1oIYrKmgkv0V8+/hr3S1Bxh1AB76hkcNI
         XFMHqU6UDzniarTVla6ZiGa3MaX5fx4XXG7EqIWYx/VNYm2q7qRaKqhteZIPqVfWrDHM
         ou+74qCYt8DPK5s4NwUzgq1r644SfqVBkFF6WvmjBvkziHWhMcsYSa6f90fbFVSP56c+
         T3v8plBpyWI6Nm0sU9LrSbsN3JFqK2/miAPcBy153L/xtN9x44yW0ZFXizfL9s4WPBDz
         R20w==
X-Gm-Message-State: AOAM533NNUhapUTsC9dJy1hfSgCVEnsvHthDryoAxRMl39zyH06CL7AK
        MHMog9KcrxFXMrALdFuXQWZxIw==
X-Google-Smtp-Source: ABdhPJy4etZDF0jHGf1oOL8aQIAiIukCWywT3Ms7aYQIKOo/YWnHPGMbAStYPaSjVf8jNfsjJ2GxUA==
X-Received: by 2002:a17:902:b218:b029:11a:bf7b:1a80 with SMTP id t24-20020a170902b218b029011abf7b1a80mr7922862plr.82.1629305686952;
        Wed, 18 Aug 2021 09:54:46 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id q18sm287702pfj.178.2021.08.18.09.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 09:54:46 -0700 (PDT)
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH RFC] Enable bio cache for IRQ driven IO from io_uring
Message-ID: <3bff2a83-cab2-27b6-6e67-bdae04440458@kernel.dk>
Date:   Wed, 18 Aug 2021 10:54:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We previously enabled this for O_DIRECT polled IO, however io_uring
completes all IO from task context these days, so it can be enabled for
that path too. This requires moving the bio_put() from IRQ context, and
this can be accomplished by passing the ownership back to the issuer.

Use kiocb->private for that, which should be (as far as I can tell) free
once we get to the completion side of things. Add a IOCB_PUT_CACHE flag
to tell the issuer that we passed back the ownership, then the issuer
can put the bio from a safe context.

Like the polled IO ditto, this is good for a 10% performance increase.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Just hacked this up and tested it, Works For Me. Would welcome input on
alternative methods here, if anyone has good suggestions.

diff --git a/block/bio.c b/block/bio.c
index ae9085b97deb..3c838d5cea89 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -684,6 +684,7 @@ void bio_put(struct bio *bio)
 	if (bio_flagged(bio, BIO_PERCPU_CACHE)) {
 		struct bio_alloc_cache *cache;
 
+		WARN_ON_ONCE(!in_task());
 		bio_uninit(bio);
 		cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
 		bio_list_add_head(&cache->free_list, bio);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7b8deda57e74..f30cc8e21878 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -332,6 +332,7 @@ static void blkdev_bio_end_io(struct bio *bio)
 {
 	struct blkdev_dio *dio = bio->bi_private;
 	bool should_dirty = dio->should_dirty;
+	bool free_bio = true;
 
 	if (bio->bi_status && !dio->bio.bi_status)
 		dio->bio.bi_status = bio->bi_status;
@@ -347,7 +348,18 @@ static void blkdev_bio_end_io(struct bio *bio)
 			} else {
 				ret = blk_status_to_errno(dio->bio.bi_status);
 			}
-
+			/*
+			 * If IRQ driven and not using multi-bio, pass
+			 * ownership of bio to issuer for task-based free. Then
+			 * we can participate in the cached bio allocations.
+			 */
+			if (!dio->multi_bio &&
+			    (iocb->ki_flags & (IOCB_ALLOC_CACHE|IOCB_HIPRI)) ==
+						IOCB_ALLOC_CACHE) {
+				iocb->ki_flags |= IOCB_PUT_CACHE;
+				iocb->private = bio;
+				free_bio = false;
+			}
 			dio->iocb->ki_complete(iocb, ret, 0);
 			if (dio->multi_bio)
 				bio_put(&dio->bio);
@@ -363,7 +375,8 @@ static void blkdev_bio_end_io(struct bio *bio)
 		bio_check_pages_dirty(bio);
 	} else {
 		bio_release_pages(bio, false);
-		bio_put(bio);
+		if (free_bio)
+			bio_put(bio);
 	}
 }
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index f984cd1473aa..e5e69bd24d53 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2581,6 +2581,12 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 
 static void io_req_task_complete(struct io_kiocb *req)
 {
+#ifdef CONFIG_BLOCK
+	struct kiocb *kiocb = &req->rw.kiocb;
+
+	if (kiocb->ki_flags & IOCB_PUT_CACHE)
+		bio_put(kiocb->private);
+#endif
 	__io_req_complete(req, 0, req->result, io_put_rw_kbuf(req));
 }
 
@@ -2786,6 +2792,13 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
+		/*
+		 * IRQ driven IO can participate in the bio alloc cache, since
+		 * we don't complete from IRQ anymore. This requires the caller
+		 * to pass back ownership of the bio before calling ki_complete,
+		 * and then ki_complete will put it from a safe context.
+		 */
+		kiocb->ki_flags |= IOCB_ALLOC_CACHE;
 		kiocb->ki_complete = io_complete_rw;
 	}
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 96a0affa7b2d..27bfe25106ba 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -321,6 +321,8 @@ enum rw_hint {
 #define IOCB_NOIO		(1 << 20)
 /* can use bio alloc cache */
 #define IOCB_ALLOC_CACHE	(1 << 21)
+/* bio ownership (and put) passed back to caller */
+#define IOCB_PUT_CACHE		(1 << 22)
 
 struct kiocb {
 	struct file		*ki_filp;

-- 
Jens Axboe

