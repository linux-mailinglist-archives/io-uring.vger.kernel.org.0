Return-Path: <io-uring+bounces-10915-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B43EC9D6EE
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0D6A34E4C65
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FF3221FBF;
	Wed,  3 Dec 2025 00:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kOtlVtWo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4043A20C037
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722226; cv=none; b=iu9+fdUsrytxL9uUAN0VI4mlWc+UOPVB9Tjkc9FCFZijFFV5jJBUjv5Aihlg3sRlgSeo+lQgHy3WvhQtMUsN+N40ZRIiORaID5azw/Is69qUcB/6RaAPJOQtZ0plaSZMCuoU1jOPyroUYDseoDxhDUfkgjYavG7x7uoFbq1Yamg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722226; c=relaxed/simple;
	bh=97DIqpADxwI8rNvHSDsC2R8G5wA/QvIUp8FIf49KXyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tES3SYT/5eWKXEbbYun+/tDXQwR0/DcFNOKUNOLE9vwSGbGKR1uIvGl7ckeqdw+oz6m0wmcEJN4xsXjCBVKCVIg81LeNeZT/GmMBpGMXygqoigdkz9i8ZRHSf6n+YDDrvm8e2tWzxoJ0q8S1IibY2K5ABJaVqDJxFMkME2gYphI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kOtlVtWo; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so4245516b3a.2
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722223; x=1765327023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yGp5Rn0vVZm9rPFZdbWspCmo4kz1a10uQjxpXXwPtV4=;
        b=kOtlVtWoZIwzqTieQruNzHmjCVjQZpwWeuwqMck1ONLLBM2LQJaXNoU4TZblpvIfYY
         60zOJZbFniH3sRQn7wY1AOUwLk0ILBjV+o6lx4t1akcSLy4XT5gD/W4Goe6EU9glut32
         yS7QR+xD3iRCmGkbolXLhjfWeYJDchn+efItJI2VIwlYJfNLw1MCBk0OL5PkoU6a/WsT
         OLBpaLnNEUyexODxtWsN6lWEDQbLQAJE8vPH4f7u1tSB5nVneIRsomYLUOuftlk88Yp7
         B225JqSEa+p0AVzk0Q9cayeAvcGiZ6Zn3Ni76HV2fQQB5sdLpMuBOU8DAF+AqPXQBZOH
         Z9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722223; x=1765327023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yGp5Rn0vVZm9rPFZdbWspCmo4kz1a10uQjxpXXwPtV4=;
        b=heqHfXWwx03kvzlAdzh6cWzmvQX+nXkMLpZuzUbkcuJjuKlmAJYPxdlm/NB374R47R
         d6R5wjm5qIKqbfGeqOoSLuK6Uws3D3qMfnVPpTxGZt/NKNJNgnC58OkyWVAAavo/iCqe
         xoy+Xw13tuizaBR3DHW+Ql8p38ZB5csi9i3cpwqrLKA568EVcPX4RHQf9AIYgh3NQOOA
         GWJePefcjLXsqMVVM9PzhOIJRhiGQ5o8v6VNR8neEtgNtN2S1ezCHVDIb/yrCu+YqPYa
         Tr+f92VOJvUmdIskwm86okQIiQhg7JA/BM5/+ge7B1Z77rozB24V36U4j/TuMY+pec+y
         Hjaw==
X-Forwarded-Encrypted: i=1; AJvYcCV+7i9r/M1PSJDL8Hr4sQVm2lLh/S1iq4x01oAoSEXU4OBKe3heCssiGkKBIukVr5u4eN78hOdIOA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9yEXXm64su4gRIP8fqMZDxpmq9l8BOqz2Oe+LV3vCWvCSl3ne
	nCpdI9XHAMMQ46eK/7b/zfIYJCJ9SmzAx9lIPxgEq8tsOOzPezMeUcIo
X-Gm-Gg: ASbGnctr0YnDsoiThKuFQRm/DiTzojfc9F6WCw3Xj4wpbFzf/TI2buMf5WqWSPCOPoK
	3pqGE0Sv3j5NURVT3vIv5r7DRBYNrzzQi8oe5FWKjkT0V+HU99lqGmULRtlk/HfRGUbcxMVbRDs
	xEAhb8LLQAIzZ4v4QxoSfMIUL2ZWK5JmEkDLoPvZAimeqT4G6Gwb5WR8UgYQcH+2O/872j9NykJ
	KhDk8RMT/EvZQ8cG7GyjIiQ/Gj2bKCinaBlB3Y6qTS/0e1jbX4WjS+DtrBv9LAg0k8SL8hYW5aW
	ZH5trWPCrHKGOutmOkSzzu2zcs4fIU5vMgi8W85cW2SiZA5AIHX8LVgfwO+ddMcCHXf64o6ONIP
	rCSbnjbGE3XZwB40+GANI4KMrsIucxsnWUSkdr3eYUX2nOcBatcHk5hKiS7d6felqH4gBgfxui3
	Bz3aJQI2EA2i82BACblSQDG49RUdZ3
