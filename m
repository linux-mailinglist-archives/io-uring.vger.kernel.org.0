Return-Path: <io-uring+bounces-9137-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDCAB2EB15
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11746567691
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A5E2D8781;
	Thu, 21 Aug 2025 02:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OZjyjWd1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EDA2D8798
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755742115; cv=none; b=LcTgLqnUPNGgOGbDdDSSwiBwnnOp/Qtm89xMA9M3kuqQNo0UhuYS5Z24PtLfEqsWOrI5HYUSphlEEM3DNdE4BkX0xIBZXgg581KAoBK+5zC2liJc2xFoXKPuk6DCm6YY3scjmsFU44h81BN+yOdyomUOQ8geNlj3208kybp1bvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755742115; c=relaxed/simple;
	bh=26CxhChv9zPAE4spgh4Ej0xjlDhgmvIAYFHEx6Bpmys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=co7MfXZJyS2NHcDo1I8H8ff+jphTVa52hogLQlRzc/PSlf/dfjBEDmSTWu+CFtzE26kQLY/WaIw8jy/GmKJxU7CNvN/xZWoBSirAyCYz4ZCXQtCaiOUnBec1LMEmFt+BUZa9x4tg8V3fneOwErK1/mKiT++7zna367mZB0ZiEg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OZjyjWd1; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24458195495so3091525ad.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755742111; x=1756346911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6BTgAvpf2GfBCrubS/n8RMiZWjAee4q4dHTjvT2jHp0=;
        b=OZjyjWd1U8QlyVJVXY6DdMFFklfGJdJeAroqUdnKKK3eL9V1r6nEL1/3ch55btEWQg
         SmH98GK2gMX3o35cUZhvpuhD+Uoo0ehpqUG0hz6BHXs0yJ2M2NK7qQVnfjyb/SKhzRdQ
         DY7Nd+RSEDSCcGhszcelVhSD9rZaLjxqTleo+O2BBz6JRFLZv3Yxc+UnTRp+vEt6urjQ
         blV+V31yqdr4PNtyKkHZyh/9HMNQr3zRwfsrAtIQjIJ2ix2EqSktLXKknEOskTClZ08I
         xXo8twnthuWWgQ4nXtHLnaJAVM77bRlWLWOv38Q7gFOfQsHqI+SGLQMjUOy+qlO8oF6K
         mDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742111; x=1756346911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6BTgAvpf2GfBCrubS/n8RMiZWjAee4q4dHTjvT2jHp0=;
        b=MGoOo60anwTqiwHelMguC55nt3UiiCEfI/oPHNACbomlt4xITgSqOR1IJ8XoQhtC/T
         RilgPdzcOSR3lpWu5HhAnQKLqhbY+VXb32wfdJyLWBwHgkKo+szlS0y9fzDCvFKSQc3H
         289nMtBb94InSQ5qaC3tz4xk6+yQ/WKMbeJKxc5BsVRaDL1/QaIOBbc37EVccZqTfnjZ
         pM4pI/hMdhHr/Hm0dsPO/B0Lyj/C8GhcM3HbkgiDqYZ2WtkXcLpSIPzQS1/bzjXh+PtQ
         OePtISSfgBHkPNM55mm8rF+wBY70BWkqlqsryr6wmAK7zhr9+KCFMvmudtN8NHfuJyA/
         ilEg==
X-Gm-Message-State: AOJu0Yw5oZqEKjz6sUH6lFJrjgfQ9Z6RuxBWW4MEWgb4zwjUFkLRBW+C
	AJuTMa6fq5kZs7xrpDm6HWTN/WuBEfiGYtIxXpdOJKGxKtODVsZI9QxVjJ4mR/CU4vr7qcFotJm
	AASv4
X-Gm-Gg: ASbGncthg1rZHe7U/ltNmg6syt+6aB1czgiqC7i5nbzuyckoUwntEzDGFXiDgOnRr+W
	m5v9EBvGV1xrRk5Mx2bK0AlvdE5U/Q2O4io4mJffP9naSbwjY6tRHObvnePedNhm7Tk6yu0S3mC
	MRuvH48/dPFFUQPCPdb68se+fDtA9zMvauwa/X7V+s96nYu1b+m3mn5zI17/F3vq6+smyacXkCW
	eKbd+sHE5m8RtU6iIOXpcZSrLNLfF17lManczJ2C0YvMk7JrX3lcJPuBYGQsVyqrDK7chCk4Nkl
	P8HaqQq87z3e5u2mjbF0MuZno7bnGoPojGLRo0fJYWvIhwehjC+2N0GVddHoQLFGl72tUfeiG26
	7d3N9ArabDl+19yY8gSn1W4i5iej3
X-Google-Smtp-Source: AGHT+IENAE7h/lYds0sShWSmg4oMs0GrgIJJw5s+XFirA1CU5r4nz7H21bNdUj9s1J75CPpj6SqJVg==
X-Received: by 2002:a17:902:e543:b0:244:214f:13b7 with SMTP id d9443c01a7336-245fede0a56mr10535815ad.53.1755742111337;
        Wed, 20 Aug 2025 19:08:31 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f381812asm104827a91.0.2025.08.20.19.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 19:08:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/12] io_uring/net: don't use io_net_kbuf_recyle() for non-provided cases
Date: Wed, 20 Aug 2025 20:03:31 -0600
Message-ID: <20250821020750.598432-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821020750.598432-2-axboe@kernel.dk>
References: <20250821020750.598432-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A previous commit used io_net_kbuf_recyle() for any network helper that
did IO and needed partial retry. However, that's only needed if the
opcode does buffer selection, which isnt support for sendzc, sendmsg_zc,
or sendmsg. Just remove them - they don't do any harm, but it is a bit
confusing when reading the code.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 3da253b80332..a8a6586bc416 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -570,7 +570,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 			kmsg->msg.msg_controllen = 0;
 			kmsg->msg.msg_control = NULL;
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1503,7 +1503,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 			zc->len -= ret;
 			zc->buf += ret;
 			zc->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1573,7 +1573,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
-- 
2.50.1


