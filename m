Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A429E2FF963
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 01:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbhAVAX4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jan 2021 19:23:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49684 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbhAVAXs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jan 2021 19:23:48 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M08tgh027207;
        Fri, 22 Jan 2021 00:23:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zJPC0L8fY8OOBixCv565mqCpBfyMJ+523DrvWKy5+yk=;
 b=PqYxb4NIORECsKjHyNzFQtgnqQynvSiaBmhLhXrzfq4XE1yEzY4Um8/5fTvKXkw+2xyF
 0gnGtYWPCN3376jTmGEDvlscrfo7nAV7xiTrg+WicdF7/7vmUQx/kKQSS/xJ1QmmeJ4H
 gD8tpAnQ2d2yeSI60jeXaz5jOGhtfBPnbt4jQ3TlHlkrT1UMafenCIYQ1nIllwXjX1di
 ZOX3ciZrf8hyxn8c4kvyQIcoMVWlA4jPMy5/gVM7QHdQQlStsizXOQoe/jesDfMCC21l
 0yleYvqzBL6MXDQiKlfMQptrAOUflKgERqassPkz2/W0MW7+5gQZJTArYCEQTxH1m+8B 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3668qrhwvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 00:23:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M0AsGc127842;
        Fri, 22 Jan 2021 00:23:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3020.oracle.com with ESMTP id 3668r016pr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 00:23:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHOYKO9TxrRRJtcRABFOOKWdr5kaHqMwWlNDWZAsoH/tdw15tfpXDyX0u9GGWyGqqcILa+QU8KJZYmo0Bn9yCje0zINgtao2IQXVN+QQs62iIEdGfRL9+9jCoULrRs03sCjyykpXIZ3sAgWjaefX7xDofOMQWWtsfDqcmGRKxKkSRgPFOWq6cNlRhwl0fioOKITE2p1VO3jEVsawSuShHDKm5S1ZKeTKr3e+F9WvB4dlS0m1ZlrY9eEshHrNQHBOYK1kKU8GTk+Y8TARigKQ4unEZEsfnTepa1ZODJQw0xJnn2GfVlU+2uYg57Ef2NNQyRrnDWFzO/g0Jj5dVCPhig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJPC0L8fY8OOBixCv565mqCpBfyMJ+523DrvWKy5+yk=;
 b=Vwt3qpgtdkX1aLm8XTeiG6fIJ+FE34ekiVpjRCQ9aL0h6B5C6GvLxiLu3UKWAYl0UXEQTWNw9jdhqrMO3UoDVh6PwMdqns/1Rf2oEOFjmSws/lvNVKREEjMKH8QQ/E0d8I9j9LdmlNeWdb6eXsYZ2vGwmRnm45Q42QSbvv6r6+SScNF03zMsT9/X6QqDPcWibiy0tPRWQbuy2d6Cr2vZaVpLYK1CCJ0Rks18oZFudIPx+MccMDmB3e53CH7EjLppBq5KZJ7Pz7ZxRBQH+OXDNCk6e8OqcBhpqUcOIpDR6wkaDdEgLtpd12hnMOkG1Om2WrIOk+e0uZ6kJClPaRvuQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJPC0L8fY8OOBixCv565mqCpBfyMJ+523DrvWKy5+yk=;
 b=CfIUTMfhgLxdFCCQ7zAguyCl+ZQs2wtVHRZgUn/ZSLA9t6YX4izRnJuWKqddDteZtPZReqj+tqnQx9AhPfzRa35SahgyWmSOcOwhPqrloIhGc9O6GC96LX1HCvMFDpREV/aJGnIP9yEGlUCXXkjBH2beF19xogJqz2/mcoTStJM=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Fri, 22 Jan
 2021 00:23:01 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 00:23:01 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v6 2/5] io_uring: implement fixed buffers registration similar to fixed files
