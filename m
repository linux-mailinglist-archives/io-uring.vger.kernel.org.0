Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424426E9852
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 17:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbjDTPbs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 11:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjDTPbr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 11:31:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5D93AB7;
        Thu, 20 Apr 2023 08:31:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqswfMgzMrrMwCT53P+md7VFwEXUUnYT6kTFIEXsBe/qjyIzwN3IffMC/W3wLkVhUC8U1sl1URwCJ76JHx8lIV9zrD8O/GnhtyrMJ7gw7ozyRAYAMwX53051G/ES6NUK+xnHRfO3Oiws56VnjeS8+3HyxMQhdMnkzZevcPB9y9++7ZM2iF7pRDhcEY/uC1eKgyganWsDipspqliBm9Zbk7pIjY/YJ54YgTbGuX0749uA4RABpCxkvGwJtzWIlYjT90q1XGjOHIdnr5YaEtiTLCA/9y2sXHDaSXafMFYGEBesdmGLufDxQqJvNGsNcQSb3LU5J/lEIykjWErb/YViiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFmFmXDSNUDIvOPhXNJOhfchTiMzDuOUILdEl/4PzS4=;
 b=jUzaa7E3ZkYznCAX0FyjS0nm1sPYLI1Vw/YyAnl3kM9/whCyEHLayVcGKwhyeZRwox2hkLlIKWR3tgvGtys+d7oOd7VRsJ8EjlQjwpOJ6kyXZOqldmi7xQKWnaM7dxcWCH0nH+s1Hs2J66OcjJmbgfS2bwPyZCO4w0dnOhLSbJsirFYJDIvtdN7/E7A9QoWH8K9fElqTpDjpl6WJj1HEVTpNGMchldSXT8cl5nUi5lNNTWfU/uXcUW1gL4/Zf8vTk5TWyecWt6jELizqlXcA0z14s31wJ+SsXAfX6CeSWXOkpJmEgwuUSg9yZfMp4S6Q9DnznlgKsD8k5qj3husMBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFmFmXDSNUDIvOPhXNJOhfchTiMzDuOUILdEl/4PzS4=;
 b=HDet5De8Ub1LllyOEwHM3A+9JC8Ns2qQ2wsM6oYBNqHlrMX728+SSEjl2/PG9mZ3GgvDbS9pAoWapczVTkHNbU4OpUDysGwwBG2ibwxASNGjwT29L2wU7Z7s7pGslgnL3+Z9xW4STOwmSbXJE4l8jQgyRl8lnzlXFGb/f4eZpqxKfud5RfWT1t0EIYEoMqCAF1WYKoJGDMLhDw3eusLU1myYGojTW+Z9OG4jFe5QqgQZRklKgjwQZVKnkLxhZwyiGZ+i6W/FN4+7I6p8yGmjeuZVC58rbl1S92Z2r0WIRESmyv5S/YwTNC10rNYCw0zKJEcdSK8p/XCV0lpZUaU9lQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5219.namprd12.prod.outlook.com (2603:10b6:610:d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 15:31:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Thu, 20 Apr 2023
 15:31:42 +0000
Date:   Thu, 20 Apr 2023 12:31:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <ZEFa3YO+0/HZ3Hz/@nvidia.com>
References: <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
 <ZEAxhHx/4Ql6AMt2@casper.infradead.org>
 <ZEAx90C2lDMJIux1@nvidia.com>
 <ZEA0dbV+qIBSD0mG@casper.infradead.org>
 <c94afa59-e1b9-d7b0-a83e-6c722324e7ef@gmail.com>
 <5e4a23f1-c99e-45d6-8402-6c2df8fa06e0@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e4a23f1-c99e-45d6-8402-6c2df8fa06e0@lucifer.local>
X-ClientProxiedBy: BLAPR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:208:335::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5219:EE_
X-MS-Office365-Filtering-Correlation-Id: 18638c1e-e81b-4326-9917-08db41b457d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M8Z2wBTqiLT+h/wGfIFH4MaZ9nUxBcmAvIMli+WbjWVQP2b8+DDT6pYREJz68JGKLq7jdeSm5sgQEBY/mCiUamXjyFOgZbznYB2LmYeCFVzR7LTWKPxl9Hin2C3Rkmcgg7Afi66QHdKQ6SlpRg+k+H2U6fbTY0ktnHmf5qPI8QKhza/UiiYUz58/+iZkNazZjz06UywKQr85t90+TtBICaDEoTJmVq3T30tydC1QMWs35QUUAqLkY10QVUvXJuy7GtYIt+ogdcrZENTps3awrWaqhdQwgvUFrGGZw9AxUrtNNvThA0Xy1MDDs9ww2CjLBlyOE4i+f8DQTOYpMcBPKQp8M0a15/CnnMECVnBJjJF20wYpld9oPZdbOkIJwf8kwO7wkDt0DKbS9Joey175SMPfJkajI1byO6BQMN/L+2WJvLiDBLwE3JBlrlArv5scDDFVP+eFtuoOGir+KKXQ0s7qoxyNkcuuPsTZBLkDVDSlbuzZaXSramXFDDUW90j0fHHDsVUAuf4pvA4rFPK5cmUMtIoFmd8b4ehkuXgEueFFYlDoYvEaY2eOVPHnfvKQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(451199021)(2616005)(316002)(66946007)(6916009)(4326008)(66556008)(6486002)(478600001)(54906003)(8676002)(41300700001)(8936002)(38100700002)(66476007)(4744005)(2906002)(5660300002)(26005)(6506007)(6512007)(186003)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TSBso2i9mvH6W6WoQroNaNG2bfiujQtgWBpQujKSEpxl3EUPfkXgTBbr116p?=
 =?us-ascii?Q?AEZ1pOSh1v5lwfbtBTVWYwnNhMqB52ZMppZ7kXUTEBIG7Wjx6JdGFhITjOVS?=
 =?us-ascii?Q?J1b09WZmNWygtdIn+rH8Gb9kd+KkpZuQ2jzf9Xil23eF7cmI9uJNEw6vDjNH?=
 =?us-ascii?Q?rj5gU4oDjKvi5jqFW/FZZqhqteS3hsXL5D5wbAbMbkx/EbkcseMG08gBALwc?=
 =?us-ascii?Q?DrGxPIIAB55/l5J20Kc230biuS6mTucDbjMKs/fAP+SUToJYf+Hp860ywggx?=
 =?us-ascii?Q?ivEjP8W5NnxB3bRGcJ23rwMaC1r4CiG67FBL9NkgoF08IIU95YNsxjYanN6U?=
 =?us-ascii?Q?0mJtAy7y79Xl9ECg7RolsrijZqYqqjPIsXzG4rgXIpLVNj41J1hlrAsa9QxM?=
 =?us-ascii?Q?n59ybM7eBpfdIEwJdtjjwLhzyjDmWf4qkf4LbGytukVYGxV0Xv750rvZrmdI?=
 =?us-ascii?Q?IUOoT6HAl43NnWBcRkXME3/VgOEGpYmQH7SUaFVubg7KRMFLSIq/5WFpGjvo?=
 =?us-ascii?Q?KQpGF9yzZiVrCxWiSdpKVos0nOxQZGt1Zy+wS46kp+SE1WMsvuYaF8Ccb4LM?=
 =?us-ascii?Q?f5aB3UGlInA2eyN9tXD7ZYT0LsjVqQvVi26oRLmQPwoSDC8eGyJwpKY7SiKJ?=
 =?us-ascii?Q?tvEcUCxCyNmb2gf2gPVoWXC+wWx6/jWt7SJHmpTAYFhu7huuBlkFPUpDS0K8?=
 =?us-ascii?Q?11MXoE2SpDe3yrrdRwKPax9kjaGdrY7m9j6ecQfO5KhIqPnCAVtcdeI0O5PS?=
 =?us-ascii?Q?ZP4mxBoJtl5HPbq4fBmNZdIY5kCg7wrGt23hqpJpXBNI6aP2+41l9N39MK8p?=
 =?us-ascii?Q?Vj7dWKVavelOL95h+WEAFGi40M6X7MMgTov2ZO1G6Khr/qY4r/YRouZw4jUt?=
 =?us-ascii?Q?1H5KKAJfHa+Z6BdWHH5efVKjHfQXj+B2ElXXM4bSpFOgHNNMHK9IuJYmZUlC?=
 =?us-ascii?Q?nsTdEBzRY4VbNyDEdZ5l5NTjuuwFa9kRtplh55YIRQ1z/TTD7uPfHbdMD3CG?=
 =?us-ascii?Q?SIQYnI0Wvxbv0I5Jszsb1CVhMc8NYH/U7ijLoeFilHKA5pCjLwuOAvB3d6ib?=
 =?us-ascii?Q?xQrcAeWy99rLjRpjsh0meDoIyt/ylAAYz2W1QLmdi9mcv+IH6oYJ8xPg88Oi?=
 =?us-ascii?Q?JpCOxq+4E+RifNb0jp6xbxH1PYuTwdMQr84yNlEvqq6Nkk6V9ykI+rb9ZZ2o?=
 =?us-ascii?Q?g2YKJi460D/e2sz5EdVyshjUuuwv40MFmoaLF3nnP5T6LMwp2JlZCcG0K+vM?=
 =?us-ascii?Q?F2l4RmVESkDfsKFc2FuJ1jFb2+Rzy6/zSyrocwKUJCN9ULmxwH/PNvtx/7VV?=
 =?us-ascii?Q?HuyS9uZdkzIZ2OZ2UEOXhPXGhB59Jpr022aa1Gf5WOV4xz2VfZT3qsV6icGe?=
 =?us-ascii?Q?jcl+cAgY+DRdBn3e/diLfakt2ANk3SH/v9Pfgsrloq+rhO2hahrWg0oqeUqQ?=
 =?us-ascii?Q?Gm6scLL8GRdr4h92d3QAgcD2UtwJGwmPbh/VfPFBfj9GQeSykF+eZPrx/OF4?=
 =?us-ascii?Q?ty0dORa3wh4DffVvyaJVkbvXKh+obDe8VcG5M9iV1eG786j6XBk6MLnWz7wT?=
 =?us-ascii?Q?yVf4baIykXefCmnSWnvXgIOWZO6h7DiUtwYwSttD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18638c1e-e81b-4326-9917-08db41b457d0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 15:31:42.7773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x9217FtAGwNl6BmOulaIkJSFbdPbQH/BByTSsR+YLvoTPvk47GQ4yvuSLRqI9jOy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5219
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 20, 2023 at 03:19:01PM +0100, Lorenzo Stoakes wrote:

> So I guess the question is, do you feel the requirement for vm_file being
> the same should apply across _any_ GUP operation over a range or is it
> io_uring-specific?

No need at all anywhere.

GUP's API contract is you get a jumble of pages with certain
properties. Ie normal GUP gives you a jumble of CPU cache coherent
struct pages.

The job of the GUP caller is to process this jumble.

There is no architectural reason to restrict it beyond that, and
io_uring has no functional need either.

The caller of GUP is, by design, not supposed to know about files, or
VMAs, or other MM details. GUP's purpose is to abstract that.

I would not object if io_uring demanded that all struct pages be in a
certain way, like all are P2P or something. But that is a *struct
page* based test, not a VMA test.

Checking VMAs is basically io_uring saying it knows better than GUP
and better than the MM on how this abstraction should work.

Jason
