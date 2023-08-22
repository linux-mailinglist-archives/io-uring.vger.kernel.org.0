Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C265783856
	for <lists+io-uring@lfdr.de>; Tue, 22 Aug 2023 05:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbjHVDNV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Aug 2023 23:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbjHVDNU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Aug 2023 23:13:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6411187
        for <io-uring@vger.kernel.org>; Mon, 21 Aug 2023 20:13:17 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37M1EdIL014071;
        Tue, 22 Aug 2023 03:13:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=4HKga445KUlNyfuPHA/UNOBz61n2XdIBM6tmOG1rg3U=;
 b=hiEBqE44nuRwpOGNCRF0kGFEdbhki5+gw/dmKGEGCG1GaILXYFN3RS8SZYtCLgOFMvH8
 C2WoD8DdDlxRT1bQVB0tAm7ezvie2WwDvOtIeLYOMlP+DUplQBjiy6gAYkv20n3nTgPc
 4z2gE6dt9utOTnWxRZt4004WdGuUsmd2eShP9OWxX1SXnmSeaEow1rd+2G2GlXCXq5XE
 XcOr7imCCBcso7YHYb8GJuHVjFa4NhNrtmnguBXM1KdoyKgxSdnWt75qJmT/l7K0hJQQ
 GQnI0WJ9Ubx9675APHVd9jh7QWlqBaW2OKT0pZ+zZpoG3lA22N4+EcO6bcIfPlzpFYYc Tw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjnbtv9b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 03:13:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37M1Zka8029830;
        Tue, 22 Aug 2023 03:13:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm6ary9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 03:13:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nKyv83v6lALIeYwFC2za2K69jO+ofCbvBLUCx5pjMTyi1E6gkFzV3P2MzNCpqPQfjLPNkZ8r2vprnHT6Cjcp16IbpGCumFwNNd4700LHvO2IKjKtJddEJar8Vmt3pUYyBsXVVUBTitnGw0ZQ/DvlnzvoUHG5ETjI+/2pCeonV6aY7IYJY5X5Wfwx/HYVHlzJTxoTI82s9WBHaoSbAVUMtNRahYOyfzl6B856CfRSNC/pOGEve6ZaeOOOUM5UM6jr7ERoYfozb3K8qvltPRL0+Wx/14y0j/1SMApau1tVPaM27lVIMysP0QgLZl23hzJuEfly9/cjn8c/cbkIWHvU/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4HKga445KUlNyfuPHA/UNOBz61n2XdIBM6tmOG1rg3U=;
 b=CQx4YZTmO9p4W24Fl8nG5YamPMGp7/6wnvuByqXbqs9sNdTU7nLoi+gtDigmZ1vewulE+xV6Gw3vPQREMZ5REGMihr6JOJbqm5kjF2NBFT0wrZD+DJFe+WCisdUlI4j3hXA66hnPDuW2BB6jCo6Gnch0ybsSUXqnMakc763Uejhy9s6VPCjp+F7HmjthtNlCuJ+futB6BKTMB4stZvJbfBQyzbSEf4wr17lzFYvh6pilO3RV6HWojUVeN9pEb3WG1xWW8AxBFNjol3/qBm8+hIngi3cTTkvX5TxQmsQ9sCizQ8lcVJC9nRdzCQgNDgVIndRL3IlFVoZxbVmkMj/hCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HKga445KUlNyfuPHA/UNOBz61n2XdIBM6tmOG1rg3U=;
 b=NvUAZxx+SGIuw5Lzv/DcLBykZBLyOkD1sfN/CXA0pMIM0n1oiPRbdV4EMoyS+yLS/AzNkhTWCuLGBy76yyY97ZHhg01lTEc3ZULO+Ybbfng7GtjvxJkQAKQBo3tub6XVAtIoDzrPmoXfv7sfZsCXsb24zpkdiDYeu9JJx3RTEUU=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BLAPR10MB5028.namprd10.prod.outlook.com (2603:10b6:208:307::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.25; Tue, 22 Aug
 2023 03:13:03 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::92ea:33e7:fb66:c937]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::92ea:33e7:fb66:c937%7]) with mapi id 15.20.6699.022; Tue, 22 Aug 2023
 03:13:03 +0000