Date:   Thu, 21 Jan 2021 16:22:53 -0800
Message-Id: <1611274976-44074-3-git-send-email-bijan.mottahedeh@oracle.com>
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
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by DM3PR03CA0015.namprd03.prod.outlook.com (2603:10b6:0:50::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 00:23:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a4e4477-66a8-4eef-5f6e-08d8be6be0d2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4496:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4496F71D594AA284EAD506F2E4A09@SJ0PR10MB4496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:115;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1E2q/KAroahe+SKz1ONoJb95uScQGRSv+Y4qcxTLi2jKIvCB2k4o0pVrWAi/Dpd1Xb52wUrIf9KUwXqTFdHUoalwwgTQKro+i95AAzaiaW3BVKLEqRd5fQa8+eEEstumBrr8mcX2IHoUPQx4fJZjboh6fCxi4BM2WaVeACuguHUF0BaGGPGjHVrEJbf39SH5A+S0JQEtV8vbPZnyPvSB9dB1MhJ+bHh5YHDq4MSBy3VR9mIR7CPMOtYJ77AaXPjfsrvHTs+YukMTadsvqYZrokuaaZmdxzBQ8aWnZuu602oXsbU1YygeZWDjPw9neBNB8PHAIjJmRPbJ3YAJBrcgjErHcqyUoKAeFyFcUtHLgJYzZV9zm3XbNEc2h3j5RB3n4a8cbI2a89+pxMQAwB8pSmsK91S+/n1pSHuQdGLr3nxbx/XP46n8m/CQoSlIqMmk5HvEn3GD2Kr5LEs02FjYJK5+WqsZM+ZGZnz8x8Am7Xigf4K9C4VKfECrWJXBkn4/ZyZQO/24bTkbX0jqa2tYfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(39860400002)(136003)(6666004)(478600001)(44832011)(36756003)(186003)(86362001)(2616005)(16526019)(6486002)(316002)(956004)(2906002)(52116002)(66556008)(7696005)(5660300002)(83380400001)(26005)(8936002)(66476007)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5/QGole8MJBs3AL+gtuewWofMPi+b5pMzcBBbJAMvLVfyz2MPr+7HpVDSqQf?=
 =?us-ascii?Q?LUTqRXnJyeDry/UIh9qKFu28aaD2JXO2T+eaDcQnq6eLJ9+PXDzN6jSqfMro?=
 =?us-ascii?Q?3WqZeaKvY7Jl0m7vY4ccpHLRjKEuUd9xHi95rlbc617j8pa/gX5+AlIe7zCT?=
 =?us-ascii?Q?l1nRmI+G1Ju1cGs9kLwNSz8E5kujt+fAWRbAgE8MsI1scAnvtAJ71HzjIDcP?=
 =?us-ascii?Q?JR8UYcJwq96p3TmjvaA9UGBjh7j78aXlcVUoZor03rXy5aVeqq7thc4BQabN?=
 =?us-ascii?Q?3bQRsUkvubivOzylOiUtI43gCY2XfbmwkmM6JW+lh2j2a7/Q39bt6aUl8C5l?=
 =?us-ascii?Q?fyh2xinGv+4iIncXMQbS68HHKs1bNrGH7rGqio+OTMpJmoEDnhDQrS4BDLVz?=
 =?us-ascii?Q?1Dpy/9Az7Ms+KETlAj53CzZ7NqEQqoGC5z0+E/LnSJOOH4AiHlNcRfmhMyKn?=
 =?us-ascii?Q?s/k2DHi6sghiNGjKdI+osNpoKMYDnXYoAMEd6WmRdM1n8aWAKYGncLu6g8bd?=
 =?us-ascii?Q?5OzhZOagii+Uu5ItpXbRZc/LF4+59XP4i+kmslRNTfRCS+ZNXK4a2BBbZyrQ?=
 =?us-ascii?Q?6H7NIxGlQf/TDYEeySvYyoPPNo9EJ6OY5L0kwZZ5do4yNXVoNnmaGxJ8Y7/Y?=
 =?us-ascii?Q?X7V7ln+oezDoqJHyS6tXMCNiM3vmu5snlfVjNw2joFhN7Qo8gpC0sJZ7tJ03?=
 =?us-ascii?Q?9sxw3doBaUP54eZHodSYeCtrkfO8WPPJ1iyPZypXDWl+23DDuCbqEvpOzPRB?=
 =?us-ascii?Q?T9YaByjt2vIK1g96SrBUyVwoD+7/uiVs8kwKI68SfDcLwLMZXsT6wduvR9x9?=
 =?us-ascii?Q?Yc2yOnouoDlbuKE05QWflseHbwBeUOmdDJliSm+fIsjijg5cgI1nZttd+U0F?=
 =?us-ascii?Q?OyNiVbL7AR/gko2JlxXTcsxMoUiyzalvsn7Q3NeYndzWiaZyPQm79+t4ZVma?=
 =?us-ascii?Q?QPbPL4jWmcT9Ev4/rVudLwlDDneCNWciL8HnOtYPt4E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4e4477-66a8-4eef-5f6e-08d8be6be0d2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 00:23:01.6895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +H0QInP7mMBRI1xytHiPUSvyE23FlFgBZBUdtea+RIdYR/5A6eLTGljnQnyUxXr0cj+I/mnY+GitKQdxlqJ28ruvQAsULvwGFBuo5yQC+xI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210119
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210119
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apply fixed_rsrc functionality for fixed buffers support.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 221 ++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 183 insertions(+), 38 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 416c350..2f02e11 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -104,6 +104,14 @@
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
+/*
+ * Shift of 7 is 128 entries, or exactly one page on 64-bit archs
+ */
+#define IORING_BUF_TABLE_SHIFT	7	/* struct io_mapped_ubuf */
+#define IORING_MAX_BUFS_TABLE	(1U << IORING_BUF_TABLE_SHIFT)
+#define IORING_BUF_TABLE_MASK	(IORING_MAX_BUFS_TABLE - 1)
+#define IORING_MAX_FIXED_BUFS	UIO_MAXIOV
+
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
 	u32 tail ____cacheline_aligned_in_smp;
@@ -202,11 +210,15 @@ struct io_rsrc_put {
 	union {
 		void *rsrc;
 		struct file *file;
+		struct io_mapped_ubuf *buf;
 	};
 };
 
 struct fixed_rsrc_table {
-	struct file		**files;
+	union {
+		struct file		**files;
+		struct io_mapped_ubuf	*bufs;
+	};
 };
 
 struct fixed_rsrc_ref_node {
@@ -333,8 +345,8 @@ struct io_ring_ctx {
 	unsigned		nr_user_files;
 
 	/* if used, fixed mapped user buffers */
+	struct fixed_rsrc_data	*buf_data;
 	unsigned		nr_user_bufs;
-	struct io_mapped_ubuf	*user_bufs;
 
 	struct user_struct	*user;
 
@@ -1015,6 +1027,8 @@ static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 			struct io_ring_ctx *ctx);
 static void init_fixed_file_ref_node(struct io_ring_ctx *ctx,
 				     struct fixed_rsrc_ref_node *ref_node);
+static void init_fixed_buf_ref_node(struct io_ring_ctx *ctx,
+				    struct fixed_rsrc_ref_node *ref_node);
 
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 			     struct io_comp_state *cs);
@@ -2988,6 +3002,15 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		io_rw_done(kiocb, ret);
 }
 
