Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F22518C9A
	for <lists+io-uring@lfdr.de>; Tue,  3 May 2022 20:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiECSxI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 May 2022 14:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236685AbiECSxE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 May 2022 14:53:04 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D30B3F896
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 11:49:21 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220503184919euoutp01e70ac3cec3c2cfb00756ca5f6e04517c~rrN54ZHRh2548725487euoutp01S
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 18:49:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220503184919euoutp01e70ac3cec3c2cfb00756ca5f6e04517c~rrN54ZHRh2548725487euoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651603759;
        bh=U2NXMQ5XCQ1djlVQ3lkbCm+nuuKAOUuIEQS2Vz67/ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeUU5ZHqbPrWhQTIpor1ECUc/2OSXGXE4U0vL3h3q+02jPGJles4Cv1WgpdYmjlZu
         obrw7ngenol5AwmAi/v8dn/4oUtWzL6nz57p5FOiC3rIarYhPUI73mHOvAeGLuzDgw
         3My+SrtR1fSoNKxsFjHMSgQJ0TNZIT2DvtGkoqHI=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220503184917eucas1p218b32edb3e270131712cfef117517e61~rrN3dma0J0698106981eucas1p2C;
        Tue,  3 May 2022 18:49:17 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 55.2E.10009.D2971726; Tue,  3
        May 2022 19:49:17 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220503184916eucas1p266cbb3ffc1622b292bf59b5eccec9933~rrN3AZiXe0739707397eucas1p2C;
        Tue,  3 May 2022 18:49:16 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220503184916eusmtrp14a030f4b923fefbf5781015d7265d9bd~rrN2-r_1V2552825528eusmtrp1Y;
        Tue,  3 May 2022 18:49:16 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-98-6271792dc890
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id AB.F6.09404.C2971726; Tue,  3
        May 2022 19:49:16 +0100 (BST)
Received: from localhost (unknown [106.210.248.170]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220503184916eusmtip17ba71bb39bd022151924e4e5cd7831ed~rrN2pz3Ob0995809958eusmtip1E;
        Tue,  3 May 2022 18:49:16 +0000 (GMT)
From:   Pankaj Raghav <p.raghav@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v3 5/5] nvme: add vectored-io support for uring-cmd
Date:   Tue,  3 May 2022 20:48:31 +0200
Message-Id: <20220503184831.78705-6-p.raghav@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503184831.78705-1-p.raghav@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsWy7djP87q6lYVJBidesFs0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmcf7tYSaL+cueslvcmPCU0eLQ5GYmi6svD7A7
        8HhMbH7H7rFz1l12j8tnSz02repk89i8pN5j980GNo/3+66yefRtWcXo8XmTXABnFJdNSmpO
        Zllqkb5dAlfGvH1LWQq+i1Q8XP6FpYFxtWAXIyeHhICJxOTp/1i6GLk4hARWMErMmf+SHcL5
        wiix5PIcZgjnM6PE5WlbGGFavp3vZIRILGeU2LtiJztIQkjgJaPE2ddVXYwcHGwCWhKNnWBh
        EQF5iS+314KtYBZoZJL4+a0BLCEs4CyxvHU+mM0ioCrR1/mDGcTmFbCU+DxvCzvEMnmJmZe+
        s4PM5BSwktgxH6pEUOLkzCcsIDYzUEnz1tlgh0oI/OCQmHXhKhtEr4vExhcnmSBsYYlXx2Fm
        ykicntzDAmFXSzy98RuquYVRon/nejaQZRIC1hJ9Z3JATGYBTYn1u/Qhyh0lDr37xwhRwSdx
        460gxAl8EpO2TWeGCPNKdLQJQVQrSez8+QRqqYTE5aY5UEs9JFa3bWeZwKg4C8kzs5A8Mwth
        7wJG5lWM4qmlxbnpqcWGeanlesWJucWleel6yfm5mxiByev0v+OfdjDOffVR7xAjEwfjIUYJ
        DmYlEV7npQVJQrwpiZVVqUX58UWlOanFhxilOViUxHmTMzckCgmkJ5akZqemFqQWwWSZODil
        Gpg67WcuWPNofzrXs91qfNet4i93ueow3puusP7b1vTUNUm6s38771oya1LQ6b0L0x9dSBGQ
        eLLhh3OQ78yYUKfXDcuT2KS6lCQFFCLCuHnj4qZGT8p0+iG6Tvjn+uP1tk9a39uEfHY1+W1V
        3Fr2/hvnoUOck+7lia78uSRuG9cv4WtVSSWLG+6yXz/O8H0pj/r3RCUxHYeMh1Yz7tmV6L1W
        yvKf/nWyGeNRlVfxD0z4+ie4G4rm/AlXTRNc4Gs9cZPe9dOW4t8mHOHT+VLXe3ta3/1nV76y
        s1+sbGrUn5le8Wux+YvnC76FrnTZOOF1tS+z26bGRcKsczNTl0c/NZx+N7eZpTt2af2i8klV
        vluVWIozEg21mIuKEwHr68slzQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t/xu7o6lYVJBsu7NSyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzOP/2MJPF/GVP2S1uTHjKaHFocjOTxdWXB9gd
        eDwmNr9j99g56y67x+WzpR6bVnWyeWxeUu+x+2YDm8f7fVfZPPq2rGL0+LxJLoAzSs+mKL+0
        JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1SN8uQS9j3r6lLAXfRSoe
        Lv/C0sC4WrCLkZNDQsBE4tv5TsYuRi4OIYGljBIHf71lhkhISNxe2MQIYQtL/LnWxQZiCwk8
        Z5T4sJqni5GDg01AS6Kxkx0kLCKgKLHxYxPYHGaBXiaJiVs+sIIkhAWcJZa3zgcrYhFQlejr
        /AE2n1fAUuLzvC3sEPPlJWZe+s4OMpNTwEpix3xmiFWWEm0TF7NDlAtKnJz5hAXEZgYqb946
        m3kCo8AsJKlZSFILGJlWMYqklhbnpucWG+kVJ+YWl+al6yXn525iBMbZtmM/t+xgXPnqo94h
        RiYOxkOMEhzMSiK8zksLkoR4UxIrq1KL8uOLSnNSiw8xmgKdPZFZSjQ5HxjpeSXxhmYGpoYm
        ZpYGppZmxkrivJ4FHYlCAumJJanZqakFqUUwfUwcnFINTJlC566ccRVX03zopn/jq5CBaMvJ
        tWfT+PrXnD8yK+XoCR57vTB2kwqWz0KmE7JEDXZutJ999Jbpy4hJezf0Zqo6MTgITbwQw72h
        dO/TT1bOVerqnG9Z3i2pX542Ic9/9lfNHx2mER9/SFgETHOMc2f53/r9c6zUkm+issuvPLgg
        etK6KKhyX51s9z81vXuPDF4kKYRGn7T4fEx6R46ar1grq3vVx2WvLCb2mjO4ShwrSa6ac2Sf
        udyGhz0XbD+ILerS+Z98Y2nUm+OPC6ZleX58nD3z3fuFJYf2Rs1jEFF03p+qsWJ50S/Pngrt
        w099N/2bbjs77BF3sGifQQKH04maXdsmeTtsP8uyM+tGvBJLcUaioRZzUXEiALyND/M8AwAA
