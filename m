Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDEA1FD36D
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 19:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgFQR1K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 13:27:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41031 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgFQR1J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 13:27:09 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200617172705epoutp02ce10082bbddbd368de0a35c466f83e7f~ZZNi8mI3C1579015790epoutp02S
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2020 17:27:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200617172705epoutp02ce10082bbddbd368de0a35c466f83e7f~ZZNi8mI3C1579015790epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592414825;
        bh=GDO7X/pOKQXLyuzzWrlxMlTjJnzAq7Lh38N/EO1S+rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkMojGkfEhkLNJviZzM+SLn3gJ+x4bDy4Rwo/OVZgZvfye2rEgUb1kDVeSgRZUdZZ
         0ofTsvjNup9bNtCyOzqtepBeGk4vLe5zwqB7ppLNgogbBw1VYtyEH/QS0mOgiQsytt
         4Kclu0kbbeC6TAgvPzX5LOwy7caA6pXQcDayQ6L4=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200617172703epcas5p3e9ff5dda503c94b4b04ca66af6b5463a~ZZNho3aBm1731717317epcas5p3u;
        Wed, 17 Jun 2020 17:27:03 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BE.66.09475.7625AEE5; Thu, 18 Jun 2020 02:27:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200617172702epcas5p4dbf4729d31d9a85ab1d261d04f238e61~ZZNgh9iRQ0132401324epcas5p4e;
        Wed, 17 Jun 2020 17:27:02 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200617172702epsmtrp120faf98315f32fc623eea2f8ff5d60b9~ZZNghDb6w1872618726epsmtrp1A;
        Wed, 17 Jun 2020 17:27:02 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-2d-5eea52672a81
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BA.2C.08382.6625AEE5; Thu, 18 Jun 2020 02:27:02 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200617172700epsmtip14cd840243725f84066880e1b97cbd725~ZZNeh0t7E0930109301epsmtip1R;
        Wed, 17 Jun 2020 17:27:00 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 1/3] fs,block: Introduce IOCB_ZONE_APPEND and direct-io
 handling
Date:   Wed, 17 Jun 2020 22:53:37 +0530
Message-Id: <1592414619-5646-2-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWy7bCmlm560Ks4g1VNBhar7/azWXT928Ji
        8a71HIvF4zuf2S2O/n/LZrFw4zImiynTmhgt9t7Sttiz9ySLxeVdc9gstv2ez2xxZcoiZovX
        P06yWZz/e5zVgc/j8tlSj02fJrF79G1ZxejxeZOcx6Ynb5kCWKO4bFJSczLLUov07RK4MvZ/
        usNW8Fy4oufuC+YGxiaBLkYODgkBE4kDL6y7GLk4hAR2M0q8Xt7ECuF8YpTonLAAyvnGKHH7
        wl32LkZOsI67h9cyQiT2MkpM2HiLCcL5zCjxcuceJpC5bAKaEhcml4KYIgI2EjuXqID0Mgs0
        MEn8/64DYgsLBEk8WnKaGcRmEVCV+P/6HiOIzSvgJPHg6SIWiF1yEjfPdYLVcAo4S8zefAns
        IAmBRg6JrXtfM0IUuUi8fbiVFcIWlnh1fAvUoVISL/vboOxiiV93jjJDNHcwSlxvmAm1wV7i
        4p6/YDczA928fpc+xKF8Er2/nzBBgohXoqNNCKJaUeLepKdQq8QlHs5YAmV7SCz8f5QJxBYS
        mMYo0f3UewKj7CyEoQsYGVcxSqYWFOempxabFhjnpZbrFSfmFpfmpesl5+duYgSnDS3vHYyP
        HnzQO8TIxMF4iFGCg1lJhNf594s4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxKP87ECQmkJ5ak
        ZqemFqQWwWSZODilGphiC3UW7UqavHaW4Zc71is4V16L1GNp9XjZkv/k7bv8F1XLmm65z/ny
        9qjmjI1JPoqLBKXFIzLf7ny+xWLrNO4VDgZ5e6Ntj2Y0ZzM4yl3mKwxPc/7Vk8IyQVh2lmN4
        q2Kk9EetP+e3tPBL3TO8vCvXr35C5V+mn9HNnJp660VZX7PuNco8YXnD7a9BfZ9hRMq9+RxB
        PAmrG+49mjbpccWyVRvvC5w8v8f3yN4/nAubnjt7V1dyOb1fb8wbETXPwvnsU6XqvudH1vxd
        +V7bR1S7K/mpgp2vY9OEvNYV32ZfVp2R4p9yVr8+RypqVvfVro1CvTlX9b8LnEj72mRl09su
        ITDtfMHl6neciw68DVFiKc5INNRiLipOBAAouxsVigMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWy7bCSnG5a0Ks4g5mXFC1W3+1ns+j6t4XF
        4l3rORaLx3c+s1sc/f+WzWLhxmVMFlOmNTFa7L2lbbFn70kWi8u75rBZbPs9n9niypRFzBav
        f5xkszj/9zirA5/H5bOlHps+TWL36NuyitHj8yY5j01P3jIFsEZx2aSk5mSWpRbp2yVwZez/
        dIet4LlwRc/dF8wNjE0CXYycHBICJhJ3D69l7GLk4hAS2M0o8XbdTlaIhLhE87Uf7BC2sMTK
        f8/ZIYo+Mkpcu7sAqIODg01AU+LC5FKQGhEBB4mu44+ZQGqYBbqYJE7c3MUEkhAWCJC4dOsa
        I4jNIqAq8f/1PTCbV8BJ4sHTRSwQC+Qkbp7rZAaxOQWcJWZvvgR2hBBQzZ9Fs1gnMPItYGRY
        xSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHLhamjsYt6/6oHeIkYmD8RCjBAezkgiv
        8+8XcUK8KYmVValF+fFFpTmpxYcYpTlYlMR5bxQujBMSSE8sSc1OTS1ILYLJMnFwSjUwWf9s
        P+lbwnJAaKomq5bYe1PTjVyTN7tcEs359HVrMcdGj33Hq6Wf3RI8t/2M+LKC8z8T/z9R3L8h
        csO/txeyPGbcY59zcfvE1aU191kmHdt4OD5yn+7t8+ecpycKXQx3Wth1s6Rgmv2ntoC/2RG3
        wwJzl7s+bSvTkJ53en3x040fIiSNHi/YrnLybRnDg6z/HowhH0v1fBNXxB+Ses2RweR+aLfy
        1iqDux/vdBd1p07XWNWk8k3k49JGb1ERv/eGdVP2N173ddKYve019z8R1i/37uswfy1eyO8+
        P+HZl831mWuUt+3kfq2nYZNybsHvG01fpsfOC5554tecGSXRu3+H/k3awWWQV3T5zabZpdFK
        LMUZiYZazEXFiQD71pzvywIAAA==
