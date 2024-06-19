Return-Path: <io-uring+bounces-2265-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9817390E183
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 04:06:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD69A1C2298F
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 02:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D72CA40;
	Wed, 19 Jun 2024 02:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bNqCpRrT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UFqDHGpX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bNqCpRrT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UFqDHGpX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF871097B
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 02:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718762800; cv=none; b=Oty+IbZVI6QWj0YNIMNMMBBMA+Tuyp6SXw9l4XExXP+UjYcEhvVPkRNBePy+q1AI3hg6xKnQzzPtYwUTPDrFbzpjw7wBfj0pFope6kvnPAaoKJiVEX74hr2ZiwuI2+qL5QVjBOW86HvDBLb1BKWy1GMaZLQCVkKpXXx2MYwyz5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718762800; c=relaxed/simple;
	bh=EJbb1It10VgxHc+Zxv9g/aRFmGamoyfSMEdbUJxxEhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G77BWWG2MhYOPvNmk7k3VckycGwBuqWGb/BkhYuSiSg5oWQtPIBH7BgZasx97ZmBYSSXiMGfZ5op6GzrL/d4iUJPOq/V2iuOO7R2G2oeEUHyEFJLHDb1LjZ+nyyNQQJPpLHh+bWfCPGawHdnqCFyUXkMp7Qqb6RhO+W33pnuATk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bNqCpRrT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UFqDHGpX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bNqCpRrT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UFqDHGpX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 567142198B;
	Wed, 19 Jun 2024 02:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718762796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j9+jdUADYt52dtFQ3q/Db7cHZ/Wb0fZqcEyf9oJ8Pyk=;
	b=bNqCpRrTT8GItqMjMTZ4kGbFCwG1oQdak9ms7NEJDOq8tASBEnK5QWPlvyz+CiwNu3mamk
	7YUwIj8QPexFnKizadRqMjR9wFBZUzeIzaIUJn2YWJZllJsECEmcbE/aWWg9KBgs4CgoF1
	+3goYeLj+wJCQ0qTd7KUnKuwI80LB6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718762796;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j9+jdUADYt52dtFQ3q/Db7cHZ/Wb0fZqcEyf9oJ8Pyk=;
	b=UFqDHGpXP7fB10nW4i6yhEJd3JJvaKI0HGtf+Oks7agndxSZLHqry4oo6OkQSoxG9E831e
	LfVnHAKp/DwHE/Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718762796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j9+jdUADYt52dtFQ3q/Db7cHZ/Wb0fZqcEyf9oJ8Pyk=;
	b=bNqCpRrTT8GItqMjMTZ4kGbFCwG1oQdak9ms7NEJDOq8tASBEnK5QWPlvyz+CiwNu3mamk
	7YUwIj8QPexFnKizadRqMjR9wFBZUzeIzaIUJn2YWJZllJsECEmcbE/aWWg9KBgs4CgoF1
	+3goYeLj+wJCQ0qTd7KUnKuwI80LB6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718762796;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j9+jdUADYt52dtFQ3q/Db7cHZ/Wb0fZqcEyf9oJ8Pyk=;
	b=UFqDHGpXP7fB10nW4i6yhEJd3JJvaKI0HGtf+Oks7agndxSZLHqry4oo6OkQSoxG9E831e
	LfVnHAKp/DwHE/Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1901F13AAA;
	Wed, 19 Jun 2024 02:06:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id K4UkOys9cmYoNgAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 19 Jun 2024 02:06:35 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 2/3] io_uring: Allocate only necessary memory in io_probe
Date: Tue, 18 Jun 2024 22:06:19 -0400
Message-ID: <20240619020620.5301-3-krisman@suse.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619020620.5301-1-krisman@suse.de>
References: <20240619020620.5301-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
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
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

We write at most IORING_OP_LAST entries in the probe buffer, so we don't
need to allocate temporary space for more than that.  As a side effect,
we no longer can overflow "size".

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/register.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 75f8e85cf0b0..8409fc80c1cb 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -39,9 +39,10 @@ static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 	size_t size;
 	int i, ret;
 
+	if (nr_args > IORING_OP_LAST)
+		nr_args = IORING_OP_LAST;
+
 	size = struct_size(p, ops, nr_args);
-	if (size == SIZE_MAX)
-		return -EOVERFLOW;
 	p = kzalloc(size, GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
@@ -54,8 +55,6 @@ static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 		goto out;
 
 	p->last_op = IORING_OP_LAST - 1;
-	if (nr_args > IORING_OP_LAST)
-		nr_args = IORING_OP_LAST;
 
 	for (i = 0; i < nr_args; i++) {
 		p->ops[i].op = i;
-- 
2.45.2


