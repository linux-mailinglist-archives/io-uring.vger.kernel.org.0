Return-Path: <io-uring+bounces-2624-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C9F89429D5
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 11:02:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E01A71F2215B
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 09:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E19E71A8C03;
	Wed, 31 Jul 2024 09:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Rw/Fe7YD"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571561A8BEA
	for <io-uring@vger.kernel.org>; Wed, 31 Jul 2024 09:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722416528; cv=none; b=SjgKl3e7rzxBWaSgEU1mq1c2TwhFg9Bu0N5s1w5IBvUYhGhl6BG8GQV+zvlE3547OysYab3wTW79SCq1V/Tz7F834Ao0kkQmgbKxntIHr+jXFN01oH/POCbukDgP54yT2UI2I2YAZLeqLZrKu4c3LoWqeSgWpojKm5dJHsUjvl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722416528; c=relaxed/simple;
	bh=u91U89RKtUzU0Fdk339BGSMGPmHUPvoiGBMwL95VEfA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=BaQirsD05XsBuzG27LypAx5Q3/+nmTJLOHJqZiQWE1AfXFbr3+wHnzoDtMD++ZErjLXgKMX/crvaQFco2ioBZEn9O06DrkZCiI0ciKr6t8sTq7YhLoJFa+eakT+1dkX1io6CKcu/4xp0f+MZNLzxMkPTDgRsMfrwh52/nzavNjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Rw/Fe7YD; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240731090204epoutp03c3b66fa51f5815be0cca4e6352f034e2~nQLQETGj90253502535epoutp03A
	for <io-uring@vger.kernel.org>; Wed, 31 Jul 2024 09:02:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240731090204epoutp03c3b66fa51f5815be0cca4e6352f034e2~nQLQETGj90253502535epoutp03A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1722416524;
	bh=Xhqw64kxxBLlO3hJBXEtgm9LwPyIiwT77nQdCS3+gS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rw/Fe7YDD5eIoSxbpyeIUYCZsH4pLsYbDxaaEE+ky4tFBT0VTUhRwA6kdWqcPNfEx
	 p9xyNnlDW09rLQdB2lXdseastf/Zl/xDvgo0hhV+zCGrbPjAe8PepqLF0kMLeFPVE2
	 W5D4FA5LyHKitdNXUuteQ+mPn9zweJYFjsm9i3dA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240731090203epcas5p497eec8e8ae28a03b57df1be49d9c63a2~nQLPpXHjF3167331673epcas5p4N;
	Wed, 31 Jul 2024 09:02:03 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WYmLd3c5Tz4x9Q7; Wed, 31 Jul
	2024 09:02:01 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1E.E5.09640.98DF9A66; Wed, 31 Jul 2024 18:02:01 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240731090145epcas5p459f36e03c78655d92b5bd4aca85b1d68~nQK_b51IC0236702367epcas5p4B;
	Wed, 31 Jul 2024 09:01:45 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240731090145epsmtrp28891e39e41fb3a05696fae4d5efc8fa8~nQK_WmHyl2144521445epsmtrp2v;
	Wed, 31 Jul 2024 09:01:45 +0000 (GMT)
X-AuditID: b6c32a49-aabb8700000025a8-82-66a9fd8933a1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C1.D8.08456.97DF9A66; Wed, 31 Jul 2024 18:01:45 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240731090143epsmtip1b1ed2fa1aaf957e868d6308d60c5adaf~nQK8vM8Xi3089730897epsmtip1J;
	Wed, 31 Jul 2024 09:01:43 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v8 2/2] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
