Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763D42FF967
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 01:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbhAVAXz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jan 2021 19:23:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49702 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbhAVAXu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jan 2021 19:23:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M08u7r027217;
        Fri, 22 Jan 2021 00:23:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=tBRXzD1NAUP252Frq4ueE1b3SDHXHh1WXA4BM6SAH40=;
 b=LhXZNeA4Ur+INGfOTdi3Qrt/D0WkURS0r/nnYvP28n4GiRJxoZ3QAvnZhXg3/ImIuyPs
 pRD6Py3dyBCD5rab9eXQE0Mssc5nQdE7AP57tAt+K92jFInUtVTYcb7H2Jx4+06XdMzc
 oirpBFQy1bQz3FwB4iWBKr2ZqSPZeND6lszMsV8SL8n/XuACsy6pHKHLMql/Q93JxJGa
 m3EUwsp3wyHJCvwUgx+Vn2hmFcMK/RrngRzEzNnrU0rckC8QTA87Zveb5Z8uMGgmjrXp
 rl8Qj1PmW7Gup6h4HPTqvupQfQ6s9GZ9KNcBupkpMGfchOtspIWkWaLCslUyJN7E7z/i Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3668qrhwvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 00:23:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M0A0Dm162671;
        Fri, 22 Jan 2021 00:23:05 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 3668rgmgdg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 00:23:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXy9lQByKGA7pQk7cQcVKk7SV4YC3FERKjWakVbnKgA0R3Pqpi76oMHPu0pj1xJjHKZWMkILb5TqgQkIjXt+Y74Uasr+oP6LJfO7I7goKzoHtSB4kz1oremKHrZgAFQJlF12dk5UrXFViI4swpk0DUEerqX9MB1WqubhSyXRwLQ5gzRd3ZM0pBsfSQH/+Qp2XG2zTj6M0wvKRF9QZ44wsFlIClkopzjU+53GIHsETEXbk83cY1rFjenJ02bEbpIPBeItWX4nvXgqiY+CNwNVEvzRMfPZeJhUhUI5xh14obJTFIDrNCPXdAynIfY/JgzAB0jf7fhibCnPU6NBgOLVEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBRXzD1NAUP252Frq4ueE1b3SDHXHh1WXA4BM6SAH40=;
 b=iWRoRCFDaATOmsepFTK2vR/J6ZlitY5GiV6sHJzt6DtYT231Xf9d9ta02DN8JOXEcjA/HDA/LHiz+waMJt1FFr0z04pisN10m+jTpJlZsaJYfPNBUqwff5n6Nry62JWoZq1vP9c63W+voPnCwtpGd33VFkG5LHXRGL4MbICaR6cLsc4vwKIx8e8siIccKClRnVPyusiYcJ7+cQK+QkUlS9CvYUMX2ZGttpF+G3D3rEqcmzF2wpF+GdExBliqQK/i174iGMsQ+5dTOzNbVLemprxRAsSUZdUo8HSDNWPWguOG63FUCZ4OlXYqFYAdZpbENUtf8dyymbbAcSSRSgtj7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBRXzD1NAUP252Frq4ueE1b3SDHXHh1WXA4BM6SAH40=;
 b=n9ZxP4RQsVeL+BvAQ3LaI0iYkIV0PxWjwE/0fCI3+moEkvRRoRCMkOitZl/eFmai7JV1iRxyhQqyTBf6+a625y3yuNoPzwNU1CZ0wzNhsoe2+GRAd7GabDo5Z51mhLxtbQYiOWLxSaBQUQm3uTchKj5sOE9g2lcbsy8PrG8U/js=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Fri, 22 Jan
 2021 00:23:03 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 00:23:03 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v6 4/5] io_uring: support buffer registration updates
