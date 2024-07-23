Return-Path: <io-uring+bounces-2553-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 306C193A9BC
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 01:17:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6211D1C226F3
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 23:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B92613BAD5;
	Tue, 23 Jul 2024 23:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gtNF9sOf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WgyZ26dx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gtNF9sOf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WgyZ26dx"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B286028E8
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 23:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721776669; cv=none; b=oy0H7LNlB7sjNNq2lgnPqgvB/apj0hThNV4vcgkxCwmuzK0jt7NkUUNhwyp676AYchQ9HLo9c5RCH+pNM1kUywDNff5Py43Nz6N1WdxB4U6kT02nEc0TB7Nj3vReKtebN25ff7Vq9SjDxOAoYl6AXOuAKLTeKO6Th0TK0rahmc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721776669; c=relaxed/simple;
	bh=U1FcmfJ8+cvlue83//r8iaxGTbgTnFsUrb0C9J9leSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaWjpTG7VoO4EsiW7R9jY/3KN0GnafQZHALBCs4pFFSM9FN5t8Ehp+CPTWK5OmWiLaf7O388rILKRT5iQxUiqSNvwL0aLjdiOPYMr9RiVdUfE9VGBTqFpsB44sCAQpwK5Zzz1B8sZRISl4ntZYEq+1q4tfp5/vL+A0cml5COkk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gtNF9sOf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WgyZ26dx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gtNF9sOf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WgyZ26dx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E018C21A82;
	Tue, 23 Jul 2024 23:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEwvX77XHO7ox1O071NbVflXo4aI4ZaorFaCrwqijio=;
	b=gtNF9sOf2fQrppiPuNcPUHqEwYWU2r0scEntdZ/S/yO50S8z1uQCAwvXqyGfsE+ZH/xuWT
	D1oD8bgaEE7p+M34AMYRcxaEY9+hGsLikzZAANGeWmeWgsTk6oCb1ehcur2H/m9TLQYfd7
	GiP+VrjHg6KZ3qoOPnhkakukkoNq2Xg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776665;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEwvX77XHO7ox1O071NbVflXo4aI4ZaorFaCrwqijio=;
	b=WgyZ26dxhFPas93CkIve7sxdnpEmTbMGU+Plh/vTI1UyGBz6CrCYXtDEJmFHpaL346gdTu
	Ro4Sgo8OqU+n67Cg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEwvX77XHO7ox1O071NbVflXo4aI4ZaorFaCrwqijio=;
	b=gtNF9sOf2fQrppiPuNcPUHqEwYWU2r0scEntdZ/S/yO50S8z1uQCAwvXqyGfsE+ZH/xuWT
	D1oD8bgaEE7p+M34AMYRcxaEY9+hGsLikzZAANGeWmeWgsTk6oCb1ehcur2H/m9TLQYfd7
	GiP+VrjHg6KZ3qoOPnhkakukkoNq2Xg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776665;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEwvX77XHO7ox1O071NbVflXo4aI4ZaorFaCrwqijio=;
	b=WgyZ26dxhFPas93CkIve7sxdnpEmTbMGU+Plh/vTI1UyGBz6CrCYXtDEJmFHpaL346gdTu
	Ro4Sgo8OqU+n67Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9CFA913874;
	Tue, 23 Jul 2024 23:17:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C+oxIBk6oGbVUgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 23 Jul 2024 23:17:45 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing v2 5/5] man/io_uring_prep_listen.3: Document IORING_OP_LISTEN operation
Date: Tue, 23 Jul 2024 19:17:33 -0400
Message-ID: <20240723231733.31884-6-krisman@suse.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723231733.31884-1-krisman@suse.de>
References: <20240723231733.31884-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.10 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,suse.de];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -1.10

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
2.45.2


