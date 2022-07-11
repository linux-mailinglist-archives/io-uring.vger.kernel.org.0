Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA57257008D
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 13:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiGKL2u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 07:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiGKL2S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 07:28:18 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CE5A1
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 04:08:30 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220711110829epoutp02fdd2964c1639966fb4a708c99f3d9754~AwcPEmgnA3110331103epoutp02L
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 11:08:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220711110829epoutp02fdd2964c1639966fb4a708c99f3d9754~AwcPEmgnA3110331103epoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657537709;
        bh=TPokgc8KiyKiXoT7NCkFEOk/43/FQR9MxdUyRi6+mZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IiNv9mdUfdwa+nQIwKsNszwLGCQ0UpZjY40j9bhKUaNCX+D0cB4UIbNzTn8ig2Vpv
         hWAj+YzwMVxqroYQFK+IFqFCm5MTw+8tIvYIPDHeF7vjLHb4PFAFanKyO+9cKF4bap
         huiFxkAiIeXhCq8dei+GYwKebEnzbFNkhsGffBzw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220711110828epcas5p130ed5ecf71cb8427a86abc25beb9432d~AwcODpN8E1709317093epcas5p1O;
        Mon, 11 Jul 2022 11:08:28 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LhLj46SHpz4x9Pv; Mon, 11 Jul
        2022 11:08:24 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.30.09566.8A40CC26; Mon, 11 Jul 2022 20:08:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b~AwcKN9xEX2363823638epcas5p2r;
        Mon, 11 Jul 2022 11:08:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220711110824epsmtrp163c8723a98b81f7851e41ea44ecb7772~AwcKNKTnl1261612616epsmtrp1D;
        Mon, 11 Jul 2022 11:08:24 +0000 (GMT)
X-AuditID: b6c32a4a-ba3ff7000000255e-ba-62cc04a84df3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.89.08802.8A40CC26; Mon, 11 Jul 2022 20:08:24 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220711110820epsmtip2521d7a387b1bdcc51eb6f4dd6b6b3ffc~AwcG34GhO0331003310epsmtip2T;
        Mon, 11 Jul 2022 11:08:20 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     hch@lst.de, sagi@grimberg.me, kbusch@kernel.org, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next 3/4] io_uring: grow a field in struct io_uring_cmd
