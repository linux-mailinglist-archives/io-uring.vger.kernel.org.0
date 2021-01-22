Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9856301065
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 23:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbhAVW4x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jan 2021 17:56:53 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52970 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729037AbhAVW4C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jan 2021 17:56:02 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMsrMX154480;
        Fri, 22 Jan 2021 22:55:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=r2CnE5ciXbtdKoSIzDn8RgVjTAKJjOFcn2m26m4s1TE=;
 b=vgmlHX+k+OZbIjRjJkHUM8gT9wQfm5jjZRtpzLhqsU/oXmOw5YQPIssuMaIH1gXz0cFb
 WsYQki3Bgf5q+naZ0uknINsb4Yb1RtxaKT+bLaPsFHrYVWwS+yEwkYwpgoR1hlijjE2x
 NklmLjR69rrvgtIhuVYHKULj74luk8+AW9fgbPytZoMXLZkBQqusLs6TXBtgIVSIxYYi
 u6WFO7LcfNxtmFWSQ9T80t0z2mWVeM+psJHaER6Bvg1ZD08+8+e/FF6DcwHF6YzmLg/6
 MkSnq6LKjUuIbbHU1oXCunpZIsbla3c3TlrQ+DK0Wuuldnpj/aJF/1ehTrIRvU6d7JUn Xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3668qrpj7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMt0Os162490;
        Fri, 22 Jan 2021 22:55:11 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by userp3020.oracle.com with ESMTP id 3668r1pqjp-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwuT6S+rUy3aNZSi2KbdAfgH5zepWMUnLgXZKvt5eUSZrTrZGZ0J7fqLGc/FMnvZfgyylXS7wMEWbhTs/FgRHZUvBVtbjuSRA7r8rrg2uFnB5SDnUqW8WYnELFzYzplgjWEYdL6y1LfniUMGCixgSxG+Guc/hFbEaQEbk9yqQU1W6eSVvO/v7/CNMxKb46z0ogNxbWPfvHvUoA56Jgi815o9PtTImpUvDpWbdqQOOz+wZfl4oqaz4rbQkRXH47F2vUBItRkalPphwclKmmmmKp0eLAEfvP8wkZuugoiREojViH6K2p5sO1dnxsszRFMlkgxN5XXzdpjSOmYveDeH6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2CnE5ciXbtdKoSIzDn8RgVjTAKJjOFcn2m26m4s1TE=;
 b=i0wMgEZs/UKuO39MlpO1A6zpczszdknMNqZmo8GOWEfH+a95vn2djK6hNhuZtfu7qFEr1l52pLQyI4mIwqX9x6tf+bo0p8xelCuNB7kp8ZizNZIHVMOlFGWrddRIOs+stxitlNN6HeLUSymKP3RaZN1a07wr4vIQGsootbnnfspY4Ay/IeyburxmkjTbG4nvsQXSttArN+2NTfBoWe7F/rR7slcWlt7UjHkuel6DLUU6nNsBSysHpaC8wjG4e5DEAP8ZdovWCLtYeTybZekRt/OL6hSKAzamczAVI8Uqmt480taEvIxPCRMyJ3RyzeyrpDBVLJTsr1cA0nHBnpvKBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2CnE5ciXbtdKoSIzDn8RgVjTAKJjOFcn2m26m4s1TE=;
 b=Fso5KpA5YraYluOHN8ADqSFYfpwOvWH1jcMAILBbvRrAkuW0P6W5qqfXV9xMVmD8WByTQ8K8zMNF4S5cE8Rsim9tUiWTFgEWdwUQrjG9rNtTEDodLodLXZ8NrLFnIWNgKuHznOlNHzEISt77MJfT6z17Yr/tDIwTm6gLTQ02a3w=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by BY5PR10MB3827.namprd10.prod.outlook.com (2603:10b6:a03:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 22:55:10 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 22:55:10 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH v2 08/10] man/io_uring_setup.2: document buffer registration sharing
