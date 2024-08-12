Return-Path: <io-uring+bounces-2706-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7354C94F247
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 18:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 177B1B25A18
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 16:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B4C117994F;
	Mon, 12 Aug 2024 16:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GxQJBIX0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D277E17F397
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 16:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478508; cv=none; b=CZONjnE1BktFLAmsCjj24mMp8IrpdLgFMF14UJa2VnM1bPLrBgmGIMsCM0UauElrAh2mh5cVdmvtKJoJsyI+RPWv2gg7bj/Vnmyf8NR1re/FxRDQmre6b8HTmeXcMNK+5Exuvfw8cbdzl4FWnuRbQt+HLUg2EgNUH2kgDOgJfQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478508; c=relaxed/simple;
	bh=h+DYg0KgzzTCZEU3sPpXdhjTCZVbrCzwmmUrTefSHsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWlQhln2BtBSz7UpvT55nYrOyAEPI9aSgtzB9zG2OTOEIny4gU11DahnHmmFoWLwGgas4gEwFMC3b5R1RYyETParIGrVFjs2PpHg9o63GYdvXaDRsgs+158NmhNzI/43hLWyaIF5eYCoS3DgLlMH9jz2UGqh5oUQU33IAr6lii8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GxQJBIX0; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fd8f92d805so2075465ad.0
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 09:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723478504; x=1724083304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fIg273n+Py8x8jmajGQeVWLSjZgc3eapBsmuCQT+/zw=;
        b=GxQJBIX03TylLw0i4KkkP3kqyv3AnB3X82kT0b8USXPtt3B04zrZjgVrVPFQcPAalv
         eAZMuho04usc0H9P9My6Gn7yDNlU6bGakEQBXm+8xXkti+sA0SZLcdPPTmwovIBr0naO
         A9gkkOB9u1JWamrEmJd2MnXMC5hwnWnHAc1TECrtYD5uoGn0+lgagF6CJKHpLk5KAzUA
         MK9CiFFSfrv0UXiL3XmycTd+4xfdu74Ilue3EC2UK+U5z+kqmCoURtD7Wj2OmePOL9K0
         QhoIkJ+qVhIi5dhgcbZizveScf4EFT5gv7zOktbTt2xNZ8nfioZ00mqcZzqR3UQWVadF
         Ft5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723478504; x=1724083304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fIg273n+Py8x8jmajGQeVWLSjZgc3eapBsmuCQT+/zw=;
        b=c/ShyR/LRjR0CZBsQVc3VesfovNut1Y5Wf2wMPKQzGid28ilCPXU1ey4y04IfAStY7
         p8uSGExk/9Zb3o5Sa623tMSDWJRhaQqGmpDnGDAZEfYlZGayMIncXZALb265gaLOXKDu
         bKYcofHRI/HouWkixSw6nSIZ7RmegfXaCzRl/2rbKzg1vKqfoGGkCfOfb66/GG4lkfb2
         slVKieKxTEDBBmeta6sgAPQR85sIP37xCCCGNjn3Q+Yw0GMpcGwNQ3wvKcy7v+/Laywc
         n3YczzGAaJhVI/zHA4h66Nhb23gnfHblbdI+feRTB+Uab5nnIDXctYglrU1MyyucbHLW
         EAKg==
X-Gm-Message-State: AOJu0YzOai9X4JWTdCIUO5Eazz5RRdjC/nKjmofiR0eN4SJGPR6oYzFc
	8qzg897IG9sgxbTSz3rkzungGj07HaUpL1AMCunip5J3e2o0lZ3oXgKZbkRHFT7go7RYTjpJvyR
	t
X-Google-Smtp-Source: AGHT+IGfFJZgQX+0b4BK/5DFIIY5G5IP5iayvydcJmywXVBFSb9c4EN/1BWigxP1zHjvh2GUrDaVSQ==
X-Received: by 2002:a17:902:c412:b0:1fb:31a7:e663 with SMTP id d9443c01a7336-201ca13b41amr5319375ad.4.1723478503696;
        Mon, 12 Aug 2024 09:01:43 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb8f7546sm39749705ad.77.2024.08.12.09.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 09:01:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/kbuf: move io_ring_head_to_buf() to kbuf.h
Date: Mon, 12 Aug 2024 09:51:13 -0600
Message-ID: <20240812160129.90546-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812160129.90546-1-axboe@kernel.dk>
References: <20240812160129.90546-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for using this helper in kbuf.h as well, move it there and
turn it into a macro.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 6 ------
 io_uring/kbuf.h | 3 +++
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 5e27d8b936c2..64f5bb91a28b 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -132,12 +132,6 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	return 0;
 }
 
-static struct io_uring_buf *io_ring_head_to_buf(struct io_uring_buf_ring *br,
-						__u16 head, __u16 mask)
-{
-	return &br->bufs[head & mask];
-}
-
 static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 					  struct io_buffer_list *bl,
 					  unsigned int issue_flags)
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index c9798663cd9f..b7da3ce880bf 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -121,6 +121,9 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	return false;
 }
 
+/* Mapped buffer ring, return io_uring_buf from head */
+#define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
+
 static inline void io_kbuf_commit(struct io_kiocb *req,
 				  struct io_buffer_list *bl, int nr)
 {
-- 
2.43.0


