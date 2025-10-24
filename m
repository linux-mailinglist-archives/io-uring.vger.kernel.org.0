Return-Path: <io-uring+bounces-10192-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C3A5C07155
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 17:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 918801C26E1B
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 15:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A7030C363;
	Fri, 24 Oct 2025 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V4tYt5W5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KDfVtia9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V4tYt5W5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KDfVtia9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304B832ED45
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761320965; cv=none; b=VpLnxpjrR/R5l6KJ54MUpQTfwTOnpSOWOKSsdF+jq3LfSN6NvYcOI3k789unaDdidLQTYv4O99IZLet9wBAqcrvTPpAHqoKkNpZ47PWSKBy9ul9ojsEX2gY3dW4Dr89iSZSRV3gutyPFpVn78joRXhInNTgZA9WK9SSnpIzpDsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761320965; c=relaxed/simple;
	bh=pUt3macq9aC/xFaDi3e0yXOG0jr8Yic6Te5qWIr9YL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/6GV5md8HCWwVZ9lbkxkhvzEqIYuebYmQDfjOF3hHsYwFk+4VcHQ1aTfa1qk4fvIeRkJgxTFMziRhdiOa5zTGIP4SCI5ncQWBBMM9djWNJYFShBAjr72bNIiDe2A+ooWwK7Q8Q8GO8hXB4D+PVeTjboViYW+ktiW1zBAULmcoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V4tYt5W5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KDfVtia9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V4tYt5W5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KDfVtia9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C36D61F451;
	Fri, 24 Oct 2025 15:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761320957; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AeJWPKRttC8nCexjJ0wKvKpK6/EWWl/jl5GEx61dRGE=;
	b=V4tYt5W52XcpJTFDnMImJOtiYqiEMS3tNVLKQbucp/bA2bhyDcnI82fPHBmP4PrjcQ754a
	7aw61tHzv2G4NLYjr7i83eqRfPoexqfDSqCbUper+FFH6wBylmLJQbAv8NOQMtlHghvWxn
	xdBRxRBbMgiSEy6XvjllODuQG7tH9bw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761320957;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AeJWPKRttC8nCexjJ0wKvKpK6/EWWl/jl5GEx61dRGE=;
	b=KDfVtia9M7SqRrY55IMJxLo4Y0FGP7cxJUvmZqpU9s3C53MtyY1x35ZKrUP+zenpX4gZi2
	IB27mY2bFJ+PHYAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=V4tYt5W5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KDfVtia9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761320957; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AeJWPKRttC8nCexjJ0wKvKpK6/EWWl/jl5GEx61dRGE=;
	b=V4tYt5W52XcpJTFDnMImJOtiYqiEMS3tNVLKQbucp/bA2bhyDcnI82fPHBmP4PrjcQ754a
	7aw61tHzv2G4NLYjr7i83eqRfPoexqfDSqCbUper+FFH6wBylmLJQbAv8NOQMtlHghvWxn
	xdBRxRBbMgiSEy6XvjllODuQG7tH9bw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761320957;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AeJWPKRttC8nCexjJ0wKvKpK6/EWWl/jl5GEx61dRGE=;
	b=KDfVtia9M7SqRrY55IMJxLo4Y0FGP7cxJUvmZqpU9s3C53MtyY1x35ZKrUP+zenpX4gZi2
	IB27mY2bFJ+PHYAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7CCB5132C2;
	Fri, 24 Oct 2025 15:49:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9cc/Ev2f+2gOEQAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 24 Oct 2025 15:49:17 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	netdev@vger.kernel.org,
	io-uring@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>
Subject: [PATCH 3/3] io_uring: Introduce getsockname io_uring cmd
Date: Fri, 24 Oct 2025 11:49:00 -0400
Message-ID: <20251024154901.797262-4-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024154901.797262-1-krisman@suse.de>
References: <20251024154901.797262-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C36D61F451
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

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
 io_uring/cmd_net.c            | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 263bed13473e..6bab32efabef 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1001,6 +1001,7 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_GETSOCKOPT,
 	SOCKET_URING_OP_SETSOCKOPT,
 	SOCKET_URING_OP_TX_TIMESTAMP,
+	SOCKET_URING_OP_GETSOCKNAME,
 };
 
 /*
diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index 27a09aa4c9d0..092844358729 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -132,6 +132,28 @@ static int io_uring_cmd_timestamp(struct socket *sock,
 	return -EAGAIN;
 }
 
+static int io_uring_cmd_getsockname(struct socket *sock,
+				    struct io_uring_cmd *cmd,
+				    unsigned int issue_flags)
+{
+	const struct io_uring_sqe *sqe = cmd->sqe;
+
+	struct sockaddr_storage address;
+	struct sockaddr __user *uaddr;
+	int __user *ulen;
+	unsigned int peer;
+
+	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	ulen = u64_to_user_ptr(sqe->addr3);
+	peer = READ_ONCE(sqe->optlen);
+
+	if (sqe->ioprio || sqe->__pad1 || sqe->len || sqe->rw_flags)
+		return -EINVAL;
+	if (peer > 1)
+		return -EINVAL;
+	return do_getsockname(sock, &address, 0, uaddr, ulen);
+}
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -159,6 +181,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
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


