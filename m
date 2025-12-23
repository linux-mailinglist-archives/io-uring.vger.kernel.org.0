Return-Path: <io-uring+bounces-11274-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C36FCCD787B
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:39:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0C7E30213D0
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C20B19C553;
	Tue, 23 Dec 2025 00:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Go0yyIt+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D931F3B87
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450224; cv=none; b=YiYlMsN2sHTJnTb85jBlRKeXSgg/MNUhukhIZE1Y2klreEWwKqJaQ0Ya11gw0cBh6sPSIraEx45b7bDXLQ3a0HAMUElfqyufmLw+xSYPQUnYBPS/3Iy79HX7uat3JcHnxiCncu8ani4Z2KyA3Olc7e/zyUr3EZn/5WMny1FS3E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450224; c=relaxed/simple;
	bh=B9APPXwi+eJBx+Ec0dRjt1miIrzkozSsJ6sKE8vwZ90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBrEAu/zQnQwKbzDW23eKNOlzX1nmlEW3sEGncPoRzEV+pLYQmJx6SXtMoMq1Fy03M2JG5OUF+V7KK5QydK0TmdqqxmoY64eUOf9kr16aw0eisGwq/JC6tShU7NCe1oMAj+sXjJAzp6TboeH904kEPACGgNgv4wzwaTHRvVyOrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Go0yyIt+; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7aab7623f42so5167520b3a.2
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450221; x=1767055021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mwBseqLH0uMsJxr1t7ix8hlpS0RKO5SEcBlVQRvGPv8=;
        b=Go0yyIt+vGYQ0KbwYe9CN0rg68yhCXVbw7i3i5RBlsHYciWpQLThFULm15t4Rmzwxi
         e0VmZUiua/pslW/J/NUQhY/B4qr7JJFt8tCg1VPH9S5Rr5Z5thTRRcceOY4IGnMuSZw5
         +OhCxdDswcGHJdTeMYRuEL1nLvhIYy94f6Yao1jYPgj2GAJyOy/mM73CXdp6X5XsWKeG
         69a/rf6S31RzenPCEt7tu8jioy44UXGyQnoA6fHb1Apzvb8N2SQd9Qd97JspkZNQ0DST
         U0QGy+5jl883H/Q8YFAck2dYhPz3J5Hu4rIODRawD24VJnECv+J95uzRkQlmCYbWcVNg
         80ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450221; x=1767055021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mwBseqLH0uMsJxr1t7ix8hlpS0RKO5SEcBlVQRvGPv8=;
        b=sOELGOIXNVlgccVrkPl7IJ8hxclLKhGpLdn6TH8z9twZVLpR9AgOl3E+PKobxOrvu/
         aZQaFbEb9OZUR4x9CWDRTeFTRRrZA4EqQoFL1phO6jzDuXsBDYJAYad9JncarOzSIBzo
         jmOh45ZgxFjf+Z3QqY31JCEbZsGwlyXq8PcNOVYIFmh+mEx4jZGspk69yRpt7yRG7fZM
         ATNktfwjVtM+nTqx+hbaG1UrIMC2wKwguGPuf6oYVkSzIno2ripy6M6ST6rUTpMbXJ8c
         nnbvd0oHUctaeOrIPtL++M56acRhgQatYqrJH4i7e6ZfbDAQEojrk0xpvgQd8Vx7nNsv
         BVxw==
X-Forwarded-Encrypted: i=1; AJvYcCWbKsnip1rZ5jptdZ9H2GWFYgvXExiJTgZav5hNdY+S5Q4MBrzZscLSdiWPR0ab8VaHJgDxTI1UMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwNiqoLVDu7cYy2YFPEb7cTgicX5T5DVo50xb26/ANFkeSuvLYU
	JNvstdEXqJ+bzioiidoHuaKbW8kSZ5/y5BPdYDUNjS+WiE9yBSuwrEY6
