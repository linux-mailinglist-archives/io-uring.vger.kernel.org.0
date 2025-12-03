Return-Path: <io-uring+bounces-10934-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F26D7CA180D
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 20:56:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F8263014AEC
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 19:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC272F3C1D;
	Wed,  3 Dec 2025 19:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NL4+B9pz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cOikvD9y";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NL4+B9pz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cOikvD9y"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C683009F1
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 19:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764791557; cv=none; b=QCwXiOtfGGz5nfs4d38j1Op2a+puyyFqiZPciZZiTK05C48e6+DhcBlvLNoZrXZb8EB0satmrlsbKnGnqPnw6fYIvXCTO6AXXTSvWAPNXfwhjAtBwIMYKk1+fLbW2EJrKU2teUqlo8QP5ozsQ63sPr9wz1Op+ixEov/9zxozQzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764791557; c=relaxed/simple;
	bh=mktz2+hjBRo/C/AtryOU8krq8TbUcv220U1dtYzBNlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfWCgZyqTSYWh/FQNcgLzE4sncEyizWf9oJNkvLjz1Y4hESYYrBLGXsn7b3xxzPl4ljX3habkt0anuQ1RYlLSZ2wgONR3IVhpT5shEpw2/SuxehibsGVVAmWsFMYl3elKT5qlD2AnDFMQK+me047Y2Pjn9g5Xlvv9jQMnu4iizc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NL4+B9pz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cOikvD9y; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NL4+B9pz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cOikvD9y; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E189C5BD4C;
	Wed,  3 Dec 2025 19:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764791553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LIA7JGTZNX4T3OuCYO0oZSjN2X+oX3eEuaYPRVL90bQ=;
	b=NL4+B9pz4Z91xXkJKS2SwWGG3tiHaEkeUJIGjIY2eiw1XZs0KlhHIlL8igtrCbpZEWg//D
	HNcgdKql8vKZw5aIytaZ3KtDPxsyj+iJNztMEqqkOzFvF76WBxrC2gSK3v8Sg+eqeyDS5z
	yu3CZwvOIAELIzegwPwVEEPqBskyMp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764791553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LIA7JGTZNX4T3OuCYO0oZSjN2X+oX3eEuaYPRVL90bQ=;
	b=cOikvD9yg8tBg3dBybUCI08royeQrVOJDyaof4hyHZUAVCm/bw8goMWYo+VtUw4tY2m/8p
	oPKg28m0ZtHYBhDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764791553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LIA7JGTZNX4T3OuCYO0oZSjN2X+oX3eEuaYPRVL90bQ=;
	b=NL4+B9pz4Z91xXkJKS2SwWGG3tiHaEkeUJIGjIY2eiw1XZs0KlhHIlL8igtrCbpZEWg//D
	HNcgdKql8vKZw5aIytaZ3KtDPxsyj+iJNztMEqqkOzFvF76WBxrC2gSK3v8Sg+eqeyDS5z
	yu3CZwvOIAELIzegwPwVEEPqBskyMp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764791553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LIA7JGTZNX4T3OuCYO0oZSjN2X+oX3eEuaYPRVL90bQ=;
	b=cOikvD9yg8tBg3dBybUCI08royeQrVOJDyaof4hyHZUAVCm/bw8goMWYo+VtUw4tY2m/8p
	oPKg28m0ZtHYBhDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 781683EA63;
	Wed,  3 Dec 2025 19:52:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z9IHEQGVMGnOTwAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 03 Dec 2025 19:52:33 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	io-uring@vger.kernel.org,
	csander@purestorage.com
Subject: [PATCH liburing v3 1/4] liburing: Introduce getsockname operation
Date: Wed,  3 Dec 2025 14:52:15 -0500
Message-ID: <20251203195223.3578559-2-krisman@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-0.982];
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

This implements the functionality of getsockname(2) and getpeername(2)
under a single operation.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 src/include/liburing.h          | 13 +++++++++++++
 src/include/liburing/io_uring.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 83819eb7..1626f3bb 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1572,6 +1572,19 @@ IOURINGINLINE void io_uring_prep_cmd_sock(struct io_uring_sqe *sqe,
 	sqe->level = level;
 }
 
+IOURINGINLINE void io_uring_prep_cmd_getsockname(struct io_uring_sqe *sqe,
+						 int fd, struct sockaddr *sockaddr,
+						 socklen_t *sockaddr_len,
+						 int peer)
+	LIBURING_NOEXCEPT
+{
+	io_uring_prep_uring_cmd(sqe, SOCKET_URING_OP_GETSOCKNAME, fd);
+
+	sqe->addr = (uintptr_t) sockaddr;
+	sqe->addr3 = (unsigned long) (uintptr_t) sockaddr_len;
+	sqe->optlen = peer;
+}
+
 IOURINGINLINE void io_uring_prep_waitid(struct io_uring_sqe *sqe,
 					idtype_t idtype,
 					id_t id,
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index a54e5b42..8e8b8e6a 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -966,6 +966,7 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_GETSOCKOPT,
 	SOCKET_URING_OP_SETSOCKOPT,
 	SOCKET_URING_OP_TX_TIMESTAMP,
+	SOCKET_URING_OP_GETSOCKNAME,
 };
 
 /*
-- 
2.52.0


