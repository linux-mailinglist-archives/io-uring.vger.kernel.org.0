Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55395ECB9B
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 19:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbiI0Rte (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 13:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbiI0RtE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 13:49:04 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8CB99B50
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 10:46:48 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220927174646epoutp0109fdff1ddfe84c773b5a6a7330ad32c3~YyMQal8Tx2137021370epoutp01H
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 17:46:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220927174646epoutp0109fdff1ddfe84c773b5a6a7330ad32c3~YyMQal8Tx2137021370epoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664300806;
        bh=Z0IC8FwLh8tvDC+rBID68Mm7U2jdtPbcK+YXwZu6xLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3IwtXmwNznnQ7HSZ3rDWEx2OIdpNpiyUT3cD0cJ9oaWYHgyzuGWpwQwoq8XPwuue
         sV2giXPCCy1T9c1FFPKbBhLeJctWAZqEi8H8sAVOE5CMS+Yd5LHOKDWLjsNafs/prZ
         LHfKKvUihEwtcv3R3lQdHc6CfdXPPyu2hqCGXATI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220927174645epcas5p1368eef0b8fa5cb698e607ecdd6e8ccb8~YyMPN8soi3009630096epcas5p17;
        Tue, 27 Sep 2022 17:46:45 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4McRrg1Bgsz4x9Pw; Tue, 27 Sep
        2022 17:46:43 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C6.1F.39477.30733336; Wed, 28 Sep 2022 02:46:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220927174642epcas5p1dafa31776d4eb8180e18f149ed25640c~YyMMUtgTU2244622446epcas5p1X;
        Tue, 27 Sep 2022 17:46:42 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220927174642epsmtrp1e3f38800bdd1cbac135396634c8e3c75~YyMMUBdlS2108921089epsmtrp1Q;
        Tue, 27 Sep 2022 17:46:42 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-a7-633337037fea
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.86.18644.20733336; Wed, 28 Sep 2022 02:46:42 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220927174641epsmtip1156eddfe38c69c571429239d9c4c8946~YyMLA_T640699206992epsmtip1W;
        Tue, 27 Sep 2022 17:46:40 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v10 7/7] nvme: wire up fixed buffer support for
 nvme passthrough
Date:   Tue, 27 Sep 2022 23:06:10 +0530
Message-Id: <20220927173610.7794-8-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220927173610.7794-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZdlhTS5fZ3DjZYHU7u8Xqu/1sFjcP7GSy
        WLn6KJPFu9ZzLBZH/79ls5h06Bqjxd5b2hbzlz1ld+DwuHy21GPTqk42j81L6j1232xg8+jb
        sorR4/MmuQC2qGybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58A
        XbfMHKBrlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFJgV6xYm5xaV56Xp5qSVW
        hgYGRqZAhQnZGdN+Rxe0qlV0PP/D2MD4Q66LkZNDQsBEYsWnp2xdjFwcQgK7GSV+rfrOBOF8
        YpS4fn4VK4TzmVHiRdsedpiW7xuWMYPYQgK7GCXuTwiHK1rf9Jyxi5GDg01AU+LC5FKQGhEB
        I4n9n06CDWIWmMEosbrjNTtIjbBAtMT5k5EgNSwCqhIL1lxkAgnzCphLnJ3BDbFKXmLmpe9g
        1ZwCFhKHP2aChHkFBCVOznzCAmIzA5U0b53NDDJdQuAru8Skee8YIXpdJE7+u8gMYQtLvDq+
        Bep8KYmX/W1QdrLEpZnnmCDsEonHew5C2fYSraf6mUH2MgN9sn6XPsQuPone30/ArpQQ4JXo
        aBOCqFaUuDfpKSuELS7xcMYSKNtDovX7U3ZI4HQzSvRdXso2gVF+FpIXZiF5YRbCtgWMzKsY
        JVMLinPTU4tNC4zyUsvhkZqcn7uJEZwgtbx2MD588EHvECMTB+MhRgkOZiUR3t9HDZOFeFMS
        K6tSi/Lji0pzUosPMZoCQ3gis5Rocj4wReeVxBuaWBqYmJmZmVgamxkqifMunqGVLCSQnliS
        mp2aWpBaBNPHxMEp1cC0uGGqreTlL5Kf/5Y+Ypsn72bxSuLXpMX/DJacl9kf0G7G8Zgp8oKw
        SexnuZkFNjpLMwwOF2xtF2OojJv5P/cZ46uMaWwCOkeU+YuWnvATPPZrydrS2OPLEm6IbymK
        t7+hsFbWv0x02urLHokan7WaZvBNyrmhe8mlz21ub/S97CyeGRXsyRlPXDk+ygTt+XPtJ6P7
        sVm2uyawsdRwGteL/T/0+2Du3TvqUacX6KdZ3xGedmFjfIShqrsRU3+ma64mc1r0f/3MzIDK
        a//vZ+xkMm5X5z4avLcvm+31/+cB7jY69x4d5Lwjy8g/tTBiW8GF3YtSlWXKVXVWsM67d4Dj
        m8S6/iaZLVPd+ja07FRiKc5INNRiLipOBAAKRBQiGQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSnC6TuXGywdMFkhar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorhsUlJzMstSi/TtErgypv2OLmhVq+h4/oexgfGHXBcjJ4eEgInE9w3LmLsY
        uTiEBHYwSpyZvpkRIiEu0XztBzuELSyx8t9zMFtI4COjxIytwl2MHBxsApoSFyaXgoRFBMwk
        lh5ewwIyh1lgDqPE5ct72EFqhAUiJb4vqAWpYRFQlViw5iITSJhXwFzi7AxuiOnyEjMvfQer
        5hSwkDj8MRNikbnE1k0fWEBsXgFBiZMzn4DZzEDlzVtnM09gFJiFJDULSWoBI9MqRsnUguLc
        9NxiwwKjvNRyveLE3OLSvHS95PzcTYzg0NbS2sG4Z9UHvUOMTByMhxglOJiVRHh/HzVMFuJN
        SaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoEpuvXAsk+yKR8+
        JXh/KDGqNd32w2TO0Y+lhWcc1rmZt7le2HqP7XCe2W4Bdp5GRcc0+UbW2D+mHoW/H27ubsvM
        VOiQXrlQ6KSD/JTL3rEWn/+whi44IxmZxDo3bWW/guHeU0dErPOqGJes4zr1vEBa1NCUN3//
        h9jcg9XqWy4VfErr0cl9JGjM+zjHxNe9fWK5f9Ou6HdbNL/IxPMaq/0ye8q3JeAM/0PBY1/X
        3PXOfnNnzWe2zYeLPzVtfmtt6ff4u6dZZUyTQkXdItNZ1b9t9vS6rFqqmMRne1lpU9YGxyRr
        p8x3m7Q0zbaVc1/P51m9rqT52q3DhZlGr6OMZU5u3H/u3K01FyvmBV0rVVFiKc5INNRiLipO
        BAD+Fksh3AIAAA==