Date:   Mon, 21 Aug 2023 20:13:00 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 07/13] mm: Remove HUGETLB_PAGE_DTOR
Message-ID: <20230822031300.GA82632@monkey>
References: <20230816151201.3655946-1-willy@infradead.org>
 <20230816151201.3655946-8-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230816151201.3655946-8-willy@infradead.org>
X-ClientProxiedBy: MW2PR2101CA0022.namprd21.prod.outlook.com
 (2603:10b6:302:1::35) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|BLAPR10MB5028:EE_
X-MS-Office365-Filtering-Correlation-Id: 060d1bd2-5c01-401c-38c3-08dba2bdb279
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/u3Zu4mExdUoC/aq4+lqnir5Qub84LQHBTq8XsYryi1fUWHSQrkP4g58KE0zD2E//7pAjO4BWLyRByv8nFf2QMFXeYfEJuGSRa6A4CbCQM0Hr47zQjBqHn2DjhB1KGH1awpJ2H7uawJNz/LwZpFYaXyj8redvLuLzBVp2dzlz6Ag8qjc4DzHLeYhbqS0TXNTe5LvMT3gnUFoN3RcWub7jruAS0vod5Y3cHPK3/nuM6MDr+BoMH6BsE2GM6WDvFG4IE41QO3ZpURGymQZmtLJ4DZHG/ADLefSwLwqykbZYUV5UM9qkU6TQZ7t5XyYyCBrXTql4Bi/3+MAoONr/Rogf+zusAo4X5cPckc5iV9jn+GCCw9OecRyKT3RBvOrip44b1lKlgW7Wu4lvvOPYsRuWCsQms/jesehoJztdgPyVus2quYQPAEtPmnRUusu1CYkdoghKTXPSj9RJUZpUvyP7xcUZHyu3rEtzU+hC5A99rgSWFbSp0/plKcGF3jgVZQ5Pjtlkbc4wUH2MNAfLtgmt3b10q759hMf6+EIVZzDanVCbi0FppvaIyWOWTOV8RW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199024)(1800799009)(186009)(2906002)(83380400001)(45080400002)(53546011)(6486002)(38100700002)(6506007)(5660300002)(44832011)(33656002)(26005)(86362001)(8676002)(8936002)(4326008)(66946007)(316002)(6916009)(9686003)(6512007)(66556008)(54906003)(66476007)(478600001)(41300700001)(33716001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RXOmyDdMR3nSXHQ+ha0mmiQAZVxikK21+8u27SIqbNliZ2qz1haLBgThtqG0?=
 =?us-ascii?Q?4KO/sOlef/EI3ozRX8MOj+tzp0rVvbYnHaOB/Mc/zk7p6DQb6a7MBKwKA9Bk?=
 =?us-ascii?Q?HOJU06zzCbdto03jGfWugLIUJXgsRaOAcauQWlMFhbIbHm+PfhbNDhAMuIbk?=
 =?us-ascii?Q?M6QSkrgAmu9cwPYJsf+fyHbNN0HfrqOtPuVG9Lceb/eR3A5Mlqgi+SdQVSLa?=
 =?us-ascii?Q?S4Uj0MW2/th/DvOshXio8MDhlADFc0+hSQBITgEXU00b71PePvisPfDl0lj9?=
 =?us-ascii?Q?jp7S7Qs4SKz3TWLVGVFkbh9uaIcaLFm90BD4y5OZ8g67gM3oSegkscsbZe9S?=
 =?us-ascii?Q?Pj386suZT9ft4cRQ51Hs5A/WZNseVWNVy/LQTMCpzEHPSD4N+UtpPMOjYDfo?=
 =?us-ascii?Q?LgJf5JT7L8/mGNbGWZqRFvzxNGlSnrbg9s0FaxkTMQvId6z/bg13G3DjF5FV?=
 =?us-ascii?Q?Shwutk9QSCJ8pXUvrm+HXDsIHwKEpioeYGWsuUPZlVLx/5ts5tsvfU2OtI4q?=
 =?us-ascii?Q?zksH3BMOEnZ7MNPFcxG7WSGHNyq97ce5d/Ua/KQ8tM23xfMJj7BgOMgzrG3j?=
 =?us-ascii?Q?2pyRv+xKrv1Zo7wkrDx5ZQLPz7tzWoxwoxKKYZQBOb58uUGykKPlTnkgFvVo?=
 =?us-ascii?Q?Zo9vTEYkipWt7muwXGihvqmsaCg+VnfzzCe4mN9QfI7RKB/CnWzcIHvcJmHE?=
 =?us-ascii?Q?MnQhMndO+xNbU5x5g+QSfXwhm16FbiLJLcgGy8PSKXliRKobqMCbtlnTr2n3?=
 =?us-ascii?Q?iD66vv2MEHQT5jw9M+zuu8V7QZVg9n6fqHRF4XnToW5UUtqD9wtX9SLIeVSD?=
 =?us-ascii?Q?Xupj3I1Ue4+vo0d9afKyl2xdohBdb5AROo67ioMZ7DSYbN5iQO6AB7TM9rmw?=
 =?us-ascii?Q?Azg484hVzbovpeuFrNaWMzyolw/bmFWypeQqnPZdq9Mktk94L68Qrblx/ocR?=
 =?us-ascii?Q?tLNIyGC0dbv1ch8pbbGT0yjG8MkMMGgJUtlMlvcb1jMVnqhvLhPYV0E5wZiA?=
 =?us-ascii?Q?JLTR271sj86DdGLQA90+2IBuUA7dHj5liKKP8xJjB4MW2QAcUSXYLno93Ah6?=
 =?us-ascii?Q?+T/agHYDDxwagBrpA3wsWgLbqLc3Hb6hgxLXIwzP+nZNN1bJvgsK9O33zU5K?=
 =?us-ascii?Q?CHxRNCBtiy0CuG3F3Jb7Nwqa/+dqfVzdZ7o93rWvhdcpbZdUtdf5CEpNDFQS?=
 =?us-ascii?Q?QWm2UigQmsUWwJn3PBXtYEgnbLETT+ty/V+/QVd4lTFSbj4Zu5SaGrAPBgn2?=
 =?us-ascii?Q?7+S1KMmv06fAUUaBvPMF1LkcRgXKAE6g4G0FYgyT6PSn9/XWirowZE95PEIF?=
 =?us-ascii?Q?Tv/tjb6fhpgRk89Z3H4+WbTmfDxj/AcJYs7WEkJnoVrzBzWeiP+jq1fQTziM?=
 =?us-ascii?Q?mNIsHB00mKNBHe0wWZzedVzpGg3QyQKqqmi0ciUDUDP8ibzSDg7n07/X4/+e?=
 =?us-ascii?Q?t361lb/HfbjyrrDnE6jY4YeM7J7Ij1bllXUGwXy6+0MZG2cE2u5I9Isr1wqu?=
 =?us-ascii?Q?Bp4ewzLhzykozF4b4rZfp0JpJTqZUIp8McISAVgJcR2WsIHJzm6ltdcfpG9g?=
 =?us-ascii?Q?68MlApR4saqNZ3FuRKs9xyk4B6r4yuSmAFFbgpK8M+hE/jQEA09xxzWewsQ0?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: pnvWkLYuCbRdQdJgv3MoycRUWhVj/WLaEwo1h1FaC1Oz8sgdKAOu4np546FO3tHX2uO2m+dgIZ7vu86Y2RUzgG1DsTOjJ0aNdtOXjKDWWu4j0VCGIbwCaVOOtAFeyuDqygHjDY0SXZjq5tkoDkJFpcJeKfcKplSf87whs5skisdEjd2iJ1064w8PkRhv2j96dYcu6gOAcEefaoeg0qLTIy++sbQJuRshuW2PSSSnfC369a1MLF3xbPZYau31A2O79usYVGguAzDNinnXAV+dTfKzuRmkPRO50NUgwju78t5A36aNnmeuOg67iToiuxIxGll/kp1zy4HniwgYK/kZ0wADPAi0LGgC1QonsX7ASG3bqQzdj3lb1J0c9tyDVKXNC4mhLbORjrXaYAaTayyRaeioUIfil+yO4Qk4lwCDaAfjEkLPRVGFob/aFgbqHhMCXNK5T8kD86T5lMtCF/XQxmvMucTTkDtwRMhawGcjIo7ggPVAFV8Yv7MvjoMlNwmiaVrPGpVRl66h04kVDUSqcoH+PSlGtzfWSKZ2Fvdm7z6qmOdHhNzf+VA7nkvtyJHgtVFWztzMzTaLQvH/kRdJItnPcV1OkCvIB++q1427fxQ5I/wVaD7rKuPnWa9JKhz95hPLBPew5I+v9+MM0GpYv7LNXDIP28dEpZTjUEc8kXSlYTmQI/qonTEkIrDFAxF6fHl9Bt9JBpddYfw6kIK1DJ5wJrU8qfOEwpbdbdcDI+1yJd7tDHrJPeaL9kkkQ19/MpoLhgHGs7zDcfhU23HSwYjb5J9Md+q7i/E2cV7dqJFPTtCq9uI6plGHzxI6Vs02dFiV9Cfoe28Sat/Rb8JyoqKllTtvjTbGZ0TzsfUY0qHGuR02+ZiiuDrvpPYaPxOy6BIfYZkb5kJu6Mk53LQ5qg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 060d1bd2-5c01-401c-38c3-08dba2bdb279
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2023 03:13:03.1511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OkWJW5laxCKTa1Tc6a2MsMJNdvXG+wNqSxrcTRi889Mjj2uwCAlR0in0sOSlVcNN+g3wZsy11raAJGL/5AJvIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5028
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_13,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=555
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308220023
X-Proofpoint-GUID: tMTjclo_ydrR_sRMEhsQ6mBYb8cOo3_n
X-Proofpoint-ORIG-GUID: tMTjclo_ydrR_sRMEhsQ6mBYb8cOo3_n
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
> We can use a bit in page[1].flags to indicate that this folio belongs
> to hugetlb instead of using a value in page[1].dtors.  That lets
> folio_test_hugetlb() become an inline function like it should be.
> We can also get rid of NULL_COMPOUND_DTOR.

