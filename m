Return-Path: <io-uring+bounces-12921-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAqUBeE+zWkkbAYAu9opvQ
	(envelope-from <io-uring+bounces-12921-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 17:50:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6EF37D791
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 17:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B96143008C05
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 15:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB6A14611FC;
	Wed,  1 Apr 2026 15:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="DYtHK2oX"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940393D3302;
	Wed,  1 Apr 2026 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775058310; cv=none; b=eMTNm+7rpNVzfI5IYSESBtyNpqJhEwxYRh/yyavke6g7XqlKmcC4rbvDpA2a5qEy9ay4JV0r9a3a2Kqn5OqutwcgKX0HR/Qa5PPsGWcaDWmPXmZT2rBwbpz1GLvFfXLA3f/N22XIzHIQYfLZwISpq1EcHuc3LD0traM19l8L1r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775058310; c=relaxed/simple;
	bh=X/AoYJqdE+MtYH0JlUBWh2qPaaEB6+cAWV8EcTSYaeQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=smazrPKLy9I7QDBXvH+W23Bzik4Omt0zBmQRBs123lNOhkDu61QN2Mxpw7sRwBCto9c2hGgIoVQ2bQ/Rlxp+3xMR/FBY7xAIyHrCH4VIMyuDQCIJ9dZRGVp4QeWkvDqgrpIKeB+G92r4el5zM8F2KyhQQTctnDlUshmn2rzzbq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=DYtHK2oX; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=P59MOqsT5WVRRPdQNx+zFHzBHzuH6NeFfyok3UXQEyM=; b=DYtHK2oXweuFw5ku0FkahLT29j
	eXzuZa8En7la/tJ5MnJkobcBdRFFbst4eg32FA8Ikq+cCezEi1yJX4cfvv6LCk1ANvqOhiDIzpjK+
	CUFOyxomQrEIySpVc6o+70LPVrigz5FwC9fXJ9VArjdsSJEYKgnibMaBmJzQFZapnh2ShLNd4JJFG
	+Mr2z0aUTl6v1PJ+Bcux42gZgVbZOLAXk2Ftp6waVWZ181PLNc15cIzLb2LkxuNqUPlkc/ovVe8VS
	zOVcp9nhrSq3y7QVPMZLqPbUnBPRV7MiT4iXE1bcpecnC1c1M/C4IM3c8raLQEjtIDeroXe+8I4td
	cDjz2tvQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7xkf-0035cd-2A;
	Wed, 01 Apr 2026 15:45:04 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 01 Apr 2026 08:44:28 -0700
Subject: [PATCH net-next v2 3/4] af_packet: convert to getsockopt_iter
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-getsockopt-v2-3-611df6771aff@debian.org>
References: <20260401-getsockopt-v2-0-611df6771aff@debian.org>
In-Reply-To: <20260401-getsockopt-v2-0-611df6771aff@debian.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Kuniyuki Iwashima <kuniyu@google.com>, 
 Willem de Bruijn <willemb@google.com>, metze@samba.org, axboe@kernel.dk, 
 Stanislav Fomichev <sdf@fomichev.me>
Cc: io-uring@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org, 
 Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=2766; i=leitao@debian.org;
 h=from:subject:message-id; bh=X/AoYJqdE+MtYH0JlUBWh2qPaaEB6+cAWV8EcTSYaeQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpzT1tMJaqtl0UeFruHzpKtaTppA+65BLRhFbsq
 zqkPYiLzgOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCac09bQAKCRA1o5Of/Hh3
 bV+UD/0S/gVC0JUVzIsyE5TdV2qheg+HnQF5EknwrMGroj4e3NQcxmPptGmU5F/7MbQXAZ1EF6b
 a+RIv7eB/9ZQpq4cEFOMaEto6EQQs2lnhhJAo6NM4hTIVAVJpdAF4xTBFV87yrqwt0pMWRa+dF6
 i4c+ABe/0D8GwaRadjOOtjQsxJ8gn+HuUpMSJga7iHr4ypj/5XQwuMNX3CQ4kE9lBEGYFsKitk8
 5aO43h1/TpnAl9Y3UmGDtJvIzJF323Jl9LlQlGf0wQlQSYYfJiYD9Io/UGpH1WOe0feBXJUItZ6
 0CoWvXuQGKJ/7rK/YEI9OiFEBNHTnIXMXjXD9495bKZpAQ6/DtO2UqIZOBP9KKbwYY5y3KfR0ed
 KILpo6l7v5ZqIvsM5d8vLoUB2a5gCXtkhCa48Tr3uur1oaATtWnHGlzeCwk6xriKs/PDjpmv8BR
 Vg8PQtujigwNVZ+IQBHYSvxT5fxPHPcquxnmQjYXGUfX0lejdp10MbUUmZUcyG8ZIfAGdnDL1E3
 4pJmdahkNtcql4BQKZ3v6rHr62JH31Okc7de00TvFfGpeItMfYwpHFd25+67OSz80cuHw0Ab+0a
 yfTUXPgJBLoHvvefQa7eqVwlkOhwmSNgVWkUfBsFDWmzEvHvkvpvcyC+U60V9qyNA2p4Fn+rZO5
 lH5CRkLd2jjsauA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[debian.org];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12921-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AF6EF37D791
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Convert AF_PACKET's getsockopt implementation to use the new
getsockopt_iter callback with sockopt_t.

Key changes:
- Replace (char __user *optval, int __user *optlen) with sockopt_t *opt
- Use opt->optlen for buffer length (input) and returned size (output)
- Use copy_to_iter() instead of put_user()/copy_to_user()
- For PACKET_HDRLEN which reads from optval: flip data_source to
  ITER_SOURCE, copy_from_iter(), iov_iter_revert(), then restore
  ITER_DEST before the common copy_to_iter() epilogue

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/packet/af_packet.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index bb2d88205e5a..531bcee02899 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -49,6 +49,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/ethtool.h>
+#include <linux/uio.h>
 #include <linux/filter.h>
 #include <linux/types.h>
 #include <linux/mm.h>
@@ -4051,7 +4052,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 }
 
 static int packet_getsockopt(struct socket *sock, int level, int optname,
-			     char __user *optval, int __user *optlen)
+			     sockopt_t *opt)
 {
 	int len;
 	int val, lv = sizeof(val);
@@ -4065,8 +4066,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_PACKET)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
-		return -EFAULT;
+	len = opt->optlen;
 
 	if (len < 0)
 		return -EINVAL;
@@ -4115,8 +4115,11 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 			len = sizeof(int);
 		if (len < sizeof(int))
 			return -EINVAL;
-		if (copy_from_user(&val, optval, len))
+		opt->iter.data_source = ITER_SOURCE;
+		if (copy_from_iter(&val, len, &opt->iter) != len)
 			return -EFAULT;
+		iov_iter_revert(&opt->iter, len);
+		opt->iter.data_source = ITER_DEST;
 		switch (val) {
 		case TPACKET_V1:
 			val = sizeof(struct tpacket_hdr);
@@ -4171,9 +4174,8 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 
 	if (len > lv)
 		len = lv;
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, data, len))
+	opt->optlen = len;
+	if (copy_to_iter(data, len, &opt->iter) != len)
 		return -EFAULT;
 	return 0;
 }
@@ -4672,7 +4674,7 @@ static const struct proto_ops packet_ops = {
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
 	.setsockopt =	packet_setsockopt,
-	.getsockopt =	packet_getsockopt,
+	.getsockopt_iter =	packet_getsockopt,
 	.sendmsg =	packet_sendmsg,
 	.recvmsg =	packet_recvmsg,
 	.mmap =		packet_mmap,

-- 
2.52.0


