Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B1B47B8BA
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 03:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbhLUC5J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 21:57:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47181 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbhLUC5I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 21:57:08 -0500
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20211221025706epoutp0348f82a5709d78df21ea5b92298e5df79~Cpbh4tOZ32952329523epoutp03e
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 02:57:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20211221025706epoutp0348f82a5709d78df21ea5b92298e5df79~Cpbh4tOZ32952329523epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1640055426;
        bh=SWDMGTcULDyUUGJ03Gd9mGp0+xbdwZhQc470VcrJToQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwsZYNtRqSN1e3qi7IZ7BE4Ua9mQb/QTBRdpCu962IkHeUOQi00hYdq6upyHxLUf9
         6GMIlNMGe01Y08Ru0m084l7cP2jpdqXlu7LEhGYXr2HtdHfrz0w24JudZx0RJdbTfQ
         gneRXN4A/8UkSZvlx/gnOshWrGvG0lt/K7O9q9fo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20211221025705epcas5p22b6929f51df31440c1b220fef405690a~CpbhSk1sY1195011950epcas5p2C;
        Tue, 21 Dec 2021 02:57:05 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4JJ1MK5GNCz4x9Pt; Tue, 21 Dec
        2021 02:57:01 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.86.06423.C7241C16; Tue, 21 Dec 2021 11:57:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20211220142250epcas5p34b9d93b1dd3388af6209a4223befe40f~CfI_DoopR2729127291epcas5p3U;
        Mon, 20 Dec 2021 14:22:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211220142250epsmtrp1113649aa5e250daf85cb0c63572a168d~CfI_CyWgt2445924459epsmtrp1k;
        Mon, 20 Dec 2021 14:22:50 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-d6-61c1427c8508
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.85.29871.9B190C16; Mon, 20 Dec 2021 23:22:49 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142248epsmtip179e780c785e738f6bd68b52ce146b0ee~CfI8cl9-X0040100401epsmtip1k;
        Mon, 20 Dec 2021 14:22:48 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
Subject: [RFC 11/13] nvme: enable bio-cache for fixed-buffer passthru
Date:   Mon, 20 Dec 2021 19:47:32 +0530
Message-Id: <20211220141734.12206-12-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmpm6N08FEg6Mf+CyaJvxltlh9t5/N
        YuXqo0wW71rPsVh0nr7AZHH+7WEmi0mHrjFa7L2lbTF/2VN2izU3n7I4cHnsnHWX3aN5wR0W
        j8tnSz02repk89i8pN5j980GNo++LasYPT5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53
        jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
        q5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnfFvjXHBNNWK2XdeMDYw7pLrYuTkkBAw
        kTgx6xkjiC0ksJtR4uXJvC5GLiD7E6NEU9suZgjnG6PE02nr2WE6mvqXskMk9jJKXHq5lhXC
        +cwo8X7/RKBZHBxsApoSFyaXgjSICERLXHh+jQ3EZhboYJTY2W0LYgsLuErMeredGcRmEVCV
        2P3kHtgZvAKWEif/vGeDWCYvMfPSd7DFnEDxw7OXsUHUCEqcnPmEBWKmvETz1tlgl0oI9HJI
        3FrfCXWpi8SkU9uYIWxhiVfHt0DFpSRe9rdB2cUSv+4chWoGOu56w0wWiIS9xMU9f5lAnmEG
        emb9Ln2IsKzE1FPrmCAW80n0/n7CBBHnldgxD8ZWlLg36SkrhC0u8XDGEijbQ2L13LnQkOth
        lNiw4QT7BEaFWUgemoXkoVkIqxcwMq9ilEwtKM5NTy02LTDMSy2HR3Jyfu4mRnCi1fLcwXj3
        wQe9Q4xMHIyHGCU4mJVEeLfM3p8oxJuSWFmVWpQfX1Sak1p8iNEUGOITmaVEk/OBqT6vJN7Q
        xNLAxMzMzMTS2MxQSZz3dPqGRCGB9MSS1OzU1ILUIpg+Jg5OqQam4omSV+vvfr3qKJy0bFVj
        6n5ulg+fF216b5QbcvzK3xmeB/jd1v7cZNgUHnMyvNym18/wodGu7nfl79ebfcwrqLgzwa+d
        9d63Bs/OKV/esoWdlt2T1e7gGLci2H754nNLfzS9t0uOst+8LSfTr3jSH7/Lezg/H/FyMrDj
        Xu2fpBHAUfRy+Z/qk+mGF/66fNx3k3Xzui4jy3P8u2QF7CxZkk4qZXLf9upnSFhbL/vBbuYG
        h2SzXJtX6Qszw3YlVC7Ucrgkl7Ds9Ke5Gz8sOn/m2oWtOQ9VaxYr8NeqHz4dOjt6/fPcdgN9
        of03ufZcP3cyMmSfJc961uuvdq/aVvjSe/HhvddVX+RbJzy6EPaHRYmlOCPRUIu5qDgRACPm
        GE49BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnO7OiQcSDR7ttLZomvCX2WL13X42
        i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLdbcfMriwOWxc9Zddo/mBXdY
        PC6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoEr498a44JpqhWz
        77xgbGDcJdfFyMkhIWAi0dS/lL2LkYtDSGA3o8TtpufMEAlxieZrP9ghbGGJlf+eQxV9ZJTY
        OHEmUBEHB5uApsSFyaUgNSICsRIffh1jAqlhFpjEKLGh/wFYs7CAq8Ssd9vBhrIIqErsfnKP
        EcTmFbCUOPnnPRvEAnmJmZe+g9VzAsUPz14GFhcSsJA48eELC0S9oMTJmU/AbGag+uats5kn
        MArMQpKahSS1gJFpFaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcCxoae5g3L7qg94h
        RiYOxkOMEhzMSiK8W2bvTxTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampB
        ahFMlomDU6qBifd1QvDbnX1Xbet8jtT/knmV+MzENN6S8XKmdgTvg/JPHpWXiyTSIo47mO8s
        WHiC1W1zlGuKhOfGOTf2hxQaB99efPTAu2UinQunrt1Rtye7ZXf1pNAz8xlSil983FyddL35
        wsvdH/onySounxl0Yw+He/vNkBc1emJFhqtueYt7FR+4ve2zz+X9W12uhtpx233Z+lR2rsAC
        ruqGhlZt9csfM3p2FNYyvV6aPs9tTbqpV6v3+37fskDVranlXl/Pmudni0XMPnD37xHOnJzz
        zS8jH7htflE/ycJd8oeE4L1HGZatUuyn90+9lWVZv27SpNYXS7PnP7LxObjr6LWwp0XcnWJs
        uopRO469KfsnrMRSnJFoqMVcVJwIAMB0OKD0AgAA
