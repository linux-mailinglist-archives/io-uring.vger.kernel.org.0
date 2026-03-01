Return-Path: <io-uring+bounces-12490-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ONATB3KYo2lIHwUAu9opvQ
	(envelope-from <io-uring+bounces-12490-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 02:37:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E3661CB2E6
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 02:37:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D1781300B29B
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2026 01:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF55288C20;
	Sun,  1 Mar 2026 01:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrtYTaTZ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA5728851C;
	Sun,  1 Mar 2026 01:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328556; cv=none; b=JFvY6LoHrknwb1SVrJx1fEQqWc/OWlpW2NZIpV0gzSPksUs8HoJ/mdbA6VFfRECiMr72yoQXylGz8hCIahVzEEtJi/Mk7wOWIqVP4Qvnf05fXbrc4NNkpJuHDWbAvOmjRWCOYb7TK1G+I2zU6BTWd21fI8Y2RYqFYFKJR9fswWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328556; c=relaxed/simple;
	bh=d8LEJhUrXE7nx3KVR/NfjI60j0q3smueBCCi8kTMZXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O+s9FjVGZyGpAbRnRNVnF/wtdSFdjNEiKJmwok47qizAkdjv6aPVqcQlPHCbXFo7TEyhiMuEwfkEHTnoTS50334nhUjSbycRsWmexNAiyfMEr2ZOCzB4WUjKQEPUw4kYwAN7xQieAZlpYAhZ5K4mQ81FjIlxstc7KUd91gH0mvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrtYTaTZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42D1C19421;
	Sun,  1 Mar 2026 01:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328556;
	bh=d8LEJhUrXE7nx3KVR/NfjI60j0q3smueBCCi8kTMZXk=;
	h=From:To:Cc:Subject:Date:From;
	b=qrtYTaTZ0Bl6ZXxI+LlO8y6OgM3xgWWucuGjQfjuZ+qYXNAE0PHN468wLUI+8P0Nu
	 J+RoNEJxbyDEtzqV7+eSNTM7nxZWfBhcjBLjwp/P6J0MG5wTR3fYANb01WDkCK64gu
	 wP08OK56rWweNPXRg9P9/DPb/0aBz8I03sPRaCrGvANEdQAKqBLK0V0R5YTX1PR1Zg
	 ESDCHwUzrbfRCOZZxGa2UoMh9wBkuwmBcqRsz//hvzjhlWK46apuTjYK65Mzj64oOw
	 Y+7N++EWOKrLuja4XeevS5mwBnwnV/F9E74SaTbZHoXXxITrS1ubEWtRyIOgjJnJ3B
	 JODOEic3Swr3g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	ast@fiberby.net
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Subject: FAILED: Patch "io_uring/cmd_net: fix too strict requirement on ioctl" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:29:02 -0500
Message-ID: <20260301012914.1686902-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12490-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 0E3661CB2E6
X-Rspamd-Action: no action

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 600b665b903733bd60334e86031b157cc823ee55 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>
Date: Mon, 16 Feb 2026 10:27:18 +0000
Subject: [PATCH] io_uring/cmd_net: fix too strict requirement on ioctl
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cmd_net.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index cb2775936fb84..57ddaf8746117 100644
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
-- 
2.51.0





