Return-Path: <io-uring+bounces-11999-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cLWWL7z8fGnLPgIAu9opvQ
	(envelope-from <io-uring+bounces-11999-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 19:47:24 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E845ABDF32
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 19:47:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9CBC7300A240
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 18:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC343385EFA;
	Fri, 30 Jan 2026 18:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="BRE37BbK"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5302A2D2390;
	Fri, 30 Jan 2026 18:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769798827; cv=none; b=EWBVa1P8o51IPCTEChbdvOE7Xeg+UaaFzxKJ9Ub98/VHWMAg9GG3sewaNdNYvByvm8iQiua3imYV8bp2vbAGVMXq2jcqcEUKLn1ab//D9BsVazGxzr/LkH5q5OIBoZi1JKvCvWx6YGyaMCaoy0pGQ6xuANYD60ooPEQVt/I9XJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769798827; c=relaxed/simple;
	bh=BsSJNvEtopeDtqJBgSI/2Gkhl3hlLNA7p2sp0lETHP0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=EhWNtTWJ9eLracIFPKA+Tq16Rv46A9FWQmV9jSS391wz4U5bXaL2EzKVSl4Te5XMlTysDw/6JqTxRQUekC7Sdogxg8C7Ii0UfZa9VvzM3QDdC6j37aTaePV9wyQvd8LeDfnSSzoNNHwvWNUQBk0AU6m3iu3jQlv4mE43Gx+OC8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=BRE37BbK; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=u+FPaYMRBpURyEluw/yBM5AMD+gZ+OchcgAsZYWmfxQ=; b=BRE37BbKjyy6Jjmg/EurSEMkii
	RTo38av7dzeGatWW0eWXmdICH1mDOAOLRtrOayjTy2rq15CzRQwImBO2yTgvIN3J1XUc0GiIMLQVi
	KT3OpK91ivvhwr3wa8EJAExMkWc47JHoQ01HinbnxX7FB+eoRfIDXmp5M377WoQMMGmlH6E1i7f5Z
	0QPM1Odce5w+xuab8o1yuPdy6YLinHm84jKbcKF5XUqEf3uV0iZMRe+174Pe7gbJZVb1Dw7BLu6+r
	rFZ6mYIhoJU0cua04c026xlpH3u9oVMs+dJ4NoMgm63Fzu6DY5PA4AMonkXbEhkJT/Pksyp5MOXic
	SNlCGm8g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vltW5-001upj-Km; Fri, 30 Jan 2026 18:46:50 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH net-next RFC 0/3] net: move .getsockopt away from __user
 buffers
Date: Fri, 30 Jan 2026 10:46:16 -0800
Message-Id: <20260130-getsockopt-v1-0-9154fcff6f95@debian.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHn8fGkC/yXMQQrCMBQFwKt83rqBNMWA2QoewG1xYdPXGoWkJ
 FEKpXcXdT0wGwpzYIGTDZnvUEKKcNI2An+/xZkqjHACo43VbafVzFqSf6alquPUWWsO5OgHNII
 lcwrrL+sRWVXkWuVyPuH61/IaHvT1+2HfPx3gKg58AAAA
