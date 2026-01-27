Return-Path: <io-uring+bounces-11927-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id C2QgLOUZeGmwoAEAu9opvQ
	(envelope-from <io-uring+bounces-11927-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 02:50:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 13BF58ECE2
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 02:50:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EF3243024A15
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 01:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C391990A7;
	Tue, 27 Jan 2026 01:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RUE0ENqX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HLXhxLu/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RUE0ENqX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HLXhxLu/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA4620311
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 01:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769478625; cv=none; b=EdXLk7bepd0nzlS0xJHLud2+w7w6KiyQlY9JDqcmN3whqtqu84ek3QaOE2hfcdrTKXfr+GeSNvxNZLZ0F9EhUft52igavOjf6gZc1tWldiLLaADCymcwE4pJ7AU9Mpob2385OdMuha1jtNG0lARyxU7tm65J0Dxx5WKTZUfTzhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769478625; c=relaxed/simple;
	bh=fyI1rZ8uFKI+WV+Z76FFe/Eef1hEaNaCNTsFfA5VkWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SZXuuK+Hebuj+887p/2Xda/t4Cr12qWkbWAIIByoNEOLu8vsr64qLCjcJMywEgiClWfRis4+KpdY4uhuIO4BKf5jsKGXqVwkadCIcfqNyqwHAs8OXVaprXRQjsv5Kk9GLxntRYUUqO2jdoNIEoKQR0UZMOP4gdnYD7TSMDUyHIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RUE0ENqX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HLXhxLu/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RUE0ENqX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HLXhxLu/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BB1175BCD0;
	Tue, 27 Jan 2026 01:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769478621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BSePph3zncku8ysmx7HEJE+sg2mWfR8OZIxYUUWkwc4=;
	b=RUE0ENqXYZmbRS9hf5+Jco6yiAltW2viMcgazMMUmfFKBwKZKCVSgNRsucaXCN7iTpojrm
	KuDfA1aY3niayNgxwZX9rYgwP/NH0VFwc6xksnqoY2hi3q5thu6SvLd278BbQJSLDbseUs
	pow+g2KYtbJ9iQ2+CbGgarLj0t25DOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769478621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BSePph3zncku8ysmx7HEJE+sg2mWfR8OZIxYUUWkwc4=;
	b=HLXhxLu/7FTkGPi9I3DjYq86zHtYlntnPC+A4xE48UbAp/q4gV44fbqxtj+xOWsiJngMnR
	bAMakYfVTLgtIZAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RUE0ENqX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="HLXhxLu/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769478621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BSePph3zncku8ysmx7HEJE+sg2mWfR8OZIxYUUWkwc4=;
	b=RUE0ENqXYZmbRS9hf5+Jco6yiAltW2viMcgazMMUmfFKBwKZKCVSgNRsucaXCN7iTpojrm
	KuDfA1aY3niayNgxwZX9rYgwP/NH0VFwc6xksnqoY2hi3q5thu6SvLd278BbQJSLDbseUs
	pow+g2KYtbJ9iQ2+CbGgarLj0t25DOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769478621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BSePph3zncku8ysmx7HEJE+sg2mWfR8OZIxYUUWkwc4=;
	b=HLXhxLu/7FTkGPi9I3DjYq86zHtYlntnPC+A4xE48UbAp/q4gV44fbqxtj+xOWsiJngMnR
	bAMakYfVTLgtIZAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5FE1513712;
	Tue, 27 Jan 2026 01:50:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ArpPC90ZeGnIMgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 27 Jan 2026 01:50:21 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing] io_uring_prep_cmd_getsockname.3: Deduplicate manpage
Date: Mon, 26 Jan 2026 20:50:17 -0500
Message-ID: <20260127015017.2919925-1-krisman@suse.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11927-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 13BF58ECE2
X-Rspamd-Action: no action

I committed the op_getsockname man page under the wrong name, because I
originally wrote the code and manpage as a main io_uring command and then
converted to a uring_cmd but forgot to update the manpage.  Following
this, Jens pushed an AI generated version of this page with the correct
name and almost the same content.

While the AI version is okay-ish, it is missing relevant details, like
differences in error codes to the original syscall.  So I'm replacing
the AI with my version, minus a few corrections. There is no point in
lingering the wrong named version around, as there is no function
with that name.

Reported by exbigboss on Discord.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 man/io_uring_prep_cmd_getsockname.3 | 75 ++++++++++++++++-----------
 man/io_uring_prep_getsockname.3     | 78 -----------------------------
 2 files changed, 47 insertions(+), 106 deletions(-)
 delete mode 100644 man/io_uring_prep_getsockname.3

diff --git a/man/io_uring_prep_cmd_getsockname.3 b/man/io_uring_prep_cmd_getsockname.3
index 060ff4a7..221b49dc 100644
--- a/man/io_uring_prep_cmd_getsockname.3
+++ b/man/io_uring_prep_cmd_getsockname.3
@@ -1,12 +1,14 @@
+.\" Copyright (C) 2025 SUSE LLC.
 .\" Copyright (C) 2025 Jens Axboe <axboe@kernel.dk>
 .\"
 .\" SPDX-License-Identifier: LGPL-2.0-or-later
 .\"
