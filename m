Return-Path: <io-uring+bounces-11998-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OA8LJrL8fGnLPgIAu9opvQ
	(envelope-from <io-uring+bounces-11998-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 19:47:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BAFCABDF0B
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 19:47:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 45664300B519
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 18:47:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91BC4385EC8;
	Fri, 30 Jan 2026 18:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="kEm0xwxI"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7263859ED;
	Fri, 30 Jan 2026 18:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769798827; cv=none; b=Rvs+1C2RkpT/K7kcY3C6vOTPTfXjlOm+UkoKDTaQgdn91btnDkXUAXjes7JItchdZ1q8ITrLVkt2zgbl03UqS6091wjb+1ZI6rqlqxGu+zcXlsZF2lCw0SSfuOq9aL20bOcSRq2SGW37XRHFjX9c5yPaj+H+UKSPh2uWTOekohs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769798827; c=relaxed/simple;
	bh=4FX0o94g4/j+gck6q6lurkfmlT/H4llIwQqP7XZyYbY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nBLOAQA+6hSovvP7k1ripxv6LTu4mrpQF5wCcIN++OqPmCgBio1jqMfqS2eYrFmaAqmEvZ+fyPeRHa1J6xUpS/EXZ9udj3/XRVUDvZjAHOHE+7TYQEn2COcwOcT1JRXd/DgqPDVE/LgxAxT2q+5DcNZaol7bmaRPJVIKSVpKn24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=kEm0xwxI; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=PV5ptLugLWLHVi99ajukEoln9y5Onr2WkbErb2nElJc=; b=kEm0xwxI6ESGiriN/ZWMtK7pyz
	XH9vvPMZbwHzBqq/vT1jDPyuT//B2PTroKptDCRQKMZ8dITwx7vJE/oJa/7W5/J4BK//mC2f9Y8QQ
	fgAfmVf1DhuupdZ9KqIBNM+7dtddqssSyzRdsqkCPBCKnJoxElyTwCTbZRz+oH/HUulNxkN4aqY05
	XtxIWY23ZaZNiPIwLB4esqcX/3YvmOIfqJkdWi3NuxM+fqN7cHOvTI8RSYCHP4NuX7zuNNROzg5P9
	AGWn/cGlbFVYVUFUOeMbCSdZ+zz8LQFgEIbr85Hq3LnwpmHXftasZji7RVyolkKqoyI1d2U56kJfc
	9GASVIPA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vltWA-001urW-Lx; Fri, 30 Jan 2026 18:46:54 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 30 Jan 2026 10:46:17 -0800
Subject: [PATCH net-next RFC 1/3] net: add getsockopt_iter callback to
 proto_ops
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260130-getsockopt-v1-1-9154fcff6f95@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2223; i=leitao@debian.org;
 h=from:subject:message-id; bh=4FX0o94g4/j+gck6q6lurkfmlT/H4llIwQqP7XZyYbY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpfPyUdv4Vgd18b7l3fTf3+8F7Fa1Cdsv9kzuQf
 tRnWpMZHR2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXz8lAAKCRA1o5Of/Hh3
 bUFUD/48ErHKQ8V/LgZA0hHtFI7domjnT54z9cWlkZNQBQlByPzh07GgmQ5ZY10s/bMXbNsrjZX
 OEu/xUjYW/haJN9NTPM8VHmasKoFQv2siHK5RDkULhohsU2+FusrfCig1V2RIcyn4tlgTK4selw
 FQQVPGNxE6djZtATw3TToDQDGSYsRBrjEDPto78tLy2vlj3v6U8yszHQwmFmjxHIbme7QOJObOd
 MF5Pv0aHbp+NdYWNKfngl3mAskCgrNtRSSt/M+rOA9J14B+yZd+DXrR0rY0GkJ1CYDZLaLmQMc1
 Dp7HBWeYgwd0kwtW2I9HZcU00xstEJRwg5HKPsrXW40ZOu1QBO7g1uGyUZwpHUcp3h97u2keCTk
 D5W1YE4BhEBUPAvBnLS4+eKLqMuNH00N6pD77r214GBjEbgGPgjS7MPlhPvObLEgORQJIc0P0BS
 pgU08CQ07E1KsNVB5Zp69ZeZNO376Oed9bnsU/J0++L2OgyLLjCbclvnKROdvsXQ0cdBK6LJNfV
 U0Cko0hn6a5Y2FBwsIQGBr2fQlOEXkMYZMaE+C70gTktaD9OGAIR1SE1P7V/y2t44NpOjvx8uNh
 +BC7vcGXqBnFcALhzMGBZ/BOcvrxB/+MyWcLqgb1U8KS0v3hIp712eccioh4hYy20uBT0jXWt8x
 UtVWquNDFcFBVHw==
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
	TAGGED_FROM(0.00)[bounces-11998-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux-foundation.org:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BAFCABDF0B
X-Rspamd-Action: no action

Add a new getsockopt_iter callback to struct proto_ops that uses
sockopt_t, a type-safe wrapper around iov_iter. This provides a clean
interface for socket option operations that works with both user and
kernel buffers.

The sockopt_t type encapsulates an iov_iter and an optlen field.

The optlen field, although not suggested by Linus, serves as both input
(buffer size) and output (returned data size), allowing callbacks to
return a random values independent of the bytes written via
copy_to_iter(), so, keep it separated from iov_iter.count.

This is preparatory work for removing the SOL_SOCKET level restriction
from io_uring getsockopt operations.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/net.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/net.h b/include/linux/net.h
index f58b38ab37f8a..94f6c86769afc 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -23,9 +23,26 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/sockptr.h>
+#include <linux/uio.h>
 
 #include <uapi/linux/net.h>
 
+/**
+ * struct sockopt - socket option value container
+ * @iter: iov_iter for reading/writing option data
+ * @optlen: set by callback to indicate returned data size
+ *
+ * Type-safe wrapper for socket option data that works with both
+ * user and kernel buffers.
+ *
+ * The optlen field allows callbacks to return a specific length value
+ * independent of the bytes written via copy_to_iter().
+ */
+typedef struct sockopt {
+	struct iov_iter iter;
+	int optlen;
+} sockopt_t;
+
 struct poll_table_struct;
 struct pipe_inode_info;
 struct inode;
@@ -192,6 +209,8 @@ struct proto_ops {
 				      unsigned int optlen);
 	int		(*getsockopt)(struct socket *sock, int level,
 				      int optname, char __user *optval, int __user *optlen);
+	int		(*getsockopt_iter)(struct socket *sock, int level,
+				      int optname, sockopt_t *opt);
 	void		(*show_fdinfo)(struct seq_file *m, struct socket *sock);
 	int		(*sendmsg)   (struct socket *sock, struct msghdr *m,
 				      size_t total_len);

-- 
2.47.3


