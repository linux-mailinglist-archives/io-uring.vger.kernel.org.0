Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070176F2857
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 11:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjD3Jhl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 05:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjD3Jhj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 05:37:39 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7C510F5
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:38 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f1738d0d4cso7686795e9.1
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682847456; x=1685439456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2vxHCZ2OuX71vQYdRJrfXQvjrvCcUs/wO/UUdzYl7E=;
        b=sJRgjvbcGr58l5wmaZKYxF3uhClScVRDWB4wUcQscLShTx1n8IcUjEoTMsHbqxMFvJ
         qgnF/Yn30dsib17ok/MvfeDe2u2d+hRW5167RKvB99IZwrBk3P2LgSm4WIefVFSNfkhJ
         HU9GGww0KF7NYhjost7cW0qO+ZfU8btpXRZHJAROVSUew5tKtOoaAZz6EdF1UWEW9MPF
         oHLpdC7pZH6wrawq558mcCESxnhn/5X2SHcd2oLl82+8Xb0x3UVlS7ofjQW/MJ9Rl4k8
         zpfw7h0BOGPPv8wEmO9JgYlQxeh3jr27iw8LYTCXY4Sku/0Y0jbFDycYJbKfAOYJ2HGG
         HW6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682847456; x=1685439456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k2vxHCZ2OuX71vQYdRJrfXQvjrvCcUs/wO/UUdzYl7E=;
        b=WWT8cvK/xK3uJx9R1yTI+JVx+imbcm+p8mvgzgTIhLfhHvQREJ+1H2FF16906SbHYK
         6PHCWiJm1ag+GS54c00MJmR2KN1bPchj/qSIE/3pVCOePDdRWFpVp1oZs96AgeKEDx/Y
         OIVZW9EokvhU6pkovGP5SVaJ27eXmUF04Zbq25qhw8hhQXkS/LiQ2o4IgaUwPnlLN/Oi
         RrIuO2bC7yOla1QnsOEqMeB1+R3LlvM6k1N844+Nje/toNVHG0JrsOSwp5RrKc1RUkaE
         WqG037GVoJjnsQFal3MI83hP2xbPtmg5yU5W/MNETZMWP2mShog94qPgjxnwe4pplAKh
         PBEQ==
X-Gm-Message-State: AC+VfDzU++Faox5IB5vIYlMXrvRNZjTec/u1jDDgy/EzOlflxfTDYyXL
        S6gBJ+U++RpJhg9Zz4dE+ITeyoNFFSU=
X-Google-Smtp-Source: ACHHUZ7UuoyUsMkIvWgL0+58z5czdu/3mGEgXzt3chNRzzOoJEC/Ey+do/f+/UP6oBJ417J9rem9XA==
X-Received: by 2002:a7b:ce07:0:b0:3f1:70e6:df66 with SMTP id m7-20020a7bce07000000b003f170e6df66mr8263037wmc.36.1682847456484;
        Sun, 30 Apr 2023 02:37:36 -0700 (PDT)
Received: from 127.0.0.1localhost (188.31.116.198.threembb.co.uk. [188.31.116.198])
        by smtp.gmail.com with ESMTPSA id u19-20020a05600c00d300b003f17eaae2c9sm29473170wmm.1.2023.04.30.02.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 02:37:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, ming.lei@redhat.com
Subject: [RFC 2/7] io_uring: add reg-buffer data directions
Date:   Sun, 30 Apr 2023 10:35:24 +0100
Message-Id: <01cf42c097ca12984b6dbe01407319b05b123824.1682701588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682701588.git.asml.silence@gmail.com>
References: <cover.1682701588.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There will be buffers that only allow reading from or writing to it, so
add data directions, and check it when importing a buffer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 5 +++++
 io_uring/rsrc.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index fef94f8d788d..b6305ae3538c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1185,6 +1185,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	imu->ubuf = (unsigned long) iov->iov_base;
 	imu->ubuf_end = imu->ubuf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
+	imu->dir_mask = (1U << ITER_SOURCE) | (1U << ITER_DEST);
 	*pimu = imu;
 	ret = 0;
 
@@ -1274,6 +1275,8 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	u64 buf_end;
 	size_t offset;
 
+	BUILD_BUG_ON((1U << ITER_SOURCE) & (1U << ITER_DEST));
+
 	if (WARN_ON_ONCE(!imu))
 		return -EFAULT;
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
@@ -1281,6 +1284,8 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	/* not inside the mapped region */
 	if (unlikely(buf_addr < imu->ubuf || buf_end > imu->ubuf_end))
 		return -EFAULT;
+	if (unlikely(!((1U << ddir) & imu->dir_mask)))
+		return -EFAULT;
 
 	/*
 	 * Might not be a start of buffer, set size appropriately
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f34de451a79a..10daa25d9194 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -57,6 +57,7 @@ struct io_mapped_ubuf {
 	u64		ubuf_end;
 	unsigned int	nr_bvecs;
 	unsigned int	max_bvecs;
+	unsigned int	dir_mask;
 	unsigned long	acct_pages;
 	struct bio_vec	bvec[];
 };
-- 
2.40.0

