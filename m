Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743C72FF966
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 01:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbhAVAXz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jan 2021 19:23:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34276 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbhAVAXt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jan 2021 19:23:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M0AKfg164012;
        Fri, 22 Jan 2021 00:23:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=43offNO3y+ImzGTKEzlOl3EOzKmLD1MoyskvIie6Qxs=;
 b=mWeKPWmSca4pLPSvolkDxcbf1aZMHcg9+cp4Qks+PfyPjW2v3Uh1c5tSQeyzrIb1MblU
 C4AImzMCANA8FtQZ16QgPejUSJ1iBvJQ2fdzL5BlK6TPOeH1CO1I3p2KV7zuE+5P8bbI
 tqIM2b3Zys+b/F7J5VaxH130UkF33CTNcg0RYp6l1Nup0shrbJcZHekpd2ceqi/cgOg4
 51FHnP9Oe0NKERhG6VLa4N5svgVZZ1/ydgDEW7nwOfwJCjjyyxzNj4NDm709qljJXJML
 wXuFHsO/7NhLFGulO5JPTAFbIW8tcSajsJuaYOEWCxBThGLc1aHpl/Y3P37jtqjLqzm9 yA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3668qn1vua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 00:23:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M0A0Dn162671;
        Fri, 22 Jan 2021 00:23:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 3668rgmgdg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 00:23:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6tX5EB11/lvA0eKb/sKwoiKiPfrveFZ4gdRXJ8u1Si9nZXImfEUFSfGc1TjSI7Iw1VTy4yQyFFnJ2gDiBDUWUeMQQV+Ni7w6MlpN6RDEqRMXBaSfyDRJj81zwWxhZ04YxyBHeuuRL3JODb0fUBpo3gLw3ic+PwRzeWnkRaSZR8QWgv+s5+Yr8EGWJs506vwwJkoyFsLYCnglb9qiwUt+ZI/GBeSgHN4IMjgFhsE42rqQcgTgadE8gLWEUTqm0SdnJDiLNavwt/Imt2kAMrxxVJzIeKPLgg3A90UGC6HWz7zdjzZ6sC3FMarLONjLuhA5JlOFH1RZ/O9nSal6rPz9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43offNO3y+ImzGTKEzlOl3EOzKmLD1MoyskvIie6Qxs=;
 b=HS8ybt0NxeG5kSg8LzjPVpTdeydhcqCZSaAkVRdh+abW/pXYnuHH2AXcgt26oBcJA9hE2X/fVHncR+S7VXbl5ub5FCpGk5lkDPjHo0jnpmJGhDJ3WKwdiciKN1Cmx0mwOWGKOG6muoWSiaROsv6o9Dz2d5T/usVW/PBM2p4HrJbvqDHKeLYBwKtW5RMyvIdi16gCGPlzXaOXHWm+ngrHUBQAhRfOIgWPSES3S48+P60NX2IeOXIp4yNxAT0MCVzZtyLexRiEcWeca70fdjma6wG+Pqs3pAKk7zPye3fRF2GPJV+O5Z8uYQuQO86uLq3n/UpA9LE8mVWhY/mlmiLcWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43offNO3y+ImzGTKEzlOl3EOzKmLD1MoyskvIie6Qxs=;
 b=0BVds+Nuf1xpK3+qjNxvBsoLddAnkZA9ADqqJkBrL3JINN4WlzmRYS5UBZVPcnK58xcFiGDbJQYMelAjQ+TebIjazrvha1HkrFqMU85SsLmx3yp8iJElGuxE+EkmfPErwRcMx7vpvkak77dtrA4bBkZQaf/oyvHDerenY3o+IZk=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Fri, 22 Jan
 2021 00:23:04 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 00:23:04 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v6 5/5] io_uring: support buffer registration sharing
