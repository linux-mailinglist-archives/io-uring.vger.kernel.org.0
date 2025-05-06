Return-Path: <io-uring+bounces-7879-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 249ECAAD004
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 23:46:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 464D53A35B2
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 21:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F1B022FF35;
	Tue,  6 May 2025 21:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q/anUP+b"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A7B22FE0C;
	Tue,  6 May 2025 21:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567431; cv=none; b=cLL18+hGjrVfycu8a3FpS81d5+hoXLS3mT6ye05Q82VModzHuNzyyqX3kormhaU1We/Ux90QPVkjiw1GpxmDLRIZgku8qYikwUYGlnY+h3z5gn9RMidA1UCzm+S7tAhDiOY0/CJQiKmfQbGAyRzqFXUMHmBOkT5D90cV/HbUH7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567431; c=relaxed/simple;
	bh=H/10vPzZx7bbzGtn1cMttwk6Sw/HfJXo1GFSccFfT4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VquCqKNKw7jduTeVXKLDX6veFFj9DzdZdq9vZbIbVfxwf07twGLQgnPIBEWolvpTSjxUKIdPh8AcsMhk+LBoCkQnFG5gBi2ulw5tBe9jjmH1G7oCjkwj4trAPszlOJWunPYOROkUSO2qxjPRcGSoNqzMyJeJQkpCx4KNZ9WpJAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q/anUP+b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AA7C4CEEE;
	Tue,  6 May 2025 21:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567430;
	bh=H/10vPzZx7bbzGtn1cMttwk6Sw/HfJXo1GFSccFfT4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/anUP+bO7XuC5N8ZY4o6X6qEHUdxN3myJoLjDN4ed/NRQ5sz8NWnlyctDVGdya4R
	 sYg5Yzi82xnlDGMNRe0LdrWr8T2OaG9SOA+Dpvr1QRPxFs9+Y0kx0r3yWkaq52gMVZ
	 ke7fTI9kpQJhgDRH9NmgXXpZfHcBUo2riP5jepqsfmiOqIv9NiXr0M9pvmwEsX8pk0
	 f3hduJtgcEW+S+k1CAEaeRRSD25tPBiDRg916AeEEZfjmcvblmjhPnQxwSFKcG8F4j
	 MN0S0grvdnVKNErKpdNbWrOiubLHfOIQt71ytF67//3eQQi8TxHDExGIIkxod+1gGp
	 AlbSm3TuHTxUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 10/12] io_uring/fdinfo: annotate racy sq/cq head/tail reads
Date: Tue,  6 May 2025 17:36:45 -0400
Message-Id: <20250506213647.2983356-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213647.2983356-1-sashal@kernel.org>
References: <20250506213647.2983356-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit f024d3a8ded0d8d2129ae123d7a5305c29ca44ce ]

syzbot complains about the cached sq head read, and it's totally right.
But we don't need to care, it's just reading fdinfo, and reading the
CQ or SQ tail/head entries are known racy in that they are just a view
into that very instant and may of course be outdated by the time they
are reported.

Annotate both the SQ head and CQ tail read with data_race() to avoid
this syzbot complaint.

Link: https://lore.kernel.org/io-uring/6811f6dc.050a0220.39e3a1.0d0e.GAE@google.com/
Reported-by: syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/fdinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 976e9500f6518..a26cf840e623d 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -81,11 +81,11 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	seq_printf(m, "SqMask:\t0x%x\n", sq_mask);
 	seq_printf(m, "SqHead:\t%u\n", sq_head);
 	seq_printf(m, "SqTail:\t%u\n", sq_tail);
-	seq_printf(m, "CachedSqHead:\t%u\n", ctx->cached_sq_head);
+	seq_printf(m, "CachedSqHead:\t%u\n", data_race(ctx->cached_sq_head));
 	seq_printf(m, "CqMask:\t0x%x\n", cq_mask);
 	seq_printf(m, "CqHead:\t%u\n", cq_head);
 	seq_printf(m, "CqTail:\t%u\n", cq_tail);
-	seq_printf(m, "CachedCqTail:\t%u\n", ctx->cached_cq_tail);
+	seq_printf(m, "CachedCqTail:\t%u\n", data_race(ctx->cached_cq_tail));
 	seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
 	sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
 	for (i = 0; i < sq_entries; i++) {
-- 
2.39.5


