Return-Path: <io-uring+bounces-2549-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8986193A9B7
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 01:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A74211C2240C
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 23:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A29B148FE6;
	Tue, 23 Jul 2024 23:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FwiZeiWG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="R5E2eYxp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FwiZeiWG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="R5E2eYxp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888EB28E8
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 23:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721776663; cv=none; b=UXtz9csCIPzFocfKzVvL5l8ukiKUr4N3teDJCSzSEm2CMf3gXo6t58hrd3iHTFWjlqTkiOK2d7W4d+kFBXak01CQv3UjofWjVGR/WdWjLxg2dvFT3QuVurWnMPYelBZ/wwHgNvbA+29KFHtyHYMT4xNWE2E754T2RlwQ+Krd1kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721776663; c=relaxed/simple;
	bh=C6LNVpl/17eXlW53K1xrqM9EvtpDKXdKMWa27rwkK6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeDQx/wL1R2jddJT87w3rGJMCCOnSDcHXvKmgVZD/bdKiHiGVUfRDR/QzKhBv2utBS8RLROpQNw19jH6pJUaASkrjdVcPHj6RVYIuNjkOkfjZMXJT8UdDtXHgqSbOH6TPS3ObdMtJHIXLQjtGSYie7jcB/jxeV9ebORpngftyHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FwiZeiWG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=R5E2eYxp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FwiZeiWG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=R5E2eYxp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A50FA21A82;
	Tue, 23 Jul 2024 23:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NVLyWzkbiIhSKVVLml5nISmdjgGm06FStNYv7RFmW4k=;
	b=FwiZeiWGeBL70S69C0+DZ+5arzxy6AdcfOfwjNYdolkKrXlwMQ/4aXgbQdTzCVyen7Y1Pj
	Ck3sHKkgpPh8fqjEnaFsBbLtSQmjl1SC4E3jY7zQvKP+CbGeOhPvxw5FwUuarUUWtu+Fxf
	zooe49E9X9AxCuSw3wYwWFdmX8jhGNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776659;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NVLyWzkbiIhSKVVLml5nISmdjgGm06FStNYv7RFmW4k=;
	b=R5E2eYxphUKMqLWvoKYL76GWQLibtR6f59sdeeB0i+hxCg+7u0HUrEe+UDtHe/GG7VHR2b
	+P1iInOMoa59LDCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FwiZeiWG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=R5E2eYxp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NVLyWzkbiIhSKVVLml5nISmdjgGm06FStNYv7RFmW4k=;
	b=FwiZeiWGeBL70S69C0+DZ+5arzxy6AdcfOfwjNYdolkKrXlwMQ/4aXgbQdTzCVyen7Y1Pj
	Ck3sHKkgpPh8fqjEnaFsBbLtSQmjl1SC4E3jY7zQvKP+CbGeOhPvxw5FwUuarUUWtu+Fxf
	zooe49E9X9AxCuSw3wYwWFdmX8jhGNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776659;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NVLyWzkbiIhSKVVLml5nISmdjgGm06FStNYv7RFmW4k=;
	b=R5E2eYxphUKMqLWvoKYL76GWQLibtR6f59sdeeB0i+hxCg+7u0HUrEe+UDtHe/GG7VHR2b
	+P1iInOMoa59LDCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B6EB13874;
	Tue, 23 Jul 2024 23:17:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wDn4ExM6oGbGUgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 23 Jul 2024 23:17:39 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing v2 1/5] liburing: Add helper to prepare IORING_OP_BIND command
Date: Tue, 23 Jul 2024 19:17:29 -0400
Message-ID: <20240723231733.31884-2-krisman@suse.de>
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
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -1.31
X-Rspamd-Queue-Id: A50FA21A82

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 src/include/liburing.h          | 7 +++++++
 src/include/liburing/io_uring.h | 1 +
 src/liburing-ffi.map            | 1 +
 3 files changed, 9 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index e8626f0..04cb65c 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -669,6 +669,13 @@ IOURINGINLINE void io_uring_prep_connect(struct io_uring_sqe *sqe, int fd,
 	io_uring_prep_rw(IORING_OP_CONNECT, sqe, fd, addr, 0, addrlen);
 }
 
+IOURINGINLINE void io_uring_prep_bind(struct io_uring_sqe *sqe, int fd,
+				      struct sockaddr *addr,
+				      socklen_t addrlen)
+{
+	io_uring_prep_rw(IORING_OP_BIND, sqe, fd, addr, 0, addrlen);
+}
+
 IOURINGINLINE void io_uring_prep_files_update(struct io_uring_sqe *sqe,
 					      int *fds, unsigned nr_fds,
 					      int offset)
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 9330733..177ace6 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -257,6 +257,7 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAITV,
 	IORING_OP_FIXED_FD_INSTALL,
 	IORING_OP_FTRUNCATE,
+	IORING_OP_BIND,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 0e4bd9d..de2cb09 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -201,4 +201,5 @@ LIBURING_2.6 {
 LIBURING_2.7 {
 		io_uring_prep_fadvise64;
 		io_uring_prep_madvise64;
+		io_uring_prep_bind;
 } LIBURING_2.6;
-- 
2.45.2


