Return-Path: <io-uring+bounces-13481-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLqsDlSgEGonbgYAu9opvQ
	(envelope-from <io-uring+bounces-13481-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2026 20:28:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5CE55B9096
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2026 20:28:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F1F03047414
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2026 18:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35726371D1E;
	Fri, 22 May 2026 18:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="edYPf9Rr"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ABB372050;
	Fri, 22 May 2026 18:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779474088; cv=none; b=EimKlslqLX4crQtWQfNGLJCgz+FX3xP3+b92l+Gfzy2shx1IxxfFG9rkyn5FulAUKfoYLT+a6Goym1w+k95pPL//Jpxrlp+9biW4HweSSbfr54RVQZE+0gXUpm+qELw7Dk4zTKsZGIavpEbglF3/Uc07hZ3bdIbcSj+b1eJT5/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779474088; c=relaxed/simple;
	bh=7d3Ti/hdlleLXjr3sAr8veTvIAhSjpJDPwOsLjEprog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SWxTps1G9+Ph+ZhXq3xBq0zIQTnw7wPRKfWIsjJ4Z1t/anXk99XGxTIPoOo/ZQ1R+yi2Fy+gKI6GpptaJ4HMAcYG/7pRAH2aiOZhs8rv4CCHGjGcfk1UQ/9FBp9G2xNh+LM62pLlSAofb6fqlZWwoCnaYsFkvR/xapxpme6Htb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=edYPf9Rr; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=zKLvy/XVT2bpLk4en4fS6J9Rd5aUoTUJe2g27vvq3tQ=; b=edYPf9RrqDquidBWf3LrLjCWr8
	ohWh080hKEcac6vExpyKG6U5XH6P+E+dZdSgULWxD6I72OJhYutOSlbKYpTTFdLOR5mcLYHcY0IDU
	GNhkRn/4TYmnPQ1tKqvbP2Y4zrJrKYYyPxiA1RQ3umXuH/GiWVePTUZ9gqi79KgnEEdK4KyjN4pi7
	IifQXHjtqCfaWBQlFD+w2KDacSCmWUkpptnUzdCtQTIKxdT4aAeYbBwRl/6b+YTCKdjbuSUj26nAG
	fvkUYyPbSvmOppII2AVGbp6zwYaJ5jteoiqs7qpS9un1v4oBxS9mmFOtOYSb3V769RRasMtXbdScu
	1m/BTF6w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQUUu-0000000ARbe-2m3r;
	Fri, 22 May 2026 18:21:24 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-mm@kvack.org,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH] block: Add bvec_folio()
Date: Fri, 22 May 2026 19:21:20 +0100
Message-ID: <20260522182122.2489391-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13481-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[willy@infradead.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: A5CE55B9096
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This is a simple helper which replaces page_folio(bvec->bv_page).
Minor improvement in readability, but the real motivation is to reduce
the number of references to bvec->bv_page so that it can be changed
with less work.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Leon Romanovsky <leon@kernel.org>
---

Hi Jens,

I have a pile of other patches which depend on this one, but they're
spread all over the kernel and don't really have anything in common
with each other.  Getting this in the next merge window will let me send
those patches next cycle.

 block/bio.c          |  6 +++---
 include/linux/bio.h  |  2 +-
 include/linux/bvec.h | 13 +++++++++++++
 io_uring/rsrc.c      |  2 +-
 mm/page_io.c         |  4 ++--
 5 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 5f10900b3f42..85aab3140909 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1300,7 +1300,7 @@ static void bio_free_folios(struct bio *bio)
 	int i;
 
 	bio_for_each_bvec_all(bv, bio, i) {
-		struct folio *folio = page_folio(bv->bv_page);
+		struct folio *folio = bvec_folio(bv);
 
 		if (!is_zero_folio(folio))
 			folio_put(folio);
@@ -1409,7 +1409,7 @@ int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen,
 
 static void bvec_unpin(struct bio_vec *bv, bool mark_dirty)
 {
-	struct folio *folio = page_folio(bv->bv_page);
+	struct folio *folio = bvec_folio(bv);
 	size_t nr_pages = (bv->bv_offset + bv->bv_len - 1) / PAGE_SIZE -
 			bv->bv_offset / PAGE_SIZE + 1;
 
@@ -1443,7 +1443,7 @@ static void bio_iov_iter_unbounce_read(struct bio *bio, bool is_error,
 			bvec_unpin(&bio->bi_io_vec[1 + i], mark_dirty);
 	}
 
-	folio_put(page_folio(bio->bi_io_vec[0].bv_page));
+	folio_put(bvec_folio(&bio->bi_io_vec[0]));
 }
 
 /**
diff --git a/include/linux/bio.h b/include/linux/bio.h
index dc17780d6c1e..6613ab4519bd 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -283,7 +283,7 @@ static inline void bio_first_folio(struct folio_iter *fi, struct bio *bio,
 		return;
 	}
 
-	fi->folio = page_folio(bvec->bv_page);
+	fi->folio = bvec_folio(bvec);
 	fi->offset = bvec->bv_offset +
 			PAGE_SIZE * folio_page_idx(fi->folio, bvec->bv_page);
 	fi->_seg_count = bvec->bv_len;
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index d36dd476feda..32846079b853 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -74,6 +74,19 @@ static inline void bvec_set_virt(struct bio_vec *bv, void *vaddr,
 	bvec_set_page(bv, virt_to_page(vaddr), len, offset_in_page(vaddr));
 }
 
+/**
+ * bvec_folio - Return the first folio referenced by this bvec
+ * @bv: bvec to access
+ *
+ * bvecs can span multiple folios.  Unless you know that this
+ * bvec does not, you may be better off using something like
+ * bio_for_each_folio_all() which iterates over all folios.
+ */
+static inline struct folio *bvec_folio(const struct bio_vec *bv)
+{
+	return page_folio(bv->bv_page);
+}
+
 struct bvec_iter {
 	/*
 	 * Current device address in 512 byte sectors. Only updated by the bio
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 650303626be6..5d792f70ec1e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -102,7 +102,7 @@ static void io_release_ubuf(void *priv)
 	unsigned int i;
 
 	for (i = 0; i < imu->nr_bvecs; i++) {
-		struct folio *folio = page_folio(imu->bvec[i].bv_page);
+		struct folio *folio = bvec_folio(&imu->bvec[i]);
 
 		unpin_user_folio(folio, 1);
 	}
diff --git a/mm/page_io.c b/mm/page_io.c
index 70cea9e24d2f..a59b73f8bdd9 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -490,7 +490,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
 
 	if (ret == sio->len) {
 		for (p = 0; p < sio->pages; p++) {
-			struct folio *folio = page_folio(sio->bvec[p].bv_page);
+			struct folio *folio = bvec_folio(&sio->bvec[p]);
 
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
 			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
@@ -500,7 +500,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
 		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
 	} else {
 		for (p = 0; p < sio->pages; p++) {
-			struct folio *folio = page_folio(sio->bvec[p].bv_page);
+			struct folio *folio = bvec_folio(&sio->bvec[p]);
 
 			folio_unlock(folio);
 		}
-- 
2.47.3


