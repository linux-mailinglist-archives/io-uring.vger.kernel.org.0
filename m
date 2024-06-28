Return-Path: <io-uring+bounces-2390-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAE8B91CB7F
	for <lists+io-uring@lfdr.de>; Sat, 29 Jun 2024 09:26:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38DD8B22046
	for <lists+io-uring@lfdr.de>; Sat, 29 Jun 2024 07:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0301CAA6;
	Sat, 29 Jun 2024 07:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cKAPOgaJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692CA14A85
	for <io-uring@vger.kernel.org>; Sat, 29 Jun 2024 07:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719645992; cv=none; b=thoUK+R0Fxi0doY3LEvRcPPfzDgiWzQVCFAAQzLpPLUd4m2AIiVt/YPdTByQ0GpunASd/n1BGVpeXsU5waEbKnOhcEtMjtLaDdnk5Y/AVj1W/4yPii2QEv86ih0tGQ5hkwEgPqpXuGDkTYV872GN/i30USDKk8Za2aD3npcncc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719645992; c=relaxed/simple;
	bh=dGg0F+GmbdFkSnWgqSGvP96ZO2YYn8/LGV24URAlSIM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=FIbh85Agx2DfsC9rH/JK2mM8zmMjLSqUh1hsn0Ji90jR7Oww+Mfgc2JhUglzW+jd2rWquFanCuIfuEFuI71o/Vqr7/6bzJG7GVZTNa8Q42Y1+EvqZhi2fkIixo/KwB0wZe6M+nUN53A5sgH7EKnpeTP7LcBiomkdqe+vRCNQOo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cKAPOgaJ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240629072622epoutp02fc43712273710bc7a26349500d401906~daOjn0aPE0164801648epoutp02u
	for <io-uring@vger.kernel.org>; Sat, 29 Jun 2024 07:26:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240629072622epoutp02fc43712273710bc7a26349500d401906~daOjn0aPE0164801648epoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719645982;
	bh=H44s/aUHCxaZote+pk8rKt/p0gDo70B4ZL3ZIS2Q3E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKAPOgaJI4lrtp4pGp98Wp1Q+u3ejMUPap9Ylk6FOFId0ZLrT5tZGpWnG/AOG80e8
	 8eSpbSItthYo7BpXtbgLs3+P84VPllgVnflleXF0z/7JjsPe0RF/HE/N0c+m15LxJc
	 5uY94WnfErHK7xf+hu/Hpd+SHooGk+g+MBArgv7k=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240629072620epcas5p22928b65361791025e64baf8ffc7cc2f5~daOiZN5m_0452704527epcas5p2N;
	Sat, 29 Jun 2024 07:26:20 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WB3kz5HC3z4x9Pr; Sat, 29 Jun
	2024 07:26:19 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3D.48.07307.B17BF766; Sat, 29 Jun 2024 16:26:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240628084420epcas5p32f49e7c977695d20bcef7734eb2e38b4~dHpWLh3VQ1548615486epcas5p3v;
	Fri, 28 Jun 2024 08:44:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240628084420epsmtrp2e4e1c20d50a418c5e2c5f03bfb02c143~dHpWKvrZn0935009350epsmtrp2c;
	Fri, 28 Jun 2024 08:44:20 +0000 (GMT)
X-AuditID: b6c32a44-3f1fa70000011c8b-f9-667fb71babd2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4F.04.29940.4E77E766; Fri, 28 Jun 2024 17:44:20 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240628084419epsmtip1090c41b2907317a7d61a46f553a83772~dHpU6dPxu0054500545epsmtip1u;
	Fri, 28 Jun 2024 08:44:18 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v5 1/3] io_uring/rsrc: add hugepage fixed buffer coalesce
 helpers
