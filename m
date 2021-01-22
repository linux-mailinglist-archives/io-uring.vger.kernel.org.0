Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876F830106B
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 23:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbhAVW5V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jan 2021 17:57:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41040 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728435AbhAVW4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jan 2021 17:56:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMro1I154512;
        Fri, 22 Jan 2021 22:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=CyXb3Cm8mX6gaP9qZxpM/mAo2mK3FQt6rfyAp/r8gKA=;
 b=JiQPk/CiYwmV8VdiRbk5AhJwe++CGuGZfYcFubPuzePrukvUmdf1o3Esvgx0K/qSXH99
 HTPPIwlgAZfvel7o0gJTha6VI7wlWOO9wS53RCSJTlZ5kBajUPhIgK2PBq9oFV6m4pW9
 tlUn0mR9Sj+O/JDGz4oqRqhtl8CO4wVTcRXa74mpTqWbI9QLU/GYzk4CCPgLoHvnW7fd
 mnZ+8ff9Q/VsRaST4BinAJpNOIqjjsmbsl8ZC0O4qojkstk1OupCWPTOvjf1HbwZhtDZ
 7DjCFzlixeWbpvvtyCpKTdafFUvKDIWAWSA51MUx96hbRj/58xoU6ac3ZC9xviATNK2/ 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3668qaphpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMt0Oq162490;
        Fri, 22 Jan 2021 22:55:10 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by userp3020.oracle.com with ESMTP id 3668r1pqjp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gbi2XKrcvziBC/ZCHlWX23Ln5GrXMtSKXVDqFfiZMibL3mzYvThsCSL/iICgryDY/A3MsoGeeqP6JJWQbjFkoLkit/fZHijp3GOuY93W68CS2ay90hh1ayyU4IMxKGXA+hFD4BQrUpFJdtr1+ihhFIt3wjhGjE0UlAgePUR7dwnImeRhO3kvGQzgVxax8s0jR6KrTKdGDZtwylOA39ll+5MLYMsGwtIMI1Nf6limDozgW2y5UOfx5m4pM4fbaQODiIEttrlBl4Tyy33+R8tcIkU2i4+dP0kNXHs1N/qwL9ftu+A/B6gIkB62Oe/BYQ8E4WIiJIcHLGd68ArO7g17pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CyXb3Cm8mX6gaP9qZxpM/mAo2mK3FQt6rfyAp/r8gKA=;
 b=FYcwJQuuTbPNF/rlBsl73dcEznIp0pVQbomflpoRGAXgP8zzsX5lL+Khudkdswg1ZP9DJnkt22SFC6o3g2T+XGFocVbwH+NlyNsq+vTOXhKBjYBSavA+pNIM+4+eeaA/JeUG6XT4+xBkTA+jwWzqY8FzhnndMp7xoZS9BVF55HcFUE8vpRz+IegZr9JY9t3A702FgU9IM5m4NeBOvVyuLioKAyL0eP0kuRL1iCeFSmgN9khG7SVmIDKYGfZ7Wr2z+laXshwSI3ni04FWgu1/fHyxEr6fWsbUu3XB6eB7k2TQzJxtv9X77uJYXu0z63wo3KcWdKFPIr+OpFcZdwjevA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CyXb3Cm8mX6gaP9qZxpM/mAo2mK3FQt6rfyAp/r8gKA=;
 b=HBYgG8TMLPxuP1AbxVoFAiyEfAngztH1BE8/2gzGrW9tcjzDg2kcN4w8HsMmtKJSnavHjjD1OxdTqwgOElCRBdG8I3bRaWUyhFfBxvwCsfOaJDogXqIO1tFvYKJP5LkrimkRFpw9bXYMRixgDLkciN22wZ2mk66AnCmF7jgHZiY=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by BY5PR10MB3827.namprd10.prod.outlook.com (2603:10b6:a03:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 22:55:08 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 22:55:08 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH v2 06/10] test/buffer-share: add private memory option
