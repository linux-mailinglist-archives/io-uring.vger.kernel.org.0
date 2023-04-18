Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B60B6E6BF5
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 20:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjDRSTq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 14:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjDRSTp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 14:19:45 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC2DA275;
        Tue, 18 Apr 2023 11:19:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lor0i7ImnS4+Ek6Xzju++M8EvFCd+pk+w5DWcsC0KUe+sBp/ddXWnB3QgBr/CGGTYuPvQpQRAdFJXfN10Hek8eoUKZO1gV2g3VlGsC2uMnJXbdOXKYmPsTbsEj0n+x0qlkl/AUrvp0EcPQJHmJYbxNJ+Z3W8bNOZGpXN2ZJyR/KcIREylGVjKfIRQIrvI2pAtUw8/fyuzEeBfTP2lIw/BwEaBqq5HEmjbAKDer4Yvm3ArEJR8t8dHzQv/L64Qe3W5SSbTfYPLLQseivLmC2yvg1SsnDjy7HI/dqJE80Z2/+lWKOn03geIhNyu+7bNIGsA5G2iaP5R8lO962x0ZKmeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CvqByypyVghRcI3Q2F4RqA4mNUFUBVQn9jHqXyOjJDs=;
 b=ERW6OjCbH799uuDE+mB7eca+09GLOmsPmAj6+IB7IZ8r2kgV8iwvZDP8KVs7r53PHs0G5T2pkdn4hQt++DH7xJdPr6uD1FIGyexxoPB4V9vVyEPeJQrV9dax+PCBmAegYYPuj9zDzas1xxW5HedvmsGHF1B8OwkvsHSGE7AlRvobCKuEaHcVYxXr9d9nYf1Osbw/T9wzfjomTrQqiWdNakLUg70bT7+z1O9COLxzM94fdJc37+NxG1VkSA4V6zCzOgrYj1qYcPiTJZ8L5WRjXy8VDb9zTrVvAr4jH9qP4PqZmRY+BY5qDYVqsfSJ04CDDdvpU/1xdB3nKN51sDFw5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvqByypyVghRcI3Q2F4RqA4mNUFUBVQn9jHqXyOjJDs=;
 b=Mo0RJzt9T0o9hBrSJmzACPG0HeJ8HkHtdzp83Q1Qkky3JrzpPB3/lctvdpdb+EGrKyE6uMXF/Jnoij7GDQcD0Zy7+Rk2yi6ixMy31HfKsb2pk3FQlw1zCxHCllyYBy3chCT6snH0J6V4D4jrByH/UuzmmZf49e+XwoaAPGqF9rRhHAbUGOd2Q33nLqXEuKkasIG2KQ9+HXaaqx6dHGCgwHGGggDlPRGQ0wGpKKtCB2iIoDdpTc9KblWInq76742TsxYkJfskPK7LUM7ZrlyzCAy9rTpJKlgffRX/h3GcV1WvS+1tZFJbAPRm9CPeiMw0NdTHf64sQfmR6psp6q6tNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by CH2PR12MB4263.namprd12.prod.outlook.com (2603:10b6:610:a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 18:19:34 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::94b9:a372:438d:94a2]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::94b9:a372:438d:94a2%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 18:19:33 +0000
Date:   Tue, 18 Apr 2023 15:19:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH 5/7] io_uring: rsrc: use FOLL_SAME_FILE on
 pin_user_pages()
Message-ID: <ZD7fNMR9Tyjph/QS@nvidia.com>
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
 <c19b3651-624b-f60e-3e63-fe9fadc6981f@gmail.com>
 <ZD7HGbdBt1XqIDX/@nvidia.com>
 <61ded378-51a8-1dcb-b631-fda1903248a9@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61ded378-51a8-1dcb-b631-fda1903248a9@gmail.com>