X-Change-ID: 20260130-getsockopt-9f36625eedcb
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2888; i=leitao@debian.org;
 h=from:subject:message-id; bh=BsSJNvEtopeDtqJBgSI/2Gkhl3hlLNA7p2sp0lETHP0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpfPyUfLJa7kYCbO9DaPKX8IKB5y49gG2tFLqTH
 L/wt/Qt4O+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXz8lAAKCRA1o5Of/Hh3
 bYwkD/4xEVmxAXrxOB25//mNLPLzteB+X6gKqaL7XJQLuHAZ5l3mF9n8j1Pupovi8IlxeiQ5F4p
 wb7bUSTFoAVgDXEY7hwg/mM4h06GdaeW/995ft1S+5iOQlMK4RxJBY6pT7YLM3d9TOgqVTtB/2d
 Ky4mA7IRNTqn5Xf/Cjf/iTcQzQ2LUBIGR1qaqbfxu/k4YH+x6RKviYE73ghHMM6fIbQYQ3ABmzp
 r35WTtMZRPsDpgMb8WyRY9OT4yph5G1/5caOOU4tgxSkUn+6mBwgjEg8G0GtG1pWUTmicDlRvIA
 urmCQzAnD8TesVnEiD8zOvshq9hlJO87wJ1blFiHItDmdaYKxlCp2WRDx5ErMXYhzI45hv/VQQf
 4FEx44fzLx0YD0bmks8QsWK2azaJ32D3eAwC8mFC+J62+qWHCw2XQha2pXHDwL7axCJFH5QXmNC
 Yi1912czfP6qtwUM6LENE84BWR8Kxm1uH3ucxi8/SnD9CVZl6BtJYx1IasTiDEshQqEQdEiA5uO
 v2ufBY83VKdndujzznknSdGl8xFZsSTzlBfUb692Gr3A9wyztKp9Ouod9b14w/q+IsMWaTmz4Ig
 nxdw9hFVRR8FI+BigvbjHm7xD+B8OzHwEksodPalsbGzi2hA16qPWiFuRE9j2RHEeIEqYbTv6iv
 P2QEaFph0JnsOBg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
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
	TAGGED_FROM(0.00)[bounces-11999-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E845ABDF32
X-Rspamd-Action: no action

Currently, .getsockopt callback cannot be called with kernel buffers
because it requires userspace addresses:

  int (*getsockopt)(struct socket *sock, int level,
		    int optname, char __user *optval, int __user *optlen);

This prevents kernel callers (io_uring, BPF, etc) from using getsockopt
on levels other than SOL_SOCKET, since they pass kernel pointers rather
than __user pointers.

Following Linus' suggestion [0], this series introduces a wrapper
around iov_iter (sockopt_t) and a temporary getsockopt_iter callback:

  typedef struct sockopt {
	  struct iov_iter iter;
	  int optlen;
  } sockopt_t;

Note: optlen was not suggested by Linus' but I believe it is needed, given
random values could be passed by protocols back to userspace.

And the callback becomes:

  int (*getsockopt_iter)(struct socket *sock, int level,
			 int optname, sockopt_t *opt);

The sockopt_t structure encapsulates:
- An iov_iter for reading/writing option data (works with both user
  and kernel buffers)
- An optlen field for buffer size (input) and returned data size
  (output)

The plan is to enable getsockopt to leverage kernel buffers initially,
but then move .setsockopt from sockptr_t into this as well.

This series:

 1. Adds the sockopt_t type and getsockopt_iter callback to proto_ops
 2. Adds do_sock_getsockopt_iter() helper that prefers getsockopt_iter
 3. Converts one protocol (netlink) to use getsockopt_iter as a proof of
    concept

This is what I have in mind for this work stream, to make it more
digestible:

 * Keep the temporary getsockopt_iter callback allows protocols to
   migrate gradually.
 * Once all protocols have been converted, getsockopt can be removed and
   getsockopt_iter renamed back to getsockopt with the new API.
 * Once the protocols are converted, the SOL_SOCKET limitation in
   io_uring_cmd_getsockopt() will be removed.
 * Covert setsockopt() to also use a similar strategy, moving it away
   from sockptr_t.
 * Remove sockptr_t in the front end (do_sock_getsockopt(),
   io_uring_cmd_getsockopt()) and start with sockopt_t (instead of
   sockptr_t) in __sys_getsockopt() and io_uring_cmd_getsockopt()

Link: https://lore.kernel.org/all/CAHk-=whmzrO-BMU=uSVXbuoLi-3tJsO=0kHj1BCPBE3F2kVhTA@mail.gmail.com/ [0]
---
Breno Leitao (3):
      net: add getsockopt_iter callback to proto_ops
      net: prefer getsockopt_iter in do_sock_getsockopt
      netlink: convert to getsockopt_iter

 include/linux/net.h      | 19 +++++++++++++++++++
 net/netlink/af_netlink.c | 22 ++++++++++++----------
 net/socket.c             | 42 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 70 insertions(+), 13 deletions(-)
---
base-commit: 4d310797262f0ddf129e76c2aad2b950adaf1fda
change-id: 20260130-getsockopt-9f36625eedcb

Best regards,
--  
Breno Leitao <leitao@debian.org>


