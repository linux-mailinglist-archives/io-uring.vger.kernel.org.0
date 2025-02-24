Return-Path: <io-uring+bounces-6702-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 127B4A42CF1
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:45:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CECF189CB5A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 19:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D182054E4;
	Mon, 24 Feb 2025 19:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GbIUk0Qq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C4C200138
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 19:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426266; cv=none; b=uqYn0WVRpvlx2fiWiIrzLWsI5ckMZQuqvMSyyCN2nhPkFndVsk2fiFhLDIBjrCfszEqLtIWWq8xg3uiNPxUUG2DjpVSidy940uIAvnYmsovFPdhf+TI74Y3ozWNDJcpLscRnYJP1zL5s+MuTikocnw4AadPlkybkEQ2OnMABBUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426266; c=relaxed/simple;
	bh=ZiWEpyrbRZKpS6hkr7hzo1dG6dzpZJ5uoEu210Dzmgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEAk+mggLlK7Vl4QcTXASH0WFLi6t0ZM4fa6QGKZ0GVLkZHeX4VSo2f1lMRvs3Nh/MOls64OrRV0Ek4Z4e/XTLDFFkQzmUmHAcwD4ZNnHqsOMDshzWZAg2I0gNNiUF0mIKqKBwbuTv9c+QwXSdZcgVTssEHM072kInbMF9Gv6Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GbIUk0Qq; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43948f77f1aso29488125e9.0
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 11:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740426262; x=1741031062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QK9YGtEODcnKoP57rreMyeESG4woNuiJuZC9WxFY5T0=;
        b=GbIUk0QqtpWVJLe3CD7I+wt8TgRx1/1gtN0gzj1tLFG+tfwDF8Y0r0DyDIFgRUVHQo
         zOzI9Ai+knACBmTZCYFhxzlSlE/727otBeEQ+QdIyKVd0HABKnDRsJIVvUUK6hDEFwDr
         Hj6l8GyzzIim/C4VR8VGtdARotkP0au7LqZ95VBrih9R75pOCm9cETnUthtaE0JMlnS8
         vZtwfu2xxkyspik/Bra3rz3UnOBJBDfATUCUiFGixDXoDcO6kzNz06upPD1Vi7e16a3F
         bsS5GkOGPeRH33qQLvV5ONUI3I4WSoTnnzq6oaNuaTkMcHHDgwr23A7IG+fyGmkGr2Qt
         N2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740426262; x=1741031062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QK9YGtEODcnKoP57rreMyeESG4woNuiJuZC9WxFY5T0=;
        b=fxRsxknXY9ZFwWDes4FTG06sh7gwqs3BqsQJX5trObOhsdlnHcZO20LY5JF6XA7OQi
         JHVe7BgEwN7v2pct8GHLN5tkzu5CXnNFT1ONpFlP1hekBxkV5LQAGQObUxKtFhb+dJxt
         nzdeJMWQuRne0IfhGkMQym+Z4Y4pH5bnHSzbhj9sJlRDWFU/u8rtaqlErknaaL9MJ93S
         N8D73F0tm7lZAwQ/cxoYsKskeeTm4tqQLBZOCvSB7jGEQFaL30zjwXqQaka3h1UJbeQn
         TQgDo0WKRKGMLBLpmydjrRyZmZVfgxh8ljImx3o///sDs2cOwrER5ipCa3V136Ky/ZvT
         W9xw==
X-Gm-Message-State: AOJu0Yyhe4EXGVBzJgc5Qho1YijLYYOsYTPoVHMth2cBp4LYOqrYH7PK
	UbCsF4CAwYvMdszIfAbGhughVOzMO4CvOKZHV/8tC9XM/eUatQuN47YQiA==
X-Gm-Gg: ASbGncsVODfIHoboSUC9OWUD7bQkyHGW4vlmGirQCRCa/BjLF9P4HZWLYY1zkt9xeIy
	hRnJXkHqVOe1R3pBPWUPvmJ7yQYF3QljZcnWeLv/hl6f2bb7AvXBH8wD0rAhiQenxohfCpWA+g5
	MpOwZ3re8uGUKvYZNB4X5oqW0GiD4wJXYKdGcg8BtFHZYToM87j7PSt1ErEMHdnMrZlgqgLeTPk
	Cnb5y7JC7nkE1I5cal6M5+vf43RE7cPB62HafzwnSi5bzgFouMB94ySfu4Pl4I9soFZhOu3Mtgu
	WaAe8mGB8uOs7/Qi5qc2hrYHFncO/bAlBuCiryY=
X-Google-Smtp-Source: AGHT+IFvOlj1GXW5meFdjtgZYBguANTagkdRz8UgjH/w8fSwCAJlLMGQxQUtO2vFdeQWZJ6kk+YPJQ==
X-Received: by 2002:a05:600c:19cd:b0:439:8340:637 with SMTP id 5b1f17b1804b1-43ab0fa248bmr6070095e9.30.1740426261961;
        Mon, 24 Feb 2025 11:44:21 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ab14caa5esm1548305e9.0.2025.02.24.11.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 11:44:20 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 2/4] io_uring/rw: rename io_import_iovec()
Date: Mon, 24 Feb 2025 19:45:04 +0000
Message-ID: <91cea59340b61a8f52dc7b8e720274577a25188c.1740425922.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740425922.git.asml.silence@gmail.com>
References: <cover.1740425922.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_import_iovec() is not limited to iovecs but also imports buffers for
normal reads and selected buffers, rename it for clarity.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7efc2337c5a0..e636be4850a7 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -76,7 +76,7 @@ static int io_iov_buffer_select_prep(struct io_kiocb *req)
 	return 0;
 }
 
-static int __io_import_iovec(int ddir, struct io_kiocb *req,
+static int __io_import_rw_buffer(int ddir, struct io_kiocb *req,
 			     struct io_async_rw *io,
 			     unsigned int issue_flags)
 {
@@ -122,13 +122,13 @@ static int __io_import_iovec(int ddir, struct io_kiocb *req,
 	return 0;
 }
 
-static inline int io_import_iovec(int rw, struct io_kiocb *req,
-				  struct io_async_rw *io,
-				  unsigned int issue_flags)
+static inline int io_import_rw_buffer(int rw, struct io_kiocb *req,
+				      struct io_async_rw *io,
+				      unsigned int issue_flags)
 {
 	int ret;
 
-	ret = __io_import_iovec(rw, req, io, issue_flags);
+	ret = __io_import_rw_buffer(rw, req, io, issue_flags);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -207,7 +207,7 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 		return 0;
 
 	rw = req->async_data;
-	return io_import_iovec(ddir, req, rw, 0);
+	return io_import_rw_buffer(ddir, req, rw, 0);
 }
 
 static inline void io_meta_save_state(struct io_async_rw *io)
@@ -845,7 +845,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	loff_t *ppos;
 
 	if (io_do_buffer_select(req)) {
-		ret = io_import_iovec(ITER_DEST, req, io, issue_flags);
+		ret = io_import_rw_buffer(ITER_DEST, req, io, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
 	}
-- 
2.48.1


