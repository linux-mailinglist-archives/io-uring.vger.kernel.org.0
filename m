Return-Path: <io-uring+bounces-10712-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A08CCC76773
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 23:14:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 473FB3583DA
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 22:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296AE3559F3;
	Thu, 20 Nov 2025 22:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kwxViUbm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/nq4kTaA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kwxViUbm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/nq4kTaA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FEB2FE567
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 22:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676852; cv=none; b=UooiElObeXoX5cZcIPE+VQVQJX+XYyLhFmXQiZk0nWVIu/2Bc0mQ8nBoj4+wbDN26gHKfNWeW58yl/iiMCS17fyL+M84Mtu7OHfieOL0H59tvh05aKMT2C0HZRhfTd6OMdK7CQu5w+iz8A+4fRq8IK37HwVkLH2w8QjUavcO+0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676852; c=relaxed/simple;
	bh=CagJcc8nbj5zlgBq3igfa8tYJBxJ4uwbtq7vjRqMRKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icVaYRp1g1FxdYcYfjDdk4fQqCXqunDWgK6v8iHSEe9s1aZEwqoLvTAGpeZeprvMl5CA/a5fo+mt4C6pYC+TVTjnpCmLyekGrto+Xy6SIyatH+JTPCmW/j3Is4Kzi5hPa6y26zLHKcLiCrJLBLo5tHfmgHCKo0I6uD33AuhC5Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kwxViUbm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/nq4kTaA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kwxViUbm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/nq4kTaA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9CEE221297;
	Thu, 20 Nov 2025 22:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763676846; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWE5Tx8j+/F9pc3u13QEgcCSeAq/6MrqWmz34IC8qmQ=;
	b=kwxViUbmWTcJfdTRolNF3smqRXyD6U4lCKMMQpoV2mcaeJUuv/5jlOLZsnaeYET2xsFXSJ
	YKjfwCbHBy6L9IMZbAGbBwdJ/lVvl5VV8fRtF6F0IZgJnozKv97c3czvJWjgv9K29Sgo/S
	3wQjWK+9Vb8s4WmmxMJNRzRbmGIpDRg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763676846;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWE5Tx8j+/F9pc3u13QEgcCSeAq/6MrqWmz34IC8qmQ=;
	b=/nq4kTaAChhk0Gc9u6bPWBDVAJmT30aFeEvUwvCItNPRVkFcbByAkUjbRnuhThqZsmdu13
	aP3lsJA8etGgKYBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763676846; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWE5Tx8j+/F9pc3u13QEgcCSeAq/6MrqWmz34IC8qmQ=;
	b=kwxViUbmWTcJfdTRolNF3smqRXyD6U4lCKMMQpoV2mcaeJUuv/5jlOLZsnaeYET2xsFXSJ
	YKjfwCbHBy6L9IMZbAGbBwdJ/lVvl5VV8fRtF6F0IZgJnozKv97c3czvJWjgv9K29Sgo/S
	3wQjWK+9Vb8s4WmmxMJNRzRbmGIpDRg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763676846;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWE5Tx8j+/F9pc3u13QEgcCSeAq/6MrqWmz34IC8qmQ=;
	b=/nq4kTaAChhk0Gc9u6bPWBDVAJmT30aFeEvUwvCItNPRVkFcbByAkUjbRnuhThqZsmdu13
	aP3lsJA8etGgKYBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B3FB3EA61;
	Thu, 20 Nov 2025 22:14:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id N2DqC66SH2mpBQAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 20 Nov 2025 22:14:06 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: 
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	io-uring@vger.kernel.org,
	csander@purestorage.com
Subject: [PATCH liburing v2 4/4] man/io_uring_prep_getsockname.3: Add man page
Date: Thu, 20 Nov 2025 17:13:42 -0500
Message-ID: <20251120221351.3802738-5-krisman@suse.de>
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
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

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


