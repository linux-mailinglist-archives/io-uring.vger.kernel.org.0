Return-Path: <io-uring+bounces-3424-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBCD9990B62
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 20:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD378B28917
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 18:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67BA83DAC16;
	Fri,  4 Oct 2024 18:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Asf8r2oM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9773DAC10;
	Fri,  4 Oct 2024 18:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728065965; cv=none; b=VyGjjKBS3QaUEzMgRENiKhb0E65LorKFLOFZxUbyksrU/FiCT6pa1aDJUTOn30A4O5Wmjogo11e4q27fiePF5zJtUfOSS7OzhQqi1LvmiHLXlV5dS7EdKLHNNRVCFiauaSI3Fw0Zl12gMoClKalsDjnXm+2Lb0QpRiVPZEEG3Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728065965; c=relaxed/simple;
	bh=rScf22v1o4/mI13PWSD/NlItn3tp5lAEPU2ihVYAx1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZyjM2nPm9jQKiwJ4vxzuOrG0eWJcK7y40q6MiDn0/eg3/IHWIYMlKfukftssBTZWJgdgcXFEtr91Q/iLOcRUSKk03DguUT9yajjMiz+t2T+H68IUvVjtBU9zy7ZFWp7iwBMbq/lTLtLobxD2ZS7rm16xIDxPetB82Z2F+mHA/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Asf8r2oM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E249C4CEC6;
	Fri,  4 Oct 2024 18:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728065965;
	bh=rScf22v1o4/mI13PWSD/NlItn3tp5lAEPU2ihVYAx1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Asf8r2oMULLVWOqH9jRjR8rZajjxybd0InxFMX0HJZo4bwQkePxZvnA4BR45qU8tZ
	 HvKFAKj7gprrKuyWvOy7fFFzlU6lHI1LPNG/fBnTSs4u4jfTFP7kOvzD1YHbqS2WmK
	 ocVwNn6ldYf4GCboIYK9kiBskx8WEfvvIGx8WVoZIIJ+BlNcXnvhYAdOfLw7ieoAfU
	 v7pGS7JNEr+A3DG1INEiV2kjbxHESjOyB04+vYAMPkFzP9G6PMefhjiI0lkoEG6KGz
	 ahv5c0A0SggJ45eYAL+1NXyaxpOSs0yCNF1DbEAgdeiVPqrSzSyvDCp1suhVOCtt/s
	 UShX2KremTGcQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+5fca234bd7eb378ff78e@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 32/76] io_uring: check if we need to reschedule during overflow flush
Date: Fri,  4 Oct 2024 14:16:49 -0400
Message-ID: <20241004181828.3669209-32-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004181828.3669209-1-sashal@kernel.org>
References: <20241004181828.3669209-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.2
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
index 3942db160f18e..637e59503ef10 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -624,6 +624,21 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
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


