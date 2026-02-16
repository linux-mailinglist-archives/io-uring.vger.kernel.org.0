Return-Path: <io-uring+bounces-12233-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YBjCJGLxkmlA0QEAu9opvQ
	(envelope-from <io-uring+bounces-12233-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 11:28:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C203142588
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 11:28:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B82BE3010250
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 10:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B43AB2FFDCA;
	Mon, 16 Feb 2026 10:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b="QSkhDXXg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail1.fiberby.net (mail1.fiberby.net [193.104.135.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AFA22B5AD;
	Mon, 16 Feb 2026 10:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.104.135.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771237726; cv=none; b=rfHZ0rb1VOzAdZvcDd47HNpd18Pz8jU1QRaG3OHxOvfvzv/ut//FUuWLjTKP46dKVWVSMxdIBgPUtFT5nMG64QNEJPP1xFS4hqKob3a6hOjiggP2L63U2rElDdiwt29ifCd6mybsIax/xrVJ2P+Xp4qAdnAENxXjfoIOrODHEaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771237726; c=relaxed/simple;
	bh=c9ooYNTK6GhK1xMCHJCOAWl1HFLi0SWqf37iMshRHN0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=srXQWHG7/I5WNpOVo5TlSf0HfA9J2eMC990z98w3oFdGwmfaZcWU81kw7kQkLhg/njCWt7KFYWQYu1M212pBm7r/JaQH9Fn+L/DlPcfIf8zUqgwgNl8jJWzTNtTBOipIXnzIhUZ6scta8Lx6htGuj0QIFw7zQid3bwWVkljLbH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net; spf=pass smtp.mailfrom=fiberby.net; dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b=QSkhDXXg; arc=none smtp.client-ip=193.104.135.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fiberby.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fiberby.net;
	s=202008; t=1771237721;
	bh=c9ooYNTK6GhK1xMCHJCOAWl1HFLi0SWqf37iMshRHN0=;
	h=From:To:Cc:Subject:Date:From;
	b=QSkhDXXg3Ho3xt1v3OdIVvYsoOxff6H8HbiiPw5M4FYfuCHG5h5SuVYi3o1vVJpc5
	 whVEembQYcet/5LBtgY9BMWf86SJjB+eBZ0nIBJBz4wwMq+UX9M3JfkS0vQwMURpNv
	 mlqekfl1g57G8+oA8if+GEk51/CYoZGU4Fxv9aegksfaBKR6gpbeKbxZbbCjMq1vgu
	 MHonht2SrekLpUsNjZ6cGimY3dG/pEd+U6r1cgP1kG+Axb+h4sPwqkHBJtelfe9Or2
	 mSfrom3D4y/S+V23cgUFVVeol5JEeRJBW+jufcXFOWGaUujMY77hj7GcCZRt/UlaRE
	 Q6zwsuXHM5L8Q==
Received: from x201s (193-104-135-243.ip4.fiberby.net [193.104.135.243])
	by mail1.fiberby.net (Postfix) with ESMTPSA id 320C3600FF;
	Mon, 16 Feb 2026 10:28:17 +0000 (UTC)
Received: by x201s (Postfix, from userid 1000)
	id 36863202027; Mon, 16 Feb 2026 10:27:55 +0000 (UTC)
From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>
To: Jens Axboe <axboe@kernel.dk>
Cc: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Breno Leitao <leitao@debian.org>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] io_uring/cmd_net: split ioctl code out of io_uring_cmd_sock()
Date: Mon, 16 Feb 2026 10:27:53 +0000
Message-ID: <20260216-io-uring-rfc@fiberby.net>
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
X-Spamd-Result: default: False [-1.45 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW(-0.50)[fiberby.net,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[fiberby.net:s=202008];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12233-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[fiberby.net:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[ast@fiberby.net,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0C203142588
X-Rspamd-Action: no action

io_uring_cmd_sock() originally supported two ioctl-based cmd_op
operations. Over time, additional operations were added with tail calls
to their helpers.

This approach resulted in the new operations sharing an ioctl check
with the original operations.

io_uring_cmd_sock() now supports 6 operations, so let's move the
implementation of the original two into their own helper, reducing
io_uring_cmd_sock() to a simple dispatcher.

Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
---

This RFC patch is targeting for-next, and applies on top of this
patch for master:
  [PATCH] io_uring/cmd_net: fix too strict requirement on ioctl
  https://lore.kernel.org/r/20260216-io-uring-fix@fiberby.net

I plan to submit v1 once that patch propagates to uring/for-next.

 io_uring/cmd_net.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index 57ddaf874611..56696c4baad1 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -7,6 +7,21 @@
 #include "uring_cmd.h"
 #include "io_uring.h"
 
+static int io_uring_cmd_get_sock_ioctl(struct socket *sock, int op)
+{
+	struct sock *sk = sock->sk;
+	struct proto *prot = READ_ONCE(sk->sk_prot);
+	int ret, arg = 0;
+
+	if (!prot || !prot->ioctl)
+		return -EOPNOTSUPP;
+
+	ret = prot->ioctl(sk, op, &arg);
+	if (ret)
+		return ret;
+	return arg;
+}
+
 static inline int io_uring_cmd_getsockopt(struct socket *sock,
 					  struct io_uring_cmd *cmd,
 					  unsigned int issue_flags)
@@ -156,27 +171,12 @@ static int io_uring_cmd_getsockname(struct socket *sock,
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
-	struct sock *sk = sock->sk;
-	struct proto *prot = READ_ONCE(sk->sk_prot);
-	int ret, arg = 0;
 
 	switch (cmd->cmd_op) {
 	case SOCKET_URING_OP_SIOCINQ:
-		if (!prot || !prot->ioctl)
-			return -EOPNOTSUPP;
-
-		ret = prot->ioctl(sk, SIOCINQ, &arg);
-		if (ret)
-			return ret;
-		return arg;
+		return io_uring_cmd_get_sock_ioctl(sock, SIOCINQ);
 	case SOCKET_URING_OP_SIOCOUTQ:
-		if (!prot || !prot->ioctl)
-			return -EOPNOTSUPP;
-
-		ret = prot->ioctl(sk, SIOCOUTQ, &arg);
-		if (ret)
-			return ret;
-		return arg;
+		return io_uring_cmd_get_sock_ioctl(sock, SIOCOUTQ);
 	case SOCKET_URING_OP_GETSOCKOPT:
 		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
 	case SOCKET_URING_OP_SETSOCKOPT:
-- 
2.51.0


