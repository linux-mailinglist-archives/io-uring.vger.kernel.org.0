Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5531F0C6D
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 17:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgFGPeM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 11:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgFGPeM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 11:34:12 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA180C08C5C4;
        Sun,  7 Jun 2020 08:34:11 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t18so14740768wru.6;
        Sun, 07 Jun 2020 08:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YAsUrh63goZyXNgXwopjHb3IQJxC4ZmIiqNb64E7YCE=;
        b=d/BegjzMabzoMQJbU2EkOFWM7Su8kLnBd8zd6hTi/klxPkj1gMpciKuIN8I18/Zva4
         AkUQP8uNuYNWvUYSWwo9tVy53irMxjJtZiT5C55XvoTlmeWOO4T1HuJoeFuQsSNbkJUv
         Jb5Qpt/2j1jKKtamgrd0WNKFj60Sy2M6mGvzbFLV3Ss/I53q314L4cNu1dRn9GWrir7M
         ktVen5I/I2FqctEcGteagB7/gIl7r01wWTtYpeau5nrw/vhO4NNXkUyiG4h62edPi9Jh
         9GmEZYDPaUkYATIjbv95HKffnRvFysB1Yw3aJYy2tvsH7WTa36e4bzesYF3IRB0BFAYH
         RCZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YAsUrh63goZyXNgXwopjHb3IQJxC4ZmIiqNb64E7YCE=;
        b=qdexcsFJg6+fJMW2R2psm5hqx7oT0udt6Exc9rQVyW3jxEro4UaGmeDt3T88xBCC/4
         DEdJg2P0QK2d5OuYObcGn5Vm32tRHtmvcn3GrsT3K38Mx515M/LPGsxx4ASvC/XL/C4U
         ZTb47ZojNVDtx1cRTyse0VhHZAQWfUs8/CAWbzmQQKI2K9Rstnc91BgEXPR8+C56I2fa
         iXrbP5aSGB4BKOhmXTDyP0OU70ArcFlZGxCJaK0q0hkEd0mbXqAO3CCduT1194MHpROo
         EK3lSHP4DJSof6jsAX4/FYwx57+J8Y7u+JVIGw3SFKV0HnaHXledfYRmfauQ47seuAsp
         6KYQ==
X-Gm-Message-State: AOAM533sCqqBiOXTHPovRXMDWBLKsgjBWYetgkGXyOWpwdiRd8Fn6pYS
        mtmWtFjL8In7bBE4iisXI3orR4+8
X-Google-Smtp-Source: ABdhPJyMEDjmKxVLRT2WZxxYzrQQOyr3M+Kv5WuLxbpYve49Slt1Tjb9NQ50EkEIfWA0lbhO5ihUaw==
X-Received: by 2002:adf:a51c:: with SMTP id i28mr19090257wrb.78.1591544050431;
        Sun, 07 Jun 2020 08:34:10 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id 1sm19589015wmz.13.2020.06.07.08.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 08:34:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] io_uring: batch cancel in io_uring_cancel_files()
Date:   Sun,  7 Jun 2020 18:32:25 +0300
Message-Id: <156ed08ba6c25ce97f6ba3261e64b2ffba6b2b58.1591541128.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591541128.git.asml.silence@gmail.com>
References: <cover.1591541128.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of waiting for each request one by one, first try to cancel all
of them in a batched manner, and then go over inflight_list/etc to reap
leftovers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bcfb3b14b888..3aebbf96c123 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7519,9 +7519,22 @@ static int io_uring_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static bool io_wq_files_match(struct io_wq_work *work, void *data)
+{
+	struct files_struct *files = data;
+
+	return work->files == files;
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
+	if (list_empty_careful(&ctx->inflight_list))
+		return;
+
+	/* cancel all at once, should be faster than doing it one by one*/
+	io_wq_cancel_cb(ctx->io_wq, io_wq_files_match, files, true);
+
 	while (!list_empty_careful(&ctx->inflight_list)) {
 		struct io_kiocb *cancel_req = NULL, *req;
 		DEFINE_WAIT(wait);
-- 
2.24.0

