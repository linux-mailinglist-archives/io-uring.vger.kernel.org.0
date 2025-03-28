Return-Path: <io-uring+bounces-7290-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C5C1A752CB
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 00:10:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0FD47A6746
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E9C1F180C;
	Fri, 28 Mar 2025 23:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aiIOsU0j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DD41F4170
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 23:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743203428; cv=none; b=R9UAiPbgnIXRwk6qiv7G/oXe6diIwlQrXfTcQUFeqRejlwzPWqFPnd9etwvwm2gOGNFohuZa4+S6XPAoVBkgkKgjrvVjclfhhqfJ61kuSPuFfToDohI481a35/pK+/junpZvxAZXpCULySsk/o2sVGrXerb7/MyoLpKyvsr7wG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743203428; c=relaxed/simple;
	bh=rqsDQJ7bq4hI0AISnnf+b1Yl4yyvzyHX9OPc6L8E5UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAr4mI0BMnKPFcgY+VKsruA410d2syPX8YTbwaZTR877iUoksvaVg95h6J+hYoT3OBH2Rz+xLw5IXfmClgdnGgIMLmuQIp+hqmVfmFHB0t11SRh2549RprGdIepPZY8bPEjzS/LJ3UR1YhQ6WaJm/dPG22ma5CPA3V1Hh0ky3C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aiIOsU0j; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac2902f7c2aso456656766b.1
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743203424; x=1743808224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8joMM0e9MKFzlH1siqj7abLLw9+811LBtPm8cuQc14=;
        b=aiIOsU0j9WPpCNPEN5QcjjhiPBt9A/glerl7HntS3JPGrzg/EpZaaPHbODPbmhDGzo
         crctu9n0AEkc1LUCJ3GOet/wP/ngNKUPXXPp4YvXyVsXUPrqcyKXHoAwnikD4m3ligPb
         ATIX9jknAfL2M33y3EgOzVc55RoZNZUOq6w8schK0xVdD9oya7DKDcdNhY52JYbWbAVd
         WlrJlqpRw16GQSAeqEmyZz+SnAupyjTGyWx8pDYqkfL86ztrYMsH0BS1nUE157LG5v9a
         Xai+yf6hijdo2qCVCBjVqdErkk5MAwI10S10SipqP8XVcSzWAxd1Uzx4qYdscIZASiML
         eEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743203424; x=1743808224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y8joMM0e9MKFzlH1siqj7abLLw9+811LBtPm8cuQc14=;
        b=cCBU5PaUH/+0PEp7LnKmg3Pinxz5JBPNjB/as/RX6UhoDVzedUlHk+mGuDfudzKfvv
         y/fWnWR6+ERNzwhtXQKOlCu4l9iPVfjRkmdSHWmsVtGWO+D0yX7Pgn7A7n7nd/xzcPmX
         mL7geIIBbYR+2densUZ2QrINVBkMpbHE5w1Ps9tqyJfxFfZePxKdTO+ASrl1R3Yz3GTM
         2nx/btBl0Av80Y7dQ2KJM3H8WzzlI6IDLTJgVIOEE26srauA1H9BwABR4pS82KWQ8LG0
         fn/O/1jYZxKxVtqn8ru7Wo69RETrfoczOfaSlZLPMls4HH8Kqcpl+CG+rtt1c95Tb0rq
         dZxg==
X-Gm-Message-State: AOJu0YxJnX7q7vkR7aiHZtP9/nxFu6yrcPe4irT9ZXdgfzArHQ1rx4ao
	3COehW9w+/xqRFdWqVYPZC2xGOzwBtSh3Qi2D7pj/bvZgTcgIQlj4pUqbQ==
X-Gm-Gg: ASbGncsKZzvPhTKocSpuJK5357CA1so4hprqY9Yr9tXrxbXLiidqlqPJDpqlQe/TFB4
	69JHwpcUELTPh5rz6C6rW3Imp4ugJaQXxENVOf6phS2dHPjFYKnuQBxU3BQmm9L2LxgrOfSkXce
	vjLS4/Kr88ID1jweB8woM1cSAtt6mLz/bD6K2LCt3KtIyQbHZ4KDd5fbBFk4SFcb6sk2TnESFM7
	wQCZntO1oPPbkDvKnuIwBrmzeinFvfoZNnI2wjQuTWz2qkiu+vqEZe+eula2i3w1nFvfEw5XvjO
	b39s/s7PAf6qMHy1KXFWx6IraVZfXyVJNCSxxfC4sTTC+jTnj+pP1JvH908=
X-Google-Smtp-Source: AGHT+IHWjrTvolVyc7Y3ks//A6mvyjb1nSyxy37hJLH/IjC8dNNFV3NNeElVwcIQ4Rj7L4yOE6JGLw==
X-Received: by 2002:a17:907:3f07:b0:ac2:9093:6856 with SMTP id a640c23a62f3a-ac738bf65d7mr78242066b.54.1743203424157;
        Fri, 28 Mar 2025 16:10:24 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71961f04dsm228915966b.91.2025.03.28.16.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:10:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/7] io_uring/net: combine sendzc flags writes
Date: Fri, 28 Mar 2025 23:10:56 +0000
Message-ID: <c519d6f406776c3be3ef988a8339a88e45d1ffd9.1743202294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743202294.git.asml.silence@gmail.com>
References: <cover.1743202294.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Save an instruction / trip to the cache and assign some of sendzc flags
together.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 78c72806d697..e293f848a686 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1292,7 +1292,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	zc->done_io = 0;
 	zc->retry = false;
-	req->flags |= REQ_F_POLL_NO_LAZY;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
@@ -1306,7 +1305,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	notif->cqe.user_data = req->cqe.user_data;
 	notif->cqe.res = 0;
 	notif->cqe.flags = IORING_CQE_F_NOTIF;
-	req->flags |= REQ_F_NEED_CLEANUP;
+	req->flags |= REQ_F_NEED_CLEANUP | REQ_F_POLL_NO_LAZY;
 
 	zc->flags = READ_ONCE(sqe->ioprio);
 	if (unlikely(zc->flags & ~IO_ZC_FLAGS_COMMON)) {
-- 
2.48.1