Date:   Thu, 21 Jan 2021 16:22:55 -0800
Message-Id: <1611274976-44074-5-git-send-email-bijan.mottahedeh@oracle.com>
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
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by DM3PR03CA0015.namprd03.prod.outlook.com (2603:10b6:0:50::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 00:23:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 214e8d24-6ece-460a-ebcd-08d8be6be1e7
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4496:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4496BF2D708B798BE67CF976E4A09@SJ0PR10MB4496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:13;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGYlYHGem/tvFeo5awT+xeA3ECpfmAFGQF8ApnoIL8RoZhKbrYk4O5fZtPEMID6gPmCrDhzdy7ae5gURdwHzD+Sp7CA9a54LOhCr5wHcagOuQP4o+9YsL0cKWvoALuRJI47OUu9fCeSLjiKMyV7fq/xVJ+g3DhlfunN3t98oaaZvWk3CBQupcvSg33dkbyEG34rsbbAJwT88VQh1nh8dx5ZrV61CoDnrd9EITwvn9WCoZJDPZIJqYn5eEmxeFnlOCStEQkX64AsyIY6AJuZbGvIxR9j53Z4nuKjcNP7GP7HhBu+gNzZoJ8md5hKZpaURfUScOEsJYa2f0pHFeS0wsY1j0NNqqc1MvpaK9whIJpZiDh1B9nz4DyoWz7fp+1aQVVZE3Blckzf8DKvdLO/J6kDxDKZOaT+gQ3klJSd9dDhG44DzwqdwyFdR7uUd8+8RKWcU9iwUmj+vhFH7dJsfJeHVMsYDUXWdPCioKRd6h/JhyGedKO3shMb9Pbz3ICqynUrVplRvwK5RQgcUuLZJfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(39860400002)(136003)(6666004)(478600001)(44832011)(36756003)(186003)(86362001)(2616005)(16526019)(6486002)(316002)(956004)(2906002)(52116002)(15650500001)(66556008)(7696005)(5660300002)(83380400001)(26005)(8936002)(66476007)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qavMmGgJALGwGnyaMPvWRa5U92C+bSBAEc7U00bbcSMl8bO+jAkjk/2/B9Oc?=
 =?us-ascii?Q?VyuIBhZybMIGUHLPKYKHXXfRjM/J275To1WbeAwwgIViSQAYoUB+FT+MqcGo?=
 =?us-ascii?Q?M1EggdEhEzDgy643bG4RIKM8YCOM5wnFfInEP85yaCyyjlaSoQeGqX/ss7Uq?=
 =?us-ascii?Q?Caan4TNbH2p+f4EwX93rNRC5/NIC2jQuJ1Z4hY7Bmb6PwW/yKMCboBFg1ROo?=
 =?us-ascii?Q?ofvewPfSudAJuCu0pGJetACYaP1x5fxvR8G7Wd7I3vmQnC626qLCDJcvfska?=
 =?us-ascii?Q?fltgGnIRo7vWPizmr+lzbREFYpXj6KZ8FEi8X1NNSHsLIOpDsJqXKRg9P/6r?=
 =?us-ascii?Q?q/5kK/YD8o3Bk9MnB/yDkZSg7vVVEb0FOKZ8PDXc5NnQv/+qNc7nsTeDGgHQ?=
 =?us-ascii?Q?7ylhd4zq+wongfa+FuCwG5iWyvuBc579LRg98N6hTk8+Mwlv2iTgfaQXGRMj?=
 =?us-ascii?Q?RlQCWAjreQp5T6k7EAsEbX5mvVd2sRUYrI3H1dzb65H82M0Qo4UtfWej10hZ?=
 =?us-ascii?Q?00VqjunP4rFjnngNHZW0177cCZ6utGSaCW+7vJ+XAIIeGI0gFYCcjoE2qW4z?=
 =?us-ascii?Q?RqQgCgB3OXp0FyIqgxgp/ii0qiuJPhb9a43ZkxRvxiauEDSAjgUAflpn2cYR?=
 =?us-ascii?Q?iEuunLFFPvvp2GvZo7yODSiwW2zxhvSFTGA+KJsHBDnqsVOMH4lOwPae8UcZ?=
 =?us-ascii?Q?xMJ58Ce7JxxkZQ7Mmf8sD5U3AIJGZBk0/tdj5dQcFJOzoxgb99CsWS944dnO?=
 =?us-ascii?Q?XaalK7f/nU08GmUXx4tCbbVfzDzTu2esbO0YWZofXcfqIO8hbqovqhObYD61?=
 =?us-ascii?Q?QZf0e84TMUHj6v0xWxwbr+oMZjsPp/sYm3UygejhjYbVc73MnnsmPP6uiEyH?=
 =?us-ascii?Q?EIK60mVq0LuFl+bvZF5nMxKlS2+OCHfh9l4VSYJ1I/eVYCbfcPAFrQmLgolZ?=
 =?us-ascii?Q?GzrBNdQ4MuHLqazlAqRnf7AdwbPO5yawmIbwY22PpnA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 214e8d24-6ece-460a-ebcd-08d8be6be1e7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 00:23:03.4875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rztnhR0Ch1/ycyhfgCsT3A4BTi+kdDYPNrxU0k2ZVGWcYRLuK6GCvCcl3b4XmjmroIUeqmX8PGKbA6a++SMnzaKKDdQYgkRnaKqllG8Rgns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
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

Introduce IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE,
consistent with file registration update.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c                 | 125 +++++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |   2 +
 2 files changed, 125 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 62e1b84..15f0e41 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1012,6 +1012,9 @@ struct io_op_def {
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
 						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_BUFFERS_UPDATE] = {
+		.work_flags		= IO_WQ_WORK_MM,
+	},
 };
 
 enum io_mem_account {
@@ -1042,6 +1045,9 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *ip,
 				 unsigned nr_args);