X-CMS-MailID: 20211220142250epcas5p34b9d93b1dd3388af6209a4223befe40f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211220142250epcas5p34b9d93b1dd3388af6209a4223befe40f
References: <20211220141734.12206-1-joshi.k@samsung.com>
        <CGME20211220142250epcas5p34b9d93b1dd3388af6209a4223befe40f@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since we do submission/completion in task, we can have this up.
Add a bio-set for nvme as we need that for bio-cache.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-map.c           | 4 ++--
 drivers/nvme/host/core.c  | 9 +++++++++
 drivers/nvme/host/ioctl.c | 6 ++++--
 drivers/nvme/host/nvme.h  | 1 +
 include/linux/blk-mq.h    | 2 +-
 5 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 9aa9864eab55..e3e28b628fba 100644
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
index bce2e93d14a3..0c231946a310 100644
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
@@ -4793,6 +4796,11 @@ static int __init nvme_core_init(void)
 		goto unregister_generic_ns;
 	}
 
+	result = bioset_init(&nvme_bio_pool, NVME_BIO_POOL_SZ, 0,
+			BIOSET_NEED_BVECS | BIOSET_PERCPU_CACHE);
+	if (result < 0)
+		goto unregister_generic_ns;
+
 	return 0;
 
 unregister_generic_ns:
@@ -4815,6 +4823,7 @@ static int __init nvme_core_init(void)
 
 static void __exit nvme_core_exit(void)
 {
+	bioset_exit(&nvme_bio_pool);
 	class_destroy(nvme_ns_chr_class);
 	class_destroy(nvme_subsys_class);
 	class_destroy(nvme_class);
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index dc6a5f1b81ca..013ff9baa78e 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -43,6 +43,7 @@ static void nvme_pt_task_cb(struct io_uring_cmd *ioucmd)
 	struct request *req = cmd->req;
 	int status;
 	u64 result;
+	struct bio *bio = req->bio;
 
 	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
 		status = -EINTR;
@@ -52,6 +53,7 @@ static void nvme_pt_task_cb(struct io_uring_cmd *ioucmd)
 
 	/* we can free request */
 	blk_mq_free_request(req);
+	blk_rq_unmap_user(bio);
 
 	if (cmd->meta) {
 		if (status)
@@ -73,9 +75,9 @@ static void nvme_end_async_pt(struct request *req, blk_status_t err)
 	struct bio *bio = cmd->bio;
 
 	cmd->req = req;
+	req->bio = bio;
 	/* this takes care of setting up task-work */
 	io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);
-	blk_rq_unmap_user(bio);
 }
 
 static void nvme_setup_uring_cmd_data(struct request *rq,
@@ -164,7 +166,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 					bufflen, GFP_KERNEL);
 		else
 			ret = blk_rq_map_user_fixedb(q, req, ubuffer, bufflen,
-					GFP_KERNEL, ioucmd);
+					&nvme_bio_pool, ioucmd);
 		if (ret)
 			goto out;
 		bio = req->bio;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 9a901b954a87..6bbb8ed868eb 100644
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
index a82b054eebde..e35a5d835b1f 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -923,7 +923,7 @@ struct rq_map_data {
 int blk_rq_map_user(struct request_queue *, struct request *,
 		struct rq_map_data *, void __user *, unsigned long, gfp_t);
 int blk_rq_map_user_fixedb(struct request_queue *, struct request *,
-		     u64 ubuf, unsigned long, gfp_t,
+		     u64 ubuf, unsigned long, struct bio_set *,
 		     struct io_uring_cmd *);
 int blk_rq_map_user_iov(struct request_queue *, struct request *,
 		struct rq_map_data *, const struct iov_iter *, gfp_t);
-- 
2.25.1

