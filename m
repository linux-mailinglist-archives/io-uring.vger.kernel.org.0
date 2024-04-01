Return-Path: <io-uring+bounces-1353-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 26684894493
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 19:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC3861F22639
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 17:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC4E24D5A0;
	Mon,  1 Apr 2024 17:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XY4Uw3ck"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344B91DFF4
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 17:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711994285; cv=none; b=o7p6Gx4dklIXxpLYVybsSlaLtEYMOuTLBG4ht5kvzaZjZV5Ph9OEJUSGss3YH07KanoyA7np6eiWdR02hcSqF8mRkqErTXgZRGZYq9n7ndR/kvDWoqrBXTu/fLmLN7afay8Df6KKCfDBnhOz3uJKKjIps9ntqoLwqh+ZVu59IsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711994285; c=relaxed/simple;
	bh=ZOc31Chv9GMzFMptACL4IWPv63UmYAghUAlkMAAqqNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZFQVeRkVG6uj3vfz/luohOKAUzubtp5qWdvj8bfapRehRKEXUCgYd2EWBtF2hC0JHMWJAbOkswsg5Re2EPnNCq/Wl2bU/bcEvfBSaJj8rA/IMt2/CR9ZVfNT9FHSm6kSJ2oGcN4vN3lttYGS3Pr8/CyJK+iV03KaSMiyI/TMYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XY4Uw3ck; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3685acaa878so6181275ab.1
        for <io-uring@vger.kernel.org>; Mon, 01 Apr 2024 10:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711994283; x=1712599083; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1mvpGKi0DP7HNfgie+1LU8g3Dn3YtdBR+/r1RYG5X0=;
        b=XY4Uw3ck45wucMSm1S05HK4Ah+XNJPMLie9ze4iaggLzfR+4mrGhmf73rrqgvzbwAe
         17EEb5AOTYTFg5VY69BIhJV0e9FTN2j5x3KUjR0f6tlN0XwPahTUoCS4EuJ/4UJiFXTx
         ZJPc/i2LoWKpqzCsfIUncpz6APT4ZaXCm8oBh32aHLO5a8H4JsEpdLq3w6ZyRmcye+6G
         Y5+NEIZXFebhmLqOp1UiQ3LJ0/7nOFTFEwBEJKtc3Um8tBdwmhFT7BevuASNqLRPc1R1
         2PVIEdioXTx9zL8a9REsl69zuGVs1qE1muPQYIr99KXli3H948TFSfxux4kxWAdUj6NE
         JmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711994283; x=1712599083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D1mvpGKi0DP7HNfgie+1LU8g3Dn3YtdBR+/r1RYG5X0=;
        b=AoE+UVYGm4F1uvcymTGHW/TCLCz6P9oV+r2W+ybIqz8ySF0nckDgOpKQHscgUEOA6t
         2cg3n2KY3FnQgU8Yt1e8CRhu4XdZ7rXtF/MXq2uNOxHoYRYQOVOXoXcHxlbn2ioNxL/Y
         fx1yvTr1mNnCd3WhlTti23YON9DybfvfrWS03A5pMW1VNFOk1IjfWhtfH7a0CI2TvOqb
         lJl2J6agKk8kI4HaJ/cwagejvYBSLVCT3nuympIArk5bPg6u3s//4AmV1igx4ctg3hTG
         zbnbk2rokcjjCcoY8Hkese7lQOG8pidizM7KB2ttv9dYlVgo6RqvtzJt+8yxsx57Tfau
         6SJw==
X-Gm-Message-State: AOJu0Yycxe8MzOo8jQLFgnG3w4ol2ep2Dg8CVpY/skZZmEuCWBgjmir5
	1Mq0K40XHBQmQgZOnI8w1LgR2jigRmGp+V/5tNOsS/pzsItoRb2xt0dlIjxvtwFjU1nh1J6UM2B
	h
X-Google-Smtp-Source: AGHT+IEFCf68NrzAn0Lm5+x36u49Bfjw/AX2Dh6WQLwlm7zkoAnJd2Kay/fyAtHb0qptljoo6uX8zg==
X-Received: by 2002:a92:cf42:0:b0:368:a917:168f with SMTP id c2-20020a92cf42000000b00368a917168fmr9271325ilr.3.1711994282939;
        Mon, 01 Apr 2024 10:58:02 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ge9-20020a056638680900b0047730da740dsm2685669jab.49.2024.04.01.10.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 10:58:01 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring/msg_ring: cleanup posting to IOPOLL vs !IOPOLL ring
Date: Mon,  1 Apr 2024 11:56:27 -0600
Message-ID: <20240401175757.1054072-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240401175757.1054072-1-axboe@kernel.dk>
References: <20240401175757.1054072-1-axboe@kernel.dk>
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


