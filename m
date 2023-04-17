Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873A26E49DF
	for <lists+io-uring@lfdr.de>; Mon, 17 Apr 2023 15:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjDQN0T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Apr 2023 09:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjDQN0S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Apr 2023 09:26:18 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2073.outbound.protection.outlook.com [40.107.95.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9503A72A2;
        Mon, 17 Apr 2023 06:26:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EvDeISCb6nsSX8KqTyArcgpQyiUukKLaxIabKhQ1nAxpLvM+MNK6Cy/s5p4Smiq2wE8mqVgf4MwvyOUxHl7S1zfjJqHY+uvpF721rJzsGGluSYtgojDDe2mEltA+an+P21lSH+g6r94IK8RxFC8Nr0i3MPQccL6FiF+bR51OHiGmAXHmhrCOYx0m5ChQZqRZ7fijgFPHirAjTndrHDqxuF7ovQAtI94ua9A/9j/b6GTRO6+jZ2/rsf3IzWJPoL0EkCe+4mlXEJ5g5BRVMJx//aeeSnoNnsOw/4utHj+IZ9yt4GboB+BHezH4oc2OuuyCeGOfDb5szUd6qdRKKQVj2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6eDMUrV/LCeZwYhl1q0IUPTFTk5XP0Bi/F/jLFozTk=;
 b=EL4z5Xn8SVk4RtZ0FsVC9nL8AFB+k5Ir77bbSYLK4GCixi0fjS0HT6o7QRNG9q+GBLutb2jleHYW9tlKceZHIQHQAmddyABEo3nqBJMLsPTLimBOMvRNNphF2OzXxBVPuvlRnY7nhG/4i+k0eT4FYGnD1m8l8dd2ByohRgSYciGfIQvf4hlYwCOVbbSZXOg0s7tfkY6DAU3nICutxua+7vk+v/wDRXXML4W0wf3Bbx4z8CPKG2nrhBlNj4DyBZQYKZkez4qyc5Ht7upkQ94RV1iOPuednnSV7BxnRCZ4VHBA4d2B6VvBH3LOWTJDda8OOlZ8hkjQAUZnF2LyDTi2QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6eDMUrV/LCeZwYhl1q0IUPTFTk5XP0Bi/F/jLFozTk=;
 b=ruB7zwq8XjNmY97MGgtAwDpSZ4fWnjftkYGcuLreUhEZ0AAIYtVXkKtimrnprURCqSm3jlHUlWlfndPmHqkmKZVns4Qhie+TOgwgVYVQ4+yzTj6PXp3K4tC219rq45Nzb/peNhGM+Oz6SF14zDKRG3zIuKLpqasjJOiSgZVqukDs1y+TCQ7TLC+UPA0y34NL5fWA3x8Wzx9f7tu2yUu9njTE4OX7/QKof/FiE1N/uMFe46rh0XBroB2k5z8Cj/UEYlwx/auwU1vJ7/UQdpqb6aeXLth3/oXrspoTHsCQwSzm0kHxOyCEi30NmeFKt18Y3kt8uFdXNoX41clTfLPT7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7966.namprd12.prod.outlook.com (2603:10b6:510:274::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Mon, 17 Apr
 2023 13:26:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 13:26:11 +0000
Date:   Mon, 17 Apr 2023 10:26:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 5/7] io_uring: rsrc: use FOLL_SAME_FILE on
 pin_user_pages()
Message-ID: <ZD1I8XlSBIYET9A+@nvidia.com>
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
 <b1f125c8-05ec-4b41-9b3d-165bf7694e5a@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1f125c8-05ec-4b41-9b3d-165bf7694e5a@lucifer.local>
X-ClientProxiedBy: BYAPR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7966:EE_
X-MS-Office365-Filtering-Correlation-Id: 142de38e-dd29-4fd9-7c1d-08db3f474f8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eirDB1/80OKgeJDKTBkIUmxBwb+AJIaKR8U2H0ApCfM7tLSocvU0BpXWDGqRZ7GTgrJ6Fmb/pc0IBSAeiTZwRFYyR7y83Jk/NEgK6Neu4vxfQgLjDPI3gBLX+naDu2aj7BM1/PO3hwQLXL7OzNrAoX5g4x26FF+XjQTG7Xu9cbgxVmG7PrLe/HSq3lYPjcGNa5/rK2ATtP2mqOqKQOfD1YDWKdh+aLxdXvxHNjvVpa1yrinEV/DBSpyUW4/lWpAzDY0r1dUZpS2Gy9WwMuaNMlIWySeuHqvPX2DIiadpPkukYd/mogjmO3Tl8qWrHsPti+n/6Jz/RcXUOK+l2/AZmQYzFGAGNkyOdviYfCFIxsO+YUkVUDMCElSjs2tr3VfWzLDt1bjSx0X3emM+EJGf653hq/rL+jSWwrtlQKT13Y6SWwbvU/9plRzMxnFCnQLni3OrLAL9xsmbplMKcV6TtDzfHNhDD4t279ZFkWr6k+vsDozj/TllpJHj2IIX5ywSqWGJ+lyntzg2ErOfJKwmFEE0Ff/zzfd8YN0bb26HepGhvjm8WOSgIzEaHM06mxv1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199021)(41300700001)(5660300002)(54906003)(2906002)(66946007)(66476007)(66556008)(6916009)(8676002)(4326008)(8936002)(316002)(478600001)(6486002)(6506007)(6512007)(26005)(186003)(2616005)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kD/FVEQx8McnZfpMT19pzD3lPFvx9Io8QSCY4NcFVDDn+OGbDyxwq2MlH1QD?=
 =?us-ascii?Q?Jy2gIrwvnCvBzfIiYODUl+ttxuOXcXeKStVzj3QP/6+2mYlfqPhOuLQK2jQr?=
 =?us-ascii?Q?MpPjkS+gJgNn4nsjov1rdehqISe7OeeNrIMT77Rw8KMs0NQ/DhzNhKGk/9Fo?=
 =?us-ascii?Q?vJwG2s35CyCre+dKdJqM8k1KzQ92YCx29txtQyS2fMbkTMxYYkdShIz3Uy+/?=
 =?us-ascii?Q?9tQRz9xMwfvtm4tmzeJrUFKL70Xnpzz6rW3DH3I9WtcH1eBi/JRscw6Qwuzl?=
 =?us-ascii?Q?K/zOp1b2WaCyjh8hBclWDK402UU5LBSH+W8swzsetS3xJk74tK3+twqJFXcM?=
 =?us-ascii?Q?ef8RmsFmRzx2pxhCpbLUs0tr1ZofLI+P3xJCXKsZnVsjaQDx04fAqxy6eJOM?=
 =?us-ascii?Q?ejnuraoYBW6sspiWZ39BUNPluIxAbpF9/pqEwKdwMLJdZYZpM+R0XG/2Rgog?=
 =?us-ascii?Q?Q+HPbw7zarf2PrKSaLAxDfZJRj7JrjZ+ITZzOJklpUAhy1FfaVjtOInhoN/6?=
 =?us-ascii?Q?IOwCq6hwTN4fLX/AP5+0nDsbXWjag1qx0EgtsAgNW06PrjgL3Jlcys5IUWyV?=
 =?us-ascii?Q?dhFYYh1M6twSFp0FmjqYvhjDaf41CQ+/CMiXJgOQkJAPZCKlMu3yFVL7m/xk?=
 =?us-ascii?Q?VSZrewWAvVgZBXFtZu8iDrH1C7+6va0f7VG6NFlxcM9825PqNsTexA6T3i58?=
 =?us-ascii?Q?lGsBechmi/xll0bshz4akG5Fp5UUVr8MQRhZzQdEcINhCtr1qhEedXfM5TTV?=
 =?us-ascii?Q?p8QXy9iOLfLayydAyuMcZmvuwyFtkETiFCZa83EONHH8NClZE/pUoxQpJytb?=
 =?us-ascii?Q?2enFIpSHCYV+gaY5gpO5TniuqieG4kMvHxqsYLJ6XO5RPkcy6itSgRwXXoZA?=
 =?us-ascii?Q?fLNkBcfq5ng+BG5Nr6Nysy1nkvhV2t6rGkAEPYcJezSWFi+/orFz05QKSuNx?=
 =?us-ascii?Q?g+ZCIjGsgaKscRQrhVnHlJWgKonHXpAeydIUmRLl4ITVf+vlCHpSzzP17K5I?=
 =?us-ascii?Q?8SIwC4/svl4uRoYL8zbfG56rc5tGLsbZygknY09xDuYaV/LKzB04l+/1P6fb?=
 =?us-ascii?Q?QjznfsXsqxlMpvaAA5GRH0FiNIzjnYSJEBbPQ+xgwiO2GtKcMj1Ab0AHzKXA?=
 =?us-ascii?Q?HDOMTvy8U8bLwMpMyMxz2LiV+MYn22cgRlOXGKNquWasCOMLtrwA7zEBj9Fe?=
 =?us-ascii?Q?B+1O2G/engUUcZDPAfdxjQ8bmG9q6i0Dmeps+A/fe1/0laOd7+s1R+VwITJm?=
 =?us-ascii?Q?MVoaWZvGmvpXnmWmhQ4z1VOeEC9tCTG/7PVRInzjSY68wrBTLrIM3GuMYRmM?=
 =?us-ascii?Q?UOkD8gNlSvXrjRDMgzQlaG0xpAqkmLM4sBqtuWttbalm8C7DOKjtsfIw81Qa?=
 =?us-ascii?Q?vbocW7xpAuaaNqNFPtlDneKjHdM57v0PBfbMx4hen3B0bMcB+9SEmQjQzOFe?=
 =?us-ascii?Q?zpVR2lTeprvOZIZNWtTi2bm+bUrVtZfCvOhbunjsy7NKR4b0zSnedGwflJEv?=
 =?us-ascii?Q?3k52+OJTD1esY1LkhDUIVM91de8z/99hpidWmSQwr9wcxrldLYusbWMDFadB?=
 =?us-ascii?Q?J3Tf80pmf2aHnviKRsnRcrq19ruv0/jRCDrSNkk3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142de38e-dd29-4fd9-7c1d-08db3f474f8a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:26:11.4466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hWqAdHKZyMHHojKXsk+x6ElfZeiPQ1sjaM86O93JWSxlcAYSRs90iu3ILwGgPyBs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7966
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 17, 2023 at 02:19:16PM +0100, Lorenzo Stoakes wrote:

> > I'd rather see something like FOLL_ALLOW_BROKEN_FILE_MAPPINGS than
> > io_uring open coding this kind of stuff.
> >
> 
> How would the semantics of this work? What is broken? It is a little
> frustrating that we have FOLL_ANON but hugetlb as an outlying case, adding
> FOLL_ANON_OR_HUGETLB was another consideration...

It says "historically this user has accepted file backed pages and we
we think there may actually be users doing that, so don't break the
uABI"

Without the flag GUP would refuse to return file backed pages that can
trigger kernel crashes or data corruption.

Eg we'd want most places to not specify the flag and the few that do
to have some justification.

We should consdier removing FOLL_ANON, I'm not sure it really makes
sense these days for what proc is doing with it. All that proc stuff
could likely be turned into a kthread_use_mm() and a simple
copy_to/from user?

I suspect that eliminates the need to check for FOLL_ANON?

Jason
