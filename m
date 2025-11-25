Return-Path: <io-uring+bounces-10801-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 203A6C873A5
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 22:27:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0F9B84E0728
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 21:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5812FB0BC;
	Tue, 25 Nov 2025 21:27:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78084231858
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 21:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764106061; cv=none; b=KvO6GVmVqNyYgGucy4uwO9PBdenTP70O7E+0100nJ8TB6mOXMmmJ8vrfY3ZVkgGv/L/FBpB6Vcc0pG9WlRoNffiuE94zCzo6YiO6tDVxeIpDyqgm7rlIdzfRij2V9nMVqvPnTKzkBhPdITv6wAUr/nJv/sWL+5WRQ3mBEeJfmi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764106061; c=relaxed/simple;
	bh=CagJcc8nbj5zlgBq3igfa8tYJBxJ4uwbtq7vjRqMRKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ML94tT2ZWX+USFpp9dwWWQwKPqnL6QDXIuumBDjeRjFkWdNl0pbKRnArlwD3Dq+Y0uoJ7KxGE4Qb+Hr/qhpbxFGmh0+qKMSCt1EN1Mjl9wiU8H/FUnbHLtBvXdIwg+qnfxkSZuZe36PvBT3YlG662k2rJzAVSo9PSg9TJKtlNbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3A37922971;
	Tue, 25 Nov 2025 21:27:34 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F28183EA63;
	Tue, 25 Nov 2025 21:27:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2kHGNEUfJmngdwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 25 Nov 2025 21:27:33 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	csander@purestorage.com
Subject: [PATCH liburing v2 4/4] man/io_uring_prep_getsockname.3: Add man page
Date: Tue, 25 Nov 2025 16:27:15 -0500
Message-ID: <20251125212715.2679630-5-krisman@suse.de>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 3A37922971
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 man/io_uring_prep_getsockname.3 | 76 +++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 man/io_uring_prep_getsockname.3

diff --git a/man/io_uring_prep_getsockname.3 b/man/io_uring_prep_getsockname.3
new file mode 100644
index 00000000..71e65f1d
--- /dev/null
+++ b/man/io_uring_prep_getsockname.3
@@ -0,0 +1,76 @@
+.\" Copyright (C) 2024 SUSE LLC.
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_prep_getsockname 3 "Oct 23, 2025" "liburing-2.11" "liburing Manual"
+.SH NAME
+io_uring_prep_getsockname \- prepare a getsockname or getpeername request
+.SH SYNOPSIS
+.nf
+.B #include <sys/socket.h>
+.B #include <liburing.h>
+.PP
+.BI "void io_uring_prep_getsockname(struct io_uring_sqe *" sqe ","
+.BI "                          int " sockfd ","
+.BI "                          struct sockaddr *" sockaddr ","
+.BI "                          socklen_t *" sockaddr_len ","
+.BI "                          int " peer ");"
+.fi
+.SH DESCRIPTION
+The
+.BR io_uring_prep_getsockname (3)
+function prepares a getsockname/getpeername request.
+The submission queue entry
+.I sqe
+is setup to fetch the locally bound address or peer address of the socket
+file descriptor pointed by
+.IR sockfd.
+The parameter
+.IR sockaddr
+points to a region of size
+.IR sockaddr_len
+where the output is written.
+.IR sockaddr_len
+is modified by the kernel to indicate how many bytes were written.
+The output address is the locally bound address if
+.IR peer
+is set to 0
+or the peer address if
+.IR peer
+is set to 1.
+
+This function prepares an async
+.BR getsockname (2)
+or
+.BR getpeername (2)
+request. See those man pages for details.
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
+.BR
+Differently from the equivalent system calls, if the user attempts to
+use this operation on a non-socket file descriptor, the CQE error result
+is
+.IR ENOTSUP
+instead of
+.IR ENOSOCK.
+.SH SEE ALSO
+.BR io_uring_get_sqe (3),
+.BR io_uring_submit (3),
+.BR io_uring_prep_getsockname (2)
+.BR io_uring_prep_getpeername (2)
-- 
2.51.0


