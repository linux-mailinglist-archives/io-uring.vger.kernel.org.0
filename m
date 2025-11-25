Return-Path: <io-uring+bounces-10777-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 68E3FC82EE2
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 01:24:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B2E1F34B2B0
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 00:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF9111E2834;
	Tue, 25 Nov 2025 00:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Xz4F+2LJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kAz0c3lz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="M+XOFNZG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QQOHtKeC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB431DF985
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 00:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764030259; cv=none; b=Vdms47pxCGq6yX298oPfpUTYjFBNL/4BFHka2KZvgXlCeXOFHqGLGAS44CniEqYoZpY8IRWGrV7pLpzQYNRN9ga1tfra/V+oyM4FmlEE3PLS0v1lbUxzHTwLza8RSWdqg5VXiVDOVqf9iddlcOs/RLGVUYbOsaF458DSsrR65Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764030259; c=relaxed/simple;
	bh=r1zjOHFjCHbViSIsmhrQEyGybO5oXcctg2lsCTrUgGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsQZGDBCaoJ9s27w6Bb3rFia/Zpm8Jaf9wXZmjuPQ5nydQsehMTSMOr+KQdoQu6OThoxYfW8kYOONcVqDv7IU4Lsvj3fp18Jlu9SWgcUY068qPJVqIIZi/V35KkrsC0pmQRDl9kJPINbL2Ouu7+zTksi2e9FKaHVU9o04KIRpq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Xz4F+2LJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kAz0c3lz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=M+XOFNZG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QQOHtKeC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B17985BCC2;
	Tue, 25 Nov 2025 00:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764030256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+iBdZOmN23xj/485VAkhIkVR20tfBcL9I30wrE8gPoM=;
	b=Xz4F+2LJbMlOPzAbFIcq4GaI0aaxRQZP0hO6qFGIAMdWMz1xW6+yWHPGXxXWmw9AEvRvH/
	qPtPjrjkuDUic5svA2PsWB4gi1DvRx8JkAOh5KRgXQf5qphZ8A5BdyE7VyeTYN7zx/IXs/
	h6Q33OdhFfH0EJ7Iy3p5VYivYXJ3bKo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764030256;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+iBdZOmN23xj/485VAkhIkVR20tfBcL9I30wrE8gPoM=;
	b=kAz0c3lz9tV4cqeGKDJm6GKO+/MI2WWP033Amet08YZt2w2tY6Feik6AUbN/XnDWcvg5ND
	3UiUPhiSKqUpudBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764030254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+iBdZOmN23xj/485VAkhIkVR20tfBcL9I30wrE8gPoM=;
	b=M+XOFNZGfP4LICumRXkvlght+GxMa8KF2UhlkrudvauAFvLuvQ8lkpm5fc70qsam7FwBoV
	sDbHS3AZFdyVyBy7xO5u2xKPvGEFmnGAsGNMzYs3Cdy1f+AszjboFiHj4+j/zYLC3o/toh
	mygLrMPZE0bG4tvTV3GXtcrtTw3p4o4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764030254;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+iBdZOmN23xj/485VAkhIkVR20tfBcL9I30wrE8gPoM=;
	b=QQOHtKeCRwUb2Df+Yo7X9Maj/+XdlcGX8aVLIaH6WJgqapEIjI64JPXNqZ6BLwZZ3pu9t+
	+9EY9aOlhmwhTBBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 600A93EA63;
	Tue, 25 Nov 2025 00:24:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SVZPCy73JGmKQQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 25 Nov 2025 00:24:14 +0000
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
Subject: [PATCH v3 3/3] io_uring: Introduce getsockname io_uring cmd
Date: Mon, 24 Nov 2025 19:23:43 -0500
Message-ID: <20251125002345.2130897-4-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251125002345.2130897-1-krisman@suse.de>
References: <20251125002345.2130897-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
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
v2->v3:
Don't pass sockaddr_storage pointer parameter
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/cmd_net.c            | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

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
index 27a09aa4c9d0..a2d76157df4f 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -132,6 +132,26 @@ static int io_uring_cmd_timestamp(struct socket *sock,
 	return -EAGAIN;
 }
 
+static int io_uring_cmd_getsockname(struct socket *sock,
+				    struct io_uring_cmd *cmd,
+				    unsigned int issue_flags)
+{
+	const struct io_uring_sqe *sqe = cmd->sqe;
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
+	return do_getsockname(sock, 0, uaddr, ulen);
+}
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -159,6 +179,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
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


