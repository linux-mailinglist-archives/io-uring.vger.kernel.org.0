Return-Path: <io-uring+bounces-11189-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D5675CCAF4D
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:41:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE28630B8E1E
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E64A332E729;
	Thu, 18 Dec 2025 08:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BOXkQbsQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BA62C21FC
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046890; cv=none; b=gh61yCMjzzyNBPSRq5ie9zAK6XDAOLus0EINMsaXGBfQmO9F2mkj/FhWfOeBUTY0LEFCslPxqTJFSl7mI9MJkbShLc3Aw0kTCh3P2Q0HsCqHG6ZAAznKc6e6VrFKAz4PItoXS8wvTM/3ae9wzrrp1rI0pEF+nPf05uISoLlVdCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046890; c=relaxed/simple;
	bh=vgNbsD9CCALgi9j4yOOkitbeNwGqU9jXs2FSeyCMKpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TufA6RGsSir+v3AOw6JBUz1Trp8b/m5n07WfIl1Kfb/eXOnjbT94CsoUH0HqBaD6zGe5YZjBfYHcwCaOTTbHgPXJ+AVMKJiSCuhzqcrld40HpBF97RpsULab4px0rKo4/l6QrK/zLL6HWIyyydFrL8dCDkTNUOxCQWQibvsVIzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BOXkQbsQ; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7b8eff36e3bso666486b3a.2
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046889; x=1766651689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IO0sQgruMs/IR+nTAa8imAaF1pCZdLIE1N0C3k6xZFU=;
        b=BOXkQbsQdIdv16Tt7ED/RrrIWhvulHHWqK14a1Jblt9wN0sGr6P5qsUPInW5PYcaP4
         4qVRog+t32Mnmv4UqkYmOiydCCgJoEGwit7Ke6TLuVu1JtsYNayr5QKaboMCL207/FE+
         D/ind6iIKlM7+jgSNRlsnr8ICwr/tOVu0WC3JzQj/ebN7ikpOw8D5Gv/ob/A1ZsQ82Nm
         GyysQw9ggTi1i6C21nIefq8oWwmB/PHnYEIjLmKum+wGNRSuk4riwPia5dvtrgNDD9o8
         uvJ1McWQnLwB1xF4HSxdMWQEKjzHAaeEmuFfnlrzdQLeECM3uP4aeIxeQ5LF8/WMkCvJ
         vwRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046889; x=1766651689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IO0sQgruMs/IR+nTAa8imAaF1pCZdLIE1N0C3k6xZFU=;
        b=EhpalTbeFmcyWe6N558voFiu7UICr9v2lIJM7dvN3TyM9HmE77Qh7AMmzATm7zG2iX
         ViWpz6UFmMfHyxDAuxJjKF+09zCzELbfCZiTv2b8fq/jV2nNxamyi/s2pvUD9c99pE7v
         OC5fuNLPOU+UekuN1F/0FJc9wTMSeEUNFmVRfxruVtfuK2GvGPx7CmkTVsZbQqZlz7pQ
         jsqkujyR6XVjsFLlEKJA/NNAhcSuNmK6QBu13v46kS3mckHSq0VvKkAZgeJz7M3R3d/I
         674CW3cmijwQjEKYIUY9p1/xMpu7WyisI2oTxrS225/akOvrGnv3U6vqa7kXaq7bzuBw
         lYrw==
X-Forwarded-Encrypted: i=1; AJvYcCVH8K27tiNPPw/RrL3H1jtnKp6tZGuT6lSNEWNwMAVz1sGAa2oWcSm0QoyIQQQ7r6/+OWjaiPVyvg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzlh/DyXmc0JwboX2V0GNojpXgmB0lSQQ0PiZ9xAD/I49nSI5/G
	4UNpbGrxwE9adVpZkSKNYXWSe2WBlPyv9trKLkCmjGxYwan+REqB7UKu
