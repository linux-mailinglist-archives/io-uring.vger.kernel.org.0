Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6E350B5C7
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 12:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446973AbiDVLBG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 07:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245078AbiDVLBF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 07:01:05 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E195623C
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 03:58:11 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220422105809epoutp017fac8a4b6e0d21950d534bf02c3c9907~oMsYE_xSj3169631696epoutp01D
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 10:58:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220422105809epoutp017fac8a4b6e0d21950d534bf02c3c9907~oMsYE_xSj3169631696epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1650625089;
        bh=wSban962LSknykig1+Yye9ZUnqSBjf+ro2Nmaj/db/M=;
        h=From:To:Cc:Subject:Date:References:From;
        b=sdoJl4qWxQ2QSucmsEFuW2oMAT0VUgwA42dfAt6eQv2BSUjQsEkynexRtwT3Yoll5
         sQsr9bhe/HzTz53CutyCBF3ZfRJtoUoeCcomLQBy2ud8pSuclDDg76ddEpvHLwcGC1
         ncaDqcHOi4UWLG6c6XuDj74Vm0W+6SVWDJ/Y/KJ4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220422105809epcas5p19209f0dbe9e0fff827d74f51b6b082fe~oMsX4tR0N2944029440epcas5p1F;
        Fri, 22 Apr 2022 10:58:09 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KlBG657mqz4x9Py; Fri, 22 Apr
        2022 10:58:06 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.0A.06423.E3A82626; Fri, 22 Apr 2022 19:58:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220422101608epcas5p22e9c82eb1b3beef6bf6e1c2e83b4b19b~oMHso1LIm2025120251epcas5p2u;
        Fri, 22 Apr 2022 10:16:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220422101608epsmtrp2b99d7abc4a019c0b855a0b1f10cdbdf0~oMHsoNh3c2966929669epsmtrp2E;
        Fri, 22 Apr 2022 10:16:08 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-77-62628a3e7885
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6D.4F.03370.86082626; Fri, 22 Apr 2022 19:16:08 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220422101608epsmtip22be50ab41f36c26835a9d3366efe29bd~oMHr7hMk42944029440epsmtip2D;
        Fri, 22 Apr 2022 10:16:08 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Cc:     hch@lst.de
Subject: [PATCH] io_uring: cleanup error-handling around io_req_complete
Date:   Fri, 22 Apr 2022 15:40:48 +0530
Message-Id: <20220422101048.419942-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7bCmuq5dV1KSweNf8har7/azWaxcfZTJ
        4l3rORYHZo/LZ0s9dt9sYPP4vEkugDkq2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ
        0sJcSSEvMTfVVsnFJ0DXLTMHaI+SQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8Ck
        QK84Mbe4NC9dLy+1xMrQwMDIFKgwITtj++5v7AW/lSsaO04wNzB+k+li5OSQEDCROHv2KFsX
        IxeHkMBuRolJr5qZIZxPjBIHfr2Hcj4zSnTdO8gG03J8/TFGiMQuRonGEy+Y4Kr2f7oK1MLB
        wSagKXFhcilIg4iArsTW6zcYQWxmAT6Jaxv2gg0SFvCQmH5kEROIzSKgKjH9cjeYzStgKfFp
        5iaoZfISMy99Z4eIC0qcnPmEBWKOvETz1tlg10kILGKXuL2ukwWiwUVixoqF7BC2sMSr41ug
        bCmJz+/2Qg1Nlmjdfpkd5E4JgRKJJQvUIcL2Ehf3/GUCCTMDnb9+lz5EWFZi6ql1TDDn9/5+
        wgQR55XYMQ/GVpS4N+kpK4QtLvFwxhIo20Pi6b3PYLaQQKzE5cVTWCYwys9C8s0sJN/MQti8
        gJF5FaNkakFxbnpqsWmBYV5qOTxek/NzNzGCU5uW5w7Guw8+6B1iZOJgPMQowcGsJMIbOjM+
        SYg3JbGyKrUoP76oNCe1+BCjKTCIJzJLiSbnA5NrXkm8oYmlgYmZmZmJpbGZoZI47+n0DYlC
        AumJJanZqakFqUUwfUwcnFINTAqWeVqqBbt2Vuz9v/SXsQbXexbDz5fPtrdnBZp6cvlvUJd4
        5L3zwNkfRa3HNsny3irkP7clSHBRc3Irf+eys7cfp0seqLY68fhKsWWBkcpb+9Lvpzv6s/id
        5i+ZPOmVBtvLmZydRnUuF1IlmH8GijWoCxcfzw+b9XOaSmloXsoOpzfKk+KPf05/Ib5ePWwn
        z/kvt5rzj1md9ol8vUmt8bNteYLEoohUjs8yjCVOkmZL93Cbv4n6tKDLL96tZbpuV7mki6u3
        bWy6dvyOBZ9Mri2WXMFzvGFnf57SpujAD+yMMQIOUyymBrXJdh326zool2a1cMcsxnkeqZG1
        s0qErFVduc7Plr72f7e89HwlluKMREMt5qLiRACAdKK39gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42LZdlhJXjejISnJYMMfM4vVd/vZLFauPspk
        8a71HIsDs8fls6Ueu282sHl83iQXwBzFZZOSmpNZllqkb5fAlbF99zf2gt/KFY0dJ5gbGL/J
        dDFyckgImEgcX3+MsYuRi0NIYAejxNL/x9ghEuISzdd+QNnCEiv/PWeHKPrIKLH5/k2mLkYO
        DjYBTYkLk0tBakQE9CX2NX5gAbGZBfgkrm3YywZiCwt4SEw/sogJxGYRUJWYfrkbzOYVsJT4
        NHMTG8R8eYmZl76zQ8QFJU7OfAI1R16ieets5gmMfLOQpGYhSS1gZFrFKJlaUJybnltsWGCU
        l1quV5yYW1yal66XnJ+7iREcZlpaOxj3rPqgd4iRiYPxEKMEB7OSCG/ozPgkId6UxMqq1KL8
        +KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODilGpjkrn2bbrQxZ/Gj7VNMhWf4
        d17gz5eLZZzCwzCRUcnkZew28fKejx/PCs3mNI49UFIR1uZpJpKd5rOS81ngNfeKwnbbzL9z
        pxr9DfRJsnFY1j2DaalL8/XczpaX+5bcOd7w2jrm1sy7P9/J8KmIVfv1Xtm1O2n3kf/1je0y
        83xnOad6/N+V877DeIeJe7RmWN77kktrY2KMuURu8PGrKRlx7gtb23PholP/jCN9fetqZ4Yo
        PdeManwcvuZ9i+IE68lFzP5TtTmdHycePXyqWpBzdXbEJ2MXc/X0zbWizQdbpT7NmGZx+lje
        2w2rBBI87V+9msB8evoyyUVtVv+ntzm4h8299OTk///90xe9DlFiKc5INNRiLipOBABRgBus
        ogIAAA==
