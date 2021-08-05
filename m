Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926EE3E1583
	for <lists+io-uring@lfdr.de>; Thu,  5 Aug 2021 15:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240451AbhHENQd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Aug 2021 09:16:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48362 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240012AbhHENQd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Aug 2021 09:16:33 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210805131617epoutp04bbcc40711c785ed9fd035b8881a84dd6~Ya2w5BWGt1656716567epoutp041
        for <io-uring@vger.kernel.org>; Thu,  5 Aug 2021 13:16:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210805131617epoutp04bbcc40711c785ed9fd035b8881a84dd6~Ya2w5BWGt1656716567epoutp041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628169377;
        bh=pqp9y1dVjDN6AtVi6Zxi1NLSpdmNb8Vknc/txYyxzo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVfc2QKlO2sXoCSvlW3wc69+AK9A0xvBojPVfVReeufp/fAkb3Hdjw03MOHVLW0xY
         NK1yM//CoD0yE8TdIwZq0kkeNkb7oBterXDilwf7EIEYxRjIFGYZ4220eOutYz0qO4
         KNbrEBP5ZxaaBI+is3aZyUvOuXLsaMhtMQCumyPk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210805131616epcas5p33cf20777dde4cf0e0243e4a7a48e35dd~Ya2wEDKuL1990619906epcas5p3j;
        Thu,  5 Aug 2021 13:16:16 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GgTdT34Gfz4x9Pp; Thu,  5 Aug
        2021 13:16:13 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.EC.41701.D94EB016; Thu,  5 Aug 2021 22:16:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20210805125937epcas5p15667b460e28d87bd40400f69005aafe3~YaoNY1t_B0653406534epcas5p1s;
        Thu,  5 Aug 2021 12:59:37 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210805125937epsmtrp2f3955560d83af905bb4211110ae4b603~YaoNYDgi32066920669epsmtrp2B;
        Thu,  5 Aug 2021 12:59:37 +0000 (GMT)
X-AuditID: b6c32a4b-0abff7000001a2e5-bd-610be49dfc31
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A4.C5.08394.9B0EB016; Thu,  5 Aug 2021 21:59:37 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210805125935epsmtip161c7aed50a76fa34dacc29e5b02ec6a9~YaoL0-z251080510805epsmtip1C;
        Thu,  5 Aug 2021 12:59:35 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com, hare@suse.de,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 6/6] nvme: enable passthrough with fixed-buffer
