Return-Path: <io-uring+bounces-10582-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ED19C5706C
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:56:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B58C3AC7CD
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04296337BA6;
	Thu, 13 Nov 2025 10:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkKTLZTQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0900F333740
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763030947; cv=none; b=kJU41MsC1O16xDO5gJTYuN5NIhfZiMKyWfTh3VN6sxR4L7GTfVpGgFVBDIqRYQarXOyxI2JiBIr26hohuIb2SuqEZ1jMegoAwsC3Jg6WF3cYE5jgSf7KXvBHntE22rmfFobwdW4SPeyurSg7W40ylKlsuDEoLYyubaowEi10cyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763030947; c=relaxed/simple;
	bh=7ajrRnP9jp91xt1fsl9a5c8fxH20Xzr+Y9tJ5b/cysQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/NuT606Rw9Y5qyH3H+5fBKrCul8U2QO1H0WN4bNpH7EdRNt+YA/R4dZWtaCS/pnYS4BIxutytp0QcWwPIA7nwHQ9IFtY7KjF2+no62PbiulaEZdDsI0sWX52bkKMg448pM1u++tFe3EVvtATzfmwiFdqunCye3SPk92b+vInNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NkKTLZTQ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4711810948aso4513165e9.2
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 02:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763030943; x=1763635743; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GKBg/6778c3lQuYKXvT4FUUbI+ReoVlwNqm1rOcYP08=;
        b=NkKTLZTQqnvtA6RJU7AkNnRkCLDIjYKbH+BLh8GncwKtdxnFfG7WARq/sKTn7BLak/
         HtzQVTabmCW2ta8scZ+et5L69vqVMBU+vYXmOCUs0Akg17ijwFRCEePemweG3CDLt5MB
         0SmyKbjvx2MJbdjFxfp7wgmwcfdnZvF2CBnCdPKe2ZzlsFRtgZVWlas8ttehTtnJEV3s
         jYOSfkdiNmhIQJbhXo9kKk2+HlFzfwFcWps6mTpeoJK8wuThp4jmY/mLKoPu68FFswCs
         TINWUWvI9r55rOSgH7dgxQxp2gsJLFC2jtK+b51dvecvZNwsToKg66crcrasDy2TgSVA
         QN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763030943; x=1763635743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GKBg/6778c3lQuYKXvT4FUUbI+ReoVlwNqm1rOcYP08=;
        b=CHK6A2IX68yzz7dd/TcAYbkL/kI+UVgjHNgM1qRLW2oKDqsgu1Htwwce2/sgG0Lknk
         p8bP/oMbH2jUB85zzzsO9fp3dr1yKtmvT3fFGQPxAPpcNZpVoil0xlvWR8PCpq7YAGml
         Gct2n02Ma93dFjg/ytdjTMxTbyjrWvbV4xC4/R7a85oNeSF3pQ8f4/GSrm3OuiPcAVVm
         YT5cEzlclbRQATyQSaLlVcwbiZa2oDo+bQ9EJq6aivB5bUMU8QnnzyYdtO5Aadk4rd7g
         i9mNizwW5DYKrgyytqQQIYl51zgN8aZFdK/JFsDfD9ZcZN6bU09zqwV4vzIa0IoRlCr4
         lNbA==
X-Gm-Message-State: AOJu0YzW3fpKvuMjCslUu79g2UBeyd6QH6HFIEApjvr1lGqTM0E/MnVS
	hMPFm2cQnct8LwX5SnBSW2NbkUedGlKQT1Tyq5RbB+Cv7+8FDFV/N9GVMaL8cw==
X-Gm-Gg: ASbGncs3fci2D8hG2n01lvcBrQS2PKZUkPgkXHzhl6LQeqwQvgzCJAXZLmZeSGPCYZZ
	UNqYHcd2Nt4ub/TEuGiQBgChkquuCMU1V43UB0hFk/tOGxE5mZryALRptPIltnDFDBr/BW7vh2W
	j99yVN9TRk3opjHur/Evfvxg/b8MUkFtp03BsU5MQFSAaB9aot3vF/p1Kxj1MlZe2HQso8W4OIZ
	nGV0oApdFlvhLLeRGYWGh+1U5IpuQdqrpCKVrkYN7tzw+PjQe0wIpQRsS8vfYvYKcsgJBzMQowT
	zq3DWRtUsSXyOqsAU6O7chOn4Rzh5wh5pAbwyja1vZFUvLRttshc/KvWrD28iQ4gkhNDSL/8NMA
	jk8ImZBrgoGHy2sBIklPWTFQm/M1ZbxYbTVqG+4W5+CTY9YWxSxCcCSgaoT7sY3x80G6leA==
