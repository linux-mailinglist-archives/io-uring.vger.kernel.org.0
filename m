Return-Path: <io-uring+bounces-13553-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iBybGimEGGq6kggAu9opvQ
	(envelope-from <io-uring+bounces-13553-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 20:06:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E89865F613C
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 20:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB0983050F50
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 17:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C5F3FFAA2;
	Thu, 28 May 2026 17:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LxLOs6Ov"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1964028CC;
	Thu, 28 May 2026 17:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779991157; cv=none; b=HOdX1xVH6NBSwzfa+H0oQVQNz3n0wp5WglwVN2qm7O04aY33pm/szATmZ2X3fctsidLsaQRTLVJ0gkhwY33IIgxFRIiIbDPNcqfjr49tIdWWXV33WJ2WFD2Qil0VbEBhh3sEm3W2gC2TZ2tcLhcV44zTJEmke+3It3rwXCIWpiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779991157; c=relaxed/simple;
	bh=HWnwdvN+wH0BNDOr5PiWKCj6j16psryRcs0rHbe8jV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtoTu4seZieGxV+B01lac9c/4ZEB7YUYHLevDJGf+kV13a9CZnpbkzRDOTIGZaLqOv2/y7/vekfOiuMFLoC3/8q1BwNPfqUCtFq6BJhDjcvYbxwlLqYyzWRu5A+ymA/sUonmYrnT8CS03e7v1wycuiSstMrmaYMCSVnaFdc98pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LxLOs6Ov; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=00eqepaCtdAWu+DT6W6K8Woolj1q8dfZ4GLsgZojTfU=; b=LxLOs6Ov5lZ1U5Xru94afj9U9t
	PJL/TdKDYOWmG/W183u33w3lX2ScLoLLWmYvgRywVOH7ba+BYVC/K3wV4aME5maSdLI3puQCo0n/u
	npWsniY14pov3dOUQuhEU+7dEY8RgL+hTxmseN4qNOsjMfY4ZiHEQr4dSYi2kcbE2DbamsS88ptkZ
	HJOAw+ReE+LcCye1BMN2T5ZYVqsTsftZ6EMmMdcSRrYJHoC8PPlylMxT9wgT2qOtV1Z9S6i72ds+s
	1zm4CaNYV9URu7imarFFRFQPtyWp5DXpz71Ueb5+ERrYUkuaEX4q/QzHJnpC6nwo34LWrWlHbmfW8
	SAkN2pDg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSf0d-00000004clb-2Ub7;
	Thu, 28 May 2026 17:59:07 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-mm@kvack.org,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 1/2] block: Add bvec_folio()
Date: Thu, 28 May 2026 18:59:03 +0100
Message-ID: <20260528175905.1102280-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528175905.1102280-1-willy@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13553-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[willy@infradead.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: E89865F613C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This is a simple helper which replaces page_folio(bvec->bv_page).
Minor improvement in readability, but the real motivation is to reduce
the number of references to bvec->bv_page so that it can be changed
with less work.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Leon Romanovsky <leon@kernel.org>
---
 block/bio.c          |  6 +++---
 include/linux/bio.h  |  2 +-
 include/linux/bvec.h | 15 +++++++++++++++
 io_uring/rsrc.c      |  2 +-
 mm/page_io.c         |  4 ++--
 5 files changed, 22 insertions(+), 7 deletions(-)

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
index d36dd476feda..27ac3fcc6d9e 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -74,6 +74,21 @@ static inline void bvec_set_virt(struct bio_vec *bv, void *vaddr,
 	bvec_set_page(bv, virt_to_page(vaddr), len, offset_in_page(vaddr));
 }
 
+/**
+ * bvec_folio - Return the first folio referenced by this bvec
+ * @bv: bvec to access
+ *
+ * A bvec can contain non-folio memory, so this should only be called by
+ * the creator of the bvec; drivers have no business looking at the owner
+ * of the memory.  It may not even be the right interface for the caller
+ * to use as a bvec can span multiple folios.  You may be better off using
+ * something like bio_for_each_folio_all() which iterates over all folios.
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


