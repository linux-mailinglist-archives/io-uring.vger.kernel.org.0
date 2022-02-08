Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1324AD264
	for <lists+io-uring@lfdr.de>; Tue,  8 Feb 2022 08:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348497AbiBHHla (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Feb 2022 02:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237648AbiBHHla (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Feb 2022 02:41:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F43C0401F1;
        Mon,  7 Feb 2022 23:41:29 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2183uVFg027133;
        Tue, 8 Feb 2022 07:41:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=/r61dqGQQU6Awo81DpNBRii8EhlZv0w60fnANaW0jF4=;
 b=aQd8wEE9iKUkQ4YMj6fHcQzfuN6eoHFJuoLNZLmBAOJZ8o+oCVLYmh8AEEGrBRPUKZ3G
 P1ORMNAIqGUJULnm/IZNSxZQpc+Zj2PEvRuheyRUDiWEgpizZVgPE2i14ZYd3jFtozEy
 jBrpZRwKMwTnDxHxC1kh0m15nCQmvNLxAKCdOzKN3jO8CkI42YaGWsI77sG2++rceAjI
 BEmf5fNyCFJAVbLgURaBZNIsT7WFxNNTn/wpNNCY3C5DhP0Zw78nTYYMcNkTOxbkwAxF
 MHqAfuucHOtcZufjJjjhYjqSli26Ruw7SxWANkjplwhKJYvEvYlY0uCRyhT79dBfB8ea aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28gffj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 07:41:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2187eP7B054356;
        Tue, 8 Feb 2022 07:41:25 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2045.outbound.protection.outlook.com [104.47.74.45])
        by userp3020.oracle.com with ESMTP id 3e1jpq0wan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 07:41:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgHCITkorCQNIKIJLHmvOSqlUMXTbN90UMGLW5b0HJfn5MlzxsU0muR7HdTsh8b0i2qDIcF1krjRxqf4fWaDvHy/R1RBhM09hLgTxICzZCVUe2BZuOzWSLvlK9ww/+9gFzXE+ztZOYHM0AmpnhYxdzfpjig5JUzd5zast4pKcWyh557Pv6XpvYNtRjWxeKoZJqPQev/EbmoYGoDxweP4G0CKCpSzCLUqWnkr+ET97VN4RazYRIs+f0pIBpYl2MmFL+mPGcKEEBD+cs0vkLnSd74+461N9v/yjZluFEiDBOSnlIOaWomk7gi08QZd3tQpvlUu9PHHwXjKKeBwYvOoug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/r61dqGQQU6Awo81DpNBRii8EhlZv0w60fnANaW0jF4=;
 b=euhrhjyq+erMfTv0hadS7fG0HMvW1isYpEK/clUG5+19hiBBHNIWbioxhNqaAdwh6tkrolyOItqfTjkGnJZm5W4ET/dGNLuT46c4DAEzxXBZ0I1epgM4nQb6HVKkLsxWdzOOpd9GmLeEf3F8x4CX4pkqopzHKiwjJ1jf8rkwNJ931hoMVMW+o7+RLrWcdWGAZqLLF8D6KZTVRT2sYlZDDtpvL8OzXj3KTLvgTdQfweSlctJYmfDozOi36wTFzZVb8AVnASjaxcYEzJnbm/I/RzR63GnnM7Z6mc1Pff6Qn9vdpgjyG5tKe6eBzsm9Mn/KzrRhMLiGgW0scPHrYY3Miw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/r61dqGQQU6Awo81DpNBRii8EhlZv0w60fnANaW0jF4=;
 b=jqcKNgjY3J6f3WkLOmf1tJu0x+Cqi8Q1xJlTA9ib584DZV/3OLK/mX2O3kjKFlRAU+UgQiAlGyVBJUQp3V8l7fqcmDERMwIFQNX1gK1zhegkn/eePf3YDspZUEFt959wiB7X5ecv5JMSzW5JzgBs+RGKb+qpNqLsEotRZw3U8Xo=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Tue, 8 Feb
 2022 07:41:23 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 07:41:23 +0000
Date:   Tue, 8 Feb 2022 10:41:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>, Usama Arif <usama.arif@bytedance.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] io_uring: fix uninitialized error code in
 io_eventfd_register()
