Return-Path: <io-uring+bounces-10798-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA99C8739C
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 22:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 34B5234ECEA
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 21:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA11231858;
	Tue, 25 Nov 2025 21:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dj299DPN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uZ7nFE4+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dj299DPN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uZ7nFE4+"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815892264A9
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 21:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764106048; cv=none; b=RpKVgQgOLelShujVXjVyJr+IL0bd/XFIxqmQyZ9BUPTe2opAgeO/rqKqQzzyT9cs/5giWuFJQILP/UHS7dhvQ8iYdf8WvKL9EKWFmuTuhHiaXSTo8Fckpa3pGzj136YrZV1/14FIPfPy600XaZl7ulCwyFrHDBd6yIH0qrnWVAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764106048; c=relaxed/simple;
	bh=njscxX8Tt0E7kiZkORL8M0UW6fGCNfJsxoF6/X/uKKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7+UCTcs+EDsUXeLw7rKG5CyrqdH5UUZGfIvSa0Nc383QN5OLHFe/opq3IabGINkV3DpU2ABzvGWqM2sHE5QiIqdilnA2IjixeHV0c5+H4UB+utuWVcvqt+0IPdB8TaMNLhWWmoVHDAHNv4+SPHNBrapfTR2maHE0+//OyLWrcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dj299DPN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uZ7nFE4+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dj299DPN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uZ7nFE4+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C99695BD61;
	Tue, 25 Nov 2025 21:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764106044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IwjJydqw4fmOu2DnMwdqCv9RvphV39m7bpsVRwII5FQ=;
	b=dj299DPNq2I7CKQLPK8Y/on6Gs9aaI+e0o2Y+5yUw/bTS+RzAGxqM7c1nZtpw5nrkLiz6D
	2Melfa9Wh9I4GwSOfzShSRxObZtWtb2b1oHwV5FJX0pDCU3aDvaxVb+5iQHL33y3/U/1UP
	Z6czh5OXeX/+q0FPDkfzQIBXnuejxcI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764106044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IwjJydqw4fmOu2DnMwdqCv9RvphV39m7bpsVRwII5FQ=;
	b=uZ7nFE4+Pj/tjOdry/dei/Inw4dm7mTGQHN1dXwXyejPPf1+KGVD+kqQFJqCPTIgIIoWLh
	KwwA58M6gdHEfMBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764106044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IwjJydqw4fmOu2DnMwdqCv9RvphV39m7bpsVRwII5FQ=;
	b=dj299DPNq2I7CKQLPK8Y/on6Gs9aaI+e0o2Y+5yUw/bTS+RzAGxqM7c1nZtpw5nrkLiz6D
	2Melfa9Wh9I4GwSOfzShSRxObZtWtb2b1oHwV5FJX0pDCU3aDvaxVb+5iQHL33y3/U/1UP
	Z6czh5OXeX/+q0FPDkfzQIBXnuejxcI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764106044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IwjJydqw4fmOu2DnMwdqCv9RvphV39m7bpsVRwII5FQ=;
	b=uZ7nFE4+Pj/tjOdry/dei/Inw4dm7mTGQHN1dXwXyejPPf1+KGVD+kqQFJqCPTIgIIoWLh
	KwwA58M6gdHEfMBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8CF3C3EA63;
	Tue, 25 Nov 2025 21:27:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2Z3NGzwfJmmadwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 25 Nov 2025 21:27:24 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	csander@purestorage.com
Subject: [PATCH liburing v2 1/4] liburing: Introduce getsockname operation
Date: Tue, 25 Nov 2025 16:27:12 -0500
Message-ID: <20251125212715.2679630-2-krisman@suse.de>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -6.80

This implements the functionality of getsockname(2) and getpeername(2)
under a single operation.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 src/include/liburing.h          | 13 +++++++++++++
 src/include/liburing/io_uring.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 83819eb7..1626f3bb 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1572,6 +1572,19 @@ IOURINGINLINE void io_uring_prep_cmd_sock(struct io_uring_sqe *sqe,
 	sqe->level = level;
 }
 
+IOURINGINLINE void io_uring_prep_cmd_getsockname(struct io_uring_sqe *sqe,
+						 int fd, struct sockaddr *sockaddr,
+						 socklen_t *sockaddr_len,
+						 int peer)
+	LIBURING_NOEXCEPT
+{
+	io_uring_prep_uring_cmd(sqe, SOCKET_URING_OP_GETSOCKNAME, fd);
+
+	sqe->addr = (uintptr_t) sockaddr;
+	sqe->addr3 = (unsigned long) (uintptr_t) sockaddr_len;
+	sqe->optlen = peer;
+}
+
 IOURINGINLINE void io_uring_prep_waitid(struct io_uring_sqe *sqe,
 					idtype_t idtype,
 					id_t id,
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index a54e5b42..8e8b8e6a 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -966,6 +966,7 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_GETSOCKOPT,
 	SOCKET_URING_OP_SETSOCKOPT,
 	SOCKET_URING_OP_TX_TIMESTAMP,
+	SOCKET_URING_OP_GETSOCKNAME,
 };
 
 /*
-- 
2.51.0


