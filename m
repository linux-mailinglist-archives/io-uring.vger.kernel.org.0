Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFEB6F23EB
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 11:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjD2Jmr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 05:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjD2Jmq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 05:42:46 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA90E54
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 02:42:44 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230429094242epoutp0317b5bc5f57d2b03e9eb5ddca77aff11a~aXosU05Ou2943429434epoutp03p
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 09:42:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230429094242epoutp0317b5bc5f57d2b03e9eb5ddca77aff11a~aXosU05Ou2943429434epoutp03p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682761362;
        bh=SAKoOZSg9Ryf3M1Ys01fDubKQ5exxqRHHmS46vJCi0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjF9tSTnW4E6oKa2nPcNA0zAkEl/I5VTWviKH+mYQ2pBjJ3+gIGYJWD8ZmBqYeb9H
         Ih12C44A47xC7+wmscGOav/imZMEZWJ0W8OFxupo27IuxNbyTIf+jVAB9GCP+6sTCO
         taxXXrQ5Vp9vSakVdmmesxvKbxmSqHRDkAufOdx8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230429094240epcas5p37d11b6192fc960914c687d756af34a61~aXorLFqJG0334203342epcas5p3B;
        Sat, 29 Apr 2023 09:42:40 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Q7kzM5wN4z4x9Pt; Sat, 29 Apr
        2023 09:42:39 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.50.55646.F86EC446; Sat, 29 Apr 2023 18:42:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230429094238epcas5p4efa3dc785fa54ab974852c7f90113025~aXopHYaOv1633616336epcas5p4q;
        Sat, 29 Apr 2023 09:42:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230429094238epsmtrp10dfd833b65a0679e8f1cbabc11094929~aXopGo8QR0376803768epsmtrp1p;
        Sat, 29 Apr 2023 09:42:38 +0000 (GMT)
X-AuditID: b6c32a4b-b71fa7000001d95e-d5-644ce68fc5b0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C4.38.27706.E86EC446; Sat, 29 Apr 2023 18:42:38 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230429094236epsmtip2c319e9777540e1cfa3f2fc1b390ad953~aXonEwqLw0191301913epsmtip2_;
        Sat, 29 Apr 2023 09:42:36 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        anuj1072538@gmail.com, xiaoguang.wang@linux.alibaba.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 01/12] nvme: refactor nvme_alloc_io_tag_set
