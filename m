Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E60B22CAF8
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 18:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgGXQYB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 12:24:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11225 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgGXQYA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 12:24:00 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200724162357epoutp036f2b322a70ae3e82ab27b186e8bac084~kvN_4ILu90333203332epoutp03Y
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 16:23:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200724162357epoutp036f2b322a70ae3e82ab27b186e8bac084~kvN_4ILu90333203332epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595607837;
        bh=+K/IUmUogGLkZXpodowxoJ/FLK3QQNBHyElRvdThP3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NwpGOYFVSun6Onz/lxGDkmIzLhwN8dpbvVUU5XEFBXCaE/CCVz/eWhtKiCtf3VHT7
         q9pwCtM5y5Ap7RaGOnVLh+z6YmZ8VExcMBLtjO3kiA2oSNwwbGTBm4CqbZhzDmlBpF
         6Iz7J7QV6YqvipOJjqTvOzvDh8LK2kiLZw6GN9Mc=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200724162355epcas5p14c10449e6256a8ac7315a7916be62e96~kvN9y9akW0808308083epcas5p12;
        Fri, 24 Jul 2020 16:23:55 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2F.CE.40333.B1B0B1F5; Sat, 25 Jul 2020 01:23:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200724155346epcas5p2cfb383fe9904a45280c6145f4c13e1b4~kuzoV0vvb0555205552epcas5p2Z;
        Fri, 24 Jul 2020 15:53:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724155346epsmtrp2e1e45c2609438de6fb93596d26e21103~kuzoU-y1f3047030470epsmtrp2C;
        Fri, 24 Jul 2020 15:53:46 +0000 (GMT)
X-AuditID: b6c32a4a-9a7ff70000019d8d-86-5f1b0b1be864
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9A.A9.08303.9040B1F5; Sat, 25 Jul 2020 00:53:45 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200724155343epsmtip141811e600c138774385c1799ffec5e05~kuzlsG1Sv0293902939epsmtip1w;
        Fri, 24 Jul 2020 15:53:43 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     willy@infradead.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: [PATCH v4 5/6] block: enable zone-append for iov_iter of bvec type
Date:   Fri, 24 Jul 2020 21:19:21 +0530
Message-Id: <1595605762-17010-6-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsWy7bCmpq40t3S8wfKfhha/p09htZizahuj
        xeq7/WwWXf+2sFi0tn9jsjg9YRGTxbvWcywWj+98Zrc4+v8tm8WUaU2MFpu/d7BZ7L2lbbFn
        70kWi8u75rBZbPs9n9niypRFzBavf5xkszj/9zirxe8fc9gchD12zrrL7rF5hZbH5bOlHps+
        TWL36NuyitHj8yY5j/YD3Uwem568ZQrgiOKySUnNySxLLdK3S+DK+HB2KXPBC4GKRTd/sDUw
        vuftYuTkkBAwkdi+7jVbFyMXh5DAbkaJ+4fuMkE4nxglXh68CJX5zCgx7/J5ZpiWbz2zoap2
        MUrMnDWLBSQBVrXwh18XIwcHm4CmxIXJpSCmiICNxM4lKiAVzALLmSXWrwXbLCzgLTH/VjMz
        SAmLgKrEpG5hkDCvgLPEzAk7mCA2yUncPNcJtpVTwEXiwsW7jBDxLRwSCzc5gLRKAMU3feaH
        CAtLvDq+hR3ClpL4/G4vG4RdLPHrzlFmkIMlBDoYJa43zGSBSNhLXNzzlwlkDjPQwet36UOE
        ZSWmnlrHBHExn0Tv7ydQ5/BK7JgHYytK3Jv0lBXCFpd4OGMJlO0h0XfiOCMkPKYDQ+2t+ARG
        uVkIGxYwMq5ilEwtKM5NTy02LTDKSy3XK07MLS7NS9dLzs/dxAhOTFpeOxgfPvigd4iRiYPx
        EKMEB7OSCO+Kb1LxQrwpiZVVqUX58UWlOanFhxilOViUxHmVfpyJExJITyxJzU5NLUgtgsky
        cXBKNTC1HdPoXGhY+Yr1zPUWX45nXfkhwRrePPZxWRmeT+rXR7y59D0q+HrHhN4jf86ttDf5
        HZu57NT8NyU/llydvW5u96VCYUcGR+31ngt+f0zYIvezJmiT2SO/X2uveItNZD3GXH6B8bHQ
        429Cxo1XoidsCtT6wNWz/72ix6MNBkZJtse/XF8UsZLfdPsbu8U797yN+plmVzuXSVPkssn5
        jXZLDVf/+SF8d71pMes0G375R1e+TFnlefikqK5jPmvL/wL3kn/r+sW+GpuXzjm1ffLJi+LH
        +JV7GRj3MJ94ca1n+/cL3+dGVvIxPexg/TY5r35Cq9fjw0F2rcU5T34y6unJnRSee4LxG6eP
        gNBO/Z0tSizFGYmGWsxFxYkAL47hIbsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWy7bCSnC4ni3S8wcFea4vf06ewWsxZtY3R
        YvXdfjaLrn9bWCxa278xWZyesIjJ4l3rORaLx3c+s1sc/f+WzWLKtCZGi83fO9gs9t7Sttiz
        9ySLxeVdc9gstv2ez2xxZcoiZovXP06yWZz/e5zV4vePOWwOwh47Z91l99i8Qsvj8tlSj02f
        JrF79G1ZxejxeZOcR/uBbiaPTU/eMgVwRHHZpKTmZJalFunbJXBlfDi7lLnghUDFops/2BoY
        3/N2MXJySAiYSHzrmc0EYgsJ7GCU2N6WBBEXl2i+9oMdwhaWWPnvOZDNBVTzkVHi+6p9zF2M
        HBxsApoSFyaXgtSICDhIdB1/zARSwyywnVni+5v5bCAJYQFvifm3msHqWQRUJSZ1C4OEeQWc
        JWZO2MEEMV9O4ua5TmYQm1PAReLCxbuMIOVCQDUXf5RPYORbwMiwilEytaA4Nz232LDAKC+1
        XK84Mbe4NC9dLzk/dxMjOAK0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHeFd+k4oV4UxIrq1KL8uOL
        SnNSiw8xSnOwKInzfp21ME5IID2xJDU7NbUgtQgmy8TBKdXAdO7O/87KJ3afM7qvsxbycwjq
        ZQn+OGyyzHffDFlXjVMl6+tquHeFrBDZp/D2TabkMfmbBa4ep69O/u5mL7GiWU5EnL3E0mXL
        F5OZeVksUy6oHSxL1LnUcmjeJNPI99wt63S1JPNCrk6e/f5qkKjsts17ZU02PrX8+uVBTGXg
        cb9d8rKBDgd46l2+Xo5bdfHVHBGBbwkduoE6KxJUna1blaZv+3S2bc2T2lN1Z6QXh9dxydyx
        3SZhxPCCy5HPbVX338SYkpiGkEDTKDmBx7sK9sn3ClrOCl05+farFb80JMLUPqbYyibcnGlS
        UbjP/oDm0iBVoUyFUp0mjRteT098YX+R7Gpz9O4GixK21JNKLMUZiYZazEXFiQA38RbV7wIA
        AA==
