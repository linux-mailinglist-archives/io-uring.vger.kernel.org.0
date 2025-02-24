Return-Path: <io-uring+bounces-6704-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8BAA42CE8
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:44:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58A1B177C02
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 19:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36201F3D45;
	Mon, 24 Feb 2025 19:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KQJk4jyP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3478204F8B
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 19:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426269; cv=none; b=bnILVEGyIRRl2GK0ThIIXQTkUQ0QFM3yEn+7j/S/8/t+TayYt+izs5SSTGRgOrg3Y3HmY24Db7Lc1dZ+zZztzCa3R2eR6aZa63SJjXXULBfpcVnUvq+VX+Wj3S0byuZXbJqlGH+vVNW1kaUoYn9Vq7rgJxAnQx6mcxrUe0oVDto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426269; c=relaxed/simple;
	bh=qFOqKTxZOFX9KEJWaWg6+yPiS4lhn8M7Yd4RpOprTWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kx8i+kYe+/HJO5G0LwxI/8Xdy6oVNeqpT7dwld9MruoHsxevHRoSwKmazfDeExpbSoEnMQMd1WBQEA8w1EXdiOyXAO0VXzZRbX517JDWxU3VLojPlYCvXSUef62R5gNhs1dOWBjoLpP7lYhbGdA6JEXfwTKABwzpKTyiDayIgeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KQJk4jyP; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43aac0390e8so7427435e9.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 11:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740426266; x=1741031066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3k/XwABibW+INb7cZJK+UXq7tXwfthMztjYYatrtEns=;
        b=KQJk4jyPe8SbWXtDaCwz3a2K3IQ5ZaoUWnfXrTFpAa0JHGPsioXk2c1BXpMo6FK6HO
         5jjZnC368117jqI5DctnKCOWz85O+0rd0bviD/YHqTFNIFfBBJbeCva06iWc94I2j1q8
         /Tw0Wl6hxto++xrgdR2d4ekSG1k3CLsybdNV/ygFKmfzpBnfC7j8Gt7K80ESjLBfDoAW
         cZuD6t8MixIaNjBr1IZQgTa5sDA3c49m2WtEqHo9nNQvuhjPU3PeBYV4V3gxyjA/z4V8
         E2QfY8yWU6UNj/g7maV9a3DQeV0FsOApzmujMY0V40w6r2gF5utoRkWUU4HK6gtLBH6h
         Acyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740426266; x=1741031066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3k/XwABibW+INb7cZJK+UXq7tXwfthMztjYYatrtEns=;
        b=JpudTYDUbMfhO48A/7sUS6ZkX+F2TIhggTJIkR+Tlo7Q9n8HNcuk1yO1ybL9uHAunE
         8bi4CeyXEul3ugUY+tdgcXJoPyuenKC3RD4tRbhgGPG7bPH+J7gwFHg+RBkHWMAZePNS
         VZZdV1IQUi8clFUyst/DDZfS0oFGKFoeA5M7tdrkJJdxLBOsirahz2RJXD7AH+suPj/k
         0HJsd4YPhMBfuR4gu5csSzIzRnnfYB2VG4Mc/xXZiciAZPlL9FTjibiqU6BlgrcyVKIz
         I/wDbCiS0FZA/ykh9SPjv9WVhIp+jOK5OO6+QmGWsG2/SLwNw+3rS5JaZUrD8sl9+UNE
         FwmQ==
X-Gm-Message-State: AOJu0YwpCoYdekZjPP7xKJFUbtxqWXbLxQ2y0CmYVjRSnLBPV/eWev1+
	/LqgkxfMY+bFFiQvKE2VdupY3GL3GozS6ZnMPsfMoPLWPUdOaiJ2qu2KQQ==
X-Gm-Gg: ASbGncspSTK3MPAOLWWpBPS4JQ8odTDR0dXQZY2aQ48OIMP5zxm2Z4XyW6M2i8uYb3G
	cNtaAj8x63R0R/WhDcWDvL2JIXPpywBaHxopadYI70cRqt3H1qbWWX15UHol2+xWU8GTFzSXQOH
	s1wn7SnDFkbnyVDeejlTpGpctgdKeyrsXlNPWsnEbwkENH6KVl4zad3hjIvzdsATdTIA6amhe3L
	uQVIEAAFISOA4xDWwNNu0vpxoQx2FyM0ZdD3LkuwKTcvnfS5nG1ux3tejdCkjDKR2L9ejE7CDaa
	F6rUjVi/hAHOmS4IhPW0NQELny1GcvyNqVV376Y=
X-Google-Smtp-Source: AGHT+IHkma8nETQpcFC3zRQNeua888TCLcQHV4ooN6UMH0dpez9iNOgat/L8phmHYWTyhokUdmnGGQ==
X-Received: by 2002:a05:600c:4686:b0:439:a25b:e7d3 with SMTP id 5b1f17b1804b1-439ae1f4153mr150455055e9.14.1740426265524;
        Mon, 24 Feb 2025 11:44:25 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ab14caa5esm1548305e9.0.2025.02.24.11.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 11:44:25 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 4/4] io_uring/rw: open code io_prep_rw_setup()
Date: Mon, 24 Feb 2025 19:45:06 +0000
Message-ID: <61ba72e2d46119db71f27ab908018e6a6cd6c064.1740425922.git.asml.silence@gmail.com>
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

Open code io_prep_rw_setup() into its only caller, it doesn't provide
any meaningful abstraction anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4f7fa2520820..cb660a224e90 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -204,17 +204,6 @@ static int io_rw_alloc_async(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
-{
-	struct io_async_rw *rw;
-
-	if (!do_import || io_do_buffer_select(req))
-		return 0;
-
-	rw = req->async_data;
-	return io_import_rw_buffer(ddir, req, rw, 0);
-}
-
 static inline void io_meta_save_state(struct io_async_rw *io)
 {
 	io->meta_state.seed = io->meta.seed;
@@ -287,10 +276,14 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
 	rw->flags = READ_ONCE(sqe->rw_flags);
-	ret = io_prep_rw_setup(req, ddir, do_import);
 
-	if (unlikely(ret))
-		return ret;
+	if (do_import && !io_do_buffer_select(req)) {
+		struct io_async_rw *io = req->async_data;
+
+		ret = io_import_rw_buffer(ddir, req, io, 0);
+		if (unlikely(ret))
+			return ret;
+	}
 
 	attr_type_mask = READ_ONCE(sqe->attr_type_mask);
 	if (attr_type_mask) {
-- 
2.48.1