Date: Wed, 31 Jul 2024 17:01:33 +0800
Message-Id: <20240731090133.4106-3-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731090133.4106-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmum7n35VpBjc+C1o0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAlqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWl
	eel6eaklVoYGBkamQIUJ2Rn7Hu1hKThsWrGw7SRjA+MurS5GTg4JAROJtad6mLsYuTiEBHYz
	Shw7+JsRwvnEKPH26HNWCOcbo8S5ZTuYYFo6r61lB7GFBPYySiy9IANR1MQk0fXuEViCTUBH
	4veKXywgtoiAtsTrx1PBbGaBXYwSC89JdTFycAgLBEj8nlENYrIIqErMeGEGUsErYC1x+vZN
	dohV8hL7D55lBrE5BWwkXk26yAJRIyhxcuYTqInyEs1bZ4N9ICHwl13i8r+ZjBDNLhI/pz1i
	gbCFJV4d3wI1VEri87u9bCB7JQSKJZatk4PobWGUeP9uDlSvtcS/K3tYQGqYBTQl1u/ShwjL
	Skw9tY4JYi+fRO/vJ9Ag4ZXYMQ/GVpW4cHAb1CppibUTtjJD2B4S745vZoIEVT+jxKVDT9gm
	MCrMQvLPLCT/zEJYvYCReRWjZGpBcW56arFpgWFeajk8jpPzczcxglOplucOxrsPPugdYmTi
	YDzEKMHBrCTCK3RyZZoQb0piZVVqUX58UWlOavEhRlNgeE9klhJNzgcm87ySeEMTSwMTMzMz
	E0tjM0Mlcd7XrXNThATSE0tSs1NTC1KLYPqYODilGphYet1zPjjd9HNKq5xRfE+P4TaPfoNM
	yBJJf+PUtaafz88LSFf4auHhFpLK/+DRt3/zRDx2ne6SEBTacEh9wdQlEk4mncx1Hi0zJV/f
	9dswOWz2U67i354Lk/+n+DLPcP5xcI24SaDhjRn7aqe864oLafMzK5DICIlw/dCx2/Tq+f1z
	XLT277rMe3h91SRrpulPmNxeHfcSecO6vKGbR+eHyMUuIWN17VkX7kcbrYtt3yLGsPQUS6zI
	pI8fV8SF2Ex+7l3CZCWV3TlPNiezcPOrWMOZeYIFbkLBXp9sL10xW8HZw1H7v1HXeteBnlBn
	84Ldn1/8VE+TnGX0ekHSdMsl9ywkLS9UfbO4Yfv9qRJLcUaioRZzUXEiAJrs6gQuBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnG7l35VpBvtfC1o0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujH2P9rAUHDatWNh2krGBcZdWFyMnh4SA
	iUTntbXsXYxcHEICuxklXj29yAiRkJboONTKDmELS6z89xyqqIFJ4tmGuWBFbAI6Er9X/GLp
	YuTgEBHQlWi8qwBSwyxwiFGieUMzWI2wgJ/E0vYN7CA1LAKqEjNemIGEeQWsJU7fvgk1X15i
	/8GzzCA2p4CNxKtJF8FGCgHVzHzLBFEuKHFy5hMWEJsZqLx562zmCYwCs5CkZiFJLWBkWsUo
	mVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERzsWlo7GPes+qB3iJGJgxHoZA5mJRFeoZMr
	04R4UxIrq1KL8uOLSnNSiw8xSnOwKInzfnvdmyIkkJ5YkpqdmlqQWgSTZeLglGpgkvmyzdr+
	w5aH+39+WsQc8bLo6oxXl0Pd1D5M/c+0ejrrtmMKtfJv0g76W2lkXMtftykvnd8oIjak9WvC
	Es+CxNcM+rVdSlGl/xbfZjyh7+vGtTx6mVUkn2d81srTofsdXu3jK0g1WcnyfKvA09Pt4Wkm
	AVO+WEnOk3RO4lMt15HctPdppfR2iZMn7Pq2LPV++Lyac+9B/kVT9vuvcWYJfnHbIJr7ufGH
	PsEPGz99PsqiIvJywha7kIPq96VfHoyrl68/XzL76zH3iTM0Ndes/zhTQDDsTJTh6jv5YZdk
	WpOWzjuW8jbk53KumUtv3Pk2X5m91yr/suu75v7MFakLM7//uGehdHXDP4Fnd0LfqymxFGck
	GmoxFxUnAgBj2ASt5QIAAA==
X-CMS-MailID: 20240731090145epcas5p459f36e03c78655d92b5bd4aca85b1d68
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240731090145epcas5p459f36e03c78655d92b5bd4aca85b1d68
References: <20240731090133.4106-1-cliang01.li@samsung.com>
	<CGME20240731090145epcas5p459f36e03c78655d92b5bd4aca85b1d68@epcas5p4.samsung.com>

Add support for checking and coalescing multi-hugepage-backed fixed
buffers. The coalescing optimizes both time and space consumption caused
by mapping and storing multi-hugepage fixed buffers.

A coalescable multi-hugepage buffer should fully cover its folios
(except potentially the first and last one), and these folios should
have the same size. These requirements are for easier processing later,
also we need same size'd chunks in io_import_fixed for fast iov_iter
adjust.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 134 ++++++++++++++++++++++++++++++++++++------------
 io_uring/rsrc.h |   8 +++
 2 files changed, 110 insertions(+), 32 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 64152dc6f293..7d639a996f28 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -849,6 +849,98 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
