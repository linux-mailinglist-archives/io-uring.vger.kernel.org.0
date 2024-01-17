Return-Path: <io-uring+bounces-409-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FEC482FE22
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 01:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2A6E1C2407A
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 00:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB6410E9;
	Wed, 17 Jan 2024 00:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJW6ckN7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D559E10EB
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 00:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705453168; cv=none; b=FoQowb4UUg8tAVR3+r5VybkKE0OyJHcMtDDoZGNOcUXC37TtxMCm/U9npnBbcCgTcexCh/+HLRapgte3dUTR3bYcWCFXv0Bw/CwBgWJFNn/sZNEnUPswePiepOLB+oX//1RHno81ZFbF3wu8VuyPoFxg1IWLkUQFDGOLOrtH6+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705453168; c=relaxed/simple;
	bh=YMznjEf2a8GlGttKETk1u68AD78RsrhIxfuBPyoIpow=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding; b=PU1LRQwwMgX83L+v49LFwBr3DwUL2j1wXwnupZsHZtFm2CPu0Z9OX3czPH8vqhgorhK1nZap6fcqEw0iNQGCP5/f2pQ3QeyRoQDjNtWExHiH+sGg+qs2Nhyoh42cWE3Hz+iOxHI26ZGiA88qviJGf40SwlMieHRkx0JX7kOGw+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GJW6ckN7; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a26ed1e05c7so1255981566b.2
        for <io-uring@vger.kernel.org>; Tue, 16 Jan 2024 16:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705453164; x=1706057964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=12lNFekc1W9jCZeXaALJhzL0q/MnoIeGAfSUPTmqtYE=;
        b=GJW6ckN7TtgljZtthHhukCs8z1sq8D08T9FD58AAD2Bt/w6oEzxgyeaedx4n/9q7nM
         XNMrd2wark3dCRwCPE8OzyPPraHvipzVTvRAFQLdKwQ6yQmrzHoWMnUbxDcP23j35VnZ
         fH/JsgAugK6Gi1PKbXlgkvvLk6nIdg/e7K+Sp4BBD/V4khpPz04Rr6JMcYYh2EEfx/32
         sH/efDPP4leLc+BIwYwKwVjYDtMOWm/QB37/iEl0GJAPdrkNTN9xMbJuqzRUz77OJxpZ
         JebeCsaukZbpYKUYiiLjNFEj+9DDR89TaFWI3guGLWRbJUCc1Mnh0GKCeVzCYGI9+L3X
         t1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705453164; x=1706057964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=12lNFekc1W9jCZeXaALJhzL0q/MnoIeGAfSUPTmqtYE=;
        b=UzXcCtIc4EuU70ISjK/xpDXrWk/hagELjqXVCQICd5TyDrqqFDiBbtDUoS6lbKkAbT
         OAETk96XmwPXsaEnsbY4DovMOb+g3QbcVJ9fGxg/wPpTg+0beE6NC6hVE9ivWJrhqDI3
         O0+sNl8RDnGG3CIDYfPMpQiaX9H87M0CNdtFkig9nglMD/AVnzZQIsGZIW8+dviIDkDE
         uNvexLMu0u737SV1wf9rqySppnbSWlnCHwVT8nhsJ/UCTz8EfvR8lmYNUciYdrQAN+4W
         pwjD94wJPj63vWyEf6+nRvuvZrm6C17Fe43Gu5vZOiSJLjTjMYp075bMFuG68Ib2qUCw
         tqHQ==
X-Gm-Message-State: AOJu0YxpQSu0LHHFrYIcfDTpJpEZrW4GpweeA04x6HC7/nJGF1Cg/bLY
	YMSCydqgYsJ7XNxsCdhyDgHWRsuO8LY=
X-Google-Smtp-Source: AGHT+IENoGOkfZ9OQGpcilq7E43F0vj3/UPqCZf9p+Mm7ASHIerNTx9fB4AU0pb9VHMvh+Hgvbn/1A==
X-Received: by 2002:a17:906:1411:b0:a23:4e3a:4356 with SMTP id p17-20020a170906141100b00a234e3a4356mr2271441ejc.182.1705453164528;
        Tue, 16 Jan 2024 16:59:24 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.96])
        by smtp.gmail.com with ESMTPSA id t15-20020a17090605cf00b00a28aa4871c7sm7038982ejt.205.2024.01.16.16.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jan 2024 16:59:23 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/4] io_uring: adjust defer tw counting
Date: Wed, 17 Jan 2024 00:57:26 +0000
Message-ID: <108b971e958deaf7048342930c341ba90f75d806.1705438669.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1705438669.git.asml.silence@gmail.com>
References: <cover.1705438669.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The UINT_MAX work item counting bias in io_req_local_work_add() in case
of !IOU_F_TWQ_LAZY_WAKE works in a sense that we will not miss a wake up,
however it's still eerie. In particular, if we add a lazy work item
after a non-lazy one, we'll increment it and get nr_tw==0, and
subsequent adds may try to unnecessarily wake up the task, which is
though not so likely to happen in real workloads.

Half the bias, it's still large enough to be larger than any valid
->cq_wait_nr, which is limited by IORING_MAX_CQ_ENTRIES, but further
have a good enough of space before it overflows.

Fixes: 8751d15426a31 ("io_uring: reduce scheduling due to tw")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 50c9f04bc193..d40c767a6216 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1325,7 +1325,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 		nr_tw = nr_tw_prev + 1;
 		/* Large enough to fail the nr_wait comparison below */
 		if (!(flags & IOU_F_TWQ_LAZY_WAKE))
-			nr_tw = -1U;
+			nr_tw = INT_MAX;
 
 		req->nr_tw = nr_tw;
 		req->io_task_work.node.next = first;
-- 
2.43.0


