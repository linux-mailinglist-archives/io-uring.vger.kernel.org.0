Return-Path: <io-uring+bounces-13872-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id RjHFFqIkRmqlKgsAu9opvQ
	(envelope-from <io-uring+bounces-13872-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 10:43:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ABD06F4EAA
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 10:43:13 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=EYb1ghfo;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13872-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13872-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA0DB3119F63
	for <lists+io-uring@lfdr.de>; Thu,  2 Jul 2026 08:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E019F42E8DF;
	Thu,  2 Jul 2026 08:30:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C9542E8D9
	for <io-uring@vger.kernel.org>; Thu,  2 Jul 2026 08:30:20 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782981023; cv=none; b=OVHjn19mLV02Twr1kjUWbBWeZ9c5kk8zdhLdP3jPYJAdksZxuXNogA4zeiW6RGNGInBwp2eixIAETES/IDXJ3HSOK98ZKnPm1cEKX0cgp2PDRfCgZQLdxF0MlfHV/nBETPsEx/j73jlJkZzEUtg8xr2pCi1eKuT/nqmkcx2TC8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782981023; c=relaxed/simple;
	bh=ssAp/5B8yztfE+xM92GvOqjQQLI0MJdNz1V41fAIA14=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mt7Pf4qpkgxZT02Y7KJsZ8f1AdkKRu5kh/fSpnsFdSJnuxHBvaIC4jBCGyRB+XVrEjR3wHZ9U3eYxCsrrJ1UDWF0/siiz6nYf3zyYjE+/3QRxcYbo2gv78qgQru2vLKSNpahRqbySPman8oSE/qNXFLU8u/zgetAHxgqk7Tassc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EYb1ghfo; arc=none smtp.client-ip=117.135.210.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=5G
	tWmpp7nI5jJ4KelCqQMF5TVChPY3TroFh4/PU68iI=; b=EYb1ghfox/bzkPTGwb
	8oF0wqSRLhkJWfKOpsrX930iHkR9s2Kk1E9LhyR5YIQrY634QHQwgDlat+uTIlL5
	hkwhKWdXTwtWS9N3wxRR1K61u/0U9iQuHOStu40TusW4Gy9FF2EXjajaOChDjAOE
	b132VDxyJRn2kD9+f6h6Y84zQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnH0R0IUZqmPUCHA--.22854S4;
	Thu, 02 Jul 2026 16:29:46 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 2/2] io_uring/uring_cmd: fix uring_cmd.c comments
Date: Thu,  2 Jul 2026 16:29:37 +0800
Message-Id: <20260702082937.3707134-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260702082937.3707134-1-yangxiuwei@kylinos.cn>
References: <20260702082937.3707134-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnH0R0IUZqmPUCHA--.22854S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr17trW8uw1UKF18Jw43KFg_yoW8GF1xpF
	WIgrykKFW5Arn3Ja4DAF4DWa4UZFWkA3ZrJ347ur15Gw15AFnxKr4rKF95WFyUZrWkA343
	tF4Sq3yDZr1jy3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uylk3UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRqSI2pGIXoTHgAA3Q
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13872-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:yangxiuwei@kylinos.cn,s:lists@lfdr.de];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9ABD06F4EAA

Fix "concelable" -> "cancelable" in the comment above
io_uring_cmd_mark_cancelable(), and fix the memory ordering comment
in __io_uring_cmd_done() to reference io_do_iopoll() and
->iopoll_completed.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 io_uring/uring_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index fe32311b2e51..8313600583b5 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -90,7 +90,7 @@ static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
 }
 
 /*
- * Mark this command as concelable, then io_uring_try_cancel_uring_cmd()
+ * Mark this command as cancelable, then io_uring_try_cancel_uring_cmd()
  * will try to cancel this issued command by sending ->uring_cmd() with
  * issue_flags of IO_URING_F_CANCEL.
  *
@@ -168,7 +168,7 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 	}
 	io_req_uring_cleanup(req, issue_flags);
 	if (req->flags & REQ_F_IOPOLL) {
-		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
+		/* order with io_do_iopoll() checking ->iopoll_completed */
 		smp_store_release(&req->iopoll_completed, 1);
 	} else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
 		if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
-- 
2.25.1


