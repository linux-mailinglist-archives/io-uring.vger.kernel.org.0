Return-Path: <io-uring+bounces-9806-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA90B599D1
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:27:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E61D37AB892
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB5332ED2F;
	Tue, 16 Sep 2025 14:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PE7qIOYi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4CD334711
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032818; cv=none; b=GMB7lKMmVmYVFz2LCUuCFgvVPoKOlASN/3iH8Xo3ymXeH1pZCrHU0KzpTNJBaIDl/PxMOxIBVGQFLq3hLV050/ONyhC40g/ABX2CKRBixYpqGXUG8t6r+SZB3XLwSTx8chTNzm+Z3TvXBZ7nIB50RbV480Y460VQYnwAImKzYT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032818; c=relaxed/simple;
	bh=kZs+DHWaawva+MXn9WHKPm2Vy0w5G8FxKpsyd+A3M0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTblbEbWxjONHGatbuLq+nAZq41bJc2sjiN8T6TrA4eoLo9RnrcdJYGkb1N9pym7E1jVeCA/iZ2AztxxObjnUwtOigpAAE4usPXrNhmlRpOvN0smJDyMvcxmj2m6g3eVAn1xYF+JTKBmQbfkz+ajwVqgyc2o6+OOVIFWLhXPQ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PE7qIOYi; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3e957ca53d1so2497530f8f.0
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032814; x=1758637614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cuj4BWzPC5531S2LDg+xtZ940ulE2g5Y/85FDPfd8xE=;
        b=PE7qIOYiY5du4ByxOR0BT7TNc5mx2yEopxodxNi9Bhu6Yb/XWr9JsVeE13zaWOICFM
         sEmQUx815reCug7faGSVaaUBdrBwWw5likjhcTA3fyX2OhU9FD+5GJ6y6nfL3fCAwiTy
         gOulBvlignYqjGXIL9RaCiKgECkUMxYOFVCqldl5d8cNMLsIeZbGP6uNuzW/O51AqMFw
         mVocL7nb6QfnUXjz9rxDLhRaqZZf1tocDTsIo50HS4L+N94a0usr4wdPs0TSHWJmNr2z
         JwKFwQ+0LxLyf+DDrvpsE8YCkb7qGhXN5XnZWTeh2U1/NLsiVyPOVYQaNnnupM6ao5Vz
         gLYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032814; x=1758637614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cuj4BWzPC5531S2LDg+xtZ940ulE2g5Y/85FDPfd8xE=;
        b=DGzjv1al8FAoKRV2cxoZHCOL7NGrt+es2Euzcnq8pOKzdDP4yQq/VvZX0W1nwe94U5
         T3TjNeoq/MJryyMKbJ/YweD2z2cYCi9A/vG5r8ULKj9IXJ8Tc3XWK5adEBOfGYsk+N1A
         pNjOtckptpZtV1ruc4qj/XdOzdMr+0WthcfaBOcQTfdnxZUr7tsSHYV9krWlhk+VI0l8
         Z5iQT4kDqTU+mM3T71Vk3OwHJG1LbBKC/leZ3Rc/tomfxXco6kTP8mLJm5u4yDziH3lJ
         p64mZDVgMsUcB2YH2hIonR0DkEYl7WrZSBX8OhJbQ4txffaY0Z7sxYUjKVsIC83zAqnA
         MBnw==
X-Gm-Message-State: AOJu0Yw4tbq6Rvj8zXAqbyQMC5Tse5U+Su74jcWOr0dUVT8qAezsIPoa
	joDsgVB1TvvWccCmBrwp7vo/M+gUT24XvqlIw9PCCI7YIp+kJmBL6XoLlnlZ7w==
X-Gm-Gg: ASbGncvYgsZV23IZJHiLAIrzXdQ+O6Fmdg6EW/HI6sDPYIlZGrOwyE+0fPVESlCupta
	wEPA86xFcQdTxBU4V/JLfSvil9lanm5EzhekZurFX6sxM32eGRn22DN1E0drD8RXo9wexPxhOI7
	2FLr/OJdrfmtNIGQp5DQkrW7vMz93iQgloxi6BUrnwGg9v2XQx5uUQQFBV79epxMkxHIFI4fzfE
	T/Ll1D9oVFR4VoP/nRPZPfe3LZzANjqxn1W3gYnFNwkxMKPBTFtl0kxvUHDkWba5hyNiolJPYLA
	FkndLEgwOfu8BFDbfwwTwg8xoTJolOot0JpvXvaYW6pE4S7NK88I5UlWFaNnLuSnVOPjCE3MSaB
	ogJiIoQ==
X-Google-Smtp-Source: AGHT+IGUsH8IIT0VhmUWDtKJn5YdMX11CTBPM32mGFKsWymIVbBGd0bXVkyHF0dAxJirgbThVk2GjQ==
X-Received: by 2002:a05:6000:4013:b0:3ec:6259:5095 with SMTP id ffacd0b85a97d-3ec6259530dmr2969121f8f.12.1758032813885;
        Tue, 16 Sep 2025 07:26:53 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:26:52 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 06/20] io_uring/zcrx: move area reg checks into io_import_area
Date: Tue, 16 Sep 2025 15:27:49 +0100
Message-ID: <4eecbb60c6fb177f1d3a9027b85082678d999b0f.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_import_area() is responsible for importing memory and parsing
io_uring_zcrx_area_reg, so move all area reg structure checks into the
function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index c64b8c7ddedf..ef8d60b92646 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -26,6 +26,8 @@
 #include "zcrx.h"
 #include "rsrc.h"
 
+#define IO_ZCRX_AREA_SUPPORTED_FLAGS	(IORING_ZCRX_AREA_DMABUF)
+
 #define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
 
 static inline struct io_zcrx_ifq *io_pp_to_ifq(struct page_pool *pp)
@@ -231,6 +233,13 @@ static int io_import_area(struct io_zcrx_ifq *ifq,
 {
 	int ret;
 
+	if (area_reg->flags & ~IO_ZCRX_AREA_SUPPORTED_FLAGS)
+		return -EINVAL;
+	if (area_reg->rq_area_token)
+		return -EINVAL;
+	if (area_reg->__resv2[0] || area_reg->__resv2[1])
+		return -EINVAL;
+
 	ret = io_validate_user_buf_range(area_reg->addr, area_reg->len);
 	if (ret)
 		return ret;
@@ -395,8 +404,6 @@ static void io_zcrx_free_area(struct io_zcrx_area *area)
 	kfree(area);
 }
 
-#define IO_ZCRX_AREA_SUPPORTED_FLAGS	(IORING_ZCRX_AREA_DMABUF)
-
 static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 				struct io_zcrx_area *area)
 {
@@ -413,13 +420,6 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	unsigned nr_iovs;
 	int i, ret;
 
-	if (area_reg->flags & ~IO_ZCRX_AREA_SUPPORTED_FLAGS)
-		return -EINVAL;
-	if (area_reg->rq_area_token)
-		return -EINVAL;
-	if (area_reg->__resv2[0] || area_reg->__resv2[1])
-		return -EINVAL;
-
 	ret = -ENOMEM;
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (!area)
-- 
2.49.0


