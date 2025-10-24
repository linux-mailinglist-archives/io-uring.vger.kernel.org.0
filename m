Return-Path: <io-uring+bounces-10194-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F0E55C0717C
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 17:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 26DA44EDAD7
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 15:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F6523D7E6;
	Fri, 24 Oct 2025 15:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BeabsD7Y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/zuyM3Jr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BeabsD7Y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/zuyM3Jr"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5CE13C695
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761321116; cv=none; b=hkgufuKKhxzm00H2nnFWP1Al6PwjKMbOhOyuqKL4OESn57UyDu7ZCLHdL/W07Mu0uXp49OpTQ4ExAy1FqJoOnH+dqUu8V0sXgvyI3ZJYIA4bBr4kBrbPp0zXP1Dl7UCkbZYidX8wBR5xeBmlOVKfhAlEdLxFdYrtlhH0RuStumw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761321116; c=relaxed/simple;
	bh=fEo5TM15Q9AGqfuX1ARaHNwvqfcIpdT2fxQrZcdWieM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkWIoWoJusXZqrmf2mgWPXmDyX6YBwiaqJKkAf2ZwAfaFsatHwvQpoSdSY2ebHuoiZcX8ZnhIh58iMzad1GrmXlNecwmM7i1LOzF+waXubvWLFUqR4afMha/LMsnumeSz4Mor88FXnTq3bWB1DSMRRRvGgZ+jRf8M2ChMansTSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BeabsD7Y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/zuyM3Jr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BeabsD7Y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/zuyM3Jr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 91D251F443;
	Fri, 24 Oct 2025 15:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761321113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nTmuAXaPxtj85CKz67xNsEbizqKVMgVnJetFxzIqyOg=;
	b=BeabsD7YeEgieJymXivJvlgUTQSMQv21T8syPC/TJwEQaeyk/0X6OgZZEOsK04lJSyP/9L
	gspoYnILiBr2/wB/Gpzkpcpdji1AXfrYunVsIHuwCzFANBSzJ7ntibNs+yujGZMKsjyKUM
	iI6z52UneG7QJsZeTRCgPqHE7MFPRyc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761321113;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nTmuAXaPxtj85CKz67xNsEbizqKVMgVnJetFxzIqyOg=;
	b=/zuyM3JrQuTFA9vU/8BwMbpS7jD3QR/g3vs8w1xPBbrcZo40L1jkhm1l51WbAN+HK8THtH
	m0ZCNk61aT7rcMBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761321113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nTmuAXaPxtj85CKz67xNsEbizqKVMgVnJetFxzIqyOg=;
	b=BeabsD7YeEgieJymXivJvlgUTQSMQv21T8syPC/TJwEQaeyk/0X6OgZZEOsK04lJSyP/9L
	gspoYnILiBr2/wB/Gpzkpcpdji1AXfrYunVsIHuwCzFANBSzJ7ntibNs+yujGZMKsjyKUM
	iI6z52UneG7QJsZeTRCgPqHE7MFPRyc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761321113;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nTmuAXaPxtj85CKz67xNsEbizqKVMgVnJetFxzIqyOg=;
	b=/zuyM3JrQuTFA9vU/8BwMbpS7jD3QR/g3vs8w1xPBbrcZo40L1jkhm1l51WbAN+HK8THtH
	m0ZCNk61aT7rcMBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 40873132C2;
	Fri, 24 Oct 2025 15:51:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V/6SA5mg+2gVFAAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 24 Oct 2025 15:51:53 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 1/4] liburing: Introduce getsockname operation
Date: Fri, 24 Oct 2025 11:51:32 -0400
Message-ID: <20251024155135.798465-2-krisman@suse.de>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

This implements the functionality of getsockname(2) and getpeername(2)
under a single operation.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 src/include/liburing.h          | 12 ++++++++++++
 src/include/liburing/io_uring.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 83819eb7..77b0a135 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1572,6 +1572,18 @@ IOURINGINLINE void io_uring_prep_cmd_sock(struct io_uring_sqe *sqe,
 	sqe->level = level;
 }
 
+IOURINGINLINE void io_uring_prep_cmd_getsockname(struct io_uring_sqe *sqe,
+						 int fd, struct sockaddr *sockaddr,
+						 socklen_t *sockaddr_len,
+						 int peer)
+	LIBURING_NOEXCEPT
+{
+	io_uring_prep_rw(IORING_OP_URING_CMD, sqe, fd, sockaddr, 0, 0);
+	sqe->cmd_op = SOCKET_URING_OP_GETSOCKNAME;
+	sqe->addr3 = (unsigned long) (uintptr_t) sockaddr_len;
+	sqe->optlen = peer;
+}
+
 IOURINGINLINE void io_uring_prep_waitid(struct io_uring_sqe *sqe,
 					idtype_t idtype,
 					id_t id,
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 44ce8229..365f0584 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -950,6 +950,7 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_GETSOCKOPT,
 	SOCKET_URING_OP_SETSOCKOPT,
 	SOCKET_URING_OP_TX_TIMESTAMP,
+	SOCKET_URING_OP_GETSOCKNAME,
 };
 
 /*
-- 
2.51.0


