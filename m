Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8242E5E95EF
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 22:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiIYUdn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 16:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiIYUdk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 16:33:40 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227F92C660
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 13:33:39 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220925203337epoutp0499048d6a7f723507e074a651fb0d07fb~YNLXCBY2I0311903119epoutp04s
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 20:33:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220925203337epoutp0499048d6a7f723507e074a651fb0d07fb~YNLXCBY2I0311903119epoutp04s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664138017;
        bh=xEHA1PhpFtWG0bamSbFFyJGRJOLAAuhGzUa6LLwM4SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6oMkOl7TechJJ1mreFv1q+Rxz7F3/cwEucqvDnDMpqVLvUg9yOsBo9bDQ4SF8myo
         g4mRxkvuJJQ0Y1VXHGGKNcUBkb3dGGHmfIaRpIHhVlmrHr8oyx6XBRZTxPZCzEOKPW
         iZuMGlNGswcTCeqokFBNTTvOsmLWHAZ2TD3I0W1c=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220925203336epcas5p25e535716418fc2ee0cd5fdc3090ced4a~YNLWbSum92718327183epcas5p2P;
        Sun, 25 Sep 2022 20:33:36 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MbHf61bVYz4x9Pw; Sun, 25 Sep
        2022 20:33:34 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4C.DF.56352.E1BB0336; Mon, 26 Sep 2022 05:33:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220925203332epcas5p3b080cce759996dec4e081f03e9ecd2f9~YNLSva-p13065330653epcas5p3D;
        Sun, 25 Sep 2022 20:33:32 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220925203332epsmtrp1c69f3c038d7262904ee06decc3f2d561~YNLSr3JVi1867318673epsmtrp1U;
        Sun, 25 Sep 2022 20:33:32 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-7f-6330bb1ec6de
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        51.11.14392.C1BB0336; Mon, 26 Sep 2022 05:33:32 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220925203331epsmtip194fd1e2d401f96ffffb9bd9bca2b9696~YNLRhXsA82877328773epsmtip1l;
        Sun, 25 Sep 2022 20:33:31 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v9 5/7] block: factor out bio_map_get helper
Date:   Mon, 26 Sep 2022 01:53:02 +0530
Message-Id: <20220925202304.28097-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220925202304.28097-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42LZdlhTQ1dut0GywdK3LBar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
        dN0yc4CuUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZY
        GRoYGJkCFSZkZxzqTyjYw18xo+ckcwPjHp4uRk4OCQETicv//7B3MXJxCAnsZpS49uwnI4Tz
        iVFi3ql3UJlvjBIbJjezwLR8nNLHCpHYyyjx9MteNgjnM6PEvxV9TF2MHBxsApoSFyaXgjSI
        CBhJ7P90EqyBWWAGo8TqjtfsIAlhAVeJV9s3gNksAqoS7zouM4LYvAIWEotPL4XaJi8x89J3
        sBpOAUuJJ3O3MkPUCEqcnPkErIYZqKZ562xmkAUSAh/ZJXa8OMMI0ewicWL5VFYIW1ji1fEt
        7BC2lMTL/jYoO1ni0sxzTBB2icTjPQehbHuJ1lP9zCDPMAM9s36XPsQuPone30/AfpQQ4JXo
        aBOCqFaUuDfpKdQmcYmHM5awQpR4SLz9IQwJnh5GifevDrBPYJSfheSDWUg+mIWwbAEj8ypG
        ydSC4tz01GLTAuO81HJ4vCbn525iBKdJLe8djI8efNA7xMjEwXiIUYKDWUmEN+WibrIQb0pi
        ZVVqUX58UWlOavEhRlNgEE9klhJNzgcm6rySeEMTSwMTMzMzE0tjM0Mlcd7FM7SShQTSE0tS
        s1NTC1KLYPqYODilGpiiBCSeZy9k8tH4MVnsQpSUlJ/E93h+nyLboM55hy68YeHefW719Vah
        9p8Tg1s4FyfJHGhpeVmRKt+Uc+Idt17dApWQX5N0ozV7tes5shdNZxNck/H4ysMNQZ4iUT93
        xkn3mO+cvOUzi278j6tPK0Kk83V9TjSZx31f+8P1uXNpKPeaKy884zhdf//6rSO1ZPah7eHz
        ZOoXs3AcuF4o9MNkR16U6Iu937/XTt/rdWXD6e1R33fNbt/oXfb6uap6hZnbWfvlnFtWmr+q
        TzjplXz98a2N7fP/ZtQe+7VEf+5DFxeejE47p3Qj/hfsilo32GN2L1+/jWvb45/li1Yf3x2m
        FOBoI1uSc/v0/IbJe9WVWIozEg21mIuKEwHA5XMaHAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWy7bCSnK7MboNkg/5dxhar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorhsUlJzMstSi/TtErgyDvUnFOzhr5jRc5K5gXEPTxcjJ4eEgInExyl9rF2M
        XBxCArsZJR7cWMQKkRCXaL72gx3CFpZY+e85O0TRR0aJ57P2AxVxcLAJaEpcmFwKUiMiYCax
        9PAaFpAaZoE5jBKXL+8BaxYWcJV4tX0DmM0ioCrxruMyI4jNK2Ahsfj0UhaIBfISMy99B6vh
        FLCUeDJ3KzPIfCGgmq3ntSDKBSVOznwCVs4MVN68dTbzBEaBWUhSs5CkFjAyrWKUTC0ozk3P
        LTYsMMxLLdcrTswtLs1L10vOz93ECA5wLc0djNtXfdA7xMjEwXiIUYKDWUmEN+WibrIQb0pi
        ZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTLET5E2m/FheyCiW
        5XF1UVF9McOF6g8pRUzLWqOWzijg6TnGkdptra93Z0PqgksREXayd7782cgdsvyB4ZITX4Rm
        5pyzftXgw27MGySm6qjdeK3G47m8vfWUH1KGt4x4epexLLewyl4v+7exuKF5zbVyp7R3j2Za
        uTbrp7P7JU9559j7ZYKSzC/TBtXTX0IKzubJZ2dcfTv3WZkeayFD8prNm4SmnVpmylkvPU3E
        U6tTRti0TGK6sVbLxv5yVek7ZifmP/H/sDTRUuNhvhMbj/fGDcp7lvAe0SzmPx/9YdJByYuP
        prkZ7locum2q9OynNs80xbdqWK3TeDt3zvxP2QtPaq/rvSUb9v3fvJ0MSizFGYmGWsxFxYkA
        14Qevt8CAAA=
