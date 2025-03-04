Return-Path: <io-uring+bounces-6942-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 208A2A4E50A
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 17:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1693F19C46B7
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30614298CD1;
	Tue,  4 Mar 2025 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JtwB7r8J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EAB298CD4
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 15:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741102788; cv=none; b=Vdk/+lOqn9ig3mO/89BhuRV/93byq+E+Iryz17NLNE3ar4Zy2SXOC6dQk6mSXtYVOGmS20vRtAdmCt0UzjND2kU+PRX285Hbxu3orhF7QYzbW+EDtwa/yX0/vofLIciGDbhp+Ztu+uh6Qftl3YawlIffAZy7dWfaWK0gad3fLoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741102788; c=relaxed/simple;
	bh=4sK4VkwDijMad+gj86h50HxY2xUtZTdkNgwm9T1N7Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvRmDzcK/q/CE+9EY5IjqrgYaXcWbWz2wq80fFBg+acOykybuXvcWPP1B7P7XwWKNia8T/xnt92cYGXMr07j+DCRKkA5fc6XFyln7D9awWUB+K04tx9I1WX2SzI81LsHQrfdQCmW6Yjq7HZxvjDgXWloL/gu9o8Tlo/PCGqwAYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JtwB7r8J; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-abec8b750ebso1006558366b.0
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 07:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741102784; x=1741707584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/9RNEb6QyHbVKv47iIof+34KhXOtpAV60Dp/7krGt8=;
        b=JtwB7r8JDYXwN3nAIAdaUNEYZD4O83F8dsI/+r60a7HCqNuSqB9DBrbwD4kAsRbi60
         aK1lt0VJaIKgBdpmBFt49O6WW8NUks77TucrqqtezPjraQsr6Wv+mERoWW2h2/IM+tJq
         GExyr31a/mXnDFv0YDGC7oyRI8wSb2oDn8vA9K7t2dbSbv7FoOgcy95njTUwjIGBkxGn
         6QYJNFRuI4z5iKkJJB/OfGEeHRYta5OlzsbbanqSRIlp7+GiFO6zEPP+gdH9DwZvrgl1
         XvABKPk3grVThHpOsXPfcWfDJQ6+7dzPxqSL0kGgJ9SLP1WO7icTYgmTAzxv2Yv78Afe
         FYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741102784; x=1741707584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/9RNEb6QyHbVKv47iIof+34KhXOtpAV60Dp/7krGt8=;
        b=MYbzZ2O12ot+D3t9RSOxmputf1CVlYm+4vcDGjdeYh3d+4kA1aUOZUmjiIK1Ah4YLB
         SrfXo8jPk2l35MyGlJ87azpp/CAnwOvQghvoIsP/ypg1DbPQVZ3KDr/WZYOrTbK7G28n
         70tyfBI+bKlN+Ael0KZYOEr9wgKXQvBJmj8fzUUVL4OCKwttwKGabezJtfiIEng2QgwL
         ky/RiE433aa/f3iTP0F683zhfV7jHbzU4TJ9MUymAAEHQz55tdW1wTu3bAkIMys3RI7P
         AgJopyzxr6vmnaEBiYOJIxHcCUXbLP0g97OynrKUMd/mLrjdNhJeDeRa8cWTWmra/4rs
         Epwg==
X-Gm-Message-State: AOJu0YxcbjwDXLlww7fGxE9cxRFnZPwepjAzX/8PVhD9OuwAaYu0DJL8
	Ba4uMfW/KqDy+xkZsYlsGZyKinXMb7BjzZE/BUT2/EHCIUCbeyWba7M4Sg==
X-Gm-Gg: ASbGncsK96/6IhQB/GN9Sb5EAih6z4tAD7KGzzwp5FCvZq7qPv/guqotg7Nff38G/Sd
	OuuhtHiJLBEhGcBNRFBWIRss2vYfh19zCnC59RKXiNpCe8Y8fS22cy+BRs0n0LwEVZciNcN31v9
	lB9xDZuxreD+GkQjTySsI4UxOeaDgmyx2szeSmCjvLklogqqO8+UlyIWOXvblBSDI3SddIQIiDy
	K58NbAvI6cWGWdPwKoNV+2njSwTtz0rwH5MkzR2SiBdRqVjKGq6VHsna0X53CuzvsUMkeT+S81h
	/zKR3PqeCD4osc+qES5858XdqiSC
X-Google-Smtp-Source: AGHT+IE4Wu79UPtv3RFcvZpLKQktzC0n27BtsI2xx0Ldv57Nrue9ofSuxEKYxV39rLcjISZiogT4Hg==
X-Received: by 2002:a17:907:6a0e:b0:abf:4ca9:55ff with SMTP id a640c23a62f3a-abf4ca9583dmr1527233466b.32.1741102784064;
        Tue, 04 Mar 2025 07:39:44 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:3bd7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1ecafa17fsm168420966b.162.2025.03.04.07.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 07:39:42 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH v2 9/9] io_uring: cap cached iovec/bvec size
Date: Tue,  4 Mar 2025 15:40:30 +0000
Message-ID: <50ffecb2f87a3b80300d5c0d8482e20ed897ccd9.1741102644.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741102644.git.asml.silence@gmail.com>
References: <cover.1741102644.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bvecs can be large, put an arbitrary limit on the max vector size it
can cache.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c  | 3 +++
 io_uring/rsrc.h | 2 ++
 io_uring/rw.c   | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 5e27c22e1d58..ce104d04b1e4 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -152,6 +152,9 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 
 	/* Let normal cleanup path reap it if we fail adding to the cache */
 	io_alloc_cache_vec_kasan(&hdr->vec);
+	if (hdr->vec.nr > IO_VEC_CACHE_SOFT_CAP)
+		io_vec_free(&hdr->vec);
+
 	if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr)) {
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f1496f7d844f..0bfcdba12617 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -6,6 +6,8 @@
 #include <linux/lockdep.h>
 #include <linux/io_uring_types.h>
 
+#define IO_VEC_CACHE_SOFT_CAP		256
+
 enum {
 	IORING_RSRC_FILE		= 0,
 	IORING_RSRC_BUFFER		= 1,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index e62f4ce34171..bf35599d1078 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -150,6 +150,9 @@ static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 		return;
 
 	io_alloc_cache_vec_kasan(&rw->vec);
+	if (rw->vec.nr > IO_VEC_CACHE_SOFT_CAP)
+		io_vec_free(&rw->vec);
+
 	if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
-- 
2.48.1


