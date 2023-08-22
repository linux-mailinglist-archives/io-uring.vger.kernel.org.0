Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93975784D47
	for <lists+io-uring@lfdr.de>; Wed, 23 Aug 2023 01:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbjHVXSV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Aug 2023 19:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjHVXSU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Aug 2023 19:18:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A02A10D
        for <io-uring@vger.kernel.org>; Tue, 22 Aug 2023 16:18:08 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37MMECOY029856;
        Tue, 22 Aug 2023 23:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=CJqkfpK3OP4PcGhbo5MgJP/GLy5ZZNQcre4zWBlHb/w=;
 b=AN1hkEtTB7w/RpbUG4Nj88WqP2/R1x3Ag1nmUO6EW/S+WKsLIVJ0WjOaVmjbKJkHJI0R
 TtGsqBnZ11jZqXX/q1icWjDcBljJ6jiDNIi2nmhMsFN5aOTwy1dt4bNWBEtoSzaA5/Fq
 7dekUK99n+nHIZuoTraYeAO/tbUPA9xvblNblamJf3/TGxoQnB8r0aRoxm9aHomv9lpG
 cGYAolYYqlJJoMT3XL+JNapmPdyQZyJ/Fu2Ku5Bz86nAtQdPAxxQZcE3posfmqmAShBj
 c3k7nbKzJ+/pG0FNoa46vMc4sGJBdBF278SZtGUjI9sBrKIRvEIvWIX+2XZYhkRgsoyB tQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1yvrkqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 23:17:49 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37MM1UX9000942;
        Tue, 22 Aug 2023 23:17:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1yrahhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 23:17:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFpC82Ega4aktNVKGeOkYlBPAvLn0gQPYaWF9TvJJxHmrIX6cqUYHw6GDmiaKJDaB/sHqGhHaRXwo4wi0hmPNFTgD7BkuIBSsAxmwzvoa0EjDb+0TJMroIVx89dAMgQe7DqDPfONtYGRFnvLkRGYI97+zkfk3LtIBkybWYbg6+9OEDc2TT/R/1LUjYjtjCFbnuUAax6slMp8xxykHLfS8INGXUsHXk5jMjtMZca8XXYSi+fyYdqEQ/fzoYvYFEtn0hsx1Nbd4nOTYRsHlzYf18eojDG/w8ou0xwmU84U2jwb3Z3VHCCHQexR+4hp4L1f9d5UeCLkS4PCE6ujA+ZVOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CJqkfpK3OP4PcGhbo5MgJP/GLy5ZZNQcre4zWBlHb/w=;
 b=kZ1uf51VdvduGuYQCpENuYngMzFhIaXq1J1VW6QCAmNgwGrCefZHuWIK43Tm3Fqi+xXw0MyFrt4JQo/t+4mgSvZfIlgY+rJ0h/4qX/66HtekEumkp+COEb/Zh3U+slNBWrQw/eJXDuw7nFHGVS0j+uTRP0AwmcMgbuioteST1hLxzVMMCrU53Q5XuzGffXQZjp+YHLW3MbHnaG9OVKS7gpWs0LwpLxY8Ac++Bm01GgUU3CHoFRQ+4Rc7ZWO4JdM6cGXAj5kCxU/hYL3S3IUgiY4tmYdS4Ik0Ds//0W4uxJw/dV9UsDgUeX4XISxhwwGRm15lP2A7nTZ2+Y7KJgh+rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJqkfpK3OP4PcGhbo5MgJP/GLy5ZZNQcre4zWBlHb/w=;
 b=R3LBTIotlvb0yqkxMo1BeZMkO1oMeJtj5gZ2FKZjmdlwgpQnZAsA5OE6CkQBcU+5lcJ5GGv+KCtPkZi/t/qabGJ/hFbZUoGwViTxM6Z0jPz5vtu/iPtnDZ5X7d1O6dmonmT6I02UfCvTKpPTcMUdRXfCER9QAUjsZmX+fznLSn8=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by DS7PR10MB4832.namprd10.prod.outlook.com (2603:10b6:5:3a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 23:17:46 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::92ea:33e7:fb66:c937]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::92ea:33e7:fb66:c937%7]) with mapi id 15.20.6699.025; Tue, 22 Aug 2023
 23:17:46 +0000
