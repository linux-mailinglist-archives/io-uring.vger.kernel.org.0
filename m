Return-Path: <io-uring+bounces-2039-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2FE8D6B53
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 23:14:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FB441F2ACC4
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 21:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210157FBA3;
	Fri, 31 May 2024 21:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jhTjb5PO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7vwH7OiD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jhTjb5PO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7vwH7OiD"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762177D071;
	Fri, 31 May 2024 21:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717190009; cv=none; b=St6GCuBwHfArr/WW0sMGq3S69atpD/ha0mOfH42rlG5UBL+05uqd6mQSr0FuvbijHs3bVzEO1CkGVnJ8IfR5vmT2fcjJMbpgONWBLhh+3uBhG5yaskx05x/WF8jQm4tlGDmd5BLaS2JsrSAnXSqTtTIxFQJCHC6+pouD85NeB3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717190009; c=relaxed/simple;
	bh=IArbwbe/5xwHVcGTdFIgMD+qJwWsJNnbtXMyPYX07LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkfKWZDIS5VOdpG/fQ42M7x2AU6OI7kVBbHWHa6BciqzOkyjUuQq4VA8FVhEOTnT1kbfIr276ml1JChcV5IJOAuR2h9g6zZ4eQptBkdt7wa4rNXpO4Wa4MNHgHpX67LnzT7jp47CX6n8OuYJn3SOn0dT330N0R9d6fETz4oss6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jhTjb5PO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7vwH7OiD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jhTjb5PO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7vwH7OiD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA9B01F393;
	Fri, 31 May 2024 21:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717190005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4LwpemSW1BlPMej3rVXFARd3I83W7X7h2oJRD8Kuiic=;
	b=jhTjb5POwD0jGy9KhRndxSsylvzDRfh6Dv8UQps0PgEY3RLOIysFWvP8mPoppO5k0nQeCB
	FijUX1MqZbCPiIH9Eg9R5rJDNhTw2gF7socoA+CUXbJzhCDw+jcyU+pphINBBvEND70wsN
	nZhkTWZKL+T9U+ut4frI89uOJRQ5q40=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717190005;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4LwpemSW1BlPMej3rVXFARd3I83W7X7h2oJRD8Kuiic=;
	b=7vwH7OiDAo4IRVIISVWrfIovP2083UzA13PkRrdn1FNIGhZe5qBxtekJaNmZLQoCjosr6f
	rXmDGy0pO0Z8v8Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717190005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4LwpemSW1BlPMej3rVXFARd3I83W7X7h2oJRD8Kuiic=;
	b=jhTjb5POwD0jGy9KhRndxSsylvzDRfh6Dv8UQps0PgEY3RLOIysFWvP8mPoppO5k0nQeCB
	FijUX1MqZbCPiIH9Eg9R5rJDNhTw2gF7socoA+CUXbJzhCDw+jcyU+pphINBBvEND70wsN
	nZhkTWZKL+T9U+ut4frI89uOJRQ5q40=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717190005;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4LwpemSW1BlPMej3rVXFARd3I83W7X7h2oJRD8Kuiic=;
	b=7vwH7OiDAo4IRVIISVWrfIovP2083UzA13PkRrdn1FNIGhZe5qBxtekJaNmZLQoCjosr6f
	rXmDGy0pO0Z8v8Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71F06137C3;
	Fri, 31 May 2024 21:13:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ok6xFXU9Wma3agAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 31 May 2024 21:13:25 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 1/5] io_uring: Fix leak of async data when connect prep fails
Date: Fri, 31 May 2024 17:12:07 -0400
Message-ID: <20240531211211.12628-2-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240531211211.12628-1-krisman@suse.de>
References: <20240531211211.12628-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]

move_addr_to_kernel can fail, like if the user provides a bad sockaddr
pointer. In this case where the failure happens on ->prep() we don't
have a chance to clean the request later, so handle it here.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/net.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 0a48596429d9..c3377e70aeeb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1657,6 +1657,7 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_connect *conn = io_kiocb_to_cmd(req, struct io_connect);
 	struct io_async_msghdr *io;
+	int ret;
 
 	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
@@ -1669,7 +1670,10 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(!io))
 		return -ENOMEM;
 
-	return move_addr_to_kernel(conn->addr, conn->addr_len, &io->addr);
+	ret = move_addr_to_kernel(conn->addr, conn->addr_len, &io->addr);
+	if (ret)
+		io_netmsg_recycle(req, 0);
+	return ret;
 }
 
 int io_connect(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.44.0


