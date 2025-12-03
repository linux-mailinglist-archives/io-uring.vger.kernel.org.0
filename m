Return-Path: <io-uring+bounces-10935-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 76CF0CA1810
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 20:56:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F19683017F02
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 19:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4279D2F3C1D;
	Wed,  3 Dec 2025 19:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="glPAtcIg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yoWOdlOl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="glPAtcIg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yoWOdlOl"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEC125B2FA
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 19:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764791564; cv=none; b=UrDBVpKnHMQL3Hd+YKISzlfIKf5++ME2Df33ApiRxQU5geozz+8ztv2Bi5EOcVsNvmZ7+Bk/sMTC/se6dckl0+OSHOjp0rmK5T0K038HiQGt5w5dYkkWVMKBhACFYppBQefmdyfjDqq8aNkn3/o6pqJN/iULEQ/JgVdn/OpHAnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764791564; c=relaxed/simple;
	bh=dXr+U9Xwj8QW2gVRKmmbe2MdRDqxg/ezCNi6fEanyy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jz1W3f8wuUT5k8f8kUg1/aE1O7gXCdzoOcjvOMgigfHHg/ShFV/iYQ9esw/WG29tsYxdJ7NQWgd7wFeKobhafnE3B6V1F81Wl8Hk930o9fdSsArt9RsJpt4wqYf5BzwtP6SaiHWbtoLHmdXqm13+B4Sp7omtnqBBxP/Lkgrzqg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=glPAtcIg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yoWOdlOl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=glPAtcIg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yoWOdlOl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 73F9B3368C;
	Wed,  3 Dec 2025 19:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764791560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9CxoV+e0Yd+4WhJTYZs7f4KdKTiEuUUO5laLe9gx+EA=;
	b=glPAtcIgb20YnD/Wx/gR4R2fbJAGmJwkJ14r85kTB6fJDDFwhuqf7fU9Tipuq+jjk1sQxW
	ryKmMUbhUTrP42Io1srZrcvWSwE22rnB0iZd1ZlWJiTsIEhk5osos0VsMc1BEwzLCaQXL1
	qaI7YzIjtXMpzeyX388p5OBbkvCGeu0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764791560;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9CxoV+e0Yd+4WhJTYZs7f4KdKTiEuUUO5laLe9gx+EA=;
	b=yoWOdlOlaMN2YxiD+Nzu0PfyLAFJovLgYLvvdeset3Jr58gRInK1lvrtP7ewd1a0W1TjGP
	L975W85URnHavcBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764791560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9CxoV+e0Yd+4WhJTYZs7f4KdKTiEuUUO5laLe9gx+EA=;
	b=glPAtcIgb20YnD/Wx/gR4R2fbJAGmJwkJ14r85kTB6fJDDFwhuqf7fU9Tipuq+jjk1sQxW
	ryKmMUbhUTrP42Io1srZrcvWSwE22rnB0iZd1ZlWJiTsIEhk5osos0VsMc1BEwzLCaQXL1
	qaI7YzIjtXMpzeyX388p5OBbkvCGeu0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764791560;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9CxoV+e0Yd+4WhJTYZs7f4KdKTiEuUUO5laLe9gx+EA=;
	b=yoWOdlOlaMN2YxiD+Nzu0PfyLAFJovLgYLvvdeset3Jr58gRInK1lvrtP7ewd1a0W1TjGP
	L975W85URnHavcBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 25BE13EA63;
	Wed,  3 Dec 2025 19:52:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /eXBAgiVMGnZTwAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 03 Dec 2025 19:52:40 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	io-uring@vger.kernel.org,
	csander@purestorage.com
Subject: [PATCH liburing v3 2/4] test/bind-listen.t: Use ephemeral port
Date: Wed,  3 Dec 2025 14:52:16 -0500
Message-ID: <20251203195223.3578559-3-krisman@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203195223.3578559-1-krisman@suse.de>
References: <20251203195223.3578559-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.986];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]

This test fails if port 8000 is already in use by something else.  Now
that we have getsockname with direct file descriptors, use an ephemeral
port instead.  To avoid regressing old systems, bite the bullet and do
the syscall version for older kernels, fixing the test there as well.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

---
since v2:
 - don't fail on older kernels
---
 test/bind-listen.c | 89 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 79 insertions(+), 10 deletions(-)

diff --git a/test/bind-listen.c b/test/bind-listen.c
index 6f80f177..a468aa94 100644
--- a/test/bind-listen.c
+++ b/test/bind-listen.c
@@ -22,7 +22,7 @@ static void msec_to_ts(struct __kernel_timespec *ts, unsigned int msec)
 }
 
 static const char *magic = "Hello World!";
-static int use_port = 8000;
+static bool no_getsockname = false;
 
 enum {
 	SRV_INDEX = 0,
@@ -74,18 +74,82 @@ static int connect_client(struct io_uring *ring, unsigned short peer_port)
 	return T_SETUP_OK;
 }
 
