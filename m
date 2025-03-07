Return-Path: <io-uring+bounces-6991-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B70BBA56C8D
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:48:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F4F33B6630
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBF04194C78;
	Fri,  7 Mar 2025 15:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jfHIaye8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C9221CFFA
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362504; cv=none; b=i+ywdgf2OZSGO5+SnWxgJKhEwVQA3nwbF9JY4bltTPEmPoCc5NQkjLgWZ2L7e5bGCq2vYgJpo+GjDam2/a44VrSkuFvyINaecEc5HJ8SmCL88swg4efWrRFRqVcJBZF5YMzl4A2vXM6PkFSJy3vlnn0mk5pq1OvTjueI9mrEqBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362504; c=relaxed/simple;
	bh=4sK4VkwDijMad+gj86h50HxY2xUtZTdkNgwm9T1N7Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRHJYHIrdGamNbGBDPxaow+RuNW7YeU1og/xdTf/MlQHIWhYj4fL/LT/3dZf7TkITvELENn9UZDhbmubEl25cpBDGZmzRZPSpAWVzvamwCHV1LE9NYHZ+BqUJ4RRePitSmIRUcGtfw1wYbqlkNFF7NK08wlJ1hydmZ1KW153wIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jfHIaye8; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5e5cd420781so3316298a12.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741362501; x=1741967301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/9RNEb6QyHbVKv47iIof+34KhXOtpAV60Dp/7krGt8=;
        b=jfHIaye88tdXeJFJmDuQveGfse3Z2im53OUPGAYXgtADVN3EqM/NfIc1J11633lI0r
         R2ZkjzQEx416PITj3jzNn40jht/AjnYa7Gjf0ysDuh/TKQTxV3e9hHmUlQ/jOVALkKJ3
         3j+PydbXuQZbLrM2tP/DPKAMfhp3Y8o/pkrdF4GFOJGKevsJS7fx4YRxzjHGyW4M3jiH
         YaGRm/zBP+rPC2aXqcPnbg5PdoHAznzYqezaTTJ3Zb4XUb1W6+jte4QhNsCrSwFIruN8
         9AyQNDLthhQPBzaMiT02LurVreAtwIes5M6qdX/0fbW4d9U5i2C9UqzWmr4hwbIjCaL+
         IlyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741362501; x=1741967301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/9RNEb6QyHbVKv47iIof+34KhXOtpAV60Dp/7krGt8=;
        b=lPmgk1gpTA0hMRz0NOPBQ4YoIVrHwLqVOOjbZnsZpU1uqHbtKZOmOgURf85+jkt4QT
         CbJXxK37Iy1S9VezTo467MNqn1HFzx0BKzp1iYrPZemvpseAi4+o/hJbWGB3DxB5PJV6
         5vr9nkteWkAjyF2EgEi8lO0Sx0YyjGDJGiNhsuoW7CEspVZL9FyYVmcJqveWEqyJWrd9
         gFW7JlLmw5JPTA45vHEDrCfkF7ExpBfAea55nJx8z1Np2lNuJI9+1gIrqGr6GMseISAy
         BFLBweG0LtoiG+TRJFhaDJgTmQAI/5qT78/qURqQ9/TTXObEqIFK9bp03XAQiR8Gsto+
         i+Gg==
X-Gm-Message-State: AOJu0Yxa1Jzz60GLflYQZ2kBTcVv5gr+ME8zPklP+MS0f0RBEwHsu4IH
	35+/53k/S4Nk6UJR0KTWeUuToxYdH2uia1cj5TmeZjrVfTGadxX7cIMEjg==
X-Gm-Gg: ASbGncuY7B/chsYoiUUY6mllsSpGhH99otbt+Tyc8hYvbezYzItbt1nnOxHHh8qqrMh
	DP73rvQeiaddiRTllBPDgANjlxg8NfMzXr6eZVaT4QEA7VleNvZusxE/8Jhspxmhi3knmCOIiW/
	vjaI+aI6eCvng4PelCYojI/jnYJmtQjZ88k0cvr+iItZR0uzIE6lUSfx583Q/VD9gA7FMt7rhaD
	h7K/Yr4X++yNpV7lFoa/kYLx7iilOS+yMwxmnbKqMU2+f2AgV7C6xEUNhOH6vISR9m/CTCs/aUM
	wh49lOwOeo63/iCuJZk3MVv+zpKz
X-Google-Smtp-Source: AGHT+IGQdtbNt3VBFgp28EyvTz9nw3WDbp4yK2Mltnhd6abQAF61FPdAFCIAt1sHBjkYadrIabzxiA==
X-Received: by 2002:a05:6402:2346:b0:5e0:60ed:f355 with SMTP id 4fb4d7f45d1cf-5e5e22d98dbmr3955446a12.18.1741362500788;
        Fri, 07 Mar 2025 07:48:20 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:1422])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c766a033sm2665591a12.56.2025.03.07.07.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:48:19 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 9/9] io_uring: cap cached iovec/bvec size
Date: Fri,  7 Mar 2025 15:49:10 +0000
Message-ID: <097f9237221826b1eebf5b03336be176fd2ee0ca.1741361926.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741361926.git.asml.silence@gmail.com>
References: <cover.1741361926.git.asml.silence@gmail.com>
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


