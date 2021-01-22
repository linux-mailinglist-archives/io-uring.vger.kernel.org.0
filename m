Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322742FF96F
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 01:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbhAVAZv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jan 2021 19:25:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35466 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbhAVAZs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jan 2021 19:25:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M0AJgN163987;
        Fri, 22 Jan 2021 00:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=VzIMhhFR7w40XRJg+D/zBt6A9xskDWiKFGOyYlwAWAs=;
 b=tnXxT650GkGmR4nDXlXb5G+EjtjRnKMZVssm/xZIJwzmoweZhHzTNlwBPpVyg9dzFJsM
 e70HT7mq9Xmus1wHaZt1hUf8lf4eneZju+erQBnSW6bz7xN3zwgNwvelKCJmBu/9OojH
 MC0K3syTCDObBtyyobJA1Ln+OAdLIGyf+GnDloBB163/w4PD2mwE3XQlXv1u2QtBG60g
 xR0XV5tN5pw4chwIV5GTRGE2FFmHCDhjU5iFpa0iERsJQAugItOC4N9tSbYWNO/DxErn
 uQsdqsmFn16vL4xeWI24p2/5zc2AFLOPwjcwgXkwaehQRwwcR6gJPX5Z9B8lGShQ4Y5I 4Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3668qn1vxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 00:25:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M0A0Dl162671;
        Fri, 22 Jan 2021 00:23:04 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 3668rgmgdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 00:23:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLyUlfNjM4XNxnaauf69kJF6vcynnQQY5VEZ4ANPeK8uD6OiBOiBGW7YcWCXLmU/CfE/3BFmTWnTE3Q0mM6DvGWx/LdMFCAKJw1dOrM8go5fWX+A3o9Uw/X8oq3lrPLxzycmNjZJvbGzY/3FfmhFtsYwNnm1SYnfK7jrcCT8n930KDCAAS5afzPLrheLYo/06fqCQY+3OYJYFGbMBYq1jm8kfNkUjhsuPkwq6oS53NbuNupT0v2kOKoBT8adJPwu3IGYZxFdKvpmg+r7lNLdOEJx3Va/LWl9nWnjbMH8AarGtIn06YxzclGrBLZpp1zTWFb9mXROMz8GZgDa9hYN+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzIMhhFR7w40XRJg+D/zBt6A9xskDWiKFGOyYlwAWAs=;
 b=BpDJE4UoIdMkwseWjprJf+zp9sJgkXi7uVxfgdXnd1p2lp/dZm2w+U6L0nN2RbFM5aD8YM1MKc8m0vYZ+gIsDEH+JS5a/oQ33+kNwD1n9SD825X7CNKs8lU31lr7n21t7xry//vZx819lE6MFUjn5Lqm9BW1PNxR2H1jxjNwTSpHG4T3spxSt+tpuQCLUImeXh0LWsWbExMal7VqC83lgOCfoIGObYYFdy2MIsKXK2LbZ6ViTsJ3ALNwbTN83IL9Ekz66uLgj8dLzswy65GEHxHB+SFklpCq/nUlku4M+2d+FWThybwc2e5kfF+rjYQHBvsoXxbVqqejExix2NJ+GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzIMhhFR7w40XRJg+D/zBt6A9xskDWiKFGOyYlwAWAs=;
 b=AZ9yTYPkNxBhA471fpJgdXjkvTY526u38f924vRUEOciF0PS9g4f9TOirvCX3I+GyIgbGO1QBRLTRBlJE3VAfk7cKHeFWIevrWbnDV15Bttjd0Q6X4ZSVy2mki5fTIJoAoWhZR9Yx2Hthdk/ip7uU/8wlyeBxd71o9LF7VVMtFI=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Fri, 22 Jan
 2021 00:23:02 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 00:23:02 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v6 3/5] io_uring: generalize files_update functionlity to rsrc_update