+static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
+				   struct io_uring_rsrc_update *up,
+				   unsigned int nr_args);
 static void __io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed);
@@ -6016,6 +6022,7 @@ static int io_rsrc_update(struct io_kiocb *req, bool force_nonblock,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_rsrc_update up;
+	u32 nr_args;
 	int ret;
 
 	if (force_nonblock)
@@ -6025,8 +6032,11 @@ static int io_rsrc_update(struct io_kiocb *req, bool force_nonblock,
 	up.data = req->rsrc_update.arg;
 
 	mutex_lock(&ctx->uring_lock);
+	nr_args = req->rsrc_update.nr_args;
 	if (req->opcode == IORING_OP_FILES_UPDATE)
-		ret = __io_sqe_files_update(ctx, &up, req->rsrc_update.nr_args);
+		ret = __io_sqe_files_update(ctx, &up, nr_args);
+	else if (req->opcode == IORING_OP_BUFFERS_UPDATE)
+		ret = __io_sqe_buffers_update(ctx, &up, nr_args);
 	else
 		ret = -EINVAL;
 	mutex_unlock(&ctx->uring_lock);
@@ -6108,6 +6118,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_BUFFERS_UPDATE:
+		return io_rsrc_update_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6329,6 +6341,7 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 		ret = io_close(req, force_nonblock, cs);
 		break;
 	case IORING_OP_FILES_UPDATE:
+	case IORING_OP_BUFFERS_UPDATE:
 		ret = io_rsrc_update(req, force_nonblock, cs);
 		break;
 	case IORING_OP_STATX:
@@ -8093,8 +8106,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
 		io_sqe_rsrc_set_node(ctx, data, ref_node);
-	} else
+	} else {
 		destroy_fixed_rsrc_ref_node(ref_node);
+	}
 
 	return done ? done : err;
 }
@@ -8427,6 +8441,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 	if (imu->acct_pages)
 		io_unaccount_mem(ctx, imu->nr_bvecs, ACCT_PINNED);
 	kvfree(imu->bvec);
+	imu->bvec = NULL;
 	imu->nr_bvecs = 0;
 }
 
@@ -8633,6 +8648,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		if (pret > 0)
 			unpin_user_pages(pages, pret);
 		kvfree(imu->bvec);
+		imu->bvec = NULL;
 		goto done;
 	}
 
@@ -8748,6 +8764,8 @@ static int io_buffer_validate(struct iovec *iov)
 static void io_ring_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
 	io_buffer_unmap(ctx, prsrc->buf);
+	kvfree(prsrc->buf);
+	prsrc->buf = NULL;
 }
 
 static void init_fixed_buf_ref_node(struct io_ring_ctx *ctx,
@@ -8814,6 +8832,105 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return 0;
 }
 