Date:   Thu,  5 Aug 2021 18:25:39 +0530
Message-Id: <20210805125539.66958-7-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210805125539.66958-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGJsWRmVeSWpSXmKPExsWy7bCmpu7cJ9yJBg+ni1g0TfjLbLH6bj+b
        xZ5Fk5gsVq4+ymTxrvUci8XjO5/ZLY7+f8tmMenQNUaL+cuesltcmbKI2YHL4/LZUo9NqzrZ
        PDYvqffYfbOBzaNvyypGj82nqz0+b5ILYI/KtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
        1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCS
        U2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ0xeekMxoK58hWN18+wNjA+kexi5OSQEDCROPXp
        DmsXIxeHkMBuRomvZzYzQjifGCUmbH3BBOF8Y5RY/XEZE0zLlYfT2CESexklLv4+yQzhfGaU
        +LT5EZDDwcEmoClxYXIpSIOIgJHE/k8nwXYwCyxilNh6/zdYjbCAs8SvBVEgNSwCqhL93/ex
        gIR5BSwk+qdoQ+ySl5h56Ts7iM0pYCnx+dBeVhCbV0BQ4uTMJywgNjNQTfPW2WAnSAj0ckh8
        /HWKDaLZReL69z2sELawxKvjW9ghbCmJz+/2QtUUS/y6cxSquYNR4nrDTBaIhL3ExT1/mUAO
        Ygb6Zf0ufYiwrMTUU+uYIBbzSfT+fgINFF6JHfNgbEWJe5OeQu0Vl3g4YwmU7SHR1P4PGqI9
        jBKXr/xjncCoMAvJQ7OQPDQLYfUCRuZVjJKpBcW56anFpgXGeanl8FhOzs/dxAhOsFreOxgf
        Pfigd4iRiYPxEKMEB7OSCG/yYq5EId6UxMqq1KL8+KLSnNTiQ4ymwACfyCwlmpwPTPF5JfGG
        JpYGJmZmZiaWxmaGSuK87PFfE4QE0hNLUrNTUwtSi2D6mDg4pRqYlqYue7vulKRwrMFcZ5XT
        aXIVczzzt3CmH5wXuWDzgbfMSnfnyK/8bMo9s+p5iOmznwv7fZkmHog+rqYbzbpFfV4mN3d8
        qeJhy0qdeyHtU/fIu++u9a1SnnlMosVnxfSOIM75mtaXnzjsWs22/VPidPsHNpEBfYKX3+b9
        UF3aua9e/cN5rva9MkZaPb/9ZzFUuPhZbpfz616RabY+Q+FpwLwZwqm9qRwxPkc0p/n6rXY/
        uOD8p1QjdQfB3QoS79NZN7zaovlOYPNWlzittGNRfdkWky++/cr/mIuVu2yR9K1t284LrFgW
        3DDr+Ymo5qfJgqWbefp3XlJ7X67+abX0h39HrzyJllWpVPv7+vFCJZbijERDLeai4kQAu503
        zTkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWy7bCSnO7OB9yJBqd2K1k0TfjLbLH6bj+b
        xZ5Fk5gsVq4+ymTxrvUci8XjO5/ZLY7+f8tmMenQNUaL+cuesltcmbKI2YHL4/LZUo9NqzrZ
        PDYvqffYfbOBzaNvyypGj82nqz0+b5ILYI/isklJzcksSy3St0vgypi8dAZjwVz5isbrZ1gb
        GJ9IdjFyckgImEhceTiNvYuRi0NIYDejxJpZf1ghEuISzdd+sEPYwhIr/z0Hs4UEPjJKNF4q
        7GLk4GAT0JS4MLkUJCwiYCax9PAaFpA5zAIrGCV29/1mBKkRFnCW+LUgCqSGRUBVov/7PhaQ
        MK+AhUT/FG2I6fISMy99B5vOKWAp8fnQXlaQEiGgkplbI0DCvAKCEidnPmEBsZmBypu3zmae
        wCgwC0lqFpLUAkamVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwaGvpbmDcfuqD3qH
        GJk4GA8xSnAwK4nwJi/mShTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampB
        ahFMlomDU6qBKeWGnwN3g5jeTs9uxnkbl65VmnMgRI2/qa9gX5xckfO8+ra60H166S2PNa50
        9gnWmH74JOIVHdFXaG7RvCM+qK50besDe5ctkzc9TqoUvD31anf2hrxTS06v2pL19oeivC/r
        /5mCJ9sTgtae2Jr2z65xR0LJpe/ZwqkX5QwFIucGNtlprzb6M/eHQd6Ledcf58jwLykqyA64
        bZv/w3bbhNpP6tw3roqryjaJecX22GnXZ5h2vg5Ze1JYWf9FmYn5L9ffgkvY1odfF9qtvnqP
        p56cv93sqDOVZh5zrDND1r16nHi48963cw9qGQ7eXVAQpDOH61ba5kPKV1Nfn5xqfWheaJJB
        4IIzW6u9ZJyUWIozEg21mIuKEwFunJFH7AIAAA==
X-CMS-MailID: 20210805125937epcas5p15667b460e28d87bd40400f69005aafe3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210805125937epcas5p15667b460e28d87bd40400f69005aafe3
References: <20210805125539.66958-1-joshi.k@samsung.com>
        <CGME20210805125937epcas5p15667b460e28d87bd40400f69005aafe3@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add two new variants of passthrough ioctls
(NVMe_IOCTL_IO/IO64_CMD_FIXED) to carry out passthrough command with
pre-mapped buffers.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/ioctl.c       | 68 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/nvme_ioctl.h |  2 +
 2 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 2730c5dfdf78..d336e34aac41 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -139,6 +139,64 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 out:
 	return ERR_PTR(ret);
 }
