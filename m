Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD334D1C15
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347923AbiCHPoB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347933AbiCHPn6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:43:58 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ABE34656
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:43:01 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220308154259epoutp0140180e55022f7c7b6ea67441a6ba1bd7~acjOptq9a1308713087epoutp01F
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:42:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220308154259epoutp0140180e55022f7c7b6ea67441a6ba1bd7~acjOptq9a1308713087epoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754180;
        bh=yZrnUJ+OizD3P426LO8RDZ9aFK64rTJqSnlCEwq+Q0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgyRWrzGR6g0UegyOi5IZVYEWWxQhmfnzuZnZgfReyAauvnWOLFmdXzugkxsGoDoz
         RYT4rSboXJUTdgPuoABqyrrI7DFThh2gAV9L3ApIxDqqXGDDWr8cTCiSlkgoZlLCMl
         ULqPnfmnY/C/UIDMif75Wy8YsVgUtYQkHJYHW1JY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220308154259epcas5p4378118cc100fa519e953b6d8c5b8ed84~acjONar9f2304623046epcas5p4I;
        Tue,  8 Mar 2022 15:42:59 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KCfjX26Wmz4x9Pt; Tue,  8 Mar
        2022 15:42:56 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.BB.05590.08977226; Wed,  9 Mar 2022 00:42:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220308152718epcas5p3afd2c8a628f4e9733572cbb39270989d~acVh836sV0623006230epcas5p3t;
        Tue,  8 Mar 2022 15:27:18 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220308152718epsmtrp20821a446ed5389f4dcc0574257c867fe~acVh7_rJl2706527065epsmtrp2D;
        Tue,  8 Mar 2022 15:27:18 +0000 (GMT)
X-AuditID: b6c32a4b-723ff700000015d6-65-6227798078e9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7B.51.29871.6D577226; Wed,  9 Mar 2022 00:27:18 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152716epsmtip17df4dff75fe115ee2b149232b262bb53~acVf4GXN23168431684epsmtip1G;
        Tue,  8 Mar 2022 15:27:16 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 12/17] nvme: enable bio-cache for fixed-buffer passthru
Date:   Tue,  8 Mar 2022 20:51:00 +0530
Message-Id: <20220308152105.309618-13-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmlm5DpXqSwZl9nBbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
        ycUnQNctMwfoByWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpe
        XmqJlaGBgZEpUGFCdsbXBZfZC27IVyxf1c/ewDhNqouRg0NCwESi56ldFyMXh5DAbkaJOXPW
        s0M4nxgllr26xQrhfGOUeH5qEVMXIydYR/OZScwQib2MElebtkE5nxklnpxczwgyl01AU+LC
        5FKQBhEBL4n7t9+DTWIW6GKSeLvvPhtIQljAXeLs20ssIDaLgKrEtfMguzk5eAWsJNb/WskM
        sU1eYual72BxTqD4z1tbWSFqBCVOznwC1ssMVNO8dTZU/REOiZm/2CBsF4nby3dCXS0s8er4
        FnYIW0ri87u9UDXFEr/uHAV7QEKgg1HiesNMFoiEvcTFPX+ZQJ5hBnpm/S59iLCsxNRT65gg
        9vJJ9P5+AjWfV2LHPBhbUeLepKesELa4xMMZS6BsD4mz/+9BA6uXUaJ/20G2CYwKs5D8MwvJ
        P7MQVi9gZF7FKJlaUJybnlpsWmCcl1oOj+Xk/NxNjOB0reW9g/HRgw96hxiZOBgPMUpwMCuJ
        8N4/r5IkxJuSWFmVWpQfX1Sak1p8iNEUGOATmaVEk/OBGSOvJN7QxNLAxMzMzMTS2MxQSZz3
        VPqGRCGB9MSS1OzU1ILUIpg+Jg5OqQamtRkvjn+R/bxuMtshvrXF114cnOn3qNdf2GnDCs84
        b9nyb2/+buYuNd+zsv/WtlOmZabTXgVYT3Tsd4k7YTU93ubXbKMlSZ2t+YlhZ+9rP+s3ltgy
        8V9P8sdb1q8vfuw8uVdnLvOvyXcZM8+2PBJf9q1db8vVAzoyOjvs9tl+Obota/N/2f9+wuap
        PesKb51eajLnuM76oCsXin/qhl5bKX/98NdT+xhKXQ4fWFYl4ZvosDK46ahBMbNNkm8FA7PS
        5OdPNHc2+z03EU18d+3585Wbjm9UcjlkrTtjqpPio7d/Z19or07pYSreGmt8PlagsyXvZqlN
        9ks/pSV3lZ+uXu3sv5OJWfOjAXfc1KxGDiWW4oxEQy3mouJEAC6rD9lgBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJTvdaqXqSwcnpshbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr4+uCy+wFN+Qrlq/qZ29gnCbVxcjJISFgItF8
        ZhJzFyMXh5DAbkaJh+v3M0IkxCWar/1gh7CFJVb+e84OUfQRqGjTJpYuRg4ONgFNiQuTS0Fq
        RAQCJA42XgarYRaYwSTR0/yZBSQhLOAucfbtJTCbRUBV4tr59WBDeQWsJNb/WskMsUBeYual
        72BxTqD4z1tbWUFsIQFLiRXrfrNB1AtKnJz5BGwOM1B989bZzBMYBWYhSc1CklrAyLSKUTK1
        oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4orQ0dzBuX/VB7xAjEwfjIUYJDmYlEd7751WS
        hHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamBirwt+oOTo
        9640Qavs3bHvgVIWqatdIh6JR2zPF+3c+fre8xQpo4UTi/b6PBN+fMnf5YGA4dqzbRnJmgz2
        KkLik43OPV26IVNc70FT+tOYGa6brBLv//Fxu+GqdL3bgmvmB/ZNx6vvejzx0Alwq7uTfebQ
        VCeBnqr8JN/93speR+9LzczaGVbI8kM5J2Gm/n5VF1azRacWLmWQVV3g+WBa/ScRoaWHLJ7x
        PDT9+f31BGvHEhv9yLypud+vx8Qnn/fedJL/dOpzdgeT2pJH85+rv/0b72zOXF/uekt0xkyZ
        T5L/VwnPY4/lcK5YVfX+VuC3dv7WgyIJQVe+zK3M7NKbvzFJdoq6w5mjN07eM1RiKc5INNRi
        LipOBACYbmLUFwMAAA==
