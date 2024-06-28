Return-Path: <io-uring+bounces-2391-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C7791CB80
	for <lists+io-uring@lfdr.de>; Sat, 29 Jun 2024 09:26:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87AA8B22682
	for <lists+io-uring@lfdr.de>; Sat, 29 Jun 2024 07:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B3282BCF7;
	Sat, 29 Jun 2024 07:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bsXHeIjx"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C92E14A85
	for <io-uring@vger.kernel.org>; Sat, 29 Jun 2024 07:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719645996; cv=none; b=eB58bs8g2s6loUijpPYPK724qX6AbohOKW7blx3obIy9Uq9dO5fc4ZROw4PlBG0/4Wld8WyeE+mDsEMq3BT2CpKR+mBTwIcZ6slMNuKLUPT0/QjMhlxFfL5vNSFaF/F4vNBhrbS8dfWxTgbdXaPIblvxlPbtLIjEIhgDjOgygtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719645996; c=relaxed/simple;
	bh=olUa9NNU5ieHcq+Y0HijNMgWRehRC83XOiz7F25J15s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=eAkwVb2KAvh/GYuKUaWUukgW1xMSg6wTsG1GRfjSVYLiA2BoHzIBYqGcalsO5eT6hCLvirM0vO3+We5EMmOYYVvrSMtPUcaAGDsx9ljSMVYku9b1N4zsJ7CRn/P7Gfqz32wqakcuX6MbZvygNrNbgo922BRvwp8ylh2j2O4Svxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bsXHeIjx; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240629072627epoutp01532a3b1cc3466a99d61867fbc9c771d1~daOoQbekt0894708947epoutp01Q
	for <io-uring@vger.kernel.org>; Sat, 29 Jun 2024 07:26:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240629072627epoutp01532a3b1cc3466a99d61867fbc9c771d1~daOoQbekt0894708947epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719645987;
	bh=6/v7IO359KNVg7LZfAqkCs7n+e4c0tDwe9IRKktQPCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsXHeIjxQBf88QiLovNMRTIaEpwJD7PjbU93PYX0aEeTkamGomhmoOaP6mE0Rle5f
	 1GdSYZpO23ehgb/SCTNmV3bZXAu+TaoPb63f9w2lCEpyetGr2BLqie+2pXuWjMYWPj
	 tXD87LHMKLSQY+K2OYVA0Mxyc5W31ERMgyvgWOiE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240629072626epcas5p4a1e05ea0923d97a61242039d34df095d~daOn6P7IE1644816448epcas5p4P;
	Sat, 29 Jun 2024 07:26:26 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WB3l54YYlz4x9Q1; Sat, 29 Jun
	2024 07:26:25 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D0.18.09989.127BF766; Sat, 29 Jun 2024 16:26:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240628084424epcas5p3c34ec2fb8fb45752ef6a11447812ae0d~dHpZveEF62959029590epcas5p3v;
	Fri, 28 Jun 2024 08:44:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240628084424epsmtrp2ac106bb238054bd8e9b8034ab64773cc~dHpZux7Co0972309723epsmtrp2C;
	Fri, 28 Jun 2024 08:44:24 +0000 (GMT)
X-AuditID: b6c32a4a-e57f970000002705-d2-667fb7214541
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D3.14.29940.8E77E766; Fri, 28 Jun 2024 17:44:24 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240628084423epsmtip1b007ffc2cfce9051c28fe004bba20491~dHpYs2f-Q0054500545epsmtip1y;
	Fri, 28 Jun 2024 08:44:22 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v5 3/3] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
