Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175D65ECB96
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 19:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiI0Rtd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 13:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiI0RtC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 13:49:02 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4225D19012
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 10:46:42 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220927174640epoutp01f71f4d5834bf7703e2a77931712ce9c9~YyMKvJ0mh2137021370epoutp01E
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 17:46:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220927174640epoutp01f71f4d5834bf7703e2a77931712ce9c9~YyMKvJ0mh2137021370epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664300800;
        bh=YvisQxDCCiY/YZ3UCOZ2Bjwz4ZAQa8PRkCgpg4Fkog4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=taIsjf6eAs2bVM6Q4yCb/WSWbegjokrf2bTe6SOIvO7jLLAF2yYz0c1mXxwJJjn5w
         0/eSkHN0uqqS52xvo2qFGklrT2v9Feos7St+yT6bdShCT/WFrPUWvqLLf+K5UrEbPY
         9In1eEVl/2+ufle3j3cKKdGUQuRQcw+23ePPx3YQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220927174640epcas5p2f0d193abdb140d621e6dd3c7a63079e2~YyMKW9BUA3143031430epcas5p2B;
        Tue, 27 Sep 2022 17:46:40 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4McRrR5TCNz4x9Pv; Tue, 27 Sep
        2022 17:46:31 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3C.79.56352.7F633336; Wed, 28 Sep 2022 02:46:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220927174631epcas5p12cd6ffbd7dad819b0af75733ce6cdd2c~YyMB_NHwQ1881118811epcas5p1R;
        Tue, 27 Sep 2022 17:46:31 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220927174631epsmtrp255e7f23830670585c2a976cb17ab4dd4~YyMB9gk6v3251332513epsmtrp2f;
        Tue, 27 Sep 2022 17:46:31 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-c8-633336f7aa9a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E3.86.18644.7F633336; Wed, 28 Sep 2022 02:46:31 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220927174629epsmtip12c9f5129ac6208bc1083716bbc42cf2b~YyMAoibdO1930019300epsmtip1N;
        Tue, 27 Sep 2022 17:46:29 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v10 3/7] nvme: refactor nvme_add_user_metadata
Date:   Tue, 27 Sep 2022 23:06:06 +0530
Message-Id: <20220927173610.7794-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220927173610.7794-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42LZdlhTS/e7mXGyweID2har7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
        dN0yc4CuUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZY
        GRoYGJkCFSZkZ+w8P4mpYK9wRcsRywbGM/xdjJwcEgImEu/fPWbsYuTiEBLYzSix8vxlZgjn
        E6PEh9tb2CGcz4wSJ47tYodpOXF4N1RiF6PE6X1PmOCqTh+cB5Th4GAT0JS4MLkUpEFEwEhi
        /6eTrCA1zAIzGCVWd7wGmyQs4C7xfWEvK4jNIqAqcX7XPDCbV8BcYvPVlawQ2+QlZl76DjaT
        U8BC4vDHTIgSQYmTM5+wgNjMQCXNW2eDnS0h8JVd4mXfZ6heF4kjhx8wQtjCEq+Ob4H6QEri
        87u9bBB2ssSlmeeYIOwSicd7DkLZ9hKtp/qZQfYyA/2yfpc+xC4+id7fIP9yAJXwSnS0CUFU
        K0rcm/QUaqu4xMMZS6BsD4lTC35Cg6ebUaJ5+wK2CYzys5C8MAvJC7MQti1gZF7FKJlaUJyb
        nlpsWmCcl1oOj9fk/NxNjOA0qeW9g/HRgw96hxiZOBgPMUpwMCuJ8P4+apgsxJuSWFmVWpQf
        X1Sak1p8iNEUGMQTmaVEk/OBiTqvJN7QxNLAxMzMzMTS2MxQSZx38QytZCGB9MSS1OzU1ILU
        Ipg+Jg5OqQamEM8L31ZcfnREb6JumBjD5Y23fe4z/o4PMufYrvSB91XhrMbadUy7ikp9b+lO
        EVrJsYv1YQGTqO2P3xEKiReDTvcver5gJ2tux+00/iPRPdusQrcdOckn0rljlkhPZs6OTMbH
        GQV69RrqvHP/el1fLJuXu8hw0sY9J5mvSaskpMWWz4qZ9j8o2OS/i0aBxkvLrt8nZ8R2dE7a
        n/Po69+oq9qseoerTsb+rZv5xYd/v/f8PtEdrx7KZTRukj3T0jP9jm7m429nbnO8z1z7nPHq
        CYc1UhaRrIdc5R5lT+PV6btofLdn2ZS7d0UkDAuKisJi4iLMbqUqzM1/c2nDjRNPjV+dzWAW
        tQ2NW//b/kCGEktxRqKhFnNRcSIAN2uEhxwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSnO53M+Nkg/OTBC1W3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpuwOHx+WzpR6bVnWyeWxeUu+x+2YDm0ff
        llWMHp83yQWwRXHZpKTmZJalFunbJXBl7Dw/ialgr3BFyxHLBsYz/F2MnBwSAiYSJw7vZgex
        hQR2MEq82KQOEReXaL72gx3CFpZY+e85kM0FVPORUWLPs9XMXYwcHGwCmhIXJpeC1IgImEks
        PbyGBaSGWWAOo8Tly3vAmoUF3CW+L+xlBbFZBFQlzu+aB2bzCphLbL66khVigbzEzEvf2UFm
        cgpYSBz+mAlxj7nE1k0fWCDKBSVOznwCZjMDlTdvnc08gVFgFpLULCSpBYxMqxglUwuKc9Nz
        iw0LjPJSy/WKE3OLS/PS9ZLzczcxgsNbS2sH455VH/QOMTJxMB5ilOBgVhLh/X3UMFmINyWx
        siq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGpkwXu9l2XjfK494v
        XafeZVVVaTRXqvZrwOXH8+aq7Lr8Z7b7bYVJpfcn8Ose3PXu2qPjcoryd8oenNM44nPp0I3+
        Fzt3cOX5m01LeL0qnNExN4rDKbfd4lJHrHPb+//s6/+U97wwZeESPMggnX/CbM+LRMk52lpm
        13eIn/y4UbZL4nzKr74dPSv2/LYyOxBRNP0Yr8j/DRUKpq9s+J7x7Wh1eP+H7XnJ6VUJf+5O
        f7TpaOXsaZseSnMcq34cvvX460teNb9fvr9t8nfSp2CPgN4pIkdZYw6ppJtlTgucwHuOoTjQ
        YGrFgoXuj7xSp4cGWzzec8xV2EzmmytTp9diu/hZ6aZfFtiVnEpNEmGy0lViKc5INNRiLipO
        BAD0tOyj3gIAAA==
