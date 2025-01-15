Return-Path: <io-uring+bounces-5879-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54CA1A127B2
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 16:40:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 786F8166C74
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 15:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F8114B94B;
	Wed, 15 Jan 2025 15:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OeifHgSQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B969815539A
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 15:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736955608; cv=none; b=Dgckb8WbdWr6JGoPrWoaPHAyyWLKqofVrlMXcHIgXUq20ST1dgE9eAiAqvAdLmT4tx7MZojX9ejG+D2B3mI0ENATesZ3P0ifRc8exuf6AliMPG+NbxkHQzWFS8mu43praA+Xu2UNpT5jiCNhNzUG+fefU1GbsU8yaVxk133r3AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736955608; c=relaxed/simple;
	bh=3v5IFOWcq0DRW6TJ7r5KZPgT/WwIR4wU+NkeC0qNnII=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gq48xM//jTQBlobXdeKbchNfsy6t33Q7JKK4DVmisQXrCHWak2B6jqJ52Au6b34FLzcwmRJ/nSNv9PyRLT1vGFEETyJOXq3MCP76Dqt7DIcn4yPzkvva8kgaPNMt7dsm7MLLvxTpiHh8J4QEJIjISUBg0AxyJZlS5bzFwMzFiAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OeifHgSQ; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aafc9d75f8bso1297630566b.2
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 07:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736955604; x=1737560404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FcmeY4lilI4Ppcod5FQytZpZYJCRILkxaIwRmYjV9AY=;
        b=OeifHgSQ7xPKp+Gk3uTJNYriaGfG2YBwrQwqtQP+irpSWsnfj+eKQ4tysfBvRAmxnf
         cKbnkYouTCGcitYr7FaKCdeHvyY9cEHMF3k3A7alX8e0KrYbr3UJF5mwVyjNHi8vxVEt
         zRQaF4Dwa78NeYXbGmc90VX5lR6Uqi9IwsnWwFLFZQMrEQy6DM2iTDXU3qX9DecEihxv
         XGpNqdLFTv9JmTGOL5JTGmpq10H4WARSnsFvi+7SMJJX5Ylq7wNgUby+KN3u7/X1h3j2
         2gxVkUWI5RjgLKo5x7VrMrQSJId5Lz9e63QceuOixU6+giiGEOAZ8nGaZ9Al5wLs62OH
         oRWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736955604; x=1737560404;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FcmeY4lilI4Ppcod5FQytZpZYJCRILkxaIwRmYjV9AY=;
        b=o6VsOKrrgFf76z9Bbn1Hyodi8bQgL7C4r+ugJ7gK248k2rjbVytF1Gg8IrPXj6Fhyd
         /ryhbiHj/zTQocwNGSX6Md7itGHA16I/PR16PzGkYVtFZmfdgVKEOZj5k9KW9jdxRgtw
         V2y5fYv7IrG/l7mfHxcIX8K/bhhaKlIukfwBtzw/J97K6qoy2+35V4kGu6gjD7ZIR77S
         yf26Fj0uZzwZtnMjKeYmLlwtre0TOojVGgZF3MTTlciUD87gzpdCX2CiuvGBcpaFYJU+
         4s1blk2YraDKa4p/P2k251li3qkLiZBxxrl/0wbp7GAIOytS7badoXIKzdT4ggPjyo+i
         x8rg==
X-Gm-Message-State: AOJu0Yw6NXqqqYO7Uj4OJfIWZ5zw12NDr051FzFh9AyB6ygnphN3+qLK
	lNJIMkN9yobgMoD8NXLk0IjpNcSEvkiaU6zUb7Mo0l3l0HVEodOVUMn/SC0W
X-Gm-Gg: ASbGncsMh4ar6GDOR/jBoXOnZIlqgEdUX/cLtQothnQf0s8oEluhnDB9nNqCbeiVDO0
	T+CBaS9kFjqD2FJIwtZHfVw/VinOOf+czKuTzNAdyTu5Upa/276ezSA9Y+aeptzfezsdRTiy7Vr
	zUtjRAhJ4DJ7HHEZ84ZUAtDVqYLobWd30nQOrtdSr6gz5Ru9+CoAc/iA00h92I4C9flX6yfxucG
	mtSPlMzFd4cYiN1fnozMP4p27JJ3hnYvLrkHabS
X-Google-Smtp-Source: AGHT+IHovdFs44pB+KI3oWGIJ/Ei0Hqz5E63gTCXd2Wd/h5iZmeNKa53TY4PKLO5HmGsyW+DqEwTrQ==
X-Received: by 2002:a17:907:1c21:b0:aab:d8df:9bbb with SMTP id a640c23a62f3a-ab2abc925cbmr3047167966b.41.1736955603690;
        Wed, 15 Jan 2025 07:40:03 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:66c0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c905cd8asm769090566b.7.2025.01.15.07.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 07:40:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: reuse io_should_terminate_tw() for cmds
Date: Wed, 15 Jan 2025 15:40:48 +0000
Message-ID: <8a88dd6e4ed8e6c00c6552af0c20c9de02e458de.1736955455.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_work() rolled a hard coded version of
io_should_terminate_tw() to avoid conflicts, but now it's time to
converge them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/uring_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index d6ff803dbbe1..d235043db21e 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -105,7 +105,7 @@ static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
 
-	if (current->flags & (PF_EXITING | PF_KTHREAD))
+	if (io_should_terminate_tw())
 		flags |= IO_URING_F_TASK_DEAD;
 
 	/* task_work executor checks the deffered list completion */
-- 
2.47.1


