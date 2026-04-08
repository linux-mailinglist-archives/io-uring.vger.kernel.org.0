Return-Path: <io-uring+bounces-12985-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Mc0F58u1mkUBggAu9opvQ
	(envelope-from <io-uring+bounces-12985-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 12:31:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1D33BA8F4
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 12:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 334393011694
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 10:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0F33AE1AC;
	Wed,  8 Apr 2026 10:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="HBw0OcFy"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FD137B41E;
	Wed,  8 Apr 2026 10:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775644266; cv=none; b=i6nzqUmj83vSvdE7V+6Rx2osY5JamrI9qiHzKYtGL4Z18QCbh3CPeWxyMxXJcJGGk3nEEuc/I0MAuwy+vu/AgccU6xN5NSAbGFI8Ey1HjnoYwX4J9Xw4VFSWbxRxCZXRBUC/dFPdHn6k5O/sfpi4G1JxS/Gyj2h6ayBy08LPSDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775644266; c=relaxed/simple;
	bh=pOesKuhudD+8zt+CMHqClMhFbjEUPseOmhGjEs6pHgA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PDSrYoRSqnIYqwJFJlT4RvruCxmN1l3G3z6iBUNVKiy+hgLpE+tc26QPveyEEC43wJGxukgoGMugQyD/tW3h2ypY8lbwMR4sY8s3ZLtX1eGn3o8/KUwUaPpH/MBRktIrx2OSoFUb/Yw/qgz++/+8ncYzaegy3KCKX3Hq5xQ+NHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=HBw0OcFy; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=j3sXh234yYQ0MK964QNxt3wLmUNhN01YHWe58GIc47Q=; b=HBw0OcFyK3w38tJfgCBbhV/RnJ
	2krVQYopG2iUZxJasZBE/Oy1P2bc2pq1RVhC3NkI4Qjo41BIMU9bQyLGHhw1vmwKbsYhWpn/hjF6F
	y6W6K6kW2p2JqlMsn2HwN8igzEVShqgBAdVNkgFxnTYh0Wjm9PdUXihvxUBQsyMdoKqyJm0Ey90vq
	+oeaiqKCPE5aXopag4E/KyB50MJbkNl9VVxVhXKZcTL6F35E48eBJ/z1dl9z5j2NX8t0xWv9+dIhu
	KhpZoP0lSAxB9kn63EnIg6m8hz5XOiUywWUa81znIVP7DhEjgnFluC8YZ33+nqhC4FZC2slciV+eg
	3uTjf2Gw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAQBR-008ME4-08;
	Wed, 08 Apr 2026 10:30:53 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 08 Apr 2026 03:30:30 -0700
Subject: [PATCH net-next v3 2/4] net: call getsockopt_iter if available
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260408-getsockopt-v3-2-061bb9cb355d@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4599; i=leitao@debian.org;
 h=from:subject:message-id; bh=pOesKuhudD+8zt+CMHqClMhFbjEUPseOmhGjEs6pHgA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp1i5N/XtgR1BS+9k8hmc7RUdjCimv1CtkLELse
 /WYkEfGTSSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadYuTQAKCRA1o5Of/Hh3
 bWDHD/4vlrMvc/oNjL5ysHzc/csEMzRjhtG1l+EOFABmIl07keWEhShr9wJsy/WZRqc3wrj44Yk
 38biaVCH5H9U2hPc90nvi++9DmGjn9GK+KTVNxbrQ9wUWgZSv6K53zU/hVETjAQxtReWpMZbNrQ
 AuiuQEr9i7GnRBSt677xIj62uU/sUP9Z396AIvL7n4oDklkhNbxnB0lv+J1AAuHiBjgrfoImkvy
 kIWAZyu7PGH6CU4fb0rzLKH+7Sryd1BHte07qE1fyLqxj0lszVb+ovfzUt6pJNUw6tfAoggp/Yg
 n9R/691XFOUrUW6boaEzEayUGckwGwRomVo9eE2qT0DyJMkJH32JTvxXemeQkPG8kL2jW6HIpEE
 +Dg9512nFz7ih0tmM2IJCxEo9hGGCOatvIuPMHZ7udT9sQknnjVO+UaBK8U4D9OAoaPKFynj81e
 Tuf4IH6P5tKtQRAoEEDjJpykaYiyiunKVwPhD3EpYN6aarpGf/Xsg7a/0v2jTVDoxS7Jv6aDV4K
 nFpT4wpN1Gnv4JvwfN5qGDsItejRc29p5Ox6WnpUWJkcHo0d8+IkJQk8RZ89mg7G9PichhHsx6n
 b4q/vlIiu+OhITeq9v4iqEI1WzNN/vKGaRbGUAZYIUGJ9vJX47HcIkEgKIFjQDk/3wW5V10+SCu
 5N2jGCaWY3mV0lQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
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
	TAGGED_FROM(0.00)[bounces-12985-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9A1D33BA8F4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Update do_sock_getsockopt() to use the new getsockopt_iter callback
when available. Add do_sock_getsockopt_iter() helper that:

1. Reads optlen from user/kernel space
2. Initializes a sockopt_t with the appropriate iov_iter (kvec for
   kernel, ubuf for user buffers) and sets opt.optlen
3. Calls the protocol's getsockopt_iter callback
4. Writes opt.optlen back to user/kernel space

The optlen is always written back, even on failure. Some protocols
(e.g. CAN raw) return -ERANGE and set optlen to the required buffer
size so userspace knows how much to allocate.

The callback is responsible for setting opt.optlen to indicate the
returned data size.

Important to say that  iov_out does not need to be copied back in
do_sock_getsockopt().

When optval is not kernel (the userspace path), sockptr_to_sockopt()
sets up opt->iter_out as a ITER_DEST ubuf iterator pointing directly at
the userspace buffer (optval.user). So when getsockopt_iter
implementations call copy_to_iter(..., &opt->iter_out), the data is
written directly to userspace — no intermediate kernel buffer is
involved.

When optval.is_kernel is true (the in-kernel path, e.g. from io_uring),
the kvec points at the already-provided kernel buffer (optval.kernel),
so the data lands in the caller's buffer directly via the kvec-backed
iterator.

In both cases the iterator writes to the final destination in-place at
protocol callback. There's nothing to copy back — only optlen needs to
be written back.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/socket.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index ade2ff5845a0c..a25e513cf0f47 100644
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
@@ -2349,11 +2350,45 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
 INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 							 int optname));
 
