Return-Path: <io-uring+bounces-7880-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77762AAD022
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 23:49:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 518573AC36A
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 21:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83280220F2B;
	Tue,  6 May 2025 21:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MwWJg+Xk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55053220F29;
	Tue,  6 May 2025 21:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567454; cv=none; b=prkTw7iI09JUcEbpFoN94eXlRzQtbfhnc3Udg3qkZuxfOIcJm/OVxiqoGEAGHcAPuNV9aQ/RwFi0x80POasiRvDa6LsyXx2orAEjBtx04jJUb15s6mwuGfGkkpyL3r1jB13glZ5qUEl17Ua+nAzDFsvggihEMtNCS6r2Y2qHAQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567454; c=relaxed/simple;
	bh=us1N00jgeX6leiAkF9ub6JMcyUj2YMNyUHWD7NPKT3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FEHLeaNyf9aveGCzjHbDCdMAAqWR38Xf1g6qwXOYTdguOdPKv1sLOQNiacPRRo5KeYaFs6xuXrTQGDJBQ1SmQCWDJ0kAsEX/DcVg09M1ahHVB6A0TARjlUREwf+olHtJzKCC5+AnSxTINxvWnaVzJn4HGvqhZ4TYXThApQjD8rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MwWJg+Xk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F30C4CEEE;
	Tue,  6 May 2025 21:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567453;
	bh=us1N00jgeX6leiAkF9ub6JMcyUj2YMNyUHWD7NPKT3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwWJg+XkJerWUBlOYko0DAvHKqtb1NkE+4KYvT6H/hs/VxWPw71CsiUrBKNmBD/LD
	 MPD9O9Up/QJsrs/oV93R2gnFrWfvp8A0jAYwy/CJuGVZUIPHPD0nT9+vgel/o9E+EC
	 t0VRq7TzEV2NRJKzq0Pt8DGNU1SDF/g2okpXEPaZIqBRBKPDYao6H7ucq8nhXdilzs
	 w80Cbp8f3vQPWaLHdSL7dppBMAoS+OAtUJWDrdZxQCmAPKsY536xibK6sSAAtYux9H
	 kA8Sh5CIXc1OYXXBfLOIh0a6Aj0m/iFC/jFUogF7PDRpGOQfC3J6m8XMLHLM2MiYFQ
	 6idNcUAv527UA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 6/6] io_uring/fdinfo: annotate racy sq/cq head/tail reads
Date: Tue,  6 May 2025 17:37:14 -0400
Message-Id: <20250506213714.2983569-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213714.2983569-1-sashal@kernel.org>
References: <20250506213714.2983569-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.137
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
index ea2c2ded4e412..4a50531699777 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -79,11 +79,11 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
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