+static inline struct io_mapped_ubuf *io_buf_from_index(struct io_ring_ctx *ctx,
+						       int index)
+{
+	struct fixed_rsrc_table *table;
+
+	table = &ctx->buf_data->table[index >> IORING_BUF_TABLE_SHIFT];
+	return &table->bufs[index & IORING_BUF_TABLE_MASK];
+}
+
 static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 			       struct iov_iter *iter)
 {
@@ -3001,7 +3024,7 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 	if (unlikely(buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
 	index = array_index_nospec(buf_index, ctx->nr_user_bufs);
-	imu = &ctx->user_bufs[index];
+	imu = io_buf_from_index(ctx, index);
 	buf_addr = req->rw.addr;
 
 	/* overflow */
@@ -6086,7 +6109,7 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 			req->opcode);
-	return-EINVAL;
+	return -EINVAL;
 }
 
 static int io_req_defer_prep(struct io_kiocb *req,
@@ -8391,28 +8414,66 @@ static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
 	return pages;
 }
 
-static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
+static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 {
-	int i, j;
+	unsigned int i;
 
-	if (!ctx->user_bufs)
-		return -ENXIO;
+	for (i = 0; i < imu->nr_bvecs; i++)
+		unpin_user_page(imu->bvec[i].bv_page);
 
-	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+	if (imu->acct_pages)
+		io_unaccount_mem(ctx, imu->nr_bvecs, ACCT_PINNED);
+	kvfree(imu->bvec);
+	imu->nr_bvecs = 0;
+}
 
-		for (j = 0; j < imu->nr_bvecs; j++)
-			unpin_user_page(imu->bvec[j].bv_page);
+static void io_buffers_unmap(struct io_ring_ctx *ctx)
+{
+	unsigned int i;
+	struct io_mapped_ubuf *imu;
 
-		if (imu->acct_pages)
-			io_unaccount_mem(ctx, imu->acct_pages, ACCT_PINNED);
-		kvfree(imu->bvec);
-		imu->nr_bvecs = 0;
+	for (i = 0; i < ctx->nr_user_bufs; i++) {
+		imu = io_buf_from_index(ctx, i);
+		io_buffer_unmap(ctx, imu);
 	}
+}
 
-	kfree(ctx->user_bufs);
-	ctx->user_bufs = NULL;
+static void io_buffers_map_free(struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_data *data = ctx->buf_data;
+	unsigned int nr_tables, i;
+
+	if (!data)
+		return;
+
+	nr_tables = DIV_ROUND_UP(ctx->nr_user_bufs, IORING_MAX_BUFS_TABLE);
+	for (i = 0; i < nr_tables; i++)
+		kfree(data->table[i].bufs);
+	free_fixed_rsrc_data(data);
+	ctx->buf_data = NULL;
 	ctx->nr_user_bufs = 0;
+}
+
+static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_data *data = ctx->buf_data;
+	struct fixed_rsrc_ref_node *backup_node;
+	int ret;
+
+	if (!data)
+		return -ENXIO;
+	backup_node = alloc_fixed_rsrc_ref_node(ctx);
+	if (!backup_node)
+		return -ENOMEM;
+	init_fixed_buf_ref_node(ctx, backup_node);
+
+	ret = io_rsrc_ref_quiesce(data, ctx, backup_node);
+	if (ret)
+		return ret;
+
+	io_buffers_unmap(ctx);
+	io_buffers_map_free(ctx);
+
 	return 0;
 }
 
