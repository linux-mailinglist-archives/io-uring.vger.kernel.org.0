Return-Path: <io-uring+bounces-10936-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE251CA17A2
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 20:52:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BE82930050B5
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 19:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126A72609C5;
	Wed,  3 Dec 2025 19:52:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A552FFF90
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 19:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764791570; cv=none; b=iaYQJK6udx2/fh6mksY7PMKt1L/XSNOMjc2OYbu9VMKxLcmZztXPJPLa0c9MGVhnB8+iZZlfLK3EaBcSLFWRn7O8citfVzbOJXvpRlf8LuPHklDT7RB/mjFPm0lC8b30Y4fk+ubNkF2m6wleI2qII+fYfr60QfeEcTuSahkSVhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764791570; c=relaxed/simple;
	bh=AgHM/zynbIsLBTeObuzSQ1PQfU6viYqVUvN4RG3DvVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1pbB+zKBGAiUtaCx8v+NQpscwHgAa4jAHzJgyd9hOjzPQgcFTFCrL/aQar+Df0MypyTLpdOfp/C2tz5a9ZDLD9y3RizdLDPjTY9/HV852qXOGNOu4kvFYEWjMx9fM8Pj5fYWWvyLhVS0rPbuV2mMenCRFOX8/L+TLjLVAZGe7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7E9205BD47;
	Wed,  3 Dec 2025 19:52:46 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B9B03EA63;
	Wed,  3 Dec 2025 19:52:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5hMXCA6VMGldUAAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 03 Dec 2025 19:52:46 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	io-uring@vger.kernel.org,
	csander@purestorage.com
Subject: [PATCH liburing v3 3/4] bind-listen.t: Add tests for getsockname
Date: Wed,  3 Dec 2025 14:52:17 -0500
Message-ID: <20251203195223.3578559-4-krisman@suse.de>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 7E9205BD47
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Rspamd-Action: no action

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 test/bind-listen.c | 99 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 96 insertions(+), 3 deletions(-)

diff --git a/test/bind-listen.c b/test/bind-listen.c
index a468aa94..38200879 100644
--- a/test/bind-listen.c
+++ b/test/bind-listen.c
@@ -202,7 +202,7 @@ static int test_good_server(unsigned int ring_flags)
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	struct io_uring ring;
-	int ret;
+	int ret, port;
 	int fds[3];
 	char buf[1024];
 
@@ -235,7 +235,7 @@ static int test_good_server(unsigned int ring_flags)
 		return T_SETUP_SKIP;
 	}
 
-	/* Wait for a request */
+	/* Wait for a connection */
 	sqe = io_uring_get_sqe(&ring);
 	io_uring_prep_accept_direct(sqe, SRV_INDEX, NULL, NULL, 0, CONN_INDEX);
 	sqe->flags |= IOSQE_FIXED_FILE;
@@ -248,6 +248,22 @@ static int test_good_server(unsigned int ring_flags)
 	}
 	io_uring_cqe_seen(&ring, cqe);
 
+	/* Test that getsockname on the peer (getpeername) yields a
+	 * sane result.
+	 */
+	port = saddr.sin_port;
+	saddr.sin_port = 0;
+	if (do_getsockname(&ring, CLI_INDEX, 1,
+			   (struct sockaddr*)&saddr, &saddr_len))
+		return T_EXIT_FAIL;
+
+	if (saddr.sin_addr.s_addr != htonl(INADDR_LOOPBACK) ||
+	    saddr.sin_port != port) {
+		fprintf(stderr, "getsockname peer got wrong address: %s:%d\n",
+			inet_ntoa(saddr.sin_addr), saddr.sin_port);
+		return T_EXIT_FAIL;
+	}
+
 	sqe = io_uring_get_sqe(&ring);
 	io_uring_prep_recv(sqe, CONN_INDEX, buf, sizeof(buf), 0);
 	sqe->flags |= IOSQE_FIXED_FILE;
@@ -424,6 +440,77 @@ fail:
 	return ret;
 }
 
+static int test_bad_sockname(void)
+{
+	struct sockaddr_in saddr;
+	socklen_t saddr_len;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	int sock = -1, err;
+	int ret = T_EXIT_FAIL;
+
+	memset(&saddr, 0, sizeof(struct sockaddr_in));
+	saddr.sin_family = AF_INET;
+	saddr.sin_port = htons(8001);
+	saddr.sin_addr.s_addr = htons(INADDR_ANY);
+
+	err = t_create_ring(1, &ring, 0);
+	if (err < 0) {
+		fprintf(stderr, "queue_init: %d\n", err);
+		return T_SETUP_SKIP;
+	}
+
+	sock = socket(AF_INET, SOCK_STREAM, 0);
+	if (sock < 0) {
+		perror("socket");
+		goto fail;
+	}
+
+	err = t_bind_ephemeral_port(sock, &saddr);
+	if (err) {
+		fprintf(stderr, "bind: %s\n", strerror(-err));
+		goto fail;
+	}
+
+	/* getsockname on a !socket fd.  with getsockname(2), this would
+	 * return -ENOTSOCK, but we can't do it in an io_uring_cmd.
+	 */
+	sqe = io_uring_get_sqe(&ring);
+	saddr_len = sizeof(saddr);
+	io_uring_prep_cmd_getsockname(sqe, 1, (struct sockaddr*)&saddr, &saddr_len, 0);
+	err = io_uring_submit(&ring);
+	if (err < 0)
+		goto fail;
+	err = io_uring_wait_cqe(&ring, &cqe);
+	if (err)
+		goto fail;
+	if (cqe->res != -ENOTSUP)
+		goto fail;
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* getsockname with weird parameters */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_cmd_getsockname(sqe, sock, (struct sockaddr*)&saddr,
+				      &saddr_len, 3);
+	err = io_uring_submit(&ring);
+	if (err < 0)
+		goto fail;
+	err = io_uring_wait_cqe(&ring, &cqe);
+	if (err)
+		goto fail;
+	if (cqe->res != -EINVAL)
+		goto fail;
+	io_uring_cqe_seen(&ring, cqe);
+
+	ret = T_EXIT_PASS;
+fail:
+	io_uring_queue_exit(&ring);
+	if (sock != -1)
+		close(sock);
+	return ret;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring_probe *probe;
@@ -472,6 +559,12 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "bad listen failed\n");
 		return T_EXIT_FAIL;
 	}
-
+	if (!no_getsockname) {
+		ret = test_bad_sockname();
+		if (ret) {
+			fprintf(stderr, "bad sockname failed\n");
+			return T_EXIT_FAIL;
+		}
+	}
 	return T_EXIT_PASS;
 }
-- 
2.52.0


