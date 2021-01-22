Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B1C301074
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 23:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbhAVW6i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jan 2021 17:58:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54692 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728403AbhAVW55 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jan 2021 17:57:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMsat4046308;
        Fri, 22 Jan 2021 22:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=pZTnxN3b4Fv8Ha6kzveKCIjO9nxUM+ukLhSA2Xeq4w0=;
 b=SiRpp3v7uapjwvN0z0liMJYjX6Z4mWxOSS1WatOcVBhPES2aj2nur1adKG7uP7a1Qh2J
 Wq2c1Kl78/PXw9iU1dXhBJdbx1xEOFHHbZwuR2fg293GlJRhuG8zG930ztjDIgH1UjFl
 LMPqUyKLGlatJkTWNe2VvjbEASI7i5gUltz+SSaiikN2fcVP2wb7zSQJASbxKO648TWP
 vUr2CDu0uouiauAkwN0E2fLvbBizX6tE4vlsxmRRiXna9/mPGs9qkaIYlhkt+363N77c
 MRoWpYDvNfd4Vk9pHWFC7mkXR82Tzlcv63mHrC9b5dj7fhHQ8thkdEYEBoSfkEIO88j1 qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3668qn6hup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:57:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMt0Or162490;
        Fri, 22 Jan 2021 22:55:11 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by userp3020.oracle.com with ESMTP id 3668r1pqjp-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abAVgB6LyPkXjMOYEtkCYAdYv/rYMLukceJBxZfMzTEasucRTxIncC+FZdbdsAuLT1iEOsLBGJfHzloAsZiGJZR7P0mN1rPKQQ9uWOHMvUul+AGBj1UVa0MJrq/ERAqUTiyN0RlXzIA/pDbG+NqXbdoEu/IRW4DXVdDAayynGAh6wk1vwy38P33gBr29YraJRL1lXZlxi7cZGC6SiEIme30AmVJiGyiTiQHxGEBnbrgqihvTSEBxB36JfPYlVz668bA1DU7xsowa3//yU5PZhKzDE99/tVEM07WA7Rn2nCy/PZygBv/UrcTNMOnkXbmLZDQMgI9N61nBVZ0uuB1V+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZTnxN3b4Fv8Ha6kzveKCIjO9nxUM+ukLhSA2Xeq4w0=;
 b=hP5f6uT0pDozG1d0yH5h/+7erK9KoiGZqW/OyrNzC1UINrX0ggWtTB67uOBPv/JB8q5mFUc9ETRfoT8i/Aj9Qc18WPh42QT4pIdhN6AGfpWkNgG6gOyHHbi91aCdT7VBGPZ6wZY88+IkFfwQfnO3g9wuocPCJijQkMxIwqioBcbI5B/2loz2x99wUaAxboB5gWN/Z3itj6CQD53f+CuUCdjVR5oVHQStuIlq0gf/vmEZdnvhTi6m6d1ZDYsfnt3/VvlIafth8L+Y5zx8Nffr3EEcU2DhvdSL/yRGkj8wQwybfqbYijr6fQUiMzX7za7VFjR4XRN0PavoLsTCZ/SHNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZTnxN3b4Fv8Ha6kzveKCIjO9nxUM+ukLhSA2Xeq4w0=;
 b=btdrF79m5PYe8oaza3fE++QM5GwoapR1H5pvAVyFqbKp8Sa4Zph5LS5Hd6KKkfirxS6Hh4w3bwCibkcCPE3+YRM7ZjgtxlxAT5OSKTO9fbaId5Bp3fHaoavYk+UiMoOJ1ZUElQb3BvyumfezNmqfnhLGQCmwMWxE+3E7vFvNeK4=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by BY5PR10MB3827.namprd10.prod.outlook.com (2603:10b6:a03:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 22:55:09 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 22:55:09 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH v2 07/10] test/buffer-share: add interruptible deadlock test
