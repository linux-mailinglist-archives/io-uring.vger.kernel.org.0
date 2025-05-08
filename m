Return-Path: <io-uring+bounces-7911-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 780CFAAF924
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 13:51:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE7A7461493
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 11:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D231223335;
	Thu,  8 May 2025 11:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Utcs+Rx8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F83221FCE
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 11:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746705081; cv=none; b=l8SJqRxYerH0Oz4aJxROiBViqtMXGDVT0wNzHCqhukLL56/7yJRCq6pgEkISsxc7aweGEpzfzf/2vaz+B1Cz1FrEwlCogtr2qcsr3Y59kXcsx4DX3wFfaUFXiR6UimZHt2o2ZLFLvwz6DL8aabRUi7wt6VHo0Z+NIweoxJ9rIEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746705081; c=relaxed/simple;
	bh=RM4ekpj3ZPjqUwAT1OVpj4idaLJWCVfbHTNvhPboRlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USqDBObTrsnxwXyLjHPMefFmejQe7o+yilNxPYnjB18m4FPJNGOHCp0bjsjvYtr4l1kpuPgaU7lzVuHwKqS9LSoGdqTLApesRrrPIT8NAyV/dFtaPnKNa3rMzlIV9Ch7KEIrXdSt4i9a6YBAwBuMCzfZnRrMZngWnJoR+XxL3cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Utcs+Rx8; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5fc8c68dc9fso1394123a12.1
        for <io-uring@vger.kernel.org>; Thu, 08 May 2025 04:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746705078; x=1747309878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ha9OFlA8sNCj48XGJLSxJRD/mOQpzH2wcW9h7R+NtU4=;
        b=Utcs+Rx8FfIi+5iWfawEbFowPoaGPHQlekc4wPyasQGkXSDBJG/WY7lScvwRyKsRmr
         f+dopHMh6W9afahocFVVXb90oIrLrqgqtHPptf6uIS6fICA3JOJzTHJMwoNNhoVA5ESX
         jS+Mzr1sa2oXAlpclqgKPzcIvyzwqZPxarQ/sYEirZIbQwQeunEN93IMREYrzmZrNCtH
         IOyXWzPxo3FuyFXrJX/lWn5M6xp/938Q0V3kpl7vW4BK2ceY4GAxWh7l2U/AHEfGr011
         8JpFNOmi3anZQlfZXZFNtTSQVPlbjyw2adVoUhN15FDxCMmfAz0dP5gL95jAErrW2rs0
         ZnsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746705078; x=1747309878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ha9OFlA8sNCj48XGJLSxJRD/mOQpzH2wcW9h7R+NtU4=;
        b=L/yZEFl6TXaG2Toze39O5Lww+qoo8XgCszSh9cwJeIe+5SjGhoIousHlJtF9FuGDLX
         4utlfvZD0/g3WcSBgfIwBoPRwUsHiJUDWIOwzOweWisx3VGyjLEahDfUvvnG/LLD2WA2
         FqcoSCgAaLXSTwd6Mz1dGmlvW5gLl7UHHEOYis1EEE9SUl8YTezlxb4vxVFSC/CNAnb6
         yYS7vkNF3nWWFoDsvrjqWxe6To5i/IcxD4EPfqFs4740LOuAifMnZjMg6AeKTJ2pW398
         e23S1DiTVKm4rTQ754ai0x3O3b+0QzAH0WSLBcNwV6tbZvPx4BWyz7Rilbx3SJv/2Qn+
         0xsg==
X-Gm-Message-State: AOJu0YxEjgzqR8CAPweRO6paBf1n8Wub8f21/RhVlOpvelHYJJCTNFN8
	HLmnaLPQI5Lsh/8IsuDsKeHE7Kb5M5GpCTFd3/olxCALv9+fpIJACK+p9A==
X-Gm-Gg: ASbGncu3YvoVXQgFTLzPnpPt/nKQKNdlULe/NJI94552we/k1MO806tV2hyPwEP7Sj1
	ySVF8pfeY+jqUsKtUYDhr2yy/o7sbKQONSigah+0o8EhsNyo9w2za0Yuex8QaaKUj9wsvNf/oUe
	PqHgDWu6IdyWkvVGqsj8sEEwtIS+f9L+iGV8zD3kAp8d3WOMECt0k2do4Zg7OiA2+CZJCCm1MsR
	AJYOsIYj0MOGiiNkS7TnK+s0jrxdibuoSU3sVm720YgNcrnXx4Cmlg/WYGxtlRTOSzZI9Ix4qZH
	HqLCm5sVQSmEcnZ8JkbzW9nY
X-Google-Smtp-Source: AGHT+IEuNRy66Tpr3IX+h61Fe0obRouLX/90LbxIPk4gdD7jHN+pdTLxoGOj8vguSr0YcA9zQV+Q0g==
X-Received: by 2002:a05:6402:27d2:b0:5f6:25d6:71e1 with SMTP id 4fb4d7f45d1cf-5fbe96cc0b9mr6235018a12.0.1746705077685;
        Thu, 08 May 2025 04:51:17 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2cb4])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fc8d6f65d6sm677051a12.13.2025.05.08.04.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 04:51:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/6] io_uring: simplify drain ret passing
Date: Thu,  8 May 2025 12:52:22 +0100
Message-ID: <af14f58cecc55b078959cdac93cdaaa7822b3c3f.1746702098.git.asml.silence@gmail.com>
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

"ret" in io_drain_req() is only used in one place, remove it and pass
-ENOMEM directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 23e283e65eeb..21b70ad0edc4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1657,7 +1657,6 @@ static __cold void io_drain_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
-	int ret;
 	u32 seq = io_get_sequence(req);
 
 	/* Still need defer if there is pending req in defer list. */
@@ -1674,8 +1673,7 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	io_prep_async_link(req);
 	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
-		ret = -ENOMEM;
-		io_req_defer_failed(req, ret);
+		io_req_defer_failed(req, -ENOMEM);
 		return;
 	}
 
-- 
2.49.0


