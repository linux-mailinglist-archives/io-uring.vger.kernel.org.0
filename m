Return-Path: <io-uring+bounces-2550-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE7C793A9BA
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 01:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A949B21041
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 23:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97553148FFA;
	Tue, 23 Jul 2024 23:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mQLsdEue";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lWCdNXI1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mQLsdEue";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lWCdNXI1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCFC13BAD5
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 23:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721776664; cv=none; b=Zazt0I9B6EI6c8Tq4liACbQoAZmSseVKYVZXc+iwHfotTAJOI9E6ONpjInoNGhDr41cfTrGCobztNqpIRzGLXsy0bkEajYIUefuXQgCTSa91Fr+D7QrKNkKVKJPdw8HTVIP+EhWc2PJsGfsI3pLy4rcpcrURD9W6AcOBrjv25Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721776664; c=relaxed/simple;
	bh=YRsmLqs+mcr/8GQ2emrNeN/WE9qOakv6xuGXI66fEmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXj0WRDNj3gC+L3jj/cAZGakwjZNcNaBSUYaz2fKmkcmqTO59mBSRKIJh8Og5sAS0w/rkL8lfYBU6HDzWiRUSo9bsvj2s0dYgE3l4dREFK6+pwyd2XQH3Kbl4D+1XJ/Fw5kwMw7tcDkECgf7/uXexnhtAz4xuzUc5oW7S2VaFUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mQLsdEue; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lWCdNXI1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mQLsdEue; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lWCdNXI1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3341621A90;
	Tue, 23 Jul 2024 23:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/o7IwQqYTpr4+vLXaPoKhLo8vrPpETIFenKCk3H9JR0=;
	b=mQLsdEue9n72WvpBZe6QZiscYIxFhjUsu/yJtPKDlF+dU/ptLZ/17F7afnPP+13L2W/vX6
	hGlwGFFVaRaf214xQqZdhwTXSgK5ycdnAWubemNl77q7kpyzTZR7cqT9eblwetIJu4RvRg
	K2sNbJqWWWv7mJQRRtLkWBLrMLIxXZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776661;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/o7IwQqYTpr4+vLXaPoKhLo8vrPpETIFenKCk3H9JR0=;
	b=lWCdNXI1dJLZdzR0ymkAaiiI+A/mWh5Qng2D2ep2kzH8xHXOPrpYUz9dmSzZyeHAoCu/yc
	SmqJ8VE5HJqSckAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/o7IwQqYTpr4+vLXaPoKhLo8vrPpETIFenKCk3H9JR0=;
	b=mQLsdEue9n72WvpBZe6QZiscYIxFhjUsu/yJtPKDlF+dU/ptLZ/17F7afnPP+13L2W/vX6
	hGlwGFFVaRaf214xQqZdhwTXSgK5ycdnAWubemNl77q7kpyzTZR7cqT9eblwetIJu4RvRg
	K2sNbJqWWWv7mJQRRtLkWBLrMLIxXZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776661;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/o7IwQqYTpr4+vLXaPoKhLo8vrPpETIFenKCk3H9JR0=;
	b=lWCdNXI1dJLZdzR0ymkAaiiI+A/mWh5Qng2D2ep2kzH8xHXOPrpYUz9dmSzZyeHAoCu/yc
	SmqJ8VE5HJqSckAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF79A13874;
	Tue, 23 Jul 2024 23:17:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pMt3NBQ6oGbJUgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 23 Jul 2024 23:17:40 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing v2 2/5] liburing: Add helper to prepare IORING_OP_LISTEN command
Date: Tue, 23 Jul 2024 19:17:30 -0400
Message-ID: <20240723231733.31884-3-krisman@suse.de>
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
X-Spamd-Result: default: False [-1.10 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,suse.de];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -1.10

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 src/include/liburing.h          | 6 ++++++
 src/include/liburing/io_uring.h | 1 +
 src/liburing-ffi.map            | 1 +
 3 files changed, 8 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 04cb65c..c935efa 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -676,6 +676,12 @@ IOURINGINLINE void io_uring_prep_bind(struct io_uring_sqe *sqe, int fd,
 	io_uring_prep_rw(IORING_OP_BIND, sqe, fd, addr, 0, addrlen);
 }
 
+IOURINGINLINE void io_uring_prep_listen(struct io_uring_sqe *sqe, int fd,
+				      int backlog)
+{
+	io_uring_prep_rw(IORING_OP_LISTEN, sqe, fd, 0, backlog, 0);
+}
+
 IOURINGINLINE void io_uring_prep_files_update(struct io_uring_sqe *sqe,
 					      int *fds, unsigned nr_fds,
 					      int offset)
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 177ace6..f99d41f 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -258,6 +258,7 @@ enum io_uring_op {
 	IORING_OP_FIXED_FD_INSTALL,
 	IORING_OP_FTRUNCATE,
 	IORING_OP_BIND,
+	IORING_OP_LISTEN,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index de2cb09..0cbf14c 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -202,4 +202,5 @@ LIBURING_2.7 {
 		io_uring_prep_fadvise64;
 		io_uring_prep_madvise64;
 		io_uring_prep_bind;
+		io_uring_prep_listen;
 } LIBURING_2.6;
-- 
2.45.2


