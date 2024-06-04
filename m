Return-Path: <io-uring+bounces-2084-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7081B8FA6C2
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 02:04:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24F4E286221
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 00:04:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC278182;
	Tue,  4 Jun 2024 00:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j6ve/mf4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="az7zux5W";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j6ve/mf4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="az7zux5W"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB7637C
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 00:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717459475; cv=none; b=mB8SchVR3WGsmy8J+6nr8N2/KCbDTeIeamXc02acBXPMRSztBTb30FVTq982sRwFZuQxta/RZX/raHW8FDylaQoj72PpPv7GtRP2cfQRD5VAdR2H9BCkAdwnOxHCxc+v/JVDw7mAI66HAzTJJ8atehC/RVwqpzP8qy7xy6VpQXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717459475; c=relaxed/simple;
	bh=v/XzqDYU3QJ3QLcQjzFB+MNngNS8WDtkdBulHItyEBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOml1M0sEaFesWf0CCixJ5plBLqLa9YMUqOksfWmGzPvpDzu5zYowdeQk8RPBzm+FoMwez97Pw2gyTSkYmv5TYSJPvZQ0zIAxNvrdW0jzSNwNTEYL1J4r/e3eJI5qGXojMVjp+GGuUm/2HqgIh5IaSR2T/+B3FPIx+8p6HP3Wy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j6ve/mf4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=az7zux5W; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j6ve/mf4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=az7zux5W; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E0D4B21982;
	Tue,  4 Jun 2024 00:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717459471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NCbhk9G2oaoBxNVS3a2NgF5lzZaGKlq3XLjb+9OD8KM=;
	b=j6ve/mf4Px0q9m8sXi+Fja9Ut/OUzxYAMvNR0zCrknxjzuZ6NcR9XaKfJXCkfG4Rt0tmh4
	rfkWULmZHMFS/eqLBNxFU+X8g1JK7iOfKTfSW9mshFVud4zbADyTt3BMQgWKlDsz8Y2NIn
	aLKKQ2FvB77g6ZlSkGNXvZZVoAldtTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717459471;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NCbhk9G2oaoBxNVS3a2NgF5lzZaGKlq3XLjb+9OD8KM=;
	b=az7zux5WAd0RwOFist8KqDZttnJ7R7M3ETHukpU2D33xgHp4ibYUG0Rx9m/bHXVMWH7KZi
	hGJVI9+/ng9w1+Dg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="j6ve/mf4";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=az7zux5W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717459471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NCbhk9G2oaoBxNVS3a2NgF5lzZaGKlq3XLjb+9OD8KM=;
	b=j6ve/mf4Px0q9m8sXi+Fja9Ut/OUzxYAMvNR0zCrknxjzuZ6NcR9XaKfJXCkfG4Rt0tmh4
	rfkWULmZHMFS/eqLBNxFU+X8g1JK7iOfKTfSW9mshFVud4zbADyTt3BMQgWKlDsz8Y2NIn
	aLKKQ2FvB77g6ZlSkGNXvZZVoAldtTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717459471;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NCbhk9G2oaoBxNVS3a2NgF5lzZaGKlq3XLjb+9OD8KM=;
	b=az7zux5WAd0RwOFist8KqDZttnJ7R7M3ETHukpU2D33xgHp4ibYUG0Rx9m/bHXVMWH7KZi
	hGJVI9+/ng9w1+Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D89913A92;
	Tue,  4 Jun 2024 00:04:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p1BGIA9aXmZ+CwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 04 Jun 2024 00:04:31 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 1/5] liburing: Add helper to prepare IORING_OP_BIND command
Date: Mon,  3 Jun 2024 20:04:13 -0400
Message-ID: <20240604000417.16137-2-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240604000417.16137-1-krisman@suse.de>
References: <20240604000417.16137-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-5.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E0D4B21982
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -5.01

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 src/include/liburing.h          | 7 +++++++
 src/include/liburing/io_uring.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 0a02364..818e27c 100644
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
-- 
2.44.0


