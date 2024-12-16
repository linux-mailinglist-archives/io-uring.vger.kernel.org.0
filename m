Return-Path: <io-uring+bounces-5505-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 350AB9F3C0C
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 22:04:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EAF11655AE
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2024 21:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34D21D5AB7;
	Mon, 16 Dec 2024 20:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vrDAFRQ4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UbZYN3F+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vrDAFRQ4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UbZYN3F+"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6D11D0E26
	for <io-uring@vger.kernel.org>; Mon, 16 Dec 2024 20:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734381994; cv=none; b=MqfWL73ZDjGCn6NS7ObaZ4cXnvB1cURzRwBRLiuWgLq4jYpSSNiQv+AU6yL5hQxCg8e3+9pD7F+AmAideojFsNpiyn7K6A1/qg1if10WmgXeVTCJxjGEJ8wi2goGrt42FtnWvbqTpTf+OfDsd+fOmipijFNs52HdY5jWr+zjR6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734381994; c=relaxed/simple;
	bh=6id6AWdRZMb1HMZ1jX4utNWInmMtEe8b4LL6wdSyBwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+Pac0x7o1t55KVyW2omN2+1G2DDHzkBeH6MzYToLTyvB2TbeKnI+Rjf+u8uJ7V+rMxm/+lMvu0ha20KfEb57hjvd3+nchadXO9F0Di7kicqpoqyBUXfk5KDCBrGo1yZSkopi6du34Ln1k9BOrfHZK+v1nhshV7qpahD6poHZ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vrDAFRQ4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UbZYN3F+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vrDAFRQ4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UbZYN3F+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6259C2111F;
	Mon, 16 Dec 2024 20:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734381991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TQOa2byvDqO6GB87pBRBG7/hj3M2AXVfopBemjXfnig=;
	b=vrDAFRQ4TWwiY9Z5zIlALpCVHFbuovIeQdoU6UYveYfDnIYQbMlBrkunchQrRzCF5e3vHh
	gGVqikXzC94/ZfvSXWHWJHdSHvGGucgbByv3EAjZXPIo+9YglpiV7d0ZS1hGp29/MUYvHZ
	UxNZ6dsYzVMmxiiScke4nFh/7FcRjl4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734381991;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TQOa2byvDqO6GB87pBRBG7/hj3M2AXVfopBemjXfnig=;
	b=UbZYN3F+iW72rqNoWAtgVDW7gi7kSrc2CX8OO1Bfn1HoVQ3njCF5c6xcX//AtzgHf4JM7H
	Dm+5VOIzSNWKxyAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734381991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TQOa2byvDqO6GB87pBRBG7/hj3M2AXVfopBemjXfnig=;
	b=vrDAFRQ4TWwiY9Z5zIlALpCVHFbuovIeQdoU6UYveYfDnIYQbMlBrkunchQrRzCF5e3vHh
	gGVqikXzC94/ZfvSXWHWJHdSHvGGucgbByv3EAjZXPIo+9YglpiV7d0ZS1hGp29/MUYvHZ
	UxNZ6dsYzVMmxiiScke4nFh/7FcRjl4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734381991;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TQOa2byvDqO6GB87pBRBG7/hj3M2AXVfopBemjXfnig=;
	b=UbZYN3F+iW72rqNoWAtgVDW7gi7kSrc2CX8OO1Bfn1HoVQ3njCF5c6xcX//AtzgHf4JM7H
	Dm+5VOIzSNWKxyAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B8EB137CF;
	Mon, 16 Dec 2024 20:46:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LCGjBKeRYGffZAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 16 Dec 2024 20:46:31 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RESEND v2 2/9] io_uring: Add generic helper to allocate async data
Date: Mon, 16 Dec 2024 15:46:08 -0500
Message-ID: <20241216204615.759089-3-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241216204615.759089-1-krisman@suse.de>
References: <20241216204615.759089-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -5.30
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 

This helper replaces io_alloc_async_data by using the folded allocation.
Do it in a header to allow the compiler to decide whether to inline.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 12abee607e4a..cd7bf71574e4 100644
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


