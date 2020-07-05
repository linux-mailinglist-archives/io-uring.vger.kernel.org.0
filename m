Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8EE214EAC
	for <lists+io-uring@lfdr.de>; Sun,  5 Jul 2020 20:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgGESwZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jul 2020 14:52:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31523 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgGESwZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jul 2020 14:52:25 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200705185222epoutp042233dbb403a8a4f6bd755752e63688d2~e7-J5OcGE1096410964epoutp04c
        for <io-uring@vger.kernel.org>; Sun,  5 Jul 2020 18:52:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200705185222epoutp042233dbb403a8a4f6bd755752e63688d2~e7-J5OcGE1096410964epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593975142;
        bh=+K/IUmUogGLkZXpodowxoJ/FLK3QQNBHyElRvdThP3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o71jpY2ZOxyciu+t4fgwqMBtNL8KFU0JrmgqKR2CYv0LWY9G6fYJIqyhXsddRR78E
         1eMzZfMACk1XA8JV3T5Oe3TllxQ159IqKxT0NEnI2JvD2RZWKAarWEcbm8zGXMyxvB
         P4DH6IHquYxmrGAZ1CsMxYWvPaK3rhLx/RM+EFMI=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200705185222epcas5p2655d7f75c9997d925e61cb0a57c09c0d~e7-JbJsS92058620586epcas5p2g;
        Sun,  5 Jul 2020 18:52:22 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        84.C7.09703.661220F5; Mon,  6 Jul 2020 03:52:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200705185221epcas5p28b6d060df829b751109265222285da0e~e7-IRsvrN2058620586epcas5p2f;
        Sun,  5 Jul 2020 18:52:21 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200705185221epsmtrp147a3216c334bbd4f68ec760f75006703~e7-IQ2VDE0303903039epsmtrp17;
        Sun,  5 Jul 2020 18:52:21 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-4c-5f022166c93c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.04.08382.461220F5; Mon,  6 Jul 2020 03:52:20 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200705185218epsmtip2e411299166826203d3627aeeceb51079~e7-F3kW7_3204832048epsmtip2u;
        Sun,  5 Jul 2020 18:52:18 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     hch@infradead.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: [PATCH v3 3/4] block: enable zone-append for iov_iter of bvec type