X-Gm-Gg: AY/fxX6No16thBcOgTxTVzlR5ulI9hamVrXiEScR+p+6yUMU90yWL3eU4gqfAXBeDpw
	NMT3loIYIomN7OoLSPHMxcUlw1dvQ5xNYON8/7Z61yDt2BAMGxY2IH8aQLZB+otP/bviT2hNxq7
	iYyuusiL8+B2cfWRvcKENMI2eLgR4Up4yNAvPDvC/jshBIEwJ4DIdBEO2129WpvMFl0/MUcovXe
	PgX+H96TozgsRRYTLQAkNGh3H5bI+kPZbEkc5aXG7o19gAfZgwn8z4GzuoyCpwCGuom9+MpERiX
	f7WJzEnJ0V7SxDHdHPR5eiz0a6uHaafpgWKzksUTj2eGKK/GLuJO4pBQWMkIhwsf7y4K13+uHRy
	a7Rb5C5/Y4eXPhGy/ww1FGX5Xgcv5RlKa2QgZE5aoNP3Ko9kSZskw5yD6OSalRseu78WTfi0nM5
	zoFxj1K61sClvNWW6fKQ==
X-Google-Smtp-Source: AGHT+IHIY1jUjRKPovQMZ3yRApuQFFXCVrFEa1kTmNTjjyJXD4esz+9Go44P1EMBSQCpJpXXxMl7tw==
X-Received: by 2002:a05:6a00:600d:b0:7a2:8853:28f6 with SMTP id d2e1a72fcca58-7f667936901mr23391659b3a.22.1766046888704;
        Thu, 18 Dec 2025 00:34:48 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4a::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fe13d85186sm1831052b3a.40.2025.12.18.00.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:48 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 09/25] io_uring/kbuf: add io_uring_cmd_is_kmbuf_ring()
Date: Thu, 18 Dec 2025 00:33:03 -0800
Message-ID: <20251218083319.3485503-10-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_is_kmbuf_ring() returns true if there is a kernel-managed
buffer ring at the specified buffer group.

This is a preparatory patch for upcoming fuse kernel-managed buffer
support, which needs to ensure the buffer ring registered by the server
is a kernel-managed buffer ring.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h |  9 +++++++++
 io_uring/kbuf.c              | 19 +++++++++++++++++++
 io_uring/kbuf.h              |  2 ++
 io_uring/uring_cmd.c         |  9 +++++++++
 4 files changed, 39 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 2988592e045c..a94f1dbc89c7 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -99,6 +99,9 @@ int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
 				  unsigned int buf_group, u64 addr,
 				  unsigned int len, unsigned int bid,
 				  unsigned int issue_flags);
+
+int io_uring_cmd_is_kmbuf_ring(struct io_uring_cmd *ioucmd,
+			       unsigned int buf_group, unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -176,6 +179,12 @@ static inline int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_uring_cmd_is_kmbuf_ring(struct io_uring_cmd *ioucmd,
+					     unsigned int buf_group,
+					     unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index f494d896c17e..b16f6a6aa872 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -960,3 +960,22 @@ int io_register_kmbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 
 	return 0;
 }
+
+bool io_is_kmbuf_ring(struct io_kiocb *req, unsigned int buf_group,
+		      unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer_list *bl;
+	bool is_kmbuf_ring = false;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	bl = io_buffer_get_list(ctx, buf_group);
+	if (likely(bl) && (bl->flags & IOBL_KERNEL_MANAGED)) {
+		WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING));
+		is_kmbuf_ring = true;
+	}
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return is_kmbuf_ring;
+}
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 4d8b7491628e..68c4c78fbb44 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -149,4 +149,6 @@ int io_kbuf_ring_unpin(struct io_kiocb *req, unsigned buf_group,
 int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 addr,
 		     unsigned int len, unsigned int bid,
 		     unsigned int issue_flags);
+bool io_is_kmbuf_ring(struct io_kiocb *req, unsigned int buf_group,
+		      unsigned int issue_flags);
 #endif
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index ee95d1102505..4534710252da 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -448,3 +448,12 @@ int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *ioucmd,
 	return io_kmbuf_recycle(req, buf_group, addr, len, bid, issue_flags);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_kmbuffer_recycle);
+
+int io_uring_cmd_is_kmbuf_ring(struct io_uring_cmd *ioucmd,
+			       unsigned int buf_group, unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_is_kmbuf_ring(req, buf_group, issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_is_kmbuf_ring);
-- 
2.47.3


