Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1216522C56
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 08:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiEKGbj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 02:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbiEKGbh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 02:31:37 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C923AA4F
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 23:31:35 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220511063133epoutp021625bfec74838a7667d4d67f028ce783~t_UCMoPvS1693716937epoutp02x
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:31:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220511063133epoutp021625bfec74838a7667d4d67f028ce783~t_UCMoPvS1693716937epoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652250693;
        bh=9j08cCPemrzGiCoWRtxXZMjoyosg+XCO7H9PoRY3DYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLKuyhg/h+jS+KG9Lm1kuvOA8uU7fPTpVMwxBPDlukepXt5sZ9bb2a+3hSuIpvDbC
         JvpjQv10OuYIQzS4aKkWJBvvIFyvlKlqpVJHnPd3uG2dlGxM18cOg2crdnDJVZH7DM
         WmiFu/C6oI8gkW3+St5dxctZXZARo06CbBR/Q3kQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220511063133epcas5p3135ee9d8946eac883e77fa3b528c1b93~t_UBpSwtG2700427004epcas5p3I;
        Wed, 11 May 2022 06:31:33 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KylRj0GKQz4x9Pw; Wed, 11 May
        2022 06:31:29 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.76.09827.B385B726; Wed, 11 May 2022 15:31:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220511055312epcas5p3b1e9989a32cb1a79f8a941476fc433d1~t9yi44pF50985109851epcas5p3B;
        Wed, 11 May 2022 05:53:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220511055312epsmtrp1bfdd183ef9515e6b762faa1b9269f79c~t9yi3nGuP0128601286epsmtrp1y;
        Wed, 11 May 2022 05:53:12 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-7b-627b583bcad7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E6.28.11276.84F4B726; Wed, 11 May 2022 14:53:12 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220511055310epsmtip147bdaa48f6f2778323e8f4679fa6daf3~t9yhIsZTn2613326133epsmtip18;
        Wed, 11 May 2022 05:53:10 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: [PATCH v5 3/6] nvme: refactor nvme_submit_user_cmd()
Date:   Wed, 11 May 2022 11:17:47 +0530
Message-Id: <20220511054750.20432-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511054750.20432-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJsWRmVeSWpSXmKPExsWy7bCmpq51RHWSwampuhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ8zumMVccFqiYtWL
        +gbGb8JdjBwcEgImEi+/uXUxcnEICexmlFh2aSc7hPOJUeLxuXNMXYycQM43RonjZ8JAbJCG
        RS+PsEEU7WWUuPxyPyuE85lRYsPBZ2wgY9kENCUuTC4FaRARkJf4cnstC0gNs8BZRolptw6x
        giSEBWwlXi8/wgJSzyKgKtG1IwckzCtgIfHw0G5GiGXyEjMvfWcHsTkFLCW2bJ7HDlEjKHFy
        5hMWEJsZqKZ562xmkPkSAgs5JM7e+MsE0ewi8btlCdQgYYlXx7ewQ9hSEi/726DsZInW7ZfZ
        IUFRIrFkgTpE2F7i4h6QMRxA8zUl1u/ShwjLSkw9tY4JYi2fRO/vJ1CbeCV2zIOxFSXuTXrK
        CmGLSzycsQTK9pCYd2QZNKh6GCV2rz7DNIFRYRaSd2YheWcWwuoFjMyrGCVTC4pz01OLTQuM
        8lLL4TGcnJ+7iRGceLW8djA+fPBB7xAjEwfjIUYJDmYlEd79fRVJQrwpiZVVqUX58UWlOanF
        hxhNgcE9kVlKNDkfmPrzSuINTSwNTMzMzEwsjc0MlcR5T6dvSBQSSE8sSc1OTS1ILYLpY+Lg
        lGpgWher8vsgX/yaG9KLhL66nODd69svnzuDpXHF4/fOT98evXq3x/8ec7r/7vhs3f1uO2KL
        BAWyX3bbsujl31w8V0zQ8OZUw6lsHBs/SM5Uc1t7VVFyRkWGq9gNefMnkhmbV6+ynvVScKuy
        HWP8K/NwD9NP8Y8e+NWta1rqnrVQ8sSEPQJP9Bn1Nx3vCl5akWFw1KN67ucQ8XNLyz+VbNpg
        furwjoXHz/dp7NbJrP97Skv96Ot/kzUaZ+4XmDNlh3Bx5EfdN1XBX/K3P/okOT3o1stHHfbV
        5f+f6nWtOays7bCgtX6fpsi5dbUzMhYZf7S96HCKUcT5mOfCCUuMUqo1invlI7Q/981cuuyu
        ubvTPCWW4oxEQy3mouJEAKG5VLhFBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSnK6Hf3WSQWuvrEXThL/MFnNWbWO0
        WH23n83i5oGdTBYrVx9lsnjXeo7F4vzbw0wW85c9Zbe4MeEpo8Whyc1MFldfHmB34PaY2PyO
        3WPnrLvsHpfPlnpsWtXJ5rF5Sb3H7psNbB7v911l8+jbsorR4/MmuQDOKC6blNSczLLUIn27
        BK6M2R2zmAtOS1SselHfwPhNuIuRk0NCwERi0csjbF2MXBxCArsZJfZfu8MCkRCXaL72gx3C
        FpZY+e85O0TRR0aJqQv/MXcxcnCwCWhKXJhcClIjIqAosfFjEyNIDbPATUaJx63XmEESwgK2
        Eq+XH2EBqWcRUJXo2pEDEuYVsJB4eGg3I8R8eYmZl76D7eIUsJTYsnkemC0EVHN0yUQ2iHpB
        iZMzn4DdxgxU37x1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P
        3cQIjg8tzR2M21d90DvEyMTBeIhRgoNZSYR3f19FkhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe
        C10n44UE0hNLUrNTUwtSi2CyTBycUg1MZ3cfzH238dfHysMrpC+/uOW4onxe8zOT2lmmPLkr
        by3euLuoICMm0fth/tozTcue3b0gKSUY/oPVf+aNJ2yTNl4WVzLYY/OUf/9j69eSxxQ4ftoy
        fvL3mNxiPmduRSKjtGXy1uDU+eWPzeQX6Vo6bLRIcT32s9A4plM3RvNZp2hWKlvBep4gBhG3
        97WfF7z7pRcloXw+Qzfquo7iNQGReuFm1VN6cQX/Vr5IV46V+cYgvnjz5FVbph0Ta+jkrb+y
        t37VTNf8tP6vhe+OfO7f+PePrt2kAk2rdrFq9+8FFvyFR3nWX1ulumC+0ntD5YOveHw+pX/8
        6eSwO7PBVHflqfQHcpOeXJKdaaMXxP1SiaU4I9FQi7moOBEAry4ggv4CAAA=
