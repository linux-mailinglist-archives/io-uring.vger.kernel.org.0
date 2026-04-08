Return-Path: <io-uring+bounces-12983-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cMEpLDIv1mlZBwgAu9opvQ
	(envelope-from <io-uring+bounces-12983-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 12:34:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 68DFF3BA998
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 12:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E6A4C3073C30
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 10:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E973AF651;
	Wed,  8 Apr 2026 10:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="C+cMLpeH"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF03C3803DB;
	Wed,  8 Apr 2026 10:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775644264; cv=none; b=ru+mvb0Pnk05qHtIBQ7xYn3aw5hoikZctMZhfRMYYFvHeVXjOdJe9a31y5yygKFF1bLkAMicHC6E0NvkdWdnKCsoVWR7m1u0ECpFfFtdIWgjSnOhD2ceg+W+u9bb+WPf/h/ovMG36eHaOkuIkU1umdErAb7kaGG+kPhGGm//sJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775644264; c=relaxed/simple;
	bh=bAnwf474ats9C/F39HbYDhQ2a4jRPfMKlAC7YLXpf48=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=H3ZD6B79R/e4vcNzhp91JGWDhfwtSMID9NT5ISa+B18HAqOfqAlMy2xKAKGJMU65aphs7AfDOjonmIGMQmG4KOkIaUsZ5Hr5JSEzAr5vcT8/dMbMnxmGVSwGIGE03Z8q4Mh+XI4b/kTXTaRw4w0pF7jm2nJDVwuDJre3DpZvens=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=C+cMLpeH; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=sDEaI6Lvz2cvHsuIvdFPvtDt+pIQQFQmB6yzCWILEKA=; b=C+cMLpeHCPy4SaXJVMG8YGOQUu
	P0DhuDnUMwQfDZ3sJnurAbPsn6+q/y4yGm880dL2jvaEyPHnzHFZ4lBWUAyX7ztrhsnlsjNyOPWC9
	anGH1Zl7YuilENzpCTuWPG5T7CGrWx8bbbKBYye6AnvT/hnT/ENkXwG7/6H/+pkOQeucYc4K3FKlw
	TDDtoljEpJb3vflEoMpLstHUxvVPLjM/kWrNRGNt8/eEAxQe2lesXapNay8c5RMR1lIk55nB561Hb
	vT/EmvSrD8giJPPSEBTggKP3QjrPxcIMj67z+xWXl3Av/g2nJlHy8uJyJsibVlyv498JJnAnetZsu
	9bqWK0aQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAQBV-008MEF-1y;
	Wed, 08 Apr 2026 10:30:57 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 08 Apr 2026 03:30:31 -0700
Subject: [PATCH net-next v3 3/4] af_packet: convert to getsockopt_iter
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260408-getsockopt-v3-3-061bb9cb355d@debian.org>
References: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
In-Reply-To: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2610; i=leitao@debian.org;
 h=from:subject:message-id; bh=bAnwf474ats9C/F39HbYDhQ2a4jRPfMKlAC7YLXpf48=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp1i5N/OYD+4vKRcZXdFyIXfM++jE47P6zmYLkU
 CnNZ8f1jeiJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadYuTQAKCRA1o5Of/Hh3
 bccuD/wLiCk4QokKOoiqYW6cXyWar1nKhJh/kX3OVg8uz3cYNKNJDPXBmXcw+D+LQdWce2BQ2uf
 lYZ0PKEoyLK0c2M7Y/93z7lFPo2dDcZP8rGVkF2Ungwt6jRDIGgfS2b6Tw83+i8WOwOawkzKM8A
 buA9DWAskLI1M59IaXZp7LB1DSVHLD5vJ2BasoWpgyv7JghpF2HDkHxJYCiSI0ntoBN+YAIZaoU
 bq/u6LMbrb9rMPRgsPrf/yHlD5F2AVDs8UZz9r1cPH1IL4GvuY0yTqqjgQAQtyE1NYayxg3KC6F
 IUC8iaZqGkMqW0VJpdAg7VWNaQKj1vIgArrCqGFk1VAMIGA7UhQo3Y3lni2Ou94/YzmfuBgZVW4
 85tj+SRc2TAB88WAeq+T+UF31YGHVLMvMzi/wE3+Sbo0LuNlWX1nOrhW13eRB0hSUJW9y++bZDk
 3zgdIeJ27x+01lFTFzJ3Hlu4mRt/NKjAQqBcn+kfzxT1SCFrq8MCSyTGDQAsNh5EnDpR88x7cx4
 wfk59AY4hFtsNAaJ0eHpm4xnZK0zJ1/nzFwEn+d1aj9RScWEvgbPWUosEYPKZssF4/7t9w+x+Qz
 0RKgVA+fIdXGClcRKtcCV+fTF9VvO8QQ9f8brfTwq6JAAZntQYHTg+n/e9XOx0CQ4Qe8ea6FSK/
 ehL1wzYBWpFqD2Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
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
	TAGGED_FROM(0.00)[bounces-12983-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 68DFF3BA998
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Convert AF_PACKET's getsockopt implementation to use the new
getsockopt_iter callback with sockopt_t.

Key changes:
- Replace (char __user *optval, int __user *optlen) with sockopt_t *opt
- Use opt->optlen for buffer length (input) and returned size (output)
- Use copy_to_iter() instead of put_user()/copy_to_user()
- For PACKET_HDRLEN which reads from optval: use opt->iter_in with
  copy_from_iter() for the input read, then the common opt->iter_out
  copy_to_iter() epilogue handles the output

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/packet/af_packet.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index bb2d88205e5a6..1da78b6ad3d5f 100644
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
@@ -4115,7 +4115,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 			len = sizeof(int);
 		if (len < sizeof(int))
 			return -EINVAL;
-		if (copy_from_user(&val, optval, len))
+		if (copy_from_iter(&val, len, &opt->iter_in) != len)
 			return -EFAULT;
 		switch (val) {
 		case TPACKET_V1:
@@ -4171,9 +4171,8 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 
 	if (len > lv)
 		len = lv;
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, data, len))
+	opt->optlen = len;
+	if (copy_to_iter(data, len, &opt->iter_out) != len)
 		return -EFAULT;
 	return 0;
 }
@@ -4672,7 +4671,7 @@ static const struct proto_ops packet_ops = {
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


