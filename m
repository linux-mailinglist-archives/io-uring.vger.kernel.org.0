Return-Path: <io-uring+bounces-933-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A183787B394
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 22:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C14A51C21742
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 21:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528A65336D;
	Wed, 13 Mar 2024 21:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VZkMM7xL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="13WWRPFk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VZkMM7xL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="13WWRPFk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E0F51C33
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 21:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710365965; cv=none; b=n8uj4uznwipaz4ywaFgOsRIMpgCxhR3Noc9tXrF+9IIvysHWIrwBz01tJPdesJZdnZ2U68bVt0/oYoEt7ahtJ675HJTAUEaiystyN034ldtDxsTSWuVS7D3ZxTwiIyFrZhK1GiLkEwqv4mq9eXzZd/8a5guMLese4BvHiPttmgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710365965; c=relaxed/simple;
	bh=fG9ona20AULtxvwIjGqnY3RW6K624CKrHfUth8rqmKI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FPIelQ1Cf6fu9RZlj9xsL5fpMtHkx/svc1YlwNGHtpbVrNdjPAGqIQ+znQrMuibVhTZwvL75wxanvIrIyVzA7MJhth0z8lRsY9pWZV1ZoPVZCGMn1PCnT83LSiYle0Hsfm1L+xpHNUGhSoD/oplNmo2O5SpjOv08e95EmDxiuGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VZkMM7xL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=13WWRPFk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VZkMM7xL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=13WWRPFk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8F2AD1F7EF;
	Wed, 13 Mar 2024 21:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1710365961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=n7FI5oEjwNXPnTV7BFMHE+9LrhxVF3k78RAvBbW4LRg=;
	b=VZkMM7xL0rQ+yWlSxKT1ga2TAe94NCpPJ2ir1wjbk6WOAfFOlrdPfHc2S94kQkefukJOfD
	uWlQUlhio6v5xm1HqZy4mqMSxgKTrb771UK3M5WBrDuwq7nyZLWtTvumY0zXg6zDYpQf3W
	DdEwu5m93/ru63IPqi1/il5EeVOpWtE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1710365961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=n7FI5oEjwNXPnTV7BFMHE+9LrhxVF3k78RAvBbW4LRg=;
	b=13WWRPFkMM0FmXwPZ4259dx+NtA2M9bBiv1fG2nSWeJ+evWp3Bl0jctGdFfZfz1vH9H7pL
	wenHzy50qBNPHNDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1710365961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=n7FI5oEjwNXPnTV7BFMHE+9LrhxVF3k78RAvBbW4LRg=;
	b=VZkMM7xL0rQ+yWlSxKT1ga2TAe94NCpPJ2ir1wjbk6WOAfFOlrdPfHc2S94kQkefukJOfD
	uWlQUlhio6v5xm1HqZy4mqMSxgKTrb771UK3M5WBrDuwq7nyZLWtTvumY0zXg6zDYpQf3W
	DdEwu5m93/ru63IPqi1/il5EeVOpWtE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1710365961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=n7FI5oEjwNXPnTV7BFMHE+9LrhxVF3k78RAvBbW4LRg=;
	b=13WWRPFkMM0FmXwPZ4259dx+NtA2M9bBiv1fG2nSWeJ+evWp3Bl0jctGdFfZfz1vH9H7pL
	wenHzy50qBNPHNDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 55FA81397F;
	Wed, 13 Mar 2024 21:39:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zpTVDgkd8mUSaQAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 13 Mar 2024 21:39:21 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH] io_uring: Fix release of pinned pages when __io_uaddr_map fails
Date: Wed, 13 Mar 2024 17:39:12 -0400
Message-ID: <20240313213912.1920-1-krisman@suse.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: ***
X-Spam-Score: 3.70
X-Spamd-Result: default: False [3.70 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 TO_DN_SOME(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Looking at the error path of __io_uaddr_map, if we fail after pinning
the pages for any reasons, ret will be set to -EINVAL and the error
handler won't properly release the pinned pages.

I didn't manage to trigger it without forcing a failure, but it can
happen in real life when memory is heavily fragmented.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 85df615f1196..f26f9ff86300 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2719,7 +2719,7 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 	struct page **page_array;
 	unsigned int nr_pages;
 	void *page_addr;
-	int ret, i;
+	int ret, i, pinned;
 
 	*npages = 0;
 
@@ -2733,12 +2733,12 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 	if (!page_array)
 		return ERR_PTR(-ENOMEM);
 
-	ret = pin_user_pages_fast(uaddr, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-					page_array);
-	if (ret != nr_pages) {
-err:
-		io_pages_free(&page_array, ret > 0 ? ret : 0);
-		return ret < 0 ? ERR_PTR(ret) : ERR_PTR(-EFAULT);
+
+	pinned = pin_user_pages_fast(uaddr, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
+				     page_array);
+	if (pinned != nr_pages) {
+		ret = (pinned < 0) ? pinned : -EFAULT;
+		goto free_pages;
 	}
 
 	page_addr = page_address(page_array[0]);
@@ -2752,7 +2752,7 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 		 * didn't support this feature.
 		 */
 		if (PageHighMem(page_array[i]))
-			goto err;
+			goto free_pages;
 
 		/*
 		 * No support for discontig pages for now, should either be a
@@ -2761,13 +2761,17 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 		 * just fail them with EINVAL.
 		 */
 		if (page_address(page_array[i]) != page_addr)
-			goto err;
+			goto free_pages;
 		page_addr += PAGE_SIZE;
 	}
 
 	*pages = page_array;
 	*npages = nr_pages;
 	return page_to_virt(page_array[0]);
+
+free_pages:
+	io_pages_free(&page_array, pinned > 0 ? pinned : 0);
+	return ERR_PTR(ret);
 }
 
 static void *io_rings_map(struct io_ring_ctx *ctx, unsigned long uaddr,
-- 
2.43.0


