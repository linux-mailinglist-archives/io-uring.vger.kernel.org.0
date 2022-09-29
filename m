Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617835EF559
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbiI2MYz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbiI2MYr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:24:47 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5A638AD
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:24:40 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220929122438epoutp0100444723e75989298c0004e1d3adb03a~ZVFj6IU4Z0334303343epoutp01k
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:24:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220929122438epoutp0100444723e75989298c0004e1d3adb03a~ZVFj6IU4Z0334303343epoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454278;
        bh=4MDUpwx2cUKu3o31e+4s7CnsnjvHszXB+w2SZxN5EHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L66dUsFa33zMXCDswdpFl1ZYboNr5wVc9KGajep4gf2M7462YYmbwZQ48ORropBMH
         ac2UBFijoDUjHE0iC/WHXfhHg6PFMwudcPR8G4g+X2XBIo43J48AP7eiRNv48MZ4xX
         58P6cJB0VtEHcnG2xa9i6lnni2hHSx0RHG7awzwM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220929122438epcas5p323a706d2e2e034d7d3b8a0ef3a7f83be~ZVFjjIG180990309903epcas5p3I;
        Thu, 29 Sep 2022 12:24:38 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MdXc36kJ6z4x9Pr; Thu, 29 Sep
        2022 12:24:35 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E6.B8.39477.38E85336; Thu, 29 Sep 2022 21:24:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121713epcas5p1824ed0c48c9e9ceeb18954d9c23564ed~ZU-FJDhK41192111921epcas5p1o;
        Thu, 29 Sep 2022 12:17:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220929121713epsmtrp2a12d60bc0823694167ede69c347c2c74~ZU-FIT3MK1942419424epsmtrp2F;
        Thu, 29 Sep 2022 12:17:13 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-1a-63358e83c5db
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.43.14392.8CC85336; Thu, 29 Sep 2022 21:17:12 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121711epsmtip17062c4deb706c2bfbfcf817e4a18c8ea~ZU-D1tCru3028230282epsmtip10;
        Thu, 29 Sep 2022 12:17:11 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v11 12/13] scsi: Use blk_rq_map_user_io helper
Date:   Thu, 29 Sep 2022 17:36:31 +0530
Message-Id: <20220929120632.64749-13-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929120632.64749-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmpm5zn2mywaM2Y4umCX+ZLVbf7Wez
        uHlgJ5PFytVHmSzetZ5jsZh06Bqjxd5b2hbzlz1lt+i+voPNgdPj8tlSj02rOtk8Ni+p99h9
        s4HNo2/LKkaPz5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNT
        bZVcfAJ03TJzgE5SUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al
        6+WlllgZGhgYmQIVJmRnnLt8ja3gh2DFu01XGRsYV/F1MXJySAiYSNxd/4iti5GLQ0hgN6PE
        seMrmEASQgKfGCWuz9CBsL8xSnRvLYFp+NjxnhmiYS+jxJYFZ6C6PzNK/HrRzg5SxSagLnHk
        eSsjiC0iYCSx/9NJVpAiZoFNQEXXj4GtEBZwl1h54TlYEYuAqsSaiXOBmjk4eAWsJBYuV4PY
        Ji8x89J3sJmcQOHF1+awgti8AoISJ2c+YQGxmYFqmrfOBrtIQuAvu8TsZ3/YIJpdJKY92McE
        YQtLvDq+hR3ClpL4/G4vVE26xI/LT6FqCiSaj+1jhLDtJVpP9TOD3MMsoCmxfpc+RFhWYuqp
        dUwQe/kken8/gWrlldgxD8ZWkmhfOQfKlpDYe66BCWSMhICHROM5GUhY9TJKnJs5m3ECo8Is
        JO/MQvLOLITNCxiZVzFKphYU56anFpsWGOWllsPjODk/dxMjOJFqee1gfPjgg94hRiYOxkOM
        EhzMSiK84gWmyUK8KYmVValF+fFFpTmpxYcYTYHBPZFZSjQ5H5jK80riDU0sDUzMzMxMLI3N
        DJXEeRfP0EoWEkhPLEnNTk0tSC2C6WPi4JRqYDIIfrd40jzGXUGaa2XyFlxYZNZ9dO8bMyYj
        Z+6CWb8Pfy9vZNNQddzadE8h8mdFRV/qs4us3EKnGLzTtrJEHp09a330efdr+96VVIl3sB+M
        +2tyaP/2hTHr5vXtlp61UEdju/Zl3UITu/u/b0VMNdF4U7NEaOfSk/6Lhaa4+P074nP8a2WA
        e5XOynWyFSVtQfe9pnPN5fIwL+ho8ZY5uuPe5QivPUKXZzwq/2HJvWDz5/7ZApkbVc9GHusU
        KHUvdBM4vDnQ7nDq51t1HBn7Nnnuy+XoX+7jEnpz4lrj/NBV/CeyMhSYVWQDJXmPWfiu+Vkc
        +U/077ynWl1y03mij0e8m/PM6/T1wJCiE9/XVSuxFGckGmoxFxUnAgConU69LQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSnO6JHtNkg/OfbCyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mo4d/kaW8EPwYp3m64yNjCu4uti5OSQEDCR
        +NjxnhnEFhLYzSgxe30MRFxC4tTLZYwQtrDEyn/P2bsYuYBqPjJK/Fh/HqyBTUBd4sjzVrAi
        EQEziaWH17CAFDEL7GCUWPdsMVhCWMBdYuWF52A2i4CqxJqJc4EmcXDwClhJLFyuBrFAXmLm
        pe/sIDYnUHjxtTmsICVCApYS228qgIR5BQQlTs58wgJiMwOVN2+dzTyBUWAWktQsJKkFjEyr
        GCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCQ11Lcwfj9lUf9A4xMnEwHmKU4GBWEuEV
        LzBNFuJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoEpqV/g
        0J3tOax/Nmy47tK7rtV2hdLnqgVO909YeVxXyZmwNsp8qdtCx8Sk71MYjSfdCP4Yru5nVvHd
        xrfH9vUu3+Yi+QJFyU18j57Ztguvf3Vb5ttvaeMUhV7OKSJZsyW/b1u68+6ETdOOS5yXnxu3
        cuU19T/bv7ivMkvhYZx+tVorXf76NYUIWY3PgQZ/T1lq3HX2vhGhfPvrwQ179zOw/13O7iCk
        7+C4luPhuWMMP23XHm7hd9WyL33FVan09dJNrnU1/NtWXGiQe7ZUYfeE0w069Tf5Bb+Zfrw8
        4UnUnqSJjo8Yml4HiDks5q9YYZk9fbXuquw1q9ZE9Oy5Nk/T1SHmkHPWK+HruonBCxn9lFiK
        MxINtZiLihMBsjp7CuQCAAA=
