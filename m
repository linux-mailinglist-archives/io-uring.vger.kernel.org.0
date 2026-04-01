Return-Path: <io-uring+bounces-12920-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +ErVKIJAzWkkbAYAu9opvQ
	(envelope-from <io-uring+bounces-12920-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 17:57:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0072937D8D2
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 17:57:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B8F63133347
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 15:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE5D44B687;
	Wed,  1 Apr 2026 15:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="RHsHg+44"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF593644CA;
	Wed,  1 Apr 2026 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775058305; cv=none; b=l/T//su3dZgtmsau54/b5Pih5r8TLis2julrjlHpdSEmw3wBYLxtYUF+RmBrH09uqseqQQ4XSZk9GCDwnEGyRt7lZShoxJQtkvTMmj8ECsceV0BcnNvoXSYVz99mT6qcZR7XDwttGSbb6JXM5uhqa0oMXNSYnWxNjnLY7Emrr6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775058305; c=relaxed/simple;
	bh=Wy4BH2uTAnsO+wh6l7vn7Fq5hp6ayWXU/wA564vnaNI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gF5Lf4xDl9kE9pnlwuHFkE64LWxL40oozuzkTXoRfg0U3SsPYCQJW+KK7VAExUJ/ajLgcXzo/8m8qePu3g7bSx0r/bka7q5IJi37iIjKo5WQQ9Fz14WT5p08rmWL5Wq8w7o2B0BzJhSzw1vMJ2B2J45eg75bwb2EMUAJ50VgV1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=RHsHg+44; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=6ku4rL1qubigHGGSJXU5arZMdC5XOO4IXDE/SU6GV9o=; b=RHsHg+44jmd1BPeBoizNvI6wWf
	Yd0ef4x53i8/tOgtl4kUPe4HM8j3FInyjlx8xa3O9FU+wxOKflJL5aMwIOQB9zWdWMptYZWiEe5Nm
	8e/ibIZn6R0ZeXmTnpthSiMg3ouJrQjY7ZfesqvMy0McutG4J9VAvY4VCRwiJSyrpq5vg8PNQ3Ki3
	jPRADZ6/nqJ5Yy69klVv4PJse/t617tu6j39VHebJSJ2ntIv9puOmON5bEz4NzW0xVwl46FxDilsB
	atg5V17guJM5dE1KZngIYasTLwf+jnm95YTMIwmDieGjWPOf3aHNV7L4xXZqUSDxv/JNJfTH3LpIh
	KptLVS0Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7xkb-0035cP-0D;
	Wed, 01 Apr 2026 15:44:59 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 01 Apr 2026 08:44:27 -0700
Subject: [PATCH net-next v2 2/4] net: call getsockopt_iter if available
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-getsockopt-v2-2-611df6771aff@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3399; i=leitao@debian.org;
 h=from:subject:message-id; bh=Wy4BH2uTAnsO+wh6l7vn7Fq5hp6ayWXU/wA564vnaNI=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpzT1tDy56mQ3kIeRy5y9WTr2DAPeuz+7MI6QKO
 BJf/GAU0f+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCac09bQAKCRA1o5Of/Hh3
 bXfKD/9UNOXyXUJ/K+AqH0hnslwFZe6hAmuBsde6dZiZVCecuxYgfLAGykHYAmmqadiSW8HxWak
 CV1E5RYTKYteQJEASvJBP4QoysUoVEIgpJV1EOi+N1EoI93nQExLG2BYxi4yJ0dnQ4g4DQGOiuo
 uYCRaPRSotTdoGoa2COZKoCkLHgLjlslzmDUIEiceUgiTT3D72oFUiKtihCxl13NZGErqCNZoaV
 6zXuxyMMxhHcc6MvxLLxVzEKwHbZnNOPqDo4yxZ4mD9/TNpceNr+wp5x2zfwdi7/zckH7g3Vmiq
 eg7fLBudM4r2BHnEy4srtXO/2vLcV+0CFtARVp8LK+OdIXu3+Y7Rv81aBSOkKUmgd+W+p93yElU
 jf9Um/U5X+PwfCb5RJQDCkdO0vD5BiryrwJczA8m0guQx62pZFQmm0a59Z46pHnv4mnfK5KWzCJ
 tVT7rKPvyeB8AYsO+J+SIhWI12S6SW00eXi74fzdtf7PRnPYHPRQ4efQuSO2Qxm3c13sjfdQ4qv
 RkO0rmsqfQmS2br213H9dYLfNwK9BQilo7keG0fas4Zc3oxHcynup9ZCfBHTq+2so3Uj+F05jfz
 +DL8ldlYqfk68oYE4SjWvcB1mDseDomU4xU1krdlGNY27E1xUJdyJXh8/RmT+xsRptuYC5/Stj0
 s1B2E7Fa1852q0w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	NEURAL_HAM(-0.00)[-1.000];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DMARC_NA(0.00)[debian.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12920-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[debian.org:+]
X-Rspamd-Queue-Id: 0072937D8D2
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

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/socket.c | 48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index ade2ff5845a0..4a74a4aa1bb4 100644
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
@@ -2349,6 +2350,44 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
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
+	/* iter is initialized as ITER_DEST. Callbacks that need to read
+	 * from optval (e.g. PACKET_HDRLEN) must flip data_source to
+	 * ITER_SOURCE, then restore ITER_DEST before writing back.
+	 */
+	err = ops->getsockopt_iter(sock, level, optname, &opt);
+
+	/* Always write back optlen, even on failure. Some protocols
+	 * (e.g. CAN raw) return -ERANGE and set optlen to the required
+	 * buffer size so userspace knows how much to allocate.
+	 */
+	if (copy_to_sockptr(optlen, &opt.optlen, sizeof(int)))
+		return -EFAULT;
+
+	return err;
+}
+
 int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 		       int optname, sockptr_t optval, sockptr_t optlen)
 {
@@ -2366,15 +2405,18 @@ int do_sock_getsockopt(struct socket *sock, bool compat, int level,
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
2.52.0


