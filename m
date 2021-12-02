Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E13466DA3
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 00:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356451AbhLBX1m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Dec 2021 18:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349346AbhLBX1l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Dec 2021 18:27:41 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB372C061757
        for <io-uring@vger.kernel.org>; Thu,  2 Dec 2021 15:24:18 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id v23so1530240iom.12
        for <io-uring@vger.kernel.org>; Thu, 02 Dec 2021 15:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=NLDDw1pqgSFWCbeKySen1cv6lFv+DqvXYym5kKf0q4s=;
        b=mZCsJDK8loRnEhs1PHBAcK+4zZR5uR5yZrJTL53/yNDbJGFGg3d6+oKTFcAo5+uicQ
         /JuRrE7MFqz99uE9qsrjp6PN1OKCn8NXK6xATr1rDNHhL3N5aPzKDq6ZgdFwA5scRVJl
         Xo838GyR70XH0XIulYstak7JT/rvLJ8Jn4yIga2Cti7TnY8H18vaxllHUP7PNr4NcvKx
         gsQWc6BlbknwaJqEUz08+lyclM8lo6QfUMJ9VTg31f2vBfvJaLV0PakTQzPhbCwulN0Z
         rUqqyjE3MJ38LNYTjgY/bisrF6UmE3R4Lx7xswL2ZAO8AZEUXxeFaWj5CKftd46RIkHS
         0aUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=NLDDw1pqgSFWCbeKySen1cv6lFv+DqvXYym5kKf0q4s=;
        b=rpA0W76s5wdtlM/9mOcX1wcO5h+cU0mcRj91POvV/UTrwcUjCbMmgRSdNIvs7yscaC
         eAnnAokksnw1l9SlmGyX3BI0xyekCpQ9+UCrmJFail+rpEr27WnOZpRv5LM3nXLM6vPM
         jECJqlVw2XaIB+isK+fJCtYshQo57qK6I/LNXVIgzBQXIH2k7fx4UBVUQyxm9bys3wgS
         6vSgJZ03lKEa5tqFNi+xnrLCEu+3fwC56Q5eIbJQT9FhZWuI2V/MTP1aaI+06eadQH5C
         xNQgbADjonhBMqkYbvd20geIVXu8xnON7fmSnq1COa2BUg9xepMQxQqVCocI4OO5Fl7C
         gkeg==
X-Gm-Message-State: AOAM530vowSyEGsJjamB1n3Mz0aTBErWVO/FH0QCoJB72nT7L5QXyyPw
        7EXJkErQTHwPy5UxCJi7Qd7ocm1CdFUYbVbR
X-Google-Smtp-Source: ABdhPJxKXoNYer6IUg2VNbco2TTVgn2gGULZpd15LSrIlBDh/DG/mXm99yvW1npuIEUPfWqpr5aftQ==
X-Received: by 2002:a05:6602:3422:: with SMTP id n34mr3289994ioz.7.1638487458048;
        Thu, 02 Dec 2021 15:24:18 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m2sm637168iob.21.2021.12.02.15.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 15:24:17 -0800 (PST)
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH RFC] block: enable bio allocation cache for IRQ driven IO
Message-ID: <c24fe04b-6a46-93b2-a6a6-a77606a1084c@kernel.dk>
Date:   Thu, 2 Dec 2021 16:24:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently cannot use the bio recycling allocation cache for IRQ driven
IO, as the cache isn't IRQ safe (by design).

Add a way for the completion side to pass back a bio that needs freeing,
so we can do it from the io_uring side. io_uring completions always
run in task context.

This is good for about a 13% improvement in IRQ driven IO, taking us from
around 6.3M/core to 7.1M/core IOPS.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Open to suggestions on how to potentially do this cleaner. The below
obviously works, but ideally we'd want to run the whole end_io handler
from this context rather than just the bio put. That would enable
further optimizations in this area.

But the wins are rather large as-is.

diff --git a/block/fops.c b/block/fops.c
index 10015e1a5b01..9cea5b60f044 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -295,14 +295,19 @@ static void blkdev_bio_end_io_async(struct bio *bio)
 		ret = blk_status_to_errno(bio->bi_status);
 	}
 
-	iocb->ki_complete(iocb, ret);
-
 	if (dio->flags & DIO_SHOULD_DIRTY) {
 		bio_check_pages_dirty(bio);
 	} else {
 		bio_release_pages(bio, false);
-		bio_put(bio);
+		if (iocb->ki_flags & IOCB_BIO_PASSBACK) {
+			iocb->ki_flags |= IOCB_PRIV_IS_BIO;
+			iocb->private = bio;
+		} else {
+			bio_put(bio);
+		}
 	}
+
+	iocb->ki_complete(iocb, ret);
 }
 
 static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4591bcb79b1f..5644628b8cb7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2770,6 +2770,9 @@ static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 	unsigned int cflags = io_put_rw_kbuf(req);
 	int res = req->result;
 
+	if (req->rw.kiocb.ki_flags & IOCB_PRIV_IS_BIO)
+		bio_put(req->rw.kiocb.private);
+
 	if (*locked) {
 		io_req_complete_state(req, res, cflags);
 		io_req_add_compl_list(req);
@@ -2966,6 +2969,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
+		kiocb->ki_flags |= IOCB_ALLOC_CACHE | IOCB_BIO_PASSBACK;
 		kiocb->ki_complete = io_complete_rw;
 	}
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0cc4f5fd4cfe..1e9d86955e3d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -322,6 +322,10 @@ enum rw_hint {
 #define IOCB_NOIO		(1 << 20)
 /* can use bio alloc cache */
 #define IOCB_ALLOC_CACHE	(1 << 21)
+/* iocb supports bio passback */
+#define IOCB_BIO_PASSBACK	(1 << 22)
+/* iocb->private holds bio to put */
+#define IOCB_PRIV_IS_BIO	(1 << 23)
 
 struct kiocb {
 	struct file		*ki_filp;

-- 
Jens Axboe

