Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404324D1C06
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347944AbiCHPnj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347917AbiCHPng (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:43:36 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B281A4F45A
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:42:24 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220308154223epoutp021d32950db6dd171e0137f2110efa7514~acisX5Zxl3200332003epoutp02G
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:42:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220308154223epoutp021d32950db6dd171e0137f2110efa7514~acisX5Zxl3200332003epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754143;
        bh=KxAi2S/QOS8P47wclOO/QQaBl7MyXZwh6nrm+2MFnUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvYoo4GPnJphpnxrQk2PM/DsAUwQfVmeVZkiCqYugojt9c5y/KWBe8qMOE6H9TLwI
         hxyMxkBIyDOaPZy4UjH/RJb6fsQ6SkzRByKV30ixuz5sZg2PJ/bGd+aQgYXDd/nk9A
         bp7T2QqKoigRL1Id0gQ/jQRw1c5c/VrNjibyUNjs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220308154221epcas5p28126241c4808ab138321f959e55fea2e~acirQQVlu3013430134epcas5p2M;
        Tue,  8 Mar 2022 15:42:21 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4KCfhp671Pz4x9Pp; Tue,  8 Mar
        2022 15:42:18 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B6.E6.46822.28677226; Wed,  9 Mar 2022 00:30:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152704epcas5p16610e1f50672b25fa1df5f7c5c261bb5~acVVLiJPN1997519975epcas5p1R;
        Tue,  8 Mar 2022 15:27:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220308152704epsmtrp14721c045eeb6dbefeedfcf7d5cba2aeb~acVVKukz50125001250epsmtrp1R;
        Tue,  8 Mar 2022 15:27:04 +0000 (GMT)
X-AuditID: b6c32a4a-dfbff7000000b6e6-17-6227768274cd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        86.51.29871.8C577226; Wed,  9 Mar 2022 00:27:04 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152702epsmtip1f90559af419bb23c2a20175b5e7f4802~acVTKAjdX1072310723epsmtip1q;
        Tue,  8 Mar 2022 15:27:02 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 06/17] io_uring: prep for fixed-buffer enabled uring-cmd
Date:   Tue,  8 Mar 2022 20:50:54 +0530
Message-Id: <20220308152105.309618-7-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmpm5TmXqSQds2A4vphxUtmib8ZbaY
        s2obo8Xqu/1sFitXH2WyeNd6jsWi8/QFJovzbw8zWUw6dI3RYu8tbYv5y56yWyxpPc5mcWPC
        U0aLNTefslh8PjOP1YHf49nVZ4weO2fdZfdoXnCHxePy2VKPTas62Tw2L6n32H2zgc1j2+KX
        rB59W1YxenzeJBfAFZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
        5OIToOuWmQP0g5JCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwKRArzgxt7g0L10v
        L7XEytDAwMgUqDAhO+PbF+uCPtGK/1+XMTcwHhbsYuTkkBAwkdj2bAJjFyMXh5DAbkaJn0d+
        s4AkhAQ+MUqs2JcPkfjGKNE/5yE7TMfCeZPYIBJ7GSXmLz8E5XxmlFjfdoS1i5GDg01AU+LC
        5FKQBhEBL4n7t9+zgtQwC3QxSbzdd58NJCEs4CHRM3cimM0ioCrx+vQrRhCbV8BS4mjTW6ht
        8hIzL30HszkFrCR+3trKClEjKHFy5hOwU5mBapq3zmYGWSAhcIBDYueCx6wQzS4SE3ffhBok
        LPHq+BYoW0riZX8blF0s8evOUajmDkaJ6w0zWSAS9hIX9/xlAvmGGeib9bv0IcKyElNPrWOC
        WMwn0fv7CRNEnFdixzwYW1Hi3qSnUDeISzycsQTK9pC4dfQiNLR6GSW+ztvOMoFRYRaSh2Yh
        eWgWwuoFjMyrGCVTC4pz01OLTQuM8lLL4bGcnJ+7iRGcrrW8djA+fPBB7xAjEwfjIUYJDmYl
        Ed7751WShHhTEiurUovy44tKc1KLDzGaAkN8IrOUaHI+MGPklcQbmlgamJiZmZlYGpsZKonz
        nk7fkCgkkJ5YkpqdmlqQWgTTx8TBKdXANM84veFQusrcmauOnvh10VbN2Ggf32OWHb7/L729
        cun935ul5wz8HEJSUpZVzLjufNSi6i3fx8DEG441cw7q7uYOTm7wrpPVFciSORq6oohH44Tl
        MdviVcevqkyYv+u5Y+/H6kdzBO4Evrev3iTy2oM/LOKbjVfofoO1FeuXnSv84y6mPc9sxoq3
        G5rml/07k7aUQaj2/aK5cZOmXi/98TgumHf3aovvLxP5K+s/Wb853SsfcmvK5LfKKpJpfRvr
        gx9M2nn69c9HDcaFluGGnTO+LzLYusT5q1fXpIMHrpvZvrFeH1hjf4Q1STey877QnT93Dgew
        mP88PON+7MZ8nxr95Q7zGM08vH+V7DusJqrEUpyRaKjFXFScCABiHbqNYAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJTvdEqXqSwYMHhhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr49sX64I+0Yr/X5cxNzAeFuxi5OSQEDCRWDhv
        ElsXIxeHkMBuRok/c06yQiTEJZqv/WCHsIUlVv57zg5R9JFR4sCFK0AdHBxsApoSFyaXgtSI
        CARIHGy8DFbDLDCDSaKn+TMLSEJYwEOiZ+5ENhCbRUBV4vXpV4wgNq+ApcTRprdQC+QlZl76
        DmZzClhJ/Ly1FewIIaCaFet+s0HUC0qcnPkEbCYzUH3z1tnMExgFZiFJzUKSWsDItIpRMrWg
        ODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIzietDR3MG5f9UHvECMTB+MhRgkOZiUR3vvnVZKE
        eFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYMrz2fkpoiRi
        xtWWeX5tm9vuJ+uIczku1n6W9CXku1jejVqV8rrWR+qat1+9vj772ttoqfexJSeM83Yc/tBw
        x6O9sOKJWenc5E3+bAvzjjPd+Wl/qlfNq0Tl92F1a+PLuhX7nnesFE5RFjW+6K8SY/lZ21CJ
        t0GwedGkZ0Ksq1jyr6qu3vt+p1ROXOfdd9Fxobvuv/p03nuZwGpJkf6VVlMCF/y+dIcrdkKR
        MIv5utd6bLbxmesjbrsnbu6dp8O94tvUg6YL0h45W26SKdt2QY5t4rm9UncbujSjQgO9D29r
        v39B+WK1XGCcy+cumxdzlaWnJcUmiqldcFh+ziKAIet9xPIU/k0Lb2fMfKa4S4mlOCPRUIu5
        qDgRANUzlhEWAwAA
