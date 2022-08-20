Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8292359AAE2
	for <lists+io-uring@lfdr.de>; Sat, 20 Aug 2022 05:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243991AbiHTDRO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 23:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbiHTDRM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 23:17:12 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B28EA887
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 20:17:09 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220820031708epoutp029bf8b03e0f71032d21d1985ff6dcd671~M70GzpxWh2827628276epoutp021
        for <io-uring@vger.kernel.org>; Sat, 20 Aug 2022 03:17:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220820031708epoutp029bf8b03e0f71032d21d1985ff6dcd671~M70GzpxWh2827628276epoutp021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660965428;
        bh=luIncdN4Xs0/S1pPktHEcbVCfvwuJAGRaiPlDpqB9Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0JlCQL1Gvtl1Rb4UgjosPRCm6oChBy7EPne4U67p1MV4iFiYZkktBpHcSODy/Or2
         MIe+w69xU/rOWb0+Zv96fRwB+BeXhfIYLr71qz5Z/Fl1/O6ybFNZMGW9dBNGD1rsI+
         050025C1dhiypH0muphV0Lku8yQX1YaBC3lWSTEA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220820031707epcas5p1288fc8fde2342ece5e5582cebd57a4fd~M70GU37Pf0245602456epcas5p1B;
        Sat, 20 Aug 2022 03:17:07 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4M8kLn1tH6z4x9Pp; Sat, 20 Aug
        2022 03:17:05 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3A.75.09494.13250036; Sat, 20 Aug 2022 12:17:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220820031704epcas5p36bf7895aa5e5f8d43384c6de355a70bc~M70DplPqD1841318413epcas5p3I;
        Sat, 20 Aug 2022 03:17:04 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220820031704epsmtrp24667b060f651df782d8b9563e264c33b~M70DorJJY0249702497epsmtrp2M;
        Sat, 20 Aug 2022 03:17:04 +0000 (GMT)
X-AuditID: b6c32a4a-201ff70000012516-98-63005231faad
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.12.08802.03250036; Sat, 20 Aug 2022 12:17:04 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220820031703epsmtip13fce5cd82c118468e6b34361096d3549~M70CN-qLp1949119491epsmtip1W;
        Sat, 20 Aug 2022 03:17:03 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v2 1/4] io_uring: introduce
 io_uring_cmd_import_fixed
