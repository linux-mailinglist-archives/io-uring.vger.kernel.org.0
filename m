Return-Path: <io-uring+bounces-4991-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD2E9D6552
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 22:16:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE41A161959
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 21:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7161A54F95;
	Fri, 22 Nov 2024 21:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a4YOZm7f";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UvhGFgxm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vPgIIcFO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="496owy0m"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55F4156F3A
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 21:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732310162; cv=none; b=Dm6JC4BqsWg4luv9IM2VBiVTswCurUrU/mv86XNhK5KQm35Gro8mhP5MBezUD5wXobbubtrirZHTNHTXdVB0IWlNXcIQHxyvmB436r8uHnSqyQlWmEG3AlnoF/StdPIwt+WGsmqukJsNIY93vrL+mkODMRuCdY9A53fYaSWJieM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732310162; c=relaxed/simple;
	bh=xGkMWaPS2znrD/WhJrBKlRpXK6N5nUuaOnCu686nGYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnecNQ80tb2SjJ9j6/5ev2xZ97CNoxT0EBfcoyH5zznbfgZHSyX/y+TQ0Frik0aF2c2+Rj8Lk6uZwuYU5EytWhnWEEEyQSvo6K01mxkPp4whS3LC1ubjvKPk0npsatp2a1bgCcdH4rCSEaPFcTCSrmrgjabQrOvCtyNepwR+D/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a4YOZm7f; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UvhGFgxm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vPgIIcFO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=496owy0m; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EF00B1F79D;
	Fri, 22 Nov 2024 21:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bl+PVWrEKuoCakgEOxNrvLrDO3Ka7iUD9t77N791eO0=;
	b=a4YOZm7fx0ZqrsVHrPT+1Jz3oKLfWqCTdlAIUWb9oF4MdReWSefE9KZ8lprIzNJzZcvYgN
	jzOqXFC3CLZq49uzk81G69JOQVV2yjhTFNT6RONcfgF/jCDTWkZ/MVQQleeGkQc0ZJ6zWW
	u+SLPoAyxvIpn/xjOdw8kZsp5MkPCSU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310159;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bl+PVWrEKuoCakgEOxNrvLrDO3Ka7iUD9t77N791eO0=;
	b=UvhGFgxmnAWeHEqwBv77TgNpbEDyqxiZ36H6ft3jr+h8iSwGOkwD0Pg98Fr0K36Iw8kgSe
	eg4HlzFYpd2Wp5BA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732310158; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bl+PVWrEKuoCakgEOxNrvLrDO3Ka7iUD9t77N791eO0=;
	b=vPgIIcFODfT0DnFHhDhvDBacV4jyCUkUoKO4OP8FJ7/D/HFbJWQHlx4ODqTT8H6t/Fvtbk
	qYWk7YFmUl9t7MJiAN0f+6xZ+TXa0QWTPXThDGuoQRCgKMWEaCfjHxOwJlakKj23Ys1XDm
	mAh/8+qqdcjQqdb8+LYkwJgfkBkw8I0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732310158;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bl+PVWrEKuoCakgEOxNrvLrDO3Ka7iUD9t77N791eO0=;
	b=496owy0mUycKjohDQ3cPtRme9Afe8DhcTFz9IKQOI4TOgz13N/dcMc+tk+S99xaRT7gVz9
	N4vHAlhplJfe3/Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B463113998;
	Fri, 22 Nov 2024 21:15:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zWbtJY70QGfIXQAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 22 Nov 2024 21:15:58 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 4/9] io_uring/poll: Allocate apoll with generic alloc_cache helper
Date: Fri, 22 Nov 2024 16:15:36 -0500
Message-ID: <20241122211541.2135280-5-krisman@suse.de>
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
X-Spam-Score: -1.30
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email];
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
X-Spam-Flag: NO
X-Spam-Level: 

This abstracts away the cache details to simplify the code.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/poll.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index bced9edd5233..cc01c40b43d3 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -648,15 +648,12 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
-	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		apoll = io_alloc_cache_get(&ctx->apoll_cache);
-		if (!apoll)
-			goto alloc_apoll;
-		apoll->poll.retries = APOLL_MAX_RETRY;
 	} else {
-alloc_apoll:
-		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
-		if (unlikely(!apoll))
+		if (!(issue_flags & IO_URING_F_UNLOCKED))
+			apoll = io_cache_alloc(&ctx->apoll_cache, GFP_ATOMIC, NULL);
+		else
+			apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		if (!apoll)
 			return NULL;
 		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
-- 
2.47.0


