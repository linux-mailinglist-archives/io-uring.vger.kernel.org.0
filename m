Return-Path: <io-uring+bounces-11779-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC16D38A1F
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:32:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D679030251BC
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5522765D7;
	Fri, 16 Jan 2026 23:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A1LFzzch"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BDF322B90
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606285; cv=none; b=Ag5wleI2raiwCwYbcS5NU1NQTcBTeHuwrCCdjhOmHAOtaB2xlQngW/MTlAxyTONDyOngxymLzH+0cP2vugLS2EiFOlOyGTvrKi0f7L+vd3OuVYMve/vj4Zb2b7YZdky2/JvGwEscIev0muYIxFZx95FNXt+4glP1v2MUA+e9J0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606285; c=relaxed/simple;
	bh=d2Exw5shL65mmWBgftxDlE8YJf2sHQiJqGfzBdKjU4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ec2r1kyYlqz5PYT9hXiVc56XvkUT2frWu5s1nzPaL5Zd2kWGb+FOuUlJObMQTCOHs+2q5gm7L+6JdBFV4pRw51mFz5U2O9kJUZPNJb/BmqFfBBH6Fs0xhMD3lJz1+xPfOCYayCxnj5zrbO5ZR8wpcCM3ZAQyO1REbgCcSXY5qkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A1LFzzch; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-81ecbdfdcebso1553142b3a.1
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606283; x=1769211083; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Platj88LMl/Gmni8R/u11ZNoR7auOwrTDvEWtflAldM=;
        b=A1LFzzchu5GAIttHGjPU69ZeyvAMa3etND8SOrgtYCOaePkGSXX5YdMszsVFl2qI7w
         Q6jPPSxAsCiOLf5VGETThCiuJt9gjr2oWFfSoVQX4gFIZtKv2kGaZDzX2mOryHCrSaAU
         SWZz+1kGEv7dB/ykUjC/kh6ho6Z1l3dWnVT21nEkC3QQtAGwrv7jgKr8aMmCxwEnG6LR
         eLgDBdmktzXfm1QEIY+ThgxC2VFC1uUv/ejF8RUyAkHR8BVi9ikii3PTL/T74dXgeIHc
         OwS904qwuD/iDkbUIjMQqa5EyrUrgNTR3v1ZHflBi05LnGXKKYGJvJNPGUSB0k5pZ+oI
         jELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606283; x=1769211083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Platj88LMl/Gmni8R/u11ZNoR7auOwrTDvEWtflAldM=;
        b=ayjNELwIhrZ9T4aspxmI5jmf51C1lG+9Q8LeoRCQRxBOejJ2cH7OKPIlpyiK28unHg
         mnPDGaYG1z8qGSz/RfwMzlJ8f4/88inuvWosLSnYO9Yes/DuIbIX11lUNdlp5hg7MXpV
         nmrjhgGQpVb02VTKKkHmhJnWQQxQMADD3KJ1nm0au6DOsbRk9jmmYKPKRbqranErvfj8
         /jiDvuwVvrjKbFRutYpL7M/EODMPabzBnF5P9ZwuRd0Tgh3jUmOtjjL2cwJyrGm73Sd2
         UCZDRvXDzTzjS6F2TEJ5eQ9klY6gvlyyDvTR+jywHEBXmPWgw6c6gr04MJlRsZwcwzNK
         uuZA==
X-Forwarded-Encrypted: i=1; AJvYcCXSW00fhRz3KzFbdbeKgHKVU4plQcGss3AM6zzmNUfx78EJJZGtX097pSTLt+aI06EDS/gLYVJIQw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiuieL+xixM8pQJuQDWGpB3XTd8w1cVxdxPJWk1v1Is9z3j5KL
	7bYsSe8uoWiBY3HbOKd+WdV5qdOp2LBW+0Gch9GQIuHByISXXPmu/rp6
X-Gm-Gg: AY/fxX6Xu2hReXUxF/5NNEBoqEGE7S34r694sHjo+bkTqPtLv2u/redFPO9ZLykbonG
	6eAa/sHfrWOMlv4mPC+27CKBybxyJT2SZQ2gpAVn4+DNB5QND2A/ZihRr6zx9+BMgQrYUsEDxtY
	WD2VRHJ3nv2tGvaOxVuUw+VKyRY1bpHicjqug4e75Jg8+juPVGrE6rm/TFFDpL4X7vbPuPg266S
	/FfbfDyDLIJZmDedFy/2a/sytl8S23p7PVIJXsnyZBvQ+1ZAH9C0C125G5RXiH7XMsS38Ml6xLe
	qOIsuo+plGIB61YaETM9FG7m2GDhytJjjAV7GbQK8yo3AncNqpXUIrtr6cJkHLMf8Ia8dw3NLos
	VeCnM4VlHssKLilcbck3JDkF7GVwfhR3rRNzGpAI/F2lX4Md6VDu9lHDeY9AoTnzepYJCGCaCoj
	BeSuoBIA==
X-Received: by 2002:a17:90b:1d45:b0:34c:35ce:3c5f with SMTP id 98e67ed59e1d1-3527315c079mr2886367a91.5.1768606283206;
        Fri, 16 Jan 2026 15:31:23 -0800 (PST)
Received: from localhost ([2a03:2880:ff:40::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35272f4a9a1sm2947608a91.0.2026.01.16.15.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:22 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 11/25] io_uring/kbuf: return buffer id in buffer selection
Date: Fri, 16 Jan 2026 15:30:30 -0800
Message-ID: <20260116233044.1532965-12-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Return the id of the selected buffer in io_buffer_select(). This is
needed for kernel-managed buffer rings to later recycle the selected
buffer.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h   | 2 +-
 include/linux/io_uring_types.h | 2 ++
 io_uring/kbuf.c                | 7 +++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 6ff5c0386d0a..8881fb8da5e6 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -79,7 +79,7 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
 
 /*
  * Select a buffer from the provided buffer group for multishot uring_cmd.
- * Returns the selected buffer address and size.
+ * Returns the selected buffer address, size, and id.
  */
 struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
 					    unsigned buf_group, size_t *len,
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 0b8880cdda8b..157eaf92d893 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -100,6 +100,8 @@ struct io_br_sel {
 		void *kaddr;
 	};
 	ssize_t val;
+	/* id of the selected buffer */
+	unsigned buf_id;
 };
 
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d2a660ecc7ac..ada4bdaae79d 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -251,6 +251,7 @@ struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_index = READ_ONCE(buf->bid);
 	sel.buf_list = bl;
+	sel.buf_id = req->buf_index;
 	if (bl->flags & IOBL_KERNEL_MANAGED)
 		sel.kaddr = (void *)(uintptr_t)READ_ONCE(buf->addr);
 	else
@@ -275,10 +276,12 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	bl = io_buffer_get_list(ctx, buf_group);
 	if (likely(bl)) {
-		if (bl->flags & IOBL_BUF_RING)
+		if (bl->flags & IOBL_BUF_RING) {
 			sel = io_ring_buffer_select(req, len, bl, issue_flags);
-		else
+		} else {
 			sel.addr = io_provided_buffer_select(req, len, bl);
+			sel.buf_id = req->buf_index;
+		}
 	}
 	io_ring_submit_unlock(req->ctx, issue_flags);
 	return sel;
-- 
2.47.3


