Return-Path: <io-uring+bounces-10416-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E6010C3CAD3
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:02:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6B4DC34A6E9
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350E7334366;
	Thu,  6 Nov 2025 17:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OXCcNWyy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C2B25A633
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448532; cv=none; b=DFBoMMk15EOxdClWZ7o31hmow9jUdXABb9CjuKfrNqybpKo0Z2czVposqnEB7IDlmaZXGYFh16IeXbn3QTJuNEZwjxd9WVZbLw0INwxBojV2/251kLCPMrV9oVxcKxxwLLLj3a5Qgi74FXevrWyTgdSOy3yxnK8bTPkpqDq3liU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448532; c=relaxed/simple;
	bh=H69rqQIy1fQeFDuBEXfHkWEiF2aeM8uAHvcSp1Gi7+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTPlkW2YWQGCIk/fC7eOe/gw4or7+c8Eda12jMeWpHLaiPnP46kV5tqnJ0D34Mmq/BxRZtZI1D4izINp7wii7rBMI+NQ9Fa0kZYqMQ+YoRatgjXjKEjp/cRsVOPfWT3kW8KZghpfJuurSvSxQNE/QyLAUo1Ccpp8bLkfE2lsLdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OXCcNWyy; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-429ce7e79f8so908829f8f.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448528; x=1763053328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+OzFaf7sFq0BFf4aHO8UWCFZyELXPk7cYjYvjoIkoo=;
        b=OXCcNWyyHUgfcdG6uKw+9/uA3eSa4OVC7aYEYgO3rS76/+AQp1MQErBOnPJrNy9bs6
         t3kEz5seqqkW22OaG0IZau1a8V/FGeefA3f7RcjaFlxktQz3yFz+CxBMVZPR5R4gYCbc
         qcKU1HH4X9Do56eEiYr9Sc6erse38bZDCMmAPHrgb4C75Bw9p+JtTAKP3L99QdoXwWVU
         bbtOV7A8b0Y6kn8jN0vi947pOJVwXxctpMrbdMYw2WZnWBD/5vTtvD8ITxZew6NXbp5j
         HYRBysFf9B7Q12NsC2TeQmUa+9pUc6do+vjBMRWwVCb+nEkbEVFfjFe9hUH0ywNf8DbU
         D2QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448528; x=1763053328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+OzFaf7sFq0BFf4aHO8UWCFZyELXPk7cYjYvjoIkoo=;
        b=nWMDcKAvcPIVBWLHVKwFZnD7iv/ZhF/5hayouJ56bGmfcEBrry8FVsmryAc2ZYQDuq
         LbQawtNfSYwhNq1ASk4Gp8KWwXIQxb4h1Q1nxGEtmz+0CZrjwMT7hNLNig+qof94ud9+
         uS14KJFj5VIFTPVj95QGuPy/ko18d1hqmn3uJ8ila6Zi3fcPhIhGsz9/6JNDsewSea+N
         NBctFj+EYpJIzuC1AmmfF9/CWSGf42vQebpTe/rPOPrUqU92qWYoIzU7sp1Rzm4fQC2D
         TgBu93k8W29JKpOBBkTxRqeyS0Ye3fOJ0zVTIeK65tql0LijzXoAESp5PAFoibsB7oPX
         JD1g==
X-Gm-Message-State: AOJu0YwfkcnLnwWAA732KEXqv8OBKluUmUBHKRynaVcRnfu+a0ZY0sAy
	k/EFF9t7NxK2IgVboSDfYzNcmY13LN08bAO1Qh4yyXBxnYskWq7mTMsHkLrJmQ==