X-CMS-MailID: 20220925203332epcas5p3b080cce759996dec4e081f03e9ecd2f9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220925203332epcas5p3b080cce759996dec4e081f03e9ecd2f9
References: <20220925202304.28097-1-joshi.k@samsung.com>
        <CGME20220925203332epcas5p3b080cce759996dec4e081f03e9ecd2f9@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move bio allocation logic from bio_map_user_iov to a new helper
bio_map_get. It is named so because functionality is opposite of what is
done inside bio_map_put. This is a prep patch.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-map.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 7693f8e3c454..a7838879e28e 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -241,17 +241,10 @@ static void bio_map_put(struct bio *bio)
 	}
 }
 
-static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
+static struct bio *bio_map_get(struct request *rq, unsigned int nr_vecs,
 		gfp_t gfp_mask)
 {
-	unsigned int max_sectors = queue_max_hw_sectors(rq->q);
-	unsigned int nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS);
 	struct bio *bio;
-	int ret;
-	int j;
-
-	if (!iov_iter_count(iter))
-		return -EINVAL;
 
 	if (rq->cmd_flags & REQ_POLLED) {
 		blk_opf_t opf = rq->cmd_flags | REQ_ALLOC_CACHE;
@@ -259,13 +252,31 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
 		bio = bio_alloc_bioset(NULL, nr_vecs, opf, gfp_mask,
 					&fs_bio_set);
 		if (!bio)
-			return -ENOMEM;
+			return NULL;
 	} else {
 		bio = bio_kmalloc(nr_vecs, gfp_mask);
 		if (!bio)
-			return -ENOMEM;
+			return NULL;
 		bio_init(bio, NULL, bio->bi_inline_vecs, nr_vecs, req_op(rq));
 	}
+	return bio;
+}
+
+static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
+		gfp_t gfp_mask)
+{
+	unsigned int max_sectors = queue_max_hw_sectors(rq->q);
+	unsigned int nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS);
+	struct bio *bio;
+	int ret;
+	int j;
+
+	if (!iov_iter_count(iter))
+		return -EINVAL;
+
+	bio = bio_map_get(rq, nr_vecs, gfp_mask);
+	if (bio == NULL)
+		return -ENOMEM;
 
 	while (iov_iter_count(iter)) {
 		struct page **pages, *stack_pages[UIO_FASTIOV];
-- 
2.25.1