@@ -8465,7 +8526,9 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
 
 	/* check previously registered pages */
 	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+		struct io_mapped_ubuf *imu;
+
+		imu = io_buf_from_index(ctx, i);
 
 		for (j = 0; j < imu->nr_bvecs; j++) {
 			if (!PageCompound(imu->bvec[j].bv_page))
@@ -8600,19 +8663,66 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	return ret;
 }
 
-static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
+static void io_free_buf_tables(struct fixed_rsrc_data *buf_data,
+			       unsigned int nr_tables)
 {
-	if (ctx->user_bufs)
-		return -EBUSY;
-	if (!nr_args || nr_args > UIO_MAXIOV)
-		return -EINVAL;
+	int i;
 
-	ctx->user_bufs = kcalloc(nr_args, sizeof(struct io_mapped_ubuf),
-					GFP_KERNEL);
-	if (!ctx->user_bufs)
-		return -ENOMEM;
+	for (i = 0; i < nr_tables; i++) {
+		struct fixed_rsrc_table *table = &buf_data->table[i];
 
-	return 0;
+		kfree(table->bufs);
+	}
+}
+
+static int io_alloc_buf_tables(struct fixed_rsrc_data *buf_data,
+			       unsigned int nr_tables, unsigned int nr_bufs)
+{
+	int i;
+
+	for (i = 0; i < nr_tables; i++) {
+		struct fixed_rsrc_table *table = &buf_data->table[i];
+		unsigned int this_bufs;
+
+		this_bufs = min(nr_bufs, IORING_MAX_BUFS_TABLE);
+		table->bufs = kcalloc(this_bufs, sizeof(struct io_mapped_ubuf),
+				      GFP_KERNEL);
+		if (!table->bufs)
+			break;
+		nr_bufs -= this_bufs;
+	}
+
+	if (i == nr_tables)
+		return 0;
+
+	io_free_buf_tables(buf_data, i);
+	return 1;
+}
+
+static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
+						    unsigned int nr_args)
+{
+	unsigned int nr_tables;
+	struct fixed_rsrc_data *buf_data;
+
+	buf_data = alloc_fixed_rsrc_data(ctx);
+	if (!buf_data)
+		return NULL;
+
+	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_BUFS_TABLE);
+	buf_data->table = kcalloc(nr_tables, sizeof(*buf_data->table),
+				  GFP_KERNEL);
+	if (!buf_data->table)
+		goto out;
+
+	if (io_alloc_buf_tables(buf_data, nr_tables, nr_args))
+		goto out;
+
+	return buf_data;
+out:
+	free_fixed_rsrc_data(ctx->buf_data);
+	ctx->buf_data = NULL;
+	return NULL;
 }
 
 static int io_buffer_validate(struct iovec *iov)
