Return-Path: <io-uring+bounces-2668-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADB194B4C1
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 03:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C433D1F21746
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 01:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C9A58827;
	Thu,  8 Aug 2024 01:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QULpqcDy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46468C13
	for <io-uring@vger.kernel.org>; Thu,  8 Aug 2024 01:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723081711; cv=none; b=ooRS/g9iVPitJEnM6ZPlnzb2gmiPNLQtjWOgxQD3iaH4+pmYnFJFiVoIswB64/xJKMKx0vtUj97pLSfB6GKLwAjef/d78gU/7tB4JvLOeXf8JHzi5fEj26DibS0h27CQKvx6bmtqScMQkqtvOZiDOOspZsGdkk3nnotdtx3bID0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723081711; c=relaxed/simple;
	bh=6kniANUbgbJIQd+oMjEkgOnnY1/134tK6Kt7vfRhOd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgOApj6BBqym2rZRkXvrdUIsAWxEScy2tuTKkUcrFQYWZtAo5bKbhaMi9748H7C/UbYmsgrgKMW6ndCd8ngvraUGsEKXgblP2Sw2Uq7JNukrWs6FQAhFocaCJuENJ0XAPQsLVd72Ooy82y6JCMKVvN0zgkIgkMMgF4HuBfQfQ4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QULpqcDy; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70d26cb8f71so35164b3a.2
        for <io-uring@vger.kernel.org>; Wed, 07 Aug 2024 18:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723081707; x=1723686507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sgEdk/efCLokweNU/OQMz9jU5fZj6geKuOMQjp3pUWM=;
        b=QULpqcDylZSaQPkMVe4W3xbLvoWyJdXizpcrfxDSo3rQMFJu4SEphNu45p0ffAfEMh
         a2j9LbhcrnXbKe/iEAOHOD4ukZU1WgrTurQmrezskoKizGPRwsDYvVGPD44oXDp/m3Yc
         v/wmbZ68+YpQpHS7Kd6V9Jh80QcFpAfHqqCT2g1JX2o03b6mfIZ+lSKJx1XFV9A0H4OF
         ammlDiK56mLhj7YO7jw39FfNFyLe1IIDAoI37DIYa4exiH6n5tgxtOrVT1JEwCLQQSkL
         MszpyVNcLd9IYTnK8aJUnQXt7yqA8Eq7HBL8M1+SjpvALaX+tl7cBsKABDiSuQHoPJg6
         Gq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723081707; x=1723686507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sgEdk/efCLokweNU/OQMz9jU5fZj6geKuOMQjp3pUWM=;
        b=jrYFQqKwOfGYbg+DmGjejPZnhx3rYAc2WptayP3ZSuIQoDZzUFexLj7iXwz72JWIBB
         ptbWwz0CMVr7O3X8lge5LBt4a0ZvwKfsZh8pvNeDKZZRDX/1cFjQmKuvqYy3kIxtkl+f
         kQQhA87+9v4aLIyoHJwhjlVp5ZCfenxKKZN8lPu/FiI4aYWYMU/mLHUH7s05wn0I8rUQ
         uG0T5GAvkRLqcIEfzsbjzx5pwFfnLNf4D7iLEEOZo8BKOxe8Jdv90u5e6xFC16bIAaCe
         HN5mSDfZ5XW93YMWlf8ka3XqPBDteF/ZylC/zNuCs3CehAOm2u9mVvtm4m6v8bR3OJ/k
         3Fpg==
X-Gm-Message-State: AOJu0YwrZZZzPfmlu0r0pq27w9NfzEeeXmZdFi4je3FYv7ILLSNoms1l
	cakqdR3PdYWzV9hbfYbUNEsS3ldslRTB6Vh20JMP3AW97ORlQmM6qhVA/7M+0fTnIat7cCK7ygP
	r
X-Google-Smtp-Source: AGHT+IE64GyHq67VE8pirrW2FDU4RlqAjMQcz240MEYAq93zw87nqh1hYjRQUSstvSI4s0z8NpJcwg==
X-Received: by 2002:a05:6a00:a8d:b0:70b:705f:8c5d with SMTP id d2e1a72fcca58-710caf37c8emr334551b3a.4.1723081707421;
        Wed, 07 Aug 2024 18:48:27 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710cb20a104sm150771b3a.21.2024.08.07.18.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 18:48:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] io_uring/net: ensure expanded bundle recv gets marked for cleanup
Date: Wed,  7 Aug 2024 19:47:27 -0600
Message-ID: <20240808014823.272751-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240808014823.272751-1-axboe@kernel.dk>
References: <20240808014823.272751-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the iovec inside the kmsg isn't already allocated AND one gets
expanded beyond the fixed size, then the request may not already have
been marked for cleanup. Ensure that it is.

Cc: stable@vger.kernel.org
Fixes: 2f9c9515bdfd ("io_uring/net: support bundles for recv")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 594490a1389b..97a48408cec3 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1094,6 +1094,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
 			kmsg->free_iov_nr = ret;
 			kmsg->free_iov = arg.iovs;
+			req->flags |= REQ_F_NEED_CLEANUP;
 		}
 	} else {
 		void __user *buf;
-- 
2.43.0


