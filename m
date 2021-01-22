Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23833301066
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 23:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbhAVW45 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jan 2021 17:56:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41076 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729061AbhAVW4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jan 2021 17:56:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMre8P154344;
        Fri, 22 Jan 2021 22:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=GSemzUfGuMpC3VVD97pLR7aLV+qjjo2J4lAMkayU7gA=;
 b=PdqLh/kDPclzGD1eK5a5+rLBt9mTi4OwVQFxFh0ROb0mFGrC78gcj8bti4i+pU47s+Ve
 C7mGCPmIoNty4AsDuKoxxD3bpcUhDOwhYX1jNsFT6yB2T+M0HgaUpMoXozd9vfltDUcf
 s30eT1BHX8yqvbb1nt/C1J7gilUTKKmapIBV7j1TgBBw+m4jsN/6iVb1YxwjPxdm8FdL
 2ZDq1mZA/w6DD4gpoSi1RmmsVKN2JSko5Nx4UF84p1O78RrgwFBvLu0DKfS36MLCKNte
 8Atr+pIN7Mw6NbXHTFAQgkQ6x07UX/kMsQvlBjeBQ0c1Ka4FrcFX/1pxY12H8OA0caJA ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3668qaphps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MMt0on162479;
        Fri, 22 Jan 2021 22:55:14 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3020.oracle.com with ESMTP id 3668r1pqms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 22:55:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CegBly7CEnNLezmdQzuk1wPdd6rUQRbEHRFfZVuu77yAhmDPdmwN9W2pK5TWYkruf6s+NlYw/NHbciNISRD49Q3Toz4iQkX6vciIW674Eiq3Ta1RNKUIeKwfbRCh+ZCfTWSRAmam5mwWwKaAyllcQskkgxI/Isn89j6QtLEy1ToE16yswSWmBDPPC1e84Lkx7M9tVsQKB/c3HKorh8+WjplZkyyvkIm7tocu50uJECfWnak38NkIHOom37QA15dwT1MA7uUdkSKGgaEAXhxufCBXYRUcGKTfHmqmJ/KEaoNTH+wteiwtzhpB+OCjuddpEO+HSUba0OosAGz0lyFDfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GSemzUfGuMpC3VVD97pLR7aLV+qjjo2J4lAMkayU7gA=;
 b=O7f1q5GGnyTTl0JvhsvthByd4ACWqnxBKVdXt52rtMC282CMT1fV/PsxJQ+hTMQYQ0vDWF6pMna5IHlDrYzZK7lZAXBHJhvdr8m5iw2LRHaJ9VuzRjIZuEjgB2E9NVAsyF++avR2OjJhu1hRcktIKJT0JPLPP1TwSypGVNCptRUJT9xeV9kak/GCEBbxba8xA+tKMd3fxvonEzYZzeZbGp2J7yXSXwOf+eMRK7aiMDL6C6Ezd0NJMRUT/d8LE7jHa6CnOsPvk1A35wnu80Ffv42IaXUp18GaWli4iVyHNBWc0dOvwoJ+uqyeL21TZa7V2uj/s9wo1epxdWVzj3MiDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GSemzUfGuMpC3VVD97pLR7aLV+qjjo2J4lAMkayU7gA=;
 b=C9U70j+3jAkMXLGzDrbeLYNHe439nHUM3p63BGzgcSq3op3mi4ju56BP+ZbZyC9OqZJS0MeD1XfVS59jYDQGI4XTE2xnRXarhyrfJTaKtWdV6IluwjTzUbILvK2EAebfhMeNOQ2+wycXREAbvHRuOSW6qbaBWe4b6QXxL/mg7GU=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by BY5PR10MB3827.namprd10.prod.outlook.com (2603:10b6:a03:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 22:55:12 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 22:55:12 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH v2 10/10] man/io_uring_enter.2: document IORING_OP_BUFFERS_UPDATE
