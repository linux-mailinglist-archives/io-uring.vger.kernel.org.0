Return-Path: <io-uring+bounces-10784-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 999A9C84F92
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 13:33:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 45AAA34F2AC
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 12:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B813831DDB6;
	Tue, 25 Nov 2025 12:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QTESRBX2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5CE2DEA67
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 12:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764074008; cv=none; b=Y31LwkATnbJLsfPGzE7p3p09RDzQ+49o404dsCskyBK5J1aH0A/qG6OXd5HLZf32Wn8rD5wHaEC1yaSNcZp2E7RWhOoWT7G6u4zXIeoiWNxjGmE5kXY+dXtdpJ0Uz0wriE2aHNhFH2JphL1VBYFW/iZP2U+1wHmK6GI199tjrek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764074008; c=relaxed/simple;
	bh=L0ZQh4cmkScuY/hIq3xPizSH1cpgQSZFJSsVZoatio0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aYVY+yR7KJwRIhrQ7txq96NlgweouoDGBwF6xffarUU9EN+aQJLpsqa7vXLzVeuXgHgb4SgefVJIX2UFctAM6lT6YeT0sPwXoX12Ag5/aJfESc4SrinWprIYaulA+qr0nI3vloV2BL+oL2uR65xA2X6zgYSHDPP957IfV79QEIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QTESRBX2; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477b1cc8fb4so31141455e9.1
        for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 04:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764073996; x=1764678796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fdgA52NAOUdPXsrnfhqWYPYH2n0PDbM2eXtmG9evXek=;
        b=QTESRBX2cr73ACo6H4BvG1dfkckhdqWdVVIPhqpTNA2D1BmofZV/OwPLgroCzqliPm
         nch/A1YwOEEiWsClTqt5qfCoGmn6VS6Hh7qJc9Bp57nPoQOelrfrZKmaxyazf97luR45
         DdoDDhT9jUDtABw87CicFvd2SuIJ9CDOqEcAyomYy8Aixf5m+d/43gAFf5sB24x4VzJa
         ywvuE44zEh2jger40mo7sbTi7yt3nt919JauHRSmM9hCl/bk5EX2N2923yEX8PFdqKEx
         eoSA2VlkKv+y+pNHO2bfS3IOO+rBUg5uAn7v2csuDus2VOpUknlknmgcc3h9eQXgwjYR
         k8cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764073996; x=1764678796;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdgA52NAOUdPXsrnfhqWYPYH2n0PDbM2eXtmG9evXek=;
        b=M4RxrGsndM5m3+PtFKcctPSL7zFgQPQ+gnWTWEjha+cwncogq3Kgo9vvIlX9OnkkFE
         NpZRcGh03n4rfs+yXjIl0tOzlnzKmKm2CSIUzHcCYAfueVS+QiHHT8PJKcKBfBvwcqyL
         hntffTEwZkQOfOY9kbTmuPNK/kjLc8Iou7KIEh9VZ+sJe0iC6jpAcev3nZW8zsuNsf64
         oZjveWsiFZlvTwINuk5aTUH8SPY6Az60ETkhquljRay85+iW0WPrerDywOKDo381DlxH
         maP89QLIWBwv/Muny9JMLw8JlzefNUgZO311RECWZ2iYfmTrDIRQgXbk+sowUGGIDrn7
         oJRA==
X-Gm-Message-State: AOJu0Yz/TzxRl6Q6GG5wvt3T1p3QpzBfEIW6N49zdebB/9IFgE9SDAHk
	gesr7ajbV9Tsyf58U3E/6NV+OP8T3S+LiTwtxEPPDiJeuPq6jvUEtPTNVI/lZw==
X-Gm-Gg: ASbGncsxcJ655YFJymrakvAs+Ob1LtdY3/CHUUJlTDkHi1Faddd1ip+RL7dvhBEhdjH
	8/sW/uToW0guB+Nops1YNpilcNV3ZioioV8IXbj5DStaSyX/2BSN5NAx5XJpWIDhupgcB0PeUE4
	u41RhpCleB3oc/FUV/RPjjURKc0Euf9pvU3GQ3fMAY08NNFIrjEyUis9+AvjBXhXxoj5pSeUCE/
	3JZoB9akNeDuLMRqmgpUTFfJXaTyBtaSjkiEhelnMWVVbmqmsSzZdb7mTVeAVVlhOyGs2ZdfL2k
	8GxGSnPKQEFerhKNPMm0jXlwTDNT2t0KtLbWPW7nd0bW6yi+LaDrUFPTkP0DQ7tINdEycTROpCH
	nd9PmnaMEGHdQVKcKeK1qYVilRsdtQl+z8RQnlZReCQye8GreEiksmSoSt5nEmdoOJ+nR4rDDoa
	jthLFIvV6Ttdl6kg==
X-Google-Smtp-Source: AGHT+IHE5dAu7fl4NNtiZR7ge/YF0wlcyciApq8Gf9TUQZLJ0p16Zrgyh589WJOiyy7BxPujRGbeBw==
X-Received: by 2002:a05:600c:4f46:b0:477:fcb:226b with SMTP id 5b1f17b1804b1-47904ac44c0mr25064645e9.2.1764073996476;
        Tue, 25 Nov 2025 04:33:16 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf36d1fasm239639595e9.7.2025.11.25.04.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 04:33:15 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/1] io_uring: fix mixed cqe overflow handling
Date: Tue, 25 Nov 2025 12:33:06 +0000
Message-ID: <3f8137e8c7183817bd7830191764edbd3a59d7f9.1764073533.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I started to see zcrx data corruptions. That turned out to be due
to CQ tail pointing to a stale entry which happened to be from
a zcrx request. I.e. the tail is incremented without the CQE
memory being changed.

The culprit is __io_cqring_overflow_flush() passing "cqe32=true"
to io_get_cqe_overflow() for non-mixed CQE32 setups, which only
expects it to be set for mixed 32B CQEs and not for SETUP_CQE32.

The fix is slightly hacky, long term it's better to unify mixed and
CQE32 handling.

Fixes: e26dca67fde19 ("io_uring: add support for IORING_SETUP_CQE_MIXED")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1e58fc1d5667..5d130c578435 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -601,6 +601,8 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 			is_cqe32 = true;
 			cqe_size <<= 1;
 		}
+		if (ctx->flags & IORING_SETUP_CQE32)
+			is_cqe32 = false;
 
 		if (!dying) {
 			if (!io_get_cqe_overflow(ctx, &cqe, true, is_cqe32))
-- 
2.52.0


