Return-Path: <io-uring+bounces-13660-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id E+1DChagKWpyawMAu9opvQ
	(envelope-from <io-uring+bounces-13660-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 19:34:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A6566BF97
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 19:34:13 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=astralinux.ru header.s=mail header.b=nwQq8tAf;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13660-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13660-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=astralinux.ru;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EA5F5313206F
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 17:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A72EC33F8C3;
	Wed, 10 Jun 2026 17:22:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F672277C88;
	Wed, 10 Jun 2026 17:22:25 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781112150; cv=none; b=MBv1wsKfuqgEPcxSM7mP873HdDARvscws3D5bon+TmGSVCSHegBKJgwG0E1AqCVaxj5ZVu7z9R4wr0SwwpNv9T01A/I735Vc0k9nIV9A/s9ErFbZr7vPQIhC9XnO+UG2adPFbqdCJ3BPz889mLSHKzPCs3SlbDuE8wkS8M+0FAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781112150; c=relaxed/simple;
	bh=1YcX7DSqHTLYJFlMsJlIfEb7XFfyA/j7T8KckpKzE1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PYR09plR08l3eoTrKWCwpeEkjJcMFYrXhuc1GVi6R053euwyhK1iqYrxsBpGREM4HBgHo0TObp1AZwOatChxN5cT9yiAE/4jsCaLpuCepVa8Aa9aq27Ip9VD3gV1dcvF07ERn+LlaPjlPdkklva5FRdSUKggBupbjGBLKxo4M6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=nwQq8tAf; arc=none smtp.client-ip=93.188.205.243
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1781112137;
	bh=1YcX7DSqHTLYJFlMsJlIfEb7XFfyA/j7T8KckpKzE1Y=;
	h=From:To:Cc:Subject:Date:From;
	b=nwQq8tAfY0uKDGmhAe9Eq/5y4v2rD3KSSymfd6sV9AsBwox2CoCV+6GZvsMdfzEz/
	 HWUUiIu9D5oMJi+ZWgpoulZzOf1fc35Xw3FdXwZ7JKwVkdk9RSP/S2tOj1XK+aYWNp
	 1E3XBDQiwMRx3XVEpm79pmdHv4fIVGYhuYoHYIaXVLoTOH+asmAS1opni6eeEXOHT6
	 2HmB4W421dhK6NuFql/ZhTdo36uL4CGn+ZHZN6PyteecC8CGUFV/T7NRi31zl0yuYp
	 uHKUpI0MI/aTsLFINg9wuf41B1/XAKrbDhy/eGy8Scpx4nx30Yez8pXvhHdm86GGQe
	 5bz4+FUsi99vA==
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id 3CADA1FA08;
	Wed, 10 Jun 2026 20:22:17 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Wed, 10 Jun 2026 20:22:15 +0300 (MSK)
Received: from rbta-msk-lt-156703.astralinux.ru (unknown [10.198.54.246])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4gbCJR23djzShcf;
	Wed, 10 Jun 2026 20:22:15 +0300 (MSK)
From: Alexey Panov <apanov@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Panov <apanov@astralinux.ru>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Li Zetao <lizetao1@huawei.com>
Subject: [PATCH 5.10] io_uring: prevent opcode speculation
Date: Wed, 10 Jun 2026 20:22:03 +0300
Message-Id: <20260610172203.27999-1-apanov@astralinux.ru>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected, bases: 2026/06/10 17:02:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: apanov@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 107 0.3.107 575e75fe8e3b9d45c142d144823c5de38605099e, {Tracking_uf_ne_domains}, {Tracking_internal2}, {Tracking_from_domain_doesnt_match_to}, new-mail.astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;astralinux.ru:7.1.1;127.0.0.199:7.1.2;lore.kernel.org:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 203793 [Jun 10 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.22
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/06/10 13:12:00 #28226830
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2026/06/10 17:03:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[astralinux.ru,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[astralinux.ru:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[astralinux.ru,kernel.dk,kernel.org,gmail.com,vger.kernel.org,linuxtesting.org,huawei.com];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13660-lists,io-uring=lfdr.de];
	FORGED_SENDER(0.00)[apanov@astralinux.ru,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:stable@vger.kernel.org,m:gregkh@linuxfoundation.org,m:apanov@astralinux.ru,m:axboe@kernel.dk,m:sashal@kernel.org,m:asml.silence@gmail.com,m:activprithvi@gmail.com,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:lvc-project@linuxtesting.org,m:lizetao1@huawei.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[astralinux.ru:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[apanov@astralinux.ru,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,huawei.com:email,kernel.dk:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,astralinux.ru:dkim,astralinux.ru:email,astralinux.ru:mid,astralinux.ru:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 65A6566BF97

From: Pavel Begunkov <asml.silence@gmail.com>

commit 1e988c3fe1264708f4f92109203ac5b1d65de50b upstream.

sqe->opcode is used for different tables, make sure we santitise it
against speculations.

Cc: stable@vger.kernel.org
Fixes: d3656344fea03 ("io_uring: add lookup table for various opcode needs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Link: https://lore.kernel.org/r/7eddbf31c8ca0a3947f8ed98271acc2b4349c016.1739568408.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Alexey: Sanitize req->opcode directly because io_init_req() in
  linux-5.10.y has no local opcode variable and subsequent lookups use it. ]
Signed-off-by: Alexey Panov <apanov@astralinux.ru>
---
Backport fix for CVE-2025-21863
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2ca09e2dbd3d..51262d48a4a1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -7193,6 +7193,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
+	req->opcode = array_index_nospec(req->opcode, IORING_OP_LAST);
+
 	if (!io_check_restriction(ctx, req, sqe_flags))
 		return -EACCES;
 
-- 
2.47.3

