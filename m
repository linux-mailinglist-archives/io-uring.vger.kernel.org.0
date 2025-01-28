Return-Path: <io-uring+bounces-6164-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D18DDA21351
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 21:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08BE37A3D4A
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 20:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF4A1A841A;
	Tue, 28 Jan 2025 20:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f3TBgF4H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5691E0489
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 20:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097766; cv=none; b=AkEQCOIigSDOg8WX3sZvZdl46Ik5/i6XwjEIF8xdhjx2ufY65olefSMWvTnrgQ95Fs0Cn8Nc6q34iwryyzHAb1sudQAWX5v7PiinVHRZO1P/w+1s5UcmEyb9jM2aScFirfX+L1ZuR2FcLjMtgVkBsVWM/wIP0jZm73TNHoQT/QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097766; c=relaxed/simple;
	bh=EkZFy2j3c7rYz8uJcjG/8n8nC2Yf9BMkLFWNpiMaoO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTcmk9urJXoMDfkPTZ9d0vgvE5XkGaPYE/F+qYkjh8tgChIabBnb3I38E6ZClVjtTePlm59wLh0FGca4qTCfIx3gGMkU6NzaJpvshSiOjyvBxSmU3u+Ou4NBIOE6iL8PqaQLdQk7fgGXA8nsKAMMCgGMT31NZX2v7twNeKwkABc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f3TBgF4H; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d4e2aa7ea9so11964142a12.2
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 12:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738097762; x=1738702562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5DFEKr32NfFxugbtWp3irPHP5jvpDgP3PgoSBsGH254=;
        b=f3TBgF4H4M/FrAO5jWTjtUV7YdVnX2vhk3PGU2uRpp68t1iBPecj39MgV/OukEAOje
         jykcB5n3pqTglKITPSJttQ6cFnCrIz7+T+STQywTzzhY93Mwuc5pNmIu5fDndoOpgu+C
         n88Uf+AjaZVeF8fSiwdb/FnSKByZY0Klsib+fJgQb+oJns2FzMrmXHVX5AGYQ7cu0+4T
         bQTSssinWQkf9TOBwfq9b21O3bgyAuHVxSJdDyb5VuHDT7HbxNEjPdXmMsu06MGJoDwV
         9Q8TFFDvlumr1LbXTspykRKFenLtRadX1JMVouHoToVwopPbRSz0imybPmVdrF25NPMQ
         apTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097762; x=1738702562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5DFEKr32NfFxugbtWp3irPHP5jvpDgP3PgoSBsGH254=;
        b=jVSINcAI/X/MaUxEEXj/MW3Urv7jm8lhaOyF4C7BD9gE7RvIRqGmZ7j2N7H08ES5Bx
         5o9Om95vsBOYRy3KEv3tlS6hswGP19Xmqm96pzBuGeq/2FPS+SuqmC2s9/B8PN592BYE
         DDxnhYIG8SDq4f9FW3HTszeR3snUvuduFtkOu5zceRIQUUee4ISmA6B1BPH4KFpBiRzi
         MyiaZ+Q3DQyZmSktosXYmQ0tnhUOKgvq5MDo4MgrnmrMxNfdX/pRW8e9lBgKN/N+lNsQ
         biWIrIpZ1tkXM/rKogcLRXVFmWX8CPxtDHmZk/PDVY4wc6riyrjJAoUg9AqVS6yTZs7N
         xi5A==
X-Gm-Message-State: AOJu0Yy71D1p074g6eIoux2UAMVE6zHPepFS9bkbrCgnVhByW2EjFPzQ
	tO4F4a6CWiyjtPWFTNNl/9W0hj+EROTDdIzHZXLPwAv23w++p6bXrO8rIQ==
X-Gm-Gg: ASbGncvlhIJo8yQF+BSYXOd0hEnn9EidUL1RQ3zY5lv/M9D0xf9wm7E4oevER/Ml0/A
	8w1PwyrGMQSgJ/WzVz93dnDyX6l4RYqoq0EBL/M94E3zmfX5iZwMTTfEM5zcUfwRpP8LK/B+3y4
	otcyWzvJTpRm87RpR2oAWUr82ubal+gQJikkKLUntl/I/4I9shKckIR3jOXqwWU1cr3MCqxry1z
	pe/nDi3GmJMKYbrqnho9u7pTEemyhV/IuAd0/57LKNEt9dpeRsjlno72WI0k18zQE9gE9WoncBq
	/+B6BDO/KAnLoDDxK35ammO9t0Su7whe9C1K/ao=
X-Google-Smtp-Source: AGHT+IG/hftF153ghHjKiKYXlzPpVJwkG0vW8O1xb+kn7QJvjwR1mkXriUu7a0OWF1OCVwXg6nAIQw==
X-Received: by 2002:a05:6402:2683:b0:5cf:420a:9 with SMTP id 4fb4d7f45d1cf-5dc5efa8e53mr472857a12.5.1738097762209;
        Tue, 28 Jan 2025 12:56:02 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.145.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc18619351sm7736949a12.5.2025.01.28.12.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 12:56:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/8] io_uring: add alloc_cache.c
