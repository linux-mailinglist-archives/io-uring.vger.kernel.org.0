Return-Path: <io-uring+bounces-7877-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82B38AACFA9
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 23:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C20444A8A88
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 21:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C763022129E;
	Tue,  6 May 2025 21:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PI066gmd"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9596B221290;
	Tue,  6 May 2025 21:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567356; cv=none; b=ema4eQz+uYJNIVkyWoRYpLvihV/KPqoPCkqRDERXTaL8lCg7/S2/YRAbf72kFPfWJeDt4LCLtXngczKNNCgFtPNpSfskoOg4/HZB0IbkAtUAdtyQLYglfb+15No4vER8i1NOxs/t8wU5vPYmCkcXaKLX6RPYDBjxo+F5kXcz2Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567356; c=relaxed/simple;
	bh=RF9843dbFrk6e8uyuiWYTAzm8ROQdbBggXxDl2wRuZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XSGjeYaHfVJ4KJ4Co1a0X5r96V5Gb/N2LY0rynQWNyX0ux4qGq5OxgKJSlDhOCuTfF7bERPuCgwbSNDGJTOGIpbdaw6IFaHQMs9zopG1v57PL5u6nro4TnLTMKC7HzcxunSUfIuoNJ6nH1r68x6SEGqzKDFJzTb1IUNofybiCc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PI066gmd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8785CC4CEE4;
	Tue,  6 May 2025 21:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567356;
	bh=RF9843dbFrk6e8uyuiWYTAzm8ROQdbBggXxDl2wRuZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PI066gmdawRdhOB3h2GW4AiBDin5EmVwVVK31WU+7fevNxpO5xEr5swC3HVkpuw8G
	 OYqb2feBYqIvhBGJBhGg+ABFH6qWxt8J/Eg4U5ScJB0bVXKcg9MOFJaCnFY2a1F0fj
	 HYWPkWzg7CoWTL9TZbVqsyASRA3OmCE1HYeEq3p50CqND28XjfbF9odQ9Cf1Ootv5b
	 fykP71jRzt7fN3cRGyCWIy/xavtMvNt75BZ6V9GRaLD5zqpzvkL/25Dki8IQUb9v/h
	 T0V7o1X5+zBicgchawcc6ANsLt1JVfJ65Wd58I00vuMmEoV0l/c74It6b1Yhw6jAZI
	 OJ2h4Ow4mqZYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 16/20] io_uring/fdinfo: annotate racy sq/cq head/tail reads
Date: Tue,  6 May 2025 17:35:19 -0400
Message-Id: <20250506213523.2982756-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213523.2982756-1-sashal@kernel.org>
References: <20250506213523.2982756-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index f60d0a9d505e2..9414ca6d101c0 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -123,11 +123,11 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
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


