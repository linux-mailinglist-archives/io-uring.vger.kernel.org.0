Return-Path: <io-uring+bounces-579-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D44F84CFA7
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 18:19:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C4711C2254C
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 17:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A910823B4;
	Wed,  7 Feb 2024 17:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QOM0jQSa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CBF823D9
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 17:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707326393; cv=none; b=ut1dYsC4Bl57vahOKj+yCBjuyCA9kf+2ENiQoiPD2NXKGSKb5bC5cRS7G+VdoEkdiUlcXVJqKh/olIOk74Pkx7hZYS6nkIyZZixIhWvecH4U2uD41ZRp16RfSkRf/i4EV4ks7c0I9K8aKujZRUK8plSykojOjhxWixbQnTfMErM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707326393; c=relaxed/simple;
	bh=t+UUO9ziUzttYNdzy1UEtG1LdRlHQTp7m6IMRSUs1to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoMm8kV8Nd1YvMfSWgK/KOvikZOuReeB1eJfxZwR/cP/L3KSb+UlR/gLborsFnf+u+lZD682aI3Bg+p2Pvx0w4fzrAcMVLqtzQw55hzdcd8YRc54l5v5+2YLhxTvM3ik7+gKCg1SFuN5o3RSUHWvFJYYaMIcTAVJolZu/ZavISQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QOM0jQSa; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso17090039f.1
        for <io-uring@vger.kernel.org>; Wed, 07 Feb 2024 09:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707326390; x=1707931190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jdSGsBvnf6lEB/G2k9YOuPATM50KlQkAbmUJzXz9v+E=;
        b=QOM0jQSaMhFno/705z6WVzj95Ml/FL2fZtn6xANpwm/FZWmz+XnlUpf6qI1r15xv0V
         nTTHxhH5CPoDyL7vjOoqxoLzTHyxdnEhbqV4ratgdmOIsbBZ6CeglK6hAjQO+oW/m4lr
         qfAGSngWyaUvuLC6paRUDqoxKwLslwOaarod05J2HCZRiRtdT/y5ais7MDG7uqS1Q25l
         SRyYucbTThGQgZv+qiX9lZSr5t/G+xmC0N9+EA0Q4c6OdomX05l8IJMWyDeamL0QNKax
         qiITzIrJdbfD3MvcQrRIULhxfhk5CCnAfPYQdkrRVLgRwwON3xcxWxMNFAegMvzDX5Qt
         EvbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707326390; x=1707931190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jdSGsBvnf6lEB/G2k9YOuPATM50KlQkAbmUJzXz9v+E=;
        b=Qxe433yJjJd/DNTmev2mdza2p+iCZq3JsrQO7Y+0Ve4F453S04DOztxoettRH0i1Ao
         ktnwyill8wRo+IICFfc8gfe6Ow0Fg7loEatRVzzKssaJ451K7TbsE8iVoH2+EKXVmlv1
         14fqJ54z67HzfhWQnvd0MroF1kio52HcsNqJUMXNtz2LNIsm5pR41ASiM20651qUier9
         FUntnufkfH1J7jW1a8KygsJg3OCVSYqWCxO9omrOthSxr1upbn90Vv+SXrCwxI0fV4NZ
         2pcmClKXTiiUkAw5Kh3l1y8rRWOxbtAKwOWdiO/CwImgqJsinX+CaXN2KWKlIke5OQH+
         5XXg==
X-Gm-Message-State: AOJu0YxfHe51JXi8sin5VrMvp7BMhYVEERIrFAL15iSeG/tIsf0BF/tQ
	QeANsS2TTqxc7038kQzmgskBSSE18p0QXnbTKoydZrugvtzZWpRw7VduM5m7mffsfyZ8h2i3GYu
	4VWQ=
X-Google-Smtp-Source: AGHT+IFESC5GmgQoA3BAteoM6wTRGVBPg3BqlAkC6g1NqKzbqviFuZ3t8qOvS91WjB88HhTo2Jrltg==
X-Received: by 2002:a05:6602:155:b0:7c4:655:6e05 with SMTP id v21-20020a056602015500b007c406556e05mr472905iot.2.1707326390372;
        Wed, 07 Feb 2024 09:19:50 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g22-20020a6b7616000000b007bc4622d199sm421131iom.22.2024.02.07.09.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 09:19:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring: cleanup io_req_complete_post()
Date: Wed,  7 Feb 2024 10:17:39 -0700
Message-ID: <20240207171941.1091453-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240207171941.1091453-1-axboe@kernel.dk>
References: <20240207171941.1091453-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the ctx declaration and assignment up to be generally available
in the function, as we use req->ctx at the top anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 17bd16be1dfd..704df7e23734 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1024,15 +1024,15 @@ static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
-	if (req->ctx->task_complete && req->ctx->submitter_task != current) {
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (ctx->task_complete && ctx->submitter_task != current) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
-		   !(req->ctx->flags & IORING_SETUP_IOPOLL)) {
+		   !(ctx->flags & IORING_SETUP_IOPOLL)) {
 		__io_req_complete_post(req, issue_flags);
 	} else {
-		struct io_ring_ctx *ctx = req->ctx;
-
 		mutex_lock(&ctx->uring_lock);
 		__io_req_complete_post(req, issue_flags & ~IO_URING_F_UNLOCKED);
 		mutex_unlock(&ctx->uring_lock);
-- 
2.43.0


