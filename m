Return-Path: <io-uring+bounces-12922-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WMBeCy9BzWkkbAYAu9opvQ
	(envelope-from <io-uring+bounces-12922-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 18:00:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C91837D945
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 18:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CC0FB314DD60
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 15:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D2546AEF5;
	Wed,  1 Apr 2026 15:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="tlLU2FZM"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F93446AF0A;
	Wed,  1 Apr 2026 15:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775058315; cv=none; b=ptRMvcYdcjMfcdDwZLoQ5Vsz5x0Fhnq10AzJcfa8Mc8Wt4Ih9uUdiCl95sgNmFVStQtkebvdD9NJGb8hZPs/IpxSMMk3f+wyM2KmvUYAf7NRTlUIeodkuaJBK4+Y31qblOOjRt6Zb44HDa5pg+HTbGovBOnnBWRSlb+qUz0R07s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775058315; c=relaxed/simple;
	bh=iqc+thnplGbagtZitkFr0/8EaF2514ngtda7G4+ycEg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rGL80+fIv39QcAthXvgSMom+1gZrvLc1enMLKOHBWORoVtfGrCOrP8kpN7bFWX3AlRSih/NpWm+JZIBNA8gpwlo73n6oLuOvDuhobnK+qJSj35preM1oNYYUpleOWo/gqr3nJPEcPQSNo1zSuWGkpEoCG3DvfCpNpEBru1+++5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=tlLU2FZM; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Lej6QSoacgl2a+nP1MnseSSrOlZxwpQzZtAY5CDn1Yw=; b=tlLU2FZM0rY4qtZfObiirS4xyF
	P0YltTpMm6u0SnucTi4WO2hzR3hsjqzU9Lp6kax2XVHC57s2CxN9P+eVCoYDtIHv0fHa4/UEol/LZ
	SA89q6jWwLAH/Ez9pAUuIyEo6QVvbT4FefpGbcHsYYot2eJw9SwXr8IvPXQpymoSbCm8KGNCAb0vh
	WTTRpA9pNgaV5Msv+Ht+1o40Ux5qVPWiCdTBy8E9RTWgeN9b+ZkWz9JmXTuKcNAv1Xd0CzXIDnGBI
	b1nnV98xnouIW9fvH352AtADF8/mn45jKKbX7ewxGyq83fnkoWWyIOymRXjkEOy+81EeXopeeCwR3
	gbkcF95w==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7xkk-0035dd-10;
	Wed, 01 Apr 2026 15:45:09 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 01 Apr 2026 08:44:29 -0700
Subject: [PATCH net-next v2 4/4] can: raw: convert to getsockopt_iter
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-getsockopt-v2-4-611df6771aff@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3556; i=leitao@debian.org;
 h=from:subject:message-id; bh=iqc+thnplGbagtZitkFr0/8EaF2514ngtda7G4+ycEg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpzT1tMfMi/RtUGVLqCkkhguSfwnWWgUf5hrWp4
 6SH1L6hjZeJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCac09bQAKCRA1o5Of/Hh3
 bV/5D/9CGo1OaKmU7rR0S+c31BjEmkfEgNjBU5bEXpz89FVM5PHsQUPObRb+lkf/ijBJkyqnZEx
 4FkVn+y+/xw1ppO8lETRTaQAQ3FBEQlh0SHsalCXOGz7ehL3S9/XBNAMoS96QB3m+D2XrfCyBrZ
 rXs6J72WKKIV3bUfiDcsNVZ49Q6OyTnruWABm62W8wHz07bHRPbcbagb2+aiyHXrJwKMAOok87R
 QG+Ed6Y7P1Xv18FmT9kaPVuxaZ/wmECqLt6AmPjc2/O3q5Cd2gVGcsMIKYYNC5CQYk1rNw/fZzG
 HSYYmuO43Gn/IUP835kahXJc2QBxyGMi8+WMVBibX9O4aXAqwGN9IIfC8+mdPUIOuzdED0/0CKZ
 YhEc749hxXiMQOUukqW8SeBp3CGtnDaZjtUvF1k//8igxfLy1DYqqQqA7uCinLQQOcsVFJ0EQLn
 bXYnL5IL/xwIzFHfttlE4LTyEoaw5APTlh2Wj4CMG0UkYThS2KnwD0YFUEFd0bcsLZRBX7hmxl9
 Tt3i3NlhyIeZ3nrx2Lyukojhx+uQ2Guq+wITfK2SbivUYh7Nwpf6pf3Kb9R2Vr9WfOieHt+NaZ6
 9ei8JZuguasjg6Qn+AXdvoY7CtZ3ZKesTqlhjIvDI6Tm73Zqt5OIjH1W/Hi3ZQJZ5Hrp4PkvWkk
 70CuwSDZIsRL0+w==
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
	TAGGED_FROM(0.00)[bounces-12922-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 9C91837D945
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
index eee244ffc31e..4b3408528637 100644
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
+						 &opt->iter) != len)
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
+					 &opt->iter) != len)
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
+	if (copy_to_iter(val, len, &opt->iter) != len)
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