Date:   Thu, 21 Jan 2021 16:22:54 -0800
Message-Id: <1611274976-44074-4-git-send-email-bijan.mottahedeh@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1e4ced03-b495-4ade-745a-08d8be6be154
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4496:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4496EA515CDB0FCAC39191D7E4A09@SJ0PR10MB4496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iCZHhqV59kYT0k/ygtpjDMi8xBJSNjjw2ux2B+eJqtmw9dhSJt6UimMsJzpQ+LbMAG/Z7njmIw3zHkCThp8Nay0MCh8E+1b360LdqN2Khn/Ajc8ZPgtI9xczj9W2oOXU2SEIjfCe/FzMiGulFTWFW85Jzp5K2+Lybo7dy+sHjvA+HPgBWNniUBXvF/+2CTFuz2IzaGrn+0eSSsk/C3k8hvDVYZ7pTQVS0AEdB2mBGvJipmuIbf1regPbQvmzolf6EdxP88lrKhoRtLITYOHhsiH5mktMCsVzq6LD1BgpIflmFiBmCBVcP8xJ5i90J/XkugwHkyJh77Unf37mc3CmGgj+/eg+ly9ul5tH8sk8euFpp2EWV6xLCLZFZm1lENGyDSg+C27U72WVOhoWIxpCwPwLnsDTYHA5clCbgMPyprUB64TB1B3jOmDDEulTeEU7rnxclbYY1uB+ORbo/UzHgqFofdsTw0NtuVeinr4G84xhXwaSg1DexMMMcN32AQrUlcMmyEJt3cwBXbtdPQJ4Tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(39860400002)(136003)(6666004)(478600001)(44832011)(36756003)(186003)(86362001)(2616005)(16526019)(6486002)(316002)(956004)(2906002)(52116002)(66556008)(7696005)(5660300002)(83380400001)(26005)(8936002)(66476007)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?83ZqzMrn17HWW7zQD1mXSzOUaMChfzm+XqLq4IyacBlcuKy9+Nbdo/i23gXs?=
 =?us-ascii?Q?DqoEsUl/epZ3LbcdjeBqinNn5JoD0Pbh0no33db7IUpFqBU4sKv4GHzHwE3d?=
 =?us-ascii?Q?xbBs15pw09G2l4LKo95kFSt3kNf1vlnEMNshMsXwtg5Z1Rs5GS8kCEPSu3j3?=
 =?us-ascii?Q?vhtNxXV7NCBdI3VD69k6EXiJoEmpl/JCUWuW3iBoxy0TObT/SSbgses16Ehu?=
 =?us-ascii?Q?bzVoYPryAHyhwo2OeBCTRZyZVtp5IVavwjtx615Ajc9zVRfS0KOKolK7oZSb?=
 =?us-ascii?Q?1Ey/k18GxC5ejMUbUpZyO6viztPJ9nDfNk+c0jnHkoxdQqO6bxnplO+P2Ye3?=
 =?us-ascii?Q?8951I/nna2p9E5RVPm5OkI7fyx/ZsFtrRtqkQsBXrT2BjeHrQhmThatfPGIx?=
 =?us-ascii?Q?R37CIOrLFM2OkDkF4vUZReMoS+01eGrsnSP7YkQQ1E+D3U9ZMI31XXqKgDho?=
 =?us-ascii?Q?IAtS0UwlZ0j+wDsLO2NjbCvCHfyflTFJ6nTcBGPzLQC7ekMtRkOW2THcM/rg?=
 =?us-ascii?Q?JY7/lTJXbRt7qSgEDuSnCAcYb2yu80EsCQJSy2S9sGF0qjGEYzjfnRGTWS9/?=
 =?us-ascii?Q?/t23IKUp7jEe5XGbHkyqo5IJbbYsX38Gl0Hg+DL9mp3yI2n3pr5Y1Yohh+Ff?=
 =?us-ascii?Q?w3oiySJb81I95RrqKTlMyYwLrQsASJHjH9gR5fujPcvFoj6iaipmCpIen3DK?=
 =?us-ascii?Q?0Fu9xFX2qeXocUPVQ07P5bkXa1568Qkw6HvIy3lQihjOr3kZLBNuC2Vr7qQ8?=
 =?us-ascii?Q?pg+thUoFvixiWRqF5Qse6HvD5wvVz3WMhoGFcRDqV0XPYV1cCPHtSKtRyJKm?=
 =?us-ascii?Q?ZCDz/U1qd/dP/0DwX6jiJPLD/WU5hq9lxhHx98hBCIKJjalb9F4R9niMfBcG?=
 =?us-ascii?Q?sZXlz7jV+TE9bmllyu7J9Z3ANDOHxw98H4PZleehxVsMUKuwz8yRCpoiVP+n?=
 =?us-ascii?Q?p1Zo2exKa6rlZHaoS37/8Rez8bapAbraztJlZe8XJjw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4ced03-b495-4ade-745a-08d8be6be154
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 00:23:02.5740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3doCFn9jkoX0O+ssX09NMYasPFEaOnNRbVTddFTotmLcW+4wIZkcGSSPxnHVzoXqDEd8gYLBSdxlQJ/IVjHIng8xFanzkUnLaWvufRRPmXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=1 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
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

Generalize files_update functionality to rsrc_update in order to
leverage it for buffers updates.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2f02e11..62e1b84 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5994,7 +5994,7 @@ static int io_async_cancel(struct io_kiocb *req)
 }
 
 static int io_rsrc_update_prep(struct io_kiocb *req,
-				const struct io_uring_sqe *sqe)
+			       const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
 		return -EINVAL;
@@ -6011,8 +6011,8 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_files_update(struct io_kiocb *req, bool force_nonblock,
-			   struct io_comp_state *cs)
+static int io_rsrc_update(struct io_kiocb *req, bool force_nonblock,
+			  struct io_comp_state *cs)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_rsrc_update up;
@@ -6025,7 +6025,10 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 	up.data = req->rsrc_update.arg;
 
 	mutex_lock(&ctx->uring_lock);
-	ret = __io_sqe_files_update(ctx, &up, req->rsrc_update.nr_args);
+	if (req->opcode == IORING_OP_FILES_UPDATE)
+		ret = __io_sqe_files_update(ctx, &up, req->rsrc_update.nr_args);
+	else
+		ret = -EINVAL;
 	mutex_unlock(&ctx->uring_lock);
 
 	if (ret < 0)
@@ -6326,7 +6329,7 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 		ret = io_close(req, force_nonblock, cs);
 		break;
 	case IORING_OP_FILES_UPDATE:
-		ret = io_files_update(req, force_nonblock, cs);
+		ret = io_rsrc_update(req, force_nonblock, cs);
 		break;
 	case IORING_OP_STATX:
 		ret = io_statx(req, force_nonblock);
-- 
1.8.3.1

