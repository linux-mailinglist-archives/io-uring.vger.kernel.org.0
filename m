Return-Path: <io-uring+bounces-10800-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 97239C873A2
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 22:27:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5A0844E6867
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 21:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FAA2264A9;
	Tue, 25 Nov 2025 21:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JSVeNuG/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="moyxxWwm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JSVeNuG/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="moyxxWwm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E43B231858
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 21:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764106055; cv=none; b=jskVcIVHJWGoOhc2NHG5jBU8hM3TZnhvQMMZ4+qjP/xncDqU74tejhYn0d+Y4P+/TgFKp/vuay52zV7lA5osjr6zcvP/qp7KD8K1+LvjuZhC/a8mdDVjKlskDEkyIPgmU7YKpzaMCMFtyUrqfcUglFgldNMSsXG2Tf0cwbdNW/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764106055; c=relaxed/simple;
	bh=Oj7BsSCX3dTSvRW1CRdAGYwdSI4ps9+8zmzrUgP8IeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Piz+6NBJv+6PM9lSUSJzlOT/ZQlc72UgzZvsmQlrMLQw9m0Y0f/UyQ2oIut69gXduJzawVXAaOCyO9UdzMWDxbJgDKl8vZxOgMlV0EW3MBoi8Nsl6xr0wGFSIXJHE9Lp+qEZ+1SpUIOGEZFjSs0Y+b9iELJejUSYfuCx+v6xe2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JSVeNuG/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=moyxxWwm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JSVeNuG/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=moyxxWwm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6CC9A5BD61;
	Tue, 25 Nov 2025 21:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764106052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2kCLqRr7X/GPI9hb+ENph1bjab5YgZew0gcIuREjhLI=;
	b=JSVeNuG/WY+2o4Y9gdwvfxHHB8mUxM0lxtDFBC864RdKNXTmRerMZm8hwNef2LisyG0zMx
	1MqLVnfcjnCd/XsmH8ARCpJlPQlRNIiXwFR6pveCE/jmbEjskn5Sks8iZr/wq6NCu16qqe
	Vn9TwFIyjtl/OZuV+Kd3hFiY4OAfdyc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764106052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2kCLqRr7X/GPI9hb+ENph1bjab5YgZew0gcIuREjhLI=;
	b=moyxxWwmKMbuWJfUB2wflDuJPfK8dxPFyDnd3uAQXajm4IxMpwSUDVLZWizuwnZt5YbAy9
	8RJJ5g3yJdQzqwAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764106052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2kCLqRr7X/GPI9hb+ENph1bjab5YgZew0gcIuREjhLI=;
	b=JSVeNuG/WY+2o4Y9gdwvfxHHB8mUxM0lxtDFBC864RdKNXTmRerMZm8hwNef2LisyG0zMx
	1MqLVnfcjnCd/XsmH8ARCpJlPQlRNIiXwFR6pveCE/jmbEjskn5Sks8iZr/wq6NCu16qqe
	Vn9TwFIyjtl/OZuV+Kd3hFiY4OAfdyc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764106052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2kCLqRr7X/GPI9hb+ENph1bjab5YgZew0gcIuREjhLI=;
	b=moyxxWwmKMbuWJfUB2wflDuJPfK8dxPFyDnd3uAQXajm4IxMpwSUDVLZWizuwnZt5YbAy9
	8RJJ5g3yJdQzqwAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30CF53EA63;
	Tue, 25 Nov 2025 21:27:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id t/hYBUQfJmnKdwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 25 Nov 2025 21:27:32 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	csander@purestorage.com
Subject: [PATCH liburing v2 3/4] bind-listen.t: Add tests for getsockname
Date: Tue, 25 Nov 2025 16:27:14 -0500
Message-ID: <20251125212715.2679630-4-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251125212715.2679630-1-krisman@suse.de>
References: <20251125212715.2679630-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -6.80

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 test/bind-listen.c | 104 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 2 deletions(-)

diff --git a/test/bind-listen.c b/test/bind-listen.c
index 7c229a17..d3e3c9c8 100644
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
+	io_uring_prep_cmd_getsockname(sqe, CLI_INDEX, (struct sockaddr*)&saddr,
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