X-CMS-MailID: 20220927174642epcas5p1dafa31776d4eb8180e18f149ed25640c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220927174642epcas5p1dafa31776d4eb8180e18f149ed25640c
References: <20220927173610.7794-1-joshi.k@samsung.com>
        <CGME20220927174642epcas5p1dafa31776d4eb8180e18f149ed25640c@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

if io_uring sends passthrough command with IORING_URING_CMD_FIXED flag,
use the pre-registered buffer for IO (non-vectored variant). Pass the
buffer/length to io_uring and get the bvec iterator for the range. Next,
pass this bvec to block-layer and obtain a bio/request for subsequent
processing.
While at it, modify nvme_submit_user_cmd to take ubuffer as plain integer
argument, and do away with nvme_to_user_ptr conversion in callers.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 44 +++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index b9f17dc87de9..1a45246f0d7a 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -83,9 +83,10 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 	return req;
 }
 
-static int nvme_map_user_request(struct request *req, void __user *ubuffer,
+static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, void **metap, bool vec)
+		u32 meta_seed, void **metap, struct io_uring_cmd *ioucmd,
+		bool vec)
 {
 	struct request_queue *q = req->q;
 	struct nvme_ns *ns = q->queuedata;
@@ -93,23 +94,34 @@ static int nvme_map_user_request(struct request *req, void __user *ubuffer,
 	struct bio *bio = NULL;
 	void *meta = NULL;
 	int ret;
+	bool fixedbufs = ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED);
 
-	if (!vec)
-		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-			GFP_KERNEL);
-	else {
+	if (vec) {
 		struct iovec fast_iov[UIO_FASTIOV];
 		struct iovec *iov = fast_iov;
 		struct iov_iter iter;
 
-		ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
-				UIO_FASTIOV, &iov, &iter);
+		/* fixedbufs is only for non-vectored io */
+		WARN_ON_ONCE(fixedbufs);
+		ret = import_iovec(rq_data_dir(req), nvme_to_user_ptr(ubuffer),
+				bufflen, UIO_FASTIOV, &iov, &iter);
 		if (ret < 0)
 			goto out;
 
 		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
 		kfree(iov);
-	}
+	} else if (fixedbufs) {
+		struct iov_iter iter;
+
+		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
+				rq_data_dir(req), &iter, ioucmd);
+		if (ret < 0)
+			goto out;
+		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
+	} else
+		ret = blk_rq_map_user(q, req, NULL,
+					nvme_to_user_ptr(ubuffer), bufflen,
+					GFP_KERNEL);
 	if (ret)
 		goto out;
 	bio = req->bio;
@@ -136,7 +148,7 @@ static int nvme_map_user_request(struct request *req, void __user *ubuffer,
 }
 
 static int nvme_submit_user_cmd(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
 {
@@ -152,7 +164,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	req->timeout = timeout;
 	if (ubuffer && bufflen) {
 		ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
-				meta_len, meta_seed, &meta, vec);
+				meta_len, meta_seed, &meta, NULL, vec);
 		if (ret)
 			goto out;
 	}
@@ -231,7 +243,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.appmask = cpu_to_le16(io.appmask);
 
 	return nvme_submit_user_cmd(ns->queue, &c,
-			nvme_to_user_ptr(io.addr), length,
+			io.addr, length,
 			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
 			false);
 }
@@ -285,7 +297,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &result, timeout, false);
 
@@ -331,7 +343,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &cmd.result, timeout, vec);
 
@@ -475,9 +487,9 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	req->timeout = d.timeout_ms ? msecs_to_jiffies(d.timeout_ms) : 0;
 
 	if (d.addr && d.data_len) {
-		ret = nvme_map_user_request(req, nvme_to_user_ptr(d.addr),
+		ret = nvme_map_user_request(req, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
-			d.metadata_len, 0, &meta, vec);
+			d.metadata_len, 0, &meta, ioucmd, vec);
 		if (ret)
 			goto out_err;
 	}
-- 
2.25.1

