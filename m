Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABC52B124E
	for <lists+io-uring@lfdr.de>; Fri, 13 Nov 2020 00:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgKLXBM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 18:01:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53192 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgKLXBM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 18:01:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMtq9Z078975;
        Thu, 12 Nov 2020 23:01:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=4jcVc8ZUl5XpJ2DOXJAzNy4ErTqjZSoJqVa8VyQVaFQ=;
 b=npzfTsOeQ/PfY+BO36FN81ICzrSU5SZJCzO6BIe8DbzZZy4izh5ToWYtJq54WSlEgOQP
 22RZBZiWuchpVrIXSd/42XLHwsI2wHaxh40cBh9tbc2ZIL8pXIpIVDRfSfH/bUcUBWdG
 3/6qWZBMH3d0G2LLAioQdgJ2zfq/87InGsG01YOK5c++5EKsbpftOj03kM7x/pTJKBjr
 MyYC4fNu9BTsSm1MOY785XLTpkPv9vu/FJwas3S88ZMgOVhMUU1RB9+AL1i10tKV4SAW
 Rv7TocKNt8v8vaxt4M+qidK2cjUl+uYVrSB5y1x44KRsGWgZmG5/lHBEpSU3yDzINxDn Bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72ex9cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 23:01:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMpChL047888;
        Thu, 12 Nov 2020 23:01:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34rt56tv2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 23:01:09 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ACN17e7015711;
        Thu, 12 Nov 2020 23:01:07 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 15:01:07 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 1/8] io_uring: modularize io_sqe_buffer_register
Date:   Thu, 12 Nov 2020 15:00:35 -0800
Message-Id: <1605222042-44558-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=3 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=3 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120129
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split io_sqe_buffer_register into two routines:

- io_sqe_buffer_register() registers a single buffer
- io_sqe_buffers_register iterates over all user specified buffers

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 210 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 107 insertions(+), 103 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c2688b6..29aa3e1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8144,7 +8144,7 @@ static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
 	return pages;
 }
 
-static int io_sqe_buffer_unregister(struct io_ring_ctx *ctx)
+static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
 	int i, j;
 
