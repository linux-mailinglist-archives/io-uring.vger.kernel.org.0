Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4513220A3DA
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 19:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406627AbgFYRSm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 13:18:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37667 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406713AbgFYRSj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 13:18:39 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200625171836epoutp0429ec66b88861f67b0d3f7622a03ce44b~b2QbarzPH2771027710epoutp04X
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 17:18:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200625171836epoutp0429ec66b88861f67b0d3f7622a03ce44b~b2QbarzPH2771027710epoutp04X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593105516;
        bh=YTGGLNu4nig8Vx38SR8emuy9VTWu71Zk4LR4sgwbEjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWQf4HV8vper8LUHeQ+jOp4CXrcLH7nFUkCD9irz6+nUPu2b61XiYYYm2rFsb8OaW
         WT3J9elFDKLcK27o9DEBzBiTv3AFCNmUKvvLKrncA6AUD48uTct/N86v44N7+bWsUd
         vBfxStUtWX18afed+Co8tlMYTSQ/RFv2hN51E1WU=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200625171835epcas5p1af144de8b8e1b8d9a8c8c3cd052730d4~b2QaohFej1015710157epcas5p11;
        Thu, 25 Jun 2020 17:18:35 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.AA.09703.B6CD4FE5; Fri, 26 Jun 2020 02:18:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85~b2QZlXZ1b2484524845epcas5p2M;
        Thu, 25 Jun 2020 17:18:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200625171834epsmtrp2955a684b3710c7b060d75c15c0be5fc5~b2QZkgf342298422984epsmtrp2E;
        Thu, 25 Jun 2020 17:18:34 +0000 (GMT)
X-AuditID: b6c32a4a-4cbff700000025e7-e6-5ef4dc6b4d23
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7D.77.08382.A6CD4FE5; Fri, 26 Jun 2020 02:18:34 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200625171831epsmtip24f6edb673b9a642b3435a862c8557034~b2QXDPNZb1929619296epsmtip2k;
        Thu, 25 Jun 2020 17:18:31 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     asml.silence@gmail.com, Damien.LeMoal@wdc.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        selvakuma.s1@samsung.com, nj.shetty@samsung.com,
        javier.gonz@samsung.com, Kanchan Joshi <joshi.k@samsung.com>,
        Arnav Dawn <a.dawn@samsung.com>
Subject: [PATCH v2 1/2] fs,block: Introduce RWF_ZONE_APPEND and handling in
 direct IO path
