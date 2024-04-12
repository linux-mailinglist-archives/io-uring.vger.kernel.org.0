Return-Path: <io-uring+bounces-1524-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD278A2EA9
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 14:56:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99894284BE8
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 12:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051E45BACF;
	Fri, 12 Apr 2024 12:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h1woaI+B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649065B5C5;
	Fri, 12 Apr 2024 12:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712926541; cv=none; b=GlWXmhMVhPu8roivIRvUExmHQmOm0vDVP6mYYKJzfJ9nGqa0sk5Pcv7/FFV5NE/dn2fKaXr2VBH//wKgPacth8fX7X+e56GmOnHJye92HZFas+ssfXU4lYFKD4wvxXypRrVoSFLgvzugWcvtMeqX42zbeGmp2P5fqtZzCeZ0e3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712926541; c=relaxed/simple;
	bh=FRaoxelBlM5M3zFc8SaZ82xGErMRNCCauey/s2vGoj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=It1RbzzGL60F55JNPAPPrg+8ruo2skw3y83APtiIFru8cjdJcmIhNpsenhQnrd4rRgr5/S6YUgPFeKKXq8kZzUZLVp58xqlwH4edzG6OG7vtKFDHKg2TnCCyXzQ00vGa3Eh9UQD3/FvTwUbKBAowo8ox5BGCPM+20r7QteydVD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h1woaI+B; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a523dad53e0so48729766b.1;
        Fri, 12 Apr 2024 05:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712926538; x=1713531338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kh76fmEmFUyOwiJFHT8HJmKwt5ojCDL2FalDYbT9SG4=;
        b=h1woaI+BZomA6mfeZR4nQS4q6MyvQb5lMwI0CcmPy4Iz2BBhzx1id8veh+qRwy0NLv
         nNx+nZ0QaLG0MD77/ufonp96jbxz/xkrlPzJhkIWK1RSYN+wcNua5Q2WqG+RTe5mtcJg
         Ti/rjaRuLF/X9cryl41T8AvLUvZR6pJcne0vBGYqUGL4eJFeaX1CK5SPfDsu0tZIRSYy
         1BiIBw5yjI3Wumk4e/YNDLmQvmBCnvaHdS5xIWRnSPfQ+EKIFQf0k2ljqCT6ZJFIEXxb
         0efrB2SkS0rB2E1F5TzXftItRCQdaR36iqq9it75ATFcA5t2O310GZnaN3591wlNbtLl
         SUDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712926538; x=1713531338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kh76fmEmFUyOwiJFHT8HJmKwt5ojCDL2FalDYbT9SG4=;
        b=TBZJAc+nPPe0eGmH54w4vGAP8zI5G/ERxaIO55RoIRosU2S1UQCvXrWIvJb54bF4eE
         HFAzrB2PtpSMDRogaV89cU6+MTzDKr//5E/aINvB0bqIzkMyCslIoyDsmeuFdEipPF8Z
         a3zVuUndN0XJ9uaJC/pQdStpa0lYxe4hEexxqwPiH93qxlJpjntTzBX8vLOhMkWo74mq
         Koj68dmlOBK0bM4DSLbVXNFcgp5E0Mw4pGSEsQdKbJJFTK4Il/uJJTokSFgN7TTMTkRc
         3pYFhfZVLv0YPJ7hjTqRzb8dXlVBUNqTxzx6dDEAmiUx8iPr+SD5vVLDaQKmW3PQt6TU
         xlZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUArVAFgb2S94EMfMo/NG+yXrbCAT9blyTRPJWrAKcSrsWRoWur130MFHLk720ZbYoyScZ4apsdzYAA9qv1ts1QRTYzcp5S
X-Gm-Message-State: AOJu0YyP2ymT10jLSu94/5QoidnK/Rdld4L3QUDrRNFce+CnhtUlv584
	IpcrEmEMEh9nVL41kGbm/mw+Wmhj+ii2xOdXvsQ/e+zOBNyHXLkSCcaQpA==
X-Google-Smtp-Source: AGHT+IEx1N42p+GXLxy5yQ0lGqS7VgCNIuL2uYZAgsOpi+s0Fjx5W4y9pKQ3qPgNNMTv2rwrGyHJbg==
X-Received: by 2002:a17:907:9494:b0:a51:8672:66e4 with SMTP id dm20-20020a170907949400b00a51867266e4mr5573351ejc.22.1712926538551;
        Fri, 12 Apr 2024 05:55:38 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id qw17-20020a1709066a1100b00a473774b027sm1790903ejc.207.2024.04.12.05.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 05:55:37 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [RFC 4/6] io_uring/notif: remove ctx var from io_notif_tw_complete
Date: Fri, 12 Apr 2024 13:55:25 +0100
Message-ID: <b69c65b1df421865057f285d6309faee0d327096.1712923998.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712923998.git.asml.silence@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't need ctx in the hottest path, i.e. registered buffers,
let's get it only when we need it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 5a8b2fdd67fd..53532d78a947 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -12,13 +12,12 @@
 void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
-	struct io_ring_ctx *ctx = notif->ctx;
 
 	if (unlikely(nd->zc_report) && (nd->zc_copied || !nd->zc_used))
 		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
 
-	if (nd->account_pages && ctx->user) {
-		__io_unaccount_mem(ctx->user, nd->account_pages);
+	if (nd->account_pages && notif->ctx->user) {
+		__io_unaccount_mem(notif->ctx->user, nd->account_pages);
 		nd->account_pages = 0;
 	}
 	io_req_task_complete(notif, ts);
-- 
2.44.0


