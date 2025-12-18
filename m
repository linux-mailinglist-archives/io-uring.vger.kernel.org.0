Return-Path: <io-uring+bounces-11198-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CF86CCAFF8
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:48:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0F3FD30B195E
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AD9A330320;
	Thu, 18 Dec 2025 08:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJW+NtJt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897113346A8
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046905; cv=none; b=kJLk4IX1ItO5IS5XkLvVY84b1h4xVVgCbMuT3dnMKNtaxxbpTy/5p1ev5si+iJPDh98mkWVQ9vG/ek1feCVkxMjeO+11Xl2Xl2mkk41gW4VBbbh8AlgHUtXMnLDrnbqS0KNhkqN7c4jB4KK52FfRsl1CN+QHPyJapzVeyasaGlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046905; c=relaxed/simple;
	bh=JXMvn1NMlj4tmOrWG0zkpmdnP/Xw/eEoEIkqSGKLsO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BK16SrdI4qUxg+z3GWgxjwks2K7y8vyKsRZS909RV2AToPUoi1WVoBzM3sovzR8sZML0uEyJOeHCrWEZXwDbZJR/aF4aiGib5FcxjSppFgrf3aayarTq1oT9CIgT7QQssvrxWgciX1lhA9pZLa3w/RUilqPiFeqP5W20JcuCppM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJW+NtJt; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a12ed4d205so3448465ad.0
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046903; x=1766651703; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WO1WrE07m4/ps4EUGl0M4D/d+Qo8L6vNQWiuLZIYXDo=;
        b=iJW+NtJtwh9sFFeUAWBjcxyS+O9+2t5o23Pn0HL3rl2kQD6HPaTV9JixYVJn8ZfDdx
         8evzVZJyBcFPfgU3cY4kk0GO9/VannJeqNBS2110uXdQxI5w6z6kV8c7mGhT7oCl6dnT
         M88SzArq0qjSCK/Hr7h7Z8DJWRhhwktri6jDYeJfx/97VybnOIVWMOzYXa7XxSqnI6aO
         huYXB+4DVIe/sV3p+taiVknKHEzh6VVTmJSHlJ9s8gdzuGjxP/ekU3AJU86hvIYPDpgR
         6gJ3MhXyRcS555EYrVcg9IPFIBDpz1VHGmjZdyoo8Fc6gDP00DC5/ZWaKG2m5+IKesDK
         2VaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046903; x=1766651703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WO1WrE07m4/ps4EUGl0M4D/d+Qo8L6vNQWiuLZIYXDo=;
        b=ZxUU+uAbTwWMeW6IF0NB4TgRWQI4le39kza/ykvjtiz5Zx8sDeQXXzxwvAVk7hMo1Z
         5v+vM4ihQ3gGGpRVv6jDyhQA6iaiuLESFAwWA10/4xirxYKXd1k2GGDsSfSgYPBeX+NQ
         0YQ2paDlfpYY/FPeLu79HV0dWL/q5gf+UhC7QLYPgBI/H1oJLEClcageNdzraRzmU5dS
         dQwC2CyUXza+clGKmm1eIF3BlUy0wZAsj/fsfH4nE/E0hJUm0norgxkXiA5d1D8rnYNV
         SCG/34e2aGZt8treHkFMJ1bF5XA4tBfzafX9zSOCpT0X1UEbo95UFHvscDxGFh9+5spW
         McUA==
X-Forwarded-Encrypted: i=1; AJvYcCUp11H3TGCMX4AzbNGX0C1t8ENC86VsZfk0Uwd1L/cDaOXs1nEap5N3DDn3orKl8IbzmMlvCU6QFg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyB+B4nbhOzZ8lHaF67Mn8IBdE+xE6xh3SBGx0FgiKlIIbrdL5D
	Ei4lhZNs5pc/FoW7kP6Dyd2rvXTqRERSFXELqkx6Qj6rCoK7RHr4Li70OqYbhrJjRpI=
X-Gm-Gg: AY/fxX4zd3TM5NfVknNtng8ai+Ggmdl1Wzsoc2dQVcO7nGNGPeGRjUjcFM7RYj771Ql
	ci3vZyyiZVsV4zkYICehUkDJFmm/S8/znqMV1VFoZhHwFC/7ctJMQn5ONToIRjc6InsKWUHowRi
	mjUtlPxQ5yjT8Su6Px1d3g6hMFYxeYHdGHRj2TJSC3+PTJEuCOdMr5KOx8CkfB/Pr5E3ytsa2WH
	H/dkpIch4La9KzbwtvWvcbV9XpR1Z92TGoacpDHVASGXpJeu8mYOqKtsW904fYNLXmQrcDZtBY/
	KdunQHWjKaN3aGwX/uHuebF0IQ4HXPH6r2txh5EUDRoPVgLRODMnfE8bb3bLE7J6HL0jI78TccN
	UodZwMvyhybIIXdoG0XcD6EaQR/RWG4+7EZXT1kZFepbAtouk+aFfJPyqSk3d+ix5pHTp4yBesb
	uJ0GAphg8bdjaHUnU3NCjV1Skr1tQ=
X-Google-Smtp-Source: AGHT+IH8gkkTwp8YPa+LkoM3wopB+gBYFIKVpM+V2RfNoNV9Ryp2Tzknos2ZVIGVgmGQwlizhtYNUQ==
X-Received: by 2002:a17:902:d50c:b0:29f:3042:407f with SMTP id d9443c01a7336-29f304249dbmr209086775ad.21.1766046902814;
        Thu, 18 Dec 2025 00:35:02 -0800 (PST)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d087c710sm17312585ad.6.2025.12.18.00.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:35:02 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 18/25] fuse: support buffer copying for kernel addresses
Date: Thu, 18 Dec 2025 00:33:12 -0800
Message-ID: <20251218083319.3485503-19-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
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
index 6d59cbc877c6..ceb5d6a553c0 100644
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


