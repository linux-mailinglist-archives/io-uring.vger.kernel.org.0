Return-Path: <io-uring+bounces-8145-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B39ECAC8F6B
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:13:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2378B4E4BF1
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6241223504C;
	Fri, 30 May 2025 12:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K+II89WF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E34322CBE4
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 12:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748609464; cv=none; b=TmZR9ZiVBggyLqmmeb83jDcxVj0GuirTOr06WMZpaONLQ/77tvR8CRJsCe3dlasbi6/Jv9JznnHH1HYfOAQdc/ezPrY/tNwFqXQn41fg3AqeQT72PEGmWKiACf7CaHnt+Jkgrq7nfuo09lt7JAxPeHdaPGXRO+v2B3xqnpq5E9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748609464; c=relaxed/simple;
	bh=++9emhHmClvi6aqNwvPA9fEJ+SQrK1THGA1GG1wpjvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUk25Nxa+6dZRCaE4EidR65ecVS82RU4p1F069OFx3kzBo1gb29pK68LYdeWq/Lq+ZGB/3PvPbZo0yXVZH26LAGTALguBhTbJjXxywCZ71KzPA/QDZ3UOHiPivlSPXxeAsF8L1hEESsygJrXE+LSuIr1Y4xN9SrMrFaTglkBrJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K+II89WF; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ad89c32a7b5so302504066b.2
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 05:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748609460; x=1749214260; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GhEpTrOqfK64T+aGeqbEIvkmKe9qWIenjBF9t3NFotc=;
        b=K+II89WF5q7UmIDex18QKuKGS4zObqs7Jpkl2eVxPcpBMYCWC3kub+HP/jOe5DEXcE
         DvHF2IORqU9nlrv0GikbdBltyEqabzU2jY26A5FoZeZV8r4UAazTaEgs9SO4LHwy2x0+
         IHWv+wg1jGZWDOPXT+69p6QICqJzbZQTLNCg9jjzmNgU2SRJCKlq04tAvqkXjIv0uvRP
         roW/R7mR0+bd0U2saOnB7ZXAf5dqYeH3EK4uIpf4B+ECdMlfwZ5VTbWy7TuU7yh758Je
         sK+4o6ZpwmuerSmk+zlEEGFJSLZagwiBG5zYcSstBUmbluhD4r+XDClp/dk/wHl+peoS
         XmKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748609460; x=1749214260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GhEpTrOqfK64T+aGeqbEIvkmKe9qWIenjBF9t3NFotc=;
        b=ZSVC4wIhOaKvLpxQgEzo0Rc2f2zOzQVkiDa5TSNhQIwe8L7pZXIitb4VyjqAUE4RcK
         BCl5gA5Elsl5ug5YS2jVkOJQY21HxnzaeDeEyw37UZeBjHeohUNuNtal7g0wwOgvGbf1
         ngaqMFex3TFPYWzRxPO8OG0sQFmhaoEIRxReQjtoKDaglMI5p69SsNxn7IbP7RRSsqma
         WZeKW6VimLD80lWau83GW7+ZS/3pAGSIfsNI8ANZI+ibVqjZ+UyDBHO5RjyplQtj0mcg
         +/D4dE0Yhr49U/jdckKxomW/w5izAIowN4zIGjrQV1A8N+Dt3eE/lmwSJecAnoEhS1FC
         UjdA==
X-Gm-Message-State: AOJu0YxljCIZBmkf3+dVf/iu0cJ+pIDtEOq4pv5Wi5d24w6t8Wi9l0GA
	PGWav0lF2eAD4/NwwSoagzBeQoZvLLG6y5KNarsUu7jfFgABsrahsRr61gLpKQ==
X-Gm-Gg: ASbGncsyZf3FuaWswn4g4OYxfWoUGccb3VPLYZFDU7XM4z/zgtLXnzPCrLgC7xBoSZ/
	6+Ln7f23hCR3Pri6SPYXGBckUhiv2VVIlJXURYOS6MezUVMhN9fhR2DX6SEPPIp1c3Ze3tnz1zw
	Pm8igIg5Ual9zL9+LAzFmsia9nP1z7vZ3p31IIPsDLSw+r+hGD9EvkCR3xhqrb0Go6lvvvi+5ub
	0ZT0yrRDwhlbtV+VIxDhXmk5EKCYg2Zzf8Y3QDg/xl80ZfEvW4ZSUEqi8wkYe8LoRBaMbxhAIFk
	6WKKpkkyIUDXuSi7H7A2OzJg0xhENiZc+/M=
X-Google-Smtp-Source: AGHT+IGobE/g9DDF5x9Dut9B4Z2kcZc/dSe2YIqsVO4RN9V9wX+GqPsPocoNZ6tLQBnZxKCSfH6K/A==
X-Received: by 2002:a17:907:d87:b0:ad8:a50c:f6cb with SMTP id a640c23a62f3a-adb322fd1d0mr280203566b.26.1748609460434;
        Fri, 30 May 2025 05:51:00 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad39420sm323234266b.136.2025.05.30.05.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:50:59 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 4/6] io_uring/mock: allow to choose FMODE_NOWAIT
Date: Fri, 30 May 2025 13:52:01 +0100
Message-ID: <21c4617210da74bed1a9a24223635c4f6aa8c36b.1748609413.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748609413.git.asml.silence@gmail.com>
References: <cover.1748609413.git.asml.silence@gmail.com>
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
index 7dd87d0b83b2..517d75fac888 100644
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


