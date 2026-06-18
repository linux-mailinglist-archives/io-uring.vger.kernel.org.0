Return-Path: <io-uring+bounces-13777-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id N8q6E/zdM2rqHQYAu9opvQ
	(envelope-from <io-uring+bounces-13777-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2026 14:01:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 16E1E69FDF2
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2026 14:00:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=Q2CadI+c;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13777-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13777-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7D0133019033
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2026 12:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4443B1006;
	Thu, 18 Jun 2026 12:00:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E51314D26
	for <io-uring@vger.kernel.org>; Thu, 18 Jun 2026 12:00:48 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781784053; cv=none; b=cBspzxrKS3BCMovqRDD8f9UPmYU9vDINHI9wGSLT+nLMB/kEUmcEe7wjo1CFTjP8/ghxmSZWpFkutOA08C6i+uiR9eT8tXPaeQAjX8UF1oDvFN0u1/GDBTuYW5inWhxc/wAG9by+NnWbTVRr2Tyfus6uBhraGitmwIGwjzeeoKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781784053; c=relaxed/simple;
	bh=JtYpQGbdSq49Sy0aNEY6hgnoqr34kwcvVTs3Rt6Afxk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Uw7OxAMDZ+6CCUBpHDZVu7Cz/ofOa+Txnxp5GW41Sr+kNoDyO8tvB6SKsqamJ/8DxD6K2giwCdTQnCZVbhvhcgnFqTbdomBQ3m/rNzgDd/myAarw4wllgyAcwykJxMPq4k3QXi4m4N2GSjW2igAMxqiubtJhAbnwaerRapNt5eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Q2CadI+c; arc=none smtp.client-ip=220.197.31.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=lB
	tF2cNBQyDVv7FiETx7hwaaY+MscmWpfxsn/Txf+Rg=; b=Q2CadI+cZfA6xv7LVd
	p9hL/hIMvskiXOjTb5YztZdzAoXUqVvbtlOQe+eO7919QeWVJfWYmr9QPlVCg82R
	LWibN31vtemlOyaS39ICrA76aOgOfMbX1DfYzSRQlfaAU4ZB1Exq0PEs55o7in8w
	MoV78ZFtlN8xQ41Zw72sM8gJw=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgA33Sjb3TNqp_yLCw--.29181S2;
	Thu, 18 Jun 2026 20:00:28 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH] io_uring: flush deferred completions for multishot CQE32 posting
Date: Thu, 18 Jun 2026 20:00:24 +0800
Message-Id: <20260618120024.852834-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgA33Sjb3TNqp_yLCw--.29181S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GryxAr4rur4xurWfJF1fJFb_yoWfurb_uF
	95trWkWrZaqw1jyw12kr1rZanYkwsFkF48Wr97tFnrJFy3Aas5CryDJr18Crn8X3y7WFW5
	Ga98C34akw1IvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRRMa0tUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6hwWpmoz3dxclwAA3V
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13777-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:yangxiuwei@kylinos.cn,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	RSPAMD_URIBL_FAIL(0.00)[vger.kernel.org:query timed out,kylinos.cn:query timed out];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RSPAMD_EMAILBL_FAIL(0.00)[io-uring@vger.kernel.org:query timed out,yangxiuwei@kylinos.cn:query timed out,yangxiuwei.kylinos.cn:query timed out];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 16E1E69FDF2

io_req_post_cqe() flushes compl_reqs before posting multishot CQEs
since commit 687b2bae0eff ("io_uring: ensure deferred completions are
flushed for multishot").  Apply the same flush to io_req_post_cqe32()
so both multishot aux posting helpers behave consistently.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 io_uring/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1ea2fca34a36..7f54d27cae94 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -900,6 +900,9 @@ bool io_req_post_cqe32(struct io_kiocb *req, struct io_uring_cqe cqe[2])
 	struct io_ring_ctx *ctx = req->ctx;
 	bool posted;
 
+	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
+		__io_submit_flush_completions(ctx);
+
 	lockdep_assert(!io_wq_current_is_worker());
 	lockdep_assert_held(&ctx->uring_lock);
 
-- 
2.25.1


