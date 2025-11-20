Return-Path: <io-uring+bounces-10710-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AD4A5C76770
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 23:14:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 564E23570D2
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 22:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D850634FF7B;
	Thu, 20 Nov 2025 22:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g0RTyCC1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8j0azgSo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g0RTyCC1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8j0azgSo"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C792FE567
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 22:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676840; cv=none; b=mZ8vNPeDZbfNZrehnEplqbyPaVyW+8ZoFx9haaN9FxP9YkrXRQ4eBPgdCO3yryHLJBNrEKNnhwothg169ldfymhtVcg0Y7YorWynbpE8eaG2F4pnDOof3Hf0TvDRQ9wyxtYYl06IiuDxxgdYyhueQXTjWokjjlsuIwhAAGE7Af8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676840; c=relaxed/simple;
	bh=njscxX8Tt0E7kiZkORL8M0UW6fGCNfJsxoF6/X/uKKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6/+oXE1MmSpntjKdo3fZSWgDECuJ46+SQvds+oo8UgnhrDsU0xAODAN6kIGdI7dCv2Eo+VuZyBFix2qj40cekJhAMNGbB3ivQEzIV+m8/+fa4Ox1KtRIF24rj+pQa+/g2CUeGHelEbXV/C1iUSp13Sd5o6Nej7fFsatRUGU5CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g0RTyCC1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8j0azgSo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g0RTyCC1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8j0azgSo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 533EC20C79;
	Thu, 20 Nov 2025 22:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763676837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IwjJydqw4fmOu2DnMwdqCv9RvphV39m7bpsVRwII5FQ=;
	b=g0RTyCC1/uQG1e7dF9BZVQhY0ANSmI+AeAa+sGjEvf3SxklCDjDWHzXjU3JlM/ccK2LrNz
	lOmM4UE6E7acEkEkua1JiZqcGF4+dTnR9ugXf9FpjXQ6Nk0/G9xeWcztiHzaBItrGMLC19
	h3xg0BBLr/6CzZvakekK30UbQASfWVM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763676837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IwjJydqw4fmOu2DnMwdqCv9RvphV39m7bpsVRwII5FQ=;
	b=8j0azgSoxXWF5fGvXP+vDLhJC66JMCqEUGQ0YNWTAEvfqpvzKYK4bY8jnNY60OfRLVtSfz
	x0uGZtA7R4EXIoAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763676837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IwjJydqw4fmOu2DnMwdqCv9RvphV39m7bpsVRwII5FQ=;
	b=g0RTyCC1/uQG1e7dF9BZVQhY0ANSmI+AeAa+sGjEvf3SxklCDjDWHzXjU3JlM/ccK2LrNz
	lOmM4UE6E7acEkEkua1JiZqcGF4+dTnR9ugXf9FpjXQ6Nk0/G9xeWcztiHzaBItrGMLC19
	h3xg0BBLr/6CzZvakekK30UbQASfWVM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763676837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IwjJydqw4fmOu2DnMwdqCv9RvphV39m7bpsVRwII5FQ=;
	b=8j0azgSoxXWF5fGvXP+vDLhJC66JMCqEUGQ0YNWTAEvfqpvzKYK4bY8jnNY60OfRLVtSfz
	x0uGZtA7R4EXIoAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 163AA3EA61;
	Thu, 20 Nov 2025 22:13:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n06dNKSSH2mcBQAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 20 Nov 2025 22:13:56 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: 
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	io-uring@vger.kernel.org,
	csander@purestorage.com
Subject: [PATCH liburing v2 1/4] liburing: Introduce getsockname operation
Date: Thu, 20 Nov 2025 17:13:39 -0500
Message-ID: <20251120221351.3802738-2-krisman@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

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
2.51.0