Date:   Sat, 29 Apr 2023 15:09:14 +0530
Message-Id: <20230429093925.133327-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230429093925.133327-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsWy7bCmpm7/M58Ug9YzOhYfv/5msVh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFutev2ex2PT3JJMDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHjsfWnpsXlLvsftmA5tH35ZVjB6fN8kFcEZl22SkJqakFimk5iXn
        p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaqkUJaYUwoUCkgsLlbSt7Mp
        yi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM7oeTKTsaBFrWLWtqls
        DYzdCl2MnBwSAiYSN7dtYuxi5OIQEtjNKPF913M2COcTo8SK5mcsEM43Rom/C1qYYVqWbvrF
        BJHYyyhx49tvVgjnM6NE/9Ut7F2MHBxsApoSFyaXgjSICLhINK2dCjaWWeAio0TPp0MsIAlh
        AXuJBVfPs4HYLAKqEg0nX4Jt4BWwlJj4+hwTxDZ5iZmXvrOD2JwCVhLfZ+yGqhGUODnzCdgc
        ZqCa5q2zoa6byyHRekYMwnaR+H7mGTuELSzx6vgWKFtK4mV/G5SdLHFpJsyuEonHew5C2fYS
        raf6mUF+YQb6Zf0ufYhVfBK9v58wgYQlBHglOtqEIKoVJe5NesoKYYtLPJyxBMr2kHh0tAEa
        PL3A4D2ymW0Co/wsJB/MQvLBLIRtCxiZVzFKphYU56anFpsWGOellsMjNjk/dxMjOMVqee9g
        fPTgg94hRiYOxkOMEhzMSiK8vJXuKUK8KYmVValF+fFFpTmpxYcYTYFBPJFZSjQ5H5jk80ri
        DU0sDUzMzMxMLI3NDJXEedVtTyYLCaQnlqRmp6YWpBbB9DFxcEo1MKV2ipx4fnMmV8jlY/xb
        PjVZBW78ZXjh5tSUzmwTATF53tkp225MYZf67iyhv8TvX256xIG5y93kr4u+2ns7wzBxiXp0
        q2fD+frr3NuOm9n+dpxpYf+ZP+xnskXythkPPd5KJU/4/3BV953ZuexbLRvkXDmUPCUv5RQ1
        sYf8Pdd66PECh6P/V8aV/9ozxaFqZbLnijWZ11d+lKk++e95tLy7zubs2D/p83Key21aN2NS
        wdpf6bPE/jotTtAym872Rf3C8oTG6ccWKmg6fVPbpPypP0Zuje+z2bofWu6Y8Aif5Gndtu6C
        UvPkdF0dgRmnDLuW7qlRnj73gv2fVc7vVxfFGtjnmz6STotvsHI1nq/EUpyRaKjFXFScCADd
        5orHOgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWy7bCSvG7fM58Ug56dKhYfv/5msVh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFutev2ex2PT3JJMDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHjsfWnpsXlLvsftmA5tH35ZVjB6fN8kFcEZx2aSk5mSWpRbp2yVw
        ZfQ8mclY0KJWMWvbVLYGxm6FLkZODgkBE4mlm34xgdhCArsZJb4t8YeIi0s0X/vBDmELS6z8
        9xzI5gKq+cgoMWXvC+YuRg4ONgFNiQuTS0FqRAS8JNrfzmIDqWEWuMkosW/3XrBmYQF7iQVX
        z7OB2CwCqhINJ18yg9i8ApYSE1+fY4JYIC8x89J3sHpOASuJ7zN2g80XAqppXBAPUS4ocXLm
        ExYQmxmovHnrbOYJjAKzkKRmIUktYGRaxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kR
        HBtamjsYt6/6oHeIkYmD8RCjBAezkggvb6V7ihBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n
        44UE0hNLUrNTUwtSi2CyTBycUg1Mp7NU2qP4VbI/rD7waLLWnKeyGrZx594qx06fHvHT3Wn9
        i6lv5wXMDTgafCdohrwl060HCYd2pN3VORD78Y9mmKP0hOfaTz6rh+z2EHr558eZZay5qpz9
        s5JY3wZ75Oz3mZje+WJmyZPvByQ73HXeHz/mOtOF/22C9b4kZ//rr19fnTl3QYLlSY4rR7/p
        mcddDT7C/fBG15kGX45tDyc/cfhrHuc4zbiNS5CnvS7QaL5Bonp38EbRM44utnHO/7UPPzDk
        VlIo1N7jm/u9tSTx44sIxns9oudzdgW67VDrkb+sX7J+Xr1Qr8Signd3wk/1OS29ptZ5Jqa1
        bwObwd6LtcvPLbx9y5jX6WS4greyEktxRqKhFnNRcSIAmcAyTvwCAAA=
X-CMS-MailID: 20230429094238epcas5p4efa3dc785fa54ab974852c7f90113025
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230429094238epcas5p4efa3dc785fa54ab974852c7f90113025
References: <20230429093925.133327-1-joshi.k@samsung.com>
        <CGME20230429094238epcas5p4efa3dc785fa54ab974852c7f90113025@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Allow this function to take nr_hw_queues as a parameter. And change all
the callers. This is in preparation to introduce queues which do not
have to be registered with block-layer.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/core.c   | 5 +++--
 drivers/nvme/host/fc.c     | 3 ++-
 drivers/nvme/host/nvme.h   | 2 +-
 drivers/nvme/host/pci.c    | 3 ++-
 drivers/nvme/host/rdma.c   | 2 +-
 drivers/nvme/host/tcp.c    | 3 ++-
 drivers/nvme/target/loop.c | 3 ++-
 7 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 1bfd52eae2ee..ba476c48d566 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4962,7 +4962,7 @@ EXPORT_SYMBOL_GPL(nvme_remove_admin_tag_set);
 
 int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 		const struct blk_mq_ops *ops, unsigned int nr_maps,
