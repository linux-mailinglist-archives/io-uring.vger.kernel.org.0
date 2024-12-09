Return-Path: <io-uring+bounces-5365-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B439EA307
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE9541668C4
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 578CA21505D;
	Mon,  9 Dec 2024 23:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mdHnYImS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0ogimlF/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mdHnYImS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0ogimlF/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974582248A8
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787830; cv=none; b=EVuTqfLxh3DvmU5YFUGhhzejFsMRbuLDGfudWk5FE+cS21NOjnfC92QLX7ZObO0G3YpYJG5Vg/zcQNrSJr33LeTaDjKgyDojHASfu7L5fHpTjn6V6cuhFkzypWdFtb9MDrMsrPAZkBnQnRyO81/yv4RXT8dwskAeOvlOrJjLEMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787830; c=relaxed/simple;
	bh=ChCq7AgI1WmET1HKvBX+pXk5Z39d7W+i+jnobySWB1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSUldL/vqOUVJfw9qtjgwuK7+vypDQBFtF4M5mOBPy61TMTblocDVlrr/dfxr0sxxo+FhN2hEkF+7oVx7mQwjrAizyF1iahuHKLFFXtOzm/Fo2cxlPvIXqcEengaKrbUf5iqfzKRYeoMcnsNZ9iedNySSCaoFzDNPTSsKvgAyRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mdHnYImS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0ogimlF/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mdHnYImS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0ogimlF/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B14F421167;
	Mon,  9 Dec 2024 23:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P5jtNFPHgv7pxQLtSwya0fKmdBGWs4Xejv9/SA4pnDQ=;
	b=mdHnYImS/GuTSskplHqilg6xlQ1uw/lNw6oX+rtVXFe8cnUjAgV5tk16nKfk318pV9KgsS
	lhalKKXaRPNu0ajWmeaBXh8LCZ0hJ/lYVmVxuK4mmXJgwFQhyippKYn2qS4xNdbsrQutqN
	0zb9qHB7aWXeTDwiJ1r5KJJEzDFtE0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787826;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P5jtNFPHgv7pxQLtSwya0fKmdBGWs4Xejv9/SA4pnDQ=;
	b=0ogimlF/ORVdV/I4jc3Zx+kiEDd11YOODVPrptUR3OgR5r+n/9jFbPqqZqi0H5FZBLyCx2
	WHiDdLFyqxIzn6Bw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mdHnYImS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="0ogimlF/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733787826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P5jtNFPHgv7pxQLtSwya0fKmdBGWs4Xejv9/SA4pnDQ=;
	b=mdHnYImS/GuTSskplHqilg6xlQ1uw/lNw6oX+rtVXFe8cnUjAgV5tk16nKfk318pV9KgsS
	lhalKKXaRPNu0ajWmeaBXh8LCZ0hJ/lYVmVxuK4mmXJgwFQhyippKYn2qS4xNdbsrQutqN
	0zb9qHB7aWXeTDwiJ1r5KJJEzDFtE0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733787826;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P5jtNFPHgv7pxQLtSwya0fKmdBGWs4Xejv9/SA4pnDQ=;
	b=0ogimlF/ORVdV/I4jc3Zx+kiEDd11YOODVPrptUR3OgR5r+n/9jFbPqqZqi0H5FZBLyCx2
	WHiDdLFyqxIzn6Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B9B9138A5;
	Mon,  9 Dec 2024 23:43:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OpYMDbKAV2cRHQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:43:46 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC 6/9] io_uring: Let commands run with current credentials
Date: Mon,  9 Dec 2024 18:43:08 -0500
Message-ID: <20241209234316.4132786-7-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241209234316.4132786-1-krisman@suse.de>
References: <20241209234316.4132786-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B14F421167
X-Spam-Level: 
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
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -1.51
X-Spam-Flag: NO

IORING_OP_EXEC runs only from a custom handler and cannot rely on
overloaded credentials. This commit adds infrastructure to allow running
operations without overloading the credentials, i.e. not enabling the
REQ_F_CREDS flag.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.c | 2 +-
 io_uring/opdef.h    | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a19f72755eaa..0fd8709401fc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -457,7 +457,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!(req->flags & REQ_F_CREDS)) {
+	if (!(req->flags & REQ_F_CREDS) && !def->ignore_creds) {
 		req->flags |= REQ_F_CREDS;
 		req->creds = get_current_cred();
 	}
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 14456436ff74..94e9a2e3c028 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -27,6 +27,8 @@ struct io_issue_def {
 	unsigned		iopoll_queue : 1;
 	/* vectored opcode, set if 1) vectored, and 2) handler needs to know */
 	unsigned		vectored : 1;
+	/* io_uring must not overload credentials on async context. */
+	unsigned		ignore_creds : 1;
 
 	/* size of async data needed, if any */
 	unsigned short		async_size;
-- 
2.47.0


