Return-Path: <io-uring+bounces-5244-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 217DB9E4A01
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 00:49:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 958DD188060F
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 23:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861E52144A1;
	Wed,  4 Dec 2024 23:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYL216vs"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BE82139D1;
	Wed,  4 Dec 2024 23:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733355333; cv=none; b=pr/LunC9ixUDgE/5eHuA9Pt8PD1EcvDBPpmfU4vGIOGdAw5hlgoU41tcShYMo6u6WZrZBmCwu+L0Fv6D4FLsk5n1hu3QkVdB+n6X0SUuk+4VDY2HjFMRhWQ6h+6wo5cK3HUxX16qY6AXJyTTGM7WACpWDoMa9VIouEsx2s3+1Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733355333; c=relaxed/simple;
	bh=LrCwv/xA6yOQwsDPd5GsKlTBmspBObiOds2AdXGx3pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdsHz+rlY7eju9SRISBRlOjhOvyQvYfmBAybMg8gN5RslA3HqC2AWYqDBBs35eAzPwCWWa8w8JeNIimZ6N3km+hHizj4YQiSVBRHePt+ryzuhdIYGCuFnkyZEfnmLh6xNiOL/RIpBuF13G8gc/8tAHWquCKupsKy0XG12CK7aY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYL216vs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54571C4CECD;
	Wed,  4 Dec 2024 23:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733355333;
	bh=LrCwv/xA6yOQwsDPd5GsKlTBmspBObiOds2AdXGx3pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYL216vs+2VcOqF3dtkSCXSF/1ldcMvKx72C4ZzWaAQLcG8m5oIr8j1AqhH0NzzPY
	 CC3cua4puip4etHMudvan2mr20gQLbFhd+HINhGVL4NIA6zelloXfBxWoAaVz20qjh
	 dZbwTMG7AYCl9K5AwDjQU1apC+3xDTC0njbxrD0OB1/xrMNDT+TlkJLM6X6RE7E9CL
	 vqrkET+HmuXXYlmJjsGOfKzAwXHnMGeDIJxxOhy5y5loWj4Enujbzfe/5soX8tEpS8
	 0sw66Ze139XiHrcD/1X9Y86tZ0/3IwDpMr1vcHl29IhmWZBe5rUmFSIt/T82e9KRmk
	 Oimtvkj+1xvvA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 7/7] io_uring/tctx: work around xa_store() allocation error issue
Date: Wed,  4 Dec 2024 17:23:49 -0500
Message-ID: <20241204222402.2249702-7-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204222402.2249702-1-sashal@kernel.org>
References: <20241204222402.2249702-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.10
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