+static inline int io_queue_buffer_removal(struct fixed_rsrc_data *data,
+					  struct io_mapped_ubuf *imu)
+{
+	return io_queue_rsrc_removal(data, (void *)imu);
+}
+
+static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
+				   struct io_uring_rsrc_update *up,
+				   unsigned int nr_args)
+{
+	struct fixed_rsrc_data *data = ctx->buf_data;
+	struct fixed_rsrc_ref_node *ref_node;
+	struct io_mapped_ubuf *imu;
+	struct iovec iov;
+	struct iovec __user *iovs;
+	struct page *last_hpage = NULL;
+	__u32 done;
+	int i, err;
+	bool needs_switch = false;
+
+	if (check_add_overflow(up->offset, nr_args, &done))
+		return -EOVERFLOW;
+	if (done > ctx->nr_user_bufs)
+		return -EINVAL;
+
+	ref_node = alloc_fixed_rsrc_ref_node(ctx);
+	if (!ref_node)
+		return -ENOMEM;
+	init_fixed_buf_ref_node(ctx, ref_node);
+
+	done = 0;
+	iovs = u64_to_user_ptr(up->data);
+	while (nr_args) {
+		struct fixed_rsrc_table *table;
+		unsigned int index;
+
+		err = 0;
+		if (copy_from_user(&iov, &iovs[done], sizeof(iov))) {
+			err = -EFAULT;
+			break;
+		}
+		i = array_index_nospec(up->offset, ctx->nr_user_bufs);
+		table = &ctx->buf_data->table[i >> IORING_BUF_TABLE_SHIFT];
+		index = i & IORING_BUF_TABLE_MASK;
+		imu = &table->bufs[index];
+		if (table->bufs[index].ubuf) {
+			struct io_mapped_ubuf *dup;
+
+			dup = kmemdup(imu, sizeof(*imu), GFP_KERNEL);
+			if (!dup) {
+				err = -ENOMEM;
+				break;
+			}
+			err = io_queue_buffer_removal(data, dup);
+			if (err)
+				break;
+			memset(imu, 0, sizeof(*imu));
+			needs_switch = true;
+		}
+		if (!io_buffer_validate(&iov)) {
+			err = io_sqe_buffer_register(ctx, &iov, imu,
+						     &last_hpage);
+			if (err) {
+				memset(imu, 0, sizeof(*imu));
+				break;
+			}
+		}
+		nr_args--;
+		done++;
+		up->offset++;
+	}
+
+	if (needs_switch) {
+		percpu_ref_kill(&data->node->refs);
+		io_sqe_rsrc_set_node(ctx, data, ref_node);
+	} else {
+		destroy_fixed_rsrc_ref_node(ref_node);
+	}
+
+	return done ? done : err;
+}
+
+static int io_sqe_buffers_update(struct io_ring_ctx *ctx, void __user *arg,
+				 unsigned int nr_args)
+{
+	struct io_uring_rsrc_update up;
+
+	if (!ctx->buf_data)
+		return -ENXIO;
+	if (!nr_args)
+		return -EINVAL;
+	if (copy_from_user(&up, arg, sizeof(up)))
+		return -EFAULT;
+	if (up.resv)
+		return -EINVAL;
+
+	return __io_sqe_buffers_update(ctx, &up, nr_args);
+}
+
 static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 {
 	__s32 __user *fds = arg;
@@ -10173,6 +10290,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
 	case IORING_UNREGISTER_BUFFERS:
+	case IORING_REGISTER_BUFFERS_UPDATE:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
 	case IORING_UNREGISTER_PERSONALITY:
@@ -10248,6 +10366,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_sqe_buffers_unregister(ctx);
 		break;
+	case IORING_REGISTER_BUFFERS_UPDATE:
+		ret = io_sqe_buffers_update(ctx, arg, nr_args);
+		break;
 	case IORING_REGISTER_FILES:
 		ret = io_sqe_files_register(ctx, arg, nr_args);
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f9f106c..32b3fa6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -137,6 +137,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_BUFFERS_UPDATE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -280,6 +281,7 @@ enum {
 	IORING_UNREGISTER_PERSONALITY		= 10,
 	IORING_REGISTER_RESTRICTIONS		= 11,
 	IORING_REGISTER_ENABLE_RINGS		= 12,
+	IORING_REGISTER_BUFFERS_UPDATE		= 13,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
-- 
1.8.3.1

