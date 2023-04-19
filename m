Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CC96E85D5
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 01:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjDSXW4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 19:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjDSXWz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 19:22:55 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0061BEB;
        Wed, 19 Apr 2023 16:22:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuhLmzIfwDGp4icDxWzgbe6hQzPdcJ4kBBZmaHLl0l2VHQB8+IT+mUGeWQe8poth9C8GrI+BxD6t0jzthi6H2qgvzZjQw1nWVM4AXq6XLREVhZjruYJkMFK9lGyxEoXKnYKVBcdaU0Z8cqhX47FLgb0Lz6yQLUt91tkSIiSpaUigX/qpCzdNBWHyS5OKsa+Sd99F8RhdV/3Gp7aedFV6larhHpEmWJP+LR2ImnfuO90v4UgOfYdCI2U03hxuPs+JtQvv4IW9GTHEIIJD5FLSmKgYAD2G3JgGzqAD6A0j3B//cr2vJIDJTDAf9EFW/EMqH7zRP2J5UCL+a7LOCo/33g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=slZXqGzJlShmAnoEIUCE114mQvSY9X6mN2q7cAXLnKI=;
 b=XVH4Je9Xcs7MJFBhxvpzTs4zLJZC4LFGrsXCHIO+g8FQq9H8wuz1Yrq6XNTz8jK8tGpekN7QcUlMT76NpCvO81ZDORzhbOVc3zEY7Ca6DWrCUd9sGw0fNhdwZt5haij+jJHD2P3o0bLBWrF7znVVQdlJoOpjiXTwjvfHK0iy25Zzl7RYfGMfAkzb3HSbtDcm29hrQSN01jRMskJXjFieFRW45bTMh3HXZhkyXER/cFAar6eaQXNbppN4NY9OU/ArSTdHFfC6e0LNcGvuRZi+jRt9toglvd/Wd4gTIRv38Fg/WaZuW4phg+Pi0DBgU2BR9ljdr6v+YHgPf560b/DseQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slZXqGzJlShmAnoEIUCE114mQvSY9X6mN2q7cAXLnKI=;
 b=iHjSAIkh+/rVXvB2ZtvG9YeRSPhJhMgeYfkzI47u4n9nPqgYtV0InI2MCETeiGhM2WAz8ug99C8nbb/0OLD1yt/Hn8fkWp+lHApncrK0t2SPNtJpWT4UFtrxBBd202fiPkZQ8k2r58Y9+T8sJkMOrkj8PMSVULbVPGOeL11HNhzp+J6IsQisjwT7nBCmourLeSDSEnRmF4znnjZPVcp1qkQzS7w03TYXJr3C/+JCTmxQ2k+TFlOiaxQnVYnt1xllzRZxD/g1Qb0akOwDxcW6AopT5ZAK7n4pTxvfH5w0tFT023vMys/c/yY3f077xAHwEAHoaKaNOkgUVkTTFErclg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB6013.namprd12.prod.outlook.com (2603:10b6:408:171::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 19 Apr
 2023 23:22:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 23:22:52 +0000
Date:   Wed, 19 Apr 2023 20:22:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <ZEB3y0V2GSDcUMc2@nvidia.com>
References: <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
 <ZEAxhHx/4Ql6AMt2@casper.infradead.org>
 <ZEAx90C2lDMJIux1@nvidia.com>
 <ZEA0dbV+qIBSD0mG@casper.infradead.org>
 <8bf0df41-27ef-4305-b424-e43045a6d68d@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bf0df41-27ef-4305-b424-e43045a6d68d@lucifer.local>
X-ClientProxiedBy: BL0PR1501CA0014.namprd15.prod.outlook.com
 (2603:10b6:207:17::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB6013:EE_
X-MS-Office365-Filtering-Correlation-Id: c8260e13-3f4c-4599-3274-08db412cff40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uo0AxY8Dqitxq6p450pXha2r8bOs9C5fgsxsxLQUOHyLxleB9e51l+2py1YXac5PJEsRdSH1mrAYQJxoBRAI5vAWlTnYqdXHcv3+4GMIIeXdMdpsfw4nu8CP/pp+VwfmAk/zo4MkmGSg7Ei9FnHbxZbv8JzNIoytu3mrcMu9C5DCHGvL83F8n3ScDS7PGhTIXg7FlFXzY0FotdPPRQAaJiEBwaGC50467A/yuA1ruFw/IPF+yCRrRmm30rUTliRw59dGKcWT9cF0Aw3z1BgVF8soRVUqhKcDlIcpzCjXe8lPOKzIh2RCkxYNYJj6bcfGjPPbQwM8RDYUUNx6VPfY1CxKxbpQaPSHPzz+RqPgi2EhUboXX9V+aAvP39UK5WBNfZJQrrUNv/Jkr3FY3kGoLLZcLUdnHqI8sBE0Ld03BZUh/IWMQ6iY0cKOsaVaD3xb23e8V5ajcPqykUCazGj39On7MqUtFWg3z26NGe5JjBBV9yr03z86ZDmDn1GuzOQFdtMDit0Fn2itsYc5IEQc6/Xko3srVYDCp6pY5yMkTwLQDyjypOni3sAjdsCGsvMd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199021)(26005)(316002)(41300700001)(6916009)(54906003)(6512007)(4326008)(66946007)(66476007)(66556008)(8676002)(6486002)(478600001)(86362001)(5660300002)(8936002)(2906002)(36756003)(38100700002)(2616005)(6506007)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KVNv3jt4ov+W13oja7EPxfCLGAQoRr6BIUaWNjwHSrX83o2Oz+zVvLT6aTjV?=
 =?us-ascii?Q?IqUNqKZCA+QkJeV8eGBw5VPLc5v981CRqa6dcvbHdQTfc2QvtlWF1yWZxO/J?=
 =?us-ascii?Q?IsTifW/Gk5GUaqBX5ijo6NRPJSRJqrCagLkyeLx+v5+kfwr5qt1M8M20b+ZQ?=
 =?us-ascii?Q?0FFmOEyp0xf5C4iBFVEqlRofKiUS4Zz0AA4pgIk93Jatmc0atUNndi2Kpsu3?=
 =?us-ascii?Q?xH8siN6OGSJm1WHnbo+umTmIiYORwclkCH998natXr6fzTolSwWHSUuK8vT8?=
 =?us-ascii?Q?Kbz8GfI7yWEM8OSFY+Ei3/Sbqhz6z6dg97rr+8Qp+aTiagnfy46JzsHcpmJV?=
 =?us-ascii?Q?2NeNWr5hnirEE9WWkPl6WgsCc+PeRsS8KKVVTbEoovsO4Je4PHjY+mkS6yc2?=
 =?us-ascii?Q?InDVfepw7EE0deSX75O6Q2zvHTa0nrEHxEd2qEZJMAgGOgPah/ZW7L/cwhms?=
 =?us-ascii?Q?2a6juOmhSYeHNcxTX9OtYu43MXQpWHrimMzsMLTpQino0mumaQPs7i+fHmjX?=
 =?us-ascii?Q?h7W2F2cj9CvAGXOn4xFNp84V02NkMHKT+kTWL9TlLB4QecnjdXDpFwdcvyd4?=
 =?us-ascii?Q?Pi3HEMWrbvbIzaAe3QcnFUbFYFJji5uevH3Ivpd5x5GATMmJ9WQV/MtaBDTg?=
 =?us-ascii?Q?yFBpQkB8L0BoNi2ccoyM3QCpD2AToqx0HCEnV7jffF9MlTtRCH+nqGkZbuFp?=
 =?us-ascii?Q?bEWK9zpxoA5HjVQtTeCNHyUrt6a8DOCvKufgqLaPqzcsnHfuppnECDDaJXdP?=
 =?us-ascii?Q?EocUajZq7xZjnVq0L8j+F9DbW+F2Xj46aW/Wn2YvdnT/suFbapdEegJ4nQ5m?=
 =?us-ascii?Q?j9xfcyWXU7bo6dQLKMYka7/3vfXJl6yubU1dv6+6Ak/Rb2Mu/ZWkQ/xh27X+?=
 =?us-ascii?Q?lkEhILSaIl9fpKAcjorwWzRwYGYykZsCh5t4JmvkkZIjM7Zx7NQn2WBicQoR?=
 =?us-ascii?Q?/uRBqWl9qUUwPTNpdrUQnikpMBK0fuMiCFsxoMOOeGqUfGQN1jCfB8HUtXJs?=
 =?us-ascii?Q?PZwf3dt655FM38RHnP0Ao3mRaSlvpnioVByoGw3TAbL+p4imLO4cmj+Tno20?=
 =?us-ascii?Q?oOgZdnjcWgecG4FMsSWVUcnui/i1N4p3odlbeLVDNFa8FGWo6OU16bQm/Bd0?=
 =?us-ascii?Q?XjURdDMGN33de9wibGhZSf28luanwXG3sJh4uZLqsRxQJxJKcnXKhwXzh+/c?=
 =?us-ascii?Q?MkBTIO1WQpBw52VFCPSCn8tIve4+Lmtqm0GgAyaXiek0EkX0WcAxgLQ0m+NS?=
 =?us-ascii?Q?sKSQ5limKmJlTTTHSmFBRcjK1lqHSL1dC2wh100vmsvCT9uFHMqhBzwwSIBD?=
 =?us-ascii?Q?/fckz6ivgQzdaZbOUGpMnSpE7bMKvT/CwHc1P3seN3jL/ETFJV+5lYr/D9pu?=
 =?us-ascii?Q?Yqi+kYNRUg9OrOSjO3TGNdP8qn9NTjrdn+cUejiO9M/TRZwJzpM2bZH9Ft+a?=
 =?us-ascii?Q?gRsw6gE+KfFPoY5sDDyhrqIksxrlEvMyhIlQ+OZEOOsTMcVcDDiZJMNAuTwx?=
 =?us-ascii?Q?z0SJJflh8bFyEX7LFOWkcYSuKogABljB+ygw9626Dd0nwzTxtaOCTT8oKGUB?=
 =?us-ascii?Q?sCe8sDCx9u/TP3Tf5jVRZXYaYVBBfUNBYPkjmE96?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8260e13-3f4c-4599-3274-08db412cff40
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 23:22:52.1549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XpuHD8UYzLJKdjeLUB3ZXKhAvoP93b1OtddJMXalqJNH+H9x58iSM6Q2B6oSrZwd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6013
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

On Wed, Apr 19, 2023 at 07:45:06PM +0100, Lorenzo Stoakes wrote:

> For example, imagine if a user (yes it'd be weird) mlock'd some pages in a
> buffer and not others, then we'd break their use case. Also (perhaps?) more
> feasibly, a user might mix hugetlb and anon pages. So I think that'd be too
> restrictive here.

Yeah, I agree we should not add a broad single-vma restriction to
GUP. It turns any split of a VMA into a potentially uABI breaking
change and we just don't need that headache in the mm..

> I do like the idea of a FOLL_SINGLE_VMA for other use cases though, the
> majority of which want one and one page only. Perhaps worth taking the
> helper added in this series (get_user_page_vma_remote() from [1]) and
> replacing it with an a full GUP function which has an interface explicitly
> for this common single page/vma case.

Like I showed in another thread a function signature that can only do
one page and also returns the VMA would force it to be used properly
and we don't need a FOLL flag.

Jason