X-CMS-MailID: 20220927174631epcas5p12cd6ffbd7dad819b0af75733ce6cdd2c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220927174631epcas5p12cd6ffbd7dad819b0af75733ce6cdd2c
References: <20220927173610.7794-1-joshi.k@samsung.com>
        <CGME20220927174631epcas5p12cd6ffbd7dad819b0af75733ce6cdd2c@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass struct request rather than bio. It helps to kill a parameter, and
some processing clean-up too.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 548aca8b5b9f..8f8435b55b95 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -20,19 +20,20 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 	return (void __user *)ptrval;
 }
 
-static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
-		unsigned len, u32 seed, bool write)
+static void *nvme_add_user_metadata(struct request *req, void __user *ubuf,
+		unsigned len, u32 seed)
 {
 	struct bio_integrity_payload *bip;
 	int ret = -ENOMEM;
 	void *buf;
+	struct bio *bio = req->bio;
 
 	buf = kmalloc(len, GFP_KERNEL);
 	if (!buf)
 		goto out;
 
 	ret = -EFAULT;
-	if (write && copy_from_user(buf, ubuf, len))
+	if ((req_op(req) == REQ_OP_DRV_OUT) && copy_from_user(buf, ubuf, len))
 		goto out_free_meta;
 
 	bip = bio_integrity_alloc(bio, GFP_KERNEL, 1);
@@ -45,9 +46,13 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	bip->bip_iter.bi_sector = seed;
 	ret = bio_integrity_add_page(bio, virt_to_page(buf), len,
 			offset_in_page(buf));
-	if (ret == len)
-		return buf;
-	ret = -ENOMEM;
+	if (ret != len) {
+		ret = -ENOMEM;
+		goto out_free_meta;
+	}
+
+	req->cmd_flags |= REQ_INTEGRITY;
+	return buf;
 out_free_meta:
 	kfree(buf);
 out:
@@ -70,7 +75,6 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 		u32 meta_seed, void **metap, unsigned timeout, bool vec,
 		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags)
 {
-	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
 	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
 	struct request *req;
@@ -110,13 +114,12 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 		if (bdev)
 			bio_set_dev(bio, bdev);
 		if (bdev && meta_buffer && meta_len) {
-			meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
-					meta_seed, write);
+			meta = nvme_add_user_metadata(req, meta_buffer, meta_len,
+					meta_seed);
 			if (IS_ERR(meta)) {
 				ret = PTR_ERR(meta);
 				goto out_unmap;
 			}
-			req->cmd_flags |= REQ_INTEGRITY;
 			*metap = meta;
 		}
 	}
-- 
2.25.1