Date:   Fri, 22 Jan 2021 14:54:59 -0800
Message-Id: <1611356099-60732-11-git-send-email-bijan.mottahedeh@oracle.com>
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
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by CH0PR04CA0047.namprd04.prod.outlook.com (2603:10b6:610:77::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 22:55:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27909918-baa3-4fef-085e-08d8bf28c623
X-MS-TrafficTypeDiagnostic: BY5PR10MB3827:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3827BD41088C171DB75F9DA7E4A09@BY5PR10MB3827.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wzGROEwx6jcIY3n52bvTm4MEq1SUvfdwmBKaQJU9XrhUU7UqMgrwdJKpkSLVNrQQ2+Of5B3iIMFZj7OShTU/QweyEMf4lGgblGyyXp4OcPjUngrfiichJmAdqXis7bHi4wDAbVrbJnMPoB2wNUWuUDLNwYuZYE8OP8Z+jR2kzGJbhd5LqkwmXZn1Z59163qstHLiJQxffgAD73weBoItVXoDL7a/jTt6iIv1qeut/Iho3WOHG6J7ev/Pofvw+kHEwy2s1MmCOmCcDiN1dQ8QgqAuCEctsMtknMDBrtiKjJO9NRQuZOW+RLOM89aj0Y436eAWbKku+7ykeCoR5gq7Xy7kykqogrYjW1WkEfDrzSJTvwDDkdiaTaI/caKuIsjtdWVxcBIWvmncjyz4JDXQiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(44832011)(316002)(52116002)(36756003)(7696005)(2616005)(956004)(6666004)(66556008)(66946007)(66476007)(2906002)(478600001)(26005)(86362001)(5660300002)(8936002)(8676002)(16526019)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/pi1qMIYzEv88NGNuSkykcNmyUO8z/4qB5qLHjooe73vw9i0adhrfWizBEso?=
 =?us-ascii?Q?phk4vyPgbqpf9fbj9M4YdEFND5JSRNiOOkY59luLc2Xjnyncq0JlP3xbSEiO?=
 =?us-ascii?Q?Ax3tSwnU6CEtTTr7YCChQBcOgeGeurxhzuafREIw++1NEVBZvY78gz1EnPuh?=
 =?us-ascii?Q?7+XND8i11+J6Y7T4T8NswW4AHb5rmWohZS73TCJr6b+UFRkHe7zdHTC9YFzY?=
 =?us-ascii?Q?cPQP64hh0pR9Cspq3aCwo+bjf+STNgNJDMYMHltZTue2bFztPZG/V5GmSbKF?=
 =?us-ascii?Q?2s7QeK9PJtiAgk9QIDs2Ri7K1IJw+w0EgygUNLjk6tiSAUI45pjd19M3/Ehp?=
 =?us-ascii?Q?OlAud1SHrNf1qMM3YKPew+BCSo7pmUKyv2dPAb7Y4DjkLw1KGleu4GqT2Yh0?=
 =?us-ascii?Q?tr/iDTLl3pC098NNioVjJJYiNLIjm2KqXnjRA8vnyq7IFwkfHDnq1X58YMpU?=
 =?us-ascii?Q?o5iSvF9wlxhiO+zsTgKD+y1UwNm12iVNzQhE+Vvhn+Yipf1YmcoXtLoSb9A1?=
 =?us-ascii?Q?jX2gT/A04jLzEP/agBaAxZbgDPwfXV626ODXeORLMr0Qf0ZM8DTztYn1rZq5?=
 =?us-ascii?Q?ehtbmSVuyKON/9rOPu2ywKg+Xpo0wyclPPiJWdA0XFqCRb0MSVhzllyxqpz7?=
 =?us-ascii?Q?aIUlYwk8bT4aQqzaQG5ZKEhXYjUoqd7Q+pCZQhaIn6LJR5s4PxNGhwVvb0Y/?=
 =?us-ascii?Q?uyDfhWymgrmyDG+Zmkn8rJ3bv6FOhVgIXRCmQqP3GSthhcrqqPnxrbpJyMjF?=
 =?us-ascii?Q?2isMPkKSHmfE4SkDjXrQb8+8NSLNZMgKfNciyiTVCYdX2+AHE6nWZbSGlPMd?=
 =?us-ascii?Q?XmzgLE3JJDT9w1EjXGh/GupBeCQkFTlYzbwLj3V7hrysnAEVMadgz/DUmERx?=
 =?us-ascii?Q?kslMvqWM1+Z8KyK+JOJVeA+iKLnc1KwWFl9cjX2F28yBinKF1k2GkCtj7o//?=
 =?us-ascii?Q?3m5h/8V0IjcburEI2GcjTM8fIAOeYF34eDiteoNq/A0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27909918-baa3-4fef-085e-08d8bf28c623
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 22:55:11.8935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wf2MFyKP6qCIX9zoht5UR/HtUk7XmMtwnERWVwcgoKg1OpfE1fA7v//2G3GskY7g1mkJQL3ffgGSQ6OXQmWF+hsIopTwurKQ0WAl2YuTfG4=
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
 man/io_uring_enter.2 | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index da20451..99f6756 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -636,6 +636,22 @@ See also
 for the general description of the related system call. Available since 5.8.
 
 .TP
+.B IORING_OP_BUFFERS_UPDATE
+This command is an alternative to using
+.B IORING_REGISTER_BUFFERS_UPDATE
+which then works in an async fashion, like the rest of the io_uring commands.
+The arguments passed in are the same.
+.I addr
+must contain a pointer to the array of iovecs,
+.I len
+must contain the length of the array, and
+.I off
+must contain the offset at which to operate. Note that the array of iovecs
+pointed to in
+.I addr
+must remain valid until this operation has completed. Available since 5.12.
+
+.TP
 .B IORING_OP_FILES_UPDATE
 This command is an alternative to using
 .B IORING_REGISTER_FILES_UPDATE
-- 
1.8.3.1

