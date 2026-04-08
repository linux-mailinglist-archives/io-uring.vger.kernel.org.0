Return-Path: <io-uring+bounces-12982-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eFQwA2wu1mkUBggAu9opvQ
	(envelope-from <io-uring+bounces-12982-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 12:31:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A123BA8AE
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 12:31:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 952CD300D0EC
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 10:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F39C38551C;
	Wed,  8 Apr 2026 10:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="JVitOMZw"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D2137F75C;
	Wed,  8 Apr 2026 10:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775644261; cv=none; b=QsqtFQc+QGwfwBbFbfiBmq7N2pMm2L8c0QqHJwKaeG9JWDu85Vi3eIdBE/RnywEtcVYS7T58lQyjzMMiCuEwPLejF1eLe63jfubXyhQ6N0PhMkg6RlzW8XNr7keGakkdKFw/lV8tYaa3KbtfgJWMtygVtNXHFcU1GQTL5feXBAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775644261; c=relaxed/simple;
	bh=Z3kqAGj1zvBralU1HC67R+RaKPOjxmuRHQ9FYFkUl2Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Kz02XTRZd1iZCweVyjuTBTerKaGcldfEzYJ1ZbWPhc59GAZ3Elro0v8o4P0tF1q7AngaCsZlEeRlznEHC8xOo+hYy6pGMeBCMNiVtSCMgNOH6LCteI6xmDhAECETYAs6sFadsE66wAMQJGqJ4oBscYLhkBBGO62jfvhYofI56GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=JVitOMZw; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=HtRRkzAXU0fkc0Tx+iUTyUu5YP+MGY2ZcOBwtJyH1lk=; b=JVitOMZw8q6rQWdCtOPrdGutrk
	YSH0+ciKG0cdOw7QJXC+kYJCbcXHaO8kP8Q0BIUCPkY5b6RlIetdT5fJmo9z5ztsDy3i6OWdEWVjA
	+x78Qu4JIqgKuAvWtlXSXnlNzFsT3Gvx1Tg7j4rZTY+4rl7VSva3Ntaq4EoKPe7hi90JNpzpKo/AT
	v+6i0HqxXcSPczfpL8Ee09yn2ILsgJKWfYDKobWTXWKSPLXvQedhvPOoGQvPRj7XUxXw8ZQfDnV5g
	ueRy2683pSrIs1XQWYOXEst4z+puYmwCVeFAByRVHOHvxRo6noKtz+Zl1U9K1YniUFBxzG5gBr9RB
	8Hw59Cag==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAQBM-008MDm-1b;
	Wed, 08 Apr 2026 10:30:48 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 08 Apr 2026 03:30:29 -0700
Subject: [PATCH net-next v3 1/4] net: add getsockopt_iter callback to
 proto_ops
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260408-getsockopt-v3-1-061bb9cb355d@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2673; i=leitao@debian.org;
 h=from:subject:message-id; bh=Z3kqAGj1zvBralU1HC67R+RaKPOjxmuRHQ9FYFkUl2Q=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp1i5NHj9Xl1AjkU+gDhoHhigNX4piORFmHvHzF
 ggEMJO/kDGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadYuTQAKCRA1o5Of/Hh3
 bZSAD/9mexa9BnbBzpMw7Rr4ZVS3NFpB7NDeynnsM7sUiVPrOWAkPo7rlbcancrXJlCfNSSFMz/
 wegWUoI5sfK1KiK624x/DnenCu1IrLLre6ZIO+sv3DStjCM1JHwMyXLlptxNHUytis6/FI+JwBl
 63GrFn9+9C+kIKu/5cTVJla7X4p5BZsqWV+0G94G6Efj6cX0UxdSqX+PPv7fwOPleg7ATdzY2YW
 GNo4x11F668/k1OMm6XXkUYJhhN18yblY26UUwSZLvXDGgJ0m2lPeDwHUS3jOb8CJVjmS6YM/hf
 g5qYCUyasNkav3spTD2jbtIKBXk/8HZ3TpZaZoE07yIQ2W81WLKYQ9IyzgNGJDrD/hlr6jbZfRJ
 BBEfIJ349WxsyWKylxO/KuV93u6i/d8qrnT+L04Lck/XL8EpMO6aZ7PSPnRAydlmLkC/qcEpCU8
 KQi2uWvvQM1aILFEB+xwjQ2DJtyLV2YRvg2EZd4nzddAh9NQSKw7UdKsDiFwO7BIjeqpKLhP4rB
 YdKGKUfI8UGUm3LEuu9t1LEWl66XudjUpMd/DbpDOA36tSR8R4h2ZB6X5X+r7/gTzN8LVT7/z6C
 0Y0W0GHoNKs/NPS5OePYv3YTiq5z6p1kMiefLqcsEcYEMc+nOYXGu5/ncz8qR+XQ07y3WY3Xk9P
 +RmIb6YyDfzILLg==
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
	TAGGED_FROM(0.00)[bounces-12982-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 57A123BA8AE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a new getsockopt_iter callback to struct proto_ops that uses
sockopt_t, a type-safe wrapper around iov_iter. This provides a clean
interface for socket option operations that works with both user and
kernel buffers.

The sockopt_t type encapsulates an iov_iter and an optlen field.

The optlen field, although not suggested by Linus, serves as both input
(buffer size) and output (returned data size), allowing callbacks to
return random values independent of the bytes written via
copy_to_iter(), so, keep it separated from iov_iter.count.

This is preparatory work for removing the SOL_SOCKET level restriction
from io_uring getsockopt operations.

Keep in mind that both iter_out and iter_in always point to the same
data at all times, and we just have two of them to make the callback
implementation sane.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/net.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/net.h b/include/linux/net.h
index a8e818de95b33..fdd48d5c94441 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -23,9 +23,30 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/sockptr.h>
+#include <linux/uio.h>
 
 #include <uapi/linux/net.h>
 
+/**
+ * struct sockopt - socket option value container
+ * @iter_in: iov_iter for reading optval with the content from the caller.
+ *	     Use copy_from_iter() given this iov direction is ITER_SOURCE
+ * @iter_out: iov_iter for protocols to update optval data to userspace
+ *	      Use _copy_to_iter() given iov direction is ITER_DEST
+ * @optlen: serves as both input (buffer size) and output (returned data size).
+ *
+ * Type-safe wrapper for socket option data that works with both
+ * user and kernel buffers.
+ *
+ * The optlen field allows callbacks to return a specific length value
+ * independent of the bytes written via copy_to_iter().
+ */
+typedef struct sockopt {
+	struct iov_iter iter_in;
+	struct iov_iter iter_out;
+	int optlen;
+} sockopt_t;
+
 struct poll_table_struct;
 struct pipe_inode_info;
 struct inode;
@@ -192,6 +213,8 @@ struct proto_ops {
 				      unsigned int optlen);
 	int		(*getsockopt)(struct socket *sock, int level,
 				      int optname, char __user *optval, int __user *optlen);
+	int		(*getsockopt_iter)(struct socket *sock, int level,
+					   int optname, sockopt_t *opt);
 	void		(*show_fdinfo)(struct seq_file *m, struct socket *sock);
 	int		(*sendmsg)   (struct socket *sock, struct msghdr *m,
 				      size_t total_len);

-- 
2.52.0