-.TH io_uring_prep_cmd_getsockname 3 "January 18, 2025" "liburing-2.13" "liburing Manual"
+.TH io_uring_prep_cmd_getsockname 3 "December 3, 2025" "liburing-2.13" "liburing Manual"
 .SH NAME
 io_uring_prep_cmd_getsockname \- prepare a getsockname or getpeername request
 .SH SYNOPSIS
 .nf
+.B #include <sys/socket.h>
 .B #include <liburing.h>
 .PP
 .BI "void io_uring_prep_cmd_getsockname(struct io_uring_sqe *" sqe ","
@@ -16,45 +18,62 @@ io_uring_prep_cmd_getsockname \- prepare a getsockname or getpeername request
 .BI "                                   int " peer ");"
 .fi
 .SH DESCRIPTION
-.PP
 The
 .BR io_uring_prep_cmd_getsockname (3)
-function prepares a socket command request to get the socket address. The
-submission queue entry
+function prepares a getsockname/getpeername request.
+The submission queue entry
 .I sqe
-is setup to use the socket indicated by the file descriptor
-.IR fd .
-
-The
-.I sockaddr
-argument points to a buffer where the address will be stored. The
-.I sockaddr_len
-argument points to the length of the buffer, which will be updated with
-the actual length of the address on completion.
+is setup to fetch the locally bound address or peer address of the socket
+file descriptor pointed by
+.IR sockfd .
+The parameter
+.IR sockaddr
+points to a region of size
+.IR sockaddr_len
+where the output is written.
+.IR sockaddr_len
+is modified by the kernel on return  to indicate how many bytes were written.
+The output address is the locally bound address if
+.IR peer
+is set to
+.B 0
+or the peer address if
+.IR peer
+is set to
+.BR 1 .
 
-If
-.I peer
-is 0, this operates like
-.BR getsockname (2),
-returning the local address bound to the socket. If
-.I peer
-is non-zero, this operates like
-.BR getpeername (2),
-returning the address of the peer connected to the socket.
+This function prepares an async
+.BR getsockname (2)
+or
+.BR getpeername (2)
+request. See those man pages for details.
 
 .SH RETURN VALUE
 None
 .SH ERRORS
 The CQE
 .I res
-field will contain the result of the operation. See
-.BR getsockname (2)
-or
-.BR getpeername (2)
-for possible error values.
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
+.BR
+Differently from the equivalent system calls, if the user attempts to
+use this operation on a non-socket file descriptor, the CQE error result
+is
+.IR ENOTSUP
+instead of
+.IR ENOSOCK.
 .SH SEE ALSO
 .BR io_uring_get_sqe (3),
 .BR io_uring_submit (3),
-.BR io_uring_prep_getsockname (3),
 .BR getsockname (2),
 .BR getpeername (2)
diff --git a/man/io_uring_prep_getsockname.3 b/man/io_uring_prep_getsockname.3
deleted file mode 100644
index de78cb40..00000000
--- a/man/io_uring_prep_getsockname.3
+++ /dev/null
@@ -1,78 +0,0 @@
-.\" Copyright (C) 2024 SUSE LLC.
-.\"
-.\" SPDX-License-Identifier: LGPL-2.0-or-later
-.\"
-.TH io_uring_prep_getsockname 3 "Dec 3, 2025" "liburing-2.13" "liburing Manual"
-.SH NAME
-io_uring_prep_getsockname \- prepare a getsockname or getpeername request
-.SH SYNOPSIS
-.nf
-.B #include <sys/socket.h>
-.B #include <liburing.h>
-.PP
-.BI "void io_uring_prep_getsockname(struct io_uring_sqe *" sqe ","
-.BI "                               int " sockfd ","
-.BI "                               struct sockaddr *" sockaddr ","
-.BI "                               socklen_t *" sockaddr_len ","
-.BI "                               int " peer ");"
-.fi
-.SH DESCRIPTION
-The
-.BR io_uring_prep_getsockname (3)
-function prepares a getsockname/getpeername request.
-The submission queue entry
-.I sqe
-is setup to fetch the locally bound address or peer address of the socket
-file descriptor pointed by
-.IR sockfd .
-The parameter
-.IR sockaddr
-points to a region of size
-.IR sockaddr_len
-where the output is written.
-.IR sockaddr_len
-is modified by the kernel to indicate how many bytes were written.
-The output address is the locally bound address if
-.IR peer
-is set to
-.B 0
-or the peer address if
-.IR peer
-is set to
-.BR 1 .
-
-This function prepares an async
-.BR getsockname (2)
-or
-.BR getpeername (2)
-request. See those man pages for details.
-
-.SH RETURN VALUE
-None
-.SH ERRORS
-The CQE
-.I res
-field will contain the result of the operation. See the related man page for
-details on possible values. Note that where synchronous system calls will return
-.B -1
-on failure and set
-.I errno
-to the actual error value, io_uring never uses
-.IR errno .
-Instead it returns the negated
-.I errno
-directly in the CQE
-.I res
-field.
-.BR
-Differently from the equivalent system calls, if the user attempts to
-use this operation on a non-socket file descriptor, the CQE error result
-is
-.IR -ENOTSUP
-instead of
-.IR ENOSOCK.
-.SH SEE ALSO
-.BR io_uring_get_sqe (3),
-.BR io_uring_submit (3),
-.BR io_uring_prep_getsockname (2)
-.BR io_uring_prep_getpeername (2)
-- 
2.52.0


