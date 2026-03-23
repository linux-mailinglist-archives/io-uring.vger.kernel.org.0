Return-Path: <io-uring+bounces-12782-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4NxGLl75wGkwPAQAu9opvQ
	(envelope-from <io-uring+bounces-12782-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 09:27:10 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BEEC52EE411
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 09:27:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 588753046062
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 08:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E9D35BDAA;
	Mon, 23 Mar 2026 08:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="FVqA1lC3"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CB5126F0A;
	Mon, 23 Mar 2026 08:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774254118; cv=none; b=TQZCdRKnNmiUHB8RpgzSHA2drLQmEe3mKUFuEFZIm0Mkou1+NUAUCLJh3lA5zofq5vMfeIuiSCW6r54jcL/ZcWx7Puf35TjN/Pz4eljlMtIaNf3hLjZgxzsxE6wsbR8oCjFbktWk902RTWc0eAtFt6ggwGn8NVBDmYy5NA1TRr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774254118; c=relaxed/simple;
	bh=3CxvzSzcF68N3Uv+JMgedvzKFvhwgVWiWkcQGeHAOVg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QlRuf0YFiOMFIKlcRpxCe2DG7ztDXEQqZYkXTWfMTcfYfZTKWysF5gGSsxKVkKKh4TqSej5GO75Vgk8w7Q49nzlVg3Ub76uaGZi9J399tiy6YCjUcZADw6nnItH8yhAsxpJBF7Wzu/ZyN0hoSIghn3C8JCwx4EKKnx1bKqA2u38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=FVqA1lC3; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=XN
	un+1WP2Z+fnDyylgQ8lPyhaB9VSbISgjLPoro3x04=; b=FVqA1lC3IkQqFbkFUu
	tRF6/I0vxXlWgGI+12bMdyR3SEQ0HaeGZH1WEprGUYYbu3ZdrwNVy9iPTON8pYmG
	yoipAJ9VcMSjjHmp2KGxkIp3d/u7WJ8sStI8pke2myPDNxAKMk0t3Ab0xafg/suO
	2b1wftw0mVmnhk9X8Qd2VS4Jo=
Received: from pek-lpg-core5.wrs.com (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCHJs2S98BpjGf+Ww--.65325S2;
	Mon, 23 Mar 2026 16:19:31 +0800 (CST)
From: Robert Garcia <rob_garcia@163.com>
To: stable@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Robert Garcia <rob_garcia@163.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y] io_uring/tctx: work around xa_store() allocation error issue
Date: Mon, 23 Mar 2026 16:19:30 +0800
Message-Id: <20260323081930.899697-1-rob_garcia@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgCHJs2S98BpjGf+Ww--.65325S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF48uryUJw47XFy7Xr17trb_yoW8uryUpF
	W7ta4DWF909w17K3WDAwsrWry7Wa1kAF47Wr9xZw10yF4ayFn3Kr1UKr45WF1jkrW8AFWa
	yFZavr4DCr4DAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRO_-9UUUUU=
X-CM-SenderInfo: 5uresw5dufxti6rwjhhfrp/xtbDAhOsGGnA95ONKgAA3P
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12782-lists,io-uring=lfdr.de];
	FREEMAIL_FROM(0.00)[163.com];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[163.com:+];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rob_garcia@163.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,163.com,vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,appspotmail.com:email]
X-Rspamd-Queue-Id: BEEC52EE411
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 7eb75ce7527129d7f1fee6951566af409a37a1c4 ]

syzbot triggered the following WARN_ON:

WARNING: CPU: 0 PID: 16 at io_uring/tctx.c:51 __io_uring_free+0xfa/0x140 io_uring/tctx.c:51

which is the

WARN_ON_ONCE(!xa_empty(&tctx->xa));

sanity check in __io_uring_free() when a io_uring_task is going through
its final put. The syzbot test case includes injecting memory allocation
failures, and it very much looks like xa_store() can fail one of its
memory allocations and end up with ->head being non-NULL even though no
entries exist in the xarray.

Until this issue gets sorted out, work around it by attempting to
iterate entries in our xarray, and WARN_ON_ONCE() if one is found.

Reported-by: syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/673c1643.050a0220.87769.0066.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Modify the function in io_uring.c because it's located here in v5.15. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
---
 io_uring/io_uring.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e5889ec0273f..04e4b1e6a5b8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -8699,8 +8699,19 @@ static int io_uring_alloc_task_context(struct task_struct *task,
 void __io_uring_free(struct task_struct *tsk)
 {
 	struct io_uring_task *tctx = tsk->io_uring;
+	struct io_tctx_node *node;
+	unsigned long index;
 
-	WARN_ON_ONCE(!xa_empty(&tctx->xa));
+	/*
+	 * Fault injection forcing allocation errors in the xa_store() path
+	 * can lead to xa_empty() returning false, even though no actual
+	 * node is stored in the xarray. Until that gets sorted out, attempt
+	 * an iteration here and warn if any entries are found.
+	 */
+	xa_for_each(&tctx->xa, index, node) {
+		WARN_ON_ONCE(1);
+		break;
+	}
 	WARN_ON_ONCE(tctx->io_wq);
 	WARN_ON_ONCE(tctx->cached_refs);
 
-- 
2.34.1


