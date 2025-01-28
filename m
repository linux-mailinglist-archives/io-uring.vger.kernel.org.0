Return-Path: <io-uring+bounces-6169-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40DACA2134E
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 21:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83180188474C
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 20:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C391E0489;
	Tue, 28 Jan 2025 20:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGRrlObM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B84A1A841A
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 20:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097772; cv=none; b=ks1qhZNVmNHuehGJEGl/eoOPsDMX/wy34peZIpR8r0yUXdKFAufqbOn1I13ttNXxEjMntziJ3Q+bA0Qdh21ST+ggutxQzSxepkiXqKHE7OEXefR5/o4lCye6Bh6GJ2ydcQYNjSAKMEcOp9gSt6tFsVGkVYjyqJAw2Ckn6wtdpXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097772; c=relaxed/simple;
	bh=FSQUUyxmIvTUpNUYonhod43TJ9bFkCPWt10RH2ijo2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=du4hekiTUuS7JX8C9fG1eKEfLzGAA1OgYiN2Y2xBy5j8mE9b5PcD92dpjFyrpbuPuxnCM0QC9Ho8m9LKSeMw73ys57sMivmJLxIx8ueG+PF5NMUJgvzRBy/EuH6V8xenJB0odlgD4NUUWGBeT/IfQsnNyNluFmepbpA3WlImHcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jGRrlObM; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5dc0522475eso11937841a12.1
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 12:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738097768; x=1738702568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGgwEnXvp7tSCOvb4Gb+rPCh98jlMRpMv9IgYw6dreg=;
        b=jGRrlObMkSLSLBqagx0ANnOaemXXA2aJez/S3bSj70SH6oXRjW7OqJesl9zQ+eil9i
         pLwcxUoK2HLSNrCN3CwWyDESAqwYJAxkFUQXWMO9vp31wc/Juy7hKGALMaHj3EXvbskv
         QbBGmP+SYMGdOSduV6X7yQjMAN8ASHpXD3r5VoGpU2ue5husfYTSkx5JdRIC6UmO+fOT
         syeT9tbK4q6p32yNZvKp2gB3W3xfhkJWILiO73nZZkBuxLVaQQbY4kb+bP1XqWTn00EH
         ligOYvo7k/I/qcQXJ4GOB8WUqUJkywNJ0X4or8IQt9K4THqb7wcrkKClKK3qMTWncTpg
         Y7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097768; x=1738702568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGgwEnXvp7tSCOvb4Gb+rPCh98jlMRpMv9IgYw6dreg=;
        b=k0L8s/mVDa3FqfE/ofNPSm0yydMO/IFdWcbhmQ4G2nI9q4GVTDiu1p4+4Usm3MlDWm
         2DFkMoWutwI+pxjlXIx9iIT4DRnsD8wMlAhbpUR3lOEQefpztvz21cbesN8nR+XNBSBl
         VCuMxb7pOUQWdayj85xxYJaGgOZCmhJLRXHbsl3JJtBdksdNPE0EVlY+uI1kbdKPEYv7
         gX7/sXQMMw/z4Zn1fG01EBoSSQI0eqL386IAglZkirOn3Msez3G88Ku6kc1WoorkgnzJ
         KT+asPcLni0WzRwKwlAbZsmy0GXJeKTw74PDTW9ycOiBsePH2Lh7kvSm7Y+do7GJDAeP
         En4g==
X-Gm-Message-State: AOJu0YzzhCDz2CmTGmHsu/kWgBjunTsmiB2jZYUIikquPDOvHwdVBFFZ
	5BUYaTo7WVPHd6iNCCzDusHlt0jiRiaLgd3dZFC+uVhBRc0h6rmNiAsAoA==
X-Gm-Gg: ASbGncs9Q0tJOJMGca8wU0zlB31Ua+5vR2JjuFhrJxaqNrgwnYad97waOdMov9in1x3
	U2axZRZNT6y+Ykc9EtM1WceEGHLpwNwulXOpaV92DzO1hQ4hhflOtRVAgdQXFPlddkL2vHhgqXV
	GjjHeH+aNY8RExqW8LKvzIx85pMPw3APxon8uB6f1I3+zc9YAZz60UgjozV7s5R91BFmVN0Vlj7
	wm8sQmHbsZQVNv//+hXDDH2cg7vkIHUrUqhAoPA+Kjt1CyxNLxy+mTWnYsnIEv7lwT4Jb7QWND1
	qp96I1Ks5F4Boq0OF1wmxTYR4Hzb
X-Google-Smtp-Source: AGHT+IEaJgGHifGNITQK0+bBnVhDq4TcVjC7Ecrdz67a2fWnKhLjpIA0Pk5lWsrjVZiIh5QqnN4n6Q==
X-Received: by 2002:a05:6402:4406:b0:5db:f317:98d7 with SMTP id 4fb4d7f45d1cf-5dc5efbdd51mr481720a12.6.1738097767589;
        Tue, 28 Jan 2025 12:56:07 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.145.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc18619351sm7736949a12.5.2025.01.28.12.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 12:56:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 8/8] io_uring/rw: simplify io_rw_recycle()
Date: Tue, 28 Jan 2025 20:56:16 +0000
Message-ID: <14f83b112eb40078bea18e15d77a4f99fc981a44.1738087204.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738087204.git.asml.silence@gmail.com>
References: <cover.1738087204.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of freeing iovecs in case of IO_URING_F_UNLOCKED in
io_rw_recycle(), leave it be and rely on the core io_uring code to
call io_readv_writev_cleanup() later. This way the iovec will get
recycled and we can clean up io_rw_recycle() and kill
io_rw_iovec_free().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index c496f195aae2b..7aa1e4c9f64a3 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -146,23 +146,13 @@ static inline int io_import_iovec(int rw, struct io_kiocb *req,
 	return 0;
 }
 
-static void io_rw_iovec_free(struct io_async_rw *rw)
-{
-	if (rw->free_iovec) {
-		kfree(rw->free_iovec);
-		rw->free_iov_nr = 0;
-		rw->free_iovec = NULL;
-	}
-}
-
 static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_rw *rw = req->async_data;
 
-	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
-		io_rw_iovec_free(rw);
+	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
 		return;
-	}
+
 	io_alloc_cache_kasan(&rw->free_iovec, &rw->free_iov_nr);
 	if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
 		req->async_data = NULL;
@@ -1310,6 +1300,6 @@ void io_rw_cache_free(const void *entry)
 	struct io_async_rw *rw = (struct io_async_rw *) entry;
 
 	if (rw->free_iovec)
-		io_rw_iovec_free(rw);
+		kfree(rw->free_iovec);
 	kfree(rw);
 }
-- 
2.47.1


