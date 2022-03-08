Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8824D1C03
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347926AbiCHPnL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244230AbiCHPnK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:43:10 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7509E4EF4F
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:42:13 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220308154211epoutp03843adc33f1293a7d33f62e9a3feba0a1~acihwvI7w2455624556epoutp03D
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:42:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220308154211epoutp03843adc33f1293a7d33f62e9a3feba0a1~acihwvI7w2455624556epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754131;
        bh=+Gw3S7EpbsROEHcqCLKFsIh2z7rntifub50Jlm8CLsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMsa5Y0HhBZci8W2AiAmKkJZ2fM9vv4JWn1P7By9t9X/DYNX6Izvn3TGvaZ5fxctl
         9eK98gYSqdP+tz0dFhPRFFHzNMTeLbLFRWKdQYNLsaocXZlQhY5y5x3rSaa8uwzGsZ
         f4KDrdRV4LwDewmvIlFsBfIotW9sWSF306oY+zPA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220308154211epcas5p2895be8485a317815417f0aca54971c63~acihDmOBN3013030130epcas5p2E;
        Tue,  8 Mar 2022 15:42:11 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KCfhZ4Bk1z4x9Pt; Tue,  8 Mar
        2022 15:42:06 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.57.06423.E4977226; Wed,  9 Mar 2022 00:42:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220308152700epcas5p4130d20119a3a250a2515217d6552f668~acVQ_6hVA0648306483epcas5p4C;
        Tue,  8 Mar 2022 15:27:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220308152700epsmtrp1f92bca6e505e95dcbfe04f8e92e04356~acVQ_BlwD0125001250epsmtrp1O;
        Tue,  8 Mar 2022 15:27:00 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-d2-6227794e1152
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        15.51.29871.4C577226; Wed,  9 Mar 2022 00:27:00 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152658epsmtip1ff873fbf2c626628b6a5c1f7dc1c8700~acVO4fKK11072310723epsmtip1p;
        Tue,  8 Mar 2022 15:26:58 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 04/17] nvme: modify nvme_alloc_request to take an additional
 parameter