X-Google-Smtp-Source: AGHT+IEfzyUuDmBUTKReuVxyynrkEIqwQ/8OsydKJnvPQMys2Vwx2QQRIef2OHJOWYiBtSkRVA09LA==
X-Received: by 2002:a05:6a00:4650:b0:7a2:7c48:e394 with SMTP id d2e1a72fcca58-7e004b29385mr524430b3a.0.1764722223550;
        Tue, 02 Dec 2025 16:37:03 -0800 (PST)
Received: from localhost ([2a03:2880:ff:12::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d1516f6c47sm18177223b3a.18.2025.12.02.16.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:37:03 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 20/30] fuse: support buffer copying for kernel addresses
Date: Tue,  2 Dec 2025 16:35:15 -0800
Message-ID: <20251203003526.2889477-21-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a preparatory patch needed to support kernel-managed ring
buffers in fuse-over-io-uring. For kernel-managed ring buffers, we get
the vmapped address of the buffer which we can directly use.

Currently, buffer copying in fuse only supports extracting underlying
pages from an iov iter and kmapping them. This commit allows buffer
copying to work directly on a kaddr.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 23 +++++++++++++++++------
 fs/fuse/fuse_dev_i.h |  7 ++++++-
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 49b18d7accb3..820d02f01b47 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -848,6 +848,9 @@ void fuse_copy_init(struct fuse_copy_state *cs, bool write,
 /* Unmap and put previous page of userspace buffer */
 void fuse_copy_finish(struct fuse_copy_state *cs)
 {
+	if (cs->is_kaddr)
+		return;
+
 	if (cs->currbuf) {
 		struct pipe_buffer *buf = cs->currbuf;
 
@@ -873,6 +876,9 @@ static int fuse_copy_fill(struct fuse_copy_state *cs)
 	struct page *page;
 	int err;
 
+	if (cs->is_kaddr)
+		return 0;
+
 	err = unlock_request(cs->req);
 	if (err)
 		return err;
@@ -931,15 +937,20 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
 {
 	unsigned ncpy = min(*size, cs->len);
 	if (val) {
-		void *pgaddr = kmap_local_page(cs->pg);
-		void *buf = pgaddr + cs->offset;
+		void *pgaddr, *buf;
+		if (!cs->is_kaddr) {
+			pgaddr = kmap_local_page(cs->pg);
+			buf = pgaddr + cs->offset;
+		} else {
+			buf = cs->kaddr + cs->offset;
+		}
 
 		if (cs->write)
 			memcpy(buf, *val, ncpy);
 		else
 			memcpy(*val, buf, ncpy);
-
-		kunmap_local(pgaddr);
+		if (!cs->is_kaddr)
+			kunmap_local(pgaddr);
 		*val += ncpy;
 	}
 	*size -= ncpy;
@@ -1127,7 +1138,7 @@ static int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
 	}
 
 	while (count) {
-		if (cs->write && cs->pipebufs && folio) {
+		if (cs->write && cs->pipebufs && folio && !cs->is_kaddr) {
 			/*
 			 * Can't control lifetime of pipe buffers, so always
 			 * copy user pages.
@@ -1139,7 +1150,7 @@ static int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
 			} else {
 				return fuse_ref_folio(cs, folio, offset, count);
 			}
-		} else if (!cs->len) {
+		} else if (!cs->len && !cs->is_kaddr) {
 			if (cs->move_folios && folio &&
 			    offset == 0 && count == size) {
 				err = fuse_try_move_folio(cs, foliop);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 134bf44aff0d..aa1d25421054 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -28,12 +28,17 @@ struct fuse_copy_state {
 	struct pipe_buffer *currbuf;
 	struct pipe_inode_info *pipe;
 	unsigned long nr_segs;
-	struct page *pg;
+	union {
+		struct page *pg;
+		void *kaddr;
+	};
 	unsigned int len;
 	unsigned int offset;
 	bool write:1;
 	bool move_folios:1;
 	bool is_uring:1;
+	/* if set, use kaddr; otherwise use pg */
+	bool is_kaddr:1;
 	struct {
 		unsigned int copied_sz; /* copied size into the user buffer */
 	} ring;
-- 
2.47.3