+static inline bool nvme_is_fixedb_passthru(struct io_uring_cmd *ioucmd)
+{
+	struct block_uring_cmd *bcmd;
+
+	if (!ioucmd)
+		return false;
+	bcmd = (struct block_uring_cmd *)&ioucmd->pdu;
+	if (bcmd && ((bcmd->ioctl_cmd == NVME_IOCTL_IO_CMD_FIXED) ||
+				(bcmd->ioctl_cmd == NVME_IOCTL_IO64_CMD_FIXED)))
+		return true;
+	return false;
+}
+/*
+ * Unlike blk_rq_map_user () this is only for fixed-buffer async passthrough.
+ * And hopefully faster as well.
+ */
+int nvme_rq_map_user_fixedb(struct request_queue *q, struct request *rq,
+		     void __user *ubuf, unsigned long len, gfp_t gfp_mask,
+		     struct io_uring_cmd *ioucmd)
+{
+	struct iov_iter iter;
+	size_t iter_count, nr_segs;
+	struct bio *bio;
+	int ret;
+
+	/*
+	 * Talk to io_uring to obtain BVEC iterator for the buffer.
+	 * And use that iterator to form bio/request.
+	 */
+	ret = io_uring_cmd_import_fixed(ubuf, len, rq_data_dir(rq), &iter,
+			ioucmd);
+	if (unlikely(ret < 0))
+		return ret;
+	iter_count = iov_iter_count(&iter);
+	nr_segs = iter.nr_segs;
+
+	if (!iter_count || (iter_count >> 9) > queue_max_hw_sectors(q))
+		return -EINVAL;
+	if (nr_segs > queue_max_segments(q))
+		return -EINVAL;
+	/* no iovecs to alloc, as we already have a BVEC iterator */
+	bio = bio_kmalloc(gfp_mask, 0);
+	if (!bio)
+		return -ENOMEM;
+
+	bio->bi_opf |= req_op(rq);
+	ret = bio_iov_iter_get_pages(bio, &iter);
+	if (ret)
+		goto out_free;
+
+	blk_rq_bio_prep(rq, bio, nr_segs);
+	return 0;
+
+out_free:
+	bio_release_pages(bio, false);
+	bio_put(bio);
+	return ret;
+}
 
 static int nvme_submit_user_cmd(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
@@ -163,8 +221,12 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	nvme_req(req)->flags |= NVME_REQ_USERCMD;
 
 	if (ubuffer && bufflen) {
-		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-				GFP_KERNEL);
+		if (likely(!nvme_is_fixedb_passthru(ioucmd)))
+			ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
+					GFP_KERNEL);
+		else
+			ret = nvme_rq_map_user_fixedb(q, req, ubuffer, bufflen,
+					GFP_KERNEL, ioucmd);
 		if (ret)
 			goto out;
 		bio = req->bio;
@@ -480,9 +542,11 @@ static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
 
 	switch (bcmd->ioctl_cmd) {
 	case NVME_IOCTL_IO_CMD:
+	case NVME_IOCTL_IO_CMD_FIXED:
 		ret = nvme_user_cmd(ns->ctrl, ns, argp, ioucmd);
 		break;
 	case NVME_IOCTL_IO64_CMD:
+	case NVME_IOCTL_IO64_CMD_FIXED:
 		ret = nvme_user_cmd64(ns->ctrl, ns, argp, ioucmd);
 		break;
 	default:
diff --git a/include/uapi/linux/nvme_ioctl.h b/include/uapi/linux/nvme_ioctl.h
index d99b5a772698..fc05c6024edd 100644
--- a/include/uapi/linux/nvme_ioctl.h
+++ b/include/uapi/linux/nvme_ioctl.h
@@ -78,5 +78,7 @@ struct nvme_passthru_cmd64 {
 #define NVME_IOCTL_RESCAN	_IO('N', 0x46)
 #define NVME_IOCTL_ADMIN64_CMD	_IOWR('N', 0x47, struct nvme_passthru_cmd64)
 #define NVME_IOCTL_IO64_CMD	_IOWR('N', 0x48, struct nvme_passthru_cmd64)
+#define NVME_IOCTL_IO_CMD_FIXED	_IOWR('N', 0x49, struct nvme_passthru_cmd)
+#define NVME_IOCTL_IO64_CMD_FIXED _IOWR('N', 0x50, struct nvme_passthru_cmd64)
 
 #endif /* _UAPI_LINUX_NVME_IOCTL_H */
-- 
2.25.1

