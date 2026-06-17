Return-Path: <io-uring+bounces-13759-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id rvfBJV0MMmouuAUAu9opvQ
	(envelope-from <io-uring+bounces-13759-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 04:54:21 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C2169631B
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 04:54:20 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=IgXEhokS;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13759-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13759-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 328B2301530E
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 02:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7271F3009E1;
	Wed, 17 Jun 2026 02:54:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897DB1A8F97
	for <io-uring@vger.kernel.org>; Wed, 17 Jun 2026 02:54:15 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781664859; cv=none; b=jNbF4JHEvC+dovOQVapH0zBE15UDr8IuLzudttgPR+Xcby6+LyYSlHExd84D8GYg/L5CCHugkIyMc45MXmBfGspzmAVQyLrM8ALDkDakifv5Drrun7E4CD9n2fdQUCX6FRa6TdOJvpaYBQYbvFfUdgubmvVP3VvezUwlQjzzwfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781664859; c=relaxed/simple;
	bh=xWnom2kiigbrFhDmVUkF3m2NppuaMEJiZ7A1xcgu4k4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MB7ZZgMjWVQz/bDIFHxBmaNqLYV1gFue8nWl0ZLVjI6SP5ajpFy2dQifY7PDCu9NY4AHe+gdXEBI11xCXTnV/g7HuFfUBRkWrOGumuRifFrx7wdNAFcp2p2xE1IdnwoJ3qsQies3OCKHEAwqu7EHPNUfZniNy7bSHgplEFpsVDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=IgXEhokS; arc=none smtp.client-ip=220.197.31.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=PZ
	A+aaIdABARmbsUz08kLXIBAZZm/8ziqEuO/H4Q8xA=; b=IgXEhokSe3ASOEPQRC
	mgl7ZSKNtx5sm7VzUaaqvxjuDm7FxRzeIeCRX6xsj/ztfJtj1e+k2Sf5d7+Z5Mt4
	aRWqkOVwIV4Pc1XI/IWeW6/Gm6ztlkJyRPcqiGZTQz5msVsgxJ/SVn5KL+L+T1Ir
	KpGlZWQt9Z3bgqePA6gmVJucc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wB3Hcs+DDJqdJSeEA--.39571S2;
	Wed, 17 Jun 2026 10:53:52 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: krisman@suse.de,
	io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH] io_uring/net: fix netmsg_cache iovec leak on BIND and CONNECT
Date: Wed, 17 Jun 2026 10:53:48 +0800
Message-Id: <20260617025348.1301777-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3Hcs+DDJqdJSeEA--.39571S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7try7JrykGw4rZryfXFWkWFg_yoW8Zr47pF
	Wjva15AFWrXw4fKa1kXFs8CFyrJ3W8uF18A3yUCFs2vF17Xws2qF48Kas8C3WqqrWxCr17
	Wrs2gFs8Zr1UCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUF4iUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgA6ymoyDEDDdgAA3T
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13759-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:krisman@suse.de,m:io-uring@vger.kernel.org,m:yangxiuwei@kylinos.cn,s:lists@lfdr.de];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,kylinos.cn:mid,kylinos.cn:from_mime,vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C3C2169631B

BIND and CONNECT allocate struct io_async_msghdr from netmsg_cache via
io_msg_alloc_async(). When a prior SENDMSG left a heap-allocated iovec[]
in the cached header, REQ_F_NEED_CLEANUP is set. Neither opcode had a
cleanup handler, so io_clean_op() would kfree(async_data) without
freeing the iovec on prep failure or cancellation. io_bind() also
omitted io_req_msg_cleanup() on the issue success path,
unlike io_connect().

Add io_sendmsg_recvmsg_cleanup for both opcodes and recycle the async
header from io_bind() after issue, matching CONNECT.

Fixes: 7481fd93fa0a ("io_uring: Introduce IORING_OP_BIND")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 io_uring/net.c   | 3 ++-
 io_uring/opdef.c | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 8df15b639358..0382be472712 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1855,8 +1855,9 @@ int io_bind(struct io_kiocb *req, unsigned int issue_flags)
 	ret = __sys_bind_socket(sock, &io->addr, bind->addr_len);
 	if (ret < 0)
 		req_set_fail(req);
+	io_req_msg_cleanup(req, issue_flags);
 	io_req_set_res(req, ret, 0);
-	return 0;
+	return IOU_COMPLETE;
 }
 
 int io_listen_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index c3ef52b70811..3ee020701fc1 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -658,6 +658,9 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_CONNECT] = {
 		.name			= "CONNECT",
+#if defined(CONFIG_NET)
+		.cleanup		= io_sendmsg_recvmsg_cleanup,
+#endif
 	},
 	[IORING_OP_FALLOCATE] = {
 		.name			= "FALLOCATE",
@@ -816,6 +819,9 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_BIND] = {
 		.name			= "BIND",
+#if defined(CONFIG_NET)
+		.cleanup		= io_sendmsg_recvmsg_cleanup,
+#endif
 	},
 	[IORING_OP_LISTEN] = {
 		.name			= "LISTEN",
-- 
2.25.1