Date:   Sat, 20 Aug 2022 08:36:17 +0530
Message-Id: <20220820030620.59003-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220820030620.59003-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmhq5hEEOyQVMnl0XThL/MFqvv9rNZ
        3Dywk8li5eqjTBbvWs+xWBz9/5bNYtKha4wWe29pW8xf9pTd4tDkZiYHLo/LZ0s9Nq3qZPPY
        vKTeY/fNBjaP9/uusnn0bVnF6PF5k1wAe1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
        rqGlhbmSQl5ibqqtkotPgK5bZg7QcUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpSc
        ApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IwnryILzvNXtK7tYGpgnMTbxcjBISFgItHy2LqL
        kYtDSGA3o8T84z3MEM4nRolVn/6zQjifGSVePWxm6WLkBOvYurWXHSKxi1HifsceNriq55t+
        sYLMZRPQlLgwuRSkQUTASGL/p5Ngk5gFLjBKnGz6ygySEBYIkDgzfQEjiM0ioCpx4exPVhCb
        V8BC4veEA+wQ2+QlZl76DmZzClhKNC3/zQhRIyhxcuYTsIuYgWqat84Gu1tCoJVDYsfi94wQ
        zS4SjYcXMEPYwhKvjm+BGiol8fndXjYIO1ni0sxzTBB2icTjPQehbHuJ1lP9zCDPMAM9s36X
        PsQuPone30+YIGHHK9HRJgRRrShxb9JTVghbXOLhjCVQtofEhgmvoeHTwyjxuHMi2wRG+VlI
        XpiF5IVZCNsWMDKvYpRMLSjOTU8tNi0wyksth8drcn7uJkZwEtXy2sH48MEHvUOMTByMhxgl
        OJiVRHhv3PmTJMSbklhZlVqUH19UmpNafIjRFBjGE5mlRJPzgWk8ryTe0MTSwMTMzMzE0tjM
        UEmc1+vqpiQhgfTEktTs1NSC1CKYPiYOTqkGJm6X/W58JY7tssz7Pzx8u1xdOnX1iU9b+A9I
        fd93Wlmo/ntjvVBNIu+OjX8FNgVvKJxipbT/d8GfmmPnvmT92TorN3TTpdnHlr1+zfRF/72d
        48qST87bmi+sU5804VOxLccf0bXSfhHm3c7zHmQceOBc+lGmT1zAauPUDS9X2upvn65Q6zMn
        vWia9jGBXrdibqNmvsiDzcfKnol25W3/zp4/Key4+PH6ezP5BI43xTYufBXyprv2xYzYB8wf
        wvX0NlXLeXKYycQ8sE/59CUtu6L6g+TLt9Lu2wM619Zt3aeXGxhgc0wmqm1VqI56hp3VCbvd
        m5iLjoa0sO77br9WSq58eRfvDVutE315x/LNlFiKMxINtZiLihMBzhCIyisEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWy7bCSnK5BEEOyQds/ZYumCX+ZLVbf7Wez
        uHlgJ5PFytVHmSzetZ5jsTj6/y2bxaRD1xgt9t7Stpi/7Cm7xaHJzUwOXB6Xz5Z6bFrVyeax
        eUm9x+6bDWwe7/ddZfPo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujCevIgvO81e0ru1gamCc
        xNvFyMkhIWAisXVrLzuILSSwg1Hi6hlZiLi4RPO1H+wQtrDEyn/PgWwuoJqPjBJNHe9Zuxg5
        ONgENCUuTC4FqRERMJNYengNC4jNLHCDUWLbhHwQW1jAT+LX+71sIDaLgKrEhbM/WUFsXgEL
        id8TDkDNl5eYeek7mM0pYCnRtPw3I8Q9FhLPZ79gg6gXlDg58wnUfHmJ5q2zmScwCsxCkpqF
        JLWAkWkVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZw8Gtp7WDcs+qD3iFGJg7GQ4wS
        HMxKIrw37vxJEuJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNT
        qoEpoSxvps+qc4Z8Zea/3EPW73l7JknP4s9Ns7OF1lxFj1acXNC9/rLFAeY9vban+dmLwwob
        39z8J17xRipX0mPmc8tjl+pnqTBe4OmtCWJZuUj1e+RugU+nqo9mO/07dWp61JZ3b3ZuSC3V
        LFX5qTFDmHOfROo8hrL9Srdm3PsZsvHDPY3TL006Ft5pXXhOkfP4tbvNU58LHtynyLWiX/Ph
        Lq/AiUEVjJkugQ3aXvLL932seRW06Grm518z1LM3/ljD2xwnfPXtPotl7V+6XzI+W7mJd4XU
        40KnhxaWHwq084/W7lN4lLLsiHXSd7mj038InfnIXjk3zEPed3WG51lzf8vWtpg98lUagY2W
        TZ+MlFiKMxINtZiLihMBigT5PO0CAAA=
X-CMS-MailID: 20220820031704epcas5p36bf7895aa5e5f8d43384c6de355a70bc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220820031704epcas5p36bf7895aa5e5f8d43384c6de355a70bc
References: <20220820030620.59003-1-joshi.k@samsung.com>
        <CGME20220820031704epcas5p36bf7895aa5e5f8d43384c6de355a70bc@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

This is a new helper that callers can use to obtain a bvec iterator for
the previously mapped buffer. This is preparatory work to enable
fixed-buffer support for io_uring_cmd.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/io_uring.h |  7 +++++++
 io_uring/uring_cmd.c     | 10 ++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 58676c0a398f..60aba10468fc 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -32,6 +32,8 @@ struct io_uring_cmd {
 };
 
 #if defined(CONFIG_IO_URING)
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+		struct iov_iter *iter, void *ioucmd)
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *));
@@ -59,6 +61,11 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+		struct iov_iter *iter, void *ioucmd)
+{
+	return -1;
+}
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		ssize_t ret2)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8900856fa588..ff65cc8ab6cc 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -121,3 +121,13 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
+
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len,
+		int rw, struct iov_iter *iter, void *ioucmd)
+{
+	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
+	struct io_mapped_ubuf *imu = req->imu;
+
+	return io_import_fixed(rw, iter, imu, ubuf, len);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
-- 
2.25.1

