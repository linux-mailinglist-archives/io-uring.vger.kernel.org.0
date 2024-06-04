Return-Path: <io-uring+bounces-2085-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C668FA6C3
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 02:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6C4E1C20880
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 00:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0C737C;
	Tue,  4 Jun 2024 00:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nDC+T1uq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="H6AZ7KWK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nDC+T1uq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="H6AZ7KWK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76571384
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 00:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717459477; cv=none; b=kuNzQgq3daR4jnkjRWkfNUxp5ajMxDafMee/oTx9ZFneviMWK1dIkn/Iv1mfg8++AMosGsyAlH8/YTR38jq6KZtp0Go4eG46QerGhgkt7DY7YVQYraN5aUJsb9XZy6odOBPuAJjAaVCFkT/D6vaRjW/cluDnqr21R0RR1DVHAYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717459477; c=relaxed/simple;
	bh=/ltzQ0Uq2PF504+DUHkBBV9Hd8cIOomeaQ5Wh70zX4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ms6og9/x5u/LgV6NVbElp5GDKNzA5HYf9fTADUl0kpj6WMevVTtTRqqhbHgL93HGiANZ+b9zca6IdfimfV45d3FG1SzHpgyabTF+uSX6Br2XU6HyKITMeNxf+2PA9NpLM4EMGn69xwYr8LFUNlKFYoVSv3EihOK2P+fq3Yu8V8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nDC+T1uq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=H6AZ7KWK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nDC+T1uq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=H6AZ7KWK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6E98A219EA;
	Tue,  4 Jun 2024 00:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717459473; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xnXECQlzF6uFX3PmMMfj/5KTxFpeLOHsymTJELdN+tg=;
	b=nDC+T1uqRSxivnotmIOtZR+hsX9d8/4L1q61Ge351VA7W/MRGo5w+GkNOmbzjEfQOvesOk
	Jy6WNwH3Ca0QCrg3fKlccPBFtjpSVboNsGmFyw3KbS6g/u4z+SyL5pxXB5cRQ/bi2FB30L
	9dgGB/psl5gLEAey8OAyP/LlqVcKRHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717459473;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xnXECQlzF6uFX3PmMMfj/5KTxFpeLOHsymTJELdN+tg=;
	b=H6AZ7KWKUT/IyFrg75/kzfTmjr3ohR9P+wqMtq2oVWHbOdNKmugtNbv1nSLqD0JHcXNEpC
	ZjMRuWYWtzHF6ZDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nDC+T1uq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H6AZ7KWK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717459473; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xnXECQlzF6uFX3PmMMfj/5KTxFpeLOHsymTJELdN+tg=;
	b=nDC+T1uqRSxivnotmIOtZR+hsX9d8/4L1q61Ge351VA7W/MRGo5w+GkNOmbzjEfQOvesOk
	Jy6WNwH3Ca0QCrg3fKlccPBFtjpSVboNsGmFyw3KbS6g/u4z+SyL5pxXB5cRQ/bi2FB30L
	9dgGB/psl5gLEAey8OAyP/LlqVcKRHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717459473;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xnXECQlzF6uFX3PmMMfj/5KTxFpeLOHsymTJELdN+tg=;
	b=H6AZ7KWKUT/IyFrg75/kzfTmjr3ohR9P+wqMtq2oVWHbOdNKmugtNbv1nSLqD0JHcXNEpC
	ZjMRuWYWtzHF6ZDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3539E13A92;
	Tue,  4 Jun 2024 00:04:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SmzrBhFaXmaBCwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 04 Jun 2024 00:04:33 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 2/5] liburing: Add helper to prepare IORING_OP_LISTEN command
Date: Mon,  3 Jun 2024 20:04:14 -0400
Message-ID: <20240604000417.16137-3-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240604000417.16137-1-krisman@suse.de>
References: <20240604000417.16137-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-5.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6E98A219EA
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -5.01

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 src/include/liburing.h          | 6 ++++++
 src/include/liburing/io_uring.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 818e27c..52d732a 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -676,6 +676,12 @@ IOURINGINLINE void io_uring_prep_bind(struct io_uring_sqe *sqe, int fd,
 	io_uring_prep_rw(IORING_OP_BIND, sqe, fd, addr, 0, addrlen);
 }
 
+IOURINGINLINE void io_uring_prep_listen(struct io_uring_sqe *sqe, int fd,
+				      int backlog)
+{
+	io_uring_prep_rw(IORING_OP_LISTEN, sqe, fd, 0, backlog, 0);
+}
+
 IOURINGINLINE void io_uring_prep_files_update(struct io_uring_sqe *sqe,
 					      int *fds, unsigned nr_fds,
 					      int offset)
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 177ace6..f99d41f 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -258,6 +258,7 @@ enum io_uring_op {
 	IORING_OP_FIXED_FD_INSTALL,
 	IORING_OP_FTRUNCATE,
 	IORING_OP_BIND,
+	IORING_OP_LISTEN,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.44.0


