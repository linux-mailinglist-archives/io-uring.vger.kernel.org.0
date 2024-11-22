Return-Path: <io-uring+bounces-4992-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 45E8C9D6556
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 22:16:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC0A3B21FE7
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 21:16:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21FDD54F95;
	Fri, 22 Nov 2024 21:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a0VreOH+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="x7Bb38Ct";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a0VreOH+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="x7Bb38Ct"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FDD156F3A
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 21:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732310166; cv=none; b=AcYcBN6QNov6I6Cf5oXVTgyLCimgwpiRGAgCLmgdbPRp68Al8UGMcBQSdYp5YIRwlkogEN8bE7dc79w4H4phRr2GvejSaEwydc9BvQSuynPrTA+Tt7lJGWdCgiduozSPeHV9egS0InXEAX6TE2WQ4IUhv3q4J7Q0s7U7qN2dwwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732310166; c=relaxed/simple;
	bh=ZKECSKQZAEy2tYVHbXFG+qadlwUv4Do3BePvhPWuxTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+/jiIBIwnkrJyL+Yz0HGgeYd2MxqZ7lsP05EdIgPDmOcQjbQdpAXzTHXephhkuhzT9Y6aUc8G3PkrY1OEfoYh7/sq/l3nGbn4d7nZx2cgXJkHG7DhrkDVvp8gd5cemqab89m4NiM86LGepYv+0QFk+xH+ENHJwhCYOhNNC9Aa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a0VreOH+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=x7Bb38Ct; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a0VreOH+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=x7Bb38Ct; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 96A7D1F79B;
	Fri, 22 Nov 2024 21:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UceOIPobMJtRBzOKOUv4mPDrqLxt37UEBcXu5ghGuzE=;
	b=a0VreOH+fUseOqWDYn4EfivG9G0vZiHDeBD3Rp7Ekf2pyEmRcmiidaL3X435DtNP5fS/i9
	2KbAefJZo1RkT6ihH37G2fIc9W+w2g2Cg4TduRUwEcLubk+hWARldDLVEBhf8Yc+z3QjEg
	QAN0s2/xFqe9ZNMsNPhZhRdvNOG63QQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UceOIPobMJtRBzOKOUv4mPDrqLxt37UEBcXu5ghGuzE=;
	b=x7Bb38CtP9XEBFhYr28ATk8jGpBB7i7gTuyOCaU+uvUANFc/X+0XpzT1Pch6w804W8CKCo
	I5c9QqTSzMYZb4Cg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=a0VreOH+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x7Bb38Ct
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UceOIPobMJtRBzOKOUv4mPDrqLxt37UEBcXu5ghGuzE=;
	b=a0VreOH+fUseOqWDYn4EfivG9G0vZiHDeBD3Rp7Ekf2pyEmRcmiidaL3X435DtNP5fS/i9
	2KbAefJZo1RkT6ihH37G2fIc9W+w2g2Cg4TduRUwEcLubk+hWARldDLVEBhf8Yc+z3QjEg
	QAN0s2/xFqe9ZNMsNPhZhRdvNOG63QQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UceOIPobMJtRBzOKOUv4mPDrqLxt37UEBcXu5ghGuzE=;
	b=x7Bb38CtP9XEBFhYr28ATk8jGpBB7i7gTuyOCaU+uvUANFc/X+0XpzT1Pch6w804W8CKCo
	I5c9QqTSzMYZb4Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F5DD13998;
	Fri, 22 Nov 2024 21:15:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QWFDEYv0QGfCXQAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 22 Nov 2024 21:15:55 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 2/9] io_uring: Add generic helper to allocate async data
Date: Fri, 22 Nov 2024 16:15:34 -0500
Message-ID: <20241122211541.2135280-3-krisman@suse.de>
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
X-Rspamd-Queue-Id: 96A7D1F79B
X-Spam-Score: -1.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

This helper replaces io_alloc_async_data by using the folded allocation.
Do it in a header to allow the compiler to decide whether to inline.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4070d4c8ef97..ddf3f05c3622 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -222,6 +222,16 @@ static inline void io_req_set_res(struct io_kiocb *req, s32 res, u32 cflags)
 	req->cqe.flags = cflags;
 }
 
+static inline void *io_uring_alloc_async_data(struct io_alloc_cache *cache,
+					      struct io_kiocb *req,
+					      void (*init_once)(void *obj))
+{
+	req->async_data = io_cache_alloc(cache, GFP_KERNEL, init_once);
+	if (req->async_data)
+		req->flags |= REQ_F_ASYNC_DATA;
+	return req->async_data;
+}
+
 static inline bool req_has_async_data(struct io_kiocb *req)
 {
 	return req->flags & REQ_F_ASYNC_DATA;
-- 
2.47.0