X-CMS-MailID: 20200724155346epcas5p2cfb383fe9904a45280c6145f4c13e1b4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200724155346epcas5p2cfb383fe9904a45280c6145f4c13e1b4
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
        <CGME20200724155346epcas5p2cfb383fe9904a45280c6145f4c13e1b4@epcas5p2.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

zone-append with bvec iov_iter gives WARN_ON, and returns -EINVAL.
Add new helper to process such iov_iter and add pages in bio honoring
zone-append specific constraints.
This is used to enable zone-append with io-uring fixed-buffer.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 block/bio.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0cecdbc..ade9da7 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -975,6 +975,30 @@ static int __bio_iov_bvec_add_pages(struct bio *bio, struct iov_iter *iter)
 	iov_iter_advance(iter, size);
 	return 0;
 }
+static int __bio_iov_bvec_append_add_pages(struct bio *bio, struct iov_iter *iter)
+{
+	const struct bio_vec *bv = iter->bvec;
+	unsigned int len;
+	size_t size;
+	struct request_queue *q = bio->bi_disk->queue;
+	unsigned int max_append_sectors = queue_max_zone_append_sectors(q);
+	bool same_page = false;
+
+	if (WARN_ON_ONCE(!max_append_sectors))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(iter->iov_offset > bv->bv_len))
+		return -EINVAL;
+
+	len = min_t(size_t, bv->bv_len - iter->iov_offset, iter->count);
+	size = bio_add_hw_page(q, bio, bv->bv_page, len,
+				bv->bv_offset + iter->iov_offset,
+				max_append_sectors, &same_page);
+	if (unlikely(size != len))
+		return -EINVAL;
+	iov_iter_advance(iter, size);
+	return 0;
+}
 
 #define PAGE_PTRS_PER_BVEC     (sizeof(struct bio_vec) / sizeof(struct page *))
 
@@ -1105,9 +1129,10 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 
 	do {
 		if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
-			if (WARN_ON_ONCE(is_bvec))
-				return -EINVAL;
-			ret = __bio_iov_append_get_pages(bio, iter);
+			if (is_bvec)
+				ret = __bio_iov_bvec_append_add_pages(bio, iter);
+			else
+				ret = __bio_iov_append_get_pages(bio, iter);
 		} else {
 			if (is_bvec)
 				ret = __bio_iov_bvec_add_pages(bio, iter);
-- 
2.7.4

