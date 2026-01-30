Return-Path: <io-uring+bounces-12001-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CIAcASP9fGnLPgIAu9opvQ
	(envelope-from <io-uring+bounces-12001-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 19:49:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC3C8BDF7F
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 19:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 52215305043D
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 18:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0AF33876DC;
	Fri, 30 Jan 2026 18:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="dFgkOSl4"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621B4387580;
	Fri, 30 Jan 2026 18:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769798830; cv=none; b=E7oAFPqMyEoougY1QgveAnh5H7V+FNkH+USjgYr5+3gg41PYKy8LAzE024WMmUfVAsE+BjNR99bUyLLij5TuqCVYKxWyadQs2+KmWcajc4jnMXPg2OzuBeiaE/8kLOChTlUpWwk2RK5qqAVVlqsenxS16AKy8HjXDEa0z/okIp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769798830; c=relaxed/simple;
	bh=VoX4apeR1/fBQJ1bijPUH/ri8Yl1RQPOugsV/RS525k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aKsF5bB5CNA7S6UhurpYgl5TzPQc1bmnAmN63hmYZN1T/PJlMOdk2jbzXijb7bUMwxwFr3BPvtZ3qdEC4Nr8U+1vKKnzlN2msrNRUZpUlIbecq2rwVF7/MVymLEEZk02+VMwHqqYm6hAGr/h+CcMMBxBaYS6f+BterZWbMSgtCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=dFgkOSl4; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=usq+Fh3qedDoR7rCGaWM06IbYW1Zl0rkP+xHJTmMv28=; b=dFgkOSl4Qbfsl2E9XM2D1lnR63
	kxyMynPGNO05wAVCfygTskPk8fJ6FpUmWasx86xOsfsBddCOVScweeuwQIJpTwYiNv4A93msblr73
	UN0jCC9eno5x0M5sgiairOipvwHSUVw//SV8sQ3xBMSAb1K9P+0EmHJ/m+oJfGXatutGiY/3DllIR
	1OwCegUB5yULdeMME3V/HiXpFN/30i6b5FDLMnT0jP+n+aUFcUkTS8MCHmB4tA3RyUPVjf818ddEU
	M1G4f/wHdMppGeyLXD/qCFsTQfOGsdhekqTw8mIZKmQP5liGtE2UU0o2k2qJP5bXTEiXmy9sK3INy
	ZwH+WjCw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vltWF-001urd-Ct; Fri, 30 Jan 2026 18:46:59 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 30 Jan 2026 10:46:18 -0800
Subject: [PATCH net-next RFC 2/3] net: prefer getsockopt_iter in
 do_sock_getsockopt
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260130-getsockopt-v1-2-9154fcff6f95@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2836; i=leitao@debian.org;
 h=from:subject:message-id; bh=VoX4apeR1/fBQJ1bijPUH/ri8Yl1RQPOugsV/RS525k=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpfPyUWb2C31GfLNnJFiMkIKi+ss+7naggtKlpw
 937uzCL7wyJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXz8lAAKCRA1o5Of/Hh3
 bfK/D/9nRWHA4mKgr+GxKyziMLTfw1bkKVxBk8n58v9M4DS9704rAebJJHOetoYEpxhVYuxijj3
 f/2yOSk3xNSP/707kGrhNQfK8vxXIIgTXPA3Sh8WlBiUtC9xrqN0MxnLCxxEXgRUAJ/B+IIgaNk
 WPd+qoiYW9cdz2GJMOW5icyQwiLwgCjNEhZKr1I0yprdQmnX635doU51jmh0Yv1A6tDlrZWX74A
 D4WstkhTqPRjSptr+TGQCI5HsjKgXwAz+MfNOttb1lsliUhykTodRTXWfvm+IOQIhwwOd2nwUPr
 zIltosNZ2CCE+gjqZ9KJngBdF1N2chVCwPo5qYfq09HH0frfqHd/iPFUw48w7DnXqXsnVrDEpvn
 Iy4pTk9vc2+QcYIgje4Adpg0D1uZX70HgnQruCVQDjFxdKzhmuPdANmZNT/QNp8T6Uu7NFlgL03
 R0WFmz6IqgAh0v8crUyLvx+EMf+pQob/jJ6WUrjSPJDPqgYIUv5qoEU61F2/axkRG2hUmP8LWHM
 Hp6iNFgIysXNPbaS9lue25L/XqhYCL86zBKJhnIkApBHWFeRG4BszTG35gha7u5R0+6J6pMlVx3
 2sJZH4pGR94Kixy5g+Ndu/3juVFbKUCbG/JX4XFofYe1Fp7Amikj7N/Gr3QT24O3hTRxMlf1mUZ
 XCnMI9jZTyAaLeQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
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
	TAGGED_FROM(0.00)[bounces-12001-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AC3C8BDF7F
X-Rspamd-Action: no action

Update do_sock_getsockopt() to use the new getsockopt_iter callback
when available. Add do_sock_getsockopt_iter() helper that:

1. Reads optlen from user/kernel space
2. Initializes a sockopt_t with the appropriate iov_iter (kvec for
   kernel, ubuf for user buffers) and sets opt.optlen
3. Calls the protocol's getsockopt_iter callback
4. Writes opt.optlen back to user/kernel space

The callback is responsible for setting opt.optlen to indicate the
returned data size.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/socket.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 136b98c54fb37..2d830262b1be5 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -77,6 +77,7 @@
 #include <linux/mount.h>
 #include <linux/pseudo_fs.h>
 #include <linux/security.h>
+#include <linux/uio.h>
 #include <linux/syscalls.h>
 #include <linux/compat.h>
 #include <linux/kmod.h>
@@ -2356,6 +2357,38 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
 INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 							 int optname));
 