Date: Fri, 28 Jun 2024 16:44:09 +0800
Message-Id: <20240628084411.2371-2-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240628084411.2371-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmuq709vo0g23TVSyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7Iz762oLZipVfLlR1MB4X7qLkZNDQsBEYt3/7+xdjFwcQgK7GSWe
	3nrJDOF8YpT4vqkJyvnGKLHv6l82mJbFx6YwQST2MkpM3dcKVdXEJPHg+kEmkCo2AR2J3yt+
	sYDYIgLaEq8fTwWzmQV2MUosPCcFYgsLBEusXrYPqJmDg0VAVeL1XjWQMK+AtcSZ9x8YIZbJ
	S+w/eJYZxOYUsJG4NH0WO0SNoMTJmU+gRspLNG+dDXaDhMBfdonnWy5ANbtIrFp3jQXCFpZ4
	dXwLO4QtJfH53V42kL0SAsUSy9bJQfS2MEq8fzcHqtda4t+VPSwgNcwCmhLrd+lDhGUlpp5a
	xwSxl0+i9/cTJog4r8SOeTC2qsSFg9ugVklLrJ2wlRlilYfEogNqkKDqZ5S4vfwp6wRGhVlI
	3pmF5J1ZCJsXMDKvYpRMLSjOTU9NNi0wzEsth0dxcn7uJkZwItVy2cF4Y/4/vUOMTByMhxgl
	OJiVRHj5M+vShHhTEiurUovy44tKc1KLDzGaAoN7IrOUaHI+MJXnlcQbmlgamJiZmZlYGpsZ
	Konzvm6dmyIkkJ5YkpqdmlqQWgTTx8TBKdXAdPOtzdVbcnNdz8UeWtiRKqc0NU6288MCsz6v
	0KY9xtE3i6ffOjYx5NMhBbOf963kd+XE9khFGE88HHNq+v3HLpJds+1EJn/a+/novlWyrje+
	59p+bTAqv3H9QrXj/QlPusOa75/789voRVKglmZkaHXHsqKyZs7/LnIVkc3spUH/tdjsKuvq
	g/IEchfrrhCSP+tRKikR9uRv1FbvI6lJPa9ucew99/+1zaE1P6TZri0TbL9XVMneoFsceGP6
	UnmJo5/v2M5kPftfOOHX1ZSDWitPPJPsFhIsNbq3niGntbw7rvCBxIu/THMnnKgys//AWrdl
	m2XunQDhr1MWas/YJbdp2owlyls1t042X/OjWomlOCPRUIu5qDgRAGxKyeYtBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSnO6T8ro0g6PHeS2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxv11tQUzlSq+3ChqYLwv3cXIySEhYCKx
	+NgUpi5GLg4hgd2MElM/3WOCSEhLdBxqZYewhSVW/nsOZgsJNDBJXFoWAmKzCehI/F7xi6WL
	kYNDREBXovGuAsgcZoFDjBLNG5oZQWqEBQIl5l2awQ5SwyKgKvF6rxpImFfAWuLM+w+MEOPl
	JfYfPMsMYnMK2Ehcmj4LrFwIqObD3UiIckGJkzOfsIDYzEDlzVtnM09gFJiFJDULSWoBI9Mq
	RsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgMNfS3MG4fdUHvUOMTByMQCdzMCuJ8PJn
	1qUJ8aYkVlalFuXHF5XmpBYfYpTmYFES5xV/0ZsiJJCeWJKanZpakFoEk2Xi4JRqYJpi/fT6
	j/Q365f3rItlZlo8eXrFzNKTF/lLU048mmWycc/pTZkRTdYKC6exGqZ/1eVR+yLTf87pu8Pl
	yZPUDN7d74yvCFcv9F474/3uO4LfMu2u2nrMX5y1O2/GqrCzEvEdX4uLIjS7dHSe/NP9e/Gq
	UgJjv5LJr1c+6jIqL3fynxN9e6h43q9fn1csYdAoF+8N43ltq3VfWNJZdK6Gi/QSnfBrBXMb
	v14+E7hD+e6Rzz5fLPgncvHlpqeV8Kw38eLY/nVhrMxfk0WpK57setyUs/mTQerkZWtz88/m
	5m9UeBn0x/fd9I1RGZtv+qcn1fSvrCvbH//daenfrlmuc42TZTyqX1w3+xmUHtTlbaHEUpyR
	aKjFXFScCACgrTN04gIAAA==
X-CMS-MailID: 20240628084420epcas5p32f49e7c977695d20bcef7734eb2e38b4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240628084420epcas5p32f49e7c977695d20bcef7734eb2e38b4
References: <20240628084411.2371-1-cliang01.li@samsung.com>
	<CGME20240628084420epcas5p32f49e7c977695d20bcef7734eb2e38b4@epcas5p3.samsung.com>

Introduce helper functions to check and coalesce hugepage-backed fixed
buffers. The coalescing optimizes both time and space consumption caused
by mapping and storing multi-hugepage fixed buffers. Currently we only
have single-hugepage buffer coalescing, so add support for multi-hugepage
fixed buffer coalescing.

A coalescable multi-hugepage buffer should fully cover its folios
(except potentially the first and last one), and these folios should
have the same size. These requirements are for easier processing later,
also we need same size'd chunks in io_import_fixed for fast iov_iter
adjust.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h |  9 +++++
 2 files changed, 96 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 60c00144471a..c88ce8c38515 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -849,6 +849,93 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
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
+	new_array[0] = page_array[0];
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
+	data->folio_size = folio_size(folio);
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
+		if (nr_folios == 1)
+			data->nr_pages_head = count;
+		else if (count != data->nr_pages_mid)
+			return false;
+
+		folio = page_folio(page_array[i]);
+		if (folio_size(folio) != data->folio_size)
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
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c032ca3436ca..cc66323535f6 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -50,6 +50,15 @@ struct io_mapped_ubuf {
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
+struct io_imu_folio_data {
+	/* Head folio can be partially included in the fixed buf */
+	unsigned int	nr_pages_head;
+	/* For non-head/tail folios, has to be fully included */
+	unsigned int	nr_pages_mid;
+	unsigned int	folio_shift;
+	size_t		folio_size;
+};
+
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
-- 
2.34.1


