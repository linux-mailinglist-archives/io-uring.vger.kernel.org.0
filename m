Return-Path: <io-uring+bounces-13473-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eHjgOCadDmqlAgYAu9opvQ
	(envelope-from <io-uring+bounces-13473-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 07:50:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FA8259F38D
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 07:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0AEA330688E9
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 05:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB013546EF;
	Thu, 21 May 2026 05:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="o3reaJWM"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95E9381B16;
	Thu, 21 May 2026 05:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779342603; cv=none; b=iRvfQA0x7WVexeVf1Jlk9o/TS5U9GnpuOb1heKIxiGSH0wbt7yygmsH5L8JcAzaDQioMs0seDilHvOSvXUXWbez4XQKcGWQPGtWCt5BLsUNp3bsGoMJcZbnouwTkNtc1CUsnxASnqXbirYtyN1DB+WwEQ/TVWr2rkhgepCb0kOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779342603; c=relaxed/simple;
	bh=r9G3Ri55639VYmmaXhamtY7BDfAKKV8uBB1VOgjM9uE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TlOV8I8Y2PZqieWXTtuExIw5QLBk8JSCvW6A0Ww3H+IXYPoFj86chGTeDvqNKlQt1t3iyTLU/UDwEc6hOkwO2gptpp/5fwoq6OZTkpTIOTnW6LpHSex5BLRm4nb2L5LTKuQ3bMaqEvWIyTJMf1PldKLSE/mKKCTj7dcLv85C3vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=o3reaJWM; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=/c
	sLk9PgOsj936xAZWkc+FqW1cHXQojIjVcC7AsGo4Q=; b=o3reaJWMjAZ/VGzCLn
	OFk5oOxZN42XMAaOruqvt1x6Y7aqVD9NYExBXfdoQOuVIlKugfGIjFiH5T6y94dQ
	Zv3GGUj1Cs+VXsr22Q7/oWqeY+gMeFEUteZC9TENhpE51Gj0buez6L3Y8ZTGcrnd
	1jH27sviEOqy8lKa86JbOIGlI=
Received: from pek-lpg-core5.wrs.com (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDnjyTfnA5qevVhCg--.57735S2;
	Thu, 21 May 2026 13:49:20 +0800 (CST)
From: Robert Garcia <rob_garcia@163.com>
To: stable@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Li Zetao <lizetao1@huawei.com>,
	Robert Garcia <rob_garcia@163.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.1.y] io_uring: prevent opcode speculation
Date: Thu, 21 May 2026 13:49:19 +0800
Message-Id: <20260521054919.87373-1-rob_garcia@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnjyTfnA5qevVhCg--.57735S2
X-Coremail-Antispam: 1Uf129KBjvJXoWruFW7CFW5Cr1UJw1DCFWrAFb_yoW8JrWfpr
	yUCw4Yqr9Ykr9rGa1DAw4akFWUKa9rAFy7J398Zw4fAF17ZF1a9r1rKFWSgF1UtFWqkrW5
	Jwsagr4vkw47AFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pipB-_UUUUU=
X-CM-SenderInfo: 5uresw5dufxti6rwjhhfrp/xtbDAQB96GoOnOAoxAAA3g
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13473-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 4FA8259F38D
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
Signed-off-by: Robert Garcia <rob_garcia@163.com>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d0d9ff6b87a0..fdb8afdb0135 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2031,6 +2031,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		req->opcode = 0;
 		return io_init_fail_req(req, -EINVAL);
 	}
+	opcode = array_index_nospec(opcode, IORING_OP_LAST);
+
 	def = &io_op_defs[opcode];
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */
-- 
2.34.1