X-CMS-MailID: 20220503184916eucas1p266cbb3ffc1622b292bf59b5eccec9933
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220503184916eucas1p266cbb3ffc1622b292bf59b5eccec9933
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220503184916eucas1p266cbb3ffc1622b292bf59b5eccec9933
References: <20220503184831.78705-1-p.raghav@samsung.com>
        <CGME20220503184916eucas1p266cbb3ffc1622b292bf59b5eccec9933@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

wire up support for async passthru that takes an array of buffers (using
iovec). Exposed via a new op NVME_URING_CMD_IO_VEC. Same 'struct
nvme_uring_cmd' is to be used with -

1. cmd.addr as base address of user iovec array
2. cmd.vec_cnt as count of iovec array elements

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/ioctl.c       | 9 ++++++---
 include/uapi/linux/nvme_ioctl.h | 6 +++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index e428d692375a..ffc695aa5ba3 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -409,7 +409,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 }
 
 static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-		struct io_uring_cmd *ioucmd)
+		struct io_uring_cmd *ioucmd, bool vec)
 {
 	struct nvme_uring_cmd *cmd =
 		(struct nvme_uring_cmd *)ioucmd->cmd;
@@ -446,7 +446,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(cmd->addr),
 			cmd->data_len, nvme_to_user_ptr(cmd->metadata),
 			cmd->metadata_len, 0, cmd->timeout_ms ?
-			msecs_to_jiffies(cmd->timeout_ms) : 0, 0, rq_flags,
+			msecs_to_jiffies(cmd->timeout_ms) : 0, vec, rq_flags,
 			blk_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -556,7 +556,10 @@ static void nvme_ns_uring_cmd(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
 
 	switch (ioucmd->cmd_op) {
 	case NVME_URING_CMD_IO:
-		ret = nvme_uring_cmd_io(ns->ctrl, ns, ioucmd);
+		ret = nvme_uring_cmd_io(ns->ctrl, ns, ioucmd, false);
+		break;
+	case NVME_URING_CMD_IO_VEC:
+		ret = nvme_uring_cmd_io(ns->ctrl, ns, ioucmd, true);
 		break;
 	default:
 		ret = -ENOTTY;
diff --git a/include/uapi/linux/nvme_ioctl.h b/include/uapi/linux/nvme_ioctl.h
index 04e458c649ab..938e0a0bf46f 100644
--- a/include/uapi/linux/nvme_ioctl.h
+++ b/include/uapi/linux/nvme_ioctl.h
@@ -81,7 +81,10 @@ struct nvme_uring_cmd {
 	__u64	metadata;
 	__u64	addr;
 	__u32	metadata_len;
-	__u32	data_len;
+	union {
+		__u32	data_len; /* for non-vectored io */
+		__u32	vec_cnt; /* for vectored io */
+	};
 	__u32	cdw10;
 	__u32	cdw11;
 	__u32	cdw12;
@@ -107,5 +110,6 @@ struct nvme_uring_cmd {
 
 /* io_uring async commands: */
 #define NVME_URING_CMD_IO	_IOWR('N', 0x80, struct nvme_uring_cmd)
+#define NVME_URING_CMD_IO_VEC	_IOWR('N', 0x81, struct nvme_uring_cmd)
 
 #endif /* _UAPI_LINUX_NVME_IOCTL_H */
-- 
2.25.1