X-CMS-MailID: 20220511055312epcas5p3b1e9989a32cb1a79f8a941476fc433d1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511055312epcas5p3b1e9989a32cb1a79f8a941476fc433d1
References: <20220511054750.20432-1-joshi.k@samsung.com>
        <CGME20220511055312epcas5p3b1e9989a32cb1a79f8a941476fc433d1@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Divide the work into two helpers, namely nvme_alloc_user_request and
nvme_execute_user_rq. This is a prep patch, to help wiring up
uring-cmd support in nvme.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[axboe: fold in fix for assuming bio is non-NULL]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/host/ioctl.c | 56 +++++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 554566371ffa..8d2569b656cc 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -53,10 +53,20 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	return ERR_PTR(ret);
 }
 
-static int nvme_submit_user_cmd(struct request_queue *q,
+static int nvme_finish_user_metadata(struct request *req, void __user *ubuf,
+		void *meta, unsigned len, int ret)
+{
+	if (!ret && req_op(req) == REQ_OP_DRV_IN &&
+	    copy_to_user(ubuf, meta, len))
+		ret = -EFAULT;
+	kfree(meta);
+	return ret;
+}
+
+static struct request *nvme_alloc_user_request(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
+		u32 meta_seed, void **metap, unsigned timeout, bool vec)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -68,7 +78,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 
 	req = blk_mq_alloc_request(q, nvme_req_op(cmd), 0);
 	if (IS_ERR(req))
-		return PTR_ERR(req);
+		return req;
 	nvme_init_request(req, cmd);
 
 	if (timeout)
@@ -105,26 +115,50 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 				goto out_unmap;
 			}
 			req->cmd_flags |= REQ_INTEGRITY;
+			*metap = meta;
 		}
 	}
 
+	return req;
+
+out_unmap:
+	if (bio)
+		blk_rq_unmap_user(bio);
+out:
+	blk_mq_free_request(req);
+	return ERR_PTR(ret);
+}
+
+static int nvme_submit_user_cmd(struct request_queue *q,
+		struct nvme_command *cmd, void __user *ubuffer,
+		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
+		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
+{
+	struct request *req;
+	void *meta = NULL;
+	struct bio *bio;
+	int ret;
+
+	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
+			meta_len, meta_seed, &meta, timeout, vec);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	bio = req->bio;
+
 	ret = nvme_execute_passthru_rq(req);
+
 	if (result)
 		*result = le64_to_cpu(nvme_req(req)->result.u64);
-	if (meta && !ret && !write) {
-		if (copy_to_user(meta_buffer, meta, meta_len))
-			ret = -EFAULT;
-	}
-	kfree(meta);
- out_unmap:
+	if (meta)
+		ret = nvme_finish_user_metadata(req, meta_buffer, meta,
+						meta_len, ret);
 	if (bio)
 		blk_rq_unmap_user(bio);
- out:
 	blk_mq_free_request(req);
 	return ret;
 }
 
-
 static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 {
 	struct nvme_user_io io;
-- 
2.25.1