Message-ID: <20220208074103.GA26588@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: LNXP265CA0057.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 663ebf45-5c72-43e3-f363-08d9ead6676c
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB53443F0A5A329D9FC8C048848E2D9@DS7PR10MB5344.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:213;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WbCl+IScyiYJsbMRq8BUE/h9uk2ezjwL0G2obnak7UrGqSVzyY+GZ4CCwIuIZEsP/Nn/SZ4q18CzZEoPhzrgjF4UyB8pMZmsDAu9+b24Bqlgo0XLWDsIb7nuZBf75WUlmnkD2+awhPHQCrin4U8vk6OncYMptmgWDuc4zKHedL2ud9EzaoGmRIcBD8J50P3K1LdjMTjhMjJJanzxI981b67eBH4ic87pqPvqNVliOL69/fBTZ2nUDEYI7fPIxINaGqZ2fiOw3Z3JJrBtyzoEGroDlSNg7oZVtsyqO3X/3HgnYo7JlhZtws8WWIZ+H2xjBnm43mjUxOlW19j1NyrDG1hj6l+2Ans/hFq2mNUzSpyCZhkajLL7Y/pUZrGPA92FQLY+Ypkfx6CblK6VyrqeG/AurQHHp7qvSo3HB0995cuDogpGMPoS+E2MQN9ECxbwpkf+yz5n4xc87Kcyd/oFqI9fw4MZQeRTDwdhokMISjfJblHTEdonmOBUAkzkVAObhj+oFqXUOnJ4Xep16f60tkn54Kt0mVmp0NPrNc4DRuacDVNAhbEwaCt01bfEqF1e2wS4iVBuow5laeJ2nc8BG93nxCwn8Z0meSojyUyELfM2rLA5MIrrG82rgQTVRmh1q2unT6I7H5PbXoFgvbgfxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(86362001)(52116002)(6512007)(6506007)(316002)(4326008)(33716001)(33656002)(83380400001)(9686003)(6486002)(38100700002)(2906002)(66946007)(66476007)(66556008)(44832011)(8676002)(8936002)(508600001)(6666004)(110136005)(1076003)(5660300002)(186003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q1DaGHY+exwInQ3j5vwW0NM7Jqm+lr7ciPtKYuhKzwLNjUZMwqHmo1QqJLnc?=
 =?us-ascii?Q?YrlrapM15gXF/ShuO9xvPVLZTBMxT0Q1xmQelruNloKTErdVdgspzyPsakoZ?=
 =?us-ascii?Q?pEFoLVBLPxysB9wZ7BXIJZD+0gWYLQ2LnxrPp8r56uhENdgyYjtCsdWgsUbn?=
 =?us-ascii?Q?oS0PbMOTxEF1G5P5yEer7dlZ4U7Wv/S1LrfD0SbJU96+YBfpXvCcaroXx8Ab?=
 =?us-ascii?Q?mqfMLLF+J47EjsxXHlNRDv1yzWw0Zw/ETuSevmx2bCuhwDNjINs8ULBcLyJ6?=
 =?us-ascii?Q?owPNdzx2USJP3hVbZoQb5fGU8ahYeXXwtJ8cahc95imAeYAGUgwfYZBeyrRL?=
 =?us-ascii?Q?kneHQAgoahdY+I54W2VgjFohh0vut6IajGGZKkzULqcgKeIjhsqt4SS2uuck?=
 =?us-ascii?Q?g54KLYnfv4EDSeDXnyNdzU9IcQCkPeAlShauLSH5DYbfsOnlAvxSSpW4Un2e?=
 =?us-ascii?Q?Vvxw5AbSSvSqhuCOVbSePXQExAgHJ896D3hFrSigCzMcOX1IxLNUj4R6pvek?=
 =?us-ascii?Q?D7FC/MuyuNM3lGHSumHHy+9I3TkyjiagQF0LElDs04U4BpcwcvNrD2zxCFWW?=
 =?us-ascii?Q?3zMQi+OCCora3q/NG2zjoYZV0m5rGBKJ1HyCeZh3Ce/b5YewNc7mD0/Vxd7P?=
 =?us-ascii?Q?kKAkgwuyJilxKhJy8eWPAeiWQaWc/CMfF6vAobGCa5V/ADmCNlCkQGr7QhGj?=
 =?us-ascii?Q?Tng6qIQXvMJD9tO1sUSG/gVfhYXmrtqXbuqh/FWtHmRLnB6ERRW9481UDpcL?=
 =?us-ascii?Q?ufCrt0F9doQiRr49j53G9lMxRpu7SbkLjzz3bffJv4Mnqs+7nNHcg8PdxOee?=
 =?us-ascii?Q?aGx91ODCBCFsJirEgvu+y6ytwETaNentRJFBw76N3RPMzRqeLBeLcu9A909z?=
 =?us-ascii?Q?j0O/kzLqVsO77mOv3eEkownWcuhfKeW+ivF6SI+QWaX0pyfR1/Vrb7TjPwjq?=
 =?us-ascii?Q?V3z0iZoD50KP/O9XCYl+fsR+Ae129DClnxpB5NgcE2ecxGZCijIwF6nyKjuH?=
 =?us-ascii?Q?/gzXO9DUnnKpYwpQBKBwXqj6x/qiAZ5JpAlAK9+oCYPqmbg5ufi+xvL7qMTW?=
 =?us-ascii?Q?WMfOQ9fqz1RtetnunQbIBEfQAY4xO+JRw/UxjYilS55+2Bjd5jBXWcGMhTsr?=
 =?us-ascii?Q?egcFVLmXgQj01zwI3Ewv6oco1wwTO/qPR3YoNMm/0yeVuEoO2G+ZJgnYXf4/?=
 =?us-ascii?Q?JyucMsxMPMREaajUqvmaB9yP8BC0gjFY6t7ZYj55ud3YS1UFJcc/UA38PTRc?=
 =?us-ascii?Q?lOVe4Clud3Fh5LkwotVt5a77wzXCMf2r3o4qawyCCDzHUy4zW2QcpirTaF1M?=
 =?us-ascii?Q?ZcPabKSlAkIhHeHARVGXtcENRsIEAednGVVtVsS9z/hp17C1AUm1NK3tgQeX?=
 =?us-ascii?Q?jwxkHpNvrn1bmPl8/kEbTwdt6MafVOmRihQgehUMvd2UwyKUTszX5y4OVE1s?=
 =?us-ascii?Q?xHKQDvFxObYWTe2v93QqIqK43WB0SHQKVNthWRhFvSpFNXH5UESr9LCwI1d0?=
 =?us-ascii?Q?Z1DzJ7Pz2JBVT//5fbaWz3WzwQVsDxTHoruaNwWovJrypxTJy7Gz9WG2gR3Z?=
 =?us-ascii?Q?Q2kbk4K1kzsBzqfK6fdXAeY0e2hxzQDE6Es+ssZM9nNkIyV6CbajFe43RlZf?=
 =?us-ascii?Q?lef3hOzqnHdkqh4zlGOhdMzpKDxgBuF+8pi44Q+mBSVjbF0W4qChxzCOYpVI?=
 =?us-ascii?Q?9JPnbgKsANLiPkoEJNx/UgP4hVj8s2OJlZODSfXmf/Bf/ikh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663ebf45-5c72-43e3-f363-08d9ead6676c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 07:41:22.9823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uuno7l0p3p8esurrlSGerXkfelpIUwM1WqoCF1lK+Ijh78nLR/PqcWhtDCnK7jgOKPmzH9aUshTuBet5Uk4Zt0cjxyQMXpgnxCRbeOL2Yew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5344
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10251 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080040
X-Proofpoint-ORIG-GUID: gxEaIsRIat6K3Pd-s4h_PCvdlhh33vu6
X-Proofpoint-GUID: gxEaIsRIat6K3Pd-s4h_PCvdlhh33vu6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The "ret" variable isn't initialized.  We should just return 0.

Fixes: b77e315a9644 ("io_uring: avoid ring quiesce while registering/unregistering eventfd")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aadabb31d6da..74afb96af214 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9393,7 +9393,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 	ev_fd->eventfd_async = eventfd_async;
 
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
-	return ret;
+	return 0;
 }
 
 static void io_eventfd_put(struct rcu_head *rcu)
-- 
2.20.1

