Return-Path: <io-uring+bounces-10708-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C8AC7671C
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 22:59:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 10CCC2C4DC
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 21:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AFC2FB99E;
	Thu, 20 Nov 2025 21:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CMvZpalP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xrDDOF3Q";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CMvZpalP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xrDDOF3Q"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A9F311C3C
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 21:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675948; cv=none; b=XiurijGyleXTF7e0xu8UpGQ0G7UYlAueMlTsgu4j6DNZVDCrTV6RBAF9f4Y5IHVJ5PLdjpjtAoX+joNQOTqOh+vqw3HMmuy+DNQTzWJqaecVBIxre+fLrGM9XF4Du8WEwWbbSF2YzZQYhblL5c+Q4yJdxQkg/unQqTrryZ0rWSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675948; c=relaxed/simple;
	bh=koPu2OS4xs2Z4RrjCJxtqJsDcimXkzohnNY5nQoIwWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHEpjZzqK3os1E930AeZHZTT3ZxSVxYUYQGUfNMsvRXrHcw9WCL+dmIMU4rPqwU1O93GCNOnJlECO/lfth2Y6W1ZsPV5rYk6icpMJhBOBdwbLapu0dzxOObbhHWwJreESYxeAbXxBrdy6F8YtIf7DqLGR7gXJ3iRci4LseSJb/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CMvZpalP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xrDDOF3Q; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CMvZpalP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xrDDOF3Q; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 90897219AD;
	Thu, 20 Nov 2025 21:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763675944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CTpNjXSsCTmHJMrUSKi4P8HbQHsbxi7mOf8yVHunwO4=;
	b=CMvZpalP5PML4p752BxmXnaXpikBCtdUedOTgIuIvqRr62O2Xi0EqYT6ChqxWBUoUXxtnG
	Z3tP9bl8AfHgnAI9qkW8hgBsgERDCCYZ4IyYFK7bEIMXaynKlVFJ3Rya98AYwaJtZHXyeY
	fvf29eLOt5JTbEEmcd8qAnTRC+Aw8vo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763675944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CTpNjXSsCTmHJMrUSKi4P8HbQHsbxi7mOf8yVHunwO4=;
	b=xrDDOF3QwRmx+p+mvpJp9jcEiVwuDzaTsLjJuj/PUj+FKq6oQ9WuHkpoAmPi/1vCYMmf7Y
	N9PPhdlYCbduBvBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763675944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CTpNjXSsCTmHJMrUSKi4P8HbQHsbxi7mOf8yVHunwO4=;
	b=CMvZpalP5PML4p752BxmXnaXpikBCtdUedOTgIuIvqRr62O2Xi0EqYT6ChqxWBUoUXxtnG
	Z3tP9bl8AfHgnAI9qkW8hgBsgERDCCYZ4IyYFK7bEIMXaynKlVFJ3Rya98AYwaJtZHXyeY
	fvf29eLOt5JTbEEmcd8qAnTRC+Aw8vo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763675944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CTpNjXSsCTmHJMrUSKi4P8HbQHsbxi7mOf8yVHunwO4=;
	b=xrDDOF3QwRmx+p+mvpJp9jcEiVwuDzaTsLjJuj/PUj+FKq6oQ9WuHkpoAmPi/1vCYMmf7Y
	N9PPhdlYCbduBvBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D26C3EA61;
	Thu, 20 Nov 2025 21:59:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sWe5AiiPH2l3dgAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 20 Nov 2025 21:59:04 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: 
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
Date: Thu, 20 Nov 2025 16:58:14 -0500
Message-ID: <20251120215816.3787271-4-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251120215816.3787271-1-krisman@suse.de>
References: <20251120215816.3787271-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

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


