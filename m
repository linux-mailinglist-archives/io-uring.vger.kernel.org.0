Return-Path: <io-uring+bounces-11773-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 54638D38A0F
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:31:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 93C7A301AFE8
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4951A1C84B8;
	Fri, 16 Jan 2026 23:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ig5LbdZM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF27A320A34
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606273; cv=none; b=B/2ZkPe4tOFtkhQlaCGFs4qgQcFBq/pcin6lIGfoq+q60fL3od2v4KVzYFfI4nYtNGTFnGOe+o2TwHvrO44Rp173qGjhU7yn7PrSgQ5zTVf+aoERnY+kiQlYicnqBtcspwCLt0yorKkhtRmSgF3TGVT+vcfeNK88yKXGLWPmZgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606273; c=relaxed/simple;
	bh=1W2QlU/drgTCR8vDo6sf+b6pICaRNHXTsmuWU7JfLLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeGpGvOuLiULmhhv+FxJcGpXdhfQmZPpuiM2x/J7Oc2QMs+aufxMC6Q0t6Daz/VJMi2OhatssN4snf+cI8/yst1hTFjTs84U+CYd24lJvnjQImTggl8WYrFB1ZNISsfCyAJJajxxIeoWyw3J/UTwmhRUyQmtcrfdttMojlqOI2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ig5LbdZM; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so1123620b3a.1
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606271; x=1769211071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SKHlE5apGJL1qOx1MKXlzZmVTshm144wxJdFcI1s+nU=;
        b=ig5LbdZMNzammQPrLRJw9Jgr1/U1rwSqoZCaDYE4uwvW8OEhxdaheqz2UN0iEJLwxH
         Ny8+WWL+aPOvVcCKV1l9MF04+ff8pqC2yITOcghfdG9aWVCgRct4yFXa7xVVCsTYug6f
         PGw7Se/qkADe7uNT1QSwg0+ny4Ew5WIaOTG6lfLHeR63hEK7FrZJcHkKd5ZEMm3IKfEl
         J2U7Sbej9sLYZ1S+uZzKI4U1k3OIUV8hSv2LW2JfnpuZg1eYF8NNWqM/ebulI1B3byZh
         FUHu4gJbP82pq1+07JkYLwqCc1KNiIwhPtXMdNMHMe7bcuWoYfc5Ihl7+9iYJ8/xMldM
         NOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606271; x=1769211071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SKHlE5apGJL1qOx1MKXlzZmVTshm144wxJdFcI1s+nU=;
        b=Cv9rqNyo0EvSGE4QiF3+2Ye4sGEFDF4JsD9ELP8oac0mvVKynMWtMEJsnFxXAPqdji
         EqVuAIKYVoa+9jtsZm1FO6Yj8e9yYvsopzJlGn28Aih6g8bk8KQWpsvLOYBa1MHg0DuP
         lS/lptrT0SW07bdZCc49inq2O4YlrMf2+S/35TGYMubhuU3Y24op+H7GjkG2tSv7TPqa
         Ykp2i6mVZH/I7N4p+vJ9O1Ldw4/AM7/karDrlcBot2rscYLBwRtmDuPrJ9GxyWmUXVtc
         spFlw1dRg2NX3y7Rhv0e1LG28JPAs9bsRoY1wppsOyoV1qmqwKC/xIuufPGCbg0+W0yq
         GPQw==
X-Forwarded-Encrypted: i=1; AJvYcCXDdoY/evj7RWsT1qwjoiZ4tLEnQuVrzSzaov1Fl9y/2hhu8qQcReLwzJG5Umn9z3WUaiTawPyF/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGcz0Z+NEMXtEwSjM7W62P9z7fy7Z4wSVBrvn4rss6tfwHPhzz
	4PpTnPYpfQbLdIjewgwuny/knAhDEKN1dq/t6sW61NuTxKkY8XPHMBGW
