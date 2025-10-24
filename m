Return-Path: <io-uring+bounces-10196-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E243C0718E
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 17:54:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB21719A7696
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 15:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5333413C695;
	Fri, 24 Oct 2025 15:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SAUzcAw6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2Lz3q23i";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SAUzcAw6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2Lz3q23i"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E8332E72F
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 15:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761321130; cv=none; b=nhU1aO9aVvZXdaXYdeVvA0Deqqg377Ulf1+j3GPI0vZhLD7MRwKv6UILm6POQevnNoBEWCUVScZAeSOwLTpy2R3baOAOHSIeaHHfXELHzAl+VqQg6VmDyxBeMA+J2g3XSlZBvKl+JzrnygBwo2/Ckw9gmxj2Ip/czLMR7hDkiWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761321130; c=relaxed/simple;
	bh=mKUxUD5yC3b7KxJv+vB7u1N0phtepp68nS+kYM8un5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhglqcU0ObaB5j/+swVZKVuLX6uLjz1dNKSeTR8Lx+iAs5DnJhmZisAIMo5egR9MKgazFLWrpT3XvS2ZwLTchGn6wwAGeavczaRS9W+V12Wbau0hmb1Zc80mx9f/DSc5DHLuJAlPGMnrLxC1/3H0pY6W+akrmHbsUD5tnGEx3Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SAUzcAw6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2Lz3q23i; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SAUzcAw6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2Lz3q23i; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5B9A31F443;
	Fri, 24 Oct 2025 15:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761321118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Np34QneQEkjW0XZKz8KmZK6DRrV9T0SmoPFOyQwtsK0=;
	b=SAUzcAw6plDERbPOpsXG1bbPf7yelOowp1r8+kCHoMWfI8KhQ/cfmG4xQzaUoDe0yLZafD
	OH01SemmjvDnI30KWlRKEF+NigUj6Z3jncmyecMTvV/0QqOIXsmydxto6O6/+qQ07ITCi/
	EYMcBq0s/RiNrWmAfMtdby4xlnpAQ60=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761321118;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Np34QneQEkjW0XZKz8KmZK6DRrV9T0SmoPFOyQwtsK0=;
	b=2Lz3q23i19O+wxIRR9dpbxgvuMvieFMcJi3n9Lu8Sjr7PoLzZKUvd280rQvzYtAO0qn/dT
	KmyPmv8aYLSpi4CA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761321118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Np34QneQEkjW0XZKz8KmZK6DRrV9T0SmoPFOyQwtsK0=;
	b=SAUzcAw6plDERbPOpsXG1bbPf7yelOowp1r8+kCHoMWfI8KhQ/cfmG4xQzaUoDe0yLZafD
	OH01SemmjvDnI30KWlRKEF+NigUj6Z3jncmyecMTvV/0QqOIXsmydxto6O6/+qQ07ITCi/
	EYMcBq0s/RiNrWmAfMtdby4xlnpAQ60=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761321118;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Np34QneQEkjW0XZKz8KmZK6DRrV9T0SmoPFOyQwtsK0=;
	b=2Lz3q23i19O+wxIRR9dpbxgvuMvieFMcJi3n9Lu8Sjr7PoLzZKUvd280rQvzYtAO0qn/dT
	KmyPmv8aYLSpi4CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1FABF132C2;
	Fri, 24 Oct 2025 15:51:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VhUUOp2g+2gbFAAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 24 Oct 2025 15:51:57 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 3/4] bind-listen.t: Add tests for getsockname
Date: Fri, 24 Oct 2025 11:51:34 -0400
Message-ID: <20251024155135.798465-4-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024155135.798465-1-krisman@suse.de>
References: <20251024155135.798465-1-krisman@suse.de>
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
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 test/bind-listen.c | 104 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 2 deletions(-)

diff --git a/test/bind-listen.c b/test/bind-listen.c
index 7c229a17..22dd9a32 100644
--- a/test/bind-listen.c
+++ b/test/bind-listen.c
@@ -138,7 +138,7 @@ static int test_good_server(unsigned int ring_flags)
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	struct io_uring ring;
-	int ret;
+	int ret, port;
 	int fds[3];
 	char buf[1024];
 
@@ -179,7 +179,7 @@ static int test_good_server(unsigned int ring_flags)
 		return T_SETUP_SKIP;
 	}
 
-	/* Wait for a request */
+	/* Wait for a connection */
 	sqe = io_uring_get_sqe(&ring);
 	io_uring_prep_accept_direct(sqe, SRV_INDEX, NULL, NULL, 0, CONN_INDEX);
 	sqe->flags |= IOSQE_FIXED_FILE;
@@ -192,6 +192,30 @@ static int test_good_server(unsigned int ring_flags)
 	}
 	io_uring_cqe_seen(&ring, cqe);
 
+	/* Test that getsockname on the peer (getpeername) yields a
+         * sane result.
+	 */
+	sqe = io_uring_get_sqe(&ring);
+	saddr_len = sizeof(saddr);
+	port = saddr.sin_port;
+	io_uring_prep_cmd_getsockname(sqe, CONN_INDEX, (struct sockaddr*)&saddr,
+				      &saddr_len, 1);
+	sqe->flags |= IOSQE_FIXED_FILE;
+	io_uring_submit(&ring);
+	io_uring_wait_cqe(&ring, &cqe);
+	if (cqe->res < 0) {
+		fprintf(stderr, "getsockname client failed. %d\n", cqe->res);
+		return T_EXIT_FAIL;
+	} else {
+		if (saddr.sin_addr.s_addr != htonl(INADDR_LOOPBACK) ||
+		    saddr.sin_port != port) {
+			fprintf(stderr, "getsockname peer got wrong address: %s:%d\n",
+				inet_ntoa(saddr.sin_addr), saddr.sin_port);
+			return T_EXIT_FAIL;
+		}
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
 	sqe = io_uring_get_sqe(&ring);
 	io_uring_prep_recv(sqe, CONN_INDEX, buf, sizeof(buf), 0);
 	sqe->flags |= IOSQE_FIXED_FILE;
@@ -368,6 +392,77 @@ fail:
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
@@ -417,5 +512,10 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
+	ret = test_bad_sockname();
+	if (ret) {
+		fprintf(stderr, "bad sockname failed\n");
+		return T_EXIT_FAIL;
+	}
 	return T_EXIT_PASS;
 }
-- 
2.51.0