X-Gm-Gg: ASbGncsr4ys41jS3yCQirvBlQ00ila+rguWj8jNknD/i4WHeOGqvZGqBz7JSR1fe4ej
	zvY37/+QrPv1eoofoiBTsbRmBGoTGFTpwdKxAfEW6bWSdpUsTIVgHPYNRBogi5Hnt3bK5Ezk+t+
	5hMyYpU8qcLl4ktHLVGVQD/DIKLJY27xAtMP2CGDoTARq5uR3NaenZkKSmJxS/39PiWfhnnpPIM
	JXoklBkdqfsURyLS7NNvytVTtJ5RmIx5arYozj+voCEvJu5udGInhE4auufOvj118pK7ZiQpzC4
	bHBLefe/r/6XjzfF97F1PyR5qhCi2RFRFwh/1WBnVBKAwXmaqLcri+1LlSAJhPuelk0rXtQXOqk
	ZhbBOuddVm+rAoO5axQiobwhMEXJLZOi3eFIUum2uJnmRlxU62WtELw9oeWS8PIi3KCD+dvI/53
	MP8qM=
X-Google-Smtp-Source: AGHT+IFf+vjRmJwb7y1IrNWHDv8h1DqzpMWEE+R7lwgmZDbeR3wkqORMCk9HjVR8LIVo6SLcKvt7ZA==
X-Received: by 2002:a05:6000:2c10:b0:425:73c9:7159 with SMTP id ffacd0b85a97d-429e3305cffmr7106327f8f.33.1762448528065;
        Thu, 06 Nov 2025 09:02:08 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 08/16] io_uring: pre-calculate scq offsets
Date: Thu,  6 Nov 2025 17:01:47 +0000
Message-ID: <c82746ce37dd790fdfe823602f05f1cc807ae94b.1762447538.git.asml.silence@gmail.com>
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

Move ring size / offset calculations into io_prepare_config(). It
simplifies misconfiguration handling, keeps it local, allows to move
p->sq_off.array calculation closer to the rest of p->sq_off init.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 28 ++++++++++++++--------------
 io_uring/io_uring.h |  1 +
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8166ea9140f8..aeb9555bd258 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3362,23 +3362,20 @@ bool io_is_uring_fops(struct file *file)
 }
 
 static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
-					 struct io_uring_params *p)
+					 struct io_ctx_config *config)
 {
+	struct io_uring_params *p = &config->p;
+	struct io_scq_dim *dims = &config->dims;
 	struct io_uring_region_desc rd;
 	struct io_rings *rings;
-	struct io_scq_dim dims;
 	int ret;
 
 	/* make sure these are sane, as we already accounted them */
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
 
-	ret = rings_size(ctx->flags, p->sq_entries, p->cq_entries, &dims);
-	if (ret)
-		return ret;
-
 	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(dims.cq_comp_size);
+	rd.size = PAGE_ALIGN(dims->cq_comp_size);
 	if (ctx->flags & IORING_SETUP_NO_MMAP) {
 		rd.user_addr = p->cq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
@@ -3387,12 +3384,11 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	if (ret)
 		return ret;
 	ctx->rings = rings = io_region_get_ptr(&ctx->ring_region);
-
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		ctx->sq_array = (u32 *)((char *)rings + dims.sq_array_offset);
+		ctx->sq_array = (u32 *)((char *)rings + dims->sq_array_offset);
 
 	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(dims.sq_size);
+	rd.size = PAGE_ALIGN(dims->sq_size);
 	if (ctx->flags & IORING_SETUP_NO_MMAP) {
 		rd.user_addr = p->sq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
@@ -3569,6 +3565,13 @@ static int io_prepare_config(struct io_ctx_config *config)
 	if (ret)
 		return ret;
 
+	ret = rings_size(p->flags, p->sq_entries, p->cq_entries, &config->dims);
+	if (ret)
+		return ret;
+
+	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
+		p->sq_off.array = config->dims.sq_array_offset;
+
 	return 0;
 }
 
@@ -3641,13 +3644,10 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	mmgrab(current->mm);
 	ctx->mm_account = current->mm;
 
-	ret = io_allocate_scq_urings(ctx, p);
+	ret = io_allocate_scq_urings(ctx, config);
 	if (ret)
 		goto err;
 
-	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
-		p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
-
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 29464be9733c..d1c2c70720f1 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -27,6 +27,7 @@ struct io_scq_dim {
 
 struct io_ctx_config {
 	struct io_uring_params p;
+	struct io_scq_dim dims;
 	struct io_uring_params __user *uptr;
 };
 
-- 
2.49.0


