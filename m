Return-Path: <io-uring+bounces-1443-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E39C589B4CD
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 01:55:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BF592819E7
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 23:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0590446D3;
	Sun,  7 Apr 2024 23:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yio/c0Hg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF4444C88
	for <io-uring@vger.kernel.org>; Sun,  7 Apr 2024 23:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712534106; cv=none; b=EPlvnaYQXQTUbHml/hDYWFkxi9jGztvdld/tTuzQ669jXB153WCWILJ4tVr38s8YWjqMFVryba+POqinRIQ6oaLba9HVJ3EBsEBnZKxjNc5XJfyUusF9t3HUKfjX+9yn3QQXq+lTHYmoBYgaBMgTw4/b6tfC2XHh7jhHS+IcvPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712534106; c=relaxed/simple;
	bh=2VOPc5dxix3HCAmCWtX1QxIUysavfiS/Gs63TWKqEvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2h8p65ujvshcaHbAbjjB8gmlc6/p+iyo8Pq3UK9HFFkuBm3mc6WqV7KXpWI5WBemt3Y6u+aoCfyr0OH8k9wyF37BGNrsqICAVmlMdx64NrABAqbi4tfHetn7smplCcyDdH74uDL1iKSeliU70p2y/KVHQxGjw6sPwpc5L+brVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yio/c0Hg; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4166ccac75cso3234925e9.0
        for <io-uring@vger.kernel.org>; Sun, 07 Apr 2024 16:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712534103; x=1713138903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m1eLuvS21CjGHStugiHE76jI4qnRjr7TejjVr4grT/8=;
        b=Yio/c0HgMDDU5VV7RIFhY39VBQq1ge9wqfzyX+jGSfnuNxhwjibBULiyhGXKAW7RPb
         cfNsXHVwjXrJGafC387Uh+ANx5ItxhiajNDJOZPOi6se/sYYs+Ay3TqH7NPPTYk3o70j
         duDUzLN3J6RVYgk2Iinit3kKQeq3bkSAf+uAcnArBDfdcQKvOxvd6n4hO64lz4KX3moE
         CufLP5RwE66JIZy0N8S1SFbckn7e0QVYFuyowcWQYufz21gxJcDDGWKO3rr+wOTa0zeW
         fc/w4oRe0g68YnsU0z+DJca2Vhikk5VntO1eKff19tKlMxlo7DJts8vlvuK0biTaRcF/
         jbYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712534103; x=1713138903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m1eLuvS21CjGHStugiHE76jI4qnRjr7TejjVr4grT/8=;
        b=ez1xsxMIbUGUeMtiN5w7Te/wSh7q2auFpBJx5Lyup+aS2hqKkC6D/dZVLrwBWHHq/O
         R8hZWaV8boLerMUis8hXcCOxAnrbojITHCJSQ0sM5nt2hRPtOoP94OmioHGFsoN2Sq94
         RRvLs+8zFv9p/XmaXlm6vXzOUIa9eYEY+06mpmikxyyxXZJLLv277H/pDiM9HJBv2Zsn
         uc996xKHFaLdF8dgcSkMCjLtFymDhebBCwa33YxqWRZ6DlulUoECKAbPtpIrxI7SuX+t
         VFgXvsk8orarUQY8mXMEy5lH7c548B88HIvYgq71HGlS7d5kswUkq+57qMl468KYA96R
         OA0A==
X-Gm-Message-State: AOJu0YzkffBBZm18PG+EGInEcaaOGp2S/yv/EQZJaTcJWEPPxM8uUhcL
	3kr3czqNRKSSFHNyyEEeeJQWqjPR9hxrZuvFtjzTaZl6c73co8qAVDJysQOX
X-Google-Smtp-Source: AGHT+IGLm7cdcAt5qsmxL7KYsCkpvGWghggTz1u62UarTHAeuv0Uq2RGTfrWG0rVBoZDF4YH3O4m8A==
X-Received: by 2002:a05:600c:310d:b0:416:604a:d162 with SMTP id g13-20020a05600c310d00b00416604ad162mr1228957wmo.13.1712534103070;
        Sun, 07 Apr 2024 16:55:03 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.79])
        by smtp.gmail.com with ESMTPSA id je4-20020a05600c1f8400b004149536479esm11302917wmb.12.2024.04.07.16.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 16:55:02 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 1/3] io_uring/net: merge ubuf sendzc callbacks
Date: Mon,  8 Apr 2024 00:54:55 +0100
Message-ID: <d44d68f6f7add33a0dcf0b7fd7b73c2dc543604f.1712534031.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712534031.git.asml.silence@gmail.com>
References: <cover.1712534031.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Splitting io_tx_ubuf_callback_ext from io_tx_ubuf_callback is a pre
mature optimisation that doesn't give us much. Merge the functions into
one and reclaim some simplicity back.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index d3e703c37aba..47ff2da8c421 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -30,36 +30,24 @@ static void io_tx_ubuf_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
 	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
 
-	if (refcount_dec_and_test(&uarg->refcnt))
-		__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
-}
-
-static void io_tx_ubuf_callback_ext(struct sk_buff *skb, struct ubuf_info *uarg,
-			     bool success)
-{
-	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
-
 	if (nd->zc_report) {
 		if (success && !nd->zc_used && skb)
 			WRITE_ONCE(nd->zc_used, true);
 		else if (!success && !nd->zc_copied)
 			WRITE_ONCE(nd->zc_copied, true);
 	}
-	io_tx_ubuf_callback(skb, uarg, success);
+
+	if (refcount_dec_and_test(&uarg->refcnt))
+		__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
 }
 
 void io_notif_set_extended(struct io_kiocb *notif)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 
-	if (nd->uarg.callback != io_tx_ubuf_callback_ext) {
-		nd->account_pages = 0;
-		nd->zc_report = false;
-		nd->zc_used = false;
-		nd->zc_copied = false;
-		nd->uarg.callback = io_tx_ubuf_callback_ext;
-		notif->io_task_work.func = io_notif_complete_tw_ext;
-	}
+	nd->zc_used = false;
+	nd->zc_copied = false;
+	notif->io_task_work.func = io_notif_complete_tw_ext;
 }
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
@@ -79,6 +67,8 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	notif->io_task_work.func = io_req_task_complete;
 
 	nd = io_notif_to_data(notif);
+	nd->zc_report = false;
+	nd->account_pages = 0;
 	nd->uarg.flags = IO_NOTIF_UBUF_FLAGS;
 	nd->uarg.callback = io_tx_ubuf_callback;
 	refcount_set(&nd->uarg.refcnt, 1);
-- 
2.44.0


