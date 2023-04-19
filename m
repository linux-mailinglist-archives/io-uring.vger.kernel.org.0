Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6395C6E812C
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 20:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjDSSW2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 14:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjDSSW1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 14:22:27 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5781D269E;
        Wed, 19 Apr 2023 11:22:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UEMbFOASU8wmCJ7TtJUoVqmaCZn84NQgUKvCBkJGe47yUttAh+id4cyQ5YtSgZEwT+yqjYWkV/vrD3LAETDGzWhgEemaKsOypO3mHOaMhwV3WxmUxTIltQA8vF1xL0QOtwJ1qwCFpZZ8Zbo8zt5Q0h/EnfVUlyDRjxidlSpDn//+CLlNKpnHDClMeDerOw0XRhEFNZ+bLeUuuIR527a7hNT9sb6x8bN81nysmpxmh8xYxk3bAqbh+2vrcJ5da9Rxx+YGJe2dxqMfu4S8iMfGD4aOEgtV+ZYACvUpdcBrUIO8q/DnXQHqMyWdQv4wwsLoX6ehlSVJPJnjXdis7791aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRucLXYD6qAwd3dt7lLiRkMUt9a9aLl1CrUGgLXFRNA=;
 b=jlnCsLGjty5RGNCm7bFfTWbDfKBSn2qa+ChpQ0E1SL18ld7H9EKNv6nE6H5/mMu/BdmdzTGeUZKvH2Iozbbg1Od8wE6KHx0NGgWEFLDi8L93CU8RyB0BCvYLoeaROFfSYJ5fWUXp++MoRrpXq4v/sVdzFHvEzUCIhyEXPdEN/RVGrWGElBCn7cElP525z6LlnFSI0gC/GsmxvbeylJVpUicNd1hjF/ty8hfj3T0X3zZIraPYZhTjRmjT4zynR/g7wqsYu+1O8GzixLP2ieTjMFUKaZ6pXnRIsvhR1TIjU28WPWmh70gzLZ/gqzJb3KlAjQlZaAdkdsM6RAdXObhJdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRucLXYD6qAwd3dt7lLiRkMUt9a9aLl1CrUGgLXFRNA=;
 b=YqJC0j0bB5D8rJnDPWJhfX2N+5v3fI6+SRcFYnlBR6Xpl7K7A75E2bDuSPTjp8nd6js9yRmTQolupjKY6XpGConvubPnFM7DiFlgGOZwZyunOHyvheC7gHaiTrC3/kt8yqHCPytb9r+Au/ERSVP6G9sp8rjt6GWB3xwinsm/QXMOSXOp2KfCs7/kFPTmgjZprDzXWI8JixWI9QVOWz2UDCdnYDMkuPxi0raFXF9zaZIHAKY4eTFgSKtbKP1suoZ8eRQkSV4XGvJ5sztHd5MzfPsIwTcuLJdn+r3IQxDXeIOeBsFQJh2AH9otbQLJA5AHbH20ImkgfR2dri7A1RWbRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6570.namprd12.prod.outlook.com (2603:10b6:208:38d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 18:22:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 18:22:22 +0000
Date:   Wed, 19 Apr 2023 15:22:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <ZEAxW/yR3LCNSmjT@nvidia.com>
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
X-ClientProxiedBy: SJ0PR05CA0143.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6570:EE_
X-MS-Office365-Filtering-Correlation-Id: 33be1d26-5ff0-4e89-1af6-08db4103047e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VZ9/05xsrjLl/MQ8drYzdpqYse6voT04LC6ZLsYVANmi4rChONTob5uJekaS4nzBATEuQoMjOFdpzRnQ3G6EjjNFdrXFM8Wuzz+NblhjUvNCHqbffbNRND6vLVjXSJeXZaX2xJfMl+DlBrkOZjH4QCv+l+EBIlsx2BjTbEeCCaVRjRMYLrvaBNZ1B/rulC/h4SkVr0ZX9JlP5UBA1BqIzQDf5ss/h1lwEWtffUSqlKTMPrB+xEIRADiJq0MO4v4rH2gfc8cwN318INin0fxJQ5PdOCydD4gVqvYqxyQ9pIQLbba3vN5iHZq3oYo/SwS5H1sTCk9XYkfayI0UtpZfWp38XCNGB9dgQ0/LvXX4MlMRO0t/4PsRkaPp3f13Lx1dsHCXeX6IUu7KWaM5BdKFroS4AJJcjr89vcsQshvKxxpy0jpJ7Atzn94sMUuTJV8QEOr8OE+wv6dr8fEsO6rS/qWSnHStD71JvxqFlMEZgMtxMIOfTYG5kJVuXeCvu9Tqo/n7jJ+BywQK87aFswg+Iokb6V4XjHPtRIMgwSN/hzIJsK2LUi0o25KIqsxfBiF8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(451199021)(86362001)(6506007)(6512007)(26005)(83380400001)(36756003)(186003)(2906002)(5660300002)(6486002)(2616005)(38100700002)(6666004)(8676002)(8936002)(66476007)(478600001)(54906003)(41300700001)(316002)(66556008)(66946007)(4326008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aKZiSGS1kA3ThruZE5gqmBnOn9gcNVxKgHE1lKlYatiyzAPpbna0fCK/jOqa?=
 =?us-ascii?Q?Bqm3nKAwE14ihLT9riKRyB8pbNvIdoCUjg84/zgc3Hh1rXyoBryEX0WC0juh?=
 =?us-ascii?Q?ewwR59gUbTkVUIZZzLPHAD4hvAUkkiRdYw0kKdcb1xl3XH9DtqdJcJaSwsK5?=
 =?us-ascii?Q?gmD8+UyodoO4r2+w1kOrR8tp8QKACG7c+LdbcEaq0oN2P6yZLuhBKgafntG3?=
 =?us-ascii?Q?JJ89GJKj/aZZ3zEEcQWaIoPieuuHJPqKWpGJr9ripVvdIOT/BrVBp/15gm70?=
 =?us-ascii?Q?0vXNsvQPeIjfqxHQsC/eeLrJqVyNpUxdUR1YWJ2gkvc99695eMje8Aehu4g4?=
 =?us-ascii?Q?6n50pLQpOgHSaH25avRvu4hJP0aDZO2nrGngFEllyx9fxWcEUJTi+/dKi+eS?=
 =?us-ascii?Q?lAOpnywwuMD6BM6l77AZI0oZq7og3pkKOhp3+mZtb3Y0qx/5xGI4xwpP50l4?=
 =?us-ascii?Q?0kzSx73JCndgLyYTZl8ePu3vBaamnBh5qrJifWWD+pTJpRrj95gRLN9ANHWn?=
 =?us-ascii?Q?SF4EfdoT7Rz9dKD48hqh0/E0cteMVh5y6d1awz+wE76sbkXdys6UOybD2Rbk?=
 =?us-ascii?Q?QScQqCsa3llKRNy0QwgveivYeomS+9SpKxeghQi1ZN/5W+NcPfxY8iJjrn6P?=
 =?us-ascii?Q?0VQMmLiHyOITKFCCrsUv/eM/Ur2oUWYExaWcE9emeEoGh3aI1deeKQUoNqdj?=
 =?us-ascii?Q?aGv1/z5pJCYCn44U5je6wgYjRl69/8pl+BVWw0pQ4BaYx6Hvoxqh4SAuGPAl?=
 =?us-ascii?Q?bLypk9eG4caGc+F+XJ2mWOtXP0VL0nFaXoLU33k1vxvkEdzyhou3AsLY0PZN?=
 =?us-ascii?Q?x2gIott08ar4YT+IA7Hn3Akw4mxwP128AfebBV6hPhoPOUrDNU/yY2KeiHy+?=
 =?us-ascii?Q?UvvImH1lZdc4I32YkxZKdqPFqRyB1Q0ioiD0VZhIITgcfOcNdBJoe5qGZFJS?=
 =?us-ascii?Q?1TvRRTvwJBCrHoeqJX52DuET7hjvBOEIwefgFvo6qHrY7G7X+X1e1kjUFoOQ?=
 =?us-ascii?Q?nD60IWJvq45dyGZWRT/ueWE5vr/Rfmqjyt1DyITHoPqds+cvbaL5OdvrXotm?=
 =?us-ascii?Q?FuVjHNJhbFRzcP6/W2D6WMj7jOLZdF2q7MG6XnTE+A+zrS13SsF0dTWKt/P4?=
 =?us-ascii?Q?jU7cSeattJPD2kjqcwkc3nXUMyiJ325Ap4UYiCpoZyGhVGYplY36XjLlju9E?=
 =?us-ascii?Q?Ui5bccRtbiLxEsHOkd59guGLJVV/DkTl3Mk3z5UzoLblpCcgPSZWyztm+4XX?=
 =?us-ascii?Q?/LdGhbpdRz0RN/viTllxonyx+Aq9FZo7YEzQxgcsYKvyDFRUTHFYUxiKu2A+?=
 =?us-ascii?Q?/DRx/1vb7YbAI7UGhX7/YqUpEZmD1ft2J8ZchEMhxjfTu1goBEJI52Lq/Iuq?=
 =?us-ascii?Q?WBP+o0kP8eCxe1gbu8br7OMIGcMwvy0fwsHqvIvJnN9X6vhrBraFgFF2zFdm?=
 =?us-ascii?Q?KeXcqPQhR4XNRrtGWR0ZRrOiX6EhOmEJVuRs1o12CtLtqR8N+OQ1oaM5qKSR?=
 =?us-ascii?Q?+x6+yFmvCr6nBLNLgnR72sXFi5wjyAC/YEUgX6tOx0gro7miAeKy2wQM+NY8?=
 =?us-ascii?Q?RlEX0Y/KsNXDpuwPVYanCis2ceAXsM5buxJF8xf3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33be1d26-5ff0-4e89-1af6-08db4103047e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 18:22:22.0314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fluSD1AeNCoBZn11TE24wuh7YE3MXxmbTxTSasySLIG36yGCa2XhtAoSii41Mgfa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6570
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

On Wed, Apr 19, 2023 at 07:18:26PM +0100, Lorenzo Stoakes wrote:

> I'd also argue that we are doing things right with this patch series as-is,
> io_uring is the only sticking point because, believe it or not, it is the
> only place in the kernel that uses multiple vmas (it has been interesting
> to get a view on GUP use as a whole here).

I would say io_uring is the only place trying to open-code bug fixes
for MM problems :\ As Jens says, these sorts of temporary work arounds become
lingering problems that nobody wants to fix properly.

> So even if I did the FOLL_ALLOW_BROKEN_FILE_MAPPING patch series first, I
> would still need to come along and delete a bunch of your code
> afterwards. And unfortunately Pavel's recent change which insists on not
> having different vm_file's across VMAs for the buffer would have to be
> reverted so I expect it might not be entirely without discussion.

Yeah, that should just be reverted.

> However, if you really do feel that you can't accept this change as-is, I
> can put this series on hold and look at FOLL_ALLOW_BROKEN_FILE_MAPPING and
> we can return to this afterwards.

It is probably not as bad as you think, I suspect only RDMA really
wants to set the flag. Maybe something in media too, maybe.

Then again that stuff doesn't work so incredibly badly maybe there
really is no user of it and we should just block it completely.

Jason