Date:   Thu, 21 Jan 2021 16:22:56 -0800
Message-Id: <1611274976-44074-6-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611274976-44074-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1611274976-44074-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain
X-Originating-IP: [138.3.200.3]
X-ClientProxiedBy: DM3PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:0:50::25) To BYAPR10MB3606.namprd10.prod.outlook.com
 (2603:10b6:a03:11b::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by DM3PR03CA0015.namprd03.prod.outlook.com (2603:10b6:0:50::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 00:23:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a715e02-388f-4c17-9907-08d8be6be263
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4496:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44965D2E6BF363C84915FFE0E4A09@SJ0PR10MB4496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X6re4xr+ZfimJpihiuinOBpwEchKXPzaJzkA6xksJK4RDtl3QJZ+P6VCM/92ZrDdTP1Q3sNis9vN+Z+/oF1oi/51vl3leBhqu0GMVxYZMI0d7hG6ILFnA2DtGI7e7Ptp6kp3Qq7zyq2FbCxVsg0ps2LVe7p2tk1J/p8uVfOWYt5rPOW8GL9SC9nuZx/7Hfj6HGbMciv6KBnzWsWw4KRuVyH8CQGAgnmbCxY7xbrSr0zilEsExB3D2sBQJ6npMWDd0Op+kqnXuKIyEyMJd4JcX/a35CUDLjILhSU3xfOPpLY2VyLzPN/ifP5/Wx5klG92Zz9DR/lIX86W3y3GFxaCuEM2/5G7CEXSB7dFUX4WXa0fylLZTm4zQ4SDDipwKWiBNRCyMvYIs2Mzq/6dALfNbjPAe0p0oGD9dXicbGucmGOrWaiUxVvnKPQjgL/t+2BiEPwYz8x698r81yu84KVFPWOtmqi9pQJNkooG5mxBFwXEOyLDHruS2kwQkV/22n+l6Jwa6N+TvxXHRdo9YGVhew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(39860400002)(136003)(6666004)(478600001)(44832011)(36756003)(186003)(86362001)(2616005)(16526019)(6486002)(316002)(956004)(2906002)(52116002)(66556008)(7696005)(5660300002)(83380400001)(26005)(8936002)(66476007)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h21ci6C2bdJF2ZOgjVbsba8c1cYq/3zuzWFjYZoZfkel+rXo4fz+Jjnj9jV1?=
 =?us-ascii?Q?Y8p3e0QIG0qIgH1NitCCKrK0DF2nsinwrR5GswgoQe9EAt5/tEtMf3tlt053?=
 =?us-ascii?Q?Ax5GdGTzvA36BW3hJ0HkGSwwQ2xsAgVlwKN6BDguGECZLK9/OuAGIAMs6hLq?=
 =?us-ascii?Q?nLnkLon+x4FhZig44oj78O8pps84GchYRG5aHJVOPG2xJqmDj2asK2z6x0Js?=
 =?us-ascii?Q?I33Yek1gri3T9c8H8PX66o48ULCjYN1VzdNM33oqqDDCWkS1UAc+mFkJfOzk?=
 =?us-ascii?Q?Q2+zaBZZ2wMrPx/f+NEojHuKsLrxm0uQJR1y1BZojuYmbvP7Xa7dUEKaVmXo?=
 =?us-ascii?Q?UQhDSLyO6YKIOAtiatib11xtP6AJWBNu0hrYJ1CYxKxiWhGv0HW/p4Phf/3W?=
 =?us-ascii?Q?eR1XUbg0mNCyyAC8tejQYE3JRUPQPzMgO3V5wtvEXf+H63cpSZodtrIUvUkN?=
 =?us-ascii?Q?PPw5/Uokl+UwhVSL28Zc7J8iCOeRGiJa2JMdkv+4MCnCK6C4MlsNwV2a9rmf?=
 =?us-ascii?Q?/DbgNUziO4GxAZOUyB09IG2EPxK7/QDc9Jj9I/pFgAHsgu0NappfxTvKwVLs?=
 =?us-ascii?Q?+xWgIjgrOv/W5EaJa3dvxh+oFV9A3T7rNO5GvbKNuRLIYZSj0uRNgQuKkzgu?=
 =?us-ascii?Q?/YUqImcH59XO6ZMWbeRbXAxHu6UisEMtWmiK5NZfe9od8klbWUi+u2mVoWkj?=
 =?us-ascii?Q?Wz82+jui4NEdyvFYMXra366tskacI7/KFQE/54glJrI2qbb66aR2Npg4MSCQ?=
 =?us-ascii?Q?31MnyMbEs3g5ndq9+d8sauwDBpyvURPVRI2GvphIUbHEtKatozJ1Ogy4hFz9?=
 =?us-ascii?Q?iRCOfoeI6pEyIheze7JgUECSe3+RAxkpM/EWSywoODz0GuligEhzWxzckc//?=
 =?us-ascii?Q?FBgGhcVjP9/fhSDyXMM3ykpb9z+rYzHSdLbxHL09RhOUbOk+9iKeu2cEKbA0?=
 =?us-ascii?Q?VM5DHDYaQqIMM4gU1Rw1WRfa+K5rw+CGR6TLyljCeQ4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a715e02-388f-4c17-9907-08d8be6be263
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 00:23:04.3630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eD8+8/K591H3TlxZFCPDe2d2u8Pr7rAv7biCEMkN7KZO/XO4XPqXg2HxpsWbLxThX5rcTXnbyXxZ0iSIzYU1uJCRxU8sPAbs3HRtIuRAbH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210119
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210119
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Implement buffer sharing among multiple rings.

A ring shares its (future) buffer registrations at setup time with
IORING_SETUP_SHARE_BUF. A ring attaches to another ring's buffer
registration at setup time with IORING_SETUP_ATTACH_BUF, after
authenticating with the buffer registration owner's fd. Any updates to
the owner's buffer registrations become immediately available to the
attached rings.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c                 | 87 +++++++++++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  2 +
 2 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 15f0e41..0e9da02 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8472,6 +8472,13 @@ static void io_buffers_map_free(struct io_ring_ctx *ctx)
 	ctx->nr_user_bufs = 0;
 }
 
+static void io_detach_buf_data(struct io_ring_ctx *ctx)
+{
+	percpu_ref_put(&ctx->buf_data->refs);
+	ctx->buf_data = NULL;
+	ctx->nr_user_bufs = 0;
+}
+
 static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_data *data = ctx->buf_data;
@@ -8480,6 +8487,12 @@ static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 
 	if (!data)
 		return -ENXIO;
+
+	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
+		io_detach_buf_data(ctx);
+		return 0;
+	}
+
 	backup_node = alloc_fixed_rsrc_ref_node(ctx);
 	if (!backup_node)
 		return -ENOMEM;
