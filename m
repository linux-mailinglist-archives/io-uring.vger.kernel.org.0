Return-Path: <io-uring+bounces-7878-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C032EAACFE6
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 23:43:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FB215206B8
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 21:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8692A22A7E7;
	Tue,  6 May 2025 21:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6b0NV7G"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A91422A4FD;
	Tue,  6 May 2025 21:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567400; cv=none; b=V0GfICFpB0GbQjUfRbHM1Ak7vP5fcNjoA1CT7gEWubrDEpZt6rS5yNw/yGw5yRmtak6argwGiGcAL9ttUppTUUjAsW2pOPNbwMvD5HgdR/N2WFQMoNlevJ16VHWwyLsf+XgFhq4LhcnvnD1Il3IIzqPzJQIyMQTfzk4Rt9X1HUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567400; c=relaxed/simple;
	bh=QRkVlzjd+uMDSYB5u/qvr7CuHfFkeeV8Swf9vlM3Ado=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PyUSu4r9veq9VFVV9HMdSOEN8tut/eplgyms6mlp/EokM0i7Zs07hWE/LhpS4N1QpMuU08dAb0xkaDCSuv0w7jAYnYrgYkagDMLOWXlo27eNNXVjhDFk23M0Ix8WgsCiYTQtsAriO1bcZzbPuWTAhPMsj29KSkXynl+Dylh7DsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6b0NV7G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5309DC4CEEF;
	Tue,  6 May 2025 21:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567400;
	bh=QRkVlzjd+uMDSYB5u/qvr7CuHfFkeeV8Swf9vlM3Ado=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6b0NV7GXo12qvOaE7UI0rGXVj5qaTteINuibwPNYbTPhKlb/F6UqwiFexdg3Se2S
	 T83+7iQ167ZJhA4POu9BvJ8d46CqXvPIL0E2G3wp0x55OIw77uSfmXZobwvgffVycG
	 a3Sa2akDTZeFvMS02xUQWiSEz9wY+ZujKZAL6gjvthj7QBCZwxSpyCDgM1KoG9UT/K
	 4ZOiyKHhsoPkFU8Boc+9tgCoHDevRFMS7iAQtUkK/moNZ3oxclF3A0CubmfBYcg16C
	 SYhh4Bb5iN+c0Riu7GdV4eH8n6oLR0NRL1smG+umIxIBbB5LVcOnqHJdnkkOavmwz4
	 GlWS6c0H219qQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 15/18] io_uring/fdinfo: annotate racy sq/cq head/tail reads
Date: Tue,  6 May 2025 17:36:07 -0400
Message-Id: <20250506213610.2983098-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213610.2983098-1-sashal@kernel.org>
References: <20250506213610.2983098-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.27
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
index 6b1247664b355..ecdbe473a49f7 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -83,11 +83,11 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
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


