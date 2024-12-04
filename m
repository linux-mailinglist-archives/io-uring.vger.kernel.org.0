Return-Path: <io-uring+bounces-5245-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD4399E49FD
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 00:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D9F228D506
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 23:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632E7224B1A;
	Wed,  4 Dec 2024 23:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8C8aS5y"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3710F224B17;
	Wed,  4 Dec 2024 23:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733355354; cv=none; b=WGAPQtMEeP814/09pQ5nHwXJF+3q1VhSonpl8EnwualDfg/cP91S4jFm8HY+0wSxPTfJMw2jFkktgfZc68t/VimxYUzmrozh+D3nLZ7pV5EX8uUa/W6AgC56SpS2npL9SDiVLsp30lZ4Qs/xios2rXg3YdX103JtO3RJrhKXdGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733355354; c=relaxed/simple;
	bh=LrCwv/xA6yOQwsDPd5GsKlTBmspBObiOds2AdXGx3pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPZDlEM8hzELnbr0icVWhhZUN1k6Q0oLuSkYlAwIb2SWDtICeyEJ8qWLpEQsxjSrM47YiKCivVVmBoSf3bupGv5kf501mcQMP53Gt084be8aC+RHZStjkhGfmesynbJH0OnNgCw8mWANPt5hqXDr4ZdQXN/0ERIlXNXUBqrN72c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8C8aS5y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B4BC4CED6;
	Wed,  4 Dec 2024 23:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733355354;
	bh=LrCwv/xA6yOQwsDPd5GsKlTBmspBObiOds2AdXGx3pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8C8aS5y91RzMfAZRCcjr+/RhnCVeWGz74ckCnlYac+hkQMiIICgKSA3LCGclgeij
	 r47vp+p68LsuIl83nuXj5n8QfgUZkjPXSyCAWxeBZZFw5+fPAsqr+2YqUE0DIFsgic
	 MxVeK+uxkLzlTqcwSSad+OEO6oIj4twSj2oCJVQmO+SEN3/5U/xYYP9sHL4mU1jdPM
	 V/A7wso4OxdL2vMt/IIGHa8Us6yGIwoNgYB0nXqp3QoM1QecrqekbnRfvuH/6r/WIF
	 Wbo6GPifS1H7pmreg3Wnxz+ZDc+TxuI9vbmybSCMeURg8Byg6VmYnqk0BaugFlYqYf
	 EMEDRRm4W1d/A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 6/6] io_uring/tctx: work around xa_store() allocation error issue
Date: Wed,  4 Dec 2024 17:24:15 -0500
Message-ID: <20241204222425.2250046-6-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204222425.2250046-1-sashal@kernel.org>
References: <20241204222425.2250046-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.63
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 7eb75ce7527129d7f1fee6951566af409a37a1c4 ]

syzbot triggered the following WARN_ON:

WARNING: CPU: 0 PID: 16 at io_uring/tctx.c:51 __io_uring_free+0xfa/0x140 io_uring/tctx.c:51

which is the

WARN_ON_ONCE(!xa_empty(&tctx->xa));

sanity check in __io_uring_free() when a io_uring_task is going through
its final put. The syzbot test case includes injecting memory allocation
failures, and it very much looks like xa_store() can fail one of its
memory allocations and end up with ->head being non-NULL even though no
entries exist in the xarray.

Until this issue gets sorted out, work around it by attempting to
iterate entries in our xarray, and WARN_ON_ONCE() if one is found.

Reported-by: syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/673c1643.050a0220.87769.0066.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/tctx.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index c043fe93a3f23..84f6a83857204 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -47,8 +47,19 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 void __io_uring_free(struct task_struct *tsk)
 {
 	struct io_uring_task *tctx = tsk->io_uring;
+	struct io_tctx_node *node;
+	unsigned long index;
 
-	WARN_ON_ONCE(!xa_empty(&tctx->xa));
+	/*
+	 * Fault injection forcing allocation errors in the xa_store() path
+	 * can lead to xa_empty() returning false, even though no actual
+	 * node is stored in the xarray. Until that gets sorted out, attempt
+	 * an iteration here and warn if any entries are found.
+	 */
+	xa_for_each(&tctx->xa, index, node) {
+		WARN_ON_ONCE(1);
+		break;
+	}
 	WARN_ON_ONCE(tctx->io_wq);
 	WARN_ON_ONCE(tctx->cached_refs);
 
-- 
2.43.0