X-CMS-MailID: 20220929121713epcas5p1824ed0c48c9e9ceeb18954d9c23564ed
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121713epcas5p1824ed0c48c9e9ceeb18954d9c23564ed
References: <20220929120632.64749-1-anuj20.g@samsung.com>
        <CGME20220929121713epcas5p1824ed0c48c9e9ceeb18954d9c23564ed@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use the new blk_rq_map_user_io helper instead of duplicating code at
various places.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/scsi/scsi_ioctl.c | 22 +++-------------------
 drivers/scsi/sg.c         | 22 ++--------------------
 2 files changed, 5 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 729e309e6034..2d20da55fb64 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -449,25 +449,9 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 	if (ret < 0)
 		goto out_put_request;
 
-	ret = 0;
-	if (hdr->iovec_count && hdr->dxfer_len) {
-		struct iov_iter i;
-		struct iovec *iov = NULL;
-
-		ret = import_iovec(rq_data_dir(rq), hdr->dxferp,
-				   hdr->iovec_count, 0, &iov, &i);
-		if (ret < 0)
-			goto out_put_request;
-
-		/* SG_IO howto says that the shorter of the two wins */
-		iov_iter_truncate(&i, hdr->dxfer_len);
-
-		ret = blk_rq_map_user_iov(rq->q, rq, NULL, &i, GFP_KERNEL);
-		kfree(iov);
-	} else if (hdr->dxfer_len)
-		ret = blk_rq_map_user(rq->q, rq, NULL, hdr->dxferp,
-				      hdr->dxfer_len, GFP_KERNEL);
-
+	ret = blk_rq_map_user_io(rq, NULL, hdr->dxferp, hdr->dxfer_len,
+			GFP_KERNEL, hdr->iovec_count && hdr->dxfer_len,
+			hdr->iovec_count, 0, rq_data_dir(rq));
 	if (ret)
 		goto out_put_request;
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 94c5e9a9309c..ce34a8ad53b4 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1804,26 +1804,8 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 			md->from_user = 0;
 	}
 
-	if (iov_count) {
-		struct iovec *iov = NULL;
-		struct iov_iter i;
-
-		res = import_iovec(rw, hp->dxferp, iov_count, 0, &iov, &i);
-		if (res < 0)
-			return res;
-
-		iov_iter_truncate(&i, hp->dxfer_len);
-		if (!iov_iter_count(&i)) {
-			kfree(iov);
-			return -EINVAL;
-		}
-
-		res = blk_rq_map_user_iov(q, rq, md, &i, GFP_ATOMIC);
-		kfree(iov);
-	} else
-		res = blk_rq_map_user(q, rq, md, hp->dxferp,
-				      hp->dxfer_len, GFP_ATOMIC);
-
+	res = blk_rq_map_user_io(rq, md, hp->dxferp, hp->dxfer_len,
+			GFP_ATOMIC, iov_count, iov_count, 1, rw);
 	if (!res) {
 		srp->bio = rq->bio;
 
-- 
2.25.1