-static int setup_srv(struct io_uring *ring, struct sockaddr_in *server_addr)
+/*
+ * getsockname was added to the kernel a few releases after bind/listen.
+ * In order to provide a backward-compatible test, fallback to
+ * non-io-uring if we are on an older kernel, allowing the test to
+ * continue.
+ */
+static int do_getsockname(struct io_uring *ring, int direct_socket,
+			  int peer, struct sockaddr *saddr,
+			  socklen_t *saddr_len)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int res, fd;
+
+	if (!no_getsockname) {
+		/* attempt io_uring. Commmand might not exist */
+		sqe = io_uring_get_sqe(ring);
+		io_uring_prep_cmd_getsockname(sqe, direct_socket,
+					      saddr, saddr_len, peer);
+		sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
+		io_uring_submit(ring);
+		io_uring_wait_cqe(ring, &cqe);
+		res = cqe->res;
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	if (no_getsockname || res == -ENOTSUP) {
+		/*
+		 * Older kernel.  install the fd and use the getsockname
+		 * syscall.
+		 */
+		no_getsockname = true;
+
+		sqe = io_uring_get_sqe(ring);
+		io_uring_prep_fixed_fd_install(sqe, direct_socket, 0);
+		io_uring_submit(ring);
+		io_uring_wait_cqe(ring, &cqe);
+		fd = cqe->res;
+		io_uring_cqe_seen(ring, cqe);
+
+		if (fd < 0) {
+			fprintf(stderr, "installing direct fd failed. %d\n",
+				cqe->res);
+			return T_EXIT_FAIL;
+		}
+		if (peer)
+			res = getpeername(fd, saddr, saddr_len);
+		else
+			res = getsockname(fd, saddr, saddr_len);
+
+		if (res) {
+			fprintf(stderr, "get%sname syscall failed. %d\n",
+				peer? "peer":"sock", errno);
+			return T_EXIT_FAIL;
+		}
+		close(fd);
+	} else if (res < 0) {
+		fprintf(stderr, "getsockname server failed. %d\n", cqe->res);
+		return T_EXIT_FAIL;
+	}
+	return 0;
+}
+
+static int setup_srv(struct io_uring *ring)
 {
+	struct sockaddr_in server_addr;
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	struct __kernel_timespec ts;
 	int ret, val, submitted;
 	unsigned head;
 
-	memset(server_addr, 0, sizeof(struct sockaddr_in));
-	server_addr->sin_family = AF_INET;
-	server_addr->sin_port = htons(use_port++);
-	server_addr->sin_addr.s_addr = htons(INADDR_ANY);
+	memset(&server_addr, 0, sizeof(struct sockaddr_in));
+	server_addr.sin_family = AF_INET;
+	server_addr.sin_port = htons(0);
+	server_addr.sin_addr.s_addr = htons(INADDR_ANY);
 
 	sqe = io_uring_get_sqe(ring);
 	io_uring_prep_socket_direct(sqe, AF_INET, SOCK_STREAM, 0, SRV_INDEX, 0);
@@ -98,7 +162,7 @@ static int setup_srv(struct io_uring *ring, struct sockaddr_in *server_addr)
 	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
 
 	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_bind(sqe, SRV_INDEX, (struct sockaddr *) server_addr,
+	io_uring_prep_bind(sqe, SRV_INDEX, (struct sockaddr *) &server_addr,
 			   sizeof(struct sockaddr_in));
 	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
 
@@ -132,7 +196,8 @@ static int setup_srv(struct io_uring *ring, struct sockaddr_in *server_addr)
 
 static int test_good_server(unsigned int ring_flags)
 {
-	struct sockaddr_in server_addr;
+	struct sockaddr_in saddr = {};
+	socklen_t saddr_len = sizeof(saddr);
 	struct __kernel_timespec ts;
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
@@ -155,13 +220,17 @@ static int test_good_server(unsigned int ring_flags)
 		return T_SETUP_SKIP;
 	}
 
-	ret = setup_srv(&ring, &server_addr);
+	ret = setup_srv(&ring);
 	if (ret != T_SETUP_OK) {
 		fprintf(stderr, "srv startup failed.\n");
 		return T_EXIT_FAIL;
 	}
 
-	if (connect_client(&ring, server_addr.sin_port) != T_SETUP_OK) {
+	if (do_getsockname(&ring, SRV_INDEX, 0, (struct sockaddr*) &saddr,
+			   &saddr_len))
+		return T_EXIT_FAIL;
+
+	if (connect_client(&ring, saddr.sin_port) != T_SETUP_OK) {
 		fprintf(stderr, "cli startup failed.\n");
 		return T_SETUP_SKIP;
 	}
-- 
2.52.0


