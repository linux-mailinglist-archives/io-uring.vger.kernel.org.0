Return-Path: <io-uring+bounces-7912-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB01AAF925
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 13:51:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3BC33B856B
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 11:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52813222595;
	Thu,  8 May 2025 11:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OpkCp3/z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F834221FCE
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 11:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746705084; cv=none; b=tMnfwKTcQ1oKPk3xFIKfAhyEndWSZ/b5dutH2BCwBFHShKnmU2wQs0RCO1sSKhmcLvoOFmDm8ZUsV/iNKg24t37C2lllYrINM4T7DRISAueO2L++ND5iH4DVUa0JHmaQzcfuI/CEKULSvLIcY0R62ZODUZEbHgN1VTwJtr6QqNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746705084; c=relaxed/simple;
	bh=2CxEwFxQJQqddnF+J0xnf6PnhNBywEditudWRVqHCn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPTfMNMLUj6e2ST+E6M8i8m3z8GGhBuJjUJ6zxf69aVciXIBh+lJPNjNP88LEkfvFr+9PGJbYqodWNCFApozIEVxyffIYmwItAzDR/OuVbxTWveSn5raezCfp00budrvRRPf+3Myl5jB71KBcDr5UD+u/DOMhZ4hLUbVCvxb3fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OpkCp3/z; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5fbda5a8561so1227986a12.2
        for <io-uring@vger.kernel.org>; Thu, 08 May 2025 04:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746705080; x=1747309880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bbT15t+NWlk14b160zx1oBk4D95vv8cOwdB/GDgvbgw=;
        b=OpkCp3/zSWT6TnYpm46VVwN3/SIxN3EOdaDdsiyrpiXQ/f5JTLLzwgXDKbM2HvPofC
         3qtfE3mMG+V2ofy5W9XiDGMGw+CIakVMkrZZb2l05y4fnyT38dhE+KhQPh6UYxsuPaZp
         xbSsOW1pBWJHZVjdUgbddOCswrGhzSOtFFBI1Fs2p9bI+hl/rIxwPHnKC3PRJhyrp1W4
         v2QSQG5zBSDcwxS9qcVWjABq2+pRlIcd9EHX7OzVdBpoA4Rq0AMFPNsybuQrhC5eNexh
         9ZrBoVOLVXmVIvQnxJhACqbUHKkHSEv1gCyLY4qt9Ejl1Bf1Ql3RUDWHyN7QYuSeNWos
         Y6kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746705080; x=1747309880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bbT15t+NWlk14b160zx1oBk4D95vv8cOwdB/GDgvbgw=;
        b=C3jYvsuQmDn3N05xkfkK9gaTaNOailjXkebreKlaZXvSKvHE+qJB6gzlcoXYvXsZ3q
         A1aDXgGLKbCmr9yeAvrRR5vxXu6P14cRq1bux8aNTUyyJ9U2g5WgIt+wddMPGwUtwGaL
         veryrIq1uZsis3RITBiMGR/Kunq+U0fFJVBtqknRa11hY8LOpQSG1kcyZar4H79DmD6e
         1g/l0UMTGVs2C60WU1wEwKbnMLvYC2yXZcy5ZXHFCKPH18t3z26hu8aJZWO91yQ4n/Fj
         e8gFnuxOvmdb39/QabmlJFB/dk9luRepAKgihy2DvvBJtH7+glXwa5JArszfkHH8zTQI
         eFBQ==
X-Gm-Message-State: AOJu0YwYGiQeRqEypiNZtPiF2dl71aBnZRuoc1+51PclvyA1kqBsCiik
	yzZxBT9+Kt0D8ZTjdhWKaRgOoQ5L9/WFOz0f6TaqAonS04Mkai526lYYhQ==
X-Gm-Gg: ASbGncsnNEXgLBgLz9tISbGfCZ7G037MgGdDEBgCeuBUcvBLYLSyWWYhNQcJyCI9t+i
	59HVciMSKdEDH0tjw4Wjbbjs0VLHwaZu2sxGfR5RMCj8UCCaOYEc4VBFk/Mnbcb+Z4ZRT9YPmjy
	fa5C72OoW6w0XIahrLF7fNhHX3pEaoPHfFRvygYvRkFbcOv7WGoT1mBQw4JfwJLHCvUQ34vINTl
	XsPR28MHvnQ4/x0GeMC42iM+N1UlfGdwtXhmrWiAJydGJWO0L8UKpUS/Kc1+QPEYNwEXvGfPc7k
	azruc/blHuLfGcCMeoS1/dRQ
X-Google-Smtp-Source: AGHT+IF/az8dNiICU9Ru3vpUKXAN/jskqO/F81z5i012K+9lu5qWzG2aGJXQNmUW9dk1zZCH8c+xsQ==
X-Received: by 2002:a05:6402:84f:b0:5ee:486:9d4b with SMTP id 4fb4d7f45d1cf-5fbe9fa802dmr5798844a12.34.1746705079675;
        Thu, 08 May 2025 04:51:19 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2cb4])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fc8d6f65d6sm677051a12.13.2025.05.08.04.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 04:51:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/6] io_uring: remove drain prealloc checks
Date: Thu,  8 May 2025 12:52:23 +0100
Message-ID: <dd566f1986ea1feb2f2ed5a0344f05cebb9415b3.1746702098.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746702098.git.asml.silence@gmail.com>
References: <cover.1746702098.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently io_drain_req() has two steps. The first is fast path checking
sequence numbers. The second is allocations, rechecking and actual
queuing. Further simplify it by removing the first step.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 21b70ad0edc4..72ae350f4f8b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1659,17 +1659,6 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	struct io_defer_entry *de;
 	u32 seq = io_get_sequence(req);
 
-	/* Still need defer if there is pending req in defer list. */
-	spin_lock(&ctx->completion_lock);
-	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list)) {
-		spin_unlock(&ctx->completion_lock);
-queue:
-		ctx->drain_active = false;
-		io_req_task_queue(req);
-		return;
-	}
-	spin_unlock(&ctx->completion_lock);
-
 	io_prep_async_link(req);
 	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
@@ -1681,7 +1670,9 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	if (!req_need_defer(req, seq) && list_empty(&ctx->defer_list)) {
 		spin_unlock(&ctx->completion_lock);
 		kfree(de);
-		goto queue;
+		ctx->drain_active = false;
+		io_req_task_queue(req);
+		return;
 	}
 
 	trace_io_uring_defer(req);
-- 
2.49.0


