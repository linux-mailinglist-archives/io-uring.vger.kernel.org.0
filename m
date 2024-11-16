Return-Path: <io-uring+bounces-4763-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C159D00FA
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 22:27:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B62C1F23505
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 21:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2AE0194A63;
	Sat, 16 Nov 2024 21:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZvalBXIO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015B519D096
	for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 21:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731792439; cv=none; b=TNljGVYTXlPjLzxpe8vQ/KiY+HXTC/eR5XZGny0jmz6fz89kE9n56e0fHQQCjP2gGeBtplg/WTufOUBLoNvu0RUlVIy93UGmO2jcRfGrayAJCbSzPSqWPvsn6e+8fYKsAHo8kXqrV0IelAQjCaH2AqmHY7cFeMkEtcwraGZDzls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731792439; c=relaxed/simple;
	bh=/U7llu4aV2Z6u48nn6cMMkQl3HL89ZiKItVcEZmCaQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCSq/a3KwW4c1HxjpiwWkL9cgGCb8B71n7DQEQZO5Ro/RXaibmgKo7z/vpiU+t6pZbZ6wUPA46/2NtGvCbJOFsKoM68pRd3tTItcakr1O78q2H/bcBsWpSQwTfNyM/lh1Bn2DgDYs0JwCqDlpIflwVavcu5xjgIRV9+PkV05P6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZvalBXIO; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43167ff0f91so15962155e9.1
        for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 13:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731792436; x=1732397236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ycXKQjejvoZ7J/mfxsd4mU/r13p1EMUuROr4/t67Bsk=;
        b=ZvalBXIOr3WP8kTlTOnvkMIm8Sq2tnB6iYuu/j3BwwM160Y+7IBzbY15jeOnUMimQw
         9PuLCnHKbipmAsRH5ukZ0Tf7lYMITRHllNiHjp49qU4D8bPA4OoROTxuNYMyeRNeT24O
         2hBllw+JFdnW63PysUiCsarusMQ3DixUY6YBY2XG/vCi4Qj9J8BDcQ+gHX6oN+9ztrNK
         rm/dA6hwg6rmawnHh+beHSrmt4ZnMh0atdrLF/Fw8p1d/hGPCZ47GN/3nBiVYMdV5ea3
         Fs9inCERlVYVeyVeI/2AqcBpITBuWBS3lOpb/n3FS4smPzdlvSf9mtY8CZxQOQTg4nnB
         A3hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731792436; x=1732397236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ycXKQjejvoZ7J/mfxsd4mU/r13p1EMUuROr4/t67Bsk=;
        b=oUIn2iywKrizQM1O8bmjspRuBauvrIzQWmHxIgltjj0eukLrm+W5NRQNQdwVL9JpKo
         1uZtSnRTi6494WbNiciSn9ty+/aI3O8/IDTEsadTHMhQsOVyd4qbZZXSmkD7n29l54FJ
         3XRRIG16KI4kgRm2AWwYXo83W82WfIBXli2Ri1UMwPWlBXttt90TdtmqJqUbQOCV6TBk
         wdBabdUiKpgU1nLQedW06SbCXOTTHSL1hVmLlhdkwlSqrEmOym33rEFaRJUnnmCQ3/io
         fVjTpRqaFuoiAMcWri6rxyrIgDLzL+Nbyq9g4pYrVJgb/rhZwbiSKI2vKaJoRDs8SuiZ
         kw1w==
X-Gm-Message-State: AOJu0YwNRhWV2Qfez5GmsJKDf+WtUf9VCg8jpn3Q10Rz9IL1L9hfdNlk
	VBSHMQ9JvwGhlet21mpHP30rtk+2xjTLDokNo97FuEIN7wOx7uDAqPGjIg==
X-Google-Smtp-Source: AGHT+IGOqujDqci6eHkb1Ecr5P6naecR3A9n/7NvBOrk1iLPYE2otoykNPh39tbwW2W1p2iyiq6pmQ==
X-Received: by 2002:a05:600c:3d86:b0:42f:8515:e490 with SMTP id 5b1f17b1804b1-432df7179c6mr63419205e9.5.1731792436152;
        Sat, 16 Nov 2024 13:27:16 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac0aef0sm101071325e9.28.2024.11.16.13.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 13:27:15 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 7/8] test/reg-wait: add registration helper
Date: Sat, 16 Nov 2024 21:27:47 +0000
Message-ID: <defbcb4f286b62c04dedaab54a7e7d1de0ad33e7.1731792294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731792294.git.asml.silence@gmail.com>
References: <cover.1731792294.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 56 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index ffe4c1d..559228f 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -32,6 +32,37 @@ static int test_wait_reg_offset(struct io_uring *ring,
 				     sizeof(struct io_uring_reg_wait));
 }
 
+static int __init_ring_with_region(struct io_uring *ring, unsigned ring_flags,
+				   struct io_uring_mem_region_reg *pr,
+				   bool disabled)
+{
+	int flags = disabled ? IORING_SETUP_R_DISABLED : 0;
+	int ret;
+
+	ret = io_uring_queue_init(8, ring, flags);
+	if (ret) {
+		if (ret != -EINVAL)
+			fprintf(stderr, "ring setup failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = io_uring_register_region(ring, pr);
+	if (ret)
+		goto err;
+
+	if (disabled) {
+		ret = io_uring_enable_rings(ring);
+		if (ret) {
+			fprintf(stderr, "io_uring_enable_rings failure %i\n", ret);
+			goto err;
+		}
+	}
+	return 0;
+err:
+	io_uring_queue_exit(ring);
+	return ret;
+}
+
 static int page_size;
 static struct io_uring_reg_wait *reg;
 
@@ -222,30 +253,11 @@ static int test_try_register_region(struct io_uring_mem_region_reg *pr,
 				    bool disabled)
 {
 	struct io_uring ring;
-	int flags = 0;
 	int ret;
 
-	if (disabled)
-		flags = IORING_SETUP_R_DISABLED;
-
-	ret = io_uring_queue_init(8, &ring, flags);
-	if (ret) {
-		if (ret != -EINVAL)
-			fprintf(stderr, "ring setup failed: %d\n", ret);
-		return ret;
-	}
-
-	ret = io_uring_register_region(&ring, pr);
-	if (ret)
-		goto err;
-
-	if (disabled) {
-		ret = io_uring_enable_rings(&ring);
-		if (ret)
-			fprintf(stderr, "io_uring_enable_rings failure %i\n", ret);
-	}
-err:
-	io_uring_queue_exit(&ring);
+	ret = __init_ring_with_region(&ring, 0, pr, disabled);
+	if (!ret)
+		io_uring_queue_exit(&ring);
 	return ret;
 }
 
-- 
2.46.0


