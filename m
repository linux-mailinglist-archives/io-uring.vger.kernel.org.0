Return-Path: <io-uring+bounces-1302-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0192E8908AA
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 19:54:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 332A11C2764A
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 18:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8875F137904;
	Thu, 28 Mar 2024 18:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2gNlY9r+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3D91311B5
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 18:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711652062; cv=none; b=YFcEz+fQ5enEzF9XFZx01sV6eNly7LGMxWB9DQ/qEM9lqB3rHvvu8/Ahr14ENuB1sxj3wXyAZYqn8+dDWRLK9JgVnDyIudP3nd7KH+FotLo3OTcwqTn+Z9cVspyfXGM7HAjru3olMZtjyM6YMQT+kUPJnt01O4ue7TIb5gvyJD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711652062; c=relaxed/simple;
	bh=ZOc31Chv9GMzFMptACL4IWPv63UmYAghUAlkMAAqqNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utZf5h/EkcksujPOrawiF0Dh4oUyI1QNDgyoGJchqLkY02cI8+hPvxE4oOF/eYbHYBvA6xI0RAcgtXRe15HSxZX1lWNTSGgCJ8kkiSe6A5/eW+6NtV0nFP2RzhtY/uS+Eyosmvn8uSmD/K0c+UmlLXJrb7QFD2VWOpwncZUztSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2gNlY9r+; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-58962bf3f89so278592a12.0
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 11:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711652059; x=1712256859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1mvpGKi0DP7HNfgie+1LU8g3Dn3YtdBR+/r1RYG5X0=;
        b=2gNlY9r+olumqQ98oX4AFKDlUvHve2+35EbzTjsKnGpHfbtKbru++V4hy/9zW5oRPU
         x+lAQWCrDNW9iuSHJeKcS0oLW61lqbIOmUCV2SHzzVW6WyvPI8XtGLr35m7NKtv1IdA8
         +yz6WwZ56gwk4hz75qZG1IXdo/lfGTe36egi5m+F0PrWWDh33b/KMfX8vnwQ++d62KOp
         pMtL9ACfPoyg3q7/mrnZ1jCgi3DKRBxhoF3AyZMcm1eKAHSmkz9RY7DFQBPoyBs8OIXm
         pRGPIO3ZPXkdZU9761y8OcNxwGKzbSs0pPkKgfBsfVyxxk4A/KDNCoT5Pyd1XUly3i3g
         ZjsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711652059; x=1712256859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D1mvpGKi0DP7HNfgie+1LU8g3Dn3YtdBR+/r1RYG5X0=;
        b=kvFNZeSwbQpSb1a3JBtBcHEvFUgDamx0rUkuAmWEOAxzA8W/1sY0oAxPTSAQFBZoW8
         /wTQQdiwY+ILJb5Wy+0Df2LN+NRIPo4XPpu4VHm2JF8UeRQWJ9R3NtLgH4NYw9FE/e9q
         Et+g+2M0mRuszMQdLCxZxr/7xHA85yel2s30PoUMbw1A/ciJcRqiI25GUFUL4Jig4Bgg
         Wo9DBrkPEpU10raz56sXjlI8JpOGIXfzA8ZFWNUuU2xuA2JOsfuz0ofnV3r1ptV4LOWG
         IWHRe75WOulJiaJM7DAygDOeYYeKfvJrEzU38p29AfY6gQTx1LRdio8M/hp6/pTvHOrU
         AqfA==
X-Gm-Message-State: AOJu0YyjcdqfJSHTNFd0WjgjWp2hRGyFgZhG4f2huSbqB2DlSKCsyNVh
	3cTVQSmnNjs9plA5qwPTzq6ltgJ73A4OaQx0aXdkER0qUT+IKO1weGNcqe7Y9v1JDMkqUSmtrfn
	v
X-Google-Smtp-Source: AGHT+IH7kb59sJ7qa3POBzK1hxtzPC68XZeIBAGSywjb6vnTXc/QoaON9vbP3nY1dab1Yxgmrm57xA==
X-Received: by 2002:a05:6a00:b31:b0:6ea:8604:cb1d with SMTP id f49-20020a056a000b3100b006ea8604cb1dmr213256pfu.0.1711652059112;
        Thu, 28 Mar 2024 11:54:19 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:b138])
        by smtp.gmail.com with ESMTPSA id v17-20020a056a00149100b006e631af9cefsm1717357pfu.62.2024.03.28.11.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 11:54:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/msg_ring: cleanup posting to IOPOLL vs !IOPOLL ring
Date: Thu, 28 Mar 2024 12:52:44 -0600
Message-ID: <20240328185413.759531-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240328185413.759531-1-axboe@kernel.dk>
References: <20240328185413.759531-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the posting outside the checking and locking, it's cleaner that
way.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index cd6dcf634ba3..d1f66a40b4b4 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -147,13 +147,11 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
 		if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
 			return -EAGAIN;
-		if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
-			ret = 0;
-		io_double_unlock_ctx(target_ctx);
-	} else {
-		if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
-			ret = 0;
 	}
+	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
+		ret = 0;
+	if (target_ctx->flags & IORING_SETUP_IOPOLL)
+		io_double_unlock_ctx(target_ctx);
 	return ret;
 }
 
-- 
2.43.0