Date:   Thu, 25 Jun 2020 22:45:48 +0530
Message-Id: <1593105349-19270-2-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsWy7bCmlm72nS9xBu/bdS1+b3vEYvF7+hRW
        izmrtjFarL7bz2bR9W8Li0Vr+zcmi9MTFjFZvGs9x2Lx+M5ndouj/9+yWUyZ1sRosfeWtsWe
        vSdZLC7vmsNmsWL7ERaLbb/nM1tcmbKI2eL1j5NsFuf/Hmd1EPbYOesuu8fmFVoel8+Wemz6
        NIndo/vqD0aPvi2rGD0+b5LzaD/QzeSx6clbpgDOKC6blNSczLLUIn27BK6Mjtv3WAreaVR8
        3zuZvYFxgmIXIyeHhICJxNbVj1m6GLk4hAR2M0q8/jyfCcL5xCjR/vchK0iVkMA3Ronj76Jg
        OnYuuMEOUbSXUWJJ91dGCOczo8T0fQ+BHA4ONgFNiQuTS0FMEQEbiZ1LVEB6mQW+Mkm8OlcC
        YgsLxEjcbTnGDGKzCKhK3Gl6xAZi8wo4S6xqeMUKsUtO4ua5TmaQMZwCLhLb7oCtlRDYwyEx
        +eh1RogaF4nfO98xQ9jCEq+Ob2GHsKUkPr/bywZhF0v8unOUGaK5g1HiesNMFoiEvcTFPX+Z
        QBYwA528fpc+xJ18Er2/n4CFJQR4JTrahCCqFSXuTXoKdZq4xMMZS6BsD4lj+/vZIKEwnVHi
        S+ML9gmMsrMQpi5gZFzFKJlaUJybnlpsWmCUl1quV5yYW1yal66XnJ+7iRGcjrS8djA+fPBB
        7xAjEwfjIUYJDmYlEd4Qt09xQrwpiZVVqUX58UWlOanFhxilOViUxHmVfpyJExJITyxJzU5N
        LUgtgskycXBKNTBJPSoV8PYUW8m4t3Drh9UmpfwNzXN1Xx/1Snh9SzX60PGOZYfcMw7eS/ba
        syPs/nVFvsWr9t51uZi2f8WDwic+6Yc+Ge5/sttGoVuN5+Mb2/UGIm9s7u7MeX60J1Tz9bl/
        XGEz3d/+23TC5caGCWvrN8hab6q3zxeZ6tZwbN63D20HJqRtbDCJKNV6qbdjsdXGc4VH1y7h
        87I4axexPZqp/3jKzYpPqvPmJDRouJfwywrEKB4Vn3R5+4S50018rqicP5MmG3Yhzyfn8NI4
        3rK42yItGoXv33HYTLe2LYs6/7xXeVb77ENdrSrz105n0+lYcrJZ6oI3Y+zXKRbVp61nVy+9
        pda+oHQms4z5TrVzSizFGYmGWsxFxYkA0VUlRrYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSvG7WnS9xBtfuq1r83vaIxeL39Cms
        FnNWbWO0WH23n82i698WFovW9m9MFqcnLGKyeNd6jsXi8Z3P7BZH/79ls5gyrYnRYu8tbYs9
        e0+yWFzeNYfNYsX2IywW237PZ7a4MmURs8XrHyfZLM7/Pc7qIOyxc9Zddo/NK7Q8Lp8t9dj0
        aRK7R/fVH4wefVtWMXp83iTn0X6gm8lj05O3TAGcUVw2Kak5mWWpRfp2CVwZHbfvsRS806j4
        vncyewPjBMUuRk4OCQETiZ0LbrB3MXJxCAnsZpS4OGEmO0RCXKL52g8oW1hi5b/nUEUfGSW+
        PDnK1sXIwcEmoClxYXIpSI2IgINE1/HHTCA1zALtzBIPls5gBKkRFoiS2L45C6SGRUBV4k7T
        IzYQm1fAWWJVwytWiPlyEjfPdTKDlHMKuEhsu8MOYgoBlZx+qjCBkW8BI8MqRsnUguLc9Nxi
        wwLDvNRyveLE3OLSvHS95PzcTYzgWNDS3MG4fdUHvUOMTByMhxglOJiVRHhD3D7FCfGmJFZW
        pRblxxeV5qQWH2KU5mBREue9UbgwTkggPbEkNTs1tSC1CCbLxMEp1cDUcTGzLePUV9vZr6Rf
        OyTGXjw06cna7fMm78t32jDFWP2r1HrHCTrSnEmnRRzWtDayGCabXtzQcprrzqsD69ZF1+1X
        2rw3SyTbKWPPPV/BmU/PbOizfHxPqqunXeDSjLvexreubCqdst16t9m9y7NCIm2SShS6zvAv
        YBZvmj5Lqlev2UjWUHCPfdo30+i0hw0C8xSZX+Vq8K7ly9vM4H7dftrpiE1xitkl0mcatjjw
        lSxb6iLxSGvH1oL9rHf3fa38/HTZ1d+n3r7Nr841vyq34p7fQxY2v8sr7u5fn1Wp+PFEQug7
        02amfsmHwQ/dQy8y2d9M/DFdKNqS+2BZhmK39hHX4zYJi5en8hS4a/5QYinOSDTUYi4qTgQA
        BhpFJPQCAAA=
X-CMS-MailID: 20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
        <CGME20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85@epcas5p2.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce RWF_ZONE_APPEND flag to represent zone-append. User-space
sends this with write. Add IOCB_ZONE_APPEND which is set in
kiocb->ki_flags on receiving RWF_ZONE_APPEND.
Make direct IO submission path use IOCB_ZONE_APPEND to send bio with
append op. Direct IO completion returns zone-relative offset, in sector
unit, to upper layer using kiocb->ki_complete interface.
Report error if zone-append is requested on regular file or on sync
kiocb (i.e. one without ki_complete).

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Arnav Dawn <a.dawn@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 fs/block_dev.c          | 28 ++++++++++++++++++++++++----
 include/linux/fs.h      |  9 +++++++++
 include/uapi/linux/fs.h |  5 ++++-
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 47860e5..5180268 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -185,6 +185,10 @@ static unsigned int dio_bio_write_op(struct kiocb *iocb)
 	/* avoid the need for a I/O completion work item */
 	if (iocb->ki_flags & IOCB_DSYNC)
 		op |= REQ_FUA;
