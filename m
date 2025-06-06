Return-Path: <io-uring+bounces-8250-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16CAFAD039C
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 15:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FE053B23C1
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 13:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44938289E01;
	Fri,  6 Jun 2025 13:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HI7e2Mbd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D4128937F;
	Fri,  6 Jun 2025 13:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749218210; cv=none; b=fxD+MPD6kenBIlVIU7Zs82rLxrHhgbdnMDG15Vyne1DPEkPaSfPMTlUGvlzEzATaBDzK66E52nO+LtxeCaNP781biFbyPF7Jhwyx2k+FeeSZrlqtlwYLn4PFYN8QlMbYpxnMkt1DAIysm/81KWZKhq9r4eeE6+2/oThr3SPhxBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749218210; c=relaxed/simple;
	bh=5VMdPBhIyqMD1MmtIpltOSTRWEVW47+1088cj4tJ8pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kc7sPf/uyI2xCNg4QDnZ7W2UgU3rHrIiHmSTYIJLem3K4ZUdv7NfLQXVT3iVsKXi0qC5qwO+QnBG0k7/keIhtCBJS7SoMBrbvzfl5M+eMZFIDxIwskcJZPG8chzWkpYBdL4ujhdkqVji+rWoKolKBH6Lzr1smY7cC1fV81x7/Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HI7e2Mbd; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-60497d07279so3980635a12.3;
        Fri, 06 Jun 2025 06:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749218206; x=1749823006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kq02ZXnReuZLLwrZBHg+lNbHT6a4SK/xczUYFbR7a/w=;
        b=HI7e2Mbd4La1/kwJxp8sK9qRadhKdYQmaSUSsgucjwpsdp8Q/NmYuB+GYYZgvefCWK
         xpgTeT1p/IHr8ahlbYVvpn8c+1OofvwvnFHX2VU299fOUKYDTK6qLac+sLrwkVHsize7
         EfP8U7O7gtlVH0b4SRMbffN3rIWhFsL+tkutV5uetWWLVu1cgSi561YfMkXzXtPYQVwq
         1pMJM0qnH4gBDfN036E4zMRpJZBgEl1E76nuTsiRUR7Jn4Hq8hYfyEk4Fs+7TJCwNOEy
         7ZVmub4l9NfV2RzO/3dgft+sqJZQGaYRMGILxHkY36zISAx8nEcleRmZPU9xx8Gv2HiM
         MvZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749218206; x=1749823006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kq02ZXnReuZLLwrZBHg+lNbHT6a4SK/xczUYFbR7a/w=;
        b=FjtxfRkh2nqPYjM3hkEv5gJsDMyo1uVQiTf1BsN5qhFrirwgox9RyW+gVDUZ7+9h7i
         eqYV2b+dRUfVGLM0bneeNszmnIoKEKP6DcauYWBcIWQw9b2pUbucWZItFeUWC4nSXuyZ
         cTzr/7jfNuo7GuWk/lXcE/ODDlFNC+BAT5FvX0seUPOSUY6ugLNTEIjw7knxkETfcYK7
         zBg++vmzGAHsGMN09p8f0isU/KAxj8E5D6sgVlDrt+Vk3qjxOD4n9bapqreciRZD78H8
         0YqfQN1whFC4fgpMGNSKQLPsoNHW1M51RwtokZy09ZvgrTvdmwLN/pJybHVthhX4kkiV
         HkuA==
X-Forwarded-Encrypted: i=1; AJvYcCWkS7JlAhmIS1gmC5QBElyFBPl+m20juJqew6J0pfzCULV1y4sG9qQGa1U/AQ22aFpfe14=@vger.kernel.org, AJvYcCX/1i7AEv32LCx6SvPVF9qUn6W+tm0pIAO7i3eQQlV7Jk/j2FJMmQTBjLiD25kacmii/sCOI9FxE+nVnzV4@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+EZlW9PA8qQTSxt23cTLM5r5JQg8IaDAwqYMy+Ctj52auakyJ
	urtBsy7eMZTpXY+Ovb0LCyDQvQev9fpR/rc5GvOapcIavpdXptdBitQ4UKa5vQ==
X-Gm-Gg: ASbGncuY5dI0lIKWTt0H+tzsOrk8lkIdBItbd10aHJMA+b1pN8CdTa9nhwBTaWYYUqT
	9LwgC6BgLmC+p+H5eBGtwpr5vsF9WVSDyFiqAFNHNobB9hlqb1dDV0f+Ek75jbLtIt/hwlyAmVS
	KdFibufv1LaFpVtIoLg8cBYL75C1ysI7mt2Md+lpgf2sF8fXt7W+SE8vxkZA2HtjC9OMPh5ezKp
	MAUp8YA9xiXmEnB3Eh5dRmPzONRlqR/SXFsCuQYinTGIolHEFKzyOCYvv5R2lv7fG8poCWuSUeB
	ahLZFiUj8PCeSEE/k4Aq/66JWp0ON084gzk=