Date:   Fri, 22 Jan 2021 14:54:56 -0800
Message-Id: <1611356099-60732-8-git-send-email-bijan.mottahedeh@oracle.com>
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
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by CH0PR04CA0047.namprd04.prod.outlook.com (2603:10b6:610:77::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 22:55:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eb8d4d0-a58e-41da-63a5-08d8bf28c47b
X-MS-TrafficTypeDiagnostic: BY5PR10MB3827:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3827CD8634B1F60EB314D754E4A09@BY5PR10MB3827.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RpcC8Zea/NJoto2mw+jusPnqU6wY+tN+UtN+9OTXVQVB9f4j1kvV1nRq6iayhxUIGda1R3NkK3EUaEFE9d5zjfKP3sFVLN6pbhAdn2aBcHOgI8PBnwGhXK5axzdarN3Bj63rPmQyKz8CO0EGvvXXBYD5DLjZ4RXgQRLvGm7Yovin16wSNqEmTorSFNa4r8HMIuQ/5d1bSCx9SmrfnmjRMyKEHjq1tK/ez5GTCzBozY62oAHIfbm/1rB6xovzNFX/ZjMKMDoYwD8T57TjdbcMwRUOSOYeqQqWqPy6syPRJHVBQ61lCWKk7Dh72hPyGqg4yNRhuurqRNPO2Kjn57dyHE/7A++AxrbTE0BmTFMsMpaVxJP1zpSwLwkHyfKiz+i/7Qhf94b/djkQ62jy8uxgkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(44832011)(316002)(52116002)(36756003)(7696005)(2616005)(956004)(6666004)(66556008)(66946007)(66476007)(2906002)(478600001)(26005)(86362001)(5660300002)(8936002)(8676002)(16526019)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hiusV3hL7VXcyLc0fPtU9OKiuvzz3LCfFK/1JiZcRet7qlV3c5LaEywSXNss?=
 =?us-ascii?Q?HDO1RePlf3bzQK96yKdiZ9Q8n0dACiKI+xqgYXK0cSEnoF/iyvmwn5Ki1IeX?=
 =?us-ascii?Q?vbRle5LugHyXXKU1gaa0vT+WZWbnyYzcrcymjRlXcY3GEZjfPQqlOLU510Rc?=
 =?us-ascii?Q?mCNLXXHEFnnk1DDOJ9e2DkJIUfm8rJcOG4eK0SFj+7pqVgMXouheVKqJzz/x?=
 =?us-ascii?Q?j8OXJmOAX0NexNGIP+LkfWE5im2Is4tDHwAkLAjGQ3Fyy2i8P3S7Z8AKN48r?=
 =?us-ascii?Q?H464/4XF4OitmOm7n084Ekd8tjEDncgw/AhbASRKnP9TldaQEHVR2kOD+x66?=
 =?us-ascii?Q?9UBxVzjCinfEBXfjV/GQi5qJhreUFXdOhvx2wEzrvgoCaYpu2Ckfhgtarh0O?=
 =?us-ascii?Q?mkuXzs4Yd1569zw7vD+/tdgGuwubJWBUWJCUsARqO0viBxwiu2l51LPqqxSv?=
 =?us-ascii?Q?BTQEZPF8w/d9+xM57kdqIv0BMIZ9EfChxU8q76dGoYebw8DZy6VWMy86Y6l4?=
 =?us-ascii?Q?V8pGDc2NRw6C9XcmQvMImB7z2baQDAJrmxD+DBeodCUC62il/eaqz1TYD8eY?=
 =?us-ascii?Q?2Rphl35/Rr484m9cOw9AhFlqj/SEHOHFc7fF4r2ho+2MOEz8CaCPVX8QxaBF?=
 =?us-ascii?Q?4KE/QnEllLX6GOt/xj8olwFq8vRS5OW6fPJ+tfKBie0TnnmeBSHoqs8/lSpF?=
 =?us-ascii?Q?0b6XrFy4J+CHQ8vJ906Xsy+HAW4UJLVWWM5WwLoW8XCx+b3+DBVHqkEfwndb?=
 =?us-ascii?Q?wMMZVOTngzgo8CJWg13KXjoVjGb0OWQOekTSM3up4/bzTQWYscDeUaqdosxe?=
 =?us-ascii?Q?pkfAnHdMe7CuCFcABwN9hWxDSqbtoZVbnlaTg41K3z4qI3zmHW0M00IOx2aE?=
 =?us-ascii?Q?ftZts4upHr6BBJasO1WKqVJszfMWP+lRvcFCuO5A9AbIT31GoSfv7AT/icr4?=
 =?us-ascii?Q?6lY8h9gheMw6hRJv1g27TTxiz5es/XV18U8R+aH/4eo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb8d4d0-a58e-41da-63a5-08d8bf28c47b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 22:55:09.1261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EkceDJT3Nm4VdmLsY/gQD2agkze8IKNgV/RDUviwAnO2DqIpZC3lG4PwZgPYRluyjuDkOE1Pv6wrh+QM5m9rq0zNsAUPge1jQ/I2RQdMBJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3827
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220118
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220118
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 test/buffer-share.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 84 insertions(+), 1 deletion(-)

diff --git a/test/buffer-share.c b/test/buffer-share.c
index cbfbfb2..2997333 100644
--- a/test/buffer-share.c
+++ b/test/buffer-share.c
@@ -72,6 +72,7 @@ unsigned long shm_sz = SZ_2M;
 
 int no_read;
 int warned;
+int deadlock;
 int private;
 int verbose;
 
@@ -1095,6 +1096,82 @@ test_exit(int expect)
 	exit(ret);
 }
 
