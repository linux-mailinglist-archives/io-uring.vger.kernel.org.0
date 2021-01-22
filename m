Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F059301070
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 23:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbhAVW6A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jan 2021 17:58:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55604 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbhAVW5x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jan 2021 17:57:53 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMt1He154552;
        Fri, 22 Jan 2021 22:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=QSSIGZebVhpViLP9TEs5deRBa7T8b50Zb/pggGI7Ee0=;
 b=GKwQTZDTlSvA8WMHQn3eWNPod4FQXa148jAswU8xQbfbU8//5Gm13eL4CrmEFI4NYOWE
 POH4hXiFapnzrPCoQmQpdmJmXMv1qjSNH2MzfNoyUyQol0T7+pWmiH+U+teyBDgXu2JD
 ifPEvJIr0XHwSISy3iLovj7y2WuQnavyHZX+QoIXCLMUOGE8auwtgCKGpWz+STYybCjY
 cH0jcbguRNb0SgRluKAcB+KK1x9DlquNsMTSOy5qtWikf1hEC2MsrlgmGvIjLak45Rr1
 iOmdx07JdzjfEulqB79qx7l40uu+MgPlE6oleWhn+yKPymlFTv3GoCJgpec+CA/vTVeq Sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 3668qrpjq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:57:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMjsIK062865;
        Fri, 22 Jan 2021 22:55:06 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2059.outbound.protection.outlook.com [104.47.45.59])
        by userp3030.oracle.com with ESMTP id 3668rhjqpt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oK9HgzF2zLSnGqLrAtIkio1FJb7aJsIauZtArbpBluzZdIXO1QqljEoJD6sPeYbkeF8+wD3iA4fyitXTge+ibLMVVn3nFueGuaEfJyMkh/to+g7q2WQVvTjRBnkax6nvqydT1jxcsUI0udNdQpsfQs2LxGy+nZz+NtAuD37T8qNHCPkPk/e+rPSf/a3p0HOkq7NWVIAIHkG5TJH2/VFEJhiuOY7bWLc68H/W3F0cMx/EvhRVcAoZNY7iKLXZM3GFdR+JrkctOjXHze2JO50DOA58+R+OKVUKgKP6ZsQTDsv7fJuBh24WrwgvkN50OsJvTWEmbblx4ZLqOkodMwZbKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSSIGZebVhpViLP9TEs5deRBa7T8b50Zb/pggGI7Ee0=;
 b=IYVRMHAijyJalisS91RxaTaAXOx5UUQs+l02IZdHGwqBLra24lath40MOikjh2rm0TTYkCOcFx6DTMLBJZ1+BUV958O9ErikvgpZDEnZFFH2uAkM2wIJaib6OVO3AoeXxwjaSOmzY3x6vIcIdLThSQI/Rfoq+Q3HAsPuPlqMJiqbltMpjwoUPZXyDNYTrfM5yqqCiv9bStWBX4wduIxfYlw72BAr9CpO1h7JtA8vv/3pTy4fZvgVG5uBDmpmNluKdpof1SORU7WzGyPQYuMUeUj6ljjv2ElTZ4f3EaNZ7SutLI3fp72CZ3Eqh5i6DyVNr4EQEK69do/zLXSXgBPbtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSSIGZebVhpViLP9TEs5deRBa7T8b50Zb/pggGI7Ee0=;
 b=Xm5NfGxkvqXOaxj6v4m96I6LY4TmnARjlInL70WEvRBBAGAxufz5YEvITunu/QFJUb0hly/Ee2ZSVU+hfrAEVNiygX/syuRKu8RCfFb5CXRR3uMD1cuYDfqboAOQyiIYd2mdhvb3rVB44V/L8VWoFmA1LCn2K6Cpj8mCj31cKxY=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by BY5PR10MB3827.namprd10.prod.outlook.com (2603:10b6:a03:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 22:55:04 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 22:55:04 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH v2 02/10] liburing: support buffer registration sharing
