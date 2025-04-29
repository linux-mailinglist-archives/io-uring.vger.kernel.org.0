Return-Path: <io-uring+bounces-7781-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AFC32AA3D75
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 01:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF9111887D68
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 23:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2803D25699B;
	Tue, 29 Apr 2025 23:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFH9Tp0L"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB5C256994;
	Tue, 29 Apr 2025 23:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970679; cv=none; b=gvZaWiG57CWJS/AUZmgHGSvGIQ7PMfB0UmHSJFaYq/XCucfVNHh+qahn50WesCvtDEodOFWJti+nD0y6JAamiR6De6eyZI4vZElV2BPfBDWMKyZx/g4nlyec9gZbWSfGlISW90hEvzvKTQ4xBY1HeBNuKo5LG/Sd6WtXuQQjfWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970679; c=relaxed/simple;
	bh=hCMqzhW+XfQ1sGbaSzvh3YAc5ANAD/fo2v3VJx9zzZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UcG0DzPMDcKS17BNIM17rFG7FyjN9s5mXYYLe9w0wgoycN7kfk5o4mp4OifXqTXx8OjQt75+mYcgdyWcDh+d4DxpAayKVVQ52BOdblqwZwsT/+gZd5dp8DKFsDiV33A4Vf7kSCuSKVv9SKE2mKkmxgLRiRCgMyZlWwTYU7oOfHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFH9Tp0L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1338BC4CEEE;
	Tue, 29 Apr 2025 23:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970678;
	bh=hCMqzhW+XfQ1sGbaSzvh3YAc5ANAD/fo2v3VJx9zzZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFH9Tp0LH6wckso2DdsqoFiS12EPRXHwYa9TUx10HEZXe/ZDRguvQMk7z1PPDbcPo
	 RKX1tsenKJQcrdZtp1hP1sJP6fJuxwKL2xyn3JFiFyEFhFuT3wE5AgCutMKHQcaPbI
	 1a6RQyEY/zu3FidqRBFEQ4P6zRdorvQ1fXBG/Y1g8TAoHNUPiDrD0oi7PxTEfgaQuq
	 TWbx4GzPZL6ekjLMfgwZGC4gsfCZDVWh0Jh2iYyZNU/apGlPtVm2IVWgBOe+3xNyhu
	 oyUxeU1nvRkNH0WS0ZQMUJ1zpesMEmLQPiz5K3Bl4Cny57DUMbEOmvNeuQUkcc51nv
	 AWYT73j2lmdBQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 37/39] io_uring: don't duplicate flushing in io_req_post_cqe
Date: Tue, 29 Apr 2025 19:50:04 -0400
Message-Id: <20250429235006.536648-37-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235006.536648-1-sashal@kernel.org>
References: <20250429235006.536648-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.4
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 5e16f1a68d28965c12b6fa227a306fef8a680f84 ]

io_req_post_cqe() sets submit_state.cq_flush so that
*flush_completions() can take care of batch commiting CQEs. Don't commit
it twice by using __io_cq_unlock_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/41c416660c509cee676b6cad96081274bcb459f3.1745493861.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7370f763346f4..1421ada5b0330 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -877,10 +877,15 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	lockdep_assert(!io_wq_current_is_worker());
 	lockdep_assert_held(&ctx->uring_lock);
 
-	__io_cq_lock(ctx);
-	posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+	if (!ctx->lockless_cq) {
+		spin_lock(&ctx->completion_lock);
+		posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+		spin_unlock(&ctx->completion_lock);
+	} else {
+		posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+	}
+
 	ctx->submit_state.cq_flush = true;
-	__io_cq_unlock_post(ctx);
 	return posted;
 }
 
-- 
2.39.5


