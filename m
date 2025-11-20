Return-Path: <io-uring+bounces-10713-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50508C76776
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 23:15:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id AF3822C049
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 22:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E0C433FE12;
	Thu, 20 Nov 2025 22:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="n1K4Kg4n";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1/CxWijz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dMJA1/vT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bac3DdJJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC412FE567
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 22:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676859; cv=none; b=SmWNNA6DhmofVmr+WcI4gWbVrEMuH5B7dK9PsX5Exa7ppLeohAUe76qp3C8et/GhWZLA7eRxYIMIeBTiOP8w7hBVEzV57rWS+/H635oCEfOIsarUpe2oG+ov+U1Hfks4eMik8Hf2An9vxQEqh2eqSalvOVs8i4d4epig1hsY0Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676859; c=relaxed/simple;
	bh=mKUxUD5yC3b7KxJv+vB7u1N0phtepp68nS+kYM8un5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoMwiv0l9GCSxdlbMkxAdcAZ2pQwiT51IjaKw9nXu6e6nDsRyeLfQKET5+BtTb4VA6pnY88iIszZSuB6rpZw4SluFuQXbLeYAvSXr6/XcGmLBxk7mFPfT41U7RQY/2vbMwbPwn/Ce+ILqi2i67ku+O9O6Eag8s5GIen4lv0pnPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=n1K4Kg4n; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1/CxWijz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dMJA1/vT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bac3DdJJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4335420C79;
	Thu, 20 Nov 2025 22:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763676845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Np34QneQEkjW0XZKz8KmZK6DRrV9T0SmoPFOyQwtsK0=;
	b=n1K4Kg4n84FMMMFezW3E75c/Ej32ONhTZxis188hLBc3IYkz8avoWYf+TAUDAWsQiZyfd/
	HSA9Qtfmd4S3K3BpICo94CIwmZGexLoAHPvY5A3eIZ1qxbjkx76zkk3byrBI/3UxjG0xrK
	Xqorw4vSK/vlb9LWUoyyXPhp71Lsh8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763676845;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Np34QneQEkjW0XZKz8KmZK6DRrV9T0SmoPFOyQwtsK0=;
	b=1/CxWijzh0sOx4ZwprRnQ06TG1+X287HoOo7YW/Qn3duksM4lVY0dFntq4xb0WNg6frPOU
	cvNcKkoaQJ39K+CA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="dMJA1/vT";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bac3DdJJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763676844; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Np34QneQEkjW0XZKz8KmZK6DRrV9T0SmoPFOyQwtsK0=;
	b=dMJA1/vTI983tU/iXTSDBVp/PSFgaq27uaTSAbttF4iErnHRfEQoGHMnDC0tywJLDXuW8c
	zGfBw+cHdpL9P6y9VRKmyO58fbvv4QnHQCtiYVdto5M151VLfBxt++ZMW2Di9RsFx0YdMp
	9LtMIa0of+YlQ+GQpKp8naUwUTYGjO4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763676844;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Np34QneQEkjW0XZKz8KmZK6DRrV9T0SmoPFOyQwtsK0=;
	b=bac3DdJJ6XjfIHUBMvxNLNGUhR9F18W667o3P3BstFpMoEvwJ1O/4F9HvkNtQC81LsTFeH
	6FvzykpNosAEz0DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E74F13EA61;
	Thu, 20 Nov 2025 22:14:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zxMuMauSH2mmBQAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 20 Nov 2025 22:14:03 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: 
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	io-uring@vger.kernel.org,
	csander@purestorage.com
Subject: [PATCH liburing v2 3/4] bind-listen.t: Add tests for getsockname
Date: Thu, 20 Nov 2025 17:13:41 -0500
Message-ID: <20251120221351.3802738-4-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251120221351.3802738-1-krisman@suse.de>
References: <20251120221351.3802738-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4335420C79
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
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

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


