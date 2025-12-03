Return-Path: <io-uring+bounces-10937-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id F2AF8CA17AA
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 20:52:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 62E5B3001E05
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 19:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53AB32FFF90;
	Wed,  3 Dec 2025 19:52:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3C72609C5
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 19:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764791576; cv=none; b=RASASEeIsendp6WMZtHm1cPf07dymK3mQJnPszjHcmvymDf5ubmeZCuv4WC39ps1Dbc/2mSRYGbu5NEuez6cMpPdgkxmE5+zK6ZqwY1c6PodAMyn+6MyfutQkAZJi+ptqSJo0Ss09OQNG1hjJDuoE0SYEcsRbN30MYK34+ecNfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764791576; c=relaxed/simple;
	bh=u2CafPEyHQgq652Wc18huDpftrDelI/KXHv100sS1vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9R3xvXfPvvkLcw/sPOIyk+JcaHyYadL9JDO5WihgcjecnTirytjzYISL3Snbky0IHTtJmPJGZyVyTR2XWof9etpzF5jTO4HuX9FXPiNofbSr6HVJ52NLrYaobeyDi728VxwYPfxGVGnEBfwx4uSssDsfd2WDtdyLZEcHjt2aT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8E80E5BDE3;
	Wed,  3 Dec 2025 19:52:48 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 529693EA63;
	Wed,  3 Dec 2025 19:52:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZhgACBCVMGljUAAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 03 Dec 2025 19:52:48 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	io-uring@vger.kernel.org,
	csander@purestorage.com
Subject: [PATCH liburing v3 4/4] man/io_uring_prep_getsockname.3: Add man page
Date: Wed,  3 Dec 2025 14:52:18 -0500
Message-ID: <20251203195223.3578559-5-krisman@suse.de>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 8E80E5BDE3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

---
since v2:
- Fix Jens comments
---
 man/io_uring_prep_getsockname.3 | 78 +++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 man/io_uring_prep_getsockname.3

diff --git a/man/io_uring_prep_getsockname.3 b/man/io_uring_prep_getsockname.3
new file mode 100644
index 00000000..de78cb40
--- /dev/null
+++ b/man/io_uring_prep_getsockname.3
@@ -0,0 +1,78 @@
+.\" Copyright (C) 2024 SUSE LLC.
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_prep_getsockname 3 "Dec 3, 2025" "liburing-2.13" "liburing Manual"
+.SH NAME
+io_uring_prep_getsockname \- prepare a getsockname or getpeername request
+.SH SYNOPSIS
+.nf
+.B #include <sys/socket.h>
+.B #include <liburing.h>
+.PP
+.BI "void io_uring_prep_getsockname(struct io_uring_sqe *" sqe ","
+.BI "                               int " sockfd ","
+.BI "                               struct sockaddr *" sockaddr ","
+.BI "                               socklen_t *" sockaddr_len ","
+.BI "                               int " peer ");"
+.fi
+.SH DESCRIPTION
+The
+.BR io_uring_prep_getsockname (3)
+function prepares a getsockname/getpeername request.
+The submission queue entry
+.I sqe
+is setup to fetch the locally bound address or peer address of the socket
+file descriptor pointed by
+.IR sockfd .
+The parameter
+.IR sockaddr
+points to a region of size
+.IR sockaddr_len
+where the output is written.
+.IR sockaddr_len
+is modified by the kernel to indicate how many bytes were written.
+The output address is the locally bound address if
+.IR peer
+is set to
+.B 0
+or the peer address if
+.IR peer
+is set to
+.BR 1 .
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
+.IR -ENOTSUP
+instead of
+.IR ENOSOCK.
+.SH SEE ALSO
+.BR io_uring_get_sqe (3),
+.BR io_uring_submit (3),
+.BR io_uring_prep_getsockname (2)
+.BR io_uring_prep_getpeername (2)
-- 
2.52.0


