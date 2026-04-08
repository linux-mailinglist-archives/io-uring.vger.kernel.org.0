Return-Path: <io-uring+bounces-12986-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDPLDsIv1mlZBwgAu9opvQ
	(envelope-from <io-uring+bounces-12986-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 12:36:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A912E3BAA11
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 12:36:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E4CD730B067B
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 10:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D133BBA09;
	Wed,  8 Apr 2026 10:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="LyZ4perh"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A32D37F018;
	Wed,  8 Apr 2026 10:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775644271; cv=none; b=IkcbT+IIlHJc2GJInzSWbdDDqLNoDxJqcUBsq3CJuikhKWdilyi8Uz4COgmXwG7XtTLrcZ2kRFOE8blzeY9RbjpGiO2EPlEALFllUHYevXpCv4/yn7BiNoT5Dfj35BDCI9dNuqpMYbn1FnqV/BYRN11iIfyjWNgOgCw696tanGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775644271; c=relaxed/simple;
	bh=ob+hbsa5gaZ2FLIvbFGSmZclTDNKFYEONGlciwWTcrs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LrpCL7XlZQ+fi1wKpKbz2AAJU3Y0EHsOQuIbfoOyxMTuyt74Bow+hvHueheyGEi70FpwNo11DTAIOpvkoAb6bWHQEVk0SmfpBDKgm23O7y8T5yzrNoY6X72c53VmdnGX6WS5PetU9/DLV4b1DsHFbwwmuwklGDk7m3+PhouvLMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=LyZ4perh; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=PNxblEMqB4KhPBmYKCSvHUph+B8wcGo1Xxvt6/jg+/Y=; b=LyZ4perhYBsBCH2dGqGUqhVW8e
	92+aodKcuukx6WcViZboHFXjpjfi/pRXXVPq0uRgNvyX70zqhpzn3avmKKG1wYptu54XyLb4YedRF
	chXr1R8FwbPWuqWWP7Pl5WMg/3zgl7+sUrj04/FgZX5vrj4i5EWHJXM7pAwSDInIuprSqoHpCyHxV
	xT9TrXRhmpWO9aIs2z9P1PHeZzoNu5UBTuYIVyw2EG7QQ6IT7cmsVdLuyZns+9Sv9TO7cJS2gM47u
	gCAaNqgU5mxzLuD5YP0cG1P7kUxpLtUuxgGPInQmdBgkRX2Sg0VA8sbg8TKxA4zwHTWWRJTz4ypBY
	RhJLZgQA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAQBa-008MEP-1M;
	Wed, 08 Apr 2026 10:31:02 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 08 Apr 2026 03:30:32 -0700
Subject: [PATCH net-next v3 4/4] can: raw: convert to getsockopt_iter
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260408-getsockopt-v3-4-061bb9cb355d@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3570; i=leitao@debian.org;
 h=from:subject:message-id; bh=ob+hbsa5gaZ2FLIvbFGSmZclTDNKFYEONGlciwWTcrs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp1i5NKMEdYHx3wGg7Qa4vX7iAivyNKvTyGmjC/
 1MCC9Vd3omJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadYuTQAKCRA1o5Of/Hh3
 bY5ID/0QQwWLPW/sgiLSkESx/sudB1CI0N5EBltNaZhMUyskNxF0k2Gw835et7QDMWgo2GzycUi
 +SQUpbBYztTxkQgLa56yuW16T41e5VaKKTB4bj8e9MtLyTWn2gETp5/nt4E2i3aZPe3CeMR84wZ
 kDgolqoOwr9qGyN26yEY+92W4E0XaOCI29AP2sxKOAIRBADKGIlaAfihBteN3lkg9i8iHIFltjF
 NY1Xs+p5uhIKYFD7R4Wuj6YzCvWiio6SE+Rkbm7Gdz3wmwbMmqGcNvsoBUXq7ICG/38hduHtfzn
 ZgfzPWuXsfLhi1N9/NGC8TKyl0OWADXgEjQFx++3KrHHGcv9ecY4DPB5lxFTf2sf1wGP8Zx0+lF
 eOBrHWnK2i+6QpMRARyFP0jQqw9AXrciDxie5dEps42klrnIx9zufvK9bhPR4lnd1sl2thGot6o
 Z0eafJOmoYBzZ/IixnFRGmAEp/K83CwUJit0k1AWMkDgnYHuKgJvW4IE22CHLT3Rz3omNbha1MW
 q18Gaitf3kf4SHx54NXTNK5TVjSdIVPlRpsdpm1b2LT0UH789u3hbXHA2cRhs2JF8SgS9gAv0gQ
 eVMrybya7ngENB/cSe1qhMu67Y/T55QRGwSakdtuIuc6E0DrovsSq3x7J9kbLKdT1NeHPuk773R
 7yleGiMqVR8laYw==
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
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[debian.org];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12986-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: A912E3BAA11
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Convert CAN raw socket's getsockopt implementation to use the new
getsockopt_iter callback with sockopt_t.

Key changes:
- Replace (char __user *optval, int __user *optlen) with sockopt_t *opt
- Use opt->optlen for buffer length (input) and returned size (output)
- Use copy_to_iter() instead of copy_to_user()
- For CAN_RAW_FILTER and CAN_RAW_XL_VCID_OPTS: on -ERANGE, set
  opt->optlen to the required buffer size. The wrapper writes this
  back to userspace even on error, preserving the existing API that
  lets userspace discover the needed allocation size.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/can/raw.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index eee244ffc31ec..6f9ef867a13f2 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -760,7 +760,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 }
 
 static int raw_getsockopt(struct socket *sock, int level, int optname,
-			  char __user *optval, int __user *optlen)
+			  sockopt_t *opt)
 {
 	struct sock *sk = sock->sk;
 	struct raw_sock *ro = raw_sk(sk);
@@ -770,8 +770,7 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 
 	if (level != SOL_CAN_RAW)
 		return -EINVAL;
-	if (get_user(len, optlen))
-		return -EFAULT;
+	len = opt->optlen;
 	if (len < 0)
 		return -EINVAL;
 
@@ -787,12 +786,12 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 			if (len < fsize) {
 				/* return -ERANGE and needed space in optlen */
 				err = -ERANGE;
-				if (put_user(fsize, optlen))
-					err = -EFAULT;
+				opt->optlen = fsize;
 			} else {
 				if (len > fsize)
 					len = fsize;
-				if (copy_to_user(optval, ro->filter, len))
+				if (copy_to_iter(ro->filter, len,
+						 &opt->iter_out) != len)
 					err = -EFAULT;
 			}
 		} else {
@@ -801,7 +800,7 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 		release_sock(sk);
 
 		if (!err)
-			err = put_user(len, optlen);
+			opt->optlen = len;
 		return err;
 	}
 	case CAN_RAW_ERR_FILTER:
@@ -845,16 +844,16 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 		if (len < sizeof(ro->raw_vcid_opts)) {
 			/* return -ERANGE and needed space in optlen */
 			err = -ERANGE;
-			if (put_user(sizeof(ro->raw_vcid_opts), optlen))
-				err = -EFAULT;
+			opt->optlen = sizeof(ro->raw_vcid_opts);
 		} else {
 			if (len > sizeof(ro->raw_vcid_opts))
 				len = sizeof(ro->raw_vcid_opts);
-			if (copy_to_user(optval, &ro->raw_vcid_opts, len))
+			if (copy_to_iter(&ro->raw_vcid_opts, len,
+					 &opt->iter_out) != len)
 				err = -EFAULT;
 		}
 		if (!err)
-			err = put_user(len, optlen);
+			opt->optlen = len;
 		return err;
 	}
 	case CAN_RAW_JOIN_FILTERS:
@@ -868,9 +867,8 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 		return -ENOPROTOOPT;
 	}
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, val, len))
+	opt->optlen = len;
+	if (copy_to_iter(val, len, &opt->iter_out) != len)
 		return -EFAULT;
 	return 0;
 }
@@ -1077,7 +1075,7 @@ static const struct proto_ops raw_ops = {
 	.listen        = sock_no_listen,
 	.shutdown      = sock_no_shutdown,
 	.setsockopt    = raw_setsockopt,
-	.getsockopt    = raw_getsockopt,
+	.getsockopt_iter = raw_getsockopt,
 	.sendmsg       = raw_sendmsg,
 	.recvmsg       = raw_recvmsg,
 	.mmap          = sock_no_mmap,

-- 
2.52.0