Date:   Mon,  6 Jul 2020 00:17:49 +0530
Message-Id: <1593974870-18919-4-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsWy7bCmhm6aIlO8wbHpPBa/p09htZizahuj
        xeq7/WwWXf+2sFi0tn9jsjg9YRGTxbvWcywWj+98Zrc4+v8tm8WUaU2MFntvaVvs2XuSxeLy
        rjlsFiu2H2Gx2PZ7PrPFlSmLmC1e/zjJZnH+73FWByGPnbPusntsXqHlcflsqcemT5PYPbqv
        /mD06NuyitHj8yY5j/YD3Uwem568ZQrgjOKySUnNySxLLdK3S+DK+HB2KXPBC4GKRTd/sDUw
        vuftYuTkkBAwkeh5f4Wli5GLQ0hgN6NE14MeZgjnE6PE990vGSGcb4wS11b8ZYVpebCphw0i
        sZdR4vCOh1DOZ0aJS83NQFUcHGwCmhIXJpeCmCICNhI7l6iAlDALtDNLXDt5CWyQsIC3xPXl
        TYwgNouAqsSjmdfBbF4BZ4n5m38wQyyTk7h5rhPM5hRwkWjbfRrsPAmBLRwS1yf3sEMUuUhc
        ODUT6jphiVfHt0DFpSRe9rdB2cUSv+4chWruYJS43jCTBSJhL3Fxz18mkEuZgY5ev0sfJMws
        wCfR+/sJWFhCgFeio00IolpR4t6kp1CrxCUezlgCZXtIdLw9DLZKSGA6o8S9izYTGGVnIQxd
        wMi4ilEytaA4Nz212LTAKC+1XK84Mbe4NC9dLzk/dxMjOBFpee1gfPjgg94hRiYOxkOMEhzM
        SiK8vdqM8UK8KYmVValF+fFFpTmpxYcYpTlYlMR5lX6ciRMSSE8sSc1OTS1ILYLJMnFwSjUw
        mS3oz3sXoDTvb+bCHFa/5bEZP2dMX1A/LbjnhW4+8+pG+1W//4ZrRKlt3RR3cs25V69O2nr9
        rxAQrz30S03xd0jw3Exf7dfSccsi9zWX2k6J4Y4szplyvnpWXINegqiVVcXll+63g2YITU/S
        /Gz078BD8a3n6hsU6m8u/jpnxltZjemG9YFfLh99ZORww5OzYbWkkExkpcP8YG3DVYnaU9Q9
        woX7q0xeWpz3+B1ZFRYvV5Mpd+tAZ5uk52Lxo07vbS7uFBXYkf/cyyD1jNF7hbMSEyO2ZHiw
        mO/vOPe1smLp9Cd5Vy86+aQYBjqfDrnyYauHYPlT2fRFRwVW3z/39X5qzmOVqOPCXee2hP9U
        YinOSDTUYi4qTgQATTmlBrMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSvG6KIlO8wcwfNha/p09htZizahuj
        xeq7/WwWXf+2sFi0tn9jsjg9YRGTxbvWcywWj+98Zrc4+v8tm8WUaU2MFntvaVvs2XuSxeLy
        rjlsFiu2H2Gx2PZ7PrPFlSmLmC1e/zjJZnH+73FWByGPnbPusntsXqHlcflsqcemT5PYPbqv
        /mD06NuyitHj8yY5j/YD3Uwem568ZQrgjOKySUnNySxLLdK3S+DK+HB2KXPBC4GKRTd/sDUw
        vuftYuTkkBAwkXiwqYcNxBYS2M0o0bFEEiIuLtF87Qc7hC0ssfLfcyCbC6jmI6PE+VlTmboY
        OTjYBDQlLkwuBakREXCQ6Dr+mAmkhllgKrPE3OYDYEOFBbwlri9vYgSxWQRUJR7NvA5m8wo4
        S8zf/IMZYoGcxM1znWA2p4CLRNvu08wg84WAaqZeUpzAyLeAkWEVo2RqQXFuem6xYYFhXmq5
        XnFibnFpXrpecn7uJkZwDGhp7mDcvuqD3iFGJg7GQ4wSHMxKIry92ozxQrwpiZVVqUX58UWl
        OanFhxilOViUxHlvFC6MExJITyxJzU5NLUgtgskycXBKNTBJcRnavZt3fq1B85q0RSuN/zU0
        HxO/NnuOaWSi6kYtRU/lNOW6fg/+1YYznGX/JL9a7ziN8frEiQcCUiYJNkWuWvE01TY7QXz5
        37kWujLsm9vSmd4GBy9yDK+aMq/17faqJbv/Kgf8vO5efi1mQ7PslnzNoqx50V6i32xPTdD0
        qaq7sujT3yc/E3NXM+a9fWn371WepNTaRUWZ/cc7c1id7Ly4P2d9WLdKxSH5nf6v5fPmuvz5
        X/tPO78t+6zksTO7vgo17EkuajNs/BfyhvXlKV2dKoWNyxbt/v1LPqfKkWU757P37BVyBs1N
        t0R8ZFxP6bvt+i5zXjx8be0pezlDQebowxszz9bviWuZMluJpTgj0VCLuag4EQCG1RVp8AIA
        AA==
X-CMS-MailID: 20200705185221epcas5p28b6d060df829b751109265222285da0e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200705185221epcas5p28b6d060df829b751109265222285da0e
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
        <CGME20200705185221epcas5p28b6d060df829b751109265222285da0e@epcas5p2.samsung.com>
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