Date:   Fri, 22 Jan 2021 14:54:57 -0800
Message-Id: <1611356099-60732-9-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611356099-60732-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1611356099-60732-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain
X-Originating-IP: [138.3.200.3]
X-ClientProxiedBy: CH0PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:610:77::22) To BYAPR10MB3606.namprd10.prod.outlook.com
 (2603:10b6:a03:11b::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by CH0PR04CA0047.namprd04.prod.outlook.com (2603:10b6:610:77::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 22:55:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48fde3dd-5a4b-4af6-9195-08d8bf28c50c
X-MS-TrafficTypeDiagnostic: BY5PR10MB3827:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3827FBF184A29C8E50E8D76FE4A09@BY5PR10MB3827.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KOGCyH7V/5hhXLzMlXHfaxFo4RGMlEtaGMgmoJJZ29fTpMiMddK415XmGiiKpqPRW5wNARYegNakcrnJVkbR7hr/fZIMig4wZI9p9OdDLPxP4RPwEtexVdE1DH0kGC84uCiy3Avs/Wtcv0Dag809HYFphrOG1rVcC8p8Sl801CeC/OOxWY67IBvp+g57RshsgRT6NMfcL/IzMXXHpX3fEroBLKZrBage2LLhV64oNgFDQe/Y/gGOUhv2G3P/OZcDQbIhVXoU55XiEvxysFvKgBURioBTLOhonhaQ8kvkuSaeetw+RyP5mkjZ7KRw4CgVlNkt3CPCBwWCJtr3maGNyAapQvOQYllRozoAeyR4HMk5qT6gMcvgo0+V2TfmyoHyBtmXFPIOEhknjOURYma7xQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(44832011)(316002)(52116002)(36756003)(7696005)(2616005)(956004)(6666004)(66556008)(66946007)(66476007)(2906002)(478600001)(26005)(86362001)(5660300002)(8936002)(8676002)(16526019)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5HqgRQQpE4ihFACbT/WyuwbVHFPNryFnR/p1HX+uciu8LB1TWGkv9kHUk95S?=
 =?us-ascii?Q?aGgHwSYdGCQN1VSfq13gQrFdpUdreD7n+rqjo9w1ACvtpysrdSJEvYA/RGOv?=
 =?us-ascii?Q?gleBRABoFY+oQfTrM+G655YBdBSWJy38fII4izYtFz8AmSm0ExfpszrH9d7e?=
 =?us-ascii?Q?xU5UQh8hGqjfTZU71+viTjZL7uUOSSMh9ap1RUT49HCFEr/LdVlqNom/Sqor?=
 =?us-ascii?Q?7Aj0HyM/oSx4vpgzucoLbG98EcppKj08zwACIZuy1vsoIDC09hSqFWM8IDfr?=
 =?us-ascii?Q?f1Lh7py6kH2hLr9xOEDj7Fy1+Gy/af3s04M5vjirnR2uRl1uoK97BeuASEbU?=
 =?us-ascii?Q?uWqd1OxQWiOZMBwRxj12t3KUVD5jakem8l545TcpNH8DGhPWpKurIcWgHjJf?=
 =?us-ascii?Q?SV5MqTwmm4A74PMQmqYo2GQKbXQ2C0ygyDZ/kh9k8zQz752E0OKoBnmZrgUd?=
 =?us-ascii?Q?Bdady8i0sZ7wkA3sGFEUOZjvyj/fLYXukdSUDeN2Nm3tJ7kwAcPv0buM9KW7?=
 =?us-ascii?Q?kRIsO1m34fDCa9MOrtH2D5JM5wgSBkp8PQ+4kbSE5Rrrx+DGk72axkDGEn+W?=
 =?us-ascii?Q?hS4UAPK3J+wfWFJWIxSnOC5OBM0di+Pu2toP/+lhYGhagb6DP1uJr2myXUUI?=
 =?us-ascii?Q?cd0rgTxw3AK2uNslkDDW/FKQmZKw2pqaNekqizI8+ONWdQzZyS8iPXDj4Ip0?=
 =?us-ascii?Q?zioRqkmhIwLQcKykFCHr/0U1jA1Wza8R1EP0JaHeTCvdE3Kf5rXQtXZhfq//?=
 =?us-ascii?Q?XH+fKm8Y3TlQr0/6eFVjQibs1WtNER0disRz8wrk2YGIbZdggQ41OLxtOElX?=
 =?us-ascii?Q?AofeuerubwCmz2GchE/wu1zBlWpelMwqRyggBlZ4zTAZNbMjo9+NcdFzh2jv?=
 =?us-ascii?Q?KxOequiZm0BQPeq17WDag9r4B5ld8rruEGngl6p/q3zmSJSTJiJ/Djec0uYk?=
 =?us-ascii?Q?tWL1shUk4qTMUA/N70fNpPb7eoZR78c2O0p1mhX788c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48fde3dd-5a4b-4af6-9195-08d8bf28c50c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 22:55:10.0456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rN9nhEw0CJEZnObhbX5+F+yd6vq6xQRvFMhDcxq9hMVtVqhxzH9tDhM9a45thzVMouQaVkA08i+it1R7nXPcPyPvT4wpmBoZ6jy5JZEzP4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3827
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220118
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220118
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Document IORING_SETUP_SHARE_BUF and IORING_SETUP_ATTACH_BUF

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 man/io_uring_setup.2 | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index 3122313..0297bf1 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -166,6 +166,18 @@ exceeds
 then it will be clamped at
 .B IORING_MAX_CQ_ENTRIES .
 .TP
+.B IORING_SETUP_SHARE_BUF
+If this flag is specified, the io_uring ring allows its buffer
+registrations to be shared with other io_uring ring instances who have
+access to this ring's file descriptor.
+.TP
+.B IORING_SETUP_ATTACH_BUF
+This flag should be set in conjunction with 
+.IR "struct io_uring_params.wq_fd"
+being set to an existing io_uring ring file descriptor. When set, the
+io_uring instance being created will share the buffer registrations 
+of the specified io_uring ring.
+.TP
 .B IORING_SETUP_ATTACH_WQ
 This flag should be set in conjunction with 
 .IR "struct io_uring_params.wq_fd"
-- 
1.8.3.1

