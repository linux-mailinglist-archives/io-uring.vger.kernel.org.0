Return-Path: <io-uring+bounces-12301-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EG5PHmoqlWm2MQIAu9opvQ
	(envelope-from <io-uring+bounces-12301-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19242152C00
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 722F330162A8
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 02:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5490C2DC352;
	Wed, 18 Feb 2026 02:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R/Yi9PeC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1ACC2EA
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 02:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771383399; cv=none; b=LeJq3dy12PSWVcUKHI+1MhpquIFp4fvC2g2tWGy9rAwIfqM1uG5Kch6+Xf2PodfjbPra0gE6ESNT5ZpqhFQAF38Gx3V32tjG6/mCcBVdni1p2Df7eZyiwyx4uZv3t6Sv/q7mVvOOXlyppwn3Lw6rKIUZ2Cc0ok91iJhYG9gNL4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771383399; c=relaxed/simple;
	bh=UDQwNSbT3TM97tvN2WGXguulkBD9eGp/gS9TYQlpbmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=of275bO6ufpf7M6H52NEyJ3PdKEo9bvy5l5vGo5RaH8MNbJ3ZEC4v89pOxGmZctNtCjtB//KXbyBOyc5Qsul9B/aOxu5C1Simo7lu8yNqjZ1vw0rwsOZg5sKW63sa8ceIw0P6IRQbwMfAI0Jxqg5RLASWvQ5Wn/Z0Jozp58Jijw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R/Yi9PeC; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3566af9900eso2437443a91.2
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 18:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771383397; x=1771988197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q8Bb6AOdKTMK64W0f/BS3OWmGtTX4ZsPXqaMKADTuDs=;
        b=R/Yi9PeC+sgGEPu/jv1IWmgTIh+tJF26U0tf3q8SazWpAaaxcKz8B2a8SC86lSN3Ee
         24Lgidg4ohVSTcYvbzkjjsM4/T6WFrtF95OxTX5jth6nRl8gcS5K3Pc71cyC0ffoJBOp
         VW6NaBrXSDSyyoUVsHcdOTo9ja0PaNn8AmmatH/6lyZPMNup4dXYfGiVkP+3Wc9PAHqP
         TNWTQaqDYXdsI3B4Rae8JPyz1AcSxwolQoYYu4Ph2H9hOUMP4nU/k7le7H2zj4WeBmTu
         XLNg16/UiiqQMlZIFZaI0NU9K80zxhHAtx3Sk3yoj9U9e5nJi5PBvoqronNJscKKc9LG
         tpVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771383397; x=1771988197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q8Bb6AOdKTMK64W0f/BS3OWmGtTX4ZsPXqaMKADTuDs=;
        b=et+lSd8MPjVl64rBCbC+0hiExwgnHlKw2LjWyVrAr3VZFnr/Upar4vMc0wHZRAgQZN
         H/o3Q0B/6nH+7i3YFpUETRQWu06PNwL8M3tTEp61TfLiYhlenLwzTxYMGZ5JH04xAVPo
         +iUaduGRNkaU/9lS9abPUABoEhRYJs13NgoWNtS9RjMlFdFRcgWrAw0U45yeupfH64Ce
         RlycsT3c5++rzzPMJF+zto0mgiN2jD+rCHEAXmLsY+Q3JsTDtHySZ+ugF9oviCUs1nfK
         ZaAg9kIWMc/YhMyqB2ZxG6XdOtM8AwsoDJ9yBWdkj6812+IikBTHrqSnmfHMjpNiN/ek
         VpSg==
X-Forwarded-Encrypted: i=1; AJvYcCWDbYqktwl3HOiJ2MGBCyFM1ahwMfwlGVTT4C/LInESgE3YBtkJUd0CO2EF5Qs8SRSnZ106B4JiSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzU/HFg1b4FIz0ulT72IsYlvkHQ9HSWkFPAv5NiHH08jHY2Naku
	sXuvaeaTQPmOGYJptYDi7Xreupu8C/PDjDn7QHdd0mA/6XN55QAAQ7Yy
X-Gm-Gg: AZuq6aKV8PXF+A802LVw212PUNTseRLcquO4zLMl2ZSxMDmk8Q9Zqf0PLuLYkoo9MMP
	fA63r3U1N8qFvZRhltoE63WPfX9wEUmFWP+FiVvbABnYkoD0P4rD1GiscSohy4voOkAUV9ZErYX
	ROHSXUNBc66De7XSQvadzqcGA3CdEaZqt3zQML8RdZGLDvAMnIgfWTl2qXuST5M8RrGhU5D6Zid
	1v/qMQXxlqSvsuZ2MUXaIKv2cUPb365KOXeVOMdEwaqASgQ4GTAaBvS8gvjzA61WkOuFyZpeiTH
	ZWsiXnA694Nio/KlyQTodIP3HSnisDyiuQ1JrNjBHQ1Nk4eoapxeok5fXY19VHpt4cWfg7CYSRr
	DFn9C0adziOKA3ZUWj4fGlM3uNhDJBmszPrmcMTq5cNBeDK5dbWbqfI1RsBTuoCBGF4w5DIuJ/y
	wLV2Ag63y6diL7/mbF4w==
X-Received: by 2002:a17:90b:582f:b0:34c:c514:ee1f with SMTP id 98e67ed59e1d1-3588905b27fmr447973a91.11.1771383397344;
        Tue, 17 Feb 2026 18:56:37 -0800 (PST)
Received: from localhost ([2a03:2880:ff:43::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35886c8e3d7sm309412a91.2.2026.02.17.18.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 18:56:37 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com
Subject: [PATCH v2 1/9] io_uring/memmap: chunk allocations in io_region_allocate_pages()
Date: Tue, 17 Feb 2026 18:51:59 -0800
Message-ID: <20260218025207.1425553-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260218025207.1425553-1-joannelkoong@gmail.com>
References: <20260218025207.1425553-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,bsbernd.com,infradead.org,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12301-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 19242152C00
X-Rspamd-Action: no action

Currently, io_region_allocate_pages() tries a single compound allocation
for the entire region, and falls back to alloc_pages_bulk_node() if that
fails.

When allocating a large region, trying to do a single compound
allocation may be unrealistic while allocating page by page may be
inefficient and cause worse TLB performance.

Rework io_region_allocate_pages() to allocate memory in 2MB chunks,
attempting a compound allocation for each chunk.

Replace IO_REGION_F_SINGLE_REF with IO_REGION_F_COMPOUND_PAGES to
reflect that the page array may contain tail pages from multiple
compound allocations.

Currently, alloc_pages_bulk_node() fails when the GFP_KERNEL_ACCOUNT gfp
flag is set. This makes this commit a necessary change in order to use
kernel-managed ring buffers (which will allocate regions of large
sizes), at least until that issue is fixed.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/memmap.c | 87 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 64 insertions(+), 23 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 89f56609e50a..6e91960aa8fc 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -15,6 +15,28 @@
 #include "rsrc.h"
 #include "zcrx.h"
 
+static void release_compound_pages(struct page **pages, unsigned long nr_pages)
+{
+	struct page *page;
+	unsigned int nr, i = 0;
+
+	while (nr_pages) {
+		page = pages[i];
+
+		if (!page || WARN_ON_ONCE(page != compound_head(page)))
+			return;
+
+		nr = compound_nr(page);
+		put_page(page);
+
+		if (nr >= nr_pages)
+			return;
+
+		i += nr;
+		nr_pages -= nr;
+	}
+}
+
 static bool io_mem_alloc_compound(struct page **pages, int nr_pages,
 				  size_t size, gfp_t gfp)
 {
@@ -84,22 +106,19 @@ enum {
 	IO_REGION_F_VMAP			= 1,
 	/* memory is provided by user and pinned by the kernel */
 	IO_REGION_F_USER_PROVIDED		= 2,
-	/* only the first page in the array is ref'ed */
-	IO_REGION_F_SINGLE_REF			= 4,
+	/* memory may contain tail pages from compound allocations */
+	IO_REGION_F_COMPOUND_PAGES		= 4,
 };
 
 void io_free_region(struct user_struct *user, struct io_mapped_region *mr)
 {
 	if (mr->pages) {
-		long nr_refs = mr->nr_pages;
-
-		if (mr->flags & IO_REGION_F_SINGLE_REF)
-			nr_refs = 1;
-
 		if (mr->flags & IO_REGION_F_USER_PROVIDED)
-			unpin_user_pages(mr->pages, nr_refs);
+			unpin_user_pages(mr->pages, mr->nr_pages);
+		else if (mr->flags & IO_REGION_F_COMPOUND_PAGES)
+			release_compound_pages(mr->pages, mr->nr_pages);
 		else
-			release_pages(mr->pages, nr_refs);
+			release_pages(mr->pages, mr->nr_pages);
 
 		kvfree(mr->pages);
 	}
@@ -154,28 +173,50 @@ static int io_region_allocate_pages(struct io_mapped_region *mr,
 				    unsigned long mmap_offset)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
-	size_t size = io_region_size(mr);
 	unsigned long nr_allocated;
-	struct page **pages;
+	struct page **pages, **cur_pages;
+	unsigned chunk_size, chunk_nr_pages;
+	unsigned int pages_left;
 
 	pages = kvmalloc_array(mr->nr_pages, sizeof(*pages), gfp);
 	if (!pages)
 		return -ENOMEM;
 
-	if (io_mem_alloc_compound(pages, mr->nr_pages, size, gfp)) {
-		mr->flags |= IO_REGION_F_SINGLE_REF;
-		goto done;
-	}
+	chunk_size = SZ_2M;
+	chunk_nr_pages = chunk_size >> PAGE_SHIFT;
+	pages_left = mr->nr_pages;
+	cur_pages = pages;
+
+	while (pages_left) {
+		unsigned int nr_pages = min(pages_left,
+					    chunk_nr_pages);
+
+		if (io_mem_alloc_compound(cur_pages, nr_pages,
+					  nr_pages << PAGE_SHIFT, gfp)) {
+			mr->flags |= IO_REGION_F_COMPOUND_PAGES;
+			cur_pages += nr_pages;
+			pages_left -= nr_pages;
+			continue;
+		}
 
-	nr_allocated = alloc_pages_bulk_node(gfp, NUMA_NO_NODE,
-					     mr->nr_pages, pages);
-	if (nr_allocated != mr->nr_pages) {
-		if (nr_allocated)
-			release_pages(pages, nr_allocated);
-		kvfree(pages);
-		return -ENOMEM;
+		nr_allocated = alloc_pages_bulk_node(gfp, NUMA_NO_NODE,
+						     nr_pages, cur_pages);
+		if (nr_allocated != nr_pages) {
+			unsigned int total =
+				(cur_pages - pages) + nr_allocated;
+
+			if (mr->flags & IO_REGION_F_COMPOUND_PAGES)
+				release_compound_pages(pages, total);
+			else
+				release_pages(pages, total);
+			kvfree(pages);
+			return -ENOMEM;
+		}
+
+		cur_pages += nr_pages;
+		pages_left -= nr_pages;
 	}
-done:
+
 	reg->mmap_offset = mmap_offset;
 	mr->pages = pages;
 	return 0;
-- 
2.47.3