X-CMS-MailID: 20220308152704epcas5p16610e1f50672b25fa1df5f7c5c261bb5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152704epcas5p16610e1f50672b25fa1df5f7c5c261bb5
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152704epcas5p16610e1f50672b25fa1df5f7c5c261bb5@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Refactor the existing code and factor out helper that can be used for
passthrough with fixed-buffer. This is a prep patch.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/io_uring.c            | 19 ++++++++++++++-----
 include/linux/io_uring.h |  7 +++++++
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1f228a79e68f..ead0cbae8416 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3140,11 +3140,10 @@ static void kiocb_done(struct io_kiocb *req, ssize_t ret,
 	}
 }
 
-static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
-			     struct io_mapped_ubuf *imu)
+static int __io_import_fixed(u64 buf_addr, size_t len, int rw,
+			struct iov_iter *iter, struct io_mapped_ubuf *imu)
 {
-	size_t len = req->rw.len;
-	u64 buf_end, buf_addr = req->rw.addr;
+	u64 buf_end;
 	size_t offset;
 
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
@@ -3213,9 +3212,19 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 		imu = READ_ONCE(ctx->user_bufs[index]);
 		req->imu = imu;
 	}
-	return __io_import_fixed(req, rw, iter, imu);
+	return __io_import_fixed(req->rw.addr, req->rw.len, rw, iter, imu);
 }
 
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len,
+		int rw, struct iov_iter *iter, void *ioucmd)
+{
+	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
+	struct io_mapped_ubuf *imu = req->imu;
+
+	return __io_import_fixed(ubuf, len, rw, iter, imu);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
+
 static void io_ring_submit_unlock(struct io_ring_ctx *ctx, bool needs_lock)
 {
 	if (needs_lock)
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index cedc68201469..1888a5ea7dbe 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -25,6 +25,8 @@ struct io_uring_cmd {
 };
 
 #if defined(CONFIG_IO_URING)
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len,
+		int rw, struct iov_iter *iter, void *ioucmd);
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret);
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 			void (*driver_cb)(struct io_uring_cmd *));
@@ -48,6 +50,11 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len,
+		int rw, struct iov_iter *iter, void *ioucmd)
+{
+	return -1;
+}
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
 {
 }
-- 
2.25.1

