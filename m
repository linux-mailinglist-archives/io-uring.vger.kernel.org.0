Return-Path: <io-uring+bounces-2248-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7994090CC6A
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 14:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 434A3B27473
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 12:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BAE815ECF6;
	Tue, 18 Jun 2024 12:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KbCfz8OV"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D7215ECE4;
	Tue, 18 Jun 2024 12:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714257; cv=none; b=bxr/Ir/FVxY03/qnluAzPxgO62Bq4alqDF9Z9qj2jybMUh8MMNdYXvFnlToFF4AaA+OmZVZ1Hdvas09QIkNOEuJRSpoOGdArulZJWXzy6TNhZEmO4Hnr5HEerlRgE35GaeB7tQ52RIO5ahwiTjNRA8IRPwf7yhSgSjjp4ySXfms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714257; c=relaxed/simple;
	bh=EpeNOuTzRYQMGIT8zYf8o2LrLhjf2W6iYUh+DoIYeeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eS6CYzC7cN5mP08YN87qznF/KqRBhEpjjWaQjR+2GK9/H+OPqMelVDB2qE9QEtFvxGnTZWvwsCfa1uHLPlkhvHDa9wtaAoYHk6rgvoMLBbG2f2r9MHMGJq0CjsuN6g+ug5drSxakQoVEJb30Z7Uh3fO9/KRSaStJc+Ced9qG69E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KbCfz8OV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC711C4AF1D;
	Tue, 18 Jun 2024 12:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714256;
	bh=EpeNOuTzRYQMGIT8zYf8o2LrLhjf2W6iYUh+DoIYeeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbCfz8OVOkzm1O1kyxmpwksm2WWoB32B2o5ZOaHSTzRDj60CHvq3lDzWYq0yEFlno
	 5edvwGP/UZ6/oQJrYBnwVx8eGwIENvznB1paazA7xWqSiswUBfweIzcruAmmVv0Lb9
	 9pJtKbt2BUHo3VJckzCny1OlGKURlVvrPntPmrRfnckQwNL59mgS1QpkqNUkTt8OdG
	 xBE9zIcpqGCal9UH6gD/udNgutvLrhyUG/KGj6Esdn1Fb4d4QXyNFo+2DrzD6Fap1o
	 v+uhaPaFFs0fb4DkOaNGhsIa1FSCKoqCyVc6CZS37aH97AgjwNPXXgKQySUijNdnd9
	 x8uecYe4vorAA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Hagar Hemdan <hagarhem@amazon.com>,
	Maximilian Heyne <mheyne@amazon.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.9 36/44] io_uring: fix possible deadlock in io_register_iowq_max_workers()
Date: Tue, 18 Jun 2024 08:35:17 -0400
Message-ID: <20240618123611.3301370-36-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618123611.3301370-1-sashal@kernel.org>
References: <20240618123611.3301370-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.9.5
Content-Transfer-Encoding: 8bit

From: Hagar Hemdan <hagarhem@amazon.com>

[ Upstream commit 73254a297c2dd094abec7c9efee32455ae875bdf ]

The io_register_iowq_max_workers() function calls io_put_sq_data(),
which acquires the sqd->lock without releasing the uring_lock.
Similar to the commit 009ad9f0c6ee ("io_uring: drop ctx->uring_lock
before acquiring sqd->lock"), this can lead to a potential deadlock
situation.

To resolve this issue, the uring_lock is released before calling
io_put_sq_data(), and then it is re-acquired after the function call.

This change ensures that the locks are acquired in the correct
order, preventing the possibility of a deadlock.

Suggested-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Link: https://lore.kernel.org/r/20240604130527.3597-1-hagarhem@amazon.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/register.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/register.c b/io_uring/register.c
index 99c37775f974c..1ae8491e35abb 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -355,8 +355,10 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	}
 
 	if (sqd) {
+		mutex_unlock(&ctx->uring_lock);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
+		mutex_lock(&ctx->uring_lock);
 	}
 
 	if (copy_to_user(arg, new_count, sizeof(new_count)))
@@ -381,8 +383,10 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	return 0;
 err:
 	if (sqd) {
+		mutex_unlock(&ctx->uring_lock);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
+		mutex_lock(&ctx->uring_lock);
 	}
 	return ret;
 }
-- 
2.43.0


