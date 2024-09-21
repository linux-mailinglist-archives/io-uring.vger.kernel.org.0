Return-Path: <io-uring+bounces-3251-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B3097DC10
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 10:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB7A71F22188
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 08:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51426149C50;
	Sat, 21 Sep 2024 08:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K0DcdNG0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DE6154425
	for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 08:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726905809; cv=none; b=H3NGpZEXnn+t9V2EGOACSuDGBDuVDzDyzok0SCWM4Ku5AyPDfPQdyerY30pOJekcFtlTBYIvh7t+BEsw2DXWELAuul9UBlUxYjzRGqMJ1Rtzqc1V20OYsBygzrzpZTFTmXigfmw0vzQ33GcyVDEW4saqKQbmk59lZii4Js4eRPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726905809; c=relaxed/simple;
	bh=YU3USnm0oLLxbM4stWZB12POZPM9SUIUJtu8uHTBrTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owXcOBvHq0cF+xLtJxs2MD4VeJcA5+hTD+w8MhgEROoILx2eO7B7MMPVHLiFnNscrVMjNqUWx2RtiaRmssozUtoeJvkROtE3modEpevjS4M8/svyEJFapOS4m+p3/F1cUZrAquduoSaEGAtjTczsXkBranWxWkL+cbI9XdKdkT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K0DcdNG0; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42cb6f3a5bcso33812645e9.2
        for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 01:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726905805; x=1727510605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9G6hzmtkZZlkSzxwyO5DL96eqaxvZuai6ihXU9i9Xao=;
        b=K0DcdNG0/Ft0O61qPsbx6x9e0IKtoIj5Bi22c6zKUq6G/2sdAQFPFn15zqdBj3NSPM
         3XtPcGoJAhDPKFShcOLwaFaZRb5IjXFEmpZSN7us8vEMoh++pYwc0YpTUB+HPO013qU2
         lRykcwhvl3o5bBCOu9yDMYuydEgNxFOJpbRwf/wQwpaXPm8p0093w3qRyOmBeG50kiUk
         laB3uiQ3viERtjxMjGIZ5A05GWdFNiiRnen9o8//mxBuWo9/u2GJE330CH6tzmmAv4NP
         1W8huo0R+J13lBpIT27yCI1tkuoOq1vrWKQ44AkygL4Jee8B5WoydV5r7u9Ki1Wopepy
         vY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726905805; x=1727510605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9G6hzmtkZZlkSzxwyO5DL96eqaxvZuai6ihXU9i9Xao=;
        b=Mv67bhExbM88j15OdhpAhrX6vvVobSdpjATTwL6JzYBhMbjypj1vdj52VFHCv28mGx
         jUtRouEOGsipyNg8cWSem45aEBOq7SPOI6pwQf7XHkSc3oUTsjKnT07PtPaqjVBoXvvr
         YIz/xqf3xgcq5XmniDSkpdrPt24m5MRj6fA406seWPHv9chjhAXaCMuFSo+L3frgwD4B
         3V4frD5aqVqKdE0gqw2JfaD9Dn0hlJy1f1MHJZ25W04WBjWU8y6psv7hwpn4T8Rzb8iz
         DcV7UdePYWt71C7f4NCK7jL7uy4YBMq+Jqs4Pc0h3U4QaPt//TDTKZ/Mki67VmmC6Bm5
         kH5g==
X-Gm-Message-State: AOJu0YyTZzF9GxjTBA+oocntCJG7nY9MHRXFQqYsKft9VDIX9stcogh/
	wb/MjPivyb/3ZNJskXzypGmSdEtz1rIrRqbHNIKIJiAkMdEqBZqnCY+eqNyv44kK7pn6vslNj1X
	gOske2TF9
X-Google-Smtp-Source: AGHT+IGcXFK3aPrP0lM5AB7LTJ0HsyFsnNgSiazOaMMCsNnkQpMyzV8fhXn2pG4hfZUv0gWsjFQRAQ==
X-Received: by 2002:a05:6000:2a8:b0:374:c160:269e with SMTP id ffacd0b85a97d-37a42279388mr5001969f8f.22.1726905804873;
        Sat, 21 Sep 2024 01:03:24 -0700 (PDT)
Received: from localhost.localdomain (cpe.ge-7-3-6-100.bynqe11.dk.customer.tdc.net. [83.91.95.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90612df51asm964583666b.148.2024.09.21.01.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 01:03:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring/eventfd: abstract out ev_fd grab + release helpers
Date: Sat, 21 Sep 2024 01:59:51 -0600
Message-ID: <20240921080307.185186-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240921080307.185186-1-axboe@kernel.dk>
References: <20240921080307.185186-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for needing the ev_fd grabbing (and releasing) from
another path, abstract out two helpers for that.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/eventfd.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 0946d3da88d3..d1fdecd0c458 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -47,6 +47,13 @@ static void io_eventfd_put(struct io_ev_fd *ev_fd)
 		call_rcu(&ev_fd->rcu, io_eventfd_free);
 }
 
+static void io_eventfd_release(struct io_ev_fd *ev_fd, bool put_ref)
+{
+	if (put_ref)
+		io_eventfd_put(ev_fd);
+	rcu_read_unlock();
+}
+
 /*
  * Returns true if the caller should put the ev_fd reference, false if not.
  */
@@ -74,14 +81,18 @@ static bool io_eventfd_trigger(struct io_ev_fd *ev_fd)
 	return false;
 }
 
-void io_eventfd_signal(struct io_ring_ctx *ctx)
+/*
+ * On success, returns with an ev_fd reference grabbed and the RCU read
+ * lock held.
+ */
+static struct io_ev_fd *io_eventfd_grab(struct io_ring_ctx *ctx)
 {
-	struct io_ev_fd *ev_fd = NULL;
+	struct io_ev_fd *ev_fd;
 
 	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
-		return;
+		return NULL;
 
-	guard(rcu)();
+	rcu_read_lock();
 
 	/*
 	 * rcu_dereference ctx->io_ev_fd once and use it for both for checking
@@ -90,16 +101,24 @@ void io_eventfd_signal(struct io_ring_ctx *ctx)
 	ev_fd = rcu_dereference(ctx->io_ev_fd);
 
 	/*
-	 * Check again if ev_fd exists incase an io_eventfd_unregister call
+	 * Check again if ev_fd exists in case an io_eventfd_unregister call
 	 * completed between the NULL check of ctx->io_ev_fd at the start of
 	 * the function and rcu_read_lock.
 	 */
-	if (!io_eventfd_trigger(ev_fd))
-		return;
-	if (!refcount_inc_not_zero(&ev_fd->refs))
-		return;
-	if (__io_eventfd_signal(ev_fd))
-		io_eventfd_put(ev_fd);
+	if (io_eventfd_trigger(ev_fd) && refcount_inc_not_zero(&ev_fd->refs))
+		return ev_fd;
+
+	rcu_read_unlock();
+	return NULL;
+}
+
+void io_eventfd_signal(struct io_ring_ctx *ctx)
+{
+	struct io_ev_fd *ev_fd;
+
+	ev_fd = io_eventfd_grab(ctx);
+	if (ev_fd)
+		io_eventfd_release(ev_fd, __io_eventfd_signal(ev_fd));
 }
 
 void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
-- 
2.45.2