X-Gm-Gg: AY/fxX5MSloF5Y59JSPxWMwzTT/c0dHEY0tAD8oGXQc32PJGH27zo83O55rfV6FaioO
	EEGoyyod7roGtoaErT6vErSFotR62LsjgqqXCIj4o55C3ra/P+FbkgvL6avHn7vyEcRq1cyUhV3
	QGGrfHFDeEge7bkI2Ky13NmxrK3DUZPoh6G7TCdeLrcSS7P+DA0axGySbMMNnB1x+I37mru98P6
	26w4j/51wbjNawsIQ85eFCx4d+y4UCMn8MyrbKMIZbW/eeTlvRrHoMHEM9lKRyl09vSeBtjGsj5
	qOiR74Tnh5Sm8rVffeoUgGE5vpyAP7RXXm5KJkRcn7nOpLJV6Tm6Bw5w06uJwUvY0FVcOUCyXNB
	/VtdL6Iyqb0u1MyUy7lTAoVFPZWa7cF2kpBBb0iMKK/wqUeR0cNNx0GQrLyrr0uNgdth+h3+tST
	WTTPU2afWB6G0W/IIA
X-Google-Smtp-Source: AGHT+IHqAVUqUUFna/XGzGwIPDSeZhxHAdCbFcnbLFuTjvSsP5GrYu2RylX3alsff/kemV8PA4uoGA==
X-Received: by 2002:a05:6a20:1590:b0:366:14ac:e1f1 with SMTP id adf61e73a8af0-376aa0e3dcbmr11639117637.67.1766450221495;
        Mon, 22 Dec 2025 16:37:01 -0800 (PST)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e79620bd3sm10094996a12.4.2025.12.22.16.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:37:01 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 23/25] io_uring/rsrc: add io_buffer_register_bvec()
Date: Mon, 22 Dec 2025 16:35:20 -0800
Message-ID: <20251223003522.3055912-24-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add io_buffer_register_bvec() for registering a bvec array.

This is a preparatory patch for fuse-over-io-uring zero-copy.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h | 12 ++++++++++++
 io_uring/rsrc.c              | 27 +++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 06e4cfadb344..f5094eb1206a 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -106,6 +106,9 @@ int io_uring_cmd_is_kmbuf_ring(struct io_uring_cmd *ioucmd,
 int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
 			       void (*release)(void *), unsigned int index,
 			       unsigned int issue_flags);
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct bio_vec *bvs,
+			    unsigned int nr_bvecs, unsigned int total_bytes,
+			    u8 dir, unsigned int index, unsigned int issue_flags);
 int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
 			 unsigned int issue_flags);
 #else
@@ -199,6 +202,15 @@ static inline int io_buffer_register_request(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_buffer_register_bvec(struct io_uring_cmd *cmd,
+					  struct bio_vec *bvs,
+					  unsigned int nr_bvecs,
+					  unsigned int total_bytes, u8 dir,
+					  unsigned int index,
+					  unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 static inline int io_buffer_unregister(struct io_uring_cmd *cmd,
 				       unsigned int index,
 				       unsigned int issue_flags)
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5a708cecba4a..32126c06f4c9 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1020,6 +1020,33 @@ int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
 }
 EXPORT_SYMBOL_GPL(io_buffer_register_request);
 
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct bio_vec *bvs,
+			    unsigned int nr_bvecs, unsigned int total_bytes,
+			    u8 dir, unsigned int index,
+			    unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct io_mapped_ubuf *imu;
+	struct bio_vec *bvec;
+	int i;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	imu = io_kernel_buffer_init(ctx, nr_bvecs, total_bytes, dir, NULL,
+				    NULL, index);
+	if (IS_ERR(imu)) {
+		io_ring_submit_unlock(ctx, issue_flags);
+		return PTR_ERR(imu);
+	}
+
+	bvec = imu->bvec;
+	for (i = 0; i < nr_bvecs; i++)
+		bvec[i] = bvs[i];
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
+
 int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
 			 unsigned int issue_flags)
 {
-- 
2.47.3


