Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F129680EAE
	for <lists+io-uring@lfdr.de>; Mon, 30 Jan 2023 14:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbjA3NVk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Jan 2023 08:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjA3NVj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Jan 2023 08:21:39 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39372C644;
        Mon, 30 Jan 2023 05:21:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbM8wp9qExs+XdwF5Ws8ECIxrtEfPB30/xpZzzhxqDr63jvCMCqzqI8nwx3jRjl+jJqvYG9nO3x0h/WTX/wDMU+9EfA1QSab+f6jc/PkpEnHR2mf3PLMrfvVpRUyJnT9Qq7Hup6eQ5lxdBDv31ReNGJbhuD5CPOm4Hm9xE6DY64op1DDA9u1LAYBcej9zEPZ56ufSSbcjpj9m7xDq9/FXUsqGmen2EQp/wdP9s0yxZ6PgUkztk69GwKiWzUl0Vw7mMpibXhwhkqiusLV3engCkvq2BDBKYHHkULxSKyS+tzQv5KJqjTRRvN6SGM0rlQ2dPl1aPd15nKgxihT/TQBoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g47Ib/RumelIOz6micA8aQgCRRk/pRAB+0AK/E6UWPc=;
 b=dUxGbrcLrIRPjEGzHRunD5P9pDE2HA/0nH8CS5KDJ/esz/9LGCT3vV2gXQx2KSv8bwHUMrbOVoVPYEboP2YU4l/ReWRwkYufchgFzZHksKi0Iq17Hf6VIgfk/x0Xko1HSX3lSEHz6khJ9yS0dSvWkzqdqCJGL2oDHZ9nuhT9nk9S/T3qdQh6ypfVMm1R1pNITQQI2tCYnGEjpRk3T7nCtjlNZ6bqHl4ZZDZVpaJQ5vwBTl7km3qkZNbKS3cgCulXGAlqx0fIAdL4av0fTBmzTrJ4UCghku3+XXgztr0Bqc8SOaoWHSji/nQka00xCrOoLqrILCGv+3WryTPV9Cj5yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g47Ib/RumelIOz6micA8aQgCRRk/pRAB+0AK/E6UWPc=;
 b=KtZSDy1cP3jyUWeP7cVvaaiJZI+LrpOVBljPMUCErnA5pZiutoniN/OxF1wuYrBJpQ0/s+qtQtZR9724CwuXEj0PHXIeZB6+n21RDtwrtCRPhr6V4Ez2hFy3t0w9uk24GROPhLAoQavu/d39C7VSvt19L0KLobZ6r//StX5gCo4dJdyVrqsTq15GmeT0NaMEQGHscfNRrSO/aD9Kq2BJ1aUGYsiSkH2L7vz/8Mk0wC0TV22+QwGCL5D2vd1zhM1Qo5EArNwQpYwo/7ETws1ZbdtoXehiqb94r7n+OOkR5x4HeBZusoWeK7w3a/iBjgYMpXtDshZYD3/V9UrA8e3EVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL0PR12MB4963.namprd12.prod.outlook.com (2603:10b6:208:17d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 13:21:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.033; Mon, 30 Jan 2023
 13:21:37 +0000