X-CMS-MailID: 20200617172702epcas5p4dbf4729d31d9a85ab1d261d04f238e61
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200617172702epcas5p4dbf4729d31d9a85ab1d261d04f238e61
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
        <CGME20200617172702epcas5p4dbf4729d31d9a85ab1d261d04f238e61@epcas5p4.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Selvakumar S <selvakuma.s1@samsung.com>

Introduce IOCB_ZONE_APPEND flag, which is set in kiocb->ki_flags for
zone-append. Direct I/O submission path uses this flag to send bio with
append op. And completion path uses the same to return zone-relative
offset to upper layer.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 fs/block_dev.c     | 19 ++++++++++++++++++-
 include/linux/fs.h |  1 +
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 47860e5..4c84b4d0 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -185,6 +185,10 @@ static unsigned int dio_bio_write_op(struct kiocb *iocb)
 	/* avoid the need for a I/O completion work item */
 	if (iocb->ki_flags & IOCB_DSYNC)
 		op |= REQ_FUA;
+#ifdef CONFIG_BLK_DEV_ZONED
+	if (iocb->ki_flags & IOCB_ZONE_APPEND)
+		op |= REQ_OP_ZONE_APPEND | REQ_NOMERGE;
+#endif
 	return op;
 }
 
@@ -295,6 +299,14 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool wait)
 	return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);
 }
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static inline long blkdev_bio_end_io_append(struct bio *bio)
+{
+	return (bio->bi_iter.bi_sector %
+		blk_queue_zone_sectors(bio->bi_disk->queue)) << SECTOR_SHIFT;
+}
+#endif
+
 static void blkdev_bio_end_io(struct bio *bio)
 {
 	struct blkdev_dio *dio = bio->bi_private;
@@ -307,15 +319,20 @@ static void blkdev_bio_end_io(struct bio *bio)
 		if (!dio->is_sync) {
 			struct kiocb *iocb = dio->iocb;
 			ssize_t ret;
+			long res = 0;
 
 			if (likely(!dio->bio.bi_status)) {
 				ret = dio->size;
 				iocb->ki_pos += ret;
+#ifdef CONFIG_BLK_DEV_ZONED
+				if (iocb->ki_flags & IOCB_ZONE_APPEND)
+					res = blkdev_bio_end_io_append(bio);
+#endif
 			} else {
 				ret = blk_status_to_errno(dio->bio.bi_status);
 			}
 
-			dio->iocb->ki_complete(iocb, ret, 0);
+			dio->iocb->ki_complete(iocb, ret, res);
 			if (dio->multi_bio)
 				bio_put(&dio->bio);
 		} else {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6c4ab4d..dc547b9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -315,6 +315,7 @@ enum rw_hint {
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
+#define IOCB_ZONE_APPEND	(1 << 8)
 
 struct kiocb {
 	struct file		*ki_filp;
-- 
2.7.4

