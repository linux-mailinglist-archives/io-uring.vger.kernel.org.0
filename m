Return-Path: <io-uring+bounces-1076-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 013BB87E162
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FA261C20CDB
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BEFF225D6;
	Mon, 18 Mar 2024 00:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k7QK03Tc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24C0224DD;
	Mon, 18 Mar 2024 00:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722638; cv=none; b=LN7BntJrjC0gg2jknYWAKXoWqsrqD5kVUo8YFJUnmvmtgIAbOi3RJOnuoHfOLP1M8EeUOHK8/XqSCsnJtSgaD2rm+iLJB2Ay5pPBcNN615YuU7Zmqw5xqIGPAjTq67do0NICvCeOF8eKIJqUysnRfmBfMVRBsdEBcXreFzvR58s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722638; c=relaxed/simple;
	bh=bNt8jz/8WnJqhRG/3PrzblUGUleUniIqAeDbF11GcI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHMRda3towtltBwjUY+eLVyHkgUXlWILfWfJRYfRQxys5721AD6xprg/ioa1m9u/srqGIiHGXllrckkuqh06aCn2iD/7Qa4QS/5CvXojs3zRaISNkh3GjZACyfebLNsI12zhMb+VyaV8QHpf7WrfDIOI6O0+pcpM5RzGXEB4Opw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k7QK03Tc; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-513cfc93f4eso4275165e87.3;
        Sun, 17 Mar 2024 17:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722634; x=1711327434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aUxb5daalxdf9Y1mQ3RaNl2uAIpS4+M356xPG6h8qG4=;
        b=k7QK03TcAcWyWTwRNttqO8L3IYARVLkp0IrgOBZg7aB0ETZkDWGmiyGTtNM15REsI5
         wPUER/VqCM32rjQIs98rYNiR76mN8xTwYRFeaKVTD9soiERiFF1xQ7qA6uD5lJ9UiXit
         X0b9GUvnTC7xWaanarhniLmuMAQ2svYVUxff1ynbFabZHeChcyWxhqESMxmrHUiUQxiz
         nnJCPFM8wBg0tLmHQIrPq7NBCHqmWKGvtU2oSRwJrQByRjX74pH7UTcHUOYpE0Lv3hl8
         OjmDnDItQ4JaI7iaHte8kQCXso/dNZqk6HmqMmgOfQZyOpQFh5TU4Wj7UGns2ELy0erZ
         us3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722634; x=1711327434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aUxb5daalxdf9Y1mQ3RaNl2uAIpS4+M356xPG6h8qG4=;
        b=rkMn3LHuqSQiSIo43H+SDkiIJj3RaDABGh8eEoce2bUeVUsuuNQJp5ZMn005KY/h1C
         w5hApOcu+9g8loA774S6LPfUk9S9OWcniKv67Q6RF8pDyPEfVm/bgO9TBY6TIzkVj0zQ
         Y+awRtztv5e9ZqGNt988dqAgQnIptPCKzRgU57z85a0AidjTGGH5FgFjMyjovSQKusEP
         rP1v81oDjPYA0GFhb2RqeRU+ziNT7ey8m3XNHAQ9V8BcCw6Z4NY7XPlKxvAJrAoEXULN
         fIEcxKijcwGh0xCnjqhnloFChXwT/0vAHmpLRdRHtYSE474W+yjZyusOKjakJqqrXnqt
         OtXg==
X-Gm-Message-State: AOJu0YzZ+MWe8fTdhydKTQQh9/Md8eduGmMju91nrDWVPUGbLY4C+nTj
	BEwE/tXyhkB7kV9A4BZo+Gr9nQ8TosvsM8ZAGrqxCvKKdEWUXOw1REII3gwT
X-Google-Smtp-Source: AGHT+IGBHmLq2pEncWA7qUyFEC5gqFOgsLJpmA1AXXRQO9yGBSPKq71rUTUykihkLHm69UpjhU6iPg==
X-Received: by 2002:a05:6512:3447:b0:513:9ae1:4708 with SMTP id j7-20020a056512344700b005139ae14708mr7097539lfr.46.1710722634364;
        Sun, 17 Mar 2024 17:43:54 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:53 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 14/14] io_uring: clean up io_lockdep_assert_cq_locked
Date: Mon, 18 Mar 2024 00:41:59 +0000
Message-ID: <317cb75cd09247efec3628d3cf1a77847cbfeec1.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710720150.git.asml.silence@gmail.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move CONFIG_PROVE_LOCKING checks inside of io_lockdep_assert_cq_locked()
and kill the else branch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/3c7296e943992cf64daa70d0fdfe0d3c87a37c6f.1710538932.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index db6cab40bbbf..85f4c8c1e846 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -119,9 +119,9 @@ enum {
 void io_eventfd_ops(struct rcu_head *rcu);
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
-#if defined(CONFIG_PROVE_LOCKING)
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 {
+#if defined(CONFIG_PROVE_LOCKING)
 	lockdep_assert(in_task());
 
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
@@ -140,12 +140,8 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 		else
 			lockdep_assert(current == ctx->submitter_task);
 	}
-}
-#else
-static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
-{
-}
 #endif
+}
 
 static inline void io_req_task_work_add(struct io_kiocb *req)
 {
-- 
2.44.0


