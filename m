Return-Path: <io-uring+bounces-4793-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2149D1D35
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:24:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E997A2815F1
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6785118E25;
	Tue, 19 Nov 2024 01:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Nx2beKiY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ec/cchby";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Nx2beKiY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ec/cchby"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92D478C90
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731979361; cv=none; b=q2/qbLoqdA9tw9QSY5TXx04q1PalvvnoYxTfemlU62avhzf3xNyg/BGkMy+Hh1oo+qci7uMCZvDPtuXXBDgnfuZt+O+aFI6Jic4vVZgnx1PvReBLGjVvJGc5d1ZMYJfZpRCEgack5g9/zhbP1aaat8m71rDA6p5i826XlZuH/z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731979361; c=relaxed/simple;
	bh=rjBmGm+3UW6ps5XW+Hez9ztjF7xzPbKQpmdYjI9J/1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z03cjVxAtemzvtKdIW5i5lflo1LHvsbWie4Ix8/z/FB68/G5TOjdX7+vlOYpkwl6P1Trv7WMBogRdy68dR9sZ6VzFzNpKkh1nC4daOKXzytbX+B0aIVj1s717obHgw7hE8q5SHz6kzZe2Lh4E4Aio6q67rdOhhuBZ+XZVi9ZQrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Nx2beKiY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ec/cchby; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Nx2beKiY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ec/cchby; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 033EE1F365;
	Tue, 19 Nov 2024 01:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731979357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x7hyYkMLsUCvG97RSXG2rHGQyIotFPH0wSbg7qIEN/E=;
	b=Nx2beKiYBUiph3GOgtFh+UscOfwcgNwnHpqgDKtRtLzGjY8x812f4IvR5Clfby2qkQ0d0U
	EHjj4uP5Vzfkems4yaYl0BnJCA0QA9esztgxNs7ZCjPXcjTeI8ew1qV3g+G6cgIfcfIBzB
	rsuMd7vPnRgI2gnQiMZho1znvXK4P0Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731979357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x7hyYkMLsUCvG97RSXG2rHGQyIotFPH0wSbg7qIEN/E=;
	b=Ec/cchbyOe6c6NRygnlx6rAkIGxwVlIF58VfsKRghlZdfOWglpwPOe6m3VRgesCJ021GCz
	AWFZeoXgzXM5wzCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731979357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x7hyYkMLsUCvG97RSXG2rHGQyIotFPH0wSbg7qIEN/E=;
	b=Nx2beKiYBUiph3GOgtFh+UscOfwcgNwnHpqgDKtRtLzGjY8x812f4IvR5Clfby2qkQ0d0U
	EHjj4uP5Vzfkems4yaYl0BnJCA0QA9esztgxNs7ZCjPXcjTeI8ew1qV3g+G6cgIfcfIBzB
	rsuMd7vPnRgI2gnQiMZho1znvXK4P0Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731979357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x7hyYkMLsUCvG97RSXG2rHGQyIotFPH0wSbg7qIEN/E=;
	b=Ec/cchbyOe6c6NRygnlx6rAkIGxwVlIF58VfsKRghlZdfOWglpwPOe6m3VRgesCJ021GCz
	AWFZeoXgzXM5wzCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD2781376E;
	Tue, 19 Nov 2024 01:22:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pnf4IVzoO2e3LgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 19 Nov 2024 01:22:36 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 2/9] io_uring: Add generic helper to allocate async data
Date: Mon, 18 Nov 2024 20:22:17 -0500
Message-ID: <20241119012224.1698238-3-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241119012224.1698238-1-krisman@suse.de>
References: <20241119012224.1698238-1-krisman@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 

This helper replaces io_alloc_async_data by using the folded allocation.
Do it in a header to allow the compiler to decide whether to inline.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4070d4c8ef97..9c158e401ecb 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -222,6 +222,15 @@ static inline void io_req_set_res(struct io_kiocb *req, s32 res, u32 cflags)
 	req->cqe.flags = cflags;
 }
 
+static inline void *io_uring_alloc_async_data(struct io_alloc_cache *cache,
+					      struct io_kiocb *req)
+{
+	req->async_data = io_alloc_cache_alloc(cache, GFP_KERNEL);
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


