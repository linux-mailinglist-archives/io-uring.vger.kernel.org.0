Return-Path: <io-uring+bounces-10423-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF559C3CB8B
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:09:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 094A13B12A9
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2180D34D4CD;
	Thu,  6 Nov 2025 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RsechEMb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4272E34D4F8
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448539; cv=none; b=SJdYHkIhxSulMQcgLfBpJs4v+xYfvFNYaTwxsFmpl+t8zx/HQAyD0C341YntEQApmWUPYJWvmzKoCKSsMqgiaf7s2SDlzCSKnJDAVBLA6JV3141xKlQZEQ7hirtUHQ8lUhd6QYhg4oMSfhBGvfLGlPrd3ltNueCpEM8HElhudVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448539; c=relaxed/simple;
	bh=k53kWfgn4YbjrmjKJNkNZ3sVIICsDRM6e8ICIC1MdD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7HvGluAeA7IUX5T0ompnnCzUvyV/UrfnHq1RcuNevBTgLL20ylRF7ueu4eljRPVNoylb2/QvXUDMMkXa76QmiCwK5iEPV6BV22ms1LYdWSqYTqGXocIPGlSWGSoJGa2aArVNWR9aUF50Q/pkj7MVv5CjlNTGHVpMfC4amkemv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RsechEMb; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477563bcaacso9065665e9.1
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448535; x=1763053335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XueCnMQhNza+SWXwANIakTtscYC9IU25JKa6yUOh8+s=;
        b=RsechEMbFck8kTUk9kNLeCyfTVlb6wl/oi0l8GCsH5FFZSp2NGfT2e6g4PY5qBGta9
         EfwZD616MA0KDUsPw6WmjwK5dRAchdB9zYQAaGWAQ8OQwjPEip0/2hZZ2uXlftkFMXqB
         K8h72J0u6cvayiQtQmnq3gsRgIaYybYFGeIZHVVAmzHXpLRBg8XGeOf58RS83Xg9dkdu
         Eh2BCnbiRzkEeYzKv7DzB2pcFq7Huv4E602DB0+3OSl3kql+WVL0GB/td+rKKesdeGlM
         ozw9LdC7RubKd7j777ORHMnWSwwYyDj77iFiMgjzc3KPaUkkFZMw2m/jDJvk0A556/iT
         Vwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448535; x=1763053335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XueCnMQhNza+SWXwANIakTtscYC9IU25JKa6yUOh8+s=;
        b=vGpXSepX1MqCBLQAj383lkNQS/9OV1wy5C4xgDiX/BqxvtzZzMo1yRTAYWKRk+DNfj
         nFWSOcEknTI0JAkdMlwqfvleQ1poP1/P3xPk4HsNx7dEwjht8I9NcM9crDx9XpDUzTzT
         lXtE6zdempcUA5UC7SKaTKtZpVt93xLli9HsEIFKksWF4YufAI/C+sF2jjQBnRAoN8/O
         EsGTPatqyT39ZM1nbDJTDlfp5LOibeJj4raijFEgJUcfk1OnMz2Klf0UiOFmG9roVbvy
         bCZwXxMMO7e3W8b5tgcsr8uNtuVek0sz0r1MJRZmtcc8vykIliot7Dsx4IVpidAMOPQn
         rTkQ==
X-Gm-Message-State: AOJu0YzPnST1jlhgpGQ8bNoHcmlJn+MA+NSskVagbxzhZNdsBaaIKjZC
	0+63Ux5iqe/wbVJJgOgpKse7meal9fMRm3O8AVhz/Lfg9tQ1PiorCed9cqhsvA==
X-Gm-Gg: ASbGncsYOCuoPnnvCMtfcDqb0FYmf6y0TFEq/zcVP3eCE2jhDVoVwBqEiOnym1twUf4
	EDCbIx9N8Gt9elId6FcFMYWc42UnFN6hjAGHvgYMUAWExsTi1xnU870UfE5HwfqvNDLhmokvbbd
	WRXmtEWCHHwXknh3O9KLie9U9Js8lom1lZnZEn/0YcpE5VMLHxYDoIkJ88aGieUFetmPXfMqa9d
	EbEgoOof9h98D9oV19CfjVuyfNRRxZw2Bl/YvYuwlyOHvVwLAWGSGzNrBV+MzioLdU8ovC5RKm5
	Av6HDGH6XzhuLVC2CWoOVgzjiSgXUEhpA/agpXV2tHVBgr1pqMybW4eUusTljkfPnSRAoQejlcZ
	Z2Vxo96cgH5B/z2oHga9UYiwjmii6o6qcSHQ/5vkoYlzVXmAJNwJkjztgK9+BfMJYjkakY0Lhvw
	UCL5E=