Date:   Fri, 22 Jan 2021 14:54:55 -0800
Message-Id: <1611356099-60732-7-git-send-email-bijan.mottahedeh@oracle.com>
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
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by CH0PR04CA0047.namprd04.prod.outlook.com (2603:10b6:610:77::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 22:55:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2bd3016-d89e-452b-831b-08d8bf28c3f3
X-MS-TrafficTypeDiagnostic: BY5PR10MB3827:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3827D05EFC728042C413A2F9E4A09@BY5PR10MB3827.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /l17U7ei99zlWjFdRY25pPsE9xrT2BGzA/xJ4UX5dsiaIcNSyrFr+dDg43g+6VyNzkctIsa7jq5W88dxQ7Jh1MDbOkc9q4GzXrAxWt0cFpsOBbXujGX73KNE9o/Zlgxh5RIydI5BfT7L2cNYCLDwPBbZCBjikk5FBNo1ZgK3o/CU7FER+Nnh+p0pekwRznk+mEguMSvJ1nxyAWs53Xi+HYE3da9Z5qgP704YXBfOBIx/36wrq/fUElKNcNc8QhvAQql50OHrKdHE4/5YxTF20HHomlErVrYiJoJjKiLU6+6VUj4Dhxj4RMgvhNCXglWKERAWabnSS2aPV96QLa350LTlg4UmwhgV7dSGBysOKhFlVqpROF4XoDy/vjj5GkQvs4Je7CZAbFybdy9hQi197g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(44832011)(316002)(52116002)(36756003)(7696005)(2616005)(956004)(6666004)(66556008)(66946007)(66476007)(2906002)(478600001)(26005)(86362001)(5660300002)(8936002)(8676002)(16526019)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2xnlMQx3uLstgLt67PtZBqxsWO3uO7qroq3pgKcePex1+yVpHTJvq2SzI0RB?=
 =?us-ascii?Q?riW7otAbs6md5JS2N4485lP5/1pn4zGAr4jiORLDCOEkAOyFqBcMWyRjTINr?=
 =?us-ascii?Q?SkBzjh8g/3r3wDrqcYQr2rO95CzBhblGCrfCeFY57xaY3f0r6iADKhI7rLYl?=
 =?us-ascii?Q?1By72JSIda938Chckh0Dxhp95IN05NsX+G9P5UngD5m6rcfRe5lHgr5rxEr7?=
 =?us-ascii?Q?rBSOgXS0TJqDOPInfOtwDHDcuHaob7SjelxqZv66WRx9XoAZCqHurbu0Vmar?=
 =?us-ascii?Q?GJLUroWlQKyRPc5EcrsgNAx9860ZC6bd9esqBbp6yFVDOC2ShkWJz8rmATjM?=
 =?us-ascii?Q?/ZZdjsZnxaBkYYy/MA3xXnfozQtk3J9W/NB7xN29gOay0vtbUc6lG1XT+4YY?=
 =?us-ascii?Q?CdZZu6BptPYluoUTarfkKCTNPMwT95Ii2BNdHz84y95LJpFVufM1sKG7KXbs?=
 =?us-ascii?Q?NPfVlpsPRIXDvBjHp67vWDmnGQtCxsDpV3+sA9J+qi/Cbl9Li9HMDHFbxUJL?=
 =?us-ascii?Q?LBH25CkNIsLlAx/LpsvkPQ5CipcOsPhkHHju2hZu3mIAD3qxBFMOw4Nm9akb?=
 =?us-ascii?Q?CUL2LSk07vXCbdhLjt0CM1Dr0TpC8oFFkfa37gd9UTT3RK6pZtW4T3jb/KO4?=
 =?us-ascii?Q?JZ0ufL5vp7VV55wHMzUr1BgjxpjpBvNsjWQd+8CFrXlxOMbFalai2CY1AVMu?=
 =?us-ascii?Q?oLHTIUAk2+D/F33Ly6uEoFK/8F7afbHqg5bLF5we1bmnq4qZJ7KpjZKd1Ifc?=
 =?us-ascii?Q?31g1rgmOCte6r2hFIBKigEoce9DFNqgPbXhIUoWhhiLxZYBxq9Bu9G+SpIBS?=
 =?us-ascii?Q?CrTvmcHnqqXUIgsFlWpgBnUQ8DitbBtBnn0EQ3uSN4ldkXNFMIroL94M7X25?=
 =?us-ascii?Q?YQy2clTod6YDqHs3acaxNLajXNV4gAyZe56pX3wZmC3jpn7Dnj2rbI8cMCQm?=
 =?us-ascii?Q?imX4NInhO52xkOmINE924Mh3XHKrocVA/pRkeie3yd4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2bd3016-d89e-452b-831b-08d8bf28c3f3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 22:55:08.2007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GORMx9V4aaYuNuXloagRaQ7roATga1fiDox9tsTt1pzxjgL1jLXrz9kCIvk0rQCXBh+E9tRMZfZKz9Zk9b4hp7tuVfCPEIzg5U6b9SHTZrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3827
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220118
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220118
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 test/buffer-share.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/test/buffer-share.c b/test/buffer-share.c
index 81e0537..cbfbfb2 100644
--- a/test/buffer-share.c
+++ b/test/buffer-share.c
@@ -18,6 +18,7 @@
 #include <unistd.h>
 #include <string.h>
 #include <linux/fs.h>
+#include <malloc.h>
 
 #include "liburing.h"
 
@@ -71,7 +72,8 @@ unsigned long shm_sz = SZ_2M;
 
 int no_read;
 int warned;
-int verbose = 0;
+int private;
+int verbose;
 
 enum {
 	REG_NOP = 0,
@@ -1120,8 +1122,11 @@ main(int argc, char *argv[])
 	int shmid, pid, ret = 0;
 	char c;
 
-	while ((c = getopt(argc, argv, "s:v:")) != -1)
+	while ((c = getopt(argc, argv, "ps:v:")) != -1)
 		switch (c) {
+		case 'p':
+			private++;
+			break;
 		case 's':
 			shm_sz = atoi(optarg) * SZ_2M;
 			break;
@@ -1155,10 +1160,19 @@ main(int argc, char *argv[])
 	if (shmid < 0)
 		exit(1);
 
-	shmbuf = shm_attach(shmid);
-	if (shmbuf == MAP_FAILED) {
-		shm_destroy(shmid, shmbuf);
-		exit(1);
+	if (private) {
+		printf("private\n");
+		shmbuf = memalign(4096, shm_sz);
+		if (shmbuf == NULL) {
+			perror("memalign");
+			exit(1);
+		}
+	} else {
+		shmbuf = shm_attach(shmid);
+		if (shmbuf == MAP_FAILED) {
+			shm_destroy(shmid, shmbuf);
+			exit(1);
+		}
 	}
 
 	create_buffers(shmbuf);
@@ -1178,7 +1192,8 @@ main(int argc, char *argv[])
 	ret |= test(TEST_IO,  FD, REG_NOP, REG_ATT, TEST_DFLT,  EFAULT);
 	ret |= test(TEST_IO,  FD, REG_PIN, REG_ATT, TEST_EXIT,  NONE);
 
-	shm_destroy(shmid, shmbuf);
+	if (!private)
+		shm_destroy(shmid, shmbuf);
 
 	return ret;
 }
-- 
1.8.3.1