-		unsigned int cmd_size)
+		unsigned int cmd_size, unsigned int nr_hw_queues)
 {
 	int ret;
 
@@ -4983,9 +4983,10 @@ int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 		set->flags |= BLK_MQ_F_BLOCKING;
 	set->cmd_size = cmd_size,
 	set->driver_data = ctrl;
-	set->nr_hw_queues = ctrl->queue_count - 1;
+	set->nr_hw_queues = nr_hw_queues - 1;
 	set->timeout = NVME_IO_TIMEOUT;
 	set->nr_maps = nr_maps;
+
 	ret = blk_mq_alloc_tag_set(set);
 	if (ret)
 		return ret;
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 456ee42a6133..c7dd084c1999 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2918,7 +2918,8 @@ nvme_fc_create_io_queues(struct nvme_fc_ctrl *ctrl)
 	ret = nvme_alloc_io_tag_set(&ctrl->ctrl, &ctrl->tag_set,
 			&nvme_fc_mq_ops, 1,
 			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
-				    ctrl->lport->ops->fcprqst_priv_sz));
+				    ctrl->lport->ops->fcprqst_priv_sz),
+				    ctrl->ctrl.queue_count);
 	if (ret)
 		return ret;
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index bf46f122e9e1..73992dc9dec7 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -748,7 +748,7 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 void nvme_remove_admin_tag_set(struct nvme_ctrl *ctrl);
 int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 		const struct blk_mq_ops *ops, unsigned int nr_maps,
-		unsigned int cmd_size);
+		unsigned int cmd_size, unsigned int nr_hw_queues);
 void nvme_remove_io_tag_set(struct nvme_ctrl *ctrl);
 
 void nvme_remove_namespaces(struct nvme_ctrl *ctrl);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 7f25c0fe3a0b..3a38ee6ee129 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3033,7 +3033,8 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	if (dev->online_queues > 1) {
 		nvme_alloc_io_tag_set(&dev->ctrl, &dev->tagset, &nvme_mq_ops,
-				nvme_pci_nr_maps(dev), sizeof(struct nvme_iod));
+				nvme_pci_nr_maps(dev), sizeof(struct nvme_iod),
+				dev->ctrl.queue_count);
 		nvme_dbbuf_set(dev);
 	}
 
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 0eb79696fb73..2e2e131edc62 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -795,7 +795,7 @@ static int nvme_rdma_alloc_tag_set(struct nvme_ctrl *ctrl)
 	return nvme_alloc_io_tag_set(ctrl, &to_rdma_ctrl(ctrl)->tag_set,
 			&nvme_rdma_mq_ops,
 			ctrl->opts->nr_poll_queues ? HCTX_MAX_TYPES : 2,
-			cmd_size);
+			cmd_size, ctrl->queue_count);
 }
 
 static void nvme_rdma_destroy_admin_queue(struct nvme_rdma_ctrl *ctrl)
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index bf0230442d57..50efbd724284 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1893,7 +1893,8 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 		ret = nvme_alloc_io_tag_set(ctrl, &to_tcp_ctrl(ctrl)->tag_set,
 				&nvme_tcp_mq_ops,
 				ctrl->opts->nr_poll_queues ? HCTX_MAX_TYPES : 2,
-				sizeof(struct nvme_tcp_request));
+				sizeof(struct nvme_tcp_request),
+				ctrl->queue_count);
 		if (ret)
 			goto out_free_io_queues;
 	}
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index f2d24b2d992f..f02419b537f7 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -496,7 +496,8 @@ static int nvme_loop_create_io_queues(struct nvme_loop_ctrl *ctrl)
 	ret = nvme_alloc_io_tag_set(&ctrl->ctrl, &ctrl->tag_set,
 			&nvme_loop_mq_ops, 1,
 			sizeof(struct nvme_loop_iod) +
-			NVME_INLINE_SG_CNT * sizeof(struct scatterlist));
+			NVME_INLINE_SG_CNT * sizeof(struct scatterlist),
+			ctrl->ctrl.queue_count);
 	if (ret)
 		goto out_destroy_queues;
 
-- 
2.25.1

