Return-Path: <io-uring+bounces-3425-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D609990C58
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 20:47:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FEB528241B
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 18:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906A71F5EC2;
	Fri,  4 Oct 2024 18:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLb4aUxX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A09A1F5EBE;
	Fri,  4 Oct 2024 18:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066176; cv=none; b=kK2bJnNc/TJgRAR6+CiJHBUsOJXEgytd4ozkcrKxtsjWg8I3dYEV6QTScio8M+FtJeMPOiP1LynhyNnz7U8HXTiuqrk18iqVa6bA2tWrJzinFZllc/M8vqHMoRI505awVxfWabl6Rwgd2eRAYcEAvuklM3AJypQzSh0WEV+bxlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066176; c=relaxed/simple;
	bh=eD6tgJpXpuwcA0P/8bt187/KbE9ZeB+577xiRd3iLOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzpUPslQimPTZbXPMGkCbx9WQY4msZn+D59GV4doQ+Lo1DG3RfvbEgqfWDDQowb5V3/mew0M88eRHVdMfWZjBSISqFfMiZOy2+5telFg3g13Jv5UCpoMOTei881cpqTwJtMmk1tqPZo8KrWfDl4Ncc3X12yUZSaQqT6L0+dlUzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLb4aUxX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795E9C4CECC;
	Fri,  4 Oct 2024 18:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066176;
	bh=eD6tgJpXpuwcA0P/8bt187/KbE9ZeB+577xiRd3iLOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLb4aUxXw4kWyGoDjBM23gSS2P4rJy79kj4fr8tiWzgdQt3IyATMgMaQTI5s8URsU
	 1xDpgSSvs38/9TRAKN2CBfaf7ThugWVm/ATRZXCuKvU/2Iaq229xUw5quW5yFrCbjr
	 k8nn67YuwAQq9PGdkPuAYRjME7hPphwtjv/peZwL5K2uar+481S29a80O+ZFIi/6jW
	 L1b57tIPrvAKJGpUVfZS33KLFWfcaSvmIAPLud0BdRJ8IpQFjxX/ZcfWNmNReU0tYB
	 J47F1zgy839O7WOdzAkcgyA67eg/DfqsBP0/uOiM8Npk/WJWLdDppCvlX3vSTAoL5E
	 oB3Klir2FK84g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+5fca234bd7eb378ff78e@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.10 31/70] io_uring: check if we need to reschedule during overflow flush
Date: Fri,  4 Oct 2024 14:20:29 -0400
Message-ID: <20241004182200.3670903-31-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182200.3670903-1-sashal@kernel.org>
References: <20241004182200.3670903-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.13
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit eac2ca2d682f94f46b1973bdf5e77d85d77b8e53 ]

In terms of normal application usage, this list will always be empty.
And if an application does overflow a bit, it'll have a few entries.
However, nothing obviously prevents syzbot from running a test case
that generates a ton of overflow entries, and then flushing them can
take quite a while.

Check for needing to reschedule while flushing, and drop our locks and
do so if necessary. There's no state to maintain here as overflows
always prune from head-of-list, hence it's fine to drop and reacquire
the locks at the end of the loop.

Link: https://lore.kernel.org/io-uring/66ed061d.050a0220.29194.0053.GAE@google.com/
Reported-by: syzbot+5fca234bd7eb378ff78e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 896e707e06187..f295102789cef 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -696,6 +696,21 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 		}
 		list_del(&ocqe->list);
 		kfree(ocqe);
+
+		/*
+		 * For silly syzbot cases that deliberately overflow by huge
+		 * amounts, check if we need to resched and drop and
+		 * reacquire the locks if so. Nothing real would ever hit this.
+		 * Ideally we'd have a non-posting unlock for this, but hard
+		 * to care for a non-real case.
+		 */
+		if (need_resched()) {
+			io_cq_unlock_post(ctx);
+			mutex_unlock(&ctx->uring_lock);
+			cond_resched();
+			mutex_lock(&ctx->uring_lock);
+			io_cq_lock(ctx);
+		}
 	}
 
 	if (list_empty(&ctx->cq_overflow_list)) {
-- 
2.43.0


