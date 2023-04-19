Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE966E8131
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 20:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjDSSZB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 14:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjDSSY7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 14:24:59 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA84D2;
        Wed, 19 Apr 2023 11:24:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3R7qZS8ToH3UieY55ygamU4taIsm5ciPm9rqGCIpZa0itdF4XAcSqDapTpJx/4oTZwFo3MeLJzQgspVXXd9QVf79vXHGs/aVIFI/jAzV0FHCeHHxl+v7pvUPAK7CLm1455GUEdR8xy+9aI0wdLZsf7cUPnmQpzKEbT4zEn3NpkLWCwmj+uXoNbpRB+mjfobeCcccw+31M75gqL8eauqZPHGVkQ/P9tVg8wJvi8RPs6P8UTrsx30/SYiZLi+FDioCBjjVp2PDTl/UbcWr5XQ+m66eMlbILb3bNplVDvB/I8/PYzCoGo+N2/6QbToae6UD8T8A297XZFj5wlZ7YbjVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ookcfr4+6fRejK93NaqAwI93uhgv3VxYqlXTFteVxMU=;
 b=MU5b++hmA1ReeQxVE5l11kJn96NZP/J3k4Wsp/m857Jrkhmi24DNH+S/zdiD2qdkO3mWfINSd7uRW2oYR2HNB8HF1FUMqeWEK41lupBEVgYLx/JguzCRKjsxwpnPj8Lkd3m6vD/qc5yZN2MaHmHUNJwqVw6tWxN48DfKsQWsduXBAfMouPjmBjx/XNvdP3/zpe08gXEFXvJS/Di6ySSm3o9wE3s5l7F2mhfJUerEiBbOyLyizGrZh0iAi0lJ3eXPbhHGdjX+ev0EpjHHvhVAoW6D8577e23TSNBAbA6uZjlXxKKl/DYBKfbe+gxYAHbSQLpiig7hq6kZxNborT60wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ookcfr4+6fRejK93NaqAwI93uhgv3VxYqlXTFteVxMU=;
 b=WNyXrf9F1z90w9EukMDYgherYiROcCsk42/Ko3izCQ1JAs5vw3/1e/Hb47ZxzUVsCJN+8mnHJhsymixGWPQHQnyeeb4Fk6x8bU/5HC7g6wfqZhk8D8DuJVPUkgzjLiUZ7PqVCFuJw0y1JlhWNjIBF+qkiREcbnQQZ3o7pse8gb9Htdvr10B2LBp0/7+SP1zKq9HV0sK+7p+BHrWjOczpauhXAcUdXtOF+X8JIHDGrl+VZR8TY/ffDBLXevnJuiGqKTjXFPP2BG5i5kok8QI52NbuyqcxwrbaWaxG8N+RqL1jnqHSdEJ+80Is1QqhQiwSqBQAc3ek8nbX42GB6Ugntw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8538.namprd12.prod.outlook.com (2603:10b6:208:455::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 18:24:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 18:24:56 +0000
Date:   Wed, 19 Apr 2023 15:24:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <ZEAx90C2lDMJIux1@nvidia.com>
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
 <ZEAxhHx/4Ql6AMt2@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEAxhHx/4Ql6AMt2@casper.infradead.org>
X-ClientProxiedBy: MN2PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:208:120::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8538:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dbb8113-35e5-4f3c-1f10-08db41036057
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V6Vjl8o3Y1EZZkIeBEg6H537sIeHBSJdRrHSsvsNGRqO4jSlnjanoiBJo5jYEXMN0fA2ZB9igiFDQqQAf0Cba5IK+WoT3MRv7pxznhGN+/b964Xxa3E8hb14fR/+q6+Grb3bXwuFLyCMIYXZ/HRy1GaFyk4/ojimJHub85AFEJOHvC39LTdW47qphruyCHtqY7VBzN9FTzV9umvbw07OOqS3NT0ZWBuq8UjZho5vpCKmFl1BZ3hlfYdRFxSr/6cRoZHnahgkwsPWqiiXadCjGATvaFEH29Yl+dcReTpHMVkDwA+T/+9Y4aXXLzLoXmBH/N2x6mNbK8HLqR5Z1MWNnJ3H+wqYZTBZmWVwZm7n7bolbbOtO4cy1qjap9EoQC/1C3SyNueW7QYqzvaE/seb02Ia57HwAA6l9CioGCV7fUy1Ho0oMazKcQRY/Xfi7vz67Vgw8MPIk7Tun9N7OblGYoB5YgURUnxli/xyZvkRcKNs9iGy/80Gd9HB+Udq3zR9Lxfa7vguAazlAzMZqr1Z1ol3KRZMLHk1Txsh707QwK7DSaRIp7eKGiNlAwhO5AN5l8IKlqXgKb2FDftqf/ioF+Rn3I5LMD0iIgydZ7wcUVo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(66476007)(83380400001)(6916009)(8676002)(66556008)(41300700001)(66946007)(54906003)(966005)(6486002)(478600001)(4326008)(316002)(86362001)(36756003)(6506007)(26005)(2616005)(6512007)(8936002)(2906002)(5660300002)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C/LZYgJzxExkJlxNRDJ69P7alsXHhgWVgMEApHNVrJagXsH3NcEuxvBVxMu4?=
 =?us-ascii?Q?w+siMdL04iqzYIXVXdEkn3zcUlfO6An3C9Yw6sPe/MQUNoMYECsN1kDdv5T/?=
 =?us-ascii?Q?jMnXYae0PEDpTFPddCbKUSTUco/6PyXRgkPp2WYSPnWM8dtaP7cY+HOdn5Y1?=
 =?us-ascii?Q?lKwThlwTzl3U9mzoAsUTB9d9JWqVQ90dunPsC/cn0TyEp+RuMD3Flf0iaPzE?=
 =?us-ascii?Q?WidnbKhHNJP0E/NhhxxESQNBYDCSgsflEc68K3LEOgCHJNhbjHsGx/po75h8?=
 =?us-ascii?Q?wjWGHlXzChRmk2etzqmnXwibfUcyI3AttyGsSH2H2BYs1bQT3vTNwOSu90WE?=
 =?us-ascii?Q?sqq7m5iuWiXQJtT5ZhUg1Ml00F37J8ufTicj1q/nk+uvsxm3E805UNGI/+Oq?=
 =?us-ascii?Q?skdkIaSQxKzpTACPQgKCcCME9I0BplsLn+7qOeH2WQCKSjsOHi8xmP9ACYwn?=
 =?us-ascii?Q?T343SCpLKEr805Mv21wuZO6SMMqIuftGjOqQ/dXkwEpNswrIAZj0sk3z5F0Y?=
 =?us-ascii?Q?xyExluJgF1wFsXMBlyl5p3jmf4q3yZqyDNdNJFRdgB8TjgfnDEtVvjjARvgz?=
 =?us-ascii?Q?tkIy9Z5yuSmSMRKOpk975WI06u5CubfoVVbjUKNXcV8WX+Q3OJebQooZcvtY?=
 =?us-ascii?Q?RFbdSTcfi56+mm+pYw1mvvWrXXgaganXVzsDrTO3Gk1/fJKOU8QuosI832Sb?=
 =?us-ascii?Q?NUxD7mmdybj3Sd7xX4BDGUjbxJLnKIWCO0zH5Z9/H96LAW71HNcVl+m9nBpS?=
 =?us-ascii?Q?BcYVzOtCCw1aY5nqLGchctE7cAm198sGfw1d3Lo4xBsdVQ1piCJRBGkoLnKD?=
 =?us-ascii?Q?yozR55M8ySqccHw/1lpfTQtP9OlXPzlfzMtcVhopmfOTqJ5oSpQ1Z3ruHvHn?=
 =?us-ascii?Q?FvAnKzDVqFT0/31nfUC9HcpQC2sOoiD4HgxT+TvkMQ4keSMZ7k0uULSk9MW+?=
 =?us-ascii?Q?RowbMYBX6FsT4Tqg9CUItoMUG0FtcMct4gVPnSM+t3HfIlLO+Fr060y5vAEN?=
 =?us-ascii?Q?8isykYdN5vc5gFb0VcvXOwP25d35j5XaWYQF0YVPjS7rzuRkfjkuXl+36i1S?=
 =?us-ascii?Q?7n69aTu+cozi4esOvO/+4Q9nZH9YBODjPWysRYhZvkrnKyjVK8QWzWaJHlO+?=
 =?us-ascii?Q?OtFjvW+vv9jadGKXTg3UxDYXhiCax+WRVvUSIXd10ME76FYnGHbjc1chask2?=
 =?us-ascii?Q?BC7OJDAhbcGADGnBER6JRZHrZQLsXkdCTkOxzmEEvQ1GBfT2YY9IxiGms5kW?=
 =?us-ascii?Q?5jHLz2nm1Gpal1K/KIFgix3PDXUK199a7QJMhFFlxQvkmk3oXyb4DcsR1ilH?=
 =?us-ascii?Q?/es/BWbI/CpdolPJuMqTaHx9+2K9FQec4E5M7xbogzH6vs5reRzKQsC1HpcI?=
 =?us-ascii?Q?aqIfaXKXPNmrDVRqYptnpuFhqsfcb0LaDZlAvjDj4TeIbUZb+TiRz7ekb9du?=
 =?us-ascii?Q?qL9GVtKqoz4bGaIZV5B0YxS5kDjbW3qG+t8e7kBJs5676jNT6WoPNWLHu9b2?=
 =?us-ascii?Q?5tThGUBVy3slA7AYdKDMOqROCpBY+WQUOwH8bEzgE+uW5EYsp0W7ncUIBDv4?=
 =?us-ascii?Q?GHek1OyARQMfQ3na3EqrwtFDHxWLWaZMrYqN4fV1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dbb8113-35e5-4f3c-1f10-08db41036057
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 18:24:56.1459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1n+4X2mM1EaTOIiMjjnoozSM6yswZr9V9ydVg4F0E2Kym+1yaLFlkYvX2124bYRn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8538
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 19, 2023 at 07:23:00PM +0100, Matthew Wilcox wrote:
> On Wed, Apr 19, 2023 at 07:18:26PM +0100, Lorenzo Stoakes wrote:
> > So even if I did the FOLL_ALLOW_BROKEN_FILE_MAPPING patch series first, I
> > would still need to come along and delete a bunch of your code
> > afterwards. And unfortunately Pavel's recent change which insists on not
> > having different vm_file's across VMAs for the buffer would have to be
> > reverted so I expect it might not be entirely without discussion.
> 
> I don't even understand why Pavel wanted to make this change.  The
> commit log really doesn't say.
> 
> commit edd478269640
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Wed Feb 22 14:36:48 2023 +0000
> 
>     io_uring/rsrc: disallow multi-source reg buffers
> 
>     If two or more mappings go back to back to each other they can be passed
>     into io_uring to be registered as a single registered buffer. That would
>     even work if mappings came from different sources, e.g. it's possible to
>     mix in this way anon pages and pages from shmem or hugetlb. That is not
>     a problem but it'd rather be less prone if we forbid such mixing.
> 
>     Cc: <stable@vger.kernel.org>
>     Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> It even says "That is not a problem"!  So why was this patch merged
> if it's not fixing a problem?
> 
> It's now standing in the way of an actual cleanup.  So why don't we
> revert it?  There must be more to it than this ...

https://lore.kernel.org/all/61ded378-51a8-1dcb-b631-fda1903248a9@gmail.com/

Jason