X-ClientProxiedBy: MN2PR19CA0068.namprd19.prod.outlook.com
 (2603:10b6:208:19b::45) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|CH2PR12MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: 218b4217-573f-40f1-5f1e-08db403975cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HSiZZq1IvOLESz00YY9RLEGOIHaSg8mM6pbM5LAIfqyEivTOFPq+kgtcELYOXWkBiruc6ymJcBFfPrhLJx0Z7Zru1Ccw0t4teLUnCdyzpaeWvOrDiLlJtPIXUb1HMwdtunGrUFh2Y8UJJ469avD251B4QA7KWZA5DSjPhiphzpd4swJP4iDnCU0iT3BSlPk2ktgxEpnAPO0+mVueuZB/6UYeYSk7MIfnSBhU+WCg4iroDcetLamR/fKnIE/PhvPz0p09nCOXELtrV0EvRSgT3XqlkrCXem/G8DTrF6i0XSt5F5Ssthdex8FMdR/sUND4OfV8FC7rhHpnPMpEGmvvdjTpxXdv2c9tGSNSOBTT3QtDLQGl55qXsoJiHCHuqMTx/S1GWTcM62naMcAZ6imrOfyd/YHIym/ToZl2/hM/bWDb5r4o+BV8ZS+mKlnxsMsmAg8inZ/56cgnuPxSMIsmwxcqhQTcdoLIXJSU+/t2WffI6SbBZeNiwoTWJDz0frCFXHDQ+8ZgwIi+oTdlW+vhWyqzqNhYF6xMX4eKQiDgDvB8ANLEiDpZfzWwuUJDaawR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199021)(2616005)(53546011)(54906003)(6512007)(26005)(6506007)(478600001)(66946007)(66556008)(66476007)(316002)(6486002)(186003)(6916009)(4326008)(8936002)(8676002)(41300700001)(2906002)(5660300002)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8mczCMQ3POpfcZXv1SZyNMcl/E3k4ReZcslLPtGUQ1mVRhuLVuGIzmggkp4/?=
 =?us-ascii?Q?GjpGdPBiuKrirPKPVKpo3KsycEYyecBmpVl+D0Z3oIRJfBbCKVQLHZb4bSsi?=
 =?us-ascii?Q?92GvSXzsuo7MZqWM7h1uHD46dt4XhyPGaNu51V3hyYwo+0vF/IyV/75Joy5B?=
 =?us-ascii?Q?q2eLUgNCNZmND61KyZklGxxmukuPpr2JZQdp+aD0vk/6Q/TZRjSskS+Sdw+R?=
 =?us-ascii?Q?drfHTWW5LHwGXmsQMKf/zaJskxOVwImtJZz1F52qUV0rMGxnnA0kSeI4jx1u?=
 =?us-ascii?Q?tWBWGGhZCgLOcEkKahB08AfT51AU2z51FQuErMrRG7ck89G+IUsPbRrOBw3C?=
 =?us-ascii?Q?utC5OeFZRtUtZEW4YpwzLMkabhpaA98oXJ0Dg3M7h5SvRKlimOPmaCTCLCQ/?=
 =?us-ascii?Q?DSAdKSzXfZew+2VMjJZiq0hDTLUmbyZi4PINrMeQiBCfNemGkp5p7hDI0WAe?=
 =?us-ascii?Q?+ZK951LehnVRnHatmiWwLGtCLb2FJ2DABe7Dd0ek5WI6gOOUy5+/2n7rx73s?=
 =?us-ascii?Q?MreonZEKByc4iAPaaugvefBv1b97juUK7svqW/psk99KPPJ5jay4YSkE7h3A?=
 =?us-ascii?Q?2bsJFx6+8ukP6B1u+5Va/tiMVP/tL2PEKMf3aMstfW9Ft49RtO/kiZMg4NnP?=
 =?us-ascii?Q?uBE6qJu6vrA7MbRYZmHFO/5MaPbwkCMha690FZO4liaMOFP+l6C9XX9Vc1w6?=
 =?us-ascii?Q?LP7NDr4277+tkcVd7lVH4wJmHXiFeFZkZzliGC1mhUsBPOME0XqOPLJ+Fbe+?=
 =?us-ascii?Q?yxOBr7t3jGwdK4ywE3mWWJPPg1J0JlP7Paxn3dx965WMtffOKgd6xkuq7g3K?=
 =?us-ascii?Q?/hmgmifmbm07kSDvLQ+uSZJV/gjVUaWv4NbENtBxXx30BGCnsqMH+wp0+J+g?=
 =?us-ascii?Q?sAQm+c5meHVhZ/4uAnVr4o8HCdV72DUjrrammtHzkQ9HkoPd6fGIdx0fzCTq?=
 =?us-ascii?Q?1SoqJO01XZ18IERuaa9tM0l6XV4RMiApcBz8vFw2b/RzSLBopCOArKEIkX/O?=
 =?us-ascii?Q?vzgTYutCt9ibd+jmS3SwdBguNO5Sh/mqT5F840ij/bvEzABxi1+g1GlxxZJv?=
 =?us-ascii?Q?YJRKtUc/t+qnBlvXuBG1sPwpSz13jd8qFo5FDWoiO0gGl6ZTPHx9/E5/ZjqB?=
 =?us-ascii?Q?LMjyBiMM6hAlskFDeG+C4XBQg9cHRqEAdd+KqgCGZddaUU9LtHz6tKpQV5H9?=
 =?us-ascii?Q?6in3FOjpwqC1jvuXMyvhqqOZYrd2E2qKdtqVCzp32INOyoL3CpecVRR4Uw81?=
 =?us-ascii?Q?YuI+k6PIFXPknWcaXyAOvZrYyu/scNwP3h5GVDUUqivEupuBEbPyw+Z4xTJu?=
 =?us-ascii?Q?VlDa1HLBI9HY0acn5cyHtvaoUfTM/s8EUrolngyqfCK2qy/fPj2pAZzRIKVS?=
 =?us-ascii?Q?uCQR/1UBh6fLQLn5lYGg0X37BRLpXNxxF99DmXlMlZr+AW9WK1FAQ6JCDMVf?=
 =?us-ascii?Q?gGBpVooumpWS7B+nmne6OwNA2Px9w+K8eUZEn3y2vBjwGCnj9sPs5k4U67xh?=
 =?us-ascii?Q?4pl2yH0dU3KzPgHZl9SzbKpBJUhs9Zy5g0R0T2w6jYrFC+iOin++jxMD0ZPp?=
 =?us-ascii?Q?FcAThAvDMJiTnhZ98vKwidxlP+RnlwVjbxF8czeP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 218b4217-573f-40f1-5f1e-08db403975cd
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 18:19:33.8451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zxjNrSMfPeiVVbj8S7TfUa/sB/Nu2/sS25+x8ztod+IBVpe49NtHjqXGJjpxE14M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4263
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