X-Google-Smtp-Source: AGHT+IGxiOsNefek1Bu4XB/BKFZspesjby3DK69VYtx8UdcH82CyMF+V+9+JJsat6eaOhAdeWfxkzQ==
X-Received: by 2002:a17:907:3c88:b0:ad8:96d2:f41 with SMTP id a640c23a62f3a-ade1a9229f0mr321862066b.33.1749218206122;
        Fri, 06 Jun 2025 06:56:46 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade1dc379f6sm118026766b.110.2025.06.06.06.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 06:56:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 3/5] io_uring/bpf: implement struct_ops registration
Date: Fri,  6 Jun 2025 14:58:00 +0100
Message-ID: <f43e5d4e5e1797312ef3ee7986f4447bddac1d3c.1749214572.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749214572.git.asml.silence@gmail.com>
References: <cover.1749214572.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add ring_fd to the struct_ops and implement [un]registration.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/bpf.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++-
 io_uring/bpf.h |  3 +++
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/io_uring/bpf.c b/io_uring/bpf.c
index 3096c54e4fb3..0f82acf09959 100644
--- a/io_uring/bpf.c
+++ b/io_uring/bpf.c
@@ -3,6 +3,8 @@
 #include "bpf.h"
 #include "register.h"
 
+DEFINE_MUTEX(io_bpf_ctrl_mutex);
+
 static struct io_uring_ops io_bpf_ops_stubs = {
 };
 
@@ -50,20 +52,83 @@ static int bpf_io_init_member(const struct btf_type *t,
 			       const struct btf_member *member,
 			       void *kdata, const void *udata)
 {
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+	const struct io_uring_ops *uops = udata;
+	struct io_uring_ops *ops = kdata;
+
+	switch (moff) {
+	case offsetof(struct io_uring_ops, ring_fd):
+		ops->ring_fd = uops->ring_fd;
+		return 1;
+	}
+	return 0;
+}
+
+static int io_register_bpf_ops(struct io_ring_ctx *ctx, struct io_uring_ops *ops)
+{
+	if (ctx->bpf_ops)
+		return -EBUSY;
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		return -EOPNOTSUPP;
+
+	percpu_ref_get(&ctx->refs);
+	ops->ctx = ctx;
+	ctx->bpf_ops = ops;
 	return 0;
 }
 
 static int bpf_io_reg(void *kdata, struct bpf_link *link)
 {
-	return -EOPNOTSUPP;
+	struct io_uring_ops *ops = kdata;
+	struct io_ring_ctx *ctx;
+	struct file *file;
+	int ret;
+
+	file = io_uring_register_get_file(ops->ring_fd, false);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	ctx = file->private_data;
+	scoped_guard(mutex, &ctx->uring_lock)
+		ret = io_register_bpf_ops(ctx, ops);
+
+	fput(file);
+	return ret;
 }
 
 static void bpf_io_unreg(void *kdata, struct bpf_link *link)
 {
+	struct io_uring_ops *ops = kdata;
+	struct io_ring_ctx *ctx;
+
+	guard(mutex)(&io_bpf_ctrl_mutex);
+
+	ctx = ops->ctx;
+	ops->ctx = NULL;
+
+	if (ctx) {
+		scoped_guard(mutex, &ctx->uring_lock) {
+			if (ctx->bpf_ops == ops)
+				ctx->bpf_ops = NULL;
+		}
+		percpu_ref_put(&ctx->refs);
+	}
 }
 
 void io_unregister_bpf_ops(struct io_ring_ctx *ctx)
 {
+	struct io_uring_ops *ops;
+
+	guard(mutex)(&io_bpf_ctrl_mutex);
+	guard(mutex)(&ctx->uring_lock);
+
+	ops = ctx->bpf_ops;
+	ctx->bpf_ops = NULL;
+
+	if (ops && ops->ctx) {
+		percpu_ref_put(&ctx->refs);
+		ops->ctx = NULL;
+	}
 }
 
 static struct bpf_struct_ops bpf_io_uring_ops = {
diff --git a/io_uring/bpf.h b/io_uring/bpf.h
index a61c489d306b..4b147540d006 100644
--- a/io_uring/bpf.h
+++ b/io_uring/bpf.h
@@ -8,6 +8,9 @@
 #include "io_uring.h"
 
 struct io_uring_ops {
+	__u32 ring_fd;
+
+	struct io_ring_ctx *ctx;
 };
 
 static inline bool io_bpf_attached(struct io_ring_ctx *ctx)
-- 
2.49.0