+
+	if (iocb->ki_flags & IOCB_ZONE_APPEND)
+		op |= REQ_OP_ZONE_APPEND;
+
 	return op;
 }
 
@@ -295,6 +299,14 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool wait)
 	return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);
 }
 
+static inline long blkdev_bio_end_io_append(struct bio *bio)
+{
+	sector_t zone_sectors = blk_queue_zone_sectors(bio->bi_disk->queue);
+
+	/* calculate zone relative offset for zone append */
+	return bio->bi_iter.bi_sector & (zone_sectors - 1);
+}
+
 static void blkdev_bio_end_io(struct bio *bio)
 {
 	struct blkdev_dio *dio = bio->bi_private;
@@ -307,15 +319,19 @@ static void blkdev_bio_end_io(struct bio *bio)
 		if (!dio->is_sync) {
 			struct kiocb *iocb = dio->iocb;
 			ssize_t ret;
+			long res2 = 0;
 
 			if (likely(!dio->bio.bi_status)) {
 				ret = dio->size;
 				iocb->ki_pos += ret;
+
+				if (iocb->ki_flags & IOCB_ZONE_APPEND)
+					res2 = blkdev_bio_end_io_append(bio);
 			} else {
 				ret = blk_status_to_errno(dio->bio.bi_status);
 			}
 
-			dio->iocb->ki_complete(iocb, ret, 0);
+			dio->iocb->ki_complete(iocb, ret, res2);
 			if (dio->multi_bio)
 				bio_put(&dio->bio);
 		} else {
@@ -382,6 +398,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		bio->bi_private = dio;
 		bio->bi_end_io = blkdev_bio_end_io;
 		bio->bi_ioprio = iocb->ki_ioprio;
+		bio->bi_opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb);
 
 		ret = bio_iov_iter_get_pages(bio, iter);
 		if (unlikely(ret)) {
@@ -391,11 +408,9 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		}
 
 		if (is_read) {
-			bio->bi_opf = REQ_OP_READ;
 			if (dio->should_dirty)
 				bio_set_pages_dirty(bio);
 		} else {
-			bio->bi_opf = dio_bio_write_op(iocb);
 			task_io_account_write(bio->bi_iter.bi_size);
 		}
 
@@ -465,12 +480,17 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 static ssize_t
 blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
+	bool is_sync = is_sync_kiocb(iocb);
 	int nr_pages;
 
+	/* zone-append is supported only on async-kiocb */
+	if (is_sync && iocb->ki_flags & IOCB_ZONE_APPEND)
+		return -EINVAL;
+
 	nr_pages = iov_iter_npages(iter, BIO_MAX_PAGES + 1);
 	if (!nr_pages)
 		return 0;
-	if (is_sync_kiocb(iocb) && nr_pages <= BIO_MAX_PAGES)
+	if (is_sync && nr_pages <= BIO_MAX_PAGES)
 		return __blkdev_direct_IO_simple(iocb, iter, nr_pages);
 
 	return __blkdev_direct_IO(iocb, iter, min(nr_pages, BIO_MAX_PAGES));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6c4ab4d..3202d9a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -315,6 +315,7 @@ enum rw_hint {
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
+#define IOCB_ZONE_APPEND	(1 << 8)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -3456,6 +3457,14 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
 		ki->ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
 	if (flags & RWF_APPEND)
 		ki->ki_flags |= IOCB_APPEND;
+	if (flags & RWF_ZONE_APPEND) {
+		/* currently support block device only */
+		umode_t mode = file_inode(ki->ki_filp)->i_mode;
+
+		if (!(S_ISBLK(mode)))
+			return -EOPNOTSUPP;
+		ki->ki_flags |= IOCB_ZONE_APPEND;
+	}
 	return 0;
 }
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 379a612..1ce06e9 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -299,8 +299,11 @@ typedef int __bitwise __kernel_rwf_t;
 /* per-IO O_APPEND */
 #define RWF_APPEND	((__force __kernel_rwf_t)0x00000010)
 
+/* per-IO O_APPEND */
+#define RWF_ZONE_APPEND	((__force __kernel_rwf_t)0x00000020)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
-			 RWF_APPEND)
+			 RWF_APPEND | RWF_ZONE_APPEND)
 
 #endif /* _UAPI_LINUX_FS_H */
-- 
2.7.4

