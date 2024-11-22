Return-Path: <io-uring+bounces-4995-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 124159D6557
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 22:16:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83D8C161317
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 21:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A810156F3A;
	Fri, 22 Nov 2024 21:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ya5lK9Vn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EG1WY9Te";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A1xonI0Z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+mY64JaK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83B254F95
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 21:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732310172; cv=none; b=dzUR4bdc3G+rvqR60s9q8j209ju5kfMrm4TNTaH5Sp5Lr33ALjMtkDI1VDUka7yzEFVI0LEMBnCVGBjqpmJj3h4+R41mHZZpZf+Vbi/bn4nHcieHJdYeGtVTCHlVrWPU3+VNTC2lsjauSfNHWPQw65GRZnUEt4yma6yJarGRsD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732310172; c=relaxed/simple;
	bh=o3XWb+ztFT4nsPWZIrjZBjjgOz24AeHFlG1kxx8yMMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmV6dvmbqIfE7fOSW5llZ+fbtXUJ00MvUw/B1NH4wV1HvjEpdvYhcNOXfEteqoqWbb81o+lb+b0jzc+0oItPWogW5HscMzC0Ez0rAi1WL/ggKcJOttAq91Y4Ap+IE2wStLPa/iciN1rzoNd0C8oqgo71MaA5dqihLDVygVpavOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ya5lK9Vn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EG1WY9Te; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A1xonI0Z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+mY64JaK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AD01021200;
	Fri, 22 Nov 2024 21:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310168; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i37RvDHe3b/txmys4XbZFO1wo8mNN+93QYUjCHcPtm4=;
	b=ya5lK9VnxONYmIWbIpTnZlEOKnFBMMIpnHl4SD9T8F9kSwjou1GEBO4zNzOcZqnukwgshq
	P45Hr6S7DQ4QJLfbyARhtp3XonZhBY11DlrxBL7HUhyrYlfxNknaRfQ+e1+J+1iJfl3oFb
	WxbcMpYwoDTmB+Yxc52+0Cad5xHuOyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310168;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i37RvDHe3b/txmys4XbZFO1wo8mNN+93QYUjCHcPtm4=;
	b=EG1WY9TeGx4mvAATYuDA7lVuYb2xwha6DUB3ABsptxXoVWoPmMZ2Ewdn9NYI/y/9a9wMLU
	K3VyNs6ZyOiZrDDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i37RvDHe3b/txmys4XbZFO1wo8mNN+93QYUjCHcPtm4=;
	b=A1xonI0ZodNh9fUDhFKK3BcJ0jFbTQn79MC6OBa2XMxTNEa5p+jr1RgbbgdY+tskh8COhY
	2Nc7nvf5tVMAK5MO6K1MJd663+36JLKegInTaiSMwRSVL37kg14N1tBflHkTVA7jfuHq1U
	djdkolQfKVl6tZHjhATaveuh74aVPG0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i37RvDHe3b/txmys4XbZFO1wo8mNN+93QYUjCHcPtm4=;
	b=+mY64JaKHwzbL0h5mFfnkPTaySry2aQ3+XhWOAnVWAVDwF6ZcqNBul4nMx1htZXpTqY4FA
	ATskhwKMYNoNqjBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71ABA13998;
	Fri, 22 Nov 2024 21:16:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3fWhFZf0QGfTXQAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 22 Nov 2024 21:16:07 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 6/9] io_uring/net: Allocate msghdr async data through helper
Date: Fri, 22 Nov 2024 16:15:38 -0500
Message-ID: <20241122211541.2135280-7-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241122211541.2135280-1-krisman@suse.de>
References: <20241122211541.2135280-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -1.30
X-Spam-Flag: NO

This abstracts away the cache details.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/net.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index df1f7dc6f1c8..8457408194e7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -155,30 +155,31 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
+static void io_msg_async_data_init(void *obj)
+{
+	struct io_async_msghdr *hdr = (struct io_async_msghdr *)obj;
+
+	hdr->free_iov = NULL;
+	hdr->free_iov_nr = 0;
+}
+
 static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_async_msghdr *hdr;
 
-	hdr = io_alloc_cache_get(&ctx->netmsg_cache);
-	if (hdr) {
-		if (hdr->free_iov) {
-			kasan_mempool_unpoison_object(hdr->free_iov,
-				hdr->free_iov_nr * sizeof(struct iovec));
-			req->flags |= REQ_F_NEED_CLEANUP;
-		}
-		req->flags |= REQ_F_ASYNC_DATA;
-		req->async_data = hdr;
-		return hdr;
-	}
+	hdr = io_uring_alloc_async_data(&ctx->netmsg_cache, req,
+					io_msg_async_data_init);
+	if (!hdr)
+		return NULL;
 
-	if (!io_alloc_async_data(req)) {
-		hdr = req->async_data;
-		hdr->free_iov_nr = 0;
-		hdr->free_iov = NULL;
-		return hdr;
+	/* If the async data was cached, we might have an iov cached inside. */
+	if (hdr->free_iov) {
+		kasan_mempool_unpoison_object(hdr->free_iov,
+					      hdr->free_iov_nr * sizeof(struct iovec));
+		req->flags |= REQ_F_NEED_CLEANUP;
 	}
-	return NULL;
+	return hdr;
 }
 
 /* assign new iovec to kmsg, if we need to */
-- 
2.47.0


