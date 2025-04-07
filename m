Return-Path: <io-uring+bounces-7428-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A4AA7EB6E
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 20:53:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF7254208B8
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 18:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEA3F270ED3;
	Mon,  7 Apr 2025 18:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBuYJlMO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85596270ECE;
	Mon,  7 Apr 2025 18:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744049838; cv=none; b=R21S6CCqr+vAHUxbHC9cUxhxzo5X9urWQni8YVBm4qgw76LNifMY2SSBaaSVIvleG0tOEvHeVGFrMRyTZHOWG/EyMqe5eEuTBKieVITDo/PvQjmgCTdZ2rdefkfnKRIOOxEWlrRx7FLxSkVDLyD9E8dLsSQIOJbD090oIq7MeIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744049838; c=relaxed/simple;
	bh=Ta8XYuWHED4rqL7tcXUHVcYcjqXQRiH2ImfMiGy00Rg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ocO11WRKcbJPT0U4AQRsJljtPo4mlB9FDD+uYP4w9giomCRGwmrZ2P1xACCmW2IMMo/gZW7pJ1gXQxgv7t8yb+/2VbQDE1QeMUg6S2iUBcibKlTbOvhO8bq9gLwa3soMuDRmIgy2bNOaAdI7P57ovHbQLU2NvXQX1TKMxR+oXjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBuYJlMO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFC1C4CEE7;
	Mon,  7 Apr 2025 18:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744049838;
	bh=Ta8XYuWHED4rqL7tcXUHVcYcjqXQRiH2ImfMiGy00Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBuYJlMOhPuYV5d54iB8GmyJGYgHR/cfuIkvSnMsEropi2bwp6DzctjD+PSLimtSZ
	 l71SyPT0eO8YPe+oY27VGtFav1XATGnK8GzvdMioj719LFpFcuTqvU64prlT/jppfa
	 tDBLMs9x37mrmZXqay8W3vPP6FLV/8EFc8dA12XXQvBUjPjgxIPRWBibVxo6xdX2tu
	 VOnsDSZNksvynLBHLV0HJ4Idrdut2qWj4+5E8NGgn+XWqUfTvZs7SN4S8frBEF0nwh
	 pjspt5ZaX1tebqZ6udevyfJw0uajgPC6xEsZZuW6o1ZkdlueIJhab6wDYfNmyX8pAp
	 UgeqKV6NmMudg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	syzbot+903a2ad71fb3f1e47cf5@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.13 8/8] io_uring: always do atomic put from iowq
Date: Mon,  7 Apr 2025 14:16:58 -0400
Message-Id: <20250407181658.3184231-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250407181658.3184231-1-sashal@kernel.org>
References: <20250407181658.3184231-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.10
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
index 0b0dfef934803..6a2d154bbd7a2 100644
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


