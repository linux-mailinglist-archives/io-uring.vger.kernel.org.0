Return-Path: <io-uring+bounces-2256-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D1290DC02
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 20:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 36E07B22106
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 18:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD43615ECCE;
	Tue, 18 Jun 2024 18:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qZA0489F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81C715ECCD
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 18:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718737001; cv=none; b=ThELyObgqqMKYDui5ln82q6WT+SMDzp9PXAOKh4s6oC7YcIPgTcAUcPNiP5Wraq/Gi/z1/uRMvv4QPxogpR2EmbU3RvHawcsgVbJPhb7qG7BD9CvV5AIGyTQU+ULUcnF63gBW3QJfW3+cOUe8ssAOKIuQDAloL0aW7CAiGk8sOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718737001; c=relaxed/simple;
	bh=Dg7eZOnIgLth5/bbTSu+ZhOWjL8S1TMLSv1i4QJE9bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBux6srKJLPGnCSb8XrysmJXfEXm4FJ8Z7h69T6aczJ6oBx+qtp0vhI/ZTP9466i1f+fPHRrfTUyzBpH8gBOoaxSfzTPu4Ab5PunoZGNnu3YpzeCPTFd1UGrON2MjBkng1FiDwyyDf0vC1Og28aLeN8LuB8FjuwXCNFxCGh/5U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qZA0489F; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3d21cb3833cso198439b6e.2
        for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 11:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718736998; x=1719341798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1EmDC2bGMmU0XeSvchLBl6+1crQIfO4g6MqrY1wcIM=;
        b=qZA0489F2bv7bK0rZKWSiZJOyW3hkphIDPx2B/UPzCKq0YNijL9JFY1TcFOdENyr+a
         K8tNbxtrmrewpOYNz+8ONRJG7y8af8JRjtRiuKH3rdVTg3TWuXdqPKaSGGuclLGSN1ZB
         4yZxSC8Tnisf9yCK064+Wc2ZAeIj5ftP18ctLTFBj4b7BkD9hYZLykBNxpx9bTy/J8/i
         MF6cgAMBQw+JneODjL/t/sWsV3tZLDmNyLJ+e8Iqxb3l40o6QkEisyJU3nuBxxseIXn2
         tn7DDHu3qgguG+QJ6ARU9QSsi5ZMPXrtY88afQYQi7pUMzNP9tXrVWLnfseoPwcNZ/rM
         t2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718736998; x=1719341798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T1EmDC2bGMmU0XeSvchLBl6+1crQIfO4g6MqrY1wcIM=;
        b=nglW/JVA0KFGmHE0aF1oyWspjG5o888f/OY/GGu2fl6D3o9bDHhWG8xpD8qDOi9Gmh
         ILw4c11d98UklqkrKdGE5lWT6WtebSW0qo9OmnKvck/Jw0p6bsjKXjbKAqoR/WUxQJw5
         Uclw46xo8bWgpS1CemqMruHgayCY+2AYquW4gyLCwv+dV0/2a+WwpgDsCtPDMEhGxaki
         MpIGDmppaW+EocHG0orGD7aJIU8fPrFl3jSRoX0KpQEk7dyuJm7+y5W/ydkcrZFJQS/W
         Xcu+Ke60aYqNddGHBSCadCLcJevqhFGiH2Oedwl/51bWGKyXSctrBwCy3V04OPKqZ8K8
         J1ew==
X-Gm-Message-State: AOJu0Yw4kh5ERp3KKHE5ayCbmn+qczHwMEagN7qJmapKE08jJAO3ItOE
	xF2hibbNlChhjj5uWW8xuXLoxskYI4ZMeuHYfAquBWb4sH8gGQOt7vFp5YvGpY2u6AI0n9kCPwD
	Q
X-Google-Smtp-Source: AGHT+IFu3gYPd84wGTjZbeDH+YWLvT4rEBMmk69RJTTtKTWIk62ifXIgJ4jsJ9G0T0eTU76e2Exlvw==
X-Received: by 2002:a05:6870:ec8e:b0:254:d417:34ff with SMTP id 586e51a60fabf-25c94da7916mr664194fac.4.1718736996396;
        Tue, 18 Jun 2024 11:56:36 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2567a9f7d6fsm3255492fac.20.2024.06.18.11.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 11:56:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring/msg_ring: tighten requirement for remote posting
Date: Tue, 18 Jun 2024 12:48:40 -0600
Message-ID: <20240618185631.71781-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618185631.71781-1-axboe@kernel.dk>
References: <20240618185631.71781-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently this is gated on whether or not the target ring needs a local
completion - and if so, whether or not we're running on the right task.
The use case for same thread cross posting is probably a lot less
relevant than remote posting. And since we're going to improve this
situation anyway, just gate it on local posting and ignore what task
we're currently running on.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 81c4a9d43729..9fdb0cc19bfd 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -68,9 +68,7 @@ void io_msg_ring_cleanup(struct io_kiocb *req)
 
 static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 {
-	if (!target_ctx->task_complete)
-		return false;
-	return current != target_ctx->submitter_task;
+	return target_ctx->task_complete;
 }
 
 static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
-- 
2.43.0


