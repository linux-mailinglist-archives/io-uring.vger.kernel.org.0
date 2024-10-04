Return-Path: <io-uring+bounces-3426-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F03C4990D2F
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 21:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6ED93283250
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 19:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 579F520606E;
	Fri,  4 Oct 2024 18:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6qUo0DT"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BA720606A;
	Fri,  4 Oct 2024 18:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066355; cv=none; b=fYW4vqokdjHt1fsew1dBlCzhuEkiJDkIeohihz5kBocjprsnsGp67cVSKK/OsebTEaB11KSHKPnHA3YLd3NuZXKZDOe0+SHC6qC5RHDHbEdfb+M3qqIzS5fiZO+YOf+uklcfLT34Sjj/4xWKnOPm99nU5EuDoP91vbshwOpohDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066355; c=relaxed/simple;
	bh=rY6mFcDsEre+YnT0jQ+P5qHzYCY9XoykSYhbOfyQYuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0dz3INc080sqsOlxO1q5Qrsg4YrYE/UJIBxG0ydRmlgY6qK4EckUnkkEY+3P6vPyMzrJU34dr01uvX9bMMe3KgB2O8vfOPdRlLvmMn3wngzdCWXcZSLmRZzmZ6a9pxnLhjGoXZ17jOkBCRr0Dr21yQhaEAp28hza54ko+WtTIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6qUo0DT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB4BC4CECE;
	Fri,  4 Oct 2024 18:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066355;
	bh=rY6mFcDsEre+YnT0jQ+P5qHzYCY9XoykSYhbOfyQYuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6qUo0DTUKqNYKuIng+C6RN83pYJz6Ot3kRavV2FITyHtimklO1/1oWZZVVBp4m9v
	 3LYs3sDCKEeR9R+UjNjmrH95NtVC7zEfewnjV5BYf4ZR4iSicB1czzptk1zHU7TL7G
	 R3x3BS7jfgyGpdz9RFvYcdADNfkOk4v5D7FNJRUk2cu8qiZkczlB3Dubs3F6KvNJTC
	 ru5Rt3wwVMJx4JPcKTeGt4f2VL5tFkBqFdshd8W6yRnYqeth4ngaUKf7URQtzAdBbv
	 2pq7EkHlB6qSLQ3sAg8iu3q0AUx8J4xHRi03mNv3pwaz+V7BwThzug8F4WwnxDmwn8
	 2Z54/0UDRNkPQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+5fca234bd7eb378ff78e@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 29/58] io_uring: check if we need to reschedule during overflow flush
Date: Fri,  4 Oct 2024 14:24:02 -0400
Message-ID: <20241004182503.3672477-29-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182503.3672477-1-sashal@kernel.org>
References: <20241004182503.3672477-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.54
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
index 68504709f75cb..7ecfd314cf3cb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -701,6 +701,21 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 		memcpy(cqe, &ocqe->cqe, cqe_size);
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