Date:   Fri, 22 Jan 2021 14:54:51 -0800
Message-Id: <1611356099-60732-3-git-send-email-bijan.mottahedeh@oracle.com>
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
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by CH0PR04CA0047.namprd04.prod.outlook.com (2603:10b6:610:77::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 22:55:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c69ef938-a10b-47cd-b109-08d8bf28c1b1
X-MS-TrafficTypeDiagnostic: BY5PR10MB3827:
X-Microsoft-Antispam-PRVS: <BY5PR10MB38270E6719D55D8312908DF1E4A09@BY5PR10MB3827.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:361;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZYD0fuU/PR/Z1KUfBsCOFHLzHLYufQeAonDDyPLEVREE8hc5RW/Y9bKEFwRyY41CGkVPQFCMTtYZZqC4Wu1kGXIEybViwymqEsElPyzOgB+pc1YwUx35vsu9Llw/20tqczob/iqnSvARhcyiH6JoPF8+HnqqjS+IzE/G9G+6hyPUylZ2uFbZfys51KN+dJmtCRySjGp9ARaFmE3h3Ssj1WzysNv+ffDaxBflcElvBxc/4mEIQyO2FvSL4ebwuqRwMBVzUfX3mrJbW9DksN9TN8tJwLnp0CFy1xj5LJ3gRwUQ84KQqrEaxES755qC4PIbhZOAAijStyxHwRpamEzOG0BFnoYDPP57m/NbJNkpeE0Dir8MFVmpivhQPBHnKto3fYO2ncwDd2vSAbAZzb2uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(44832011)(316002)(52116002)(36756003)(7696005)(2616005)(956004)(6666004)(66556008)(66946007)(66476007)(2906002)(478600001)(26005)(86362001)(5660300002)(8936002)(8676002)(16526019)(4744005)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TQB0m4VCDj3qbf10iDrvjRsaxpj03bNbId+wjtAHhRD7XJyQpNpL2cAkVPYE?=
 =?us-ascii?Q?ILBZzfc8+8Jz4wAZHMs3gJgLFP0WfDt1JAGna6Pr1KMobzvHZdFH6T+SkAPD?=
 =?us-ascii?Q?K7NWKXfcI7GTSjEd1XtQ0pm/oD0tOcqv8pjcyvbNpkYLdUjxBWUQ9Pw4witj?=
 =?us-ascii?Q?4UKXVgfiVrdSeDhjMnFKAnx58N06TQzyN83X2A+sYzAgt7Q2KvSrQYz8TV0I?=
 =?us-ascii?Q?C69h3qWdHaArEXuwQFbLonCCRNXQnHOEiK6ity+Pcef2GOd2XOpbdyiiIkR5?=
 =?us-ascii?Q?iMQWXIHmWD41Uhg4QEEEWjOXtVQGg0hgwf7o1RlD7zR5IAoXfXrRXyA0SAv7?=
 =?us-ascii?Q?AkafXTtGVRjc8c3ye/VVS5lXb4H3/qNbDR/OC3NV2Kx22QgB7+mloncKiwDK?=
 =?us-ascii?Q?kn0CKyGSzbl56/jN/AUbDUMkBX4QqevF5X56b5LWawWRaYI+CqmV+u2D1IoI?=
 =?us-ascii?Q?Inpcw646QK5A1ZE+UzYSTP65Z8wZIXzJKEhSWJObX+/E2fE4HpB4bgA4MKqA?=
 =?us-ascii?Q?hncsKS8BQAUCCY/RovVrgdx1F5mCguG3orfsOGTwCPj4Vvhb79WhChWyzw+i?=
 =?us-ascii?Q?m3pjwB6JrFDG/9yJQKhiVO8O1NaTOU4abhVeH9HTSO/IUwmla097uHRSoT6t?=
 =?us-ascii?Q?ao81z/cgt3chOhPKaSPNy8JtEfplPoCkj9S5dZ7TuOMVbV92WNmyiYV0VPYD?=
 =?us-ascii?Q?Owg3srBmgk315NDbkW59oaVub1pOqCXtVtOdSGjDSeUZ4gVbKFd6hZEHVTNn?=
 =?us-ascii?Q?4KH69K3OM39izEkTQMObW2EDe7H3CctXyZes3r0CGBYUiNOS1xd7U7toADtm?=
 =?us-ascii?Q?oF22yYZzMbanf7xE2pHRZWKhficOoSu0gqfpX/4K7lTyaDVaMYmuH4LcN/x4?=
 =?us-ascii?Q?5zeQ9y/O1JXr1AYOz5fHS32br6CrCy+QD1b7RkPc3eTTLs2AxjPwcJLFYgvo?=
 =?us-ascii?Q?n7n3IwM322eQ05Vvb4Kp85pPDuZscOqyTD74OhVPQdk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c69ef938-a10b-47cd-b109-08d8bf28c1b1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 22:55:04.5148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FuRj7p8w+m0EM3Y9ZvrzUO/X387/oW+i7tYuuUDOm/QFwfZAQsUbGoS+iAJnixPP2spFp0WRqWMKyOhZTHEtsuxN4nmekRvJmGu5CcbIrXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3827
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220117
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220118
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 src/include/liburing/io_uring.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 1ee9a0f..c85ab40 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -102,6 +102,8 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_SHARE_BUF	(1U << 7)	/* share buffer registration */
+#define IORING_SETUP_ATTACH_BUF	(1U << 8)	/* attach buffer registration */
 
 enum {
 	IORING_OP_NOP,
-- 
1.8.3.1

