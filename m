Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F165E95E9
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 22:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiIYUdh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 16:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIYUdg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 16:33:36 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56FF2C118
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 13:33:34 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220925203332epoutp03e3de9b2b6a235b8511c0e2f2d6c0c7d4~YNLSvWRHf1368813688epoutp03J
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 20:33:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220925203332epoutp03e3de9b2b6a235b8511c0e2f2d6c0c7d4~YNLSvWRHf1368813688epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664138012;
        bh=YvisQxDCCiY/YZ3UCOZ2Bjwz4ZAQa8PRkCgpg4Fkog4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPlogZbhuT7uerT2YDoKPEDMrEyfFRwauYPAKibVec8ajg76xi8QG56YOWd6HHify
         PzLHlBM9JX9hi8EL3rPnjPvGpXsOQm03hG7dghvc51UnTPxe+uIwAkWdicZzNkEOsz
         Up2n/Udh+UAGusEGslmzghDNiNF+ajBdoXS4oKGw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220925203331epcas5p21f5dc19cc6f58a8e49e773e4449e7091~YNLROT9ia0635906359epcas5p2T;
        Sun, 25 Sep 2022 20:33:31 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MbHf03gZXz4x9Pv; Sun, 25 Sep
        2022 20:33:28 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.DF.56352.81BB0336; Mon, 26 Sep 2022 05:33:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220925203328epcas5p1872214ededaf3b75762dcb5af15199da~YNLOMXBtq0458804588epcas5p1D;
        Sun, 25 Sep 2022 20:33:28 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220925203328epsmtrp2d3c4637b5c4e6b4c4cc3a7edad3933a7~YNLOJDqs-1586315863epsmtrp2I;
        Sun, 25 Sep 2022 20:33:28 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-76-6330bb1897ca
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.1A.18644.71BB0336; Mon, 26 Sep 2022 05:33:27 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220925203326epsmtip1e21d4e04714bed193e77562734905d21~YNLM7Hh9q0205602056epsmtip1L;
        Sun, 25 Sep 2022 20:33:26 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v9 3/7] nvme: refactor nvme_add_user_metadata
Date:   Mon, 26 Sep 2022 01:53:00 +0530
Message-Id: <20220925202304.28097-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220925202304.28097-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42LZdlhTU1dit0GywdMp4har7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
        dN0yc4CuUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZY
        GRoYGJkCFSZkZ+w8P4mpYK9wRcsRywbGM/xdjJwcEgImEg+OTWDpYuTiEBLYzSjx9PgxJgjn
        E6PEluYdrBDOZ0aJa8eXssO0TJnYxAyR2MUoMWv/S4SqF32z2boYOTjYBDQlLkwuBWkQETCS
        2P/pJFgNs8AMRonVHa/ZQWqEBdwkdh3hBKlhEVCV+HziBQuIzStgIbH1zidGiGXyEjMvfQdb
        zClgKfFk7lZmiBpBiZMzn4DVMwPVNG+dDXaQhMBXdolVy05BNbtIfOnpgrpaWOLV8S1QtpTE
        53d72SDsZIlLM88xQdglEo/3HISy7SVaT/Uzg9zJDPTL+l36ELv4JHp/P2ECCUsI8Ep0tAlB
        VCtK3Jv0lBXCFpd4OGMJlO0hcbXvBjREexgl2l9PZ5rAKD8LyQuzkLwwC2HbAkbmVYySqQXF
        uempxaYFxnmp5fB4Tc7P3cQITpNa3jsYHz34oHeIkYmD8RCjBAezkghvykXdZCHelMTKqtSi
        /Pii0pzU4kOMpsAwnsgsJZqcD0zUeSXxhiaWBiZmZmYmlsZmhkrivItnaCULCaQnlqRmp6YW
        pBbB9DFxcEo1MBWbnXsnoipSeH92Y2zW3J1XrySuuBDap6EeX/eB+bVW1J7t1VGzX2UVdrMG
        ef26UKzlbjg1dqPY+4Q+1ovM1Xmb/otm/hL5zX/kY/JR5ykXlbi3aUqYZ74od9r21SV9o8Hc
        4g2PC5/k9zhGXMleeL9k7kS+pDf/5H7nvZMo46rwv5ibc1e2T0P326HyJP039l9YX7FM90/K
        ENOIaZKwY/QJn3LyoPqPqq2v+OLWnQ18+++FjeD8oNV9sttF+sLOc+mv55zPObvzsfvengim
        3Y5yM1rl9Dhevn5tI2KwKeWsp+AlZed/lx59MVa3DZv8Lef5Cb71Vg4KFukLndkC5X5HzWDw
        OSBfHDY18th2JZbijERDLeai4kQA+827ZRwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSnK74boNkg1vvzCxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpuwOHx+WzpR6bVnWyeWxeUu+x+2YDm0ff
        llWMHp83yQWwRXHZpKTmZJalFunbJXBl7Dw/ialgr3BFyxHLBsYz/F2MnBwSAiYSUyY2MXcx
        cnEICexglNjR1cAOkRCXaL72A8oWllj57zk7RNFHRok3fU0sXYwcHGwCmhIXJpeC1IgImEks
        PbyGBaSGWWAOo8Tly3vYQWqEBdwkdh3hBKlhEVCV+HziBQuIzStgIbH1zidGiPnyEjMvfQfb
        xSlgKfFk7lZmkFYhkJrzWhDlghInZz4Ba2UGKm/eOpt5AqPALCSpWUhSCxiZVjFKphYU56bn
        FhsWGOWllusVJ+YWl+al6yXn525iBIe3ltYOxj2rPugdYmTiYDzEKMHBrCTCm3JRN1mINyWx
        siq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGJt38uGUu21ud9x+a
        PHH2tyUnlk+XncGxNXfhj8uVoa5zH+bHbXJo37xYZfO8YE2eewEq1/aW26wv3rG8LF6+60a0
        YMafXoYwOZ/bCp3r3JSaJopPFl+asub5fi3FS3P3qkquvGB7IjHW6uNUT5PEIyfzQy25aj69
        ucYh+4WN/Z3ajjVWbDOjWz6/3NC7+qvqrH+qvQs6v8qXvdjfM9tzyg/x5WwzN3zZn99d2/nf
        MPqP8eMqD35Lm2civ97H6K7n2BIYVMS8Z2bctD3LWpiWrVh5Uszm4BxH5ddvmHc2OZmqT8lO
        2XkrqCex6R2fpp/71KWScW1Tz4o97F81//+NP+9fyEmZS7nteiezvXbJ8UIlluKMREMt5qLi
        RADkQPBL3gIAAA==