Date:   Tue,  8 Mar 2022 20:50:52 +0530
Message-Id: <20220308152105.309618-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmuq5fpXqSwbJFChbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
        ycUnQNctMwfoByWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpe
        XmqJlaGBgZEpUGFCdsapae9ZCqYpVew/OZetgfGSTBcjJ4eEgInEuRcLmbsYuTiEBHYzSuxb
        PYMVJCEk8IlRYuaeUojEN0aJ3gnfWWE61rYfYYJI7GWUeHv1JQuE85lR4vrTDUAOBwebgKbE
        hcmlIA0iAl4S92+/ZwWpYRboYpJ4u+8+G0hCWCBCYs6JTnYQm0VAVeL7i5VgvbwClhK71qtC
        LJOXmHnpO1gJp4CVxM9bW8GO4BUQlDg58wkLiM0MVNO8dTbYCxICJzgkLi28ygLR7CLxt/MV
        E4QtLPHq+BZ2CFtK4mV/G5RdLPHrzlGo5g6gBxpmQjXbS1zc85cJ5CBmoGfW79KHCMtKTD21
        jgliMZ9E7+8nUPN5JXbMg7EVJe5NegoNLXGJhzOWQNkeEjv+32aHBFYvo8SfKQeYJzAqzELy
        0CwkD81CWL2AkXkVo2RqQXFuemqxaYFhXmo5PJaT83M3MYLTtZbnDsa7Dz7oHWJk4mA8xCjB
        wawkwnv/vEqSEG9KYmVValF+fFFpTmrxIUZTYIBPZJYSTc4HZoy8knhDE0sDEzMzMxNLYzND
        JXHe0+kbEoUE0hNLUrNTUwtSi2D6mDg4pRqYGrT/vVFc5PtgpfS5+4zG/qpzelOK/5yUe1iZ
        5V2jseuikfG6i+8X5qzgPnjsKfPj36Vrzj8//04yuI9LZ6Nu2OKsS13CqfpPZqcIKoRvS32T
        +WVTa7iTgpLt1iuimg9XzJ595aC3zlK2I7GChpO8sudP1wz7dCzZc94OO4dl9bc/zTS+4mH3
        KPrCuYX36sPvbTTsCk4s8g8OnmB+8dfpKSptJ6pCvF99tY787vZ2/blVN3LaJXPn8tk4JL42
        usc9nzvHx1uK897Cnh02L/pOzczVDGo7yDizcHtS3KSk3TGfd3xtZi9hds45oWb76FhYfVfn
        GhFJ8VcCU7Y9mZJYwdm4yiP+qeCXvLfXDqxSUGIpzkg01GIuKk4EAK+jZgJgBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJTvdIqXqSwf8uPovphxUtmib8ZbaY
        s2obo8Xqu/1sFitXH2WyeNd6jsWi8/QFJovzbw8zWUw6dI3RYu8tbYv5y56yWyxpPc5mcWPC
        U0aLNTefslh8PjOP1YHf49nVZ4weO2fdZfdoXnCHxePy2VKPTas62Tw2L6n32H2zgc1j2+KX
        rB59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CVcWrae5aCaUoV+0/OZWtgvCTTxcjJISFgIrG2
        /QhTFyMXh5DAbkaJzQdfs0MkxCWar/2AsoUlVv57zg5R9JFRontyC2MXIwcHm4CmxIXJpSA1
        IgIBEgcbL4PVMAvMYJLoaf7MApIQFgiT2PRhKjOIzSKgKvH9xUoWkF5eAUuJXetVIebLS8y8
        9B1sF6eAlcTPW1tZQWwhoJIV636zgdi8AoISJ2c+ARvJDFTfvHU28wRGgVlIUrOQpBYwMq1i
        lEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAiOJy3NHYzbV33QO8TIxMF4iFGCg1lJhPf+
        eZUkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODilGphstOL7
        xRU0fjYWG8nY7PSuFo+WEqiLP6W8g+nmlEWnpzF3Nc5T/CVuX2N2Q/biHLZF7DVtzpvl52zd
        fWvtslYdlZ23tJsZbf24rFwPMAnKWvz/zfx5W8se1VUaycZsDY/+PC7PCJD4+/Hc87MrZ016
        NOmCbMQTa77F9ToxdZ6XIxOZnk+2UXKTzf3avFhZcH9RRrPf2aqc3PBJCu3JOn7T+773yEUt
        u7GE/eVx640e0tlemU4Sf74e+ON1t87+3GGvrK1PPX0fPxW9MTdjztoUMfFDi+dNmRIruslj
        77R5s/0YL/zQ2Gce+02C7cbuhG8mW1JMXupeKQnqfVZy6rXGyUOvK+JKPth5PZkurqzEUpyR
        aKjFXFScCAC/ZVvRFgMAAA==
X-CMS-MailID: 20220308152700epcas5p4130d20119a3a250a2515217d6552f668
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152700epcas5p4130d20119a3a250a2515217d6552f668
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152700epcas5p4130d20119a3a250a2515217d6552f668@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