Date:   Mon, 11 Jul 2022 16:31:54 +0530
Message-Id: <20220711110155.649153-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220711110155.649153-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGJsWRmVeSWpSXmKPExsWy7bCmhu4KljNJBr8nGlk0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmcf7tYSaLSYeuMVrsvaVtMX/ZU3aLda/fszjw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHn1bVjF6fN4kF8ARlW2TkZqYklqkkJqX
        nJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SrkkJZYk4pUCggsbhYSd/O
        pii/tCRVISO/uMRWKbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE74/uG46wFOwUqDu15
        zdrAuJm3i5GTQ0LARGL6okusILaQwG5GiY6z9V2MXED2J0aJ5XufsEI4nxkl7q+4ywjTMXHH
        Q3aIxC5GibNHHzPDVR09vwXI4eBgE9CUuDC5FKRBRMBForNpOtgkZoG7jBINu1aDTRIW8Jbo
        +boBbDeLgKrE8n1TwXp5BSwl1jyxgFgmLzHz0nd2EJtTwEpi5vZ/YK28AoISJ2c+YQGxmYFq
        mrfOZoaon8shsfQLO4TtInHq4AwWCFtY4tXxLVBxKYmX/W1QdrLEpZnnmCDsEonHew5C2fYS
        raf6wc5hBnpl/S59iFV8Er2/nzCBhCUEeCU62oQgqhUl7k16ygphi0s8nLEEyvaQuHlrLxsk
        dHoZJTZ/es40gVF+FpIPZiH5YBbCtgWMzKsYJVMLinPTU4tNC4zyUsvh0Zqcn7uJEZxgtbx2
        MD588EHvECMTB+MhRgkOZiUR3j9nTyUJ8aYkVlalFuXHF5XmpBYfYjQFhvBEZinR5Hxgis8r
        iTc0sTQwMTMzM7E0NjNUEuf1uropSUggPbEkNTs1tSC1CKaPiYNTqoFJwlxSUF2NTSLW68Vb
        54aPz0+u+RLms5mRf+WhjPUMt7/YHBe78rLznNvtqYzK0qzPu4u7pEwnO/kvenDl8a4j+Q4y
        PhPZuZocBDqtxJ1Kma7sObi+xOSgbl92tefFi7PNUhcf6X+9MaTxxqaiAJ5TWxx7/p5JZam4
        sC3i9DuGdTLf6m7dCLDIUtvQ8u7L+9bi25LXDrzestVy4+LfRbN8ts1ZE/xYbteUOx12nCxF
        0zZu3GBiX9sZ/PbJrlzJVb9XdoR5fuG7c+5PcMwcb9ZZG2qPXDO56qltyWoQkcPtZJNvKLYy
        Idv+1oTbyQ/esmqXzd0x8epNmcWrnxQnH7+pL619n5+7aV9ih8PDp+u2KbEUZyQaajEXFScC
        ANYOrRM5BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSvO4KljNJBhPvs1o0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmcf7tYSaLSYeuMVrsvaVtMX/ZU3aLda/fszjw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+X
        wJXxfcNx1oKdAhWH9rxmbWDczNvFyMkhIWAiMXHHQ/YuRi4OIYEdjBJzPq1lhEiISzRf+8EO
        YQtLrPz3HKroI6PE5Gl3gBwODjYBTYkLk0tBakQEvCRW9PxhAqlhFngKVDOrH2yQsIC3RM/X
        DawgNouAqsTyfVOZQXp5BSwl1jyxgJgvLzHz0newXZwCVhIzt/8DaxUCKjl1dyYTiM0rIChx
        cuYTFhCbGai+eets5gmMArOQpGYhSS1gZFrFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7
        iREcH1paOxj3rPqgd4iRiYPxEKMEB7OSCO+fs6eShHhTEiurUovy44tKc1KLDzFKc7AoifNe
        6DoZLySQnliSmp2aWpBaBJNl4uCUamAS/uf3TIxVzYnF37C2//pmzqf8t7dc0epo0f2dtEdd
        epL6h03NF5s0X1vaGyjYBCz8V3w588usEyUuex1zHDdLb7GR5bTVbqmee2PLl4uc3Ew2lY8/
        mPOnW2/UmVl8M85EuHT1j+B7FYcNTnzMM7Pfy3X2m79xcl2ozgQe9ZhCY7P/n/UlfvryXFrn
        I+rorVG3iWVbqoiHn++1AzPi594+kzDp8aGF5Tq7N96dLnE0frLb1un8ZoLbv7T1tn239Z0Z
        2GE9V+2/6Q/OJ49E9MXXPutevUTt49q6BJV39Zd7vJZVvtarlwh/LPzggqmiaNElYQaXL8Wd
        Abty9ppwsib0fTC8/9CfLzmCa9VpZSWW4oxEQy3mouJEAKoCxfX+AgAA
X-CMS-MailID: 20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b
References: <20220711110155.649153-1-joshi.k@samsung.com>
        <CGME20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use the leftover space to carve 'next' field that enables linking of
io_uring_cmd structs. Also introduce a list head and few helpers.

This is in preparation to support nvme-mulitpath, allowing multiple
uring passthrough commands to be queued.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/linux/io_uring.h | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 54063d67506b..d734599cbcd7 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -22,9 +22,14 @@ struct io_uring_cmd {
 	const void	*cmd;
 	/* callback to defer completions to task context */
 	void (*task_work_cb)(struct io_uring_cmd *cmd);
+	struct io_uring_cmd	*next;
 	u32		cmd_op;
-	u32		pad;
-	u8		pdu[32]; /* available inline for free use */
+	u8		pdu[28]; /* available inline for free use */
+};
+
+struct ioucmd_list {
+	struct io_uring_cmd *head;
+	struct io_uring_cmd *tail;
 };
 
 #if defined(CONFIG_IO_URING)
@@ -54,6 +59,27 @@ static inline void io_uring_free(struct task_struct *tsk)
 	if (tsk->io_uring)
 		__io_uring_free(tsk);
 }
+
+static inline struct io_uring_cmd *ioucmd_list_get(struct ioucmd_list *il)
+{
+	struct io_uring_cmd *ioucmd = il->head;
+
+	il->head = il->tail = NULL;
+
+	return ioucmd;
+}
+
+static inline void ioucmd_list_add(struct ioucmd_list *il,
+		struct io_uring_cmd *ioucmd)
+{
+	ioucmd->next = NULL;
+
+	if (il->tail)
+		il->tail->next = ioucmd;
+	else
+		il->head = ioucmd;
+	il->tail = ioucmd;
+}
 #else
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		ssize_t ret2)
@@ -80,6 +106,14 @@ static inline const char *io_uring_get_opcode(u8 opcode)
 {
 	return "";
 }
+static inline struct io_uring_cmd *ioucmd_list_get(struct ioucmd_list *il)
+{
+	return NULL;
+}
+static inline void ioucmd_list_add(struct ioucmd_list *il,
+		struct io_uring_cmd *ioucmd)
+{
+}
 #endif
 
 #endif
-- 
2.25.1

