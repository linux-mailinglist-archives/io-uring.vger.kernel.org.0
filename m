Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D8D2FF965
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 01:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbhAVAXy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jan 2021 19:23:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbhAVAXq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jan 2021 19:23:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M09va4096933;
        Fri, 22 Jan 2021 00:23:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=xf9scBKManwOQboTSFPjf7VuH8lYFeryICm5nfgK5eY=;
 b=ABRG8NBPr49Vbk5DHhyjOS679MdNys9rSz3/JiKS3mZ6Ror/+vviVj1U2vpnW7D+114p
 8IWMJaCSJVLftyfR1e97OnaPG9gMIUesHAaONxM/ZTHDsUry3oQI6UKi50errrtqhaRi
 I06LtHzaWfO2E3UEJoI072SgJvaGXm1+C+vcOFhIkdHNWBaLouMMRgN47YTeNijn3iqj
 8XHXa+VUHrf++IAGNHbFrV0tHgOqR0+hjLZ/uHnAuzIFM9HaoHp6SRRIFXWfEUuUwuyp
 TXhOzErEqSThcQ9P/yYyin/XvJolZ7EtfLoksvJuA24CaJCDQh55KHHjENUlunweOybh LA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3668qahx00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 00:23:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M0AsGa127842;
        Fri, 22 Jan 2021 00:23:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3020.oracle.com with ESMTP id 3668r016pr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 00:23:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSOJE/mjhOdZ+WKWFzQSf1mH+j/Q/6OFC0rRJi7QWO78ZuZWGCpnVJ8ZGGc7JiM//k8BXw+U4ufC1fbNrdAjJ9zO7jzziTMTpE5gRLK29CLMnJLONQ/HG8fcHZKMuh853aJwlq63O0/ExkqCsjr4FZIc/fVtap0/BwZxMkfwb35Cb8K0CoMMrF0FjO9bPX35Ilh2NzUqsUI7+aG7Vc8/Ky/qj/8pBfQzdyAOgtloCLJQtl5lza+etAcI5oLAb6joGylcH/CtRLMHGfOJ6N6/utZj8fiCk81hci6PnDMLHWCh14n7/gVjcIMAX+il8H1C+03ZrxJTNMCsZVQpO0yiwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xf9scBKManwOQboTSFPjf7VuH8lYFeryICm5nfgK5eY=;
 b=Ze4K9WZtu8XGUIBO38WJQnkhZH9PTJ4ajF/YUrecRjafVAorIJH2e+KVKr/VqvJuhi2U1X92iPCKyZYae7ZWgTaaxhDkqaeQ6NJLp0S9SorTPP7l4F6RF0DBMFtQnnFbG1DafreNejIm6Vkvt67mINoVm4C5g6D360cbyMpHEkapwe637Co8Lgw7aqTT9Z40hcG/LxFpfZL+DGL3Y04Wd+rzCs9lXNWkpMm9o/0Ud/x+QAOYJ/zTYEVtTOdyv6Tb8xHGP+C9uug2v/vDiHvwRJl4sMX7cK9jyOGYS1MoAYsjdodkLzq8QZRDLA9Hv33HTcLESQB2GPZqdL6wAAksxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xf9scBKManwOQboTSFPjf7VuH8lYFeryICm5nfgK5eY=;
 b=QJ0X/kKczjNK3pXO6+GTPUvkObcEmoG9GSIcAirsPp30Opr1hmDkG0300zQTGFKD1Y5GPbJBTZ5073M3/Kyq5NDmmgOdb1iUjcbM9ew+zBqIoEXkbOlLdsnunOqU+jw8QQuyPQODF5/74e3ubCiifH5nI9cZxkOmP8kHa9dEnPU=
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
 00:23:00 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v6 1/5] io_uring: call io_get_fixed_rsrc_ref for buffers