X-CMS-MailID: 20220925203328epcas5p1872214ededaf3b75762dcb5af15199da
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220925203328epcas5p1872214ededaf3b75762dcb5af15199da
References: <20220925202304.28097-1-joshi.k@samsung.com>
        <CGME20220925203328epcas5p1872214ededaf3b75762dcb5af15199da@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass struct request rather than bio. It helps to kill a parameter, and
some processing clean-up too.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 548aca8b5b9f..8f8435b55b95 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -20,19 +20,20 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 	return (void __user *)ptrval;
 }
 
-static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
-		unsigned len, u32 seed, bool write)
+static void *nvme_add_user_metadata(struct request *req, void __user *ubuf,
+		unsigned len, u32 seed)
 {
 	struct bio_integrity_payload *bip;
 	int ret = -ENOMEM;
 	void *buf;
+	struct bio *bio = req->bio;
 
 	buf = kmalloc(len, GFP_KERNEL);
 	if (!buf)
 		goto out;
 
 	ret = -EFAULT;
-	if (write && copy_from_user(buf, ubuf, len))
+	if ((req_op(req) == REQ_OP_DRV_OUT) && copy_from_user(buf, ubuf, len))
 		goto out_free_meta;
 
 	bip = bio_integrity_alloc(bio, GFP_KERNEL, 1);
@@ -45,9 +46,13 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	bip->bip_iter.bi_sector = seed;
 	ret = bio_integrity_add_page(bio, virt_to_page(buf), len,
 			offset_in_page(buf));
-	if (ret == len)
-		return buf;
-	ret = -ENOMEM;
+	if (ret != len) {
+		ret = -ENOMEM;
+		goto out_free_meta;
+	}
+
+	req->cmd_flags |= REQ_INTEGRITY;
+	return buf;
 out_free_meta:
 	kfree(buf);
 out:
@@ -70,7 +75,6 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 		u32 meta_seed, void **metap, unsigned timeout, bool vec,
 		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags)
 {
-	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
 	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
 	struct request *req;
@@ -110,13 +114,12 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 		if (bdev)
 			bio_set_dev(bio, bdev);
 		if (bdev && meta_buffer && meta_len) {
-			meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
-					meta_seed, write);
+			meta = nvme_add_user_metadata(req, meta_buffer, meta_len,
+					meta_seed);
 			if (IS_ERR(meta)) {
 				ret = PTR_ERR(meta);
 				goto out_unmap;
 			}
-			req->cmd_flags |= REQ_INTEGRITY;
 			*metap = meta;
 		}
 	}
-- 
2.25.1

