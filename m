Return-Path: <io-uring+bounces-6683-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5335A42759
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 17:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4668F167A9C
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 16:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36025261595;
	Mon, 24 Feb 2025 16:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMJCwuXR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61823261583
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 16:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740413201; cv=none; b=nMN8GNgyEW2r+gxCZ4JFhICVcyyMPh1je9zZdTC619mYYoln8k4OSB9gvFn2dkeS3aaNpCckoiLFW2+i0gicDFvx+ykt7I82g6o0O1Btm0hfJhZgYf1v5AyBcOmcE+ZdDhEj7e8YaMGTZfYf70+gJyIT0CF8dwG9pGOYOihCtFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740413201; c=relaxed/simple;
	bh=ZiWEpyrbRZKpS6hkr7hzo1dG6dzpZJ5uoEu210Dzmgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhMg0qT1ozmlKYiBeY/DiVUiQEsLobueiSD0F/dcvenRKlQkmXzeOlBOaENT0QFUh0ykL00V7xqiq1AM/FDdyWLShSHn04XlGw3ZXuOZ14pSBVlqEzN5OyrWXGhdYeqrrpYNK7aHxHWDV46sk5A1sE3MlT2jun74fYy0puZ8KYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eMJCwuXR; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5dec817f453so7604327a12.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 08:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740413197; x=1741017997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QK9YGtEODcnKoP57rreMyeESG4woNuiJuZC9WxFY5T0=;
        b=eMJCwuXRVGIIb27HT2WgaGf++Qh5ScYIGOyyt8E0KsFZ4uA+iiK0sMOsHCepxKTIHO
         0TtDkiImTb+CSaKw8tqW6X4ErkOYJinyupfZNPpmWQSKfJfji27sy6v+3jaYhPI8qRf/
         L1YmFXdq13C1cK777kapmuJUO42QDvQdSrZcT6SgRhLM632f2DY22uMOCjV0WkCW8/6G
         pQpTHVtM5um91EOHXH3BMOjAgL/sDQNEMwQJxA9HNE2pFXJIKGl5Ovb9vxO6PLVCSe2N
         IZ/5clkykn1JCzshDV37Vq3YFltDsoEdcO6JMZEX3f0p6Wf3Hxh0CaYZGHvr0tEQDRVs
         knaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740413197; x=1741017997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QK9YGtEODcnKoP57rreMyeESG4woNuiJuZC9WxFY5T0=;
        b=E7B5gDOPjBhKAetiVkJNMMmvkFR1pftowQqRWeO7OH+ffMok4SDtaWotwKQkc96ElA
         mcWUays5b+2yuSwOu19hqb5LO20zhWbfcE+sliaNqqC4NvTlV2gNs0LW5W6LrgITKlar
         MMkRViZ92vtp/e1zKtcIewHCpnkXIFwbntiDKMas33sZewXZTRUxQBBY04+MRd1TLwaH
         l+eaJlg35wAiaukShwwBKP2/aK9FDOTZKhkMIe34fhR7/9+sRkpBf3iEvUBl/Q4W2neB
         QpySsSMHNFWKMSC2qUjhw/2eGAAZQoqcD85wdkklFdwZI63D8tyJYVaBeEOVty0LLaLM
         4jjg==
X-Gm-Message-State: AOJu0Yxzj2CmZ8XX7oiUSaRy939hVvOFi/XGP3XDJRdYRdeuLM0z3NSJ
	yMdOgWrfu0CMIpwTelWb27uSAh8hTakFhZduJV1kTVCZqcr/YqHN1hRM6A==
X-Gm-Gg: ASbGncvY3sybpCIouU7UZfiwVUZOi+5VT/x6IuFitMUY7/2N6gXnkCMU9Jdp3lCUhVn
	M+t9eAeMOaaczDaAbOgBH/qaHp0YkJqheO/hGc4wRgFVWwt0Vy+aGbKk4Fc3fS/uOF9PVI89Xul
	RtLTMjq+TSDfm+Jc0g1aD4jUA3agh2KQ1diXyRL7LDBn2oWPRJVe2MOTMZDlREiTWN06z57Ya6+
	tLiD4PdpSpv6SoLUALwfb4Zc6WXq4hj4acaVu1IF0pFXVzjhxngBUKyMkL/lVaicsV1W5l5ohP5
	wq9Pj7M0zg==
X-Google-Smtp-Source: AGHT+IFXIYK5WVyWjAr4xNyXz8iaGrsF6jytUfZykN8TEJQd33k3335cHz42s1KoUerTZyJ2zat/3w==
X-Received: by 2002:a17:906:3290:b0:aa6:9eac:4b8e with SMTP id a640c23a62f3a-abc09bf5188mr1283654866b.41.1740413196804;
        Mon, 24 Feb 2025 08:06:36 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abb95cc7451sm1664684566b.92.2025.02.24.08.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 08:06:36 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/4] io_uring/rw: rename io_import_iovec()
Date: Mon, 24 Feb 2025 16:07:23 +0000
Message-ID: <2c8fa231c1096b81f909d327fcdbf0ddf1855afd.1740412523.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740412523.git.asml.silence@gmail.com>
References: <cover.1740412523.git.asml.silence@gmail.com>
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