Not 100% sure yet, but I suspect this patch/series causes the following
BUG in today's linux-next.  I can do a deeper dive tomorrow.

# echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
# echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

[  352.631099] page:ffffea0007a30000 refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x1e8c00
[  352.633674] head:ffffea0007a30000 order:8 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  352.636021] flags: 0x200000000000040(head|node=0|zone=2)
[  352.637424] page_type: 0xffffffff()
[  352.638619] raw: 0200000000000040 ffffc90003bb3d98 ffffc90003bb3d98 0000000000000000
[  352.640689] raw: 0000000000000001 0000000000000008 00000000ffffffff 0000000000000000
[  352.642882] page dumped because: VM_BUG_ON_PAGE(compound && compound_order(page) != order)
[  352.644671] ------------[ cut here ]------------
[  352.645746] kernel BUG at mm/page_alloc.c:1101!
[  352.647284] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  352.649286] CPU: 2 PID: 894 Comm: bash Not tainted 6.5.0-rc7-next-20230821-dirty #178
[  352.651245] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc37 04/01/2014
[  352.653349] RIP: 0010:free_unref_page_prepare+0x3c4/0x3e0
[  352.654731] Code: ff 0f 00 00 75 d4 48 8b 03 a8 40 74 cd 48 8b 43 48 a8 01 74 c5 48 8d 78 ff eb bf 48 c7 c6 10 90 22 82 48 89 df e8 fc e1 fc ff <0f> 0b 48 c7 c6 20 2e 22 82 e8 ee e1 fc ff 0f 0b 66 66 2e 0f 1f 84
[  352.660080] RSP: 0018:ffffc90003bb3d08 EFLAGS: 00010246
[  352.661457] RAX: 000000000000004e RBX: ffffea0007a30000 RCX: 0000000000000000
[  352.663119] RDX: 0000000000000000 RSI: ffffffff8224cc56 RDI: 00000000ffffffff
[  352.664697] RBP: 00000000001e8c00 R08: 0000000000009ffb R09: 00000000ffffdfff
[  352.666191] R10: 00000000ffffdfff R11: ffffffff824660c0 R12: 0000000000000009
[  352.667612] R13: 00000000001e8c00 R14: 0000000000000000 R15: 0000000000000000
[  352.669033] FS:  00007f18fc3a0740(0000) GS:ffff888477c00000(0000) knlGS:0000000000000000
[  352.670654] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  352.671678] CR2: 000055b1b1f16018 CR3: 0000000302e5a002 CR4: 0000000000370ee0
[  352.672936] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  352.674215] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  352.675399] Call Trace:
[  352.675907]  <TASK>
[  352.676400]  ? die+0x32/0x80
[  352.676974]  ? do_trap+0xd6/0x100
[  352.677691]  ? free_unref_page_prepare+0x3c4/0x3e0
[  352.678591]  ? do_error_trap+0x6a/0x90
[  352.679343]  ? free_unref_page_prepare+0x3c4/0x3e0
[  352.680245]  ? exc_invalid_op+0x49/0x60
[  352.680961]  ? free_unref_page_prepare+0x3c4/0x3e0
[  352.681851]  ? asm_exc_invalid_op+0x16/0x20
[  352.682607]  ? free_unref_page_prepare+0x3c4/0x3e0
[  352.683518]  ? free_unref_page_prepare+0x3c4/0x3e0
[  352.684387]  free_unref_page+0x34/0x160
[  352.685176]  ? _raw_spin_lock_irq+0x19/0x40
[  352.686641]  set_max_huge_pages+0x281/0x370
[  352.687621]  nr_hugepages_store_common+0x91/0xf0
[  352.688634]  kernfs_fop_write_iter+0x108/0x1f0
[  352.689619]  vfs_write+0x207/0x400
[  352.690423]  ksys_write+0x63/0xe0
[  352.691198]  do_syscall_64+0x37/0x90
[  352.691938]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[  352.692847] RIP: 0033:0x7f18fc494e87
[  352.693481] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[  352.696304] RSP: 002b:00007ffff7597318 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  352.697539] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f18fc494e87
[  352.698790] RDX: 0000000000000002 RSI: 000055b1b1ed3620 RDI: 0000000000000001
[  352.700238] RBP: 000055b1b1ed3620 R08: 000000000000000a R09: 00007f18fc52c0c0
[  352.701662] R10: 00007f18fc52bfc0 R11: 0000000000000246 R12: 0000000000000002
[  352.703112] R13: 00007f18fc568520 R14: 0000000000000002 R15: 00007f18fc568720
[  352.704547]  </TASK>
[  352.705101] Modules linked in: rfkill ip6table_filter ip6_tables sunrpc snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg snd_hda_codec 9p snd_hwdep joydev snd_hda_core netfs snd_seq snd_seq_device snd_pcm snd_timer 9pnet_virtio snd soundcore virtio_balloon 9pnet virtio_net net_failover virtio_console virtio_blk failover crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel serio_raw virtio_pci virtio virtio_pci_legacy_dev virtio_pci_modern_dev virtio_ring fuse
[  352.713435] ---[ end trace 0000000000000000 ]---
[  352.714725] RIP: 0010:free_unref_page_prepare+0x3c4/0x3e0
[  352.717293] Code: ff 0f 00 00 75 d4 48 8b 03 a8 40 74 cd 48 8b 43 48 a8 01 74 c5 48 8d 78 ff eb bf 48 c7 c6 10 90 22 82 48 89 df e8 fc e1 fc ff <0f> 0b 48 c7 c6 20 2e 22 82 e8 ee e1 fc ff 0f 0b 66 66 2e 0f 1f 84
[  352.721235] RSP: 0018:ffffc90003bb3d08 EFLAGS: 00010246
[  352.722388] RAX: 000000000000004e RBX: ffffea0007a30000 RCX: 0000000000000000
[  352.723909] RDX: 0000000000000000 RSI: ffffffff8224cc56 RDI: 00000000ffffffff
[  352.725408] RBP: 00000000001e8c00 R08: 0000000000009ffb R09: 00000000ffffdfff
[  352.726875] R10: 00000000ffffdfff R11: ffffffff824660c0 R12: 0000000000000009
[  352.728352] R13: 00000000001e8c00 R14: 0000000000000000 R15: 0000000000000000
[  352.729821] FS:  00007f18fc3a0740(0000) GS:ffff888477c00000(0000) knlGS:0000000000000000
[  352.731511] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  352.732723] CR2: 000055b1b1f16018 CR3: 0000000302e5a002 CR4: 0000000000370ee0
[  352.734199] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  352.735681] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

-- 
Mike Kravetz