Date:   Tue, 22 Aug 2023 16:17:41 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 10/13] mm: Free up a word in the first tail page
Message-ID: <20230822231741.GC4509@monkey>
References: <20230816151201.3655946-1-willy@infradead.org>
 <20230816151201.3655946-11-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230816151201.3655946-11-willy@infradead.org>
X-ClientProxiedBy: MW4PR04CA0356.namprd04.prod.outlook.com
 (2603:10b6:303:8a::31) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|DS7PR10MB4832:EE_
X-MS-Office365-Filtering-Correlation-Id: 02ab482e-43f9-4284-c14e-08dba365fdbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qy3CE59vTHQNiKzup717xTOIcUMQvns2LqGl1GHb3rQj1M6NENsZhnrCmjWmKN455LH5UJhMO7o/Dm43Of2nEA9H5EdBjfK6X6OnWqLHn09O3YXAR/KhvXBRlKD5xcrZSJbH/now96C1qZm8Gkgr5Z040f6zxHIMGVV6aATKgFnLDGNJ+UlyffOBgSQST6JPsdVi3ofDHaV2zcdDxrd6TLqrkL+RBJg5m3j8GHzD0YbF1zJwvMUDsyX1cbtliTzeIb5pQpIHK/GEfnaQFpSpkaCjNEdCoO0/S8Ug7Ny9+gzjtM50yG68YUG71swXSIpxGuL5A9/nCmDcsXD4ahiaQ1bSLdjGI1cleEOtjD7Y8VUWGbzux2gi21VaASZwcVP5A1K/w5XqOKTZABsRV14VDG1/po3BRJlzi0uMrHFbcbbtDfW2QzEbCnBLyqQO+0Zr47NFcUCpzpJTA4I07izi3XsEtX1P9TtWBwCofUP64ONkAU8M+Flil4luQ6TxoQTBy2kM3xaJFbr66Js4TbszNP95ZYkeLFfnHqeixY6VHWosiMFWO731q+t+9KyvjK5w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(346002)(39860400002)(376002)(136003)(396003)(451199024)(186009)(1800799009)(2906002)(38100700002)(6506007)(53546011)(6486002)(83380400001)(5660300002)(44832011)(26005)(33656002)(86362001)(8676002)(8936002)(4326008)(316002)(66946007)(9686003)(6512007)(6916009)(54906003)(66556008)(66476007)(478600001)(6666004)(1076003)(41300700001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vDadAb02AhBaT7XKgTo5JzznTba87oc62DYbJFa4FIYM1PLJfGSRpANQp7RN?=
 =?us-ascii?Q?Sw5GKFntT5ZiYRCC/c5j3wku1Y/umekAqTqxbiXli2sZF+hm/OQJRScgcj3K?=
 =?us-ascii?Q?Y0Kx81qpW3NOYRP0ZcGUJSG/lvesFHSb1w/as9pLEdmnY1vOTm0XhWUphdWG?=
 =?us-ascii?Q?UzUDJBLrCkcHXBHglDyxXoHIyoNJ9dMswr4fWxtJEdYCWzIfp+JlWjJEKd+M?=
 =?us-ascii?Q?D+2VCR2+6JLHM1MoggyI0S2YyRyqI86coYPgGfAr87ZE6cNgwwFrXcbWdUG+?=
 =?us-ascii?Q?e7pD72Li3l8LHwHu5tmNVC4XZDEpZgrn5vAGLcgk/QWU/zgdUrtmSdqYDmfq?=
 =?us-ascii?Q?dagYUR5HYVH9BO7r3nCx4G8Qa8s+uELMLhzNHxxzJ6p4GumLSbbWRYfVIqcy?=
 =?us-ascii?Q?6uq9GkIapkDdteUO7k0Zkwbnfm3rtncRPrb3FxQSqcYvods8RUvz3POBxGoD?=
 =?us-ascii?Q?7ao7Gw+FrzGd2CS/C2ML2D6nIxFecRD/YLaA7CtXYlAyqwAQVEYQQpJnzkQQ?=
 =?us-ascii?Q?nuwQurTyRv+Yfm/tpZFvMo8hwdh3sPq2HWjU3gXgF+SRAW6NW5iyMxFf7pYJ?=
 =?us-ascii?Q?5Z/My4d0sPa9lIlmRoXo+teZ/bQM+SSTOvW3FBFbiJeL1UgJrEpIyNxbuEmG?=
 =?us-ascii?Q?Cv8GBgi3Gt8IdyDCQ/7iVevLJN0aueyZyDuh0kTWVG0lirMQKxPrXS4zKslT?=
 =?us-ascii?Q?/1a7FVU1GMta/bfRC48U+nkCa6UvC4Zh0lnNRCYMjYkdENrefWey1mGPU1pp?=
 =?us-ascii?Q?wnS/isvVuLIaiKLZ+YerB9JCj4XizzvshrY+Jy7VrmNIfsiV8e80XxUHVylF?=
 =?us-ascii?Q?2RWvQZFTjV7WR+kSu94vEcKXy1AsKOU/rHQvn+lwDo0j2rrUaJGke+jTKVAL?=
 =?us-ascii?Q?z2PAGFXJqsYtzKu6PISI/w3tG4ngJJZmInRu2Wyc1HRG54XTgK23DiWF2Xtv?=
 =?us-ascii?Q?c91bFBa6AgCG/VVlctdwXupGoZIZE+VPLe5/M1eeI+dV1Jk4SDmd0DH5a28z?=
 =?us-ascii?Q?azto6UobR1qDAb4/aiRa3hf/VbCyRBgvKqmQ8Lk5z5W9WINy/CxxX/tQw623?=
 =?us-ascii?Q?RJZP5Z/6o13CfLrIroefpNMIT3uDAWn2IQUyUjPMUdn7Z8xwW9vrAtia3MEt?=
 =?us-ascii?Q?6qte1s4PTqB3zCsiqapPNI4FEJZSAukZQJlVOXA+OXZKgnrxxYd17LcwEdhm?=
 =?us-ascii?Q?ahn/EtVWTiaGTUVI05e791Jjdma9xXKsqtPZpIByv4Nrc4+50vNbVzB5A6hL?=
 =?us-ascii?Q?1V71SvGk3Hy1OyZv7qa8OHmbMxAgE1r9N6jfbxvEecbFYkdRDCjF2uIYq9xU?=
 =?us-ascii?Q?iGBR6HCxXTzpKJgy3H2qvNNzDvZuaZXawI7bJPqt/xj0Uin47dt9Uk60Xt5v?=
 =?us-ascii?Q?lNvqrVZTr4ckpeJlLXpxPsutY30H3eikWTsnJJ9tzwz86dNRCJLZJDq3qbZu?=
 =?us-ascii?Q?JcftS5ybQcZecak0e31x6JS5yxaK1XIdQAP0wGySSsphysS011LdlN5pDHFN?=
 =?us-ascii?Q?0nAlEVy8gnAVtjH34gkohJm3Rm5gM9TroDhAWvFdBQB6y9FgECnHv4NQwg8t?=
 =?us-ascii?Q?bwc58riBE881uXkQ3j0KHE+IdNfPYPREnLd2vLBe?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rOVRTLSaLmYKbtmTqS+Fx95pERL//ZCb+607F0h7skn0gT9IIqpX0Z9ANSA+dKtnEFRz8ayg0IQuzK7TVFCniaotj6oHxBYQkcTKAWqlKo2bMCU9bB3UFFdD6DHvV52u4WHIyajuYiTXhLXbx5q5nmry/+kSbyrXD1Y/FTcUJoznldFRw74Nejjj0BcID7EXskN2Ou3iLzqZ26a4W0FZ1SkQBWSc5YZnIsKN3eAqkRBzy4pEUXA1VrAtRjlpo3Cd2o5Cl9B4As1wq4k94indsJuBjKdp4oH/FnCEoTXyi31BUEWYNYFcYo7gg/LVNtmsHkXeeRuclXq7+kXKAzHwcybQM/fwdN/Vw4aiu1J5ooZohfhfa5lF+zUwf1QyaFcB9zykUUMqe+YfQB+AyvDq6pTtUXdik/b/bkBbMNQ2sNYSVyjjNz1aenRXRj/3PoY1JiEEif5WmFl65SXr0pJZPx3lhA2Z7pzC1/vHn53T0DITE5QMJzsZhlftsHdM3+Mjf2UHQP61BrVJjqwcayG4mRRMJRHstq30YUvxKgb5bJ6ZEDmNLqhtmVDRn4PuFdmuKhgiuON3tTmpM7P9bvh/9QWrWqySk/Mkm3O6l5/s3deg0tRk/0gcENMqS7JG8GkvsAFSTo99MnPrpnboQDPrAyqGBKEjs+1R1+o94f00ShJxtJIz3DpKwa89J7jREpJ4MI6toHkv9kZioSSo7TugsO6RJPOUw/YXX6DwdIMVXTk1cvJ2y+DNWkMsh/elZ5hc8odOJ7XUtxG6FSS2yk77PbXhe7bqmmIBISDcslGhRX3Cd6JleyIu4lxRjS9WmRSv0E22L8P4g/yNW3YoB0/3QiMpyrETrQb5PnBRG4CVtazo087vvjjJTlY3+5dG2D10ifMdkg5vHQcuhJbvCSaIyuduRQC6+Nu6LMYauXvTCcQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ab482e-43f9-4284-c14e-08dba365fdbd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2023 23:17:46.0023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wVF15cqgBodF/uaKaP5Q8uGBywOupzz+EkVzgxWnMGBjtwQVKW4dJFopZj072rXppYA6DLS2QnJoPrl5C7DBFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-22_20,2023-08-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308220191
X-Proofpoint-ORIG-GUID: 9DbE2ulqQ1N_1bmG4feO5IyFooEYnwkw
X-Proofpoint-GUID: 9DbE2ulqQ1N_1bmG4feO5IyFooEYnwkw
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/16/23 16:11, Matthew Wilcox (Oracle) wrote:
> Store the folio order in the low byte of the flags word in the first
> tail page.  This frees up the word that was being used to store the
> order and dtor bytes previously.

hugetlb manually creates and destroys compound pages.  As such it makes
assumptions about struct page layout.  This breaks hugetlb.  The following
will allow fix the breakage.

The hugetlb code is quite fragile when changes like this are made.  I am
open to suggestions on how we can make this more robust.  Perhaps start
with a simple set of APIs to create_folio from a set of contiguous pages
and destroy a folio?
-- 
Mike Kravetz

From 8d8aa4486a4119f6d694b423b2f68161b4e7432c Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Tue, 22 Aug 2023 15:30:43 -0700
Subject: [PATCH] hugetlb: clear flags in tail pages that will be freed
 individually

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/hugetlb.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a82c3104337e..cbc25826c9b0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1484,6 +1484,7 @@ static void __destroy_compound_gigantic_folio(struct folio *folio,
 
 	for (i = 1; i < nr_pages; i++) {
 		p = folio_page(folio, i);
+		p->flags &= ~PAGE_FLAGS_CHECK_AT_FREE;
 		p->mapping = NULL;
 		clear_compound_head(p);
 		if (!demote)
@@ -1702,8 +1703,6 @@ static void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 static void __update_and_free_hugetlb_folio(struct hstate *h,
 						struct folio *folio)
 {
-	int i;
-	struct page *subpage;
 	bool clear_dtor = folio_test_hugetlb_vmemmap_optimized(folio);
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
@@ -1745,14 +1744,6 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
-	for (i = 0; i < pages_per_huge_page(h); i++) {
-		subpage = folio_page(folio, i);
-		subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
-				1 << PG_referenced | 1 << PG_dirty |
-				1 << PG_active | 1 << PG_private |
-				1 << PG_writeback);
-	}
-
 	/*
 	 * Non-gigantic pages demoted from CMA allocated gigantic pages
 	 * need to be given back to CMA in free_gigantic_folio.
-- 
2.41.0

