Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920807B12D4
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 08:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjI1G2Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 02:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjI1G2X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 02:28:23 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CE59C
        for <io-uring@vger.kernel.org>; Wed, 27 Sep 2023 23:28:21 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230928062818epoutp03e2531aba5529db0e7868bcb7c89db809~I-CWx9d211516015160epoutp03M
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 06:28:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230928062818epoutp03e2531aba5529db0e7868bcb7c89db809~I-CWx9d211516015160epoutp03M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1695882498;
        bh=np1wCyyTF5m5+8Zyeo7ik3GwizYUYFnqjB6m0xeAUEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZXkkvTIfdZcMqm4jDpwndmwXbzyT1Ux+/7YkAcdXFqB7DbjlNSYaaOxBEaBb33Ihc
         mULP990slGl+R/oDZQmbztFORJnAvTP/kDzRucxJH/pFt4lu6ioIHOPX3tb4AE2vxs
         qTMEtk5N9zQp1WRJ76bZ517SuyAcVOLQZmaTipFA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230928062818epcas5p48c9e782c3fec36d361d952bece68fd60~I-CWhkY6g1625216252epcas5p4D;
        Thu, 28 Sep 2023 06:28:18 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Rx3Sw2x2Pz4x9Pr; Thu, 28 Sep
        2023 06:28:16 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2E.B0.09638.00D15156; Thu, 28 Sep 2023 15:28:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230928061733epcas5p1837b43637213341fb9674e99efa62a94~I_4_F9kju1720117201epcas5p1u;
        Thu, 28 Sep 2023 06:17:33 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230928061733epsmtrp26779921415ce6637ee9ce1aef8af9dc4~I_4_FX2QK0908609086epsmtrp2K;
        Thu, 28 Sep 2023 06:17:33 +0000 (GMT)
X-AuditID: b6c32a4a-92df9700000025a6-64-65151d00ad88
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.C1.08788.D7A15156; Thu, 28 Sep 2023 15:17:33 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230928061732epsmtip26264bd26e97aba7d1dddecc5fc551468~I_49PwP5p0377403774epsmtip2y;
        Thu, 28 Sep 2023 06:17:32 +0000 (GMT)
Date:   Thu, 28 Sep 2023 11:41:25 +0530
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Re: [PATCH V4 1/2] io_uring: retain top 8bits of uring_cmd flags
 for kernel internal use
Message-ID: <20230928061125.hm2dxmms7db2xk5x@green245>
MIME-Version: 1.0
In-Reply-To: <20230923025006.2830689-2-ming.lei@redhat.com>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdlhTXZdBVjTV4NIPQYvVd/vZLN61nmOx
        2H5mKbPF3lvaFocmNzM5sHpcPlvq8X7fVTaPzaerPT5vkgtgicq2yUhNTEktUkjNS85PycxL
        t1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFaqqRQlphTChQKSCwuVtK3synKLy1J
        VcjILy6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzli47BhzwSexinMH7zM3MK4U
        7mLk5JAQMJH4vPcZSxcjF4eQwG5GiYVX1rFDOJ8YJQ7828cIUiUk8I1RovOWGEzHiktHoDr2
        AsUPPGaGKHrGKPFxCVgDi4CqxNZFC9hBbDYBdYkjz1vB4iICShJ3764G28As0MIocWHtKbCE
        sECyxO/9EM28AmYS//+cYYewBSVOznzCAmJzClhLHNh8EiwuKiAjMWPpV2aQQRICt9gljn78
        xwpxnovEm0MnmSBsYYlXx7ewQ9hSEp/f7WWDsNMlflx+ClVTINF8DOJNCQF7idZT/WDfMAtk
        SBz51ApVLysx9dQ6Jog4n0Tv7ydQvbwSO+bB2EoS7SvnQNkSEnvPNUDZHhKth2czQYJrP6PE
        7OdbWCYwys9C8twsJPsgbCuJzg9NrLMYOYBsaYnl/zggTE2J9bv0FzCyrmKUTC0ozk1PLTYt
        MMpLLYfHeHJ+7iZGcKLU8trB+PDBB71DjEwcjIcYJTiYlUR4H94WShXiTUmsrEotyo8vKs1J
        LT7EaAqMrYnMUqLJ+cBUnVcSb2hiaWBiZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8T
        B6dUA9OsLd3TdjX36ZoLphz7yV5QPv/ZI489515s7Cz359D6cfbN68BfFVO1xOTcqn6tu3ll
        0lE5fq/Hs8tV1ZxlGedszjIp+1aXs9j9xgT1uP9OK1V3vZ+zYt8J3blmXVcrPkQY+a+6sV/n
        /utjt9lf67LL8tk0hTu8XeLQyaE5mfVj0Ber4ODbnyY8XlQnXh0hGSxzOdHq0abK+c3//LnE
        xSv7En9ncL2z13c7NONzZOcOcYMZjRPnpP6KeXaAv6RFzsFN8rjDltvrQ8tcuTd232PlfvBt
        sXKmsGZ64OUqlcqg5hkF89OU2eUcPP4smnTUqahV8Hxd2ZPjEedrZEz5GdTm2AlNvt4Rcv6d
        7xYeTiWW4oxEQy3mouJEAJ26aUgdBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSvG6tlGiqwfH1Mhar7/azWbxrPcdi
        sf3MUmaLvbe0LQ5NbmZyYPW4fLbU4/2+q2wem09Xe3zeJBfAEsVlk5Kak1mWWqRvl8CV0dIX
        WrBEpGLG3ZQGxq8CXYycHBICJhIrLh1hAbGFBHYzSqw9oQMRl5A49XIZI4QtLLHy33P2LkYu
        oJonjBKvly1gBkmwCKhKbF20gB3EZhNQlzjyvBWsQURASeLu3dVgDcwCbYwS3372gzUICyRL
        /Pg2BWwbr4CZxP8/Z9ghNmdL9C49wAQRF5Q4OfMJWA0zUM28zQ+BejmAbGmJ5f84QMKcAtYS
        BzafBGsVFZCRmLH0K/MERsFZSLpnIemehdC9gJF5FaNkakFxbnpusWGBUV5quV5xYm5xaV66
        XnJ+7iZGcGhrae1g3LPqg94hRiYOxkOMEhzMSiK8D28LpQrxpiRWVqUW5ccXleakFh9ilOZg
        URLn/fa6N0VIID2xJDU7NbUgtQgmy8TBKdXApC2kPuv1tPkqa1SVz7jeSP6xP/JvjdJV5WKj
        K9u7d6614ONXNTdN4P8s1/Rg3be1RbP8WnKFm2OqUtUfuNprbqnrDXkv2yeV+8+H4QmP+OwX
        Z6QLbKZ4Fp9VPBp/qapzfZ7jmzqe7Osrttwvdt/mtYPZKzy3JeeeFeeLzCLmTd95WxUfX7s7
        7/RCP0nxqs+aiRfdKt1sjvypXLXc/VmNWuss1ySBE7vu6/HbnHsgLXl6U1C6wGX9kF5Pk7cC
        F/387a7GbdqTGLrscZjXxgPqEd/al/85LnV4k2psfcfdsMUzv/8IWzM7SFhzYnehisnlBxr+
        Dyz7upWOvNzyQp79dYGggY1s6wur+QcvbfqvxFKckWioxVxUnAgAgVtaUNwCAAA=