Date:   Thu, 21 Jan 2021 16:22:52 -0800
Message-Id: <1611274976-44074-2-git-send-email-bijan.mottahedeh@oracle.com>
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
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by DM3PR03CA0015.namprd03.prod.outlook.com (2603:10b6:0:50::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 00:22:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48f0986d-7c0c-478a-f12d-08d8be6bdfc0
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4496:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4496973FC969043E83230BFFE4A09@SJ0PR10MB4496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q9Q5xuejoJirruh2IwLk6W8jrvR9RQUTG+F4M3TqTo20BcPGqPU13PjhpRIXhbS5gwJ6iBiHGTso3pKiIfKUVAIhdTgpW6X8v+aPnRAiGxo3b3sK+mSSbvTb/aEv2kLScaTWGK3OXN++K30KN2sX5PmmiuUn+TaRiK5QilWEK+stScXprGZhj3/KVUdOG1aYjn76Agv9y4/KDjNwIBW5ugGJnP4KnuCCLndr12uZZLGKktjsLgVn5RFbHwkJLYicb4rBA+xJWdDVO0efkL9ec8eM0VxLRf0Jgewf4tXS0/SxG5ax9cMRlTU3VosBOWPbAMJGUHOrIiJN69F8+e5lOGz/aRk8K/NWfQxI807j4VIIo6UIjGqzMExOotnKVE6IWB9upG8gizzytOaOCUH0pwKpt8rSzDcf+jnGRhycT2Sv293Jb/bBc07oaf5rZnH7ijNOhcpdFtqHehAEdNrq90IW6/fCIz0Dt5dXdzsb9BCoA6RPk2YjVzn9vGJJ4hOYqo0fzPZ+By2Rnf+bJ8NZYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(39860400002)(136003)(6666004)(478600001)(44832011)(36756003)(186003)(86362001)(2616005)(16526019)(6486002)(316002)(956004)(2906002)(52116002)(66556008)(7696005)(5660300002)(83380400001)(26005)(8936002)(66476007)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?arSrt2aiKWm9oZ/zXc3J9HiT8M+yy4oGM5Uakus7hbLoZb7hfw6IYhqk3pHK?=
 =?us-ascii?Q?wRs8jwESFcja9t17KYtlbMj6z3H0kOzzamUz1I6II5TGCldHWZnrAzMm9YOU?=
 =?us-ascii?Q?PngHKuQ07fkRn9ymM+V55V6wP5VjyjJBmMA1ypkgdG8fUJC9lEunTKJgf+lu?=
 =?us-ascii?Q?Vq+piSs4e10MTYbVHhr1zeTsoyRTrAUlNGcfxANbpN3AGHsjawIGXlkwz2bx?=
 =?us-ascii?Q?OTP51l156UjYWaCIZNJnXKZLx4MWVnzesIzl1wYO5VJ/hYPkNUZc9lVVKj7i?=
 =?us-ascii?Q?15nIGMF17uWvTXPwhRgcOwwdVu60Gm627UCJg18PPu7ocgay7i/WgSYcZmQk?=
 =?us-ascii?Q?Td5wkooYS4YesGAKWABxCM7x15KoDwfcgcYy0mi4RWXWnPLa6E1Oo33flZ7W?=
 =?us-ascii?Q?/uqrVGESrSPxtSvtAMFPGxM+715V4UEPMb6ZmLdQitW/3D+blPj3bE+7qbDa?=
 =?us-ascii?Q?Xi6gLt7J0xLmVI4mZvBpyg4cAFxKSNYdpLZ0vNP5xvjK0oJ6wRaId4n4eAgl?=
 =?us-ascii?Q?wehQyWUNo3nbcWfZGrnp6WJ2pf0uaWGTfdi+0+Dm3o/ochjVHjcbFGD2Nzva?=
 =?us-ascii?Q?giONGXxggmrOm6o9RnXSvM5t2iMRB0xh28L/A+JQ90i+XB9cveKmQViD3gaM?=
 =?us-ascii?Q?m5q0ykkI/LEXCRGeteTiS2WyDv2ws9FP3msliN/kH+JMAxA45pOP7RMcp1hl?=
 =?us-ascii?Q?f3mBgDsJddFVZLRE8C8GBOKosLJYXsD5IRNMan5AxHLvbWnARSuOMZl+Gpt5?=
 =?us-ascii?Q?D+VkFlY5U8f947shz8b0wFNyIgzVZEa1A9boGCTQSEfGMH/ByimV+Ewljitp?=
 =?us-ascii?Q?oMTAZQ0yDzlDxFqffcmN6euJo1kVmS+Xcplsv5eBD9v/jdDZfbyyDep98ev+?=
 =?us-ascii?Q?hbTNSSzlKznlQGvdWz7ekXQXHC9JPfRb+f61t2LaR3zocLX4PFVNGmK5H/uT?=
 =?us-ascii?Q?51jR5O/Fm3fV4kSQnsIOPlkctNdN7uBoN4xF1zaFYJw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f0986d-7c0c-478a-f12d-08d8be6bdfc0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 00:23:00.7111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q97D6jao396pYKtN7za6HLN94+QnK0J7Y0qc6arQHmsJhU9O3G3tUGYokcyqs3/7kAtAgEfqUt/M/zre5ctj30oqXdrEMLnFuZPQLBQLcWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210119
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210119
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_get_fixed_rsrc_ref() must be called for both buffers and files.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5bfcb72..416c350 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1068,12 +1068,11 @@ static inline void io_clean_op(struct io_kiocb *req)
 		__io_clean_op(req);
 }
 
-static inline void io_set_resource_node(struct io_kiocb *req)
+static inline void io_get_fixed_rsrc_ref(struct io_kiocb *req,
+					 struct fixed_rsrc_data *rsrc_data)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	if (!req->fixed_rsrc_refs) {
-		req->fixed_rsrc_refs = &ctx->file_data->node->refs;
+		req->fixed_rsrc_refs = &rsrc_data->node->refs;
 		percpu_ref_get(req->fixed_rsrc_refs);
 	}
 }
@@ -2940,6 +2939,9 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
 	req->buf_index = READ_ONCE(sqe->buf_index);
+	if (req->opcode == IORING_OP_READ_FIXED ||
+	    req->opcode == IORING_OP_WRITE_FIXED)
+		io_get_fixed_rsrc_ref(req, ctx->buf_data);
 	return 0;
 }
 
@@ -6439,7 +6441,7 @@ static struct file *io_file_get(struct io_submit_state *state,
 			return NULL;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file = io_file_from_index(ctx, fd);
-		io_set_resource_node(req);
+		io_get_fixed_rsrc_ref(req, ctx->file_data);
 	} else {
 		trace_io_uring_file_get(ctx, fd);
 		file = __io_file_get(state, fd);
-- 
1.8.3.1

