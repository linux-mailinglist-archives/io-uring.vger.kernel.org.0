Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8E7253515
	for <lists+io-uring@lfdr.de>; Wed, 26 Aug 2020 18:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgHZQkV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Aug 2020 12:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgHZQkT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Aug 2020 12:40:19 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A8BC061574
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 09:40:19 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id v6so2766991iow.11
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 09:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=zuI5L/CEZV2KDVFA6PSEUngiI68gn82/7UuRuQLO9ck=;
        b=DCkjDAvmFTgGiWL3vG0TVfLLHy5//whNik+WTWn+KarpuIgEIXFbAd2hrLdi5tej95
         vK/DGas538yB6H3WyRdqepLrTIlVghIusxp904AsKihn4bWcXmjpbrjEuqmLV9q3AsJn
         5Kj1TjtznSU9YHUh7FKz57xBlqzo3xJlAmsFMCGdPnsSTAr1naP5JHneGuMncIn4JmnU
         niWX66lhD4OT07JfHyYtD5I1m60K1NLtFeHGSvktHJYNyVBLyMr0kDiaCUGdqZ/Q3Wy8
         rZ1EkwjmDoGCCaLxyRKoO9BrmL1We2LImWL4kZW2y3tKBz5MCI4yzRaYVVo5XRIy7mg/
         r4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=zuI5L/CEZV2KDVFA6PSEUngiI68gn82/7UuRuQLO9ck=;
        b=Qsdf4u6J7KymC3nntgAjMY6wLgsCOUhK/JGbjfHs94NC66nmUcuhG49N5uXCitsoUx
         KHJU/fz64k7zlXfBHrDx0Kwecf77yxQHE4gk6LKo6/xyu4GgFoQf3nTCDr/PJryr+5IN
         PvmxePljULLNOqIaoXON5Ex7iiM3b7Gd/BGMvi6qD8JddBYHZj9kypZeEEtRDKX7OryM
         9ziQJdW1U19pLYsHk3YyJEIqkSv9oVe+edvXaYDgufxXRk08ek1YXXR5Y3KZK9zW0f9N
         VVwh/bDsIt1jcLFgkbxSTZqae/Vex7GlUtbjOdQxpABPBTh1SedFwe0uPSsYEWQRtccy
         W6QA==
X-Gm-Message-State: AOAM532WP+oxgwC+S2jt9HAIbvj/fXshcUUlZHJtuH6OYzUOdXwzWeii
        LtLQNSSeUfCWPjnaTnSfA7eA5/36DxpwoPeT
X-Google-Smtp-Source: ABdhPJwLKj+iGsH6u+KXCoXcnMK8jB/XAGh4pN3nainlt0OUlzHUvm58oqs+L5/KuSFLbY8c3kRZCw==
X-Received: by 2002:a02:69d1:: with SMTP id e200mr6047667jac.96.1598460018180;
        Wed, 26 Aug 2020 09:40:18 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c1sm1646887ilk.28.2020.08.26.09.40.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:40:17 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: make offset == -1 consistent with preadv2/pwritev2
Message-ID: <eee81ef8-8669-fb73-954d-99a75e940d02@kernel.dk>
Date:   Wed, 26 Aug 2020 10:40:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The man page for io_uring generally claims were consistent with what
preadv2 and pwritev2 accept, but turns out there's a slight discrepancy
in how offset == -1 is handled for pipes/streams. preadv doesn't allow
it, but preadv2 does. This currently causes io_uring to return -EINVAL
if that is attempted, but we should allow that as documented.

This change makes us consistent with preadv2/pwritev2 for just passing
in a NULL ppos for streams if the offset is -1.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: Benedikt Ames <wisp3rwind@posteo.eu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d9b88644d5e8..bd2d8de3f2e8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2866,6 +2866,11 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	return iov_iter_count(&req->io->rw.iter);
 }
 
+static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
+{
+	return kiocb->ki_filp->f_mode & FMODE_STREAM ? NULL : &kiocb->ki_pos;
+}
+
 /*
  * For files that don't have ->read_iter() and ->write_iter(), handle them
  * by looping over ->read() or ->write() manually.
@@ -2901,10 +2906,10 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 
 		if (rw == READ) {
 			nr = file->f_op->read(file, iovec.iov_base,
-					      iovec.iov_len, &kiocb->ki_pos);
+					      iovec.iov_len, io_kiocb_ppos(kiocb));
 		} else {
 			nr = file->f_op->write(file, iovec.iov_base,
-					       iovec.iov_len, &kiocb->ki_pos);
+					       iovec.iov_len, io_kiocb_ppos(kiocb));
 		}
 
 		if (iov_iter_is_bvec(iter))
@@ -3139,7 +3144,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		goto copy_iov;
 
 	iov_count = iov_iter_count(iter);
-	ret = rw_verify_area(READ, req->file, &kiocb->ki_pos, iov_count);
+	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), iov_count);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -3262,7 +3267,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 		goto copy_iov;
 
 	iov_count = iov_iter_count(iter);
-	ret = rw_verify_area(WRITE, req->file, &kiocb->ki_pos, iov_count);
+	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), iov_count);
 	if (unlikely(ret))
 		goto out_free;
 
-- 
Jens Axboe

