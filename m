Return-Path: <io-uring+bounces-12486-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IO17MOxOo2nW/AQAu9opvQ
	(envelope-from <io-uring+bounces-12486-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 28 Feb 2026 21:24:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AB371C84FA
	for <lists+io-uring@lfdr.de>; Sat, 28 Feb 2026 21:24:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA1CE34CE4B3
	for <lists+io-uring@lfdr.de>; Sat, 28 Feb 2026 19:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55E5347FFB;
	Sat, 28 Feb 2026 18:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b="mZcgwfP9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail1.fiberby.net (mail1.fiberby.net [193.104.135.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F05D35AC02;
	Sat, 28 Feb 2026 18:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.104.135.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302696; cv=none; b=iE0IVEkTFmcIn8IQGWIulcshqB4iJgtvNIc5mG/FI5LBADyjMRzXLfJ0uaMpsKGVjop7P6MdRpHqhwktX0cP49hrukYouKLDUjWm+E8PPWGTCA5l/VLHPWcDZvWCRH8b+FkgylTHM0+H1/l9bcaEbRmS1KBNMzG5DFFPJuNu6bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302696; c=relaxed/simple;
	bh=Myv1uT6pgCKChE0Cthw3fmvc8MAoOj0B17opGgEWW1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZV3phi8N1jFlV3/AmVnCqRbMMfsZBQNmGXb3QNNCnI9MK0revTub45BVDvl0l7IEYPM9qYZ2e06wRG2BIRYLEasG/MS7Bog7JndNZ2MK6+QJ26yQtdEap4Wec94GPUQEqlcHVj/DZkVlXnDPo8cRjKgYt0GLMRGBj3Z+3YFGV+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net; spf=pass smtp.mailfrom=fiberby.net; dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b=mZcgwfP9; arc=none smtp.client-ip=193.104.135.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fiberby.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fiberby.net;
	s=202008; t=1772302218;
	bh=Myv1uT6pgCKChE0Cthw3fmvc8MAoOj0B17opGgEWW1Q=;
	h=From:To:Cc:Subject:Date:From;
	b=mZcgwfP9adD+pi0NUfxneqVnEoz1sYa6FR5axyr6kaHCioKpy0A5DC/jNZhyRJLuB
	 ulhvutcv9ZFsfFBhb9fCvG+WayRvkBaGmfgjTWXpda3vKmhDxD7/OAmLA+RaHkuTn9
	 VuMwNfbsRkO9wfhBJGuFoI4NorGpeq6YP5ev1c3zZwYqGIQycLkT4lVV6ODtib0nF0
	 DCLYQzSQ150pBxuqQxoEfzLxZvPvVumf0I6PXrazXlMBBrK1uNWYMhoVV74Li2LHrc
	 UOqf+HMSODUW25RrqzO6PY1UgXlZ+SdHF2hImGe2BYbafZlkef7ATeKhyAE+F/3NEg
	 UYoY5WfqKsHCw==
Received: from x201s (193-104-135-243.ip4.fiberby.net [193.104.135.243])
	by mail1.fiberby.net (Postfix) with ESMTPSA id F2609600BF;
	Sat, 28 Feb 2026 18:10:17 +0000 (UTC)
Received: by x201s (Postfix, from userid 1000)
	id 7C80C201903; Sat, 28 Feb 2026 18:09:54 +0000 (UTC)
From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>
To: stable@vger.kernel.org
Cc: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 6.12.y] io_uring/uring_cmd: fix too strict requirement on ioctl
Date: Sat, 28 Feb 2026 18:08:53 +0000
Message-ID: <20260228180858.66938-1-ast@fiberby.net>
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
X-Spamd-Result: default: False [-0.49 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MIXED_CHARSET(0.67)[subject];
	DMARC_POLICY_ALLOW(-0.50)[fiberby.net,reject];
	R_DKIM_ALLOW(-0.20)[fiberby.net:s=202008];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12486-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[fiberby.net:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[ast@fiberby.net,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,fiberby.net:mid,fiberby.net:dkim,fiberby.net:email,kernel.dk:email]
X-Rspamd-Queue-Id: 3AB371C84FA
X-Rspamd-Action: no action

[ Upstream commit 600b665b903733bd60334e86031b157cc823ee55 ]

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
[Asbjørn: function moved in commit 91db6edc573b; updated subject prefix]
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
---
 io_uring/uring_cmd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index f927844c8ada7..e5d0cc8a8a562 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -338,16 +338,19 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
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

base-commit: 444b39ef6108313e8452010b22aaba588e8fb92b
-- 
2.51.0


