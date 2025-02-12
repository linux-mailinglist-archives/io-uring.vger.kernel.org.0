Return-Path: <io-uring+bounces-6356-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29895A32782
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 14:49:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B996B188EB0C
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 13:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 022E323774;
	Wed, 12 Feb 2025 13:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jKB7m0rZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7C22746D
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739367953; cv=none; b=dqJ+iO/Wrz5FGWSUp2a4i+sG+pBWTAXb/3ssLHd4wS1hR8Hb5AbayQG5iVt87jyDdvkpFu6N0VtgMbZyg5EQgOXJb44NdDyWFwvpLUYpKSuMCRoU8rZz1oyGLHslLmQ9c5oVZ8JZWaA2JtcApBVFaz2wfzH9p/OgYXXDrFa5Ks8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739367953; c=relaxed/simple;
	bh=LT0nKW01p8/8XoHtuYYqXKtLtFfDxP+A3AKO8twspPE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NqpuqW2o+PW0442u/zJENniV+XbjJPRr9Xik8vNSuy/UG3YtizbkU2nwjD3xmUDvUFIM8+h4y+DvI9z3kTLfdmfK2ucA+eFME+IvfqaKsos8QhxIyyBec1iPLqUL36jBqoXSTEkjoeAci6HPNrFPc8hD/j6suXOCuyZULfli0/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jKB7m0rZ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43690d4605dso46896675e9.0
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 05:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739367950; x=1739972750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UNDY+s/utgRjZ1yly4daU48bPvPdbNz0sCDBnMNCBl0=;
        b=jKB7m0rZ16oz5PI/gHUFHAdGCl3+IBfTwvY44MklxXa8fHnERznYzzDrRKk1X4reMX
         LjIHVYt8ini5x8igW7f6wU7UTZeJnKEdyYTGaBs+FoyrpEPZny37RJiYSaScWNUJkaeM
         TtwT0psfFLpO8TkuTgXb4ITe6KNGtt+W0EnXH0OGo79vkUv8rVeuboQ8RJNiQWoSF0uP
         4LhjH+Aul3TQesGQxJqqeSLTc349uuXMNOZu1CI+kN1jk7kfp/QhvuECZgZraxWeaSDV
         Y1uVmarKpHO+T2ZCNyyYEgO71bVfnSoR00Pp6McZJ5koVttwcJS4VkDj7piW/dPxSoKN
         3imA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739367950; x=1739972750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UNDY+s/utgRjZ1yly4daU48bPvPdbNz0sCDBnMNCBl0=;
        b=C+2MKT7Mo3r01LkL6zRlod8A5i8i6otY+FAcLWG5iPcz/1yDeQwYOFI0yvRRGhcBIE
         vABqEEpToEIBh8g9jo9428spLCClmWtUnLtkDzARjSOLT8JSgeQxsz1mcX2byCq2p+B9
         yFOoXGZhBnXAS80Fye65GydCpw3TjCiu29TJQ/k6AMPEB1WdjKmQRWGBl+ItUr0WPhQw
         MZ8B3SHsgl1qBDGZG9GOZ4FzUjTHP9oRtgevA6e3yWv0V2CI/39Odtvqqpl9TKHwp9wN
         uYBJp9B/bfufmKj/hOsj5biSbEFjMgJuvLDfMWSPdYjRQGE5903HM58ss0dqgcr0HfM7
         B+AA==
X-Gm-Message-State: AOJu0YybkBp0IJZUMrv+n0sE0DISY+oiBtnRXlrmbsD+MlrnOkWehJhB
	44aCerbkXUsYxGZifqdD3QkZklDFJaxE2UHmr097bxrGr6CIXg8hkE29qw==
X-Gm-Gg: ASbGnctAQYKoHckKqAu6blubZm5rEruOPNGqSLuJuXiOXt9YYjZpKBzZQUik/bmd8nr
	rArkPtLHuEV49r99swqjJwqknSavptR3QxClNRqX6ZfbIto/YnMg9LdmUhwcUb9yXAvtpn6riEl
	4s8taW7tSbkLjc5OBVkBNY/KsPmprJS8i+seHAZ5hP9yk7EcJNjQMjIbGmj6I2BszdzH5VDzQu0
	gfMvFDsijgT45JRzfBHEHxJjXiLgA5WRQBtEoWim7VjJ9h5X6o/UfkONCJCin7Q4H0TRCzw9Woy
	oZwJmO7kQApw8DwO/nFxRVfDUpK3
X-Google-Smtp-Source: AGHT+IGxsemkKAlmFrRF4n3fK1Vfv+dzP7jOhU93eiK4qz1L22/SAwjuUGuERzqz/AuDZqj1dEGK5w==
X-Received: by 2002:a5d:47c1:0:b0:38e:d4b3:9454 with SMTP id ffacd0b85a97d-38ed4b3950emr1345792f8f.34.1739367949651;
        Wed, 12 Feb 2025 05:45:49 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a1aa7d2sm20454335e9.25.2025.02.12.05.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 05:45:48 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Pumpkin Chang <pumpkin@devco.re>
Subject: [PATCH 1/1] io_uring/kbuf: reallocate buf lists on upgrade
Date: Wed, 12 Feb 2025 13:46:46 +0000
Message-ID: <40d7284c871172f948f490a92c59a9a50a9ca3fc.1739367903.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IORING_REGISTER_PBUF_RING can reuse an old struct io_buffer_list if it
was created for legacy selected buffer and has been emptied. It violates
the requirement that most of the field should stay stable after publish.
Always reallocate it instead.

Cc: stable@vger.kernel.org
Reported-by: Pumpkin Chang <pumpkin@devco.re>
Fixes: 2fcabce2d7d34 ("io_uring: disallow mixed provided buffer group registrations")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 04bf493eecae..8e72de7712ac 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -415,6 +415,13 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 	}
 }
 
+static void io_destroy_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+{
+	scoped_guard(mutex, &ctx->mmap_lock)
+		WARN_ON_ONCE(xa_erase(&ctx->io_bl_xa, bl->bgid) != bl);
+	io_put_bl(ctx, bl);
+}
+
 int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_provide_buf *p = io_kiocb_to_cmd(req, struct io_provide_buf);
@@ -636,12 +643,13 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		/* if mapped buffer ring OR classic exists, don't allow */
 		if (bl->flags & IOBL_BUF_RING || !list_empty(&bl->buf_list))
 			return -EEXIST;
-	} else {
-		free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
-		if (!bl)
-			return -ENOMEM;
+		io_destroy_bl(ctx, bl);
 	}
 
+	free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+	if (!bl)
+		return -ENOMEM;
+
 	mmap_offset = (unsigned long)reg.bgid << IORING_OFF_PBUF_SHIFT;
 	ring_size = flex_array_size(br, bufs, reg.ring_entries);
 
-- 
2.48.1


