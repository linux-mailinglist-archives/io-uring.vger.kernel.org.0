Return-Path: <io-uring+bounces-8128-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED9C7AC8A0C
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 10:37:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 493A89E145A
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 08:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F9D1FF603;
	Fri, 30 May 2025 08:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jwd3FtOK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E472192EC
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 08:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748594235; cv=none; b=aOK0JI3QAzgVq16gTP7NwZEsJC9yUHhwPPqcupYJVdzmI9Ewta7adbLKw6H6BLcTazRj8lfda/bcH4ygcUt4bVgHmVDLIBjZ/w4TJ39Nm5wFlcNIPHX1XUnZVOIzPQhZO3MKouzKBnE5ZoBDOvKMEvDHY+Z3Ti41bAFcWfNVtmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748594235; c=relaxed/simple;
	bh=KFmUiDwv1oas9hDmX1X4FGj8wDt8TSu+yzyTW5ZS8cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFjCIoX0+9yaJcSY+hZAuWKmaBFbcVy6IHXj9Gaibnm+rkQwjiirgIJ8cQWKnwJlyb18t99D0Ay0SQrDA7AS33/4tp8kMIzuFgbUfdGGY1Zx8mzDWMjoyOzUCJKMANZiXaZAvQ+IoCr9Oo4X/P4dRrVC0RtVtkYHPoUf7fiL1t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jwd3FtOK; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-adb2bd27c7bso210691166b.2
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 01:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748594231; x=1749199031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CMXaliXIGfznwaI4qWw4zet4ISun/uo/VMWirQX3VYE=;
        b=jwd3FtOK1scPBpThWFdb5/YsWIQT5n8iIdKPQ28Qyk1gLLAzGFzkCMw/WSNNnjSEsX
         NPe7YtkE8iMY+5JqTU/Z2z9BpdVpIdS9JT7iZUFbMlVTs+D8UipkKm9YBZ72A/tkSvk9
         7pBBvGFoqXsGgGlZN6yKCMxocitdJPdirMtszQobLQ010121pSwTR7+P8bkXnx7BWQRe
         gQakQp4bxorPzqSH8GP6HTK1hvSx0h1pbBWLDMKNS5yFwRL2yxolbnA0NmqISht/3VNM
         boF+3m1TeGLXhhAlZxaDQ4ZXMI4sjy+gSJVRQJV3nUK2aHUWkEqlfxBRpxJcSwf3mSu3
         rFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748594231; x=1749199031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CMXaliXIGfznwaI4qWw4zet4ISun/uo/VMWirQX3VYE=;
        b=NRDvJaK7p+9qCJWDjvGTlX/BmSPs0TNaEvVxibH0NEmMxro1M7wXOFD0osBlRbWZTT
         VqYfdz73ZUv2R8CMcLIjEv5zPvYzdwwEmKXrTb65IKPfYcsEKYZqq7W2J+E/YgQ6VVTO
         MmEmde19Ns1i+eG/KjtrV+hnYf5PODXkqrxq3+ruwShBEz/1ABxnGHw9IA2CpugOYd9d
         H2c8ULK1YhasOmRDsS57Rsj5h6LLgv0R9uzmK8Wc4Ujc2+xNurPPtE/gzaK5pbKFNI6r
         2LKL9LJ+04ubwb/Oqr9nhKAVF4E+um3Dfc2qTQmNiQbijVlWF90H3+/7/a7xt0gLMysF
         regw==
X-Gm-Message-State: AOJu0Yw4JrP/ynB9Vq5KEsOGCJuoiOKiw1yS/+nU+bmevdWCW4SCLYHa
	qRbQ8Xp9LCsbK9I43VaRQQGvW5luoekEJWbX+ojbzlVUBU4f+/t0ERDcBpXgVg==
