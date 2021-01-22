Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0013430106C
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 23:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbhAVW5W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jan 2021 17:57:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40952 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728438AbhAVWzv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jan 2021 17:55:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMrogh154515;
        Fri, 22 Jan 2021 22:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=duIYV8b4T0NmmXMotSNNKBsNvT7+z9NmzlALYNbqLrQ=;
 b=ZBLvZblvhbWqFSUPFwpxNl2CvvDg9inufg9oYz/V7SMMFRBEW1EHbVX8VXbK6t8H4cqK
 gGgjNcjgh92tfKEvN4ZgkDwFwZwPWrmW410WoQEGS0yRBmVu2ZmbOSwigTsufEAA/k0F
 TPg26pY0u2CgZwbMHK6/jp727uMQf7VSgQr4eKddC8U7lpKGUj4vzOG5ZpHkOi8+Tih4
 h1+bGAzRuSf1bXTDZcGChoxowOPkCv51Tt1YsOWL87QwthD1iv1vnyRZv87G27aobJbS
 UuzUUJsKgWms9ZdrXF9DOBH+d7swDir+AXQYcGbRk5NsPq7TjGCnxzQQwhOcCV7/S//G yQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3668qaphp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMjsII062865;
        Fri, 22 Jan 2021 22:55:05 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2059.outbound.protection.outlook.com [104.47.45.59])
        by userp3030.oracle.com with ESMTP id 3668rhjqpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFAKFU07pIr29jmDx++LzIEE060mBKJYOG5AD0JklnOHC3mmpURO8nestgxY3gzHDpYyCaVjfcT3k3a+LBYTx/HeGmZFIDJTeTcWiDB43q3z2TBb9sxuL9kcPtblRMzbTnMYitmNGag56zJuhAEs432swPABMat3aHu4N4cNwEibemrw4MjFdvSArw7VLedHkGA65X7K+hmrdTWdkNzbMLgS6HsyHLcl4ZAqc9bR+lgbOQnk9/kAO+x1BCVS9VpZQwxIb+EoH+ZfzkrzpsglmXnAX8puYkEhRoaazzOmCZLMd+W/e+HRm4ylR68OIQhV3JrK6eMx7QuHEXJ5cupFxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duIYV8b4T0NmmXMotSNNKBsNvT7+z9NmzlALYNbqLrQ=;
 b=iTyOuH6RzYbY6L5CnV15wRGtnnZVotcOQ9rjWKIIDpfCx8/s+Xvaiy/RjfKaqsy+aPK7oeukpx7Tpi5FsVIV2hhqJ8BHcUA/LPK1HRik1XYeAtOi6sJ0+vH7IWP058a/2qPD3yEoXivUFVAOqrak57BVRshSSGtuwEoAKxmTZPKsfwxh0e8JtgJyTHQFOOzPrXYnEGEP4KQ4d67oNnWCCVPgBQFpqJwrahO04JX09MAO0NRw7KrBiDstpNZXPWL4qVjBIoSRX5gCiI3UTDWips82If5aU1MIgSyXiFK9h7la+zlRiEjBLhtSZv51lULKDFlSkgMUwavxWLyebz5ujg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duIYV8b4T0NmmXMotSNNKBsNvT7+z9NmzlALYNbqLrQ=;
 b=z+FK96QaQc7xRBvKhtIkjyLivagwJU8dtA+QJDCHKwKOL3ffmAOV31HY+ioC/20G89EzbYSCaoHSv8LMYz+rgJnueHV/PHaC+lbByVyjj73ljR2Qewwhu6yWEQWjtNTmUKkyVCEEA/R0fYSjn60SKnoMJhT7lNcGDa7OB/MrPFs=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by BY5PR10MB3827.namprd10.prod.outlook.com (2603:10b6:a03:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 22:55:02 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 22:55:02 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH v2 00/10] liburing: buffer registration enhancements