X-Google-Smtp-Source: AGHT+IEUGqCNAG1dctiQ3OFpFo4TeEKXc4H0dJPNwQ1EYeoUFrHucczPvrifxaYC7N/al9HGhMMSTA==
X-Received: by 2002:a05:600c:8b09:b0:475:e067:f23d with SMTP id 5b1f17b1804b1-4776bcba007mr207675e9.25.1762448534850;
        Thu, 06 Nov 2025 09:02:14 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:13 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 15/16] io_uring: allow creating mem region at setup
Date: Thu,  6 Nov 2025 17:01:54 +0000
Message-ID: <6a15ce77a48ccb1b0532f3050354a0a9c7a0543b.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762447538.git.asml.silence@gmail.com>
References: <cover.1762447538.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch gives users a way to create a memory region at ring setup
instead of requiring a registration call. First, it can be much more
convenient when the region is used for wait parameters and hence
requires IORING_SETUP_R_DISABLED. I'll also need it in the next patch
for placing SCQ into it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  7 ++++++-
 io_uring/io_uring.c           | 26 ++++++++++++++++++++++++++
 io_uring/io_uring.h           |  1 +
 io_uring/register.c           |  2 ++
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 04797a9b76bc..2da052bd4138 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -599,11 +599,16 @@ struct io_uring_params {
 	__u32 sq_thread_idle;
 	__u32 features;
 	__u32 wq_fd;
-	__u32 resv[3];
+	__u32 resv;
+	__u64 params_ext; /* pointer to struct io_uring_params_ext */
 	struct io_sqring_offsets sq_off;
 	struct io_cqring_offsets cq_off;
 };
 
+struct io_uring_params_ext {
+	__u64 mem_region; /* pointer to struct io_uring_mem_region_reg */
+};
+
 /*
  * io_uring_params->features flags
  */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ff52d9f110ce..908c432aaaaa 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3574,8 +3574,13 @@ int io_uring_fill_params(struct io_uring_params *p)
 static int io_prepare_config(struct io_ctx_config *config)
 {
 	struct io_uring_params *p = &config->p;
+	struct io_uring_params_ext __user *ext_user;
 	int ret;
 
+	ext_user = u64_to_user_ptr(config->p.params_ext);
+	if (ext_user && copy_from_user(&config->ext, ext_user, sizeof(config->ext)))
+		return -EFAULT;
+
 	ret = io_uring_sanitise_params(p);
 	if (ret)
 		return ret;
@@ -3592,6 +3597,22 @@ static int io_prepare_config(struct io_ctx_config *config)
 	return 0;
 }
 
+static int io_ctx_init_mem_region(struct io_ring_ctx *ctx,
+				  struct io_ctx_config *config)
+{
+	struct io_uring_params_ext *e = &config->ext;
+	struct io_uring_mem_region_reg __user *mr_user;
+	struct io_uring_mem_region_reg mr;
+
+	mr_user = u64_to_user_ptr(e->mem_region);
+	if (!mr_user)
+		return 0;
+
+	if (copy_from_user(&mr, mr_user, sizeof(mr)))
+		return -EFAULT;
+	return io_create_mem_region(ctx, &mr);
+}
+
 static __cold int io_uring_create(struct io_ctx_config *config)
 {
 	struct io_uring_params *p = &config->p;
@@ -3661,10 +3682,15 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	mmgrab(current->mm);
 	ctx->mm_account = current->mm;
 
+	ret = io_ctx_init_mem_region(ctx, config);
+	if (ret)
+		goto err;
+
 	ret = io_allocate_scq_urings(ctx, config);
 	if (ret)
 		goto err;
 
+
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 20f6ca4696c1..c883017b11d3 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -30,6 +30,7 @@ struct io_scq_dim {
 
 struct io_ctx_config {
 	struct io_uring_params p;
+	struct io_uring_params_ext ext;
 	struct io_scq_dim dims;
 	struct io_uring_params __user *uptr;
 };
diff --git a/io_uring/register.c b/io_uring/register.c
index 425529a30dd9..4affabc416aa 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -414,6 +414,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		return -EFAULT;
 	if (p.flags & ~RESIZE_FLAGS)
 		return -EINVAL;
+	if (p.params_ext)
+		return -EINVAL;
 
 	/* properties that are always inherited */
 	p.flags |= (ctx->flags & COPY_FLAGS);
-- 
2.49.0


