Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE54E58ADBE
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 17:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241509AbiHEPzZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 11:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238648AbiHEPzI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 11:55:08 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA337E007
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 08:53:32 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220805155316epoutp040d5c7d9283eb71bcefe5079a3a624f2a~IfdBPv8un0030600306epoutp04b
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 15:53:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220805155316epoutp040d5c7d9283eb71bcefe5079a3a624f2a~IfdBPv8un0030600306epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659714796;
        bh=qxbl+D7T7pLG1KnB6mV1fU5QffkSLPLNszuu3vmJO/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbHdx7O/O7RjThXhHnEhtA/25fvttZguD96xWDGnowOQEMuF+iSjLgHXt2ong85t4
         5AVnW5LnAmKw9PsYASJK/ssQ/T+5Q5yWAmOsAtuqygTHIBUjxao346LPpHznDzagUc
         qD56sMU2enadiYPg+QZEDr7svePwKQwo7Cqy4lD8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220805155315epcas5p17e44e94a063d8e28ffbf77ed7268f871~IfdAvvIm82221822218epcas5p1y;
        Fri,  5 Aug 2022 15:53:15 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LzqrB1504z4x9Pt; Fri,  5 Aug
        2022 15:53:14 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        05.4A.09662.9EC3DE26; Sat,  6 Aug 2022 00:53:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220805155313epcas5p2d35d22831bd07ef33fbdc28bd99ae1d0~Ifc_2719A0917409174epcas5p24;
        Fri,  5 Aug 2022 15:53:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220805155313epsmtrp1f2f0d47e45eedd08b64029b060919afb~Ifc_2JopT0820308203epsmtrp1i;
        Fri,  5 Aug 2022 15:53:13 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-6a-62ed3ce93da0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        3D.FD.08802.9EC3DE26; Sat,  6 Aug 2022 00:53:13 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220805155312epsmtip267b29e932ee9955ee8efa409b2995a04~Ifc9Y8xbW1265212652epsmtip28;
        Fri,  5 Aug 2022 15:53:12 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH 4/4] nvme: wire up async polling for io passthrough commands
