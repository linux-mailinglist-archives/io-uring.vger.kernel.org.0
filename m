Return-Path: <io-uring+bounces-2238-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4216890AF86
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 15:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D3B61C20CA3
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 13:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC0C1B143C;
	Mon, 17 Jun 2024 13:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rEPet5Wf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A921B1435;
	Mon, 17 Jun 2024 13:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630533; cv=none; b=hvWQu3ddWontl0ZV1J07ZUGqQvuPjeIOONzjnznFWR38+FMky2PAoszS5Mx/htl7LMFlEbHuX6fE3DCrJ68GORO0DQiQKU3rgIQ6xvf3jzkOABUH8D+0fcd8d7wgtUI/1zZT1jVHNZvAUmj04c4/mqF6A0PiIUMNnJacOzt1Y8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630533; c=relaxed/simple;
	bh=EpeNOuTzRYQMGIT8zYf8o2LrLhjf2W6iYUh+DoIYeeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgMEnhWcStf/r+ORvSCBmo8xTMiGTw3CjjgaLF3aqnipjlq/fcdYwtLlq3llr34XlUIWOwmvvU7DqEvy2Om6AIJ5LK+nxX2gIL0cvQQAnJ1m0R1CLwn5yRd2SpDqYqvUHodLYdvxnoFKj3rYNwYgn7OvxMdophnWcucE9114zsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rEPet5Wf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA06C4AF4D;
	Mon, 17 Jun 2024 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718630533;
	bh=EpeNOuTzRYQMGIT8zYf8o2LrLhjf2W6iYUh+DoIYeeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEPet5Wfsl6UJEJQGLItzPT5cRZbGwnUmUUyujypPUH89/wZf/Ermm31m2wciBAkb
	 AewIafUFE/4LaCy+lhRw+NY0EM0EgISuSmph5wGis3adbHSSFBr+Z8zUxunAzNi5uJ
	 gsoZv05LDFjm2nVBuQBWEb1zpj5LFyddcf3WUE/AEqTDXCwi7kyWV4gj64TY5lQhfd
	 kYeWCoO3U93ifsZQXdnYoknQbYqeDy2uOSKKcZsLIo159U+KKiFuwr2nm6AHlo9S6L
	 qlBZOv9CAEaF40Ci/cAWJYMgnZLLAMduA7dO7XD1EOjm/OtkG8qXwsEAC6U6fhiQBa
	 oua5vC1IczQzQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Hagar Hemdan <hagarhem@amazon.com>,
	Maximilian Heyne <mheyne@amazon.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.9 36/44] io_uring: fix possible deadlock in io_register_iowq_max_workers()
Date: Mon, 17 Jun 2024 09:19:49 -0400
Message-ID: <20240617132046.2587008-36-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240617132046.2587008-1-sashal@kernel.org>
References: <20240617132046.2587008-1-sashal@kernel.org>
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