@@ -8724,9 +8737,13 @@ static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
 	unsigned int nr_tables;
 	struct fixed_rsrc_data *buf_data;
 
-	buf_data = alloc_fixed_rsrc_data(ctx);
-	if (!buf_data)
-		return NULL;
+	if (ctx->buf_data) {
+		buf_data = ctx->buf_data;
+	} else {
+		buf_data = alloc_fixed_rsrc_data(ctx);
+		if (!buf_data)
+			return buf_data;
+	}
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_BUFS_TABLE);
 	buf_data->table = kcalloc(nr_tables, sizeof(*buf_data->table),
@@ -8784,8 +8801,16 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	struct fixed_rsrc_ref_node *ref_node;
 	struct fixed_rsrc_data *buf_data;
 
-	if (ctx->buf_data)
+	if (ctx->nr_user_bufs)
 		return -EBUSY;
+
+	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
+		if (!ctx->buf_data)
+			return -EFAULT;
+		ctx->nr_user_bufs = ctx->buf_data->ctx->nr_user_bufs;
+		return 0;
+	}
+
 	if (!nr_args || nr_args > IORING_MAX_FIXED_BUFS)
 		return -EINVAL;
 
@@ -9914,6 +9939,55 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 	return file;
 }
 
+static int io_attach_buf_data(struct io_ring_ctx *ctx,
+			      struct io_uring_params *p)
+{
+	struct io_ring_ctx *ctx_attach;
+	struct fd f;
+
+	f = fdget(p->wq_fd);
+	if (!f.file)
+		return -EBADF;
+	if (f.file->f_op != &io_uring_fops) {
+		fdput(f);
+		return -EINVAL;
+	}
+
+	ctx_attach = f.file->private_data;
+	if (!ctx_attach->buf_data) {
+		fdput(f);
+		return -EINVAL;
+	}
+	ctx->buf_data = ctx_attach->buf_data;
+
+	percpu_ref_get(&ctx->buf_data->refs);
+	fdput(f);
+	return 0;
+}
+
+static int io_init_buf_data(struct io_ring_ctx *ctx, struct io_uring_params *p)
+{
+	if ((p->flags & (IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF)) ==
+	    (IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF))
+		return -EINVAL;
+
+	if (p->flags & IORING_SETUP_SHARE_BUF) {
+		struct fixed_rsrc_data *buf_data;
+
+		buf_data = alloc_fixed_rsrc_data(ctx);
+		if (!buf_data)
+			return -ENOMEM;
+
+		ctx->buf_data = buf_data;
+		return 0;
+	}
+
+	if (p->flags & IORING_SETUP_ATTACH_BUF)
+		return io_attach_buf_data(ctx, p);
+
+	return 0;
+}
+
 static int io_uring_create(unsigned entries, struct io_uring_params *p,
 			   struct io_uring_params __user *params)
 {
@@ -10031,6 +10105,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
+	ret = io_init_buf_data(ctx, p);
+	if (ret)
+		goto err;
+
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
@@ -10113,6 +10191,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
+			IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF |
 			IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 32b3fa6..aeaf72c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -98,6 +98,8 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_SHARE_BUF	(1U << 7)	/* share buffer registration */
+#define IORING_SETUP_ATTACH_BUF	(1U << 8)	/* attach buffer registration */
 
 enum {
 	IORING_OP_NOP,
-- 
1.8.3.1