Date: Tue, 28 Jan 2025 20:56:11 +0000
Message-ID: <06984c6cd58e703f7cfae5ab3067912f9f635a06.1738087204.git.asml.silence@gmail.com>
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

Avoid inlining all and everything from alloc_cache.h and move cold bits
into a new file.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/Makefile      |  2 +-
 io_uring/alloc_cache.c | 44 ++++++++++++++++++++++++++++++++++++++++++
 io_uring/alloc_cache.h | 44 +++++++++---------------------------------
 3 files changed, 54 insertions(+), 36 deletions(-)
 create mode 100644 io_uring/alloc_cache.c

diff --git a/io_uring/Makefile b/io_uring/Makefile
index 53167bef37d77..d695b60dba4f0 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					sync.o msg_ring.o advise.o openclose.o \
 					epoll.o statx.o timeout.o fdinfo.o \
 					cancel.o waitid.o register.o \
-					truncate.o memmap.o
+					truncate.o memmap.o alloc_cache.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
 obj-$(CONFIG_NET_RX_BUSY_POLL) += napi.o
diff --git a/io_uring/alloc_cache.c b/io_uring/alloc_cache.c
new file mode 100644
index 0000000000000..58423888b736e
--- /dev/null
+++ b/io_uring/alloc_cache.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "alloc_cache.h"
+
+void io_alloc_cache_free(struct io_alloc_cache *cache,
+			 void (*free)(const void *))
+{
+	void *entry;
+
+	if (!cache->entries)
+		return;
+
+	while ((entry = io_alloc_cache_get(cache)) != NULL)
+		free(entry);
+
+	kvfree(cache->entries);
+	cache->entries = NULL;
+}
+
+/* returns false if the cache was initialized properly */
+bool io_alloc_cache_init(struct io_alloc_cache *cache,
+			 unsigned max_nr, unsigned int size,
+			 unsigned int init_bytes)
+{
+	cache->entries = kvmalloc_array(max_nr, sizeof(void *), GFP_KERNEL);
+	if (!cache->entries)
+		return true;
+
+	cache->nr_cached = 0;
+	cache->max_cached = max_nr;
+	cache->elem_size = size;
+	cache->init_clear = init_bytes;
+	return false;
+}
+
+void *io_cache_alloc_new(struct io_alloc_cache *cache, gfp_t gfp)
+{
+	void *obj;
+
+	obj = kmalloc(cache->elem_size, gfp);
+	if (obj && cache->init_clear)
+		memset(obj, 0, cache->init_clear);
+	return obj;
+}
diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 9eb374ad7490c..0dd17d8ba93a8 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -8,6 +8,14 @@
  */
 #define IO_ALLOC_CACHE_MAX	128
 
+void io_alloc_cache_free(struct io_alloc_cache *cache,
+			 void (*free)(const void *));
+bool io_alloc_cache_init(struct io_alloc_cache *cache,
+			 unsigned max_nr, unsigned int size,
+			 unsigned int init_bytes);
+
+void *io_cache_alloc_new(struct io_alloc_cache *cache, gfp_t gfp);
+
 static inline void io_alloc_cache_kasan(struct iovec **iov, int *nr)
 {
 	if (IS_ENABLED(CONFIG_KASAN)) {
@@ -57,41 +65,7 @@ static inline void *io_cache_alloc(struct io_alloc_cache *cache, gfp_t gfp)
 	obj = io_alloc_cache_get(cache);
 	if (obj)
 		return obj;
-
-	obj = kmalloc(cache->elem_size, gfp);
-	if (obj && cache->init_clear)
-		memset(obj, 0, cache->init_clear);
-	return obj;
-}
-
-/* returns false if the cache was initialized properly */
-static inline bool io_alloc_cache_init(struct io_alloc_cache *cache,
-				       unsigned max_nr, unsigned int size,
-				       unsigned int init_bytes)
-{
-	cache->entries = kvmalloc_array(max_nr, sizeof(void *), GFP_KERNEL);
-	if (cache->entries) {
-		cache->nr_cached = 0;
-		cache->max_cached = max_nr;
-		cache->elem_size = size;
-		cache->init_clear = init_bytes;
-		return false;
-	}
-	return true;
+	return io_cache_alloc_new(cache, gfp);
 }
 
-static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
-				       void (*free)(const void *))
-{
-	void *entry;
-
-	if (!cache->entries)
-		return;
-
-	while ((entry = io_alloc_cache_get(cache)) != NULL)
-		free(entry);
-
-	kvfree(cache->entries);
-	cache->entries = NULL;
-}
 #endif
-- 
2.47.1