X-Google-Smtp-Source: AGHT+IF/makQ9iufro4Cp/VgWc9OUhnLPS8YdA6i5tgXLgdauxyCwc2GewudHbGbR+ChHno63ZFEnw==
X-Received: by 2002:a05:600c:c4a1:b0:477:63b5:6f3a with SMTP id 5b1f17b1804b1-477870b2d84mr52351295e9.27.1763030942745;
        Thu, 13 Nov 2025 02:49:02 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e442c2sm88850945e9.7.2025.11.13.02.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:49:02 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring/query: introduce zcrx query
Date: Thu, 13 Nov 2025 10:48:57 +0000
Message-ID: <83766bd424eec657a293f93150a919b084565ef8.1763030298.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763030298.git.asml.silence@gmail.com>
References: <cover.1763030298.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new query type IO_URING_QUERY_ZCRX returning the user some basic
information about the interface, which includes allowed flags for areas
and registration and supported IORING_REGISTER_ZCRX_CTRL subcodes.

There is also a chicken-egg problem with user provided refill queue
memory, where offsets and size information is returned after
registration, but to properly allocate memory you need to know it
beforehand, which is why the userspace currently has to guess the RQ
headers size and severely overestimates it. Return the size information.
It's split into "size" and "alignment" fields because for default
placement modes the user is interested in the aligned size, however if
it gets support for more flexible placement, it'll need to only know the
actual header size.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring/query.h | 16 ++++++++++++++++
 io_uring/query.c                    | 19 +++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/uapi/linux/io_uring/query.h b/include/uapi/linux/io_uring/query.h
index 3539ccbfd064..fc0cb1580e47 100644
--- a/include/uapi/linux/io_uring/query.h
+++ b/include/uapi/linux/io_uring/query.h
@@ -18,6 +18,7 @@ struct io_uring_query_hdr {
 
 enum {
 	IO_URING_QUERY_OPCODES			= 0,
+	IO_URING_QUERY_ZCRX			= 1,
 
 	__IO_URING_QUERY_MAX,
 };
@@ -41,4 +42,19 @@ struct io_uring_query_opcode {
 	__u32	__pad;
 };
 
+struct io_uring_query_zcrx {
+	/* Bitmask of supported ZCRX_REG_* flags, */
+	__u64 register_flags;
+	/* Bitmask of all supported IORING_ZCRX_AREA_* flags */
+	__u64 area_flags;
+	/* The number of supported ZCRX_CTRL_* opcodes */
+	__u32 nr_ctrl_opcodes;
+	__u32 __resv1;
+	/* The refill ring header size */
+	__u32 rq_hdr_size;
+	/* The alignment for the header */
+	__u32 rq_hdr_alignment;
+	__u64 __resv2;
+};
+
 #endif
diff --git a/io_uring/query.c b/io_uring/query.c
index e1435cdc2665..6f9fa5153903 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -4,9 +4,11 @@
 
 #include "query.h"
 #include "io_uring.h"
+#include "zcrx.h"
 
 union io_query_data {
 	struct io_uring_query_opcode opcodes;
+	struct io_uring_query_zcrx zcrx;
 };
 
 #define IO_MAX_QUERY_SIZE		sizeof(union io_query_data)
@@ -27,6 +29,20 @@ static ssize_t io_query_ops(union io_query_data *data)
 	return sizeof(*e);
 }
 
+static ssize_t io_query_zcrx(union io_query_data *data)
+{
+	struct io_uring_query_zcrx *e = &data->zcrx;
+
+	e->register_flags = ZCRX_REG_IMPORT;
+	e->area_flags = IORING_ZCRX_AREA_DMABUF;
+	e->nr_ctrl_opcodes = __ZCRX_CTRL_LAST;
+	e->rq_hdr_size = sizeof(struct io_uring);
+	e->rq_hdr_alignment = L1_CACHE_BYTES;
+	e->__resv1 = 0;
+	e->__resv2 = 0;
+	return sizeof(*e);
+}
+
 static int io_handle_query_entry(struct io_ring_ctx *ctx,
 				 union io_query_data *data, void __user *uhdr,
 				 u64 *next_entry)
@@ -55,6 +71,9 @@ static int io_handle_query_entry(struct io_ring_ctx *ctx,
 	case IO_URING_QUERY_OPCODES:
 		ret = io_query_ops(data);
 		break;
+	case IO_URING_QUERY_ZCRX:
+		ret = io_query_zcrx(data);
+		break;
 	}
 
 	if (ret >= 0) {
-- 
2.49.0


