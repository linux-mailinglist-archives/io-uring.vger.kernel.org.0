Return-Path: <io-uring+bounces-7001-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF77FA56CF5
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D05F13B919E
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B36C194C78;
	Fri,  7 Mar 2025 15:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mceVADc+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921AF221712
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741363198; cv=none; b=RtH2lsiz817aaYJhLTOiXA/PUE1mGhSxWwtPGi6DerMNXdqclV+59+PntSUD3jNmqgSJh+4ZjX3/v0dTBWOqT1SQVI+CEkHCEJRFrvfuGruBEj/nYc99W9900oktWX2WxEXoz3eNFR1kNlmfecjgrBZiledUIgTOy/X0faNBLOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741363198; c=relaxed/simple;
	bh=c43Svu1iU7sMmAeZKrfwQmrejzQqcdDB09RJDv98Y9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYRkL18FL7f7MF0M70dB3HX8ULYRA5BMsmXiBLCzN4W3WrAO9OcRnomCOJ1JYMBMV8Cioxq5Lhx2biay0H0sOkg+fMRaIuVwjrhes8UV8K4E9TaSv1RvbblvQrYLyHcwstG0xrHMDZ2a7OmWZXa2HNBBTm5ZsUfJ8/gDOzyVjjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mceVADc+; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5e5e1a38c1aso1142671a12.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741363194; x=1741967994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jl4Ox8E80bgKYyEccBIF1Yq4r8LoalAtGCisRYqp/Z8=;
        b=mceVADc+9y+dohvo6/nqQ1/ekZiQGiEZtfn0e/YnKZQZWEYPCLdvBh69gOkRbPz4Vb
         uciIVKNk4GwDhHP0soj7I3SK4EsHVRqmhk0DT+5KP8kIfytKXe1aH1zUc1dymrUIOufZ
         s08/UKsaZQoXFwPis6cIHES7VTFUDyIMUl7eidthtS+QHqLaTOlho+kiQfb7ms5awOKC
         cbwZg8la82WEOYoWrqfjKUo3o3FCUPIROw1xaVj+zYpNVRtpd11gnrf95Wrq91+lmwc6
         e2NBtbsKK2uppeUn+cpK4EUXeN10C9kEljQTS4uhFXLoDWVY8lgtailJPrFOb/KaBydI
         Zc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741363194; x=1741967994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jl4Ox8E80bgKYyEccBIF1Yq4r8LoalAtGCisRYqp/Z8=;
        b=HuKo6ro93g4T0ZcLnGG6yk8KNsndFVLStI/vV3CtVPN52sCu8c01t9p2fyBDqy3wlp
         RSFCOTOGtJrSYHGLTNO5ZAPGx0o+owSWR9cboZrrxosu4n5v8vLlhCYMyo4RgGWXYqkM
         VwLXWWD9TW4UbTAEl7d6d6urq0OGhMoydaC6v3d+6oMKu2ftdedGSKfH1iTl84cI7s9s
         Edl/hAotmNcBNMsTWA9L43fAuZWfDx0xL66684y+fkZatC3+Yf6ANDTZCx7v+AQDunlj
         Ne3R88IE1qoCjjvaRC3ZyJzx/JdDmY8vN9Jnjx1Q6q7Tix5D6Td1iYXgRwya00lX52Ff
         yK2A==
X-Gm-Message-State: AOJu0YyeA7UUDHoTowb06CcY3WKeD19ZmfNE+Ekt7sIbLYDl2DPOw+0p
	r3zTEALOWxF3F8yTpMENNagmhB+OZwq8RNME1PlyjKDNv7vFOuXbKu/8rQ==
X-Gm-Gg: ASbGncuyVK+Vj+gkGHdC1wkYaTFrEEWWj1s0Y8AGq0qVQ+eDCrY1oc1tZdCvVA45fIb
	L0CIt0W24H5HvWLohNCgrPh6fjbAg2UvDGns6CGjdhGcd4uzTihRDXytqLdpYU44kxzS81O2F+k
	Ih+h2G5zGJ0NEp54JB9L8VR6QFOMfmttm6QPKRaVaCkaWaBP0p5RoU0Zs9FwIB/4QWgIiZhsTGX
	Ap6serBcuxT3TpCC1H6qtxpQriPgYSE8HEvoZD2uDYXNDno/Di8EAB1NHQWHGyMhKf6xyBxe5Uu
	sHPySrEFHogUfpLkCoTAb0KSg1b3
X-Google-Smtp-Source: AGHT+IFg3ZLvzQYYHAjOpQH6c8T7mBzy21H2tATg0eYXJ7i9jqQkFzhiFBifKAmRZpYkj3UK84Vgpw==
X-Received: by 2002:a05:6402:90c:b0:5dc:caab:9447 with SMTP id 4fb4d7f45d1cf-5e5e22da292mr10298092a12.18.1741363194318;
        Fri, 07 Mar 2025 07:59:54 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2399d7a17sm297369166b.179.2025.03.07.07.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:59:53 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 9/9] io_uring: cap cached iovec/bvec size
Date: Fri,  7 Mar 2025 16:00:37 +0000
Message-ID: <823055fa6628daa24bbc9cd77c2da87e9a1e1e32.1741362889.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741362889.git.asml.silence@gmail.com>
References: <cover.1741362889.git.asml.silence@gmail.com>
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
index 0d5c18296130..b0097c06b577 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -5,6 +5,8 @@
 #include <linux/io_uring_types.h>
 #include <linux/lockdep.h>
 
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


