Return-Path: <io-uring+bounces-7427-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F0EA7EB28
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 20:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99767188D4E5
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 18:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5FC26F45D;
	Mon,  7 Apr 2025 18:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dx0Lq9yr"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D6C26F458;
	Mon,  7 Apr 2025 18:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744049818; cv=none; b=ZNw8d3EAIDh43j4G2bG+kVcD9i3vORIh0+GX7L6PrXgxDjysJNA7xruXYZl6eO9V31bGCInuZYfPyyTWJECDadOSuhoGstKC0LAI4QivMI0QIgH4Re0TUan4eZ8GkDth6KxH5lO5AvwP4Pj/tZRyDueCN1uzxbhf3quzojnYw5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744049818; c=relaxed/simple;
	bh=VsAAArcVh6T7g0FJDwhWVlycVOgzVQQT85romacyIqA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YZ9BxX92oxBc9sreswzgWjFwGyKkJBlc51OPqMbZsELhbLEXhPic0QYqqebOzK4akLQ/wAvp2YovvEbXPW3EcfCfoXnbjOhtnfeCy9jpbGuO5qWjcAYUsaFPvpDYLlI6vEMqqFiNacctb0cF9a1Kzxf+cg2JXY96gRg6SPrF7l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dx0Lq9yr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C976C4CEE7;
	Mon,  7 Apr 2025 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744049818;
	bh=VsAAArcVh6T7g0FJDwhWVlycVOgzVQQT85romacyIqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dx0Lq9yr3DxkWZtuKoyhALkANaf2aumscJhLIQ2aQ/z9LBVtqFgsAQ7qzQy4vnbr7
	 UJs/+lKMTZRtNRtF2lr2arb/16YLXchJB/A7RDrEPWo7/oMMFgssNcfkAGhP5NPWSl
	 ZDpe/M7DfHHSc/bBOMcr7w5aXlwoH2+UgHJGI4qdHMrhURh8576mmXf4SXp/55t3eU
	 DfgTUv3yekTB94teGTCW/TptAm8c3koNtUmGOH/7ZBDB6fVoHSenyQMmPVWUlds9Fr
	 hHZjLq4YOfaanCTQs0Ma/6Rzm0kYPwzyrDms028p41iWE6EF+0RoCOzkEDqrFW9RNf
	 Ey4KADozguAuw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	syzbot+903a2ad71fb3f1e47cf5@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 9/9] io_uring: always do atomic put from iowq
Date: Mon,  7 Apr 2025 14:16:35 -0400
Message-Id: <20250407181635.3184105-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250407181635.3184105-1-sashal@kernel.org>
References: <20250407181635.3184105-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.1
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 390513642ee6763c7ada07f0a1470474986e6c1c ]

io_uring always switches requests to atomic refcounting for iowq
execution before there is any parallilism by setting REQ_F_REFCOUNT,
and the flag is not cleared until the request completes. That should be
fine as long as the compiler doesn't make up a non existing value for
the flags, however KCSAN still complains when the request owner changes
oter flag bits:

BUG: KCSAN: data-race in io_req_task_cancel / io_wq_free_work
...
read to 0xffff888117207448 of 8 bytes by task 3871 on cpu 0:
 req_ref_put_and_test io_uring/refs.h:22 [inline]

Skip REQ_F_REFCOUNT checks for iowq, we know it's set.

Reported-by: syzbot+903a2ad71fb3f1e47cf5@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d880bc27fb8c3209b54641be4ff6ac02b0e5789a.1743679736.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 io_uring/refs.h     | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f7acae5f7e1d0..67c79e576355a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1774,7 +1774,7 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
-	if (req_ref_put_and_test(req)) {
+	if (req_ref_put_and_test_atomic(req)) {
 		if (req->flags & IO_REQ_LINK_FLAGS)
 			nxt = io_req_find_next(req);
 		io_free_req(req);
diff --git a/io_uring/refs.h b/io_uring/refs.h
index 63982ead9f7da..0d928d87c4ed1 100644
--- a/io_uring/refs.h
+++ b/io_uring/refs.h
@@ -17,6 +17,13 @@ static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
 	return atomic_inc_not_zero(&req->refs);
 }
 
+static inline bool req_ref_put_and_test_atomic(struct io_kiocb *req)
+{
+	WARN_ON_ONCE(!(data_race(req->flags) & REQ_F_REFCOUNT));
+	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
+	return atomic_dec_and_test(&req->refs);
+}
+
 static inline bool req_ref_put_and_test(struct io_kiocb *req)
 {
 	if (likely(!(req->flags & REQ_F_REFCOUNT)))
-- 
2.39.5


