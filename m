Return-Path: <io-uring+bounces-7581-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85FE5A94791
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 13:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85CAE168E49
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 11:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD041E7C19;
	Sun, 20 Apr 2025 11:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UW2SRVsX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FD11FDA
	for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 11:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745148228; cv=none; b=dL8L5jz+JpZCGk+Oj92OiaOadTIxayZ5axCOVC3ACLbacRSS6JYCZpvbRTDwXTMDlqoPbf53FxWZXB5EZyRRXC9grqaPg7ev8kTnJcVvznhvq0eFBW8YuicSPIekJ5N0zCQ8+IJYNoIykSPnRDP5y8mGkb5w90TEOYU0fBKsELY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745148228; c=relaxed/simple;
	bh=k9fWL77G7R7IX2H6Gx3cYR1VhsuF8AAr3ZVm2TYHLD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6xheottf87goC9DsgRhw7GSm7vUwApoKqYBQLSKNEThSLL12v01dtra1YVKgm9SHMHt5vgP0/BFA4hZKIE/BBuXyomlGkrUbVWMNKlPxuGVgOypOysOr1YfkGu7oi5BKg650jOS3nXAQgfIWpH8d+XLrtqcplBG8o8WcCekPvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UW2SRVsX; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43ce70f9afbso27724925e9.0
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 04:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745148225; x=1745753025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=auVybIZXsL913+tO/yKYKvlgQWygN25S54Rmq7/KZYo=;
        b=UW2SRVsXfTn/PnlzQfUS0x9tfaQvUxiWNJY+qCu8Q881XIq3JxXxKyGicMXKzmJMwW
         vL3LEHJr/ZlLapFwxdbW6TK8DdpxHuGENqFnAvlx03IeJItNqdscfbE0y0F9SQDL4uoe
         naQ+pR24QRfkqxrCmY3ssXZVi7DGOz3eu9zWRJDQAHi0IRPQwFWXffwoy87IuimwtDYO
         L3PREV5zLK9CVKJ1ubBxl87+uS4eF9SBfrBpy5fb9ezJvwd/Pon04sgW0OXXoHvXiljq
         jjkdhfIVW+JeNAIPq/4tyZOGRODY4JgGH7uymqLgRZ0/BWlhbh57uuglo1JeCCIqHTCB
         lLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745148225; x=1745753025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=auVybIZXsL913+tO/yKYKvlgQWygN25S54Rmq7/KZYo=;
        b=PjnHpO7YqNVAtWl+AxVzPj/60iGfrg5Lb8X3XsvDLXdvqfxEru6uP0tC8jkno02j6p
         siySFu+20ZT3S4fNb+jB+ZoGZiPBoOHAFgvKLrOyZxFxfVeUqk1xw6g9O4MWSWqLkmqO
         mdAaGEPWxhDWFdzypX+iKqVwWIdBTmjkfOd0eMoPZgegUD7pUeiyP0c8iavLrhFmvH3j
         rebi49WZLvbt9qCEXe0LjafvfpHZCEQjwoNbHdssKWBS6ryuaoVO7Ps75LX/cNS5LR7U
         5VNFQb3I27UFoVqsUk2QY0KWVm+l8xNKaA9QLEJlC7E7XAOqaKsx4VLoZwK9nd7Wyst/
         dcgw==
X-Gm-Message-State: AOJu0Yxqyz8SJa8UbcUyaicwmGuHGgjgYkl/qWjze8dFY2vZ1bvmRAYB
	g1Niozliq3y38mYWvXKIKw/Z3WltK8cksrPZp60eA7kih852Ig43fQoffQ==
X-Gm-Gg: ASbGncsfcyjJkSk35mHVn7+tpsbybOqXLe298Yie7jxSgR7e+/I0nwBE7K6kbkO2nk9
	NHiE1Q6AszF5qK4bd+ZUut+/515TrRcu4+qghbvOptkiWtZANTziKygM0d3NaHLN9uNpg0ByY50
	7y9EP/wuu+a4unVK8royfReLpmptfKDxS4yEgFe8u1TCqMZTybihWAtjJtA83MiK/ZgVrAE8boI
	cA7QHUdxgqFj9fjaeo061IY66RSXmOkHtYH2W0jyRkJMMmswdRb87kC7tFVfW0/Hc4qvhmLmA7z
	fPa7LE+F0RXCVrXGpRV2nWB8Cor8mhwvsS9P388MVq+WvEDXZxnodA==
X-Google-Smtp-Source: AGHT+IGPSwRq++2bQHQwHBUCPR4xn7qsehMyHYXzBtzXezvyGyUDUtyPKeHjxfooDS4ZgWzswEoyPA==
X-Received: by 2002:a05:600c:154f:b0:43c:fee3:2bce with SMTP id 5b1f17b1804b1-4406abfabe7mr61552335e9.26.1745148224808;
        Sun, 20 Apr 2025 04:23:44 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5bbd35sm94447125e9.22.2025.04.20.04.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Apr 2025 04:23:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 2/3] examples/zcrx: constants for request types
Date: Sun, 20 Apr 2025 12:24:47 +0100
Message-ID: <bd94694fe41c6be7275231d762adfb1a88dd0686.1745146129.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745146129.git.asml.silence@gmail.com>
References: <cover.1745146129.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of hard coding user_data, name request types we need and use
them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/zcrx.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index afc05642..8989c9a4 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -43,6 +43,14 @@ static long page_size;
 #define AREA_SIZE (8192 * page_size)
 #define SEND_SIZE (512 * 4096)
 
+#define REQ_TYPE_SHIFT	3
+#define REQ_TYPE_MASK	((1UL << REQ_TYPE_SHIFT) - 1)
+
+enum request_type {
+	REQ_TYPE_ACCEPT		= 1,
+	REQ_TYPE_RX		= 2,
+};
+
 static int cfg_port = 8000;
 static const char *cfg_ifname;
 static int cfg_queue_id = -1;
@@ -135,7 +143,7 @@ static void add_accept(struct io_uring *ring, int sockfd)
 	struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
 
 	io_uring_prep_accept(sqe, sockfd, NULL, NULL, 0);
-	sqe->user_data = 1;
+	sqe->user_data = REQ_TYPE_ACCEPT;
 }
 
 static void add_recvzc(struct io_uring *ring, int sockfd)
@@ -145,7 +153,7 @@ static void add_recvzc(struct io_uring *ring, int sockfd)
 	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, sockfd, NULL, 0, 0);
 	sqe->ioprio |= IORING_RECV_MULTISHOT;
 	sqe->zcrx_ifq_idx = zcrx_id;
-	sqe->user_data = 2;
+	sqe->user_data = REQ_TYPE_RX;
 }
 
 static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
@@ -215,12 +223,16 @@ static void server_loop(struct io_uring *ring)
 	io_uring_submit_and_wait(ring, 1);
 
 	io_uring_for_each_cqe(ring, head, cqe) {
-		if (cqe->user_data == 1)
+		switch (cqe->user_data & REQ_TYPE_MASK) {
+		case REQ_TYPE_ACCEPT:
 			process_accept(ring, cqe);
-		else if (cqe->user_data == 2)
+			break;
+		case REQ_TYPE_RX:
 			process_recvzc(ring, cqe);
-		else
+			break;
+		default:
 			t_error(1, 0, "unknown cqe");
+		}
 		count++;
 	}
 	io_uring_cq_advance(ring, count);
-- 
2.48.1


