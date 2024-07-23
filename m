Return-Path: <io-uring+bounces-2552-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D33193A9BB
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 01:17:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA8EE1F230B5
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 23:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D17E41494A7;
	Tue, 23 Jul 2024 23:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ijA8llWS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YR4uXreM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ijA8llWS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YR4uXreM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413AF13BAD5
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 23:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721776667; cv=none; b=s7NOdoorD9a/A/ALLyLYO5oIkSpmv6vaSHJEFwNx2h9cC1w5iZYQrjCetJbscyacxnkKj8HHqnKT+lGmpH3yTw7xjNRxE8ai2U7ScYKLoZ4acBEUlTxs1HbYE4aVyGTpAOaFkbokrY/E04goK1PW/lTn9GLl8809cka9+fnmDfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721776667; c=relaxed/simple;
	bh=ftz1RzQHgfxeWgy8cF5ZY4e7SLqvk3OxfVdQMbh4flM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2ZVzX1d3Og2P3SSGykjRy2Fwrf+8DYAJf/sJniLDsqGTnxG0Wvc251mdbffz2PgwpY7ZaTlCvpNUJWJGE7zDkDl4FaRjK5eKymIypyfNCUFXORXj4i0WwGR1irw8tNcXlvKbsgjHkOqPOuHhULPw95H2dMSIs7eCOnlvxzZvM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ijA8llWS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YR4uXreM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ijA8llWS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YR4uXreM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4FDBA1F454;
	Tue, 23 Jul 2024 23:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776664; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sYSQuCfuIjLlC3yMPY46uswOkdyeX4KTIZYp1Qp+j38=;
	b=ijA8llWSaHE/AmSpVcl5q+JZUcQUXVf9EkUeHQebVkSB8z1kHe2Lo1EPp0kvrV6mzQFX+G
	Nu9au+YaFv7r3q3xbWJct7VXn37vJQUEKKWMwS1J+2O6ZjwvWGaxESecVaN2x/5KqpLNX5
	fkV++VN0HU6Cmg6KRO4t4FgVEBWgOX4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776664;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sYSQuCfuIjLlC3yMPY46uswOkdyeX4KTIZYp1Qp+j38=;
	b=YR4uXreMsOZtki7kGcE85oTPuuH2InFVFpfNXLmR96vUkuy6uj/XYboTKJOasgs5RmQLb2
	U5fx6Udl2InAPrDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ijA8llWS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YR4uXreM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776664; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sYSQuCfuIjLlC3yMPY46uswOkdyeX4KTIZYp1Qp+j38=;
	b=ijA8llWSaHE/AmSpVcl5q+JZUcQUXVf9EkUeHQebVkSB8z1kHe2Lo1EPp0kvrV6mzQFX+G
	Nu9au+YaFv7r3q3xbWJct7VXn37vJQUEKKWMwS1J+2O6ZjwvWGaxESecVaN2x/5KqpLNX5
	fkV++VN0HU6Cmg6KRO4t4FgVEBWgOX4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776664;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sYSQuCfuIjLlC3yMPY46uswOkdyeX4KTIZYp1Qp+j38=;
	b=YR4uXreMsOZtki7kGcE85oTPuuH2InFVFpfNXLmR96vUkuy6uj/XYboTKJOasgs5RmQLb2
	U5fx6Udl2InAPrDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1887F13874;
	Tue, 23 Jul 2024 23:17:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d7cEABg6oGbSUgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 23 Jul 2024 23:17:43 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing v2 4/5] man/io_uring_prep_bind.3: Document the IORING_OP_BIND operation
Date: Tue, 23 Jul 2024 19:17:32 -0400
Message-ID: <20240723231733.31884-5-krisman@suse.de>
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
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4FDBA1F454
X-Spam-Score: -1.31
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.31 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,suse.de];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

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
2.45.2