+/*
+ * Initialize a sockopt_t from sockptr optval/optlen, setting up iov_iter
+ * for both input and output directions.
+ * It is important to remember that both iov points to the same data, but,
+ * .iter_in is read-only and .iter_out is write-only by the protocol callbacks
+ */
+static int sockptr_to_sockopt(sockopt_t *opt, sockptr_t optval,
+			      sockptr_t optlen, struct kvec *kvec)
+{
+	int koptlen;
+
+	if (copy_from_sockptr(&koptlen, optlen, sizeof(int)))
+		return -EFAULT;
+
+	if (koptlen < 0)
+		return -EINVAL;
+
+	if (optval.is_kernel) {
+		kvec->iov_base = optval.kernel;
+		kvec->iov_len = koptlen;
+		iov_iter_kvec(&opt->iter_out, ITER_DEST, kvec, 1, koptlen);
+		iov_iter_kvec(&opt->iter_in, ITER_SOURCE, kvec, 1, koptlen);
+	} else {
+		iov_iter_ubuf(&opt->iter_out, ITER_DEST, optval.user, koptlen);
+		iov_iter_ubuf(&opt->iter_in, ITER_SOURCE, optval.user,
+			      koptlen);
+	}
+	opt->optlen = koptlen;
+
+	return 0;
+}
+
 int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 		       int optname, sockptr_t optval, sockptr_t optlen)
 {
 	int max_optlen __maybe_unused = 0;
 	const struct proto_ops *ops;
+	struct kvec kvec;
+	sockopt_t opt;
 	int err;
 
 	err = security_socket_getsockopt(sock, level, optname);
@@ -2366,15 +2401,28 @@ int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 	ops = READ_ONCE(sock->ops);
 	if (level == SOL_SOCKET) {
 		err = sk_getsockopt(sock->sk, level, optname, optval, optlen);
-	} else if (unlikely(!ops->getsockopt)) {
-		err = -EOPNOTSUPP;
-	} else {
+	} else if (ops->getsockopt_iter) {
+		err = sockptr_to_sockopt(&opt, optval, optlen, &kvec);
+		if (err)
+			return err;
+
+		err = ops->getsockopt_iter(sock, level, optname, &opt);
+
+		/* Always write back optlen, even on failure. Some protocols
+		 * (e.g. CAN raw) return -ERANGE and set optlen to the
+		 * required buffer size so userspace can discover it.
+		 */
+		if (copy_to_sockptr(optlen, &opt.optlen, sizeof(int)))
+			return -EFAULT;
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
2.52.0