Date: Fri, 28 Jun 2024 16:44:11 +0800
Message-Id: <20240628084411.2371-4-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240628084411.2371-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmpq7i9vo0g/X/5CyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IxNE2YxF/wVqZj9+DJrA+MsgS5GTg4JAROJDw/+snQxcnEICexm
	lLiwdAsbhPOJUWL+ytPMEM43RokJ8++xwrS03+1mArGFBPYyStw6ZARR1MQkcbJtJVgRm4CO
	xO8Vv1hAbBEBbYnXj6eC2cwCuxglFp6TArGFBQIknjWcZwexWQRUJW7vPwtm8wpYSzz4tZIZ
	Ypm8xP6DZ8FsTgEbiUvTZ0HVCEqcnPkEaqa8RPPW2WCXSgg0ckg82/6ZDaLZReL2wgeMELaw
	xKvjW9ghbCmJz+/2AtVwANnFEsvWyUH0tjBKvH83B6reWuLflT0sIDXMApoS63fpQ4RlJaae
	WscEsZdPovf3EyaIOK/EjnkwtqrEhYPboFZJS6ydsBXqFw+Jza+aGSGB1c8oseTUL8YJjAqz
	kPwzC8k/sxBWL2BkXsUomVpQnJueWmxaYJSXWg6P5eT83E2M4HSq5bWD8eGDD3qHGJk4GA8x
	SnAwK4nw8mfWpQnxpiRWVqUW5ccXleakFh9iNAUG+ERmKdHkfGBCzyuJNzSxNDAxMzMzsTQ2
	M1QS533dOjdFSCA9sSQ1OzW1ILUIpo+Jg1OqgWme0BrOMwdVzjwUrnSofXP5eYfGne7WLwJ7
	zv6fJpXGK5E3WXjLB6/EnKyzRcHGy6ZFbtNbovdIaN/PhnxFw2Xn/B1EfjAd/rOvYeKT4yd+
	BHT+fHvw4KLddtE7697ovA5rvGbAG3Fj4wnnmM2f8i5En7Y/utoyYvGnczeVhbZsM/xlfDhW
	7FmUW+fM6Ik9fbe9jR9ps61g2bb5WeTPZ69ZL3Tc+iRVErnYWqstO2Ot0UvXs3rTfUQz7nmq
	ydj0Jm7Ztu/QtvM8k4NuHFg8fXGWvfqeQL8DP6rW5u5M6vY8ILLKKu7M2WVbL7WoqCu/WKLg
	Zud/mPmR+nrVaptlgjKHq+sd+jN8vrTX71CWk9unxFKckWioxVxUnAgA7tPECjAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWy7bCSnO6L8ro0g/PXOSyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxqYJs5gL/opUzH58mbWBcZZAFyMnh4SA
	iUT73W6mLkYuDiGB3YwSc18eYINISEt0HGplh7CFJVb+e84OUdTAJDHv6yNmkASbgI7E7xW/
	WLoYOThEBHQlGu8qgNQwCxxilGje0MwIUiMs4CdxoW8eE4jNIqAqcXv/WbChvALWEg9+rWSG
	WCAvsf/gWTCbU8BG4tL0WewgM4WAaj7cjYQoF5Q4OfMJC4jNDFTevHU28wRGgVlIUrOQpBYw
	Mq1ilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAgOdy3NHYzbV33QO8TIxMEIdDMHs5II
	L39mXZoQb0piZVVqUX58UWlOavEhRmkOFiVxXvEXvSlCAumJJanZqakFqUUwWSYOTqkGpsIf
	Veee2Res+JG58dOL5cy7tdZkLy5xbj++kXkNf8IxJeNZtiq+2+/MmqHRVvThz61ZCXPK3KNP
	b7v+JqlYXSEi+MKP87GKibsZ7sbxzhI5OYV3s11HYsn+ad945C5nnvs6Zc9SJsmIZp413VNk
	fy3fK5j2Mv+pbrfLoeg77d/5rDbFzjGx4JpXwX03I/pK2yGHSVlcr3aeturmaD8dJPnrghRD
	zLOvCes1jz5g3Vw1//Dc2nYB898+XcInPxsVCTYqZly71/W7IM/v5boi64MhrbNmbby2//+n
	tq3vvu0zn7D45aPlf4qvcqkylJ/L5r/vJfZ05u0LuvWscqfiip6KNW2fLLjE4/TkfJ/THxYp
	sRRnJBpqMRcVJwIA2rwVxeYCAAA=
X-CMS-MailID: 20240628084424epcas5p3c34ec2fb8fb45752ef6a11447812ae0d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240628084424epcas5p3c34ec2fb8fb45752ef6a11447812ae0d
References: <20240628084411.2371-1-cliang01.li@samsung.com>
	<CGME20240628084424epcas5p3c34ec2fb8fb45752ef6a11447812ae0d@epcas5p3.samsung.com>

Modify io_sqe_buffer_register to enable the coalescing for
multi-hugepage fixed buffers.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 47 ++++++++++++++++-------------------------------
 1 file changed, 16 insertions(+), 31 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3198cf854db1..790ed3c1bcc8 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -945,7 +945,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	unsigned long off;
 	size_t size;
 	int ret, nr_pages, i;
-	struct folio *folio = NULL;
+	struct io_imu_folio_data data;
+	bool coalesced;
 
 	*pimu = (struct io_mapped_ubuf *)&dummy_ubuf;
 	if (!iov->iov_base)
@@ -960,31 +961,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -1004,17 +982,24 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	imu->nr_bvecs = nr_pages;
 	imu->folio_shift = PAGE_SHIFT;
 	imu->folio_mask = PAGE_MASK;
+	if (coalesced) {
+		imu->folio_shift = data.folio_shift;
+		imu->folio_mask = ~((1UL << data.folio_shift) - 1);
+	}
 	*pimu = imu;
 	ret = 0;
 
-	if (folio) {
-		bvec_set_page(&imu->bvec[0], pages[0], size, off);
-		goto done;
-	}
 	for (i = 0; i < nr_pages; i++) {
 		size_t vec_len;
 
-		vec_len = min_t(size_t, size, PAGE_SIZE - off);
+		if (coalesced) {
+			size_t seg_size = i ? data.folio_size :
+				PAGE_SIZE * data.nr_pages_head;
+
+			vec_len = min_t(size_t, size, seg_size - off);
+		} else {
+			vec_len = min_t(size_t, size, PAGE_SIZE - off);
+		}
 		bvec_set_page(&imu->bvec[i], pages[i], vec_len, off);
 		off = 0;
 		size -= vec_len;
-- 
2.34.1


