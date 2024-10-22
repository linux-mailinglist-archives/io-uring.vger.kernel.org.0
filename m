Return-Path: <io-uring+bounces-3905-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E65D9AA33E
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 15:34:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C8C91C21EAE
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 13:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D8C1E481;
	Tue, 22 Oct 2024 13:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="msrrBwUP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208E98063C
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 13:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729604097; cv=none; b=fnN+sPKW9ggqOpgdci+TRhI4+TJtC9ohGBLxrLiuM170mQ87GzmQLcVV4TFU+w7ycnjNfhlgetal+MrkyCr1XIxsF/FDg4sqgL2MWgO41VHPW4TYxlglQoRbRQD99eOOo3g8Fw8P50280V8z9RqRWBxygvRkFgPPTm4WP2rseFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729604097; c=relaxed/simple;
	bh=xTsMZ1NscutzFx3vj+pkF7qRllj0ph1Ef4bK3IFUMp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RE3VgMGyT+RR45xKVipjjrHDRJZwdAizpl+GBOy2p1T7hbkXd8mh1ZBbdeHJhRM+lqt84/y3XeyZ/MAF5pd8fkyHtzxUG59Y7C3o+YQNjrJqWRzj7RYGqLvezwn4tfbbklViqGClRAwJvS8TSGGrXa0D/iIN5bKcGznD9kcuR8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=msrrBwUP; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a3b1aa0e80so23507025ab.1
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 06:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729604094; x=1730208894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBSkbQIxH9wsbcPCiHBwUytG72Sft1sfvVnb0fwF/aM=;
        b=msrrBwUPInQTBtQXxkeoH/a/L8PIRBkAO/pnLHodRZbUBV6ZzZbkpM/Jx26mnRS9zC
         toOFYnY03KF5exPK9DpC93ig21CiAxO3W0uulT9DiBO7iUkwHioECu6u9nnnh3WKNWTJ
         d+tpqYwghUuLKbD/0vVicEPWV7mYxcqHRkBYx8dJYGJHJFOjWDGydu/9Vd8MOgiNpezH
         iKtVk6YFRDTPAYTVOW+FrOxNhoJJc40RnmhQW71W/IwLvKUnvoVD4aJxjvV6xM4KJhR5
         /HnI/jK8FiYkG+GbQ1TLQwOLwhrm6n4LpxlvVOrl16oudPF6Tm7faXQVCBYEQVui2kjl
         HxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729604094; x=1730208894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dBSkbQIxH9wsbcPCiHBwUytG72Sft1sfvVnb0fwF/aM=;
        b=T3vxL39temuFMrnex9NMQ+64Sb+P5cUFYVfQN6MltrP8x1DuI4bg+a93HDpUb7+loJ
         d8Gf4c3rCgdjrV2LuKqZ27cxMv6XGl/r7TB+T0iAzpr++VPBN0S+Ousu3ZyJzsT+xX4V
         wITgmHybJULU7kWLi06TgL2uhIQqNGz0yLTM6SROMY3Oe99N/dtOQsN0UhK5MihbHjhK
         iLfJ8AGbjc8Tvb6jGn+RyfDNMGuPYao1AxbUg/LxF+Sx8chbS3uwPIjuanlybNA9Kk/G
         oOcXEM2LJ/GiT0eRtlwLbvwezFUAM/OR166HAYGfCDULvFEFAC1XNJj4AVTTmY+0njJy
         Yn1A==
X-Gm-Message-State: AOJu0YwRs5NkxLW84eD34mhkTJJnGpbfxm+siuSxCfhznCQCKJjc/Wns
	Wo31sHnoIG7FwHorc4SuEkZtJz1d2+3CcBPUZjXmSvnfYlvWzjstGnmS7ff4cSeBThnKQKRaEza
	6
X-Google-Smtp-Source: AGHT+IH2FiVI3lN+DbElsJUjmx+BnUqWqw/31iptPVelEvwM0t7mJkvZ0jTZi4N3P7zuFNt0DqHqPw==
X-Received: by 2002:a05:6e02:1d9b:b0:3a0:b631:76d4 with SMTP id e9e14a558f8ab-3a3f4045790mr152261065ab.1.1729604094286;
        Tue, 22 Oct 2024 06:34:54 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b7c76bsm18032385ab.72.2024.10.22.06.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 06:34:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: kill 'imu' from struct io_kiocb
Date: Tue, 22 Oct 2024 07:32:58 -0600
Message-ID: <20241022133441.855081-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022133441.855081-1-axboe@kernel.dk>
References: <20241022133441.855081-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's no longer being used, remove it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 391087144666..6d3ee71bd832 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -613,9 +613,6 @@ struct io_kiocb {
 	struct task_struct		*task;
 
 	union {
-		/* store used ubuf, so we can prevent reloading */
-		struct io_mapped_ubuf	*imu;
-
 		/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 		struct io_buffer	*kbuf;
 
-- 
2.45.2


