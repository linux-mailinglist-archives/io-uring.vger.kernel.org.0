Return-Path: <io-uring+bounces-7394-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D8DA7BFC9
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 16:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C59FC17B28B
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 14:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698EF77111;
	Fri,  4 Apr 2025 14:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PO8/51Kk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD7C33CFC
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 14:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743777936; cv=none; b=ISXpJGM2JynOj9mj/tJKNsFhyjkECB4BlYA5zeP/WIF5G23tA+VhpwtNbSLTxrzBR+ogzc0ePZNWkp76/X0d/2ipKrPpOADX9ETWmAI1BeCk78MwHvn4xQj/hQO7h1jn7iGgZde0C3OIoB0yncNj2j99pb7XFIAWULspFRljets=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743777936; c=relaxed/simple;
	bh=l2ehPPhLxqiDdVdJn524wbLqaOn5arF9MTVmDy5kDIs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=urYfl6c8cTDG4meC8zJaVM+s6SN7Fwg/HWeE+PWEXf0eKXwHGRwU4Db9eKyVurh/1NeMLVI1Po7ZwbL9FCfKMptpIyrNpncfa+pRi7wic77g+TYbLLwNhnUetPBYN0BP8Mwq1mIHw/PygXq2bBdqMVB9Ne3w8931gsyHRDJRSOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PO8/51Kk; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e66407963fso4061776a12.2
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 07:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743777932; x=1744382732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MFl/26LAWYq5zk6vb4tdnDYdhBVsiIryacpyXWLHu3o=;
        b=PO8/51Kk4ddkHjyreIUrIMIzMTTrHq8n5sSgMJa07KVagqY3p+xe+QhC7VOt7wAz4s
         lq20LYVPC95sLwZl7FEuHb5lBzHc7XWm2XEjIEOhPNQUoh+qMJrBQKIFWXQ7Nek99Iug
         nT7/qu0QlXaLcMZuoFr+d2ZNsAQJLRAzM3lmZ2U5vo20ksU6cy6bNGbTNlRI9jQQNZ6w
         E/hv1qFciZEotwYYI/Cotn5bqk8hEUHB7CUYkvVtzR84GWN0tE/UZkFDU1NaVYJBP80E
         49j037rGePrq723O+1oWV3foYPP1C9f6561KAkScPoqrlYPSOHWGACwLxeIXfP/a5JzT
         mpmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743777932; x=1744382732;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MFl/26LAWYq5zk6vb4tdnDYdhBVsiIryacpyXWLHu3o=;
        b=DRmvhoJA19Z4R351g9fpWR09xn2W6StWsnMXJMDDKIIwpFEmSB30XpFVOBvSCvm6gX
         njay2/50CnEtfdbQwSGGygR/ebH/AYcj8sVUwAkjdG2uZjed4joz61TFLL+uRq8WI4rk
         xg25ZGr9VxIelIznH0hJaS1OAobMteyTApXXm3jS5PqQazrDPgYElV78eIcbXtpI2+T9
         BTk7j2v1JmxAgk4NxwXO61yVlY1DtMgcD3aOgNtFmDbEi9uwxLTPg3b9hEwEBI9NJQqD
         rHEqSWhcuFKB7C3nefK3omb7mUaSBEksVpSl0/qXpx6JLmJZ1CmUa8JOThGHfURSjzOc
         HTOA==
X-Gm-Message-State: AOJu0YyLXu1ctMIcfjA8W7+ycqQGMspZe6D/QeMyt0Cj0lJOHT5Hxnhc
	Afm4pB8BmML2K+/PqOTMxPvRHw96Utm/+Xc90uuHzmj+7ECrHRGjejVKuw==
X-Gm-Gg: ASbGncvO7tTsekkgP32dmo1tn/9pSatMn3ZcpflDsJdB9hMO4cbKvYLiBD6ZzIeuKRp
	pH9O4zNZ5CAclJAiMXw3Wm80bLVwYJ7ftzQ21U0gHOCMcg9Zf5m1ZSOQe1NTaW+O4ycBhUUm6S4
	xZ2wOp5XzmQ/lguaKvADSIq8GerdY2LJLuCTYFlSZ9EZXAY/R7uzWO4Ch+apgBJgPHXlUwLnAcf
	yehMEbiXWa2gZy5b+ExelyECKIZIDJ4CuemS+eOTHzhDRQiSOIZzXZcCvkSLKMSD2SglKfuP7ja
	NDABrpHc+ddwiGcBa95bCDJ4xY1Q
X-Google-Smtp-Source: AGHT+IFmEPxZ6siBPYZFGPYDeEiEkNV8EV4Y9aYxSOpvqMR50O3Fxusu1U0K3+vWCtwKp6O9SvsczQ==
X-Received: by 2002:a17:907:9485:b0:ac2:6bb5:413c with SMTP id a640c23a62f3a-ac7d6d5776bmr251785866b.31.1743777932318;
        Fri, 04 Apr 2025 07:45:32 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ce28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe62670sm265404366b.8.2025.04.04.07.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 07:45:31 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: fix rsrc tagging on registration failure
Date: Fri,  4 Apr 2025 15:46:34 +0100
Message-ID: <c514446a8dcb0197cddd5d4ba8f6511da081cf1f.1743777957.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Buffer / file table registration is all or nothing, if fails all
resources we might have partially registered are dropped and the table
is killed. When that happens it doesn't suppose to post any rsrc tag
CQEs, that would be a surprise to the user and it can't be handled.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5e64a8bb30a4..b36c8825550e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -175,6 +175,18 @@ void io_rsrc_cache_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->imu_cache, kfree);
 }
 
+static void io_clear_table_tags(struct io_rsrc_data *data)
+{
+	int i;
+
+	for (i = 0; i < data->nr; i++) {
+		struct io_rsrc_node *node = data->nodes[i];
+
+		if (node)
+			node->tag = 0;
+	}
+}
+
 __cold void io_rsrc_data_free(struct io_ring_ctx *ctx,
 			      struct io_rsrc_data *data)
 {
@@ -583,6 +595,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	io_file_table_set_alloc_range(ctx, 0, ctx->file_table.data.nr);
 	return 0;
 fail:
+	io_clear_table_tags(&ctx->file_table.data);
 	io_sqe_files_unregister(ctx);
 	return ret;
 }
@@ -902,8 +915,10 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	ctx->buf_table = data;
-	if (ret)
+	if (ret) {
+		io_clear_table_tags(&ctx->buf_table);
 		io_sqe_buffers_unregister(ctx);
+	}
 	return ret;
 }
 
-- 
2.48.1