+
+/*
+ * Test for deadlock scenario raised by Pavel.
+ * Test hangs but is interruptible.
+ *
+ * [Pavel's comments]
+ *
+ * Ok, now the original io_uring instance will wait until the attached
+ * once get rid of their references. That's a versatile ground to have
+ * in kernel deadlocks.
+ * 
+ * task1: uring1 = create()
+ * task2: uring2 = create()
+ * task1: uring3 = create(share=uring2);
+ * task2: uring4 = create(share=uring1);
+ * 
+ * task1: io_sqe_buffers_unregister(uring1)
+ * task2: io_sqe_buffers_unregister(uring2)
+ * 
+ * If I skimmed through the code right, that should hang unkillably.
+ */
+static int test_deadlock(void)
+{
+	int i, pid, ret, fd0, fd1;
+	struct io_uring rings[4];
+	struct io_uring_params p;
+
+	for (i = 0; i < 2; i++) {
+		memset(&p, 0, sizeof(p));
+		p.flags = IORING_SETUP_SHARE_BUF;
+		ret = io_uring_queue_init_params(1, &rings[i], &p);
+		if (ret) {
+			verror("queue_init share");
+			return ret;
+		}
+	}
+
+	fd0 = rings[0].ring_fd;
+	fd1 = rings[1].ring_fd;
+
+	pid = fork();
+
+	memset(&p, 0, sizeof(p));
+	p.flags = IORING_SETUP_ATTACH_BUF;
+
+	if (pid) {
+		p.wq_fd = fd1;
+		ret = io_uring_queue_init_params(1, &rings[2], &p);
+	} else {
+		p.wq_fd = fd0;
+		ret = io_uring_queue_init_params(1, &rings[3], &p);
+	}
+
+	if (ret) {
+		verror("queue_init attach");
+		return ret;
+	}
+
+	vinfo(V1, "unregister\n");
+
+	if (pid) {
+		close(fd1);
+		ret = io_uring_unregister_buffers(&rings[0]);
+	} else {
+		close(fd0);
+		ret = io_uring_unregister_buffers(&rings[1]);
+	}
+	
+	vinfo(V1, "unregister done\n");
+
+	if (ret)
+		verror("unregister");
+
+	return ret;
+}
+
 /*
  * main()
  * -> shm_create()
@@ -1122,8 +1199,11 @@ main(int argc, char *argv[])
 	int shmid, pid, ret = 0;
 	char c;
 
-	while ((c = getopt(argc, argv, "ps:v:")) != -1)
+	while ((c = getopt(argc, argv, "dps:v:")) != -1)
 		switch (c) {
+		case 'd':
+			deadlock++;
+			break;
 		case 'p':
 			private++;
 			break;
@@ -1146,6 +1226,9 @@ main(int argc, char *argv[])
 	if (!nids || nids > MAXID)
 		exit(1);
 
+	if (deadlock)
+		exit(test_deadlock());
+
 	shmstat = shmstat_create();
 	if (shmstat == MAP_FAILED)
 		exit(1);
-- 
1.8.3.1