This is a prep patch. It modifies nvme_alloc_request to take an
additional parameter, allowing request flags to be passed.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/core.c       | 10 ++++++----
 drivers/nvme/host/ioctl.c      |  2 +-
 drivers/nvme/host/nvme.h       |  3 ++-
 drivers/nvme/host/pci.c        |  4 ++--
 drivers/nvme/target/passthru.c |  2 +-
 5 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 961a5f8a44d2..159944499c4f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -630,11 +630,13 @@ static inline void nvme_init_request(struct request *req,
 }
 
 struct request *nvme_alloc_request(struct request_queue *q,
-		struct nvme_command *cmd, blk_mq_req_flags_t flags)
+		struct nvme_command *cmd, blk_mq_req_flags_t flags,
+		unsigned int rq_flags)
 {
+	unsigned int cmd_flags = nvme_req_op(cmd) | rq_flags;
 	struct request *req;
 
-	req = blk_mq_alloc_request(q, nvme_req_op(cmd), flags);
+	req = blk_mq_alloc_request(q, cmd_flags, flags);
 	if (!IS_ERR(req))
 		nvme_init_request(req, cmd);
 	return req;
@@ -1075,7 +1077,7 @@ int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 	int ret;
 
 	if (qid == NVME_QID_ANY)
-		req = nvme_alloc_request(q, cmd, flags);
+		req = nvme_alloc_request(q, cmd, flags, 0);
 	else
 		req = nvme_alloc_request_qid(q, cmd, flags, qid);
 	if (IS_ERR(req))
@@ -1271,7 +1273,7 @@ static void nvme_keep_alive_work(struct work_struct *work)
 	}
 
 	rq = nvme_alloc_request(ctrl->admin_q, &ctrl->ka_cmd,
-				BLK_MQ_REQ_RESERVED | BLK_MQ_REQ_NOWAIT);
+				BLK_MQ_REQ_RESERVED | BLK_MQ_REQ_NOWAIT, 0);
 	if (IS_ERR(rq)) {
 		/* allocation failure, reset the controller */
 		dev_err(ctrl->device, "keep-alive failed: %ld\n", PTR_ERR(rq));
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 22314962842d..5c9cd9695519 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -66,7 +66,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	void *meta = NULL;
 	int ret;
 
-	req = nvme_alloc_request(q, cmd, 0);
+	req = nvme_alloc_request(q, cmd, 0, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index a162f6c6da6e..b32f4e2c68fd 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -698,7 +698,8 @@ void nvme_start_freeze(struct nvme_ctrl *ctrl);
 
 #define NVME_QID_ANY -1
 struct request *nvme_alloc_request(struct request_queue *q,
-		struct nvme_command *cmd, blk_mq_req_flags_t flags);
+		struct nvme_command *cmd, blk_mq_req_flags_t flags,
+		unsigned int rq_flags);
 void nvme_cleanup_cmd(struct request *req);
 blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req);
 blk_status_t nvme_fail_nonready_command(struct nvme_ctrl *ctrl,
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6a99ed680915..655c26589ac3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1429,7 +1429,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 		 req->tag, nvmeq->qid);
 
 	abort_req = nvme_alloc_request(dev->ctrl.admin_q, &cmd,
-			BLK_MQ_REQ_NOWAIT);
+			BLK_MQ_REQ_NOWAIT, 0);
 	if (IS_ERR(abort_req)) {
 		atomic_inc(&dev->ctrl.abort_limit);
 		return BLK_EH_RESET_TIMER;
@@ -2475,7 +2475,7 @@ static int nvme_delete_queue(struct nvme_queue *nvmeq, u8 opcode)
 	cmd.delete_queue.opcode = opcode;
 	cmd.delete_queue.qid = cpu_to_le16(nvmeq->qid);
 
-	req = nvme_alloc_request(q, &cmd, BLK_MQ_REQ_NOWAIT);
+	req = nvme_alloc_request(q, &cmd, BLK_MQ_REQ_NOWAIT, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index 9e5b89ae29df..2a9e2fd3b137 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -253,7 +253,7 @@ static void nvmet_passthru_execute_cmd(struct nvmet_req *req)
 		timeout = nvmet_req_subsys(req)->admin_timeout;
 	}
 
-	rq = nvme_alloc_request(q, req->cmd, 0);
+	rq = nvme_alloc_request(q, req->cmd, 0, 0);
 	if (IS_ERR(rq)) {
 		status = NVME_SC_INTERNAL;
 		goto out_put_ns;
-- 
2.25.1

