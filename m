Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A78F599A14
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 12:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348376AbiHSKky (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 06:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348443AbiHSKkv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 06:40:51 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22961F0768
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 03:40:44 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220819104038epoutp03dc0343aadc6d6f696cea385c80396102~MuOD56OhY1595915959epoutp03k
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 10:40:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220819104038epoutp03dc0343aadc6d6f696cea385c80396102~MuOD56OhY1595915959epoutp03k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660905639;
        bh=luIncdN4Xs0/S1pPktHEcbVCfvwuJAGRaiPlDpqB9Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkIoehf28+eBDdzlbBP2VPwURt49X+6kc8prOs9YVBccXeP/SAlVQrb606vYJaa5R
         A+QeirYW4m82sjUbdVej3iR1OJTOGFJKcRFIP3TMQgFpfEMlFM5YlDnF475p/+FyjY
         oSA/fJqAv3S3j7MaJqHGyaJL26n1htSr8rP0oczM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220819104038epcas5p394a9a6345e766d02cb41514c87f13a59~MuODdweyj1255012550epcas5p3_;
        Fri, 19 Aug 2022 10:40:38 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4M8JF03yxjz4x9Pw; Fri, 19 Aug
        2022 10:40:36 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.63.49150.4A86FF26; Fri, 19 Aug 2022 19:40:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220819104036epcas5p2bb4d9b2cccbdfcdb460e085abe7fd1a8~MuOBVSWKC3086930869epcas5p2y;
        Fri, 19 Aug 2022 10:40:36 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220819104036epsmtrp1782211f8f9e4e8aae82d93c33472bf4f~MuOBUVhuW1513515135epsmtrp1B;
        Fri, 19 Aug 2022 10:40:36 +0000 (GMT)
X-AuditID: b6c32a4b-37dff7000000bffe-ca-62ff68a4bec6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.85.08802.3A86FF26; Fri, 19 Aug 2022 19:40:35 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220819104034epsmtip134ff85bbc9da877d52a3fdac6d6bab82~MuN-cbf4l0468404684epsmtip15;
        Fri, 19 Aug 2022 10:40:34 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next 1/4] io_uring: introduce io_uring_cmd_import_fixed
Date:   Fri, 19 Aug 2022 16:00:18 +0530
Message-Id: <20220819103021.240340-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220819103021.240340-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGJsWRmVeSWpSXmKPExsWy7bCmlu6SjP9JBjPey1g0TfjLbLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLQ5NbmZy4PK4fLbUY9OqTjaP
        zUvqPXbfbGDzeL/vKptH35ZVjB6fN8kFsEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
        6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJ
        KTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM548iqy4Dx/RevaDqYGxkm8XYycHBICJhL3lyxk
        7WLk4hAS2M0oceNcCwuE84lRYsGdiUwgVUICnxkltl7Nhum4enopK0R8F6PE5mYniAagmtuz
        pgB1c3CwCWhKXJhcClIjImAksf/TSbANzAIXGCVONn1lBqkRFvCWWPtYE6SGRUBVYv3epSwg
        Nq+ApcS2fWeYIHbJS8y89J0dxOYUsJKYtfQqG0SNoMTJmU/A6pmBapq3zmYGmS8h0MohcXbp
        ZVaIZheJwx8XsUHYwhKvjm9hh7ClJF72t0HZyRKXZp6DWlYi8XjPQSjbXqL1VD/YncxAv6zf
        pQ+xi0+i9/cTJpCwhACvREebEES1osS9SU+htopLPJyxBMr2kOj+c4QdEjy9jBKLf1xgncAo
        PwvJC7OQvDALYdsCRuZVjJKpBcW56anFpgXGeanl8FhNzs/dxAhOoFreOxgfPfigd4iRiYPx
        EKMEB7OSCO+NO3+ShHhTEiurUovy44tKc1KLDzGaAsN4IrOUaHI+MIXnlcQbmlgamJiZmZlY
        GpsZKonzel3dlCQkkJ5YkpqdmlqQWgTTx8TBKdXAJBL/wPnS7NfxczS/KO55MZnngO/1qbGC
        qfsfm05X/9v3am5pr5aXtYL75cy+a73W3iYHV1hN/LVhw6FTjOd8b1nJN3gZhL1TDy86ecdY
        y//oHl0RduPY8jUnVjJq8rz+XJDVvtmh2zNCj1tp2UOV2ZI8Wndfhz1bcaPyVJxp6M0Ly/Vt
        NwZoh2Y3pbreUOqU0L1c3Hg73v1J0FyRqVpyUvlhm2Qlp3/Ke7F6zl2ju/Ml7NIF7aKmGHS8
        P2PX6bpffGOEvsiRSfZx7zpXXs5x+b+kslt95yWuVf3b+hjqEx19vxmc3iNzc2bSUV3nFU9i
        79mq2OQv88xVU5/u6R0otWleAMP+FctUlp5a8uahEktxRqKhFnNRcSIAs/ff4ikEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWy7bCSnO6SjP9JBkflLZom/GW2WH23n83i
        5oGdTBYrVx9lsnjXeo7F4uj/t2wWkw5dY7TYe0vbYv6yp+wWhyY3MzlweVw+W+qxaVUnm8fm
        JfUeu282sHm833eVzaNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgynryKLDjPX9G6toOpgXES
        bxcjJ4eEgInE1dNLWbsYuTiEBHYwShx5fokZIiEu0XztBzuELSyx8t9zdoiij4wSB3dOAerg
        4GAT0JS4MLkUpEZEwExi6eE1LCA2s8ANRoltE/JBSoQFvCXWPtYECbMIqEqs37sUrIRXwFJi
        274zTBDj5SVmXvoOtopTwEpi1tKrbCC2EFDNr78dTBD1ghInZz6BGi8v0bx1NvMERoFZSFKz
        kKQWMDKtYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIDn0trR2Me1Z90DvEyMTBeIhR
        goNZSYT3xp0/SUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFw
        SjUweemfl7mxZ4niQ/GZHyPVbgUduFrEfU/uoc/80KKQC9panwTlGpd+t6r3evk5MSxDwute
        QDODzH+WPdeaRDXM5qa5v1z8L3jKnAtsxol12/hOX93dcKha9tb5H+dnbtNYpeK3Vfzr4u0n
        mTf07ZdxtH8oHTZvV8+SmprMTXJzmp68NnjWd2djq2lX3aW7aXH3M6VqLvq3y7eJ7nA7rav3
        S9ltq7uFluyj0s9f3fsm3+rZsIbbI17vzcmDs0r3N9j+sLFZWNKrnarRuuSddmPBlGyX63Fh
        zD9mHVopVnfcZ3f4JRP5TptIxgNN0t4Cb1v3Hl08NTNK3FvZ5Ldz4m7DuprVZ1qWsKv+FfMr
        6VqgxFKckWioxVxUnAgA1ciFCuwCAAA=
X-CMS-MailID: 20220819104036epcas5p2bb4d9b2cccbdfcdb460e085abe7fd1a8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220819104036epcas5p2bb4d9b2cccbdfcdb460e085abe7fd1a8
References: <20220819103021.240340-1-joshi.k@samsung.com>
        <CGME20220819104036epcas5p2bb4d9b2cccbdfcdb460e085abe7fd1a8@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

