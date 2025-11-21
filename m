Return-Path: <io-uring+bounces-10726-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5C0C7ACA9
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 17:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B6C6F3478D9
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 16:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D9BF35292A;
	Fri, 21 Nov 2025 16:10:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C5E34FF44
	for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 16:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763741426; cv=none; b=Jt4YJK+8QHup0X6bebwD4h1fmU1veAT91dg98ItRqwlsuXz2l0uFmwKinAqUrIYQYjN901ujkroXaReGErEM/p9iQmN4mIsiGNe5xqRN8YpN9qWRbwF2gBdVRc+f1gVDaX2Cd/Rl5On99bOUR9vs/y8wJ/whNKOgOqOYDNn8bwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763741426; c=relaxed/simple;
	bh=koPu2OS4xs2Z4RrjCJxtqJsDcimXkzohnNY5nQoIwWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCDDdtVCxppNrnPGxTUayxY8LfBNQeASqN6ubPylmLN6PN/nR/Ki1QKHj9U6b9ExFq2SVAwT7JfofPKFwsT9HumrjwJvAeaR47kGrldLhyhFQ72cRy4L8cOsGt5j345OBSDTPYWkYoLLvmiI6DlcSplHSTY5C9MUETpqZ6MopOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A86CF219AE;
	Fri, 21 Nov 2025 16:10:14 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59C3B3EA61;
	Fri, 21 Nov 2025 16:10:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Rl8OCuaOIGmSeAAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 21 Nov 2025 16:10:14 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	netdev@vger.kernel.org,
	io-uring@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH v2 3/3] io_uring: Introduce getsockname io_uring cmd
Date: Fri, 21 Nov 2025 11:09:48 -0500
Message-ID: <20251121160954.88038-4-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251121160954.88038-1-krisman@suse.de>
References: <20251121160954.88038-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: A86CF219AE
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]

Introduce a socket-specific io_uring_cmd to support
getsockname/getpeername via io_uring.  I made this an io_uring_cmd
instead of a new operation to avoid polluting the command namespace with
what is exclusively a socket operation.  In addition, since we don't
need to conform to existing interfaces, this merges the
getsockname/getpeername in a single operation, since the implementation
is pretty much the same.

This has been frequently requested, for instance at [1] and more
recently in the project Discord channel. The main use-case is to support
fixed socket file descriptors.

[1] https://github.com/axboe/liburing/issues/1356

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/cmd_net.c            | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3d921cbb84f8..6a97c5376019 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1010,6 +1010,7 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_GETSOCKOPT,
 	SOCKET_URING_OP_SETSOCKOPT,
 	SOCKET_URING_OP_TX_TIMESTAMP,
+	SOCKET_URING_OP_GETSOCKNAME,
 };
 
 /*
diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index 27a09aa4c9d0..90f58f883f62 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -132,6 +132,27 @@ static int io_uring_cmd_timestamp(struct socket *sock,
 	return -EAGAIN;
 }
 
+static int io_uring_cmd_getsockname(struct socket *sock,
+				    struct io_uring_cmd *cmd,
+				    unsigned int issue_flags)
+{
+	const struct io_uring_sqe *sqe = cmd->sqe;
+	struct sockaddr_storage address;
+	struct sockaddr __user *uaddr;
+	unsigned int peer;
+	int __user *ulen;
+
+	if (sqe->ioprio || sqe->__pad1 || sqe->len || sqe->rw_flags)
+		return -EINVAL;
+
+	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	ulen = u64_to_user_ptr(sqe->addr3);
+	peer = READ_ONCE(sqe->optlen);
+	if (peer > 1)
+		return -EINVAL;
+	return do_getsockname(sock, &address, 0, uaddr, ulen);
+}
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -159,6 +180,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		return io_uring_cmd_setsockopt(sock, cmd, issue_flags);
 	case SOCKET_URING_OP_TX_TIMESTAMP:
 		return io_uring_cmd_timestamp(sock, cmd, issue_flags);
+	case SOCKET_URING_OP_GETSOCKNAME:
+		return io_uring_cmd_getsockname(sock, cmd, issue_flags);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.51.0


