Return-Path: <io-uring+bounces-10195-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 599FCC0716A
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 17:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7B0E3A3FA4
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 15:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A889A322C99;
	Fri, 24 Oct 2025 15:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w10TUC3D";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="STL2WZ1H";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w10TUC3D";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="STL2WZ1H"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066B221D3C9
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761321124; cv=none; b=PjLUfmSKxu9JoA2dq7bGjHjXOjz78U5zuQ5lP6kCBEbii1q5VHUJR9ZI+KQeBptJvQhF/0E22+gyntSpCXQkl4GELZn/bsLHHyNPpopDRnZAWRYH1kaETAEPPYmp24eiGd5Lzmeitj6bHyHqrImVx6cWGBo6xM9TEbjpNMUY0EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761321124; c=relaxed/simple;
	bh=K4wWkhTRIZpgaI9jd9MMxoRj9WMh0VdTghzt7kCMFU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlA+joalW3zWI+MrhtEkylQWtmnP5Z3v7n/LSFy1/xdaLbq+0SBZJEy2RBd6lXaUmJ6HoBKzLXox3BcCHKyOcZnfOUQpRlSYPXB72+L94+px1pd5tBA7qiqlBFaE3ur9d/VDTihLfQsvF47MIsIfS2w0/VYPbW21lmmIr+GDguo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=w10TUC3D; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=STL2WZ1H; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=w10TUC3D; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=STL2WZ1H; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3DC511F45A;
	Fri, 24 Oct 2025 15:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761321116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7yHmj2ZMuwxjXFQWUY4qRE5/7DiJmPt5/jn00l13o0=;
	b=w10TUC3DobaXkG3pdQZOG6NxNHdzHL+nAHwdhpSH3FS0SlJP3J69/rT96RRU6/nw+mgaIm
	BGMJ0eBWpfeH/eqppVQaSMJM+FdzilVif2BTT6IsVS1ahJnA9qKn8SXo9sPBUrQK9ie69H
	9rhfjysp9jtATPwYRlKIzaGmR8VFBsQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761321116;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7yHmj2ZMuwxjXFQWUY4qRE5/7DiJmPt5/jn00l13o0=;
	b=STL2WZ1H+/b71NEFqK2bhYFRD3dkgUg1c+rLoN+UtPH1I7Aa6UEYdUMexkIu3sjNsplyPj
	hu1M7Sdq8hRuBnAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w10TUC3D;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=STL2WZ1H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761321116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7yHmj2ZMuwxjXFQWUY4qRE5/7DiJmPt5/jn00l13o0=;
	b=w10TUC3DobaXkG3pdQZOG6NxNHdzHL+nAHwdhpSH3FS0SlJP3J69/rT96RRU6/nw+mgaIm
	BGMJ0eBWpfeH/eqppVQaSMJM+FdzilVif2BTT6IsVS1ahJnA9qKn8SXo9sPBUrQK9ie69H
	9rhfjysp9jtATPwYRlKIzaGmR8VFBsQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761321116;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7yHmj2ZMuwxjXFQWUY4qRE5/7DiJmPt5/jn00l13o0=;
	b=STL2WZ1H+/b71NEFqK2bhYFRD3dkgUg1c+rLoN+UtPH1I7Aa6UEYdUMexkIu3sjNsplyPj
	hu1M7Sdq8hRuBnAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E23C7132C2;
	Fri, 24 Oct 2025 15:51:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JaT0Kpug+2gYFAAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 24 Oct 2025 15:51:55 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 2/4] test/bind-listen.t: Use ephemeral port
Date: Fri, 24 Oct 2025 11:51:33 -0400
Message-ID: <20251024155135.798465-3-krisman@suse.de>
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
X-Rspamd-Queue-Id: 3DC511F45A
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
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

This test fails if port 8000 is already in use by something else.  Now
that we have getsockname with direct file descriptors, use an ephemeral
port instead.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 test/bind-listen.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/test/bind-listen.c b/test/bind-listen.c
index 6f80f177..7c229a17 100644
--- a/test/bind-listen.c
+++ b/test/bind-listen.c
@@ -22,7 +22,6 @@ static void msec_to_ts(struct __kernel_timespec *ts, unsigned int msec)
 }
 
 static const char *magic = "Hello World!";
-static int use_port = 8000;
 
 enum {
 	SRV_INDEX = 0,
@@ -74,18 +73,19 @@ static int connect_client(struct io_uring *ring, unsigned short peer_port)
 	return T_SETUP_OK;
 }
 
-static int setup_srv(struct io_uring *ring, struct sockaddr_in *server_addr)
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
@@ -98,7 +98,7 @@ static int setup_srv(struct io_uring *ring, struct sockaddr_in *server_addr)
 	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
 
 	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_bind(sqe, SRV_INDEX, (struct sockaddr *) server_addr,
+	io_uring_prep_bind(sqe, SRV_INDEX, (struct sockaddr *) &server_addr,
 			   sizeof(struct sockaddr_in));
 	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
 
@@ -132,7 +132,8 @@ static int setup_srv(struct io_uring *ring, struct sockaddr_in *server_addr)
 
 static int test_good_server(unsigned int ring_flags)
 {
-	struct sockaddr_in server_addr;
+	struct sockaddr_in saddr = {};
+	socklen_t saddr_len = sizeof(saddr);
 	struct __kernel_timespec ts;
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
@@ -155,13 +156,25 @@ static int test_good_server(unsigned int ring_flags)
 		return T_SETUP_SKIP;
 	}
 
-	ret = setup_srv(&ring, &server_addr);
+	ret = setup_srv(&ring);
 	if (ret != T_SETUP_OK) {
 		fprintf(stderr, "srv startup failed.\n");
 		return T_EXIT_FAIL;
 	}
 
-	if (connect_client(&ring, server_addr.sin_port) != T_SETUP_OK) {
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_cmd_getsockname(sqe, SRV_INDEX, (struct sockaddr*)&saddr,
+				      &saddr_len, 0);
+	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
+	io_uring_submit(&ring);
+	io_uring_wait_cqe(&ring, &cqe);
+	if (cqe->res < 0) {
+		fprintf(stderr, "getsockname server failed. %d\n", cqe->res);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	if (connect_client(&ring, saddr.sin_port) != T_SETUP_OK) {
 		fprintf(stderr, "cli startup failed.\n");
 		return T_SETUP_SKIP;
 	}
-- 
2.51.0


