Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D943E157E
	for <lists+io-uring@lfdr.de>; Thu,  5 Aug 2021 15:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241690AbhHENQJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Aug 2021 09:16:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48180 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241687AbhHENQI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Aug 2021 09:16:08 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210805131552epoutp044633f60f5c9895d940a7901ba83b6bfd~Ya2Ztplsd1866118661epoutp04I
        for <io-uring@vger.kernel.org>; Thu,  5 Aug 2021 13:15:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210805131552epoutp044633f60f5c9895d940a7901ba83b6bfd~Ya2Ztplsd1866118661epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628169353;
        bh=8mgNUqK5xC19AK6FuLtTxaLPmXTM+oRg5NY7JJhIVTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSAc+wMbZrDHswUi/nG/QnjR8COKORHCWjf94hWTwou2GNRvfdkdJC100Fc/iXRvH
         0yAGZylQ1gnSFPCL7v3ii6koQFotKS8c2oUGLfVM60uvwKDsl/PuYDzZrX9Bj3o6G2
         1BBZWPz5g1Sxqid9DInkbRVlmJf3XPL3RgJKtJUU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210805131551epcas5p383f73278557d321e8076399704b6ce5f~Ya2Ya4p8z1990619906epcas5p39;
        Thu,  5 Aug 2021 13:15:51 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GgTd00HR2z4x9Pr; Thu,  5 Aug
        2021 13:15:48 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D9.2F.09595.384EB016; Thu,  5 Aug 2021 22:15:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210805125917epcas5p4f75c9423a7b886dc79500901cc8f55ab~Yan6807rz1331413314epcas5p4W;
        Thu,  5 Aug 2021 12:59:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210805125917epsmtrp28066451799d8e55b4dd82358909e3cbe~Yan68Fg6B2066920669epsmtrp26;
        Thu,  5 Aug 2021 12:59:17 +0000 (GMT)
X-AuditID: b6c32a4a-ed5ff7000000257b-4e-610be4834b5e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        CC.84.32548.5A0EB016; Thu,  5 Aug 2021 21:59:17 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210805125916epsmtip1de40eaff5777bc75236bb0676629dd0a~Yan5W1itq0981609816epsmtip1P;
        Thu,  5 Aug 2021 12:59:16 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com, hare@suse.de,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 1/6] io_uring: add infra for uring_cmd completion in
 submitter-task.