Date:   Mon, 30 Jan 2023 09:21:36 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 09/19] io_uring: convert to use vm_account
Message-ID: <Y9fEYNQOV0+iDvWJ@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9f63cf4ab74d6e56e434c1c3d7c98352bb282895.1674538665.git-series.apopple@nvidia.com>
 <Y8/uyBKHf5XoXvTW@nvidia.com>
 <87tu08z2zv.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tu08z2zv.fsf@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:208:32a::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL0PR12MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: af293ff9-296c-4220-4b0c-08db02c4ea70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: izAjevqxzwNngM93+cbE2jogLPWHy3y/RW3sxg6YzvsokHOMjRL4IDtxlbYkUG2so/eZem0v3sOnyC2mL+hWVXHhZHKMJnW2KV64mEDbJLtjKZiL1BxosN+AnM615kXKHv9j4RPXrsofc3dXdcl1g2IDIJwGP2S+yVJzky/pSjjEqhvCsN+l6YaYToWJCZBHGC7fByUTKgQ2Wsh2ok5DVNoKppk4BDddNpm+ywpsUK5xsCT5yjFdVwpig+CJPyv/wmGsV3ro+TyzSZzJHXgkxkpMKmL5YDAOx4i5Gem8z+Pdh7YHeSIH2Vy01A4/oaw9lVaRnduYLQV9yGF37Yuh+Rbn4nNd6rCcu/ykf/ac6xScctUJAdPftDYR2DCYVQOyYnQDZOuL52RqJZYBUEjcVa9aIonEH41peGipKYpnRQU8dq34sASILeygbsawmOBdqeYNsBXuiOuTi7NPNMluCCqWkZ3PjEAMpTXuf75V18XmHXGpb0l1pu8gMSckNrgQxP7cYJSTA9E16QcjMtOvLMMYLT00mdmZEOXRV/Md8rOjxNpFYSc+KpzfuDVcfvTrs2wgwofBwkDmPVzJbpFyB5inec8Qdy9GFN23WKysNaRX0WVypxUKvAq7bRriP83Apmuq5Z0bfxhTws8MtHrdKsaquVfprx6SGj7IS8vH9SP+L2RXA6LuunPeOmJbjA5a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(39850400004)(136003)(396003)(451199018)(8936002)(41300700001)(4326008)(66946007)(2616005)(66556008)(66476007)(8676002)(7416002)(5660300002)(4744005)(83380400001)(6862004)(6506007)(6486002)(478600001)(37006003)(54906003)(316002)(26005)(6512007)(6636002)(186003)(38100700002)(36756003)(86362001)(2906002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H6dka3DOLzWRGXONRuFOc3k/GdVdkidsrpQdpgJUYZAxU23A4Khu2eW+c6eT?=
 =?us-ascii?Q?pswXVLkZBxVMv8ks9Gaok0papY7eoIY6v75eck/YT20hiwwsASRZYnt66WtP?=
 =?us-ascii?Q?wbGfmFNw1mq9y3NLC5vE4+ag+/uli3bE4fEEyvmpd3c8CUmeG7GBTgrGCMlx?=
 =?us-ascii?Q?izv2ETITbx9PbUy6AjQr93Ny/Iva8f1U3bnvhG6OkwiJLgpxgpPS/JlXkfc7?=
 =?us-ascii?Q?E0gvE4d00xmds2GAAAyUqG5Km0MHGnKYuHd/MkVhr/7ht2WT6/avZ98BKwH0?=
 =?us-ascii?Q?MhdC5dUke2H9JxVs34mOLXddYX6esNsiIl0LGEU780u5NzpuvIItGh6nX5J1?=
 =?us-ascii?Q?jFAB6RXUgmxvKFZNWnbDT7y4LHa+72l3dGATR5HMAndt+I5104dw29/Y1zso?=
 =?us-ascii?Q?hZIIywgmTH7mVtpwGOKsiVaRzMdE+RSby2ZkG+5juG6ucdvmZvhV3u8oxrkr?=
 =?us-ascii?Q?ngElQ8rh/M8g3wqm/sagvETG6/mq7AfU4hKJuM6iGWoh/AYdobVsMG5KaqMw?=
 =?us-ascii?Q?1/0PHrdmSCfju4IbHWPuECYZToN5E13pP8PlGmknx/yHqbw31E/Zf+FajHW1?=
 =?us-ascii?Q?dEjBucM+AsGpElv3z9MxoGakRDdSN8vGsOd6trojK10n9k0w3MKUzsw+lnpZ?=
 =?us-ascii?Q?/7cgITO5eQC6p7PWUGqTM3sQpnNzwzzsqkGIyt3MnkgR0L99b2IvNSH7H1Yv?=
 =?us-ascii?Q?MfKBzqla8a8g0JnW+6xY3KmvHys8o3FnMqW5iijeCPUBvJC+lezlUAV9M8Rv?=
 =?us-ascii?Q?BIi3R57Pc6hRpFo/Ulde3L3E/omahz7UYvr5yEJ0VA2ZTXHVRjLdfCJ/OFS4?=
 =?us-ascii?Q?iE3fEPpylO8CIoupjLUxifuKcT1lBHzhMfMwARaoPhohEblPKGZr4yS96Mlx?=
 =?us-ascii?Q?VhXNIXUCP1rUyqfbwiKTZOBTe5U8HlCEbYJk4EMxHqJMhveBKx9DCtbT9Elc?=
 =?us-ascii?Q?5Oa7OMkdYinQhHgXhYTj0IuW8/0YgtXBhkHKPACQ7q21dWnNZoKHlhFxTBsu?=
 =?us-ascii?Q?mfuVhdaeHdb7vLSXgBCw/BSGQiy+O64jHmwUtynkLk9IoCO74vBrLiXAeBX5?=
 =?us-ascii?Q?YXtk/3Dgyy+MwvVU9dUz6okqC2NQB3SW53oVX0MPo4Myt99fwmWHnTdkyIhv?=
 =?us-ascii?Q?dCDiZBhaRNLyjLomWfMSSdmIaV97OY2jYgvQ+q1nnmaWLKRsp/B2oYDU+B9b?=
 =?us-ascii?Q?pD8O1UEAvNebvLWj01jWg6UA8Rrv1MR+rBgPEW/oH82HNqWeMs9QbxUAKhOd?=
 =?us-ascii?Q?gOfKrwR2ESGs/Jedsx9AxfkU09nseBhCjDIKpiuufFVJeTkBpVwAnsSy5NBe?=
 =?us-ascii?Q?/AIVetr/xKl8G3CGLGPNrfB4QS8ch/sjZ0ksewHoQom4gDWV1F/AFxh11sOX?=
 =?us-ascii?Q?0tTLCXxGYSzVgZgjMWQKiKyYlPKt+YKvlv+GZvLv8KZLCmqp/+v/FXtLXZGE?=
 =?us-ascii?Q?rhdnlUcpD8n6SbTR7D7pHbDdFYoIJV9nLaquxh6KPjtDr3PkD5c2PFZPq4UV?=
 =?us-ascii?Q?UtXirwsDNPIGshj5dMQpCcdrlDTj/RbOVsyPh5F+iJG7zFHLGvoNfuAb/moO?=
 =?us-ascii?Q?CsoiyFfz7C7xvT2PmKODnbk7p6goXqGNh6ip7D1N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af293ff9-296c-4220-4b0c-08db02c4ea70
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 13:21:37.4380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8TIE2q8pBpV3Ggh7EBoCbEhn2gdoSwRoL/PT9uhHSiC2kudUyw5RuI9wnvGd35Rz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4963
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 30, 2023 at 10:12:43PM +1100, Alistair Popple wrote:
> 
> Jason Gunthorpe <jgg@nvidia.com> writes:
> 
> > On Tue, Jan 24, 2023 at 04:42:38PM +1100, Alistair Popple wrote:
> >> Convert io_uring to use vm_account instead of directly charging pages
> >> against the user/mm. Rather than charge pages to both user->locked_vm
> >> and mm->pinned_vm this will only charge pages to user->locked_vm.
> >
> > I think this is a mistake in the first patch, the pinned_vm should
> > still increment (but not checked against the rlimit), though its main
> > purpose in this mode is for debugging in proc.
> 
> Sorry, didn't quite follow - are you saying we should always increment
> mm->pinned_vm and only use VM_ACCOUNT_USER vs. TASK to select which one
> the rlimit is enforced against?

yes pinned_vm was created primarily a debugging counter in proc

Jason
