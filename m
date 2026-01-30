Return-Path: <io-uring+bounces-12000-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMf4OAj9fGnLPgIAu9opvQ
	(envelope-from <io-uring+bounces-12000-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 19:48:40 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A507BDF62
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 19:48:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7EFC0303C83C
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 18:47:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC4138757A;
	Fri, 30 Jan 2026 18:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="aRHmPsMW"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CCB387378;
	Fri, 30 Jan 2026 18:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769798830; cv=none; b=FQliOOZo1GmR5g0zPYCpgLGl7G5GYOVf+snCCiVPPtmQB8NOTq8QVCwsJSuP1B+Lvja6tyrL8f5hD056Xuv/n4Y6xLnErlG372fucQobpOQkv6naNoCpSvwOLct1dXwZNX3379xZ/VNgWzEaE3ZzBGzgxmIJrq32AsSLVZpPAcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769798830; c=relaxed/simple;
	bh=IVnLhnrcy/3xPEQctLWhlsnsImXX6rsH2GP1mnkmDNQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ninl4gqEi+mhuXkI2SVPYjQm8YdlvBaPxO6fTdO2uCl59RQcc5oI8X0S6jLwwtFuYeJNSPC0lPtPsag3YeAH9MudQZQrZuwZH4LkKvlNQR8oqeOoNqkkCdL19pbQxiEmIhH566jsoUh8ktkqtv5yKb8zW7Zb4XrHcWfgb0owjUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=aRHmPsMW; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=gW70Iuxcr93CtMyUc93o0K6n2EmDcL/0tFhB6bt/uXk=; b=aRHmPsMWedGIXc2X0YSNAMvFAT
	gpBxbCe23doJ2GkVOjXk5qAtYdxfG7QHsv/GZFeGglF5MVb8oi8ie8ecBvqK6OwwGvp3Mrufj4R9f
	gwTIgyr9An7iroBpuFdP4pCvSv54rbsHMadaNcOX2Oks/h19TTOICxX6Iv3LinlyE9QvOv+tbGx/L
	wTcT5umDxfJ4bBZWN9TxcctGh0UQpm3mRZ4XmF3h5po3lGR7yRCUFQw2uBAZRzDswWic5we1XzcwF
	/SAvFr1DLgt6bXlrFp4P21KqJpRkog5J4b+9kw2+DpFOJNuHjlhk466pmK9RtnC8VpIwnGyBr2P/L
	ry9AY69w==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vltWK-001urn-5X; Fri, 30 Jan 2026 18:47:04 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 30 Jan 2026 10:46:19 -0800
Subject: [PATCH net-next RFC 3/3] netlink: convert to getsockopt_iter
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260130-getsockopt-v1-3-9154fcff6f95@debian.org>
References: <20260130-getsockopt-v1-0-9154fcff6f95@debian.org>
In-Reply-To: <20260130-getsockopt-v1-0-9154fcff6f95@debian.org>
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
X-Mailer: b4 0.15-dev-f4305
X-Developer-Signature: v=1; a=openpgp-sha256; l=3397; i=leitao@debian.org;
 h=from:subject:message-id; bh=IVnLhnrcy/3xPEQctLWhlsnsImXX6rsH2GP1mnkmDNQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpfPyU2OZHI4M0lCr3semqght57TV1hos0Fo3WE
 c1nHQfKtcOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXz8lAAKCRA1o5Of/Hh3
 bQ4lEACRll/JUEMJtdVPtrX+RF5bS7TQWHv7YtDd+8lAJdwtts5jliTofGG4ukbpoQbE4pRKcmL
 N/9T9SNairfNx6pRssn8tdoyNfc2TICWLatqB057ecdFQqlbWWefHLy4Jycya/yZUIQap+S3roY
 vR0L2UggKugpnVKUZ9+dAA4uYhYkCfVlS/SY4VU4Bk2NHNDCJvllMiGXsi71Bv2Pq7MirYfw/uv
 xiblpCNa5UEKDsIbIKV/sobPtejFcU50xdAtoxDBv2shqH6xsO0i3NxzhNBDxuJ6+ufHizF0M1Q
 zrbl+57gijjx5LAREzuKi2WQAPF7uDsNb2Tvsalu+PAD8JRZ7YznHF1L1PzPbqnoWs3OPIcjGt+
 xNcJyKiVgsbt5Pv6S1jqDc6xAL5LWxhgAhzAvPTX/SELvDNREw+K+cpSI+z9fSWKPCXonVFoFTJ
 jGCQ6XOInJel7qW1TpyKx5prRb9mVwyWxC/RV4pjjA2qR4jWSGQ8BdRysIMGBBc1ag7w0abTwFD
 K7scjnQ7i3JMdCkzk4VNJROLa+khmlxqU6rF+iJEVB+Qe7gGJWU52UiApPVoc9+pHLnOLR/ZPYF
 Tpx8H3BUSXqEYGONXfRZKraJkRpzAK9GIMCiXVrgUzXLcH4KihTVihsECbhYcLvmEH0sGkpQknh
 pios0YQFtQXxG+Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
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
	TAGGED_FROM(0.00)[bounces-12000-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5A507BDF62
X-Rspamd-Action: no action

Convert netlink's getsockopt implementation to use the new
getsockopt_iter callback with sockopt_t.

Key changes:
- Replace (char __user *optval, int __user *optlen) with sockopt_t *opt
- Use opt->optlen for buffer length (input) and returned size (output)
- Use copy_to_iter() instead of put_user()/copy_to_user()

The optlen field allows callbacks to return a specific length value
independent of the bytes written via copy_to_iter().

This enables io_uring to call netlink's getsockopt with kernel buffers.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/netlink/af_netlink.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 8e5151f0c6e46..8a195eb1ef761 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -39,6 +39,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
@@ -1716,7 +1717,7 @@ static int netlink_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int netlink_getsockopt(struct socket *sock, int level, int optname,
-			      char __user *optval, int __user *optlen)
+			      sockopt_t *opt)
 {
 	struct sock *sk = sock->sk;
 	struct netlink_sock *nlk = nlk_sk(sk);
@@ -1726,8 +1727,7 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_NETLINK)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
-		return -EFAULT;
+	len = opt->optlen;
 	if (len < 0)
 		return -EINVAL;
 
@@ -1743,6 +1743,8 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 		break;
 	case NETLINK_LIST_MEMBERSHIPS: {
 		int pos, idx, shift, err = 0;
+		u32 group_val;
+		size_t size;
 
 		netlink_lock_table();
 		for (pos = 0; pos * 8 < nlk->ngroups; pos += sizeof(u32)) {
@@ -1751,14 +1753,14 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 
 			idx = pos / sizeof(unsigned long);
 			shift = (pos % sizeof(unsigned long)) * 8;
-			if (put_user((u32)(nlk->groups[idx] >> shift),
-				     (u32 __user *)(optval + pos))) {
+			group_val = (u32)(nlk->groups[idx] >> shift);
+			size = copy_to_iter(&group_val, sizeof(group_val), &opt->iter);
+			if (size != sizeof(group_val)) {
 				err = -EFAULT;
 				break;
 			}
 		}
-		if (put_user(ALIGN(BITS_TO_BYTES(nlk->ngroups), sizeof(u32)), optlen))
-			err = -EFAULT;
+		opt->optlen = ALIGN(BITS_TO_BYTES(nlk->ngroups), sizeof(u32));
 		netlink_unlock_table();
 		return err;
 	}
@@ -1784,10 +1786,10 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
 	len = sizeof(int);
 	val = test_bit(flag, &nlk->flags);
 
-	if (put_user(len, optlen) ||
-	    copy_to_user(optval, &val, len))
+	if (copy_to_iter(&val, len, &opt->iter) != len)
 		return -EFAULT;
 
+	opt->optlen = sizeof(int);
 	return 0;
 }
 
@@ -2813,7 +2815,7 @@ static const struct proto_ops netlink_ops = {
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
 	.setsockopt =	netlink_setsockopt,
-	.getsockopt =	netlink_getsockopt,
+	.getsockopt_iter =	netlink_getsockopt,
 	.sendmsg =	netlink_sendmsg,
 	.recvmsg =	netlink_recvmsg,
 	.mmap =		sock_no_mmap,

-- 
2.47.3