On Tue, Apr 18, 2023 at 06:25:24PM +0100, Pavel Begunkov wrote:
> On 4/18/23 17:36, Jason Gunthorpe wrote:
> > On Tue, Apr 18, 2023 at 05:25:08PM +0100, Pavel Begunkov wrote:
> > > On 4/17/23 13:56, Jason Gunthorpe wrote:
> > > > On Sat, Apr 15, 2023 at 12:27:45AM +0100, Lorenzo Stoakes wrote:
> > > > > Commit edd478269640 ("io_uring/rsrc: disallow multi-source reg buffers")
> > > > > prevents io_pin_pages() from pinning pages spanning multiple VMAs with
> > > > > permitted characteristics (anon/huge), requiring that all VMAs share the
> > > > > same vm_file.
> > > > 
> > > > That commmit doesn't really explain why io_uring is doing such a weird
> > > > thing.
> > > > 
> > > > What exactly is the problem with mixing struct pages from different
> > > > files and why of all the GUP users does only io_uring need to care
> > > > about this?
> > > 
> > > Simply because it doesn't seem sane to mix and register buffers of
> > > different "nature" as one.
> > 
> > That is not a good reason. Once things are converted to struct pages
> > they don't need to care about their "nature"
> 
> Arguing purely about uapi, I do think it is. Even though it can be
> passed down and a page is a page, Frankenstein's Monster mixing anon
> pages, pages for io_uring queues, device shared memory, and what not
> else doesn't seem right for uapi. I see keeping buffers as a single
> entity in opposite to a set of random pages beneficial for the future.

Again, it is not up to io_uring to make this choice. We have GUP as
part of our uAPI all over the place, GUP decides how it works, not
random different ideas all over the place.

We don't have these kinds of restrictions for O_DIRECT, for instance.

There should be consistency in the uAPI across everything.

Jason