X-CMS-MailID: 20220308152718epcas5p3afd2c8a628f4e9733572cbb39270989d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152718epcas5p3afd2c8a628f4e9733572cbb39270989d
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152718epcas5p3afd2c8a628f4e9733572cbb39270989d@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since we do submission/completion in task, we can have this up.
Add a bio-set for nvme as we need that for bio-cache.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-map.c           | 4 ++--
 drivers/nvme/host/core.c  | 9 +++++++++
 drivers/nvme/host/ioctl.c | 2 +-
 drivers/nvme/host/nvme.h  | 1 +
 include/linux/blk-mq.h    | 3 ++-
 5 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 027e8216e313..c39917f0eb78 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -580,7 +580,7 @@ EXPORT_SYMBOL(blk_rq_map_user);
 
 /* Unlike blk_rq_map_user () this is only for fixed-buffer async passthrough. */
 int blk_rq_map_user_fixedb(struct request_queue *q, struct request *rq,
-		     u64 ubuf, unsigned long len, gfp_t gfp_mask,
+		     u64 ubuf, unsigned long len, struct bio_set *bs,
 		     struct io_uring_cmd *ioucmd)
 {
 	struct iov_iter iter;
@@ -604,7 +604,7 @@ int blk_rq_map_user_fixedb(struct request_queue *q, struct request *rq,
 	if (nr_segs > queue_max_segments(q))
 		return -EINVAL;
 	/* no iovecs to alloc, as we already have a BVEC iterator */
-	bio = bio_alloc(gfp_mask, 0);
+	bio = bio_from_cache(0, bs);
 	if (!bio)
 		return -ENOMEM;
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3fe8f5901cd9..4a385001f124 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -30,6 +30,9 @@
 
 #define NVME_MINORS		(1U << MINORBITS)
 
+#define NVME_BIO_POOL_SZ	(4)
+struct bio_set nvme_bio_pool;
+
 unsigned int admin_timeout = 60;
 module_param(admin_timeout, uint, 0644);
 MODULE_PARM_DESC(admin_timeout, "timeout in seconds for admin commands");
@@ -4797,6 +4800,11 @@ static int __init nvme_core_init(void)
 		goto unregister_generic_ns;
 	}
 
+	result = bioset_init(&nvme_bio_pool, NVME_BIO_POOL_SZ, 0,
+			BIOSET_NEED_BVECS | BIOSET_PERCPU_CACHE);
+	if (result < 0)
+		goto unregister_generic_ns;
+
 	return 0;
 
 unregister_generic_ns:
@@ -4819,6 +4827,7 @@ static int __init nvme_core_init(void)
 
 static void __exit nvme_core_exit(void)
 {
+	bioset_exit(&nvme_bio_pool);
 	class_destroy(nvme_ns_chr_class);
 	class_destroy(nvme_subsys_class);
 	class_destroy(nvme_class);
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 91d893eedc82..a4cde210aab9 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -159,7 +159,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	if (ubuffer && bufflen) {
 		if (likely(nvme_is_fixedb_passthru(ioucmd)))
 			ret = blk_rq_map_user_fixedb(q, req, ubuffer, bufflen,
-					GFP_KERNEL, ioucmd);
+					&nvme_bio_pool, ioucmd);
 		else
 			ret = blk_rq_map_user(q, req, NULL, nvme_to_user_ptr(ubuffer),
 					bufflen, GFP_KERNEL);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index e6a30543d7c8..9a3e5093dedc 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -47,6 +47,7 @@ extern unsigned int admin_timeout;
 extern struct workqueue_struct *nvme_wq;
 extern struct workqueue_struct *nvme_reset_wq;
 extern struct workqueue_struct *nvme_delete_wq;
+extern struct bio_set nvme_bio_pool;
 
 /*
  * List of workarounds for devices that required behavior not specified in
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 48bcfd194bdc..5f21f71b2529 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -967,7 +967,8 @@ struct rq_map_data {
 int blk_rq_map_user(struct request_queue *, struct request *,
 		struct rq_map_data *, void __user *, unsigned long, gfp_t);
 int blk_rq_map_user_fixedb(struct request_queue *, struct request *,
-		     u64 ubuf, unsigned long, gfp_t,  struct io_uring_cmd *);
+		     u64 ubuf, unsigned long, struct bio_set *,
+		     struct io_uring_cmd *);
 int blk_rq_map_user_iov(struct request_queue *, struct request *,
 		struct rq_map_data *, const struct iov_iter *, gfp_t);
 int blk_rq_unmap_user(struct bio *);
-- 
2.25.1

