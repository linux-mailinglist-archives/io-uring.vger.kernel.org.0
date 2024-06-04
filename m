Return-Path: <io-uring+bounces-2087-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1306F8FA6C5
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 02:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37AD41C20429
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 00:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BBD0195;
	Tue,  4 Jun 2024 00:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jilrP/fu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7uHNwvtz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jilrP/fu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7uHNwvtz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77019385
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 00:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717459480; cv=none; b=WMRGa0Nqt3lPHtg1JTp9ZFz4gO0BmO3MG1kdNguIZ/F6cKFhemeHpTTbDar1ESCDbJeBB37m+p7YEE6F0dxGNYnyBSFaF3uEH5gRYFshVkVgDVfYBwmC24Czdv5ImDlhiDxnVnXFYvUoWASlsUrxRYfLmE6PdM4eO9ZXinWMH28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717459480; c=relaxed/simple;
	bh=UUIipAO0vt3KaZcWDAcaA+h8nVlptfqXy9s/D7Q+cwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeYamgxxUXFqfvG/lp1onIGT3ouIqJqYouSHpQESdcaSp6hFU1Hqe5HaufNkd0Q4gfaPgJrBNyOvEOqL/pslmzR0SVStpVRJb7F/RNsfpUwHPs3Ih7KgMwDwp7wRVQeMlf+Jk0iy2pBOiDeY90vXLJQRPMD33rgof0nGN8ZQb9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jilrP/fu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7uHNwvtz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jilrP/fu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7uHNwvtz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A08A021982;
	Tue,  4 Jun 2024 00:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717459476; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JCd4+VtMK5n7iu36mec+uHN/S1Vvzy/IZlR5WVe+/k=;
	b=jilrP/fuEUQExTMhhnfn22mh76Ch5KCIp3psOrS+Xf3Gzs8+bgF250mU0/coc0eBBWhgCc
	ZzGRU0KW8JlVKE8FGnEvCHYsskgNVkEArYqNOJoxO3Nl+kfFi+fN4bUu6z4jU5XqmR6jPr
	alCynKCKr5QGnuFr+Cb19T5rSjYCiXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717459476;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JCd4+VtMK5n7iu36mec+uHN/S1Vvzy/IZlR5WVe+/k=;
	b=7uHNwvtziA8B+c3IAqQzCtoMrNXbwasxKUlb3sCVFviI8gpwh/c9F+zYE74okOV2l21Y5F
	Jk82d+ben3ILJLAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="jilrP/fu";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7uHNwvtz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717459476; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JCd4+VtMK5n7iu36mec+uHN/S1Vvzy/IZlR5WVe+/k=;
	b=jilrP/fuEUQExTMhhnfn22mh76Ch5KCIp3psOrS+Xf3Gzs8+bgF250mU0/coc0eBBWhgCc
	ZzGRU0KW8JlVKE8FGnEvCHYsskgNVkEArYqNOJoxO3Nl+kfFi+fN4bUu6z4jU5XqmR6jPr
	alCynKCKr5QGnuFr+Cb19T5rSjYCiXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717459476;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JCd4+VtMK5n7iu36mec+uHN/S1Vvzy/IZlR5WVe+/k=;
	b=7uHNwvtziA8B+c3IAqQzCtoMrNXbwasxKUlb3sCVFviI8gpwh/c9F+zYE74okOV2l21Y5F
	Jk82d+ben3ILJLAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CF8613A92;
	Tue,  4 Jun 2024 00:04:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EcSREBRaXmaXCwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 04 Jun 2024 00:04:36 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 4/5] man/io_uring_prep_bind.3: Document the IORING_OP_BIND operation
Date: Mon,  3 Jun 2024 20:04:16 -0400
Message-ID: <20240604000417.16137-5-krisman@suse.de>
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
	BAYES_HAM(-3.00)[100.00%];
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
X-Rspamd-Queue-Id: A08A021982
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -5.01

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 man/io_uring_prep_bind.3 | 54 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 man/io_uring_prep_bind.3

diff --git a/man/io_uring_prep_bind.3 b/man/io_uring_prep_bind.3
new file mode 100644
index 0000000..e2a1cf9
--- /dev/null
+++ b/man/io_uring_prep_bind.3
@@ -0,0 +1,54 @@
+.\" Copyright (C) 2024 SUSE LLC
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_prep_bind 3 "Jun 3, 2024" "liburing-2.7" "liburing Manual"
+.SH NAME
+io_uring_prep_bind \- prepare a bind request
+.SH SYNOPSIS
+.nf
+.B #include <sys/socket.h>
+.B #include <liburing.h>
+.PP
+.BI "void io_uring_prep_bind(struct io_uring_sqe *" sqe ","
+.BI "                          int " sockfd ","
+.BI "                          struct sockaddr *" addr ","
+.BI "                          socklen_t " addrlen ");"
+.fi
+.SH DESCRIPTION
+The
+.BR io_uring_prep_bind (3)
+function prepares a bind request. The submission queue entry
+.I sqe
+is setup to assign the network address at
+.IR addr ,
+of length
+.IR addrlen ,
+to the socket descriptor
+.IR sockfd.
+
+This function prepares an async
+.BR bind (2)
+request. See that man page for details.
+
+.SH RETURN VALUE
+None
+.SH ERRORS
+The CQE
+.I res
+field will contain the result of the operation. See the related man page for
+details on possible values. Note that where synchronous system calls will return
+.B -1
+on failure and set
+.I errno
+to the actual error value, io_uring never uses
+.IR errno .
+Instead it returns the negated
+.I errno
+directly in the CQE
+.I res
+field.
+.SH SEE ALSO
+.BR io_uring_get_sqe (3),
+.BR io_uring_submit (3),
+.BR bind (2)
-- 
2.44.0


