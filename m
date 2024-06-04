Return-Path: <io-uring+bounces-2088-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 182DC8FA6C6
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 02:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69172B23408
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 00:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F0C195;
	Tue,  4 Jun 2024 00:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bEw81Uip";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5tSZL+gF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bEw81Uip";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5tSZL+gF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2976182
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 00:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717459485; cv=none; b=ti7xy/GA+EbCbQPg+c9HsFNZQmTnoqQwP4iGRAsGe6nEApsUhoHCM34KKZ2LNxwEZh//3sztX3XlVqp+G3Kc/N76N1+IgsIRlrO47KX8jskK4GBfg+HefvhZiJ+4C/DFcdKCBHBN/AwtQLMMDzbQDqUNC7P0hBDYurGaYZnN1QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717459485; c=relaxed/simple;
	bh=ot3ORprksIxZRFZuprTcNDEglW6STodZVP7W9z3OUYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R283P2wGtEYyOmTTEbzRE0K3PPUjxO4VWPIq9DifNnDVnnDHSOJ189pFfCDefiYd7k7TG3byez3CYz0ooZDVLz7y9bpgz72O+I+eBnbvnhq0CX4z3Wsm5UgOWBZpPwqZ/5gdN7lUcdL91vp2XroGaH4Nq27KQgf1Zk4H4DiWYMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bEw81Uip; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5tSZL+gF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bEw81Uip; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5tSZL+gF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 31F6B1F792;
	Tue,  4 Jun 2024 00:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717459482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QtYsFL1BpJLIqOattB5MxmCCmySIBLcNGdcM6dT4WZ4=;
	b=bEw81UipgFAZhszAVtaLxDOl8F1SnTUfQwEVfjlhhyBly2rpm2JEl5UBl9wF01sD9tJqMz
	QxBbU9BXaDfXtK388aVs+fjs4ROe91bSUob5AwSVLTlmQeJEZDRl5y1KH8tT/27e+45NRq
	xGL3GPGusyXTGMVMvvzgAAWV1LZb1w8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717459482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QtYsFL1BpJLIqOattB5MxmCCmySIBLcNGdcM6dT4WZ4=;
	b=5tSZL+gFezlHKWOwwauLsXUZH4M4JjZ5wQjL+iLNIemYSJFIcN6fFi73sbIZR3QNbGsFAC
	0yHZ3uxpJZOTyyBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bEw81Uip;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5tSZL+gF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717459482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QtYsFL1BpJLIqOattB5MxmCCmySIBLcNGdcM6dT4WZ4=;
	b=bEw81UipgFAZhszAVtaLxDOl8F1SnTUfQwEVfjlhhyBly2rpm2JEl5UBl9wF01sD9tJqMz
	QxBbU9BXaDfXtK388aVs+fjs4ROe91bSUob5AwSVLTlmQeJEZDRl5y1KH8tT/27e+45NRq
	xGL3GPGusyXTGMVMvvzgAAWV1LZb1w8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717459482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QtYsFL1BpJLIqOattB5MxmCCmySIBLcNGdcM6dT4WZ4=;
	b=5tSZL+gFezlHKWOwwauLsXUZH4M4JjZ5wQjL+iLNIemYSJFIcN6fFi73sbIZR3QNbGsFAC
	0yHZ3uxpJZOTyyBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EBB7513A92;
	Tue,  4 Jun 2024 00:04:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4FFAMxlaXmacCwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 04 Jun 2024 00:04:41 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 5/5] man/io_uring_prep_listen.3: Document IORING_OP_LISTEN operation
Date: Mon,  3 Jun 2024 20:04:17 -0400
Message-ID: <20240604000417.16137-6-krisman@suse.de>
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
X-Spam-Flag: NO
X-Spam-Score: -5.01
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 31F6B1F792
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 man/io_uring_prep_listen.3 | 52 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 man/io_uring_prep_listen.3

diff --git a/man/io_uring_prep_listen.3 b/man/io_uring_prep_listen.3
new file mode 100644
index 0000000..b765298
--- /dev/null
+++ b/man/io_uring_prep_listen.3
@@ -0,0 +1,52 @@
+.\" Copyright (C) 2024 SUSE LLC.
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_prep_listen 3 "Jun 3, 2024" "liburing-2.7" "liburing Manual"
+.SH NAME
+io_uring_prep_listen \- prepare a listen request
+.SH SYNOPSIS
+.nf
+.B #include <sys/socket.h>
+.B #include <liburing.h>
+.PP
+.BI "void io_uring_prep_listen(struct io_uring_sqe *" sqe ","
+.BI "                          int " sockfd ","
+.BI "                          int" backlog ");"
+.fi
+.SH DESCRIPTION
+The
+.BR io_uring_prep_listen (3)
+function prepares a listen request. The submission queue entry
+.I sqe
+is setup to place the socket file descriptor pointed by
+.IR sockfd
+into a state to accept incoming connections.  The parameter
+.IR backlog ,
+defines the maximum length of the queue of pending connections.
+
+This function prepares an async
+.BR listen (2)
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
+.BR listen (2)
-- 
2.44.0