X-CMS-MailID: 20230928061733epcas5p1837b43637213341fb9674e99efa62a94
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----IKYw8rt4xsi0beZH_Imxy96mvZbFJ64oQ.XZqp2ZTk-1zWLz=_2a65e_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230928061733epcas5p1837b43637213341fb9674e99efa62a94
References: <20230923025006.2830689-1-ming.lei@redhat.com>
        <20230923025006.2830689-2-ming.lei@redhat.com>
        <CGME20230928061733epcas5p1837b43637213341fb9674e99efa62a94@epcas5p1.samsung.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------IKYw8rt4xsi0beZH_Imxy96mvZbFJ64oQ.XZqp2ZTk-1zWLz=_2a65e_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/09/23 10:50AM, Ming Lei wrote:
>Retain top 8bits of uring_cmd flags for kernel internal use, so that we
>can move IORING_URING_CMD_POLLED out of uapi header.
>

Looks good.

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

>Signed-off-by: Ming Lei <ming.lei@redhat.com>
>---
> include/linux/io_uring.h      | 3 +++
> include/uapi/linux/io_uring.h | 5 ++---
> io_uring/io_uring.c           | 3 +++
> io_uring/uring_cmd.c          | 2 +-
> 4 files changed, 9 insertions(+), 4 deletions(-)
>
>diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
>index 106cdc55ff3b..ae08d6f66e62 100644
>--- a/include/linux/io_uring.h
>+++ b/include/linux/io_uring.h
>@@ -22,6 +22,9 @@ enum io_uring_cmd_flags {
> 	IO_URING_F_IOPOLL		= (1 << 10),
> };
>
>+/* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
>+#define IORING_URING_CMD_POLLED		(1U << 31)
>+
> struct io_uring_cmd {
> 	struct file	*file;
> 	const struct io_uring_sqe *sqe;
>diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>index 8e61f8b7c2ce..de77ad08b123 100644
>--- a/include/uapi/linux/io_uring.h
>+++ b/include/uapi/linux/io_uring.h
>@@ -246,13 +246,12 @@ enum io_uring_op {
> };
>
> /*
>- * sqe->uring_cmd_flags
>+ * sqe->uring_cmd_flags		top 8bits aren't available for userspace
>  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
>  *				along with setting sqe->buf_index.
>- * IORING_URING_CMD_POLLED	driver use only
>  */
> #define IORING_URING_CMD_FIXED	(1U << 0)
>-#define IORING_URING_CMD_POLLED	(1U << 31)
>+#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
>
>
> /*
>diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>index 783ed0fff71b..9aedb7202403 100644
>--- a/io_uring/io_uring.c
>+++ b/io_uring/io_uring.c
>@@ -4666,6 +4666,9 @@ static int __init io_uring_init(void)
>
> 	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
>
>+	/* top 8bits are for internal use */
>+	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
>+
> 	io_uring_optable_init();
>
> 	/*
>diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>index 537795fddc87..a0b0ec5473bf 100644
>--- a/io_uring/uring_cmd.c
>+++ b/io_uring/uring_cmd.c
>@@ -91,7 +91,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> 		return -EINVAL;
>
> 	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
>-	if (ioucmd->flags & ~IORING_URING_CMD_FIXED)
>+	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
> 		return -EINVAL;
>
> 	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
>-- 
>2.41.0
>

------IKYw8rt4xsi0beZH_Imxy96mvZbFJ64oQ.XZqp2ZTk-1zWLz=_2a65e_
Content-Type: text/plain; charset="utf-8"


------IKYw8rt4xsi0beZH_Imxy96mvZbFJ64oQ.XZqp2ZTk-1zWLz=_2a65e_--