Date:   Fri, 22 Jan 2021 14:54:49 -0800
Message-Id: <1611356099-60732-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [138.3.200.3]
X-ClientProxiedBy: CH0PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:610:77::22) To BYAPR10MB3606.namprd10.prod.outlook.com
 (2603:10b6:a03:11b::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by CH0PR04CA0047.namprd04.prod.outlook.com (2603:10b6:610:77::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 22:55:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c0431d5-6573-49de-e47c-08d8bf28c08c
X-MS-TrafficTypeDiagnostic: BY5PR10MB3827:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3827BDEDEFE6DBD3567417CEE4A09@BY5PR10MB3827.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: balozwHK1K0CG7uvqKzoIZx9Z+7JrkJjkY9T5JjwE4qLwCIE6HHJCQSjuZOccfKZQznQTAg2ToG4Vj+pqfL+ZoIu6tT0jMoaxm29661pDiC6DE4CiHr9RVRNdVr8AbxjqHReY6a/gBde09IXpTmFtGH3c/xdmvkjh8PDzj7UawqmewlD2BwyRRhrkymx4ML81gHrw22Ouwnb532ZKHiQAH8aggFwBu85sOQ4TfmSugBUG9SzVIg11SFYFDJ6IzlA0TUZ6ZNeV+YamJmd3estp8EXKl2uf3ne5955YA8S+iCqKOQlynvgEG4iVSrHbCwfuBbj2tqmRpLJj1jHakxYNnzreQU9STmmlk5XlFw6ocqWkMDuIjhj3ZZx1iwaIRPl7k7qr3fyGgkEnVWvIMlXIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(44832011)(316002)(52116002)(36756003)(7696005)(2616005)(956004)(6666004)(66556008)(66946007)(66476007)(2906002)(478600001)(26005)(86362001)(5660300002)(8936002)(8676002)(16526019)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?V0C3HH9ZTRVzuXb7PyXnCIj3E7ues1P2WcNHe+bG6wDsRYgqPP/10Ytu+Nt6?=
 =?us-ascii?Q?xstg3v/O4bJUgyrTwpPbKYBjDtIiFs/Tzk2l8MYZIi6bWd1ZN2VFRsN2r1FQ?=
 =?us-ascii?Q?RSvymdBRnWqYQlHdG7DpLHvYHP8+2cWkSn1a3Jh+XyzHC1WPkyR3oxmaGYFz?=
 =?us-ascii?Q?yQ26xCViF5yjHdHDDaz2jvKRKEWIkSB308sz8CUqMks7ZH3qPWgpY3Ya/hwH?=
 =?us-ascii?Q?YzLzadXed2UZS+AieVtcCJOpYLRTpppyxx4P3KZ/fGQSojT0dsGR/duH34Wl?=
 =?us-ascii?Q?d77JCIX7Udf32vraInXwJyRw4aZdaEzdmdahaPvCWCT1QW3B5vubm2TGjzsn?=
 =?us-ascii?Q?MCwOYqSsFtpWyEExY1wZPKDvu2xJzeZw5iUilmGf0xJosgA77jgzT/Tc4Xco?=
 =?us-ascii?Q?mdlyWuC7d65LOl3hQFpJaLOOkpZvjzC8epUqV0hdduM4arrUJIhNSLbQADI/?=
 =?us-ascii?Q?QC+G1fuxa2/QSOUH5/DqbKc410i/q3UUyf3TksQPLHoTPZkf17RPddCtonGQ?=
 =?us-ascii?Q?X2COj4L9ZgnOhD6fhm2bkUCyZ06TTrDchJWVcz8JiLs1nALBQljH3M8oNPhb?=
 =?us-ascii?Q?hRgo2uzzy8shuSO37KrBWQ6LGgvu/m4Zhs6sMessIzjl9+qBlOS/W1bsGDHf?=
 =?us-ascii?Q?l4UxF/J1UffPHzhM7l/zlNukck8HfYfz/12Crp6Zf6DUmqzBNt6+C+oyImPj?=
 =?us-ascii?Q?/hhnc+MZNWQ5UvkchLZydftuSK6rTEf8p5sSafWud5C+HtAxi2TvMw7OnTne?=
 =?us-ascii?Q?3KDFo0whLiuMuS/s2ouJLlOaICzl8T4rn+q2bz78gk+Ai/iru7ECEgJAX0sk?=
 =?us-ascii?Q?ijuX9U7xnOoMBqOiRekHH4Ef5XZmIKxmMDJWu2U3zKluhJlg5Cmlkqt7Dr7c?=
 =?us-ascii?Q?T596IpSZjXNnW4yZih5YooGNqI8rXN/fg1mE2hL+iqPSCINt8F9IJ8GpxLAw?=
 =?us-ascii?Q?p3XAxxRrK7veCQziCIRSSHfVjNS6Qhkvs/eDa/d4t2Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c0431d5-6573-49de-e47c-08d8bf28c08c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 22:55:02.5249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DOy2hpQg1O4iJVSMBFfwZ6HhBxRVS797LIUjhhyQrAblSR9UznKPkROZ0iQlljShrSBo3NOuA2UfhllByhAK78kPQrhw6Pz7SEQ/esDkjW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3827
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220117
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220118
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v2:

- manpage updates
- additional sharing test cases

This patchset is the liburing changes for buffer registration enhancements.

Patch 1-2 implement the actual liburing changes

Patch 3-4 are the buffer-registration/update tests, copied from
          corresponding file tests and adapted for buffers

Patch 5-7 are the buffer-sharing tests.

Patch 8-10 are the man page changes.

Bijan Mottahedeh (10):
  liburing: support buffer registration updates
  liburing: support buffer registration sharing
  test/buffer-register: add buffer registration test
  test/buffer-update: add buffer registration update test
  test/buffer-share: add buffer registration sharing test
  test/buffer-share: add private memory option
  test/buffer-share: add interruptible deadlock test
  man/io_uring_setup.2: document buffer registration sharing
  man/io_uring_register.2: document buffer registration updates
  man/io_uring_enter.2: document IORING_OP_BUFFERS_UPDATE

 .gitignore                      |    3 +
 man/io_uring_enter.2            |   16 +
 man/io_uring_register.2         |   29 +-
 man/io_uring_setup.2            |   12 +
 src/include/liburing.h          |   12 +
 src/include/liburing/io_uring.h |   11 +
 src/register.c                  |   29 +-
 test/Makefile                   |    7 +
 test/buffer-register.c          |  701 +++++++++++++++++++++
 test/buffer-share.c             | 1282 +++++++++++++++++++++++++++++++++++++++
 test/buffer-update.c            |  165 +++++
 11 files changed, 2260 insertions(+), 7 deletions(-)
 create mode 100644 test/buffer-register.c
 create mode 100644 test/buffer-share.c
 create mode 100644 test/buffer-update.c

-- 
1.8.3.1

