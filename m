Return-Path: <io-uring+bounces-12919-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eGLyBXA+zWkkbAYAu9opvQ
	(envelope-from <io-uring+bounces-12919-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 17:49:04 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B292A37D6FA
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 17:49:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5B5F3308735D
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 15:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20A23FFAD2;
	Wed,  1 Apr 2026 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="i10ik82i"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9703DBD61;
	Wed,  1 Apr 2026 15:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775058301; cv=none; b=rrENQ1spJQFL8FN6VXY73usmqjbL7/ZSTzzudZqiLL6e1L6H0kRj1pJVAq5Pu7gIrY00jVkHLSaSBLZuLNKSXUIjZ5Tnsc94nYNyGocitHlLdm4tDRARUkaHDYJsgtu9Ia0COwmQ/ovQbVVsYGHa6tGa7TK0oFBgXh6ZNQ7NL5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775058301; c=relaxed/simple;
	bh=hMYQYT2xvfHqOHl2LFKSxlX6nua5F3CMVTSf2Pf/5bY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L5Ltk1UMjq/tewMSWq2pHph1p+fcwNqYQpT8O5xEV5OXfSeY9FTC8bZLeyNa477CBlSzoF/EfPInHCMzTx4liIK52VXN2whii44WqBB4UgHgl0KcFSLsQSFoh1c8xoJ0C0jBHZVZg9K7z/O3RozH0kEApkP75dxDqAkP4uCqK7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=i10ik82i; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=npBuva6v0+cdBLu8r0x6NARc7OQliddIYu9hiO4ITV8=; b=i10ik82i9R89aKWrfdPwl6L6Su
	+X2n/CRtUBnTW1DnjOd0Cf9S9kCY3ImEQk3xUAjJPxA/esESxeRstWK9aFSNgvc4RvwdK3wSXtl14
	TgHCRvsL3C3a/YvqH+tAbwX1UDAvk7s88KjukqtMCgzG9LxHzgXGAgA26P0JNEZrTJ0hmlAvOkw+V
	nw022n0dTqAnyrHgMNVkRqMKJSVwd30N8vPmgFtM2YDYfH07G64gli8GmQcitF6g5Ip4Br0Ni4XSm
	/wnFw1pEZLwoKTUTyGBzWlcZFMa+rClVLfMK9NI4c+N72A72R/3/0YFkA/fhcUroJ8Sz2T9BCDY+M
	t6MTB3DQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7xkW-0035cJ-1q;
	Wed, 01 Apr 2026 15:44:55 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 01 Apr 2026 08:44:26 -0700
Subject: [PATCH net-next v2 1/4] net: add getsockopt_iter callback to
 proto_ops
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-getsockopt-v2-1-611df6771aff@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2238; i=leitao@debian.org;
 h=from:subject:message-id; bh=hMYQYT2xvfHqOHl2LFKSxlX6nua5F3CMVTSf2Pf/5bY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpzT1tEK2sgVZblXNKllTHeR3jNXo3w+LhuCcK6
 Y0/IrdkRCeJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCac09bQAKCRA1o5Of/Hh3
 bYLdD/4psx2XNR7NLxe+UBFXYH7K0dirkXXF9WIn/fsl17SyxmSOQhXikX58+JDV3gVSxjc2mTt
 pvnboSSRYzYa1GUVNkWO7glDn+Nz7QqxQL07LXfZZCD6KlTf3j/gvZbbrN06sACiCZ05XXwsUK3
 2SJSafQm2cplIO8WCwJbVFSR61Mebbz1ue/Nma5cXnuLs8nAZrLS+TE3/o5SdARcp6eIHZ9W4Ev
 yk3qFCjMAWn7Dc7cnDlPmlyGjG4eUrWRMcVajMKEtQ3MoWbAZ8zQc27m/MI6lGIfH8ZnvtyvAdD
 EYIUaQv828selFCTmOIAAQs/JW4OwNfEj3BFcqbSfvurgZHRJTArjU832WhAXxhdwpwFpscYq9P
 3h8PbgZpN+bLIFDwug/mnHTgL2sHgQhy/wtPJ6Yr0OdM7Lb3PHRSmWtt7DHSBlGiee5dsL8YKzG
 woLD4LxFKxS8K9mTDRDZ1jHypAU+uA23/CvwhsSacriDQ0oCOHqawHQwKiUyWFgVixYhudFEHRs
 L7Pbbl36+E7rB7x8VMXIAM4JugIe+Huf4FyV6QSJU3BigQHvNl9HfIai6V/1VMMvduzwLixddRa
 zNPbPbSFOI1n54816cgxwcUsIqK5N5VhAgog+IwZhm/hk0F2e+cVcjynX7URMeO1LMW+/6Q30hF
 hTiGobipofUDJkw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
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
	TAGGED_FROM(0.00)[bounces-12919-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linux-foundation.org:email]
X-Rspamd-Queue-Id: B292A37D6FA
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

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/net.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/net.h b/include/linux/net.h
index a8e818de95b3..9dde75b4bf77 100644
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
+ * @optlen: serves as both input (buffer size) and output (returned data size).
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
+					   int optname, sockopt_t *opt);
 	void		(*show_fdinfo)(struct seq_file *m, struct socket *sock);
 	int		(*sendmsg)   (struct socket *sock, struct msghdr *m,
 				      size_t total_len);

-- 
2.52.0


