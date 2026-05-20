Return-Path: <io-uring+bounces-13445-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gHufCqlUDWr9wAUAu9opvQ
	(envelope-from <io-uring+bounces-13445-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 08:28:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 90DF258821B
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 08:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DEA03300999C
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 06:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 982A7372EE0;
	Wed, 20 May 2026 06:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="WYETC6VC"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A720366060;
	Wed, 20 May 2026 06:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779258533; cv=none; b=cxVgHPJpERT7hGdxW/x93h5BdD5+E9nP5r2Kltbi2+uvVHbr0cBnk13FMRAPKDRA+NdtfSNBAYlhid8qox7PQBq2nMTvR0+FSEjwuHfFPiRYmaegLFzuNcVkZLbfaPs8taWfeMMQGLbgfksA4obopxAybLX1CA0fQBlxeUJlF1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779258533; c=relaxed/simple;
	bh=I+1ogSeJKYuojHSs42V27ZpdzAvHqRsNBg2CvhsGyz0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hZuYPCGbhJbYgju74zhXZSwtEVTJrVJKWr4v4oBYfTuhKxwlQfs1YyqMFUS7uzVJOVwGo82O9tKB7yM3zFHXn+Cb6jbu4X/7o5J/HUB4dX/br+u2aQwsw7bHZw2Hbi6dYAiHIJvIoBnrTjDgNpTMyLf7kTUDMor2Gkizy1ykOC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=WYETC6VC; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=V/
	w9FUmKivkArIsAleWJ2/m6pzU1GMwFJZlkA2kvgXI=; b=WYETC6VCjRelVe8zXD
	Ho6QzUrHpq5qLJjsuxCpJgUiE34vztRLWh59JMaA4FCi2oPIJiCN7BEClZ5VUOtn
	ubeHkz0eRhz/HuXh5GpHHN/LjoDNPA+xVSWWOIg1mN4/RGb6JVJpSZhpNBHArsf9
	vGuyGJOS5b4gNq9Ps41cFGoAw=
Received: from pek-lpg-core5.wrs.com (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgBnrbWRVA1qpWqxEQ--.9S2;
	Wed, 20 May 2026 14:28:36 +0800 (CST)
From: Robert Garcia <rob_garcia@163.com>
To: stable@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Li Zetao <lizetao1@huawei.com>,
	Robert Garcia <rob_garcia@163.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y] io_uring: prevent opcode speculation
Date: Wed, 20 May 2026 14:28:33 +0800
Message-Id: <20260520062833.2563847-1-rob_garcia@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgBnrbWRVA1qpWqxEQ--.9S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFWUGr45tF15Ww1rKrWUtwb_yoW8JF47pr
	yUGa1YqrykKryxK3Z5GF43CFWUCa9xAFWxXw4Duw4Syr17ZFnIgr109FWIgFy7tFWvkry5
	ZrZavFZYv3y7Aa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piGjg8UUUUU=
X-CM-SenderInfo: 5uresw5dufxti6rwjhhfrp/xtbC5hQYg2oNVJQ8PAAA3O
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13445-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.dk,huawei.com,163.com,vger.kernel.org];
	DKIM_TRACE(0.00)[163.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rob_garcia@163.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[163.com];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,huawei.com:email,kernel.dk:email]
X-Rspamd-Queue-Id: 90DF258821B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 1e988c3fe1264708f4f92109203ac5b1d65de50b ]

sqe->opcode is used for different tables, make sure we santitise it
against speculations.

Cc: stable@vger.kernel.org
Fixes: d3656344fea03 ("io_uring: add lookup table for various opcode needs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Link: https://lore.kernel.org/r/7eddbf31c8ca0a3947f8ed98271acc2b4349c016.1739568408.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Use req->opcode instead of opcode here. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 38decfc1a914..47221d7bad61 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -7365,6 +7365,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
+	req->opcode = array_index_nospec(req->opcode, IORING_OP_LAST);
+
 	if (!io_check_restriction(ctx, req, sqe_flags))
 		return -EACCES;
 
-- 
2.34.1