+static int do_sock_getsockopt_iter(struct socket *sock,
+				   const struct proto_ops *ops, int level,
+				   int optname, sockptr_t optval,
+				   sockptr_t optlen)
+{
+	struct kvec kvec;
+	sockopt_t opt;
+	int koptlen;
+	int err;
+
+	if (copy_from_sockptr(&koptlen, optlen, sizeof(int)))
+		return -EFAULT;
+
+	if (optval.is_kernel) {
+		kvec.iov_base = optval.kernel;
+		kvec.iov_len = koptlen;
+		iov_iter_kvec(&opt.iter, ITER_DEST, &kvec, 1, koptlen);
+	} else {
+		iov_iter_ubuf(&opt.iter, ITER_DEST, optval.user, koptlen);
+	}
+	opt.optlen = koptlen;
+
+	err = ops->getsockopt_iter(sock, level, optname, &opt);
+	if (err)
+		return err;
+
+	if (copy_to_sockptr(optlen, &opt.optlen, sizeof(int)))
+		return -EFAULT;
+
+	return 0;
+}
+
 int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 		       int optname, sockptr_t optval, sockptr_t optlen)
 {
@@ -2373,15 +2406,18 @@ int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 	ops = READ_ONCE(sock->ops);
 	if (level == SOL_SOCKET) {
 		err = sk_getsockopt(sock->sk, level, optname, optval, optlen);
-	} else if (unlikely(!ops->getsockopt)) {
-		err = -EOPNOTSUPP;
-	} else {
+	} else if (ops->getsockopt_iter) {
+		err = do_sock_getsockopt_iter(sock, ops, level, optname,
+					      optval, optlen);
+	} else if (ops->getsockopt) {
 		if (WARN_ONCE(optval.is_kernel || optlen.is_kernel,
 			      "Invalid argument type"))
 			return -EOPNOTSUPP;
 
 		err = ops->getsockopt(sock, level, optname, optval.user,
 				      optlen.user);
+	} else {
+		err = -EOPNOTSUPP;
 	}
 
 	if (!compat)

-- 
2.47.3


