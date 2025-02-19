Return-Path: <io-uring+bounces-6554-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA001A3BB3D
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 11:11:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F094D3AC7C9
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 10:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD151C3BFC;
	Wed, 19 Feb 2025 10:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2YNQ11i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4426F15B971
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 10:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739959625; cv=none; b=jcDq7ex6knX2iNnpO6lT9WAaO/EUh9Uyp+LYOWwRi7i9U/NkDJLdd9zmDSmpAw7GwVj+qBHrq+S5D4/qkazhLZkFu4gE86Qlwf3ez6ZNtRE0dBDZZGE8Q4rQ5TxclCDAUh5FDpuoFNirUUbAsaCo0s+B7D8/YpJ0RFH5UgjOsI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739959625; c=relaxed/simple;
	bh=SBQTcK29RKTRkfjtfhQSQb7t8Ob2pQoE0CT7qC1OHjA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tBmw8xrBUpfAN+o74YTiN0dYSwsfOcYp1Y2pMp3YwYbswxwXoFFFYvkjqH/dVGfBix/uHs5TYp0vjIwXRMD7wqQy5ohnZOIqaZLsvb5AG2DQGhVJ8e2PfJ+DFAW9g9ypTYnvX+mSkdssQcZAP68ZFl8xB0ndmZF/i8CM9tGtYV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2YNQ11i; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-abbc38adeb1so242413666b.1
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 02:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739959622; x=1740564422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lNKsxZWjdsbAguyL9fy5mgpiEVdfqm+0Ki80zlkAlpg=;
        b=K2YNQ11i0dFCwSDcyXXmQdWPcMUroURhyENgcqYeIoRFSbCwbhAVbh2uhB3EqTs07H
         6/W6BNd88W+DMkR67xzOaI+WhHb/xBXhnO+zgEDwcx7Q9AUi67cObo2FnmC3UlXf4tO8
         JsnoV5PNtUPOCu6+X8Vft+5yVqFIoXtsLqr6t5v/nWUgWPSSabAzIQN8cgWhWFLkpgrs
         +q3Ij+gkUfpv5KPhYVvWJ7NU/kLlTXVfsQipu4R6hfUtfS/3v6Wlp0lVDQOMq7sYx+cU
         IM9ckU2PnVVBB3X8j1phxgr2JGmozKvcI5X0zmNsj+2jybyRl3WVUxSm8disOgd5Xep+
         LUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739959622; x=1740564422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lNKsxZWjdsbAguyL9fy5mgpiEVdfqm+0Ki80zlkAlpg=;
        b=epVW+dTWqTogYKS4U3V0vsfVCd7Y0695rtCox+XHLPqb0FCjQcaJqnN26ploHy+3W0
         6amCTcD5Eu4NtG9oUWDPobyImMeLpUHaxNMhDwGlh//pds/TEO7WLJuIjXnMYuViWPl7
         etaiRA4QWJtTLzrZGlTp/BnPADuz6mqCmZ5gMnxe7bxAQp6+/1e2vJj8EPybJjJnHrI8
         zymNcGHsEn8s4ZK8+zp6GcBJ51frXrUFHoerZ6Rqnhvk4nk+xQMsyP5ecP6wz0UKG144
         UzuYTB0zwpMVLHeTUUKUL9F+xKMs4IT9u+I51TCrtjNLhvArSI/v9ipSbv2H2c0uWMqJ
         99Ag==
X-Gm-Message-State: AOJu0YxYEDld5Jktu0Af4P0W6pOejh/AV74Yq1FF2VMWYWRTJd349Swt
	faEzF+h/cV7+Hb5wbva+sDBTzYo390d7hO/B+PZE64OIZwWD7aXEfVvoHA==
X-Gm-Gg: ASbGncvYxhJx+BY2t5E4KgdKLjbm03H/NhG5nU8Am4B5Cu2yhGUU4IrJC0Fa+F+P0n7
	v9jf7BD21XyQmBpPc1f04ZpQsRpeR99SAfPApTP1NcjusAZ++p5c+NjhWEtW3P4xaCAJNUiWE7p
	jryNi7Byvree++woXOijG+ouNyIM6dBfciNUiQ6y5fTyLTQaJMDF0eoa6KxHm2Z7yMs8Nv/oC77
	JH8q5loV9IcQ5WtXBi47XVqaved/jiYO6vOjWeTvQjyqRCvKd6/pXcctK9h+dmQJSjOO+ZHJIo=
X-Google-Smtp-Source: AGHT+IECyFQTH2u+7lzOqjGGzdRSudjApCZ08qCPxUpGifhRjtYDE9lvOCDlImzWNvrLARmLENTwdA==
X-Received: by 2002:a17:906:1bb2:b0:ab3:9923:ef4e with SMTP id a640c23a62f3a-abbccea67aamr279159466b.22.1739959622024;
        Wed, 19 Feb 2025 02:07:02 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:cfff])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba5a4f4cb4sm1156471566b.118.2025.02.19.02.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 02:07:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Kees Bakker <kees@ijzerbout.nl>
Subject: [PATCH 1/1] io_uring/zcrx: recheck ifq on shutdown
Date: Wed, 19 Feb 2025 10:08:01 +0000
Message-ID: <905e55c47235ab26377a735294f939f31d00ae53.1739934175.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_ring_exit_work() checks ifq before shutting it down and guarantees
that the pointer is stable, but instead of relying on rather complicated
synchronisation recheck the ifq pointer inside.

Reported-by: Kees Bakker <kees@ijzerbout.nl>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 026efb8dd381..a9eaab3fccf2 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -489,9 +489,9 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	lockdep_assert_held(&ctx->uring_lock);
 
-	if (ctx->ifq)
-		io_zcrx_scrub(ctx->ifq);
-
+	if (!ctx->ifq)
+		return;
+	io_zcrx_scrub(ctx->ifq);
 	io_close_queue(ctx->ifq);
 }
 
-- 
2.48.1


