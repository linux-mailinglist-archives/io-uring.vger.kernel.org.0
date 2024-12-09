Return-Path: <io-uring+bounces-5370-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EAA09EA30C
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:44:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84823188529F
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9808C19CC33;
	Mon,  9 Dec 2024 23:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tmdoF969";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DgyOkW+o";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tmdoF969";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DgyOkW+o"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A9D19F489
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787870; cv=none; b=q6eQgxaHw7u7aPYEqTecWWtBUWZWoSRrjd1vZhqXzP8M1czJmobSCwMngkjzf53+oIw8adp6JYLOx5sNvwWRIHSUG1gtqkKd1MgLl7ZGN8ZOBeDzDE7JYmcGYBcaKVTLf297Pk99lnaee5/eL/o6S//IMTPpjPRDzwAjgD5zp+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787870; c=relaxed/simple;
	bh=sV5IYXPKuipD6S5PO6/STyqOQ9GcFQMQ+20RTJWnbmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6J/MWIixw3GqChny3wTwhxQQ2SBD235EjU+yhN0im02kXyE5o3JBfx2EluC+HCYxkHrD/57EKgyFEU98A7zvXGvs1FeQoHEnvx4kqx3Olantn36nZcMmwwB//7kQRBYfUb5knJi9p0kS7FUGiJxW/8lt/XqCdUlsIfG8XT4CxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tmdoF969; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DgyOkW+o; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tmdoF969; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DgyOkW+o; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1FBB51F441;
	Mon,  9 Dec 2024 23:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787867; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NrEt5dQ45eju5+rnbyvI8mZDvtdJx7VdsLb3f9iXUtU=;
	b=tmdoF969Jxe2e6VaUAFsW3w2a8nVLv8n1b+QwdmbSYR9lyX2yw1o1IncAf0/HDWNUnfVmT
	4TeTGwcgbFwIPvZe47gGgdfKRQoYqOY3wPcQMLJhd+vc8kS7LrszBPS7EoYW7XgVfHgPLM
	gURGfAaCr+S/LDMO8TqnzoAHyaF0I2w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787867;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NrEt5dQ45eju5+rnbyvI8mZDvtdJx7VdsLb3f9iXUtU=;
	b=DgyOkW+o/9UmQQ4h/OEVB/SUoM+OA+4ksFUEUlshCWNwsGrLiNMf3BHDkhoBiEWqi6j2YF
	UKoUPsmHnez5ntAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787867; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NrEt5dQ45eju5+rnbyvI8mZDvtdJx7VdsLb3f9iXUtU=;
	b=tmdoF969Jxe2e6VaUAFsW3w2a8nVLv8n1b+QwdmbSYR9lyX2yw1o1IncAf0/HDWNUnfVmT
	4TeTGwcgbFwIPvZe47gGgdfKRQoYqOY3wPcQMLJhd+vc8kS7LrszBPS7EoYW7XgVfHgPLM
	gURGfAaCr+S/LDMO8TqnzoAHyaF0I2w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787867;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NrEt5dQ45eju5+rnbyvI8mZDvtdJx7VdsLb3f9iXUtU=;
	b=DgyOkW+o/9UmQQ4h/OEVB/SUoM+OA+4ksFUEUlshCWNwsGrLiNMf3BHDkhoBiEWqi6j2YF
	UKoUPsmHnez5ntAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D8A19138A5;
	Mon,  9 Dec 2024 23:44:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W53ILdqAV2czHQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:44:26 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC liburing 1/2] Add IORING_OP_CLONE/EXEC support
Date: Mon,  9 Dec 2024 18:44:20 -0500
Message-ID: <20241209234421.4133054-2-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241209234421.4133054-1-krisman@suse.de>
References: <20241209234421.4133054-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -5.30
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 src/include/liburing.h          | 25 +++++++++++++++++++++++++
 src/include/liburing/io_uring.h |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 627fc47..6d344b1 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1229,6 +1229,31 @@ IOURINGINLINE void io_uring_prep_socket_direct_alloc(struct io_uring_sqe *sqe,
 	__io_uring_set_target_fixed_file(sqe, IORING_FILE_INDEX_ALLOC - 1);
 }
 
+static inline void io_uring_prep_clone(struct io_uring_sqe *sqe)
+{
+	io_uring_prep_rw(IORING_OP_CLONE, sqe, 0, NULL, 0, 0);
+}
+
+static inline void io_uring_prep_execveat(struct io_uring_sqe *sqe, int dfd,
+					  const char *filename, char *const *argv,
+					  char *const *envp, int flags)
+{
+	io_uring_prep_rw(IORING_OP_EXECVEAT, sqe, dfd, filename, 0, 0);
+	sqe->addr2 = (unsigned long)(void *)argv;
+	sqe->addr3 = (unsigned long)(void *)envp;
+	sqe->execve_flags = flags;
+}
+
+static inline void io_uring_prep_exec(struct io_uring_sqe *sqe,
+				      const char *filename, char *const *argv,
+                                      char *const *envp)
+{
+       io_uring_prep_rw(IORING_OP_EXECVEAT, sqe, 0, filename, 0, 0);
+       sqe->addr2 = (unsigned long)(void *)argv;
+       sqe->addr3 = (unsigned long)(void *)envp;
+}
+
+
 /*
  * Prepare commands for sockets
  */
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 7659198..a198969 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -73,6 +73,7 @@ struct io_uring_sqe {
 		__u32		futex_flags;
 		__u32		install_fd_flags;
 		__u32		nop_flags;
+		__u32		execve_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -262,6 +263,8 @@ enum io_uring_op {
 	IORING_OP_FTRUNCATE,
 	IORING_OP_BIND,
 	IORING_OP_LISTEN,
+	IORING_OP_CLONE,
+	IORING_OP_EXECVEAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.47.0


