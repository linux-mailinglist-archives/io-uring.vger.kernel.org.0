Return-Path: <io-uring+bounces-1675-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 820C28B60EF
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 20:16:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C85EFB20AF2
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 18:16:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F31086655;
	Mon, 29 Apr 2024 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CZGQ3RT+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lIKbvTC8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CZGQ3RT+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lIKbvTC8"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863218614C
	for <io-uring@vger.kernel.org>; Mon, 29 Apr 2024 18:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714414565; cv=none; b=ovklhwmmjeqqFvaJeJBZh25bVqsW5TkNb6CDWfLhEYdAIeOu9jrx4Haa+dfqM9Q5q7BPpgNtApE+a3uqYSIhCak3BEoG+duH7pPsErR+x6JN1Y5QZZnGkKvcXqaP/AXskCbSlzT7e04asfwYxwXUWZ8SuXb67KJSuBVXuj7XV3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714414565; c=relaxed/simple;
	bh=I7Y6OE2gelda7t1z7O6o2Ik4q5XEFDA+NCgdaZKlz04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WquCvcAYKUDxEmi6UFNN+Pzw/Ze8u1mEL3c562v8TTgu1SK8IuaG45B7pl91yXYQNnNenUQzNCKlcWLMHJSSDOmOulvS3IyMNV/RIkbpcQNLyAHexDcxnN5xorQ6nuoSnVTEn7qL6vP4qY2UCCu7ZD1rDWIRtBjJJ528r+NCfF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CZGQ3RT+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lIKbvTC8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CZGQ3RT+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lIKbvTC8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 681EE22A72;
	Mon, 29 Apr 2024 18:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714414561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H5laxXeFCufvUqLEnV3XS3EvCWQYujxIGlH1rdxXmIM=;
	b=CZGQ3RT+9ga7R9U8x9W7KfKA4kFar13vschZIuuYRU5S1txH3RZ/xy0+JnyxHNNh65rqa9
	V1KFM997gXDB1HHEz1JksD4baHfEb/hOWyEa+jDK4Q2CveNA0WnsuWMfltY0vxGiVwGAmV
	KxYgMSM1uBgXINfWMydCdnJaqoARyYg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714414561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H5laxXeFCufvUqLEnV3XS3EvCWQYujxIGlH1rdxXmIM=;
	b=lIKbvTC8zJft1cRb1hjFFoTq8IwLqyGZJe8/sAg0+A3Wa1Z0i7SPfJYdVygMjP6I3zH4jT
	zBmDZd0Qo5MLRDDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714414561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H5laxXeFCufvUqLEnV3XS3EvCWQYujxIGlH1rdxXmIM=;
	b=CZGQ3RT+9ga7R9U8x9W7KfKA4kFar13vschZIuuYRU5S1txH3RZ/xy0+JnyxHNNh65rqa9
	V1KFM997gXDB1HHEz1JksD4baHfEb/hOWyEa+jDK4Q2CveNA0WnsuWMfltY0vxGiVwGAmV
	KxYgMSM1uBgXINfWMydCdnJaqoARyYg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714414561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H5laxXeFCufvUqLEnV3XS3EvCWQYujxIGlH1rdxXmIM=;
	b=lIKbvTC8zJft1cRb1hjFFoTq8IwLqyGZJe8/sAg0+A3Wa1Z0i7SPfJYdVygMjP6I3zH4jT
	zBmDZd0Qo5MLRDDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 140AC139DE;
	Mon, 29 Apr 2024 18:16:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rCVwOuDjL2auVQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 29 Apr 2024 18:16:00 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH] io_uring: Require zeroed sqe->len on provided-buffers send
Date: Mon, 29 Apr 2024 14:15:56 -0400
Message-ID: <20240429181556.31828-1-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20557585-cd75-4202-b0e5-eabf774ece8e@kernel.dk>
References: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Score: -2.80
X-Spam-Flag: NO

When sending from a provided buffer, we set sr->len to be the smallest
between the actual buffer size and sqe->len.  But, now that we
disconnect the buffer from the submission request, we can get in a
situation where the buffers and requests mismatch, and only part of a
buffer gets sent.  Assume:

* buf[1]->len = 128; buf[2]->len = 256
* sqe[1]->len = 128; sqe[2]->len = 256

If sqe1 runs first, it picks buff[1] and it's all good. But, if sqe[2]
runs first, sqe[1] picks buff[2], and the last half of buff[2] is
never sent.

While arguably the use-case of different-length sends is questionable,
it has already raised confusion with potential users of this
feature. Let's make the interface less tricky by forcing the length to
only come from the buffer ring entry itself.

Fixes: ac5f71a3d9d7 ("io_uring/net: add provided buffer support for IORING_OP_SEND")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 51c41d771c50..ffe37dd77a74 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -423,6 +423,8 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
 	}
+	if (req->flags & REQ_F_BUFFER_SELECT && sr->len)
+		return -EINVAL;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
-- 
2.44.0


