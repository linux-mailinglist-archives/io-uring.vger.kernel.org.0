Return-Path: <io-uring+bounces-12234-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6KDDK2jxkmlA0QEAu9opvQ
	(envelope-from <io-uring+bounces-12234-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 11:28:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 460C9142599
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 11:28:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E712530074AC
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 10:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FEE2FFF9D;
	Mon, 16 Feb 2026 10:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b="bElWKRco"
X-Original-To: io-uring@vger.kernel.org
Received: from mail1.fiberby.net (mail1.fiberby.net [193.104.135.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464412FF67A;
	Mon, 16 Feb 2026 10:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.104.135.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771237728; cv=none; b=q5vdUZyuFp+viDGZZY+6Fy0J4FuVzzTFpxVHHMxcL88UedIPaIozeVwZuMkqyhhwrf07N8uNhvNs3OrkoLRdrFTyZE1Ml/WqqA6Jeh/ug/mbyWRHFSxIYgkFb2wbuhjbaH6bLEcnu+XsIlKGWCrjApgAeObuP5yqE8BtjkpsZWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771237728; c=relaxed/simple;
	bh=zvTyan5qupPAd8ZhYvh6WTVKUc7a46aewxejGUk+eo0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cP8z3VZrEyXcSvBhIup0nqNao2XLij+jTlPl9bM53oYPkDVuUVsEISak8Vxc+qxosPEKFebsEBa61fIqaAZcsf9exQWg/DCSUzRTi0rFJ0Ttu56xgFb8KRpUIuqtXP/bfvC+fk0tNAnB1Uv0iaUmW99cIVn/SFsnZiy/M3jWWDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net; spf=pass smtp.mailfrom=fiberby.net; dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b=bElWKRco; arc=none smtp.client-ip=193.104.135.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fiberby.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fiberby.net;
	s=202008; t=1771237724;
	bh=zvTyan5qupPAd8ZhYvh6WTVKUc7a46aewxejGUk+eo0=;
	h=From:To:Cc:Subject:Date:From;
	b=bElWKRcoQ2OGY66Y65eHcyN6Go3vy0FJUiqEuBsK/ZcIT5KnKKsxYTaGm61pXjL3/
	 et6gAxJYm1KQwKpiyPT1ArTAgEo/hDA5jj8oHw5OQp0AHG2A42yMztg7MLUD23QoJ6
	 I3sQPNypgjTGK0P8XHPL7gcQ5jV8+2H9dOJW7pOXy3NqCl+RTmWp58z9p0wR1Yk+A6
	 J4fUX8Vgu1rB5RUMBjIplfd2llWRnZVxcRZsGMXnTcOHn85+D3YoSJthUWAyDpE8WW
	 el7Y9Gbdd4H6Xzp4bCdOKhcz6i0+I02TS0B3TZ5UwQS834SlPlYSRbk1Gxx8u0Uihc
	 QYKfKlMeLA9Ag==
Received: from x201s (193-104-135-243.ip4.fiberby.net [193.104.135.243])
	by mail1.fiberby.net (Postfix) with ESMTPSA id 3597F60103;
	Mon, 16 Feb 2026 10:28:17 +0000 (UTC)
Received: by x201s (Postfix, from userid 1000)
	id 52E112003E2; Mon, 16 Feb 2026 10:27:49 +0000 (UTC)
From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>
To: Jens Axboe <axboe@kernel.dk>
Cc: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Breno Leitao <leitao@debian.org>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] io_uring/cmd_net: fix too strict requirement on ioctl
Date: Mon, 16 Feb 2026 10:27:18 +0000
Message-ID: <20260216-io-uring-fix@fiberby.net>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.39 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.77)[subject];
	DMARC_POLICY_ALLOW(-0.50)[fiberby.net,reject];
	R_DKIM_ALLOW(-0.20)[fiberby.net:s=202008];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[fiberby.net:+];
	TAGGED_FROM(0.00)[bounces-12234-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[ast@fiberby.net,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 460C9142599
X-Rspamd-Action: no action

Attempting SOCKET_URING_OP_SETSOCKOPT on an AF_NETLINK socket resulted
in an -EOPNOTSUPP, as AF_NETLINK doesn't have an ioctl in its struct
proto, but only in struct proto_ops.

Prior to the blamed commit, io_uring_cmd_sock() only had two cmd_op
operations, both requiring ioctl, thus the check was warranted.

Since then, 4 new cmd_op operations have been added, none of which
depend on ioctl. This patch moves the ioctl check, so it only applies
to the original operations.

AFAICT, the ioctl requirement was unintentional, and it wasn't
visible in the blamed patch within 3 lines of context.

Cc: stable@vger.kernel.org
Fixes: a5d2f99aff6b ("io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT")
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
---
 io_uring/cmd_net.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index cb2775936fb8..57ddaf874611 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -160,16 +160,19 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	struct proto *prot = READ_ONCE(sk->sk_prot);
 	int ret, arg = 0;
 
-	if (!prot || !prot->ioctl)
-		return -EOPNOTSUPP;
-
 	switch (cmd->cmd_op) {
 	case SOCKET_URING_OP_SIOCINQ:
+		if (!prot || !prot->ioctl)
+			return -EOPNOTSUPP;
+
 		ret = prot->ioctl(sk, SIOCINQ, &arg);
 		if (ret)
 			return ret;
 		return arg;
 	case SOCKET_URING_OP_SIOCOUTQ:
+		if (!prot || !prot->ioctl)
+			return -EOPNOTSUPP;
+
 		ret = prot->ioctl(sk, SIOCOUTQ, &arg);
 		if (ret)
 			return ret;

base-commit: bb7a3fc2c976b5d0deb35a54ca237519816d7ba9
-- 
2.51.0