@@ -8262,14 +8262,103 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
-static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
-				  unsigned nr_args)
+static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
+				  struct io_mapped_ubuf *imu,
+				  struct page **last_hpage)
 {
 	struct vm_area_struct **vmas = NULL;
 	struct page **pages = NULL;
+	unsigned long off, start, end, ubuf;
+	size_t size;
+	int ret, pret, nr_pages, i;
+
+	ubuf = (unsigned long) iov->iov_base;
+	end = (ubuf + iov->iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	start = ubuf >> PAGE_SHIFT;
+	nr_pages = end - start;
+
+	ret = -ENOMEM;
+
+	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		goto done;
+
+	vmas = kvmalloc_array(nr_pages, sizeof(struct vm_area_struct *),
+			      GFP_KERNEL);
+	if (!vmas)
+		goto done;
+
+	imu->bvec = kvmalloc_array(nr_pages, sizeof(struct bio_vec),
+				   GFP_KERNEL);
+	if (!imu->bvec)
+		goto done;
+
+	ret = 0;
+	mmap_read_lock(current->mm);
+	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
+			      pages, vmas);
+	if (pret == nr_pages) {
+		/* don't support file backed memory */
+		for (i = 0; i < nr_pages; i++) {
+			struct vm_area_struct *vma = vmas[i];
+
+			if (vma->vm_file &&
+			    !is_file_hugepages(vma->vm_file)) {
+				ret = -EOPNOTSUPP;
+				break;
+			}
+		}
+	} else {
+		ret = pret < 0 ? pret : -EFAULT;
+	}
+	mmap_read_unlock(current->mm);
+	if (ret) {
+		/*
+		 * if we did partial map, or found file backed vmas,
+		 * release any pages we did get
+		 */
+		if (pret > 0)
+			unpin_user_pages(pages, pret);
+		kvfree(imu->bvec);
+		goto done;
+	}
+
+	ret = io_buffer_account_pin(ctx, pages, pret, imu, last_hpage);
+	if (ret) {
+		unpin_user_pages(pages, pret);
+		kvfree(imu->bvec);
+		goto done;
+	}
+
+	off = ubuf & ~PAGE_MASK;
+	size = iov->iov_len;
+	for (i = 0; i < nr_pages; i++) {
+		size_t vec_len;
+
+		vec_len = min_t(size_t, size, PAGE_SIZE - off);
+		imu->bvec[i].bv_page = pages[i];
+		imu->bvec[i].bv_len = vec_len;
+		imu->bvec[i].bv_offset = off;
+		off = 0;
+		size -= vec_len;
+	}
+	/* store original address for later verification */
+	imu->ubuf = ubuf;
+	imu->len = iov->iov_len;
+	imu->nr_bvecs = nr_pages;
+	ret = 0;
+done:
+	kvfree(pages);
+	kvfree(vmas);
+	return ret;
+}
+
+static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
+				   unsigned int nr_args)
+{
+	int i, ret;
+	struct iovec iov;
 	struct page *last_hpage = NULL;
-	int i, j, got_pages = 0;
-	int ret = -EINVAL;
 
 	if (ctx->user_bufs)
 		return -EBUSY;
@@ -8283,14 +8372,10 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	for (i = 0; i < nr_args; i++) {
 		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
-		unsigned long off, start, end, ubuf;
-		int pret, nr_pages;
-		struct iovec iov;
-		size_t size;
 
 		ret = io_copy_iov(ctx, &iov, arg, i);
 		if (ret)
-			goto err;
+			break;
 
 		/*
 		 * Don't impose further limits on the size and buffer
@@ -8299,103 +8384,22 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 		 */
 		ret = -EFAULT;
 		if (!iov.iov_base || !iov.iov_len)
-			goto err;
+			break;
 
 		/* arbitrary limit, but we need something */
 		if (iov.iov_len > SZ_1G)
-			goto err;
-
-		ubuf = (unsigned long) iov.iov_base;
-		end = (ubuf + iov.iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		start = ubuf >> PAGE_SHIFT;
-		nr_pages = end - start;
-
-		ret = 0;
-		if (!pages || nr_pages > got_pages) {
-			kvfree(vmas);
-			kvfree(pages);
-			pages = kvmalloc_array(nr_pages, sizeof(struct page *),
-						GFP_KERNEL);
-			vmas = kvmalloc_array(nr_pages,
-					sizeof(struct vm_area_struct *),
-					GFP_KERNEL);
-			if (!pages || !vmas) {
-				ret = -ENOMEM;
-				goto err;
-			}
-			got_pages = nr_pages;
-		}
-
-		imu->bvec = kvmalloc_array(nr_pages, sizeof(struct bio_vec),
-						GFP_KERNEL);
-		ret = -ENOMEM;
-		if (!imu->bvec)
-			goto err;
-
-		ret = 0;
-		mmap_read_lock(current->mm);
-		pret = pin_user_pages(ubuf, nr_pages,
-				      FOLL_WRITE | FOLL_LONGTERM,
-				      pages, vmas);
-		if (pret == nr_pages) {
-			/* don't support file backed memory */
-			for (j = 0; j < nr_pages; j++) {
-				struct vm_area_struct *vma = vmas[j];
-
-				if (vma->vm_file &&
-				    !is_file_hugepages(vma->vm_file)) {
-					ret = -EOPNOTSUPP;
-					break;
-				}
-			}
-		} else {
-			ret = pret < 0 ? pret : -EFAULT;
-		}
-		mmap_read_unlock(current->mm);
-		if (ret) {
-			/*
-			 * if we did partial map, or found file backed vmas,
-			 * release any pages we did get
-			 */
-			if (pret > 0)
-				unpin_user_pages(pages, pret);
-			kvfree(imu->bvec);
-			goto err;
-		}
-
-		ret = io_buffer_account_pin(ctx, pages, pret, imu, &last_hpage);
-		if (ret) {
-			unpin_user_pages(pages, pret);
-			kvfree(imu->bvec);
-			goto err;
-		}
+			break;
 
-		off = ubuf & ~PAGE_MASK;
-		size = iov.iov_len;
-		for (j = 0; j < nr_pages; j++) {
-			size_t vec_len;
-
-			vec_len = min_t(size_t, size, PAGE_SIZE - off);
-			imu->bvec[j].bv_page = pages[j];
-			imu->bvec[j].bv_len = vec_len;
-			imu->bvec[j].bv_offset = off;
-			off = 0;
-			size -= vec_len;
-		}
-		/* store original address for later verification */
-		imu->ubuf = ubuf;
-		imu->len = iov.iov_len;
-		imu->nr_bvecs = nr_pages;
+		ret = io_sqe_buffer_register(ctx, &iov, imu, &last_hpage);
+		if (ret)
+			break;
 
 		ctx->nr_user_bufs++;
 	}
-	kvfree(pages);
-	kvfree(vmas);
-	return 0;
-err:
-	kvfree(pages);
-	kvfree(vmas);
-	io_sqe_buffer_unregister(ctx);
+
+	if (ret)
+		io_sqe_buffers_unregister(ctx);
+
 	return ret;
 }
 
@@ -8449,7 +8453,7 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_finish_async(ctx);
-	io_sqe_buffer_unregister(ctx);
+	io_sqe_buffers_unregister(ctx);
 
 	if (ctx->sqo_task) {
 		put_task_struct(ctx->sqo_task);
@@ -9743,13 +9747,13 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 
 	switch (opcode) {
 	case IORING_REGISTER_BUFFERS:
-		ret = io_sqe_buffer_register(ctx, arg, nr_args);
+		ret = io_sqe_buffers_register(ctx, arg, nr_args);
 		break;
 	case IORING_UNREGISTER_BUFFERS:
 		ret = -EINVAL;
 		if (arg || nr_args)
 			break;
-		ret = io_sqe_buffer_unregister(ctx);
+		ret = io_sqe_buffers_unregister(ctx);
 		break;
 	case IORING_REGISTER_FILES:
 		ret = io_sqe_files_register(ctx, arg, nr_args);
-- 
1.8.3.1

