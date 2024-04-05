Return-Path: <io-uring+bounces-1414-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E9B289A1CF
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 17:50:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3EC5FB25E2E
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 15:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A490816FF4B;
	Fri,  5 Apr 2024 15:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2Qg6rHa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED89416F901
	for <io-uring@vger.kernel.org>; Fri,  5 Apr 2024 15:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712332219; cv=none; b=Iwu5YbNnX3Ys3FBoHp/S+0beHpImRLfL4Pc6J5QUtmSc3z9tXUmzRxeESBCeJmNvrHCLqgbAw5A4Em99uoaDDEXzv7ydDsQASvhVJL/Am2GRJ6D3S+0qmT3IsItM6+aJMD3D2wYEOnyNwf6zRndj/luEPJXgJkLx/qPlqODLA0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712332219; c=relaxed/simple;
	bh=PW/UvTZciwyckou/rsg/Z4Tl6ixRaIRr4C8xP/RXwyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDmdWjn1L6IaatToheO/FpF1IcH/Lu/zVfRU4xPE7EHqde8fFW1uKjPzyjBxbiR0TJQ9SLFeN4+u1K8Irm5P6puFLWwm4HmGz2ABf980frS0tlb6BaHH1Zv68d6kLRJAkW2uMTdAsbhj30lak6WlIodinWe4W8ZTNZaG3eaOZ3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2Qg6rHa; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a519ef3054bso134019666b.1
        for <io-uring@vger.kernel.org>; Fri, 05 Apr 2024 08:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712332216; x=1712937016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rbECNWgvyLz4lhV88KMe5XuGXgBJQ2wLT/wNj0ZcIHU=;
        b=R2Qg6rHaXzdcBlkKAMQiwGgfRGChaB/h93WH3hvencHl38bWSlvFtRlJzLvZR75gLi
         7i7dppQrNzWTNkgpP6J57H9gu/rXadU7t6TVSK/9S5fAz229dflE0kmJGPce11nMe9WE
         0k30Edv+Z8lXuBF8aNrscnWgikSo2MTk4seIEYYI1Xqu/2aTDem4TaEQGHHO54dbEAMy
         xIexrFdejMV75j5ZpW8OtN7pWLJWkfS5/xyQ+dZ1GIhf6PYI/yH0V08yjXR1PJExfTqT
         7fFjsSmANH4OgaJBJvDtLrriQksWNUWsW1+lQp/UYAeVvvL4aNUbG7dodO1wNsIi92at
         fRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712332216; x=1712937016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rbECNWgvyLz4lhV88KMe5XuGXgBJQ2wLT/wNj0ZcIHU=;
        b=E0hXReUIJR/gKN9LOQB6G7pQHK6xcZUhXev00PoeCWJdJ0uPrSyntVU4Stu4SxVjMr
         DKZ8WYHMHW1Eyp8Hv9hq8yS9EU0VCi4uY/ZiJDW/kxs3hFRlbOnD3IeBKeayL2PYSGqx
         YQDubjs+S/DeT9r8hgEAAuFA5bbyZ9aaPkUwQxieb6SVzi6riEa1ADF20kkoK6uV/7qi
         U5deTE9UuFVqQAS+mguwjdOjF02hdl/pMgg41CI/f+T2x6TFfCr0b3oBJJzphjCDZ/jB
         GVHszPbiPfMZJCMn9bUUCW6RJyxzVRqOC/iPqs/V5qJd9LNH5kRydjYnxTvjHKs07u54
         fDiA==
X-Gm-Message-State: AOJu0YykaU5mGtZr6Jw4nGGpMfdmaSASTrs9pIf3ih3xJ2v1tO2DCFsq
	KNNC1NjgYNuOFGimvMVtgnCBsA4XfkyOOaiNJJzMbNEYFfwjqKflAm5BEZYa
X-Google-Smtp-Source: AGHT+IFzKsPrSJBg0Bhirk6U4AjuZ9ORTDJv6ro4m29ttMbh7f7XO+A1EylBks21K+xn1dIXtXKahw==
X-Received: by 2002:a17:906:709:b0:a4e:9190:eb18 with SMTP id y9-20020a170906070900b00a4e9190eb18mr1274668ejb.29.1712332215428;
        Fri, 05 Apr 2024 08:50:15 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id lc24-20020a170906f91800b00a46c8dbd5e4sm966105ejb.7.2024.04.05.08.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 08:50:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH for-next 4/4] io_uring: remove io_req_put_rsrc_locked()
Date: Fri,  5 Apr 2024 16:50:05 +0100
Message-ID: <a195bc78ac3d2c6fbaea72976e982fe51e50ecdd.1712331455.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712331455.git.asml.silence@gmail.com>
References: <cover.1712331455.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_req_put_rsrc_locked() is a weird shim function around
io_req_put_rsrc(). All calls to io_req_put_rsrc() require holding
->uring_lock, so we can just use it directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 ++---
 io_uring/rsrc.h     | 6 ------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b20ee6a0e32e..909842cb1436 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1451,10 +1451,9 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 				io_clean_op(req);
 		}
 		io_put_file(req);
-
-		io_req_put_rsrc_locked(req, ctx);
-
+		io_put_rsrc_node(ctx, req->rsrc_node);
 		io_put_task(req->task);
+
 		node = req->comp_list.next;
 		io_req_add_to_cache(req, ctx);
 	} while (node);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 83c079a707f8..c032ca3436ca 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -83,12 +83,6 @@ static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node
 		io_rsrc_node_ref_zero(node);
 }
 
-static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
-					  struct io_ring_ctx *ctx)
-{
-	io_put_rsrc_node(ctx, req->rsrc_node);
-}
-
 static inline void io_charge_rsrc_node(struct io_ring_ctx *ctx,
 				       struct io_rsrc_node *node)
 {
-- 
2.44.0