Date:   Fri,  5 Aug 2022 21:12:26 +0530
Message-Id: <20220805154226.155008-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220805154226.155008-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmuu4rm7dJBtM3MVs0TfjLbLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLM6/PcxksfeWtsX8ZU/ZLQ5NbmZy4PLYOesuu8fls6Ue
        m5fUe+y+2cDm8X7fVTaPvi2rGD0+b5ILYI/KtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
        1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCS
        U2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ1x+8Yc5oI+k4qtPQdZGhiPaHcxcnBICJhIXP0m
        38XIxSEksJtR4uvmHywQzidGieP3DrF1MXICOZ8ZJd49igaxQRr2/74GFd/FKHHhgihEA1BN
        /+FmJpCpbAKaEhcml4LUiAjIS3y5vRZsKLPAc0aJpt/N7CAJYQEfiab7PUwgNouAqsTuawtY
        QGxeAUuJmUuPMkIsk5eYeek7WD2ngJVE6+EtzBA1ghInZz4Bq2cGqmneOpsZZIGEQCeHxOor
        i5kgml0k/n/th7KFJV4d38IOYUtJvOxvg7KTJS7NPAdVUyLxeM9BKNteovVUPzPIM8xAz6zf
        pQ+xi0+i9/cTJkjI8Up0tAlBVCtK3Jv0lBXCFpd4OGMJlO0hMXP/fyZI+PQySmxq+8EygVF+
        FpIXZiF5YRbCtgWMzKsYJVMLinPTU4tNCwzzUsvh0Zqcn7uJEZxCtTx3MN598EHvECMTB+Mh
        RgkOZiUR3p87XicJ8aYkVlalFuXHF5XmpBYfYjQFhvFEZinR5HxgEs8riTc0sTQwMTMzM7E0
        NjNUEuf1uropSUggPbEkNTs1tSC1CKaPiYNTqoGpc/Px4A+FRx+GJvOwn10fdauM+evVyD3K
        6WbFT8/PzOa+l/G8IL1tlajkrevvnP03chms84nfsbj00y2RP2ZpxYf7w32NjAVS5usqO7Cv
        Z+9YdOTQ0b8LPY0z755pNbqVLyxy6LZvzPtJxzacqbi7y7f1oV4h4wyJhFqzouLzt0ymbfA/
        saV0dbaaMNP8CTwsyctVvuWGsLmzb3x8pIPjjnl8uuHJopXey05tjr24Yw/HAXe2IN/9K0Jk
        SsuvdqWIz3W9JfTrkreiv+HdjV5vtgkKNR6LY/jNEq6X1jhr3rNDt2LX2B9d32KTcOSX8+wZ
        0pF725o0dV5vbTy9oUni3tXpNoovzlbULF22OzpPiaU4I9FQi7moOBEAdtQlICoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWy7bCSvO5Lm7dJBpOnaVg0TfjLbLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLM6/PcxksfeWtsX8ZU/ZLQ5NbmZy4PLYOesuu8fls6Ue
        m5fUe+y+2cDm8X7fVTaPvi2rGD0+b5ILYI/isklJzcksSy3St0vgyrh9Yw5zQZ9JxdaegywN
        jEe0uxg5OSQETCT2/77G1sXIxSEksINRouvAYSaIhLhE87Uf7BC2sMTKf8/ZIYo+Mkr82rkV
        yOHgYBPQlLgwuRSkRkRAUWLjxyZGkBpmgfeMEnfm/WQGSQgL+Eg03e8BG8oioCqx+9oCFhCb
        V8BSYubSo4wQC+QlZl76DraMU8BKovXwFmaQ+UJANfPvcEGUC0qcnPkErJUZqLx562zmCYwC
        s5CkZiFJLWBkWsUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERwBWlo7GPes+qB3iJGJ
        g/EQowQHs5II788dr5OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoE
        k2Xi4JRqYBK6bdlz+/9Vt8/8UdseOoQUhJ2QPHLX5fmCLnPR8jiZrgbV3zcdLqb0N2+aorz1
        6amgWpcNM9bMuyibbnm6ZIvTsulactN3rXnwafeqn8YzKgunmf7XVlS87fVmRv7fbfbulzfw
        vBO9pZfAEuEX+GuSTligl/jNFwFqIW/q/v7bzC2UPGeJWXO/P49csfDF9tg9k8wbtzlOfnGV
        729N23vW82mT3z+o1Hb3Z17UdMiu3a/rSeuDpriFwopPTBounuL4rbuTY3maadStnqdndC5J
        MFXt8tQpYBLWD9FWdrL/kvXofHH1n57g+971QnxbF95UCtD58q9SpWqdnsLys49bJuoHJDJq
        1PqvTva7osRSnJFoqMVcVJwIAHoMtjHvAgAA
X-CMS-MailID: 20220805155313epcas5p2d35d22831bd07ef33fbdc28bd99ae1d0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220805155313epcas5p2d35d22831bd07ef33fbdc28bd99ae1d0
References: <20220805154226.155008-1-joshi.k@samsung.com>
        <CGME20220805155313epcas5p2d35d22831bd07ef33fbdc28bd99ae1d0@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Store a cookie during submission, and use that to implement
completion-polling inside the ->uring_cmd_iopoll handler.
This handler makes use of existing bio poll facility.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/core.c      |  1 +
 drivers/nvme/host/ioctl.c     | 73 ++++++++++++++++++++++++++++++++---
 drivers/nvme/host/multipath.c |  1 +
 drivers/nvme/host/nvme.h      |  2 +
 4 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2429b11eb9a8..77b6c2882afd 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3976,6 +3976,7 @@ static const struct file_operations nvme_ns_chr_fops = {
 	.unlocked_ioctl	= nvme_ns_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.uring_cmd	= nvme_ns_chr_uring_cmd,
+	.uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
 };
 
 static int nvme_add_ns_cdev(struct nvme_ns *ns)
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 27614bee7380..136f0fd25710 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -391,11 +391,19 @@ static void nvme_uring_cmd_end_io(struct request *req, blk_status_t err)
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 	/* extract bio before reusing the same field for request */
 	struct bio *bio = pdu->bio;
+	void *cookie = READ_ONCE(ioucmd->cookie);
 
 	pdu->req = req;
 	req->bio = bio;