X-CMS-MailID: 20220422101608epcas5p22e9c82eb1b3beef6bf6e1c2e83b4b19b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220422101608epcas5p22e9c82eb1b3beef6bf6e1c2e83b4b19b
References: <CGME20220422101608epcas5p22e9c82eb1b3beef6bf6e1c2e83b4b19b@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move common error-handling to io_req_complete, so that various callers
avoid repeating that. Few callers (io_tee, io_splice) require slightly
different handling. These are changed to use __io_req_complete instead.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/io_uring.c | 34 +++++-----------------------------
 1 file changed, 5 insertions(+), 29 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2052a796436c..fcbe885a3175 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2287,6 +2287,8 @@ static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
 
 static inline void io_req_complete(struct io_kiocb *req, s32 res)
 {
+	if (res < 0)
+		req_set_fail(req);
 	__io_req_complete(req, 0, res, 0);
 }
 
@@ -4214,8 +4216,6 @@ static int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
 				ren->newpath, ren->flags);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
-		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -4236,9 +4236,6 @@ static void io_xattr_finish(struct io_kiocb *req, int ret)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	__io_xattr_finish(req);
-	if (ret < 0)
-		req_set_fail(req);
-
 	io_req_complete(req, ret);
 }
 
@@ -4514,8 +4511,6 @@ static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 		ret = do_unlinkat(un->dfd, un->filename);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
-		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -4557,8 +4552,6 @@ static int io_mkdirat(struct io_kiocb *req, unsigned int issue_flags)
 	ret = do_mkdirat(mkd->dfd, mkd->filename, mkd->mode);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
-		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -4606,8 +4599,6 @@ static int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags)
 	ret = do_symlinkat(sl->oldpath, sl->new_dfd, sl->newpath);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
-		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -4657,8 +4648,6 @@ static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 				lnk->newpath, lnk->flags);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
-		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -4694,8 +4683,6 @@ static int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
 		return -ENOTSOCK;
 
 	ret = __sys_shutdown_sock(sock, req->shutdown.how);
-	if (ret < 0)
-		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 #else
@@ -4756,7 +4743,7 @@ static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 done:
 	if (ret != sp->len)
 		req_set_fail(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, 0, ret, 0);
 	return 0;
 }
 
@@ -4801,7 +4788,7 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 done:
 	if (ret != sp->len)
 		req_set_fail(req);
-	io_req_complete(req, ret);
+	__io_req_complete(req, 0, ret, 0);
 	return 0;
 }
 
@@ -4888,8 +4875,6 @@ static int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 	ret = vfs_fsync_range(req->file, req->sync.off,
 				end > 0 ? end : LLONG_MAX,
 				req->sync.flags & IORING_FSYNC_DATASYNC);
-	if (ret < 0)
-		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -4918,9 +4903,7 @@ static int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
 				req->sync.len);
-	if (ret < 0)
-		req_set_fail(req);
-	else
+	if (ret >= 0)
 		fsnotify_modify(req->file);
 	io_req_complete(req, ret);
 	return 0;
@@ -5332,8 +5315,6 @@ static int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
-	if (ret < 0)
-		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 #else
@@ -5419,9 +5400,6 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
 		       ctx->buffer);
-
-	if (ret < 0)
-		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -5521,8 +5499,6 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = sync_file_range(req->file, req->sync.off, req->sync.len,
 				req->sync.flags);
-	if (ret < 0)
-		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
-- 
2.25.1

