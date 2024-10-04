Return-Path: <io-uring+bounces-3427-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 399E0990DBF
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 21:18:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02D32287054
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 19:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9A091D89FB;
	Fri,  4 Oct 2024 18:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWwKlmtc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECF81D95BE;
	Fri,  4 Oct 2024 18:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066478; cv=none; b=MtpekJ9jAgWhYt76NMSebJJ+ZnY0/sUAxFVq5RCmevU2DeKzuUI2pB53EL8BHVFOKXngxlRZ8Wuepi193bY2QPYRJb4R8Tca4SYGGfb/9jIpqdEOS5gKwTFJ0HxWP97X2V3gtRpQQxocHQRrL/UfHRQCvFXIqxK5mrZ8FJSX04Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066478; c=relaxed/simple;
	bh=IgYMgtqiHAQsBKJx2iJTXwxxvvb52UxnQ0WOVJSj5R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hahj/0pizzaYWRp/hiw6nYorw7y6MspxHwjHHW9sax/kBMZDygvtEXnH5f63WNdiyeneZtToTs3wxiDdLHbxibidvUBmcPVPykaYdVpgwkpTZymJj9XeYMuwDx6MeELF8t51Qfd6Vt54fhFD4guf3m82eZgkfWqT8KxdItc1SOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWwKlmtc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90693C4CEC6;
	Fri,  4 Oct 2024 18:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066478;
	bh=IgYMgtqiHAQsBKJx2iJTXwxxvvb52UxnQ0WOVJSj5R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWwKlmtc41/9OyT8EUwCQbwM6mjJqEf+2GijyK+CSBHDWwwCIexwkel3JBhm9vTf/
	 ye7tDMVE3C+eGJNCe05AUK0uacHVq3+Vjc6dmclpu39Tf/i9VZKA4+1dgD47pdYouP
	 3pXBVjEgcP6dAKGE1DAutVhikv8EP86OIJWekizRJBkSyv5k7NEKUwFBfr6LJnvd7H
	 BAWqwOozbD4QYxiNDfgmKt4nIuKesrmiSqnPMJdYYcPipizMOiO0rx1spcLAFVtBDM
	 fLFIDlz19gEtHZI8SfzD8id5T+QEqH99VOvBLBKwVfZMXhEdulbEgocTqAlVHrakmJ
	 6EMXKgVEr/sqw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+5fca234bd7eb378ff78e@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 22/42] io_uring: check if we need to reschedule during overflow flush
Date: Fri,  4 Oct 2024 14:26:33 -0400
Message-ID: <20241004182718.3673735-22-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182718.3673735-1-sashal@kernel.org>
References: <20241004182718.3673735-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.112
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
index b21f2bafaeb04..f902b161f02ca 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -615,6 +615,21 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 
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
 
 	all_flushed = list_empty(&ctx->cq_overflow_list);
-- 
2.43.0