X-Gm-Gg: ASbGncuNqf9/P3c8KUKU9MH+cjVpJMtLYSa/4m9o60BEynCUVOdDFYi0p7GjDOYYlBm
	cu1tjt4UxkS04E37+VfrDAExby9xjHmWeikpRy56/QqC3LTQ2AxQaH12RLTsDWApyR/bQrCc9M9
	g5Nv6cCP8jIY5CkLGkC0NNE1bFl8Bxyj3RTkYleLD2vpcGD4Zb7O1DN/dxA0AYpng94Il/Htzid
	8sZvyEl21oWjgcsGIUKX+eBKoUVHCTiMifdlD/kPaIq9ddIap9REn1CvZAApDKLrGQe8S3c9I7O
	fkbYg2ukHazc8Tjr1J63lXD+s+QN/HHkdDA=
X-Google-Smtp-Source: AGHT+IGQtuwrppjCRkOU6DO3H19YgYuDTzpuhzlNdcGVf771gbG5wGOEdolqJ6QVr72D5x6UdpJ8jg==
X-Received: by 2002:a17:907:3f10:b0:ac2:a50a:51ad with SMTP id a640c23a62f3a-adb3228cfc0mr227044966b.14.1748594231236;
        Fri, 30 May 2025 01:37:11 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:65cd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad696d1sm288126566b.161.2025.05.30.01.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 01:37:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 4/6] io_uring/mock: allow to choose FMODE_NOWAIT
Date: Fri, 30 May 2025 09:38:09 +0100
Message-ID: <dd5cba9ea4a782b5f891f7c8e9b6ca7c2f2970b3.1748594274.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748594274.git.asml.silence@gmail.com>
References: <cover.1748594274.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an option to choose whether the file supports FMODE_NOWAIT, that
changes the execution path io_uring request takes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/mock_file.c | 8 +++++++-
 io_uring/mock_file.h | 5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index f606e1d03113..63c7d2f07f11 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -131,6 +131,8 @@ static const struct file_operations io_mock_fops = {
 	.llseek		= io_mock_llseek,
 };
 
+#define IO_VALID_CREATE_FLAGS (IORING_MOCK_CREATE_F_SUPPORT_NOWAIT)
+
 static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	const struct io_uring_sqe *sqe = cmd->sqe;
@@ -151,7 +153,9 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 	memset(&mc, 0, sizeof(mc));
 	if (copy_from_user(&mc, uarg, uarg_size))
 		return -EFAULT;
-	if (!mem_is_zero(mc.__resv, sizeof(mc.__resv)) || mc.flags)
+	if (!mem_is_zero(mc.__resv, sizeof(mc.__resv)))
+		return -EINVAL;
+	if (mc.flags & ~IO_VALID_CREATE_FLAGS)
 		return -EINVAL;
 	if (mc.file_size > SZ_1G)
 		return -EINVAL;
@@ -174,6 +178,8 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 	file->f_mode |= FMODE_READ | FMODE_CAN_READ |
 			FMODE_WRITE | FMODE_CAN_WRITE |
 			FMODE_LSEEK;
+	if (mc.flags & IORING_MOCK_CREATE_F_SUPPORT_NOWAIT)
+		file->f_mode |= FMODE_NOWAIT;
 
 	mc.out_fd = fd;
 	if (copy_to_user(uarg, &mc, uarg_size)) {
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
index dc6cc343410d..b2b669f7621f 100644
--- a/io_uring/mock_file.h
+++ b/io_uring/mock_file.h
@@ -6,6 +6,7 @@
 enum {
 	IORING_MOCK_FEAT_CMD_COPY,
 	IORING_MOCK_FEAT_RW_ZERO,
+	IORING_MOCK_FEAT_RW_NOWAIT,
 
 	IORING_MOCK_FEAT_END,
 };
@@ -15,6 +16,10 @@ struct io_uring_mock_probe {
 	__u64		__resv[9];
 };
 
+enum {
+	IORING_MOCK_CREATE_F_SUPPORT_NOWAIT			= 1,
+};
+
 struct io_uring_mock_create {
 	__u32		out_fd;
 	__u32		flags;
-- 
2.49.0