-	/* this takes care of moving rest of completion-work to task context */
-	io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
+
+	/*
+	 * For iopoll, complete it directly.
+	 * Otherwise, move the completion to task work.
+	 */
+	if (cookie != NULL && blk_rq_is_poll(req))
+		nvme_uring_task_cb(ioucmd);
+	else
+		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
 }
 
 static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
@@ -445,7 +453,10 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		rq_flags = REQ_NOWAIT;
 		blk_flags = BLK_MQ_REQ_NOWAIT;
 	}
+	if (issue_flags & IO_URING_F_IOPOLL)
+		rq_flags |= REQ_POLLED;
 
+retry:
 	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
 			d.data_len, nvme_to_user_ptr(d.metadata),
 			d.metadata_len, 0, &meta, d.timeout_ms ?
@@ -456,6 +467,17 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	req->end_io = nvme_uring_cmd_end_io;
 	req->end_io_data = ioucmd;
 
+	if (issue_flags & IO_URING_F_IOPOLL && rq_flags & REQ_POLLED) {
+		if (unlikely(!req->bio)) {
+			/* we can't poll this, so alloc regular req instead */
+			blk_mq_free_request(req);
+			rq_flags &= ~REQ_POLLED;
+			goto retry;
+		} else {
+			WRITE_ONCE(ioucmd->cookie, req->bio);
+			req->bio->bi_opf |= REQ_POLLED;
+		}
+	}
 	/* to free bio on completion, as req->bio will be null at that time */
 	pdu->bio = req->bio;
 	pdu->meta = meta;
@@ -559,9 +581,6 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 static int nvme_uring_cmd_checks(unsigned int issue_flags)
 {
-	/* IOPOLL not supported yet */
-	if (issue_flags & IO_URING_F_IOPOLL)
-		return -EOPNOTSUPP;
 
 	/* NVMe passthrough requires big SQE/CQE support */
 	if ((issue_flags & (IO_URING_F_SQE128|IO_URING_F_CQE32)) !=
@@ -604,6 +623,23 @@ int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
 	return nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
 }
 
+int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
+{
+	struct bio *bio;
+	int ret;
+	struct nvme_ns *ns;
+	struct request_queue *q;
+
+	rcu_read_lock();
+	bio = READ_ONCE(ioucmd->cookie);
+	ns = container_of(file_inode(ioucmd->file)->i_cdev,
+			struct nvme_ns, cdev);
+	q = ns->queue;
+	if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
+		ret = bio_poll(bio, 0, 0);
+	rcu_read_unlock();
+	return ret;
+}
 #ifdef CONFIG_NVME_MULTIPATH
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx)
@@ -685,6 +721,29 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
+
+int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
+	int srcu_idx = srcu_read_lock(&head->srcu);
+	struct nvme_ns *ns = nvme_find_path(head);
+	struct bio *bio;
+	int ret = 0;
+	struct request_queue *q;
+
+	if (ns) {
+		rcu_read_lock();
+		bio = READ_ONCE(ioucmd->private);
+		q = ns->queue;
+		if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio
+				&& bio->bi_bdev)
+			ret = bio_poll(bio, 0, 0);
+		rcu_read_unlock();
+	}
+	srcu_read_unlock(&head->srcu, srcu_idx);
+	return ret;
+}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
@@ -692,6 +751,10 @@ int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
 	struct nvme_ctrl *ctrl = ioucmd->file->private_data;
 	int ret;
 
+	/* IOPOLL not supported yet */
+	if (issue_flags & IO_URING_F_IOPOLL)
+		return -EOPNOTSUPP;
+
 	ret = nvme_uring_cmd_checks(issue_flags);
 	if (ret)
 		return ret;
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 6ef497c75a16..00f2f81e20fa 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -439,6 +439,7 @@ static const struct file_operations nvme_ns_head_chr_fops = {
 	.unlocked_ioctl	= nvme_ns_head_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.uring_cmd	= nvme_ns_head_chr_uring_cmd,
+	.uring_cmd_iopoll = nvme_ns_head_chr_uring_cmd_iopoll,
 };
 
 static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index bdc0ff7ed9ab..3f2d3dda6e6c 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -821,6 +821,8 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
+int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd);
+int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd);
 int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 		unsigned int issue_flags);
 int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
-- 
2.25.1

