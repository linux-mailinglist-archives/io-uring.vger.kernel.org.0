Return-Path: <io-uring+bounces-7858-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB69FAAC436
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 14:32:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42BE44C18B7
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703D42820D5;
	Tue,  6 May 2025 12:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HO4lJZcl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3A2283129
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534606; cv=none; b=TTYoHWmFJQjrvSrNTbNZQaIlCgL4ut5SQ7LMrU6IkZHVSnGZNdGkXHeymd05Zj91KLZ3Pm6A7ojlnRmcw7nlk2ArHU/XEQZv0B1yEle/3nQVN8p/LZNnQ03mBDQOIY9SeCghllt7mp73DR77XqF7hf32HX9jx6jmw8MnyKE+2mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534606; c=relaxed/simple;
	bh=pLaRflHqHqdWQceOz6caTx0j4EJlB+3nm3piQ1AnlEg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=et2TpWKUnC9uI1k5jyy8SbXdssvybIJr3ImYYsg+12EpCucHaYcazOzmWi0D480wBukD4ZfW9lC8s/txuPEi/8LxBlW/zVTNH+bl3iHfWXRCOpOtqSRm33jiJdIYXJbqFKkLZ0+iYrI+SmoNpYpGSJgQJNozkZe5qHM4C602Gfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HO4lJZcl; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-acbb85ce788so49571166b.3
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 05:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746534602; x=1747139402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2osDlI57om4Zr3bjDLy7mJHqS7V0COhwMXyTMzM59IQ=;
        b=HO4lJZclwBdfQkHTLNGX+DK/usqGdXqdzNkFeEvBLbIJMuGLu3IBl8jK1UKJJeU41Y
         XNUocRh3e60GOMRFqTDn+M2drGlvxndhAMNsvkh9zyss+VRV/KyqnWxApfOsdn4n7NFk
         dK7t11qjbEsLiQhRyYIIKZ865V3hHWuBDbIuLgINZm8lYLnKT3Rs3P0P1Y2yPBqL2Jkp
         GbeEwXHKI63Utk10hMXVsUI53lDsEGuBUOIAfnZxqLaGRsxo9l2iM57iAjpdPY42MJxK
         CwLeFlmUBNFHx1SwgBK71YfjfejoQAs8MiN52eqQCpCVxtNccp8bg0A/Cnx6vxtcFmrf
         m9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746534602; x=1747139402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2osDlI57om4Zr3bjDLy7mJHqS7V0COhwMXyTMzM59IQ=;
        b=nMDTDTarV4PqWzQEPhcqbFMDiFXqd2c4IMvLjj/eYKNF4IxnE4Jt0D0wXhiajbvREy
         pzRJtuALHE8+cErXT1ElBTOz+P3hraqqjZ1rmx4VN8DK2TmrJ7SBrwyAjKQUm10apRuv
         N1sHZr/d3RnlpGqhnX8cFrCtUCVv+IRV09rA7FP50HgI/5FBGAWYSItqdPODVc4ylh2p
         Z6GKqymC9NfjCLcycJdAlK60CYprY4Hq5A9g0PBPz6gfhNCyU7/RXRv9lcxCogAw76SY
         AsfLDPQ98mNxPJvHH65/gC2zUJHb834ZScLmlIa3XC1TbQcU+Vyt1a2GWswUX/9qzJtN
         9q9w==
X-Gm-Message-State: AOJu0YzQBtXNFPU9h0aIihRdJ/YE+/T4RDV9BRr7dalajYuwdEU2XTcE
	PHO4MFiTD6CivASn1yyleDmw5TYwDirGU4+hlfcAFA6vzpCnm83x8NscWw==
X-Gm-Gg: ASbGncsP9Ox9ZJJe2rUbHA1OdKbFUgZToQfGgwE5pDKFuOSXVA3i5PaxFz9Yz1WOgb2
	M7zil9IFO83LzZGx/n9Z94R6f6wT42569OBVPyv4Vmrd53mTnH65fYsa/jTXIHEhK2292bNP4tE
	2kr8KWfmPVeHFKqX2S3Mh4wpYTbgf/LCiYpOIfXJazFJB5wXSBysS40p5uVovkYQR8/J6Y1FqJh
	b7J742tNMfOY3an9ubtCdI0vI/awHb+BmITfnSz+SZbxtFtV6k+qg8qbqYog3QFTuGkKkE0OVUa
	V1Hxz8JH818a0noefjo+q41B
X-Google-Smtp-Source: AGHT+IGfhx3lxxkO5pbAZE03wmaUO0A4I1e5hNNJl8oXSpfEMQUymPU0r7m3CNatux7vAArkwLa4BA==
X-Received: by 2002:a17:906:7311:b0:ac1:e53c:d13f with SMTP id a640c23a62f3a-ad1d46dd5bfmr211921466b.50.1746534602153;
        Tue, 06 May 2025 05:30:02 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b5bd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad1891a766fsm707714566b.69.2025.05.06.05.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 05:30:01 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: move io_req_put_rsrc_nodes()
Date: Tue,  6 May 2025 13:31:16 +0100
Message-ID: <bb73fb42baf825edb39344365aff48cdfdd4c692.1746533789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It'd be nice to hide details of how rsrc nodes are used by a request
from rsrc.c, specifically which request fields store them, and what bits
are signifying if there is a node in a request. It rather belong to
generic request handling, so move the helper to io_uring.c. While doing
so remove clearing of ->buf_node as it's controlled by REQ_F_BUF_NODE
and doesn't require zeroing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 10 ++++++++++
 io_uring/rsrc.h     | 12 ------------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3d20f3b63443..0d051476008c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1369,6 +1369,16 @@ void io_queue_next(struct io_kiocb *req)
 		io_req_task_queue(nxt);
 }
 
+static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
+{
+	if (req->file_node) {
+		io_put_rsrc_node(req->ctx, req->file_node);
+		req->file_node = NULL;
+	}
+	if (req->flags & REQ_F_BUF_NODE)
+		io_put_rsrc_node(req->ctx, req->buf_node);
+}
+
 static void io_free_batch_list(struct io_ring_ctx *ctx,
 			       struct io_wq_work_node *node)
 	__must_hold(&ctx->uring_lock)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 2818aa0d0472..0d2138f16322 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -115,18 +115,6 @@ static inline bool io_reset_rsrc_node(struct io_ring_ctx *ctx,
 	return true;
 }
 
-static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
-{
-	if (req->file_node) {
-		io_put_rsrc_node(req->ctx, req->file_node);
-		req->file_node = NULL;
-	}
-	if (req->flags & REQ_F_BUF_NODE) {
-		io_put_rsrc_node(req->ctx, req->buf_node);
-		req->buf_node = NULL;
-	}
-}
-
 int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
 int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
-- 
2.48.1