@@ -8632,39 +8742,73 @@ static int io_buffer_validate(struct iovec *iov)
 	return 0;
 }
 
+static void io_ring_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
+{
+	io_buffer_unmap(ctx, prsrc->buf);
+}
+
+static void init_fixed_buf_ref_node(struct io_ring_ctx *ctx,
+				    struct fixed_rsrc_ref_node *ref_node)
+{
+	ref_node->rsrc_data = ctx->buf_data;
+	ref_node->rsrc_put = io_ring_buf_put;
+}
+
 static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 				   unsigned int nr_args)
 {
 	int i, ret;
 	struct iovec iov;
 	struct page *last_hpage = NULL;
+	struct fixed_rsrc_ref_node *ref_node;
+	struct fixed_rsrc_data *buf_data;
 
-	ret = io_buffers_map_alloc(ctx, nr_args);
-	if (ret)
-		return ret;
+	if (ctx->buf_data)
+		return -EBUSY;
+	if (!nr_args || nr_args > IORING_MAX_FIXED_BUFS)
+		return -EINVAL;
 
-	for (i = 0; i < nr_args; i++) {
-		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+	buf_data = io_buffers_map_alloc(ctx, nr_args);
+	if (!buf_data)
+		return -ENOMEM;
+	ctx->buf_data = buf_data;
+
+	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
+		struct io_mapped_ubuf *imu;
 
 		ret = io_copy_iov(ctx, &iov, arg, i);
 		if (ret)
 			break;
 
+		/* allow sparse sets */
+		if (!iov.iov_base && !iov.iov_len)
+			continue;
+
 		ret = io_buffer_validate(&iov);
 		if (ret)
 			break;
 
+		imu = io_buf_from_index(ctx, i);
+
 		ret = io_sqe_buffer_register(ctx, &iov, imu, &last_hpage);
 		if (ret)
 			break;
+	}
 
-		ctx->nr_user_bufs++;
+	if (ret) {
+		io_sqe_buffers_unregister(ctx);
+		return ret;
 	}
 
-	if (ret)
+	ref_node = alloc_fixed_rsrc_ref_node(ctx);
+	if (!ref_node) {
 		io_sqe_buffers_unregister(ctx);
+		return -ENOMEM;
+	}
+	init_fixed_buf_ref_node(ctx, ref_node);
 
-	return ret;
+	io_sqe_rsrc_set_node(ctx, buf_data, ref_node);
+	return 0;
 }
 
 static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
@@ -9508,7 +9652,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	}
 	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
 	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *buf = &ctx->user_bufs[i];
+		struct io_mapped_ubuf *buf = io_buf_from_index(ctx, i);
 
 		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf,
 						(unsigned int) buf->len);
@@ -10025,6 +10169,7 @@ static bool io_register_op_must_quiesce(int op)
 	switch (op) {
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
+	case IORING_UNREGISTER_BUFFERS:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
 	case IORING_UNREGISTER_PERSONALITY:
-- 
1.8.3.1