X-Gm-Gg: AY/fxX6Jfv5gM8im13sjyCr8PHN9odAf5+NLgRPohlIMKmo8JpWC2HctD1R3rrVt4mj
	k6s69SLzXac8RVBwvEdp2kg4wi2Hf6OzC48ZKBBsUORnGOtynF7wkfIleDSK24UzWETUNGjJfq8
	NPD5h18kk8wZmjcIxX7+VdmDSaFEYh4KP0sk+4WxX8m/rfLjVwlJtDN3tpt65PVCRGLZy4PJt0i
	E3qLiwhEW586ZXLXSKOac52YqzPDwOuRfyZcfZ9glM7D4+2q4PE/2k8Zd06DA+N8srzFLsaU2hz
	8gQiLcK/VlW4wjsFtv8fh9vOY/Hxz3VrtA6ayT/Y/T9DkOa/j9dsUIxEtoCPP6maO10WPjKFNjL
	uMssg1AtrsCUYkAv9ekL1EGi9rAqoXgbHap9g05W9mvySVht7y+jdHSz0i0HoTol6u/NDGeCc/+
	DTSoRp4w==
X-Received: by 2002:a05:6a00:2496:b0:81d:a1b1:731b with SMTP id d2e1a72fcca58-81fa17923b9mr3129626b3a.19.1768606271368;
        Fri, 16 Jan 2026 15:31:11 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5b::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa1291d29sm2924245b3a.53.2026.01.16.15.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:11 -0800 (PST)
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
Subject: [PATCH v4 05/25] io_uring/kbuf: support kernel-managed buffer rings in buffer selection
Date: Fri, 16 Jan 2026 15:30:24 -0800
Message-ID: <20260116233044.1532965-6-joannelkoong@gmail.com>
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

Allow kernel-managed buffers to be selected. This requires modifying the
io_br_sel struct to separate the fields for address and val, since a
kernel address cannot be distinguished from a negative val when error
checking.

Auto-commit any selected kernel-managed buffer.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring_types.h |  8 ++++----
 io_uring/kbuf.c                | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a3e8ddc9b380..0b8880cdda8b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -93,13 +93,13 @@ struct io_mapped_region {
  */
 struct io_br_sel {
 	struct io_buffer_list *buf_list;
-	/*
-	 * Some selection parts return the user address, others return an error.
-	 */
 	union {
+		/* for classic/ring provided buffers */
 		void __user *addr;
-		ssize_t val;
+		/* for kernel-managed buffers */
+		void *kaddr;
 	};
+	ssize_t val;
 };
 
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 68469efe5552..d9bdb2be5f13 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -155,7 +155,8 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	return 1;
 }
 
-static bool io_should_commit(struct io_kiocb *req, unsigned int issue_flags)
+static bool io_should_commit(struct io_kiocb *req, struct io_buffer_list *bl,
+			     unsigned int issue_flags)
 {
 	/*
 	* If we came in unlocked, we have no choice but to consume the
@@ -170,7 +171,11 @@ static bool io_should_commit(struct io_kiocb *req, unsigned int issue_flags)
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return true;
 
-	/* uring_cmd commits kbuf upfront, no need to auto-commit */
+	/* kernel-managed buffers are auto-committed */
+	if (bl->flags & IOBL_KERNEL_MANAGED)
+		return true;
+
+	/* multishot uring_cmd commits kbuf upfront, no need to auto-commit */
 	if (!io_file_can_poll(req) && req->opcode != IORING_OP_URING_CMD)
 		return true;
 	return false;
@@ -200,9 +205,12 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_index = READ_ONCE(buf->bid);
 	sel.buf_list = bl;
-	sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
+	if (bl->flags & IOBL_KERNEL_MANAGED)
+		sel.kaddr = (void *)(uintptr_t)READ_ONCE(buf->addr);
+	else
+		sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
 
-	if (io_should_commit(req, issue_flags)) {
+	if (io_should_commit(req, bl, issue_flags)) {
 		io_kbuf_commit(req, sel.buf_list, *len, 1);
 		sel.buf_list = NULL;
 	}
-- 
2.47.3


