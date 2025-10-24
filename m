Return-Path: <io-uring+bounces-10197-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 045B8C07164
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 17:52:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7E20735C1FA
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 15:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69AA31D36C;
	Fri, 24 Oct 2025 15:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BOx/cqIf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jmtKGI6X";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BOx/cqIf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jmtKGI6X"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCD1314A84
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 15:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761321136; cv=none; b=gOjMP2OyXgaDTXLbDVuzld/dzMyO7h66tUWfAO8WfXNpnuWDj3L2PmkusNoSQ6rwwoEtfoxqyOdxQ/4oQ9YoGSoyjUCP7uMPLc8MKzH6a6XD9bsSxbWDmp8ITKpH8BUGfkUL8fBRSJcLlyIpzlmA8AbSqyZM4v3BN0gY98Np3lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761321136; c=relaxed/simple;
	bh=CagJcc8nbj5zlgBq3igfa8tYJBxJ4uwbtq7vjRqMRKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JS907Z9didh+aO75W0I8CR7OR6mpU2kArnQboVyKiGiTxs3uQ1LGVSI+1QBFwxzrjOAsd/CAkP6MudzztUtBBx0n6i+UFDLVNSv4mikJgSJUe6ghSYmn3hzI8gIxjfYGyCp3W6llc7NzymrCHO1EoA9lyGuPzRUmOtKfiHfPErg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BOx/cqIf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jmtKGI6X; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BOx/cqIf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jmtKGI6X; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4290D1F45B;
	Fri, 24 Oct 2025 15:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761321120; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWE5Tx8j+/F9pc3u13QEgcCSeAq/6MrqWmz34IC8qmQ=;
	b=BOx/cqIfj6FECCKSYiPF+dlXRAMUWXACKH+Emib77YIqDekqj3u9EDDgQTcu/iW8fGPlQn
	ujhPjrnxYenM9ZLBZbgYoD7OaOZrap0tmNFi9zo7ur0SPT/qRFd8PsTEKV07FZtHEnnAKz
	fEgpkh7QhcosTgx3QeYKrY5r9JWHfcY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761321120;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWE5Tx8j+/F9pc3u13QEgcCSeAq/6MrqWmz34IC8qmQ=;
	b=jmtKGI6XvyzNYSb/SH1V+WCpq2+bbS+zpOXimwAcDWXcy8JIcTePBdE0Y342yR6rlr05c3
	YzY1W0TVLE35WWDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="BOx/cqIf";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jmtKGI6X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761321120; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWE5Tx8j+/F9pc3u13QEgcCSeAq/6MrqWmz34IC8qmQ=;
	b=BOx/cqIfj6FECCKSYiPF+dlXRAMUWXACKH+Emib77YIqDekqj3u9EDDgQTcu/iW8fGPlQn
	ujhPjrnxYenM9ZLBZbgYoD7OaOZrap0tmNFi9zo7ur0SPT/qRFd8PsTEKV07FZtHEnnAKz
	fEgpkh7QhcosTgx3QeYKrY5r9JWHfcY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761321120;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWE5Tx8j+/F9pc3u13QEgcCSeAq/6MrqWmz34IC8qmQ=;
	b=jmtKGI6XvyzNYSb/SH1V+WCpq2+bbS+zpOXimwAcDWXcy8JIcTePBdE0Y342yR6rlr05c3
	YzY1W0TVLE35WWDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 071B7132C2;
	Fri, 24 Oct 2025 15:51:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JqXCNp+g+2gfFAAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 24 Oct 2025 15:51:59 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 4/4] man/io_uring_prep_getsockname.3: Add man page
Date: Fri, 24 Oct 2025 11:51:35 -0400
Message-ID: <20251024155135.798465-5-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024155135.798465-1-krisman@suse.de>
References: <20251024155135.798465-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 4290D1F45B
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -3.01

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


