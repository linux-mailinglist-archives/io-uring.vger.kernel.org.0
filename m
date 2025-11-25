Return-Path: <io-uring+bounces-10799-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 304F1C8739F
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 22:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A5CF934E94D
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 21:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8742E0B6E;
	Tue, 25 Nov 2025 21:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z27m2c13";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ifoUVdEe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z27m2c13";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ifoUVdEe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDD82264A9
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 21:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764106054; cv=none; b=AvqR2yEe87ncSGCmPjOslHv8PA5tbdWIyEOaF5weSU8hTsd8c+KKbZdS4kxetP4iqOwbmAOilyqr7CCYeMYe27g/ojXbKf83jk7Hu/rfRF+IOKS2HMWyg9/NBK/yUy3OdgWlvJPCk61eYjiTNE4OLQ/2JcVO9uKZzTcdFueArfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764106054; c=relaxed/simple;
	bh=K4wWkhTRIZpgaI9jd9MMxoRj9WMh0VdTghzt7kCMFU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gbm4znh/OqPZ1j0oTqm3h2CL8TzAJkXIHg/GqraHvaxQI3u/YphO7INXFjoszSVZJBEFQtpevnBPE1yJ++VJL1mMMwTiAtnBrYqYrn2M1LAPi6e7JqSGGcfU2RBKTU+YF5QKmJQtcSyNuvnzXokyZJ6KH5dHl+hUXSyyZJJU4+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z27m2c13; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ifoUVdEe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z27m2c13; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ifoUVdEe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9FE4522965;
	Tue, 25 Nov 2025 21:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764106050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7yHmj2ZMuwxjXFQWUY4qRE5/7DiJmPt5/jn00l13o0=;
	b=z27m2c13GTzH+sjOkul8ZJArdZp6umWPRJn3nW5OV5kxZbPHvlpB1suVwjtrbZWnl8uo/4
	h5fcMTJNc5ndaonCF9/j9HpRHwtFsURed6/j9tQHUAv0Ae5nrNYgphS8cMRKX0hK+JblW6
	c1v1KyIkN5C4bgquOv138e+Dw0q4v1U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764106050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7yHmj2ZMuwxjXFQWUY4qRE5/7DiJmPt5/jn00l13o0=;
	b=ifoUVdEeSW+cC5Y8eiv09JfOkTHffzchUn5GYlHS/NDRy2tao9lVPZS64KP6inpjjPBMsk
	Nn7eOSC8anbN6yAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764106050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7yHmj2ZMuwxjXFQWUY4qRE5/7DiJmPt5/jn00l13o0=;
	b=z27m2c13GTzH+sjOkul8ZJArdZp6umWPRJn3nW5OV5kxZbPHvlpB1suVwjtrbZWnl8uo/4
	h5fcMTJNc5ndaonCF9/j9HpRHwtFsURed6/j9tQHUAv0Ae5nrNYgphS8cMRKX0hK+JblW6
	c1v1KyIkN5C4bgquOv138e+Dw0q4v1U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764106050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7yHmj2ZMuwxjXFQWUY4qRE5/7DiJmPt5/jn00l13o0=;
	b=ifoUVdEeSW+cC5Y8eiv09JfOkTHffzchUn5GYlHS/NDRy2tao9lVPZS64KP6inpjjPBMsk
	Nn7eOSC8anbN6yAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 635173EA63;
	Tue, 25 Nov 2025 21:27:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bR+4EUIfJmmqdwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 25 Nov 2025 21:27:30 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	csander@purestorage.com
Subject: [PATCH liburing v2 2/4] test/bind-listen.t: Use ephemeral port
Date: Tue, 25 Nov 2025 16:27:13 -0500
Message-ID: <20251125212715.2679630-3-krisman@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -6.80

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