+static bool io_do_coalesce_buffer(struct page ***pages, int *nr_pages,
+				struct io_imu_folio_data *data, int nr_folios)
+{
+	struct page **page_array = *pages, **new_array = NULL;
+	int nr_pages_left = *nr_pages, i, j;
+
+	/* Store head pages only*/
+	new_array = kvmalloc_array(nr_folios, sizeof(struct page *),
+					GFP_KERNEL);
+	if (!new_array)
+		return false;
+
+	new_array[0] = compound_head(page_array[0]);
+	/*
+	 * The pages are bound to the folio, it doesn't
+	 * actually unpin them but drops all but one reference,
+	 * which is usually put down by io_buffer_unmap().
+	 * Note, needs a better helper.
+	 */
+	if (data->nr_pages_head > 1)
+		unpin_user_pages(&page_array[1], data->nr_pages_head - 1);
+
+	j = data->nr_pages_head;
+	nr_pages_left -= data->nr_pages_head;
+	for (i = 1; i < nr_folios; i++) {
+		unsigned int nr_unpin;
+
+		new_array[i] = page_array[j];
+		nr_unpin = min_t(unsigned int, nr_pages_left - 1,
+					data->nr_pages_mid - 1);
+		if (nr_unpin)
+			unpin_user_pages(&page_array[j+1], nr_unpin);
+		j += data->nr_pages_mid;
+		nr_pages_left -= data->nr_pages_mid;
+	}
+	kvfree(page_array);
+	*pages = new_array;
+	*nr_pages = nr_folios;
+	return true;
+}
+
+static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
+					 struct io_imu_folio_data *data)
+{
+	struct page **page_array = *pages;
+	struct folio *folio = page_folio(page_array[0]);
+	unsigned int count = 1, nr_folios = 1;
+	int i;
+
+	if (*nr_pages <= 1)
+		return false;
+
+	data->nr_pages_mid = folio_nr_pages(folio);
+	if (data->nr_pages_mid == 1)
+		return false;
+
+	data->folio_shift = folio_shift(folio);
+	/*
+	 * Check if pages are contiguous inside a folio, and all folios have
+	 * the same page count except for the head and tail.
+	 */
+	for (i = 1; i < *nr_pages; i++) {
+		if (page_folio(page_array[i]) == folio &&
+			page_array[i] == page_array[i-1] + 1) {
+			count++;
+			continue;
+		}
+
+		if (nr_folios == 1) {
+			if (folio_page_idx(folio, page_array[i-1]) !=
+				data->nr_pages_mid - 1)
+				return false;
+
+			data->nr_pages_head = count;
+		} else if (count != data->nr_pages_mid) {
+			return false;
+		}
+
+		folio = page_folio(page_array[i]);
+		if (folio_size(folio) != (1UL << data->folio_shift) ||
+			folio_page_idx(folio, page_array[i]) != 0)
+			return false;
+
+		count = 1;
+		nr_folios++;
+	}
+	if (nr_folios == 1)
+		data->nr_pages_head = count;
+
+	return io_do_coalesce_buffer(pages, nr_pages, data, nr_folios);
+}
+
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage)
@@ -858,7 +950,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	unsigned long off;
 	size_t size;
 	int ret, nr_pages, i;
-	struct folio *folio = NULL;
+	struct io_imu_folio_data data;
+	bool coalesced;
 
 	*pimu = (struct io_mapped_ubuf *)&dummy_ubuf;
 	if (!iov->iov_base)
@@ -873,31 +966,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		goto done;
 	}
 
-	/* If it's a huge page, try to coalesce them into a single bvec entry */
-	if (nr_pages > 1) {
-		folio = page_folio(pages[0]);
-		for (i = 1; i < nr_pages; i++) {
-			/*
-			 * Pages must be consecutive and on the same folio for
-			 * this to work
-			 */
-			if (page_folio(pages[i]) != folio ||
-			    pages[i] != pages[i - 1] + 1) {
-				folio = NULL;
-				break;
-			}
-		}
-		if (folio) {
-			/*
-			 * The pages are bound to the folio, it doesn't
-			 * actually unpin them but drops all but one reference,
-			 * which is usually put down by io_buffer_unmap().
-			 * Note, needs a better helper.
-			 */
-			unpin_user_pages(&pages[1], nr_pages - 1);
-			nr_pages = 1;
-		}
-	}
+	/* If it's huge page(s), try to coalesce them into fewer bvec entries */
+	coalesced = io_try_coalesce_buffer(&pages, &nr_pages, &data);
 
 	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
 	if (!imu)
@@ -909,7 +979,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		goto done;
 	}
 
-	off = (unsigned long) iov->iov_base & ~PAGE_MASK;
 	size = iov->iov_len;
 	/* store original address for later verification */
 	imu->ubuf = (unsigned long) iov->iov_base;
@@ -917,17 +986,18 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	imu->nr_bvecs = nr_pages;
 	imu->folio_shift = PAGE_SHIFT;
 	imu->folio_mask = PAGE_MASK;
+	if (coalesced) {
+		imu->folio_shift = data.folio_shift;
+		imu->folio_mask = ~((1UL << data.folio_shift) - 1);
+	}
+	off = (unsigned long) iov->iov_base & ~imu->folio_mask;
 	*pimu = imu;
 	ret = 0;
 
-	if (folio) {
-		bvec_set_page(&imu->bvec[0], pages[0], size, off);
-		goto done;
-	}
 	for (i = 0; i < nr_pages; i++) {
 		size_t vec_len;
 
-		vec_len = min_t(size_t, size, PAGE_SIZE - off);
+		vec_len = min_t(size_t, size, (1UL << imu->folio_shift) - off);
 		bvec_set_page(&imu->bvec[i], pages[i], vec_len, off);
 		off = 0;
 		size -= vec_len;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index ee77e53328bf..18242b2e9da4 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -52,6 +52,14 @@ struct io_mapped_ubuf {
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
+struct io_imu_folio_data {
+	/* Head folio can be partially included in the fixed buf */
+	unsigned int	nr_pages_head;
+	/* For non-head/tail folios, has to be fully included */
+	unsigned int	nr_pages_mid;
+	unsigned int	folio_shift;
+};
+
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
-- 
2.34.1