Date:   Thu,  5 Aug 2021 18:25:34 +0530
Message-Id: <20210805125539.66958-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210805125539.66958-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmpm7zE+5Eg887DSyaJvxltlh9t5/N
        Ys+iSUwWK1cfZbJ413qOxeLxnc/sFkf/v2WzmHToGqPF/GVP2S2uTFnE7MDlcflsqcemVZ1s
        HpuX1HvsvtnA5tG3ZRWjx+bT1R6fN8kFsEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
        6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJ
        KTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM7YfuIaU0GvSEXP7gtsDYy/BboYOTkkBEwk5u9Z
        xdbFyMUhJLCbUeLLxsfsEM4nRol75xuYIJzPjBITvq5k7mLkAGtZfcEOpFtIYBdQ0W5HuJrW
        NXPYQGrYBDQlLkwuBakRETCS2P/pJCtIDbPAIkaJrfd/M4MkhAWiJKbv+QhWzyKgKjHjuCNI
        mFfAQuL/i5eMENfJS8y89J0dxOYUsJT4fGgvK0SNoMTJmU9YQGxmoJrmrbOZIeo7OSSm3vWF
        sF0kOjZOZoKwhSVeHd/CDmFLSXx+t5cNwi6W+HXnKDPIbRICHYwS1xtmskAk7CUu7vnLBHIb
        M9Av63fpQ4RlJaaeWscEsZdPovf3E6j5vBI75sHYihL3Jj1lhbDFJR7OWAJle0g0L2lkgYRV
        D6NEz7kXTBMYFWYh+WcWkn9mIaxewMi8ilEytaA4Nz212LTAKC+1HB7Hyfm5mxjByVXLawfj
        wwcf9A4xMnEwHmKU4GBWEuFNXsyVKMSbklhZlVqUH19UmpNafIjRFBjeE5mlRJPzgek9ryTe
        0MTSwMTMzMzE0tjMUEmclz3+a4KQQHpiSWp2ampBahFMHxMHp1QDU9JxeUlLnvon1nMd38eu
        6YwUPbr+Iu905cgXvPFyoQKFSfMa/T1D7psp9yktzMqZ+Dn08OzlzWKayqbn0i7FTlYx/br8
        29SpjaF7y9odn7QsfM4SdPe2Mn+5vKqQW3WkSxjD4+nzRVxjS+QOiNsWzvkpZpthyOi+X2a/
        hmRc14t7J3d4Lc5jklN/sDGm55a35tNLhzteJb84bHzoaH/AjcRZBbbv0+vr76p+sXa50hYw
        5UvVjLd9e46u+L50xeVJvKqbNl2Xf7vp79odjif2mvTF+hmcNe9UTNnMVzB5q6CpX5fRyvwg
        0w0lz7ef9Dn9OHeF7ncJFyG2f9ImNjmWdy9rlXLe7F1x787ZyVwFSizFGYmGWsxFxYkAxpGq
        aTcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWy7bCSnO7SB9yJBo+/aVs0TfjLbLH6bj+b
        xZ5Fk5gsVq4+ymTxrvUci8XjO5/ZLY7+f8tmMenQNUaL+cuesltcmbKI2YHL4/LZUo9NqzrZ
        PDYvqffYfbOBzaNvyypGj82nqz0+b5ILYI/isklJzcksSy3St0vgyth+4hpTQa9IRc/uC2wN
        jL8Fuhg5OCQETCRWX7DrYuTiEBLYwSgx6eM+9i5GTqC4uETztR9QtrDEyn/P2SGKPjJKnN67
        lh2kmU1AU+LC5FKQGhEBM4mlh9ewgNQwC6xglNjd95sRJCEsECHxpL+RFaSeRUBVYsZxR5Aw
        r4CFxP8XLxkh5stLzLz0HWwXp4ClxOdDe8HKhYBqZm6NgCgXlDg58wkLiM0MVN68dTbzBEaB
        WUhSs5CkFjAyrWKUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECA5+La0djHtWfdA7xMjE
        wXiIUYKDWUmEN3kxV6IQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotg
        skwcnFINTKyujg9uHX8cczK1MIzhvuHz9LTe1GSjI/sfGt/2Ud095blaFvtfXy5DZt7fh3QU
        1p2MOz3B4bBbedvRQ3v0fvPtjqhew71w87wPb6Ue33VPmaB84VaAwYE/hTFLbe7fXeZTtGOx
        7PTIhsDVGzljpZtf2K99V/hsz2KuuuMn+bgnR2fkmurERdnITOQ1bDfKCHrTlhTOltG8IqLi
        DqPD1QvpZv+nnHxzIma70vZaAd5DVzV2H0y0Lg//3yD3cK9N6swdSwo3P2A3dzNkesf+c3Pe
        tujYv0mctt2Pcg14r/7Ri0qIm+mXaLHi2ZOw5zodop7Re//laVnsnbQg0KPJZUM6k6pIm+6z
        hRM83zFqK7EUZyQaajEXFScCAG+cx9HtAgAA
X-CMS-MailID: 20210805125917epcas5p4f75c9423a7b886dc79500901cc8f55ab
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210805125917epcas5p4f75c9423a7b886dc79500901cc8f55ab
References: <20210805125539.66958-1-joshi.k@samsung.com>
        <CGME20210805125917epcas5p4f75c9423a7b886dc79500901cc8f55ab@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Completion of a uring_cmd ioctl may involve referencing certain
ioctl-specific fields, requiring original submitter context.
Export an API that driver can use for this purpose.
The API facilitates reusing task-work infra of io_uring, while driver
gets to implement cmd-specific handling in a callback.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/io_uring.c            | 16 ++++++++++++++++
 include/linux/io_uring.h |  8 ++++++++
 2 files changed, 24 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 481ebd20352c..b73bc16c3e70 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2041,6 +2041,22 @@ static void io_req_task_submit(struct io_kiocb *req)
 	mutex_unlock(&ctx->uring_lock);
 }
 
+static void io_uring_cmd_work(struct io_kiocb *req)
+{
+	req->uring_cmd.driver_cb(&req->uring_cmd);
+}
+
+void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *))
+{
+	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
+
+	req->uring_cmd.driver_cb = driver_cb;
+	req->io_task_work.func = io_uring_cmd_work;
+	io_req_task_work_add(req);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
+
 static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
 	req->result = ret;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index ea20c16f9a64..235d1603f97e 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -14,11 +14,15 @@ struct io_uring_cmd {
 	__u16		op;
 	__u16		unused;
 	__u32		len;
+	/* used if driver requires update in task context*/
+	void (*driver_cb)(struct io_uring_cmd *cmd);
 	__u64		pdu[5];	/* 40 bytes available inline for free use */
 };
 
 #if defined(CONFIG_IO_URING)
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret);
+void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *));
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(struct files_struct *files);
 void __io_uring_free(struct task_struct *tsk);
@@ -41,6 +45,10 @@ static inline void io_uring_free(struct task_struct *tsk)
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
 {
 }
+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *))
+{
+}
 static inline struct sock *io_uring_get_socket(struct file *file)
 {
 	return NULL;
-- 
2.25.1

