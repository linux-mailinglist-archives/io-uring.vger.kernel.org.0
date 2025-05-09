Return-Path: <io-uring+bounces-7927-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81A64AB11F3
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 13:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AC0B9E6091
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 11:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24422227EA1;
	Fri,  9 May 2025 11:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FSkhgMet"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470C827AC2E
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 11:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746789113; cv=none; b=Ac6agNAa9+wi8bn9ZA216KTkqTScW9CviYzLXMMeV0ky+VWWkA1sMq7NMc9SEkSY0wdkhX8v2famwWSsujkZysgIq2+Uo81C7D6zyS8biR3YArDyopd+4zwUrNAKByIugqoQMmFs7TRXpecBJzPrGz5d5T0C0yjLGhJPKigO/8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746789113; c=relaxed/simple;
	bh=CJ/t1FPJ/8Pk4Buf4sJdzB/vfaLCfU3jz3XmYMZa8p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IadYFNxZt01wXV6SsFpbOgELv3jLvFkpvWHKGtjsa/8ylK/BneNg3VBKhqpHXzRLrwCToUi6PFAYY16e9KzAshI4kI0VUJXnSvX5jd4aPK62nJaR/5I8/RlRobmrTl00HDPeublspfARMoaJsWG41ts+uVaXGyllVwomdSYUw8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FSkhgMet; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ad220f139adso96501666b.1
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 04:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746789109; x=1747393909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LW8VghWfnO7BP/dUHLdgglBX6Sfa/7U42eqxOBpBh38=;
        b=FSkhgMetijIJk7DwE88tx845FlRmKlPclmfwM8Cv8CzFxtWeC03gygKncaWKgfjTSV
         b7O7NzH0IZyLngAEKVT5pNntEByGY/Z6CZ/8wn+qsUPVvJVYFAuhqfs5LT0+egz0HosV
         yiqRauV1Da6+2qmR3PA2wXG07mI/O2Pr4SCCeWcgvXrDd9ZK2hvVyfwyZrU9CS4Vmie8
         9E+b/6GReM2kd7LW+3+jOys1ZsN1g6Egv9B/+X0khU3eCzHT5p5zTwTXHE290UofMmgc
         +54Uu+Pfh3WsC9wjgFELJU+vRXVasS79E1zXNtPbd7f58ab+0QB5Tl3rWxgGT+ZhWuzk
         LVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746789109; x=1747393909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LW8VghWfnO7BP/dUHLdgglBX6Sfa/7U42eqxOBpBh38=;
        b=HwCCe0plBWrzbkhoKvSDti+OsO33ituqk/yElucxwk8UPxjrb+icedEecEQ0RScvui
         RgpJwJnyRjakdp9VkKMcj4a8xDqLhKXJHnFbkr3e/MywHCTvZgCBeUpzHArGGPcpZ72b
         /k/x0UAyUBImY8BLOYOrDO495gn7yEzMU2lO0LbZ8vmfd5aT4oIqlDaOqF5BCpjM9ft3
         bqlZv+6j1WGu9y7y2zmNv+X+hgBwa0O+HCClsTLC9XO3nYDnhd4lMr4M6zYvTwcgfywx
         U2C7WtAAXgwmL9Z3OtcDxsAdd34Pk+Ir2cgysXDwhBSObuyIJrFS2jvAsvvU3qdkyFW3
         5MWA==
X-Gm-Message-State: AOJu0YywV/TfFGNgBK1+7lCWKYX7hN4BiaN8ZLsUtnDFsK8RGhWD1hQP
	TqMyre5JiGwtXhtKpe0NCAmEvO2i1zs45QRFOorK+BHd3pfzMvWro/OVPA==
X-Gm-Gg: ASbGncuHaUjH9FtWJpn7YdAwApWvhT0bBkAheMsj8Hi/l4OLVifHM4fTnYfgERHUIbf
	OOb8sIwnjwCueGthOje5kRr9yjTggmKFrl13P7ZvvkZ/M+Nkyo6hCFC7QFlPeKU/UOIt4Kn8dOb
	vtK98YVes+XgI3B+g2QPP2ap7JWTFiJrleErBtvrUfDGn7GBBX0puy0HXJCwtcoK5jz8Svylebb
	clRABlkjHbTlY8aUqLzjVGAhfJu9JxjCQEBgJk8w7FKqDr9Wa8BAla+GfezYYW6oy8r5cnsr+ML
	8bsW9s3xcO8Y8jLZ8V8ZYJnW
X-Google-Smtp-Source: AGHT+IHHmjdwr1s+EhHLc7pAWlGvGzvB08yxbozPYCekXpMCF/uUSNRo/t35q7sLmR0aR/E02dCBgw==
X-Received: by 2002:a17:907:7da2:b0:ace:3a1b:d3d with SMTP id a640c23a62f3a-ad218ea82a1mr310348066b.2.1746789108830;
        Fri, 09 May 2025 04:11:48 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a65])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad219746dfasm132717066b.119.2025.05.09.04.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:11:48 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 4/8] io_uring: remove drain prealloc checks
Date: Fri,  9 May 2025 12:12:50 +0100
Message-ID: <4d06e89ed07611993d7bf89182de2300858379bd.1746788718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746788718.git.asml.silence@gmail.com>
References: <cover.1746788718.git.asml.silence@gmail.com>
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
index c32fae28ea52..e3f6914304a2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1671,17 +1671,6 @@ static __cold void io_drain_req(struct io_kiocb *req)
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
@@ -1693,7 +1682,9 @@ static __cold void io_drain_req(struct io_kiocb *req)
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


