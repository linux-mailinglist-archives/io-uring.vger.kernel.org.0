Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B504680BB7
	for <lists+io-uring@lfdr.de>; Mon, 30 Jan 2023 12:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbjA3LQq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Jan 2023 06:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjA3LQp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Jan 2023 06:16:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690782124;
        Mon, 30 Jan 2023 03:16:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHDuj/KsuNOHGcGFIVRS32u6Eaxskm7p5u5P9HJx8oEZeoxIWkHjdcPIB1iWCLysQv2kHpYaJBvCfRU6nB0JpJPWfo995HqzgyjJPoktXn4AaTBHWzAgsVWl4p+ga/uDMt0E32zmnlKEihl74xL9W/qWFrE9/VjP6Cef7Sy07pbvQ26kjyEaBoVx53oVEq/d0p/yQRk0lEdkysQ2L9Enbm5uDa9ZxChaCwP0cNGUuwDy478+lRo0fVpgembYf025+KnPLlPn6FPVNWBmfRP6O05FQ8p/y+AdeVDvmd5GYZMkeAj6vhWK9cPQVKpRtJjcipnVNpC9ViMCjR3delOqFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mL3G2lIOGx8nGb74swMZ/4CJHpsCfm93T1KicB/1V4o=;
 b=bzjQXg6pHvYEwLXSkMs8z3sjavT1QCfiOVheBsovgrM0RKt/4ykz3zt1m+Hq/IrFoiwSIS8Zo/29ID8vgGwt+x5heFYjWtakHgVY2wzCFtOei2jIGKZRoh9xqTrnOrpkZUoTsLbDF7i0dlxBwklGcA3n97CU6pfWJZy6y7F2K6ZeULC8BYThP9V/+xo1WCPzsp/QUYLDCQ6USHOGJRrH6+NqyH00L+MX3n0tlUSSgJiWMnH1JKNFNKcvjKkpj2xXNKYZJp1qizsEwLIZdyDiXx5h34zTrGDFk3EnTfbnA41v5FdLQSpCABzXuwHT+91A/qgh/ca34Y8rpuBZtbELcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mL3G2lIOGx8nGb74swMZ/4CJHpsCfm93T1KicB/1V4o=;
 b=MjHFPcOldZLkPFvGY7UQm5m9qLg/x5tohNAZ9ISF+QOzd5Me3f0DmSPYFGzXRIMokeOjvwwwFQ14niAkAqa0A5QeYEeYFMECIr0gQPlKTD+zVpO8vOUGrzW8Uy0AAgsqmPlaCY6giDLRdLKMtttIOI5wfs1rqZ5R7Ffy4y/2FCMhEI/fbwMzkPTPku2B6BHpMy0fRt5zRcOfWuEuI1hnDs/vZKfQOxuu+AZLfTPk55813ufjlsNAqElNpUCfcq2LKMmhse4mHb2ddPNBkv3JL7NqY3OzSzZYA0DO54sDvtg9r3HjrKNtWe2MkoM56pHAQYUNUmwkfXIa1sCYZDa4MQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 11:16:42 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e%4]) with mapi id 15.20.6043.023; Mon, 30 Jan 2023
 11:16:42 +0000
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9f63cf4ab74d6e56e434c1c3d7c98352bb282895.1674538665.git-series.apopple@nvidia.com>
 <Y8/uyBKHf5XoXvTW@nvidia.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 09/19] io_uring: convert to use vm_account
Date:   Mon, 30 Jan 2023 22:12:43 +1100
In-reply-to: <Y8/uyBKHf5XoXvTW@nvidia.com>
Message-ID: <87tu08z2zv.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SY2PR01CA0040.ausprd01.prod.outlook.com
 (2603:10c6:1:15::28) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|IA1PR12MB6163:EE_
X-MS-Office365-Filtering-Correlation-Id: 496a0f75-7a8a-45f0-64b6-08db02b37732
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 02QIn+tiRz32HQO9nIPe4be7X2fgoT+UHcofbIKJzvtFhKKMo59iP4iU9oTQivaaDgsZOSp2X009tfj7iGc6jIK103DWkPFhfL0479lnpRphXXVHMBb1u99sKcDOiW81puQ8p3Vvib3vUBrizM0MqwtSmoiwcln4nBMGnOM806lVD1iw6wdsExvOplYNWzCBvW3XNInu/s0Afq6/1JVwcw5SSLYMtJoHq2jO4mE1ppAogxjIElAhGU01QloHNK5wmQNcpWcm7u1LiycaTTUHy18n9JniId1dkMXmDc+0Xbkv4fUivBnhV3OunxDFKmn1v9DoFmv5c0pzaODIa8TZ5MUqZWX98oCl3Hw6Qucek5mn8f0K+MMgEbBL2YMwLKsxN/WcZZ4uT/aqDNHSpIY0a3vd7tFZDx2N93VTsdUGXaCMtR1NFl0q8As/TwlCvZ0sLUsnPYVUC97bhyf4vCvA8JDU+uemJ8tNogANLkpLd0Q2mxRVr8m/jx3GxOshjd7PYEDGEcTjSHfAE0gGS04ec6/d2S4W79NWe04/9AMN7pslGvbYfaMLQxXWUcN3gB/31oHCbGH4iuNRwWXCZqvw/lySxsiaw1HPb7P2MwkK6wc23DCB/LFRDqd1ZeBxwy/TE58thoUtWrsC0pyKrqGtSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199018)(8676002)(66476007)(66556008)(4326008)(41300700001)(66946007)(8936002)(83380400001)(6862004)(478600001)(86362001)(316002)(2906002)(38100700002)(6486002)(26005)(6636002)(37006003)(6506007)(5660300002)(4744005)(186003)(6512007)(54906003)(7416002)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/8FNXZju5a2DcNe9pZmmj34deE5G7oh1wWhlaNYDbi3C/VRbuqSrTzTi0qmM?=
 =?us-ascii?Q?9sHMwt/HKoUMGm/Xm46JgGcrtB9o3FparClFTzlYm0ENIuHg/Cjg1GqiT91L?=
 =?us-ascii?Q?6Qza0gza1MacpsN0ENxVBowVyfA694o9wajdcM+U7j9zktI5dYXihuRcv3RT?=
 =?us-ascii?Q?wPvKjhcNQpzSXIA2Z8p1P4W3ZeJ1ENdhiiGzs2kPl4pNnkdCFdnnSPD1auZT?=
 =?us-ascii?Q?1hR06FYukFVmznj7o1QzsLvSsuY+OXY3RgFRum7qWNutnG/wtuisOMgdj/+J?=
 =?us-ascii?Q?aoL4vSlauoPSWg++3APk3nGZp4LWs+q3OrfUojMBJHgHoJiGFzC36BFbYsMu?=
 =?us-ascii?Q?cIdLqg8desg/PG50E7NVX8BZbIEhOdYoPBnDyg5YO8TBhx6Nd4krcDi+6YC4?=
 =?us-ascii?Q?CY80eYcgYJJuikRlwNs1wHWArIpmI6XY+qF4da7XSZl6XF1asQu0Yzxi7c7R?=
 =?us-ascii?Q?WEtBlMdPYuohwQ+McCosYMrI/0cR5MGXPVxGJAOoOkec3+1UOH7l39utCc6m?=
 =?us-ascii?Q?1Fsffn8+FmCYgiOdJ8Jo+fJemEKIaZjEjEFoxqKNOsb7WoeyJd8qPS5g0Ffi?=
 =?us-ascii?Q?Q/JPJ3m1/XvhmWAPB0ywuDqbIKnN6hzEja2nVua81NamGNA+ixiF7cAnRa2W?=
 =?us-ascii?Q?d2V7qhIiAFaFpQTI9fudiE+dQUFakT8mA7BXJsRElhmnfWxOIfmjAZALwW6w?=
 =?us-ascii?Q?CFpgYTr7uC9tS6jSauSAu8Mk5r8H239fs0Q7sL1QU/Xb+6xWsZQWx+M+BQhF?=
 =?us-ascii?Q?Gimt8OUMWVuKVedZKjNLlAX7m/6h1hB2RBOCcqAZyRsrY1qsm5TZhcsZdL7G?=
 =?us-ascii?Q?M4j6qmKvfEGscqFA2Udvu20k3Lgfs1NOvBulqV9c7slxVmlwSOBAPUdlPmtf?=
 =?us-ascii?Q?HJXBKNc47/ONXfWL+nvvAT7Qb1CP8iFI+45GXHxJv6mK5GwdTKWTgQK1FJLB?=
 =?us-ascii?Q?tQ2XMwxOXaTRx3409KXWxB4kFSfXiyfb3Ka3EVj6OrG9aK/+0I58IvgIKW1g?=
 =?us-ascii?Q?z4zaOTFkFTFgMr0brtCjbjd29fg4BypFWG5nHdCheCjntXT1h0tqBlg4VM0K?=
 =?us-ascii?Q?mBTlcpTTzzISM7P9kOczZugBKT4fN9PpaPA3SdzSrqnZWlJ6lqpJ0OEpmZYO?=
 =?us-ascii?Q?VA9BsN6HvmOjWh7LnfhryD6m6EKWlSn+bBtS8GcrymI2ST9bEPJE91aKb3+G?=
 =?us-ascii?Q?r4shqY/TftmlV+XsWbq1e2WeSHxUyxY6FjENiE7wMStFtu+6Wgwn4xzoMY2g?=
 =?us-ascii?Q?2gwBsaNKDiodv4zFPD7WPY+fVYi7QZpJZZ7hC7BcS7GcXZdpfnh8gi+kXrxv?=
 =?us-ascii?Q?HvspzRH50ScGf7Wd3cgMZiS+Tma/hvYGjKWni5mVCJRRT1uATVEiYl8GJn8r?=
 =?us-ascii?Q?hdj5URrZ3FQQ5njzybGuJZ7Bu2Nh8rugnBUv+H9JxVtW+zaWoTtNWjnpVpZb?=
 =?us-ascii?Q?n6oza7oJYJBMxavgIulrW7NDKGvUmQXR5pKBwmbKB6/GtQ/Op6qrfxjQWAOb?=
 =?us-ascii?Q?T4YyLVmvXrY5Sw2Abbp95O53RPOYWoAHhG1aS48310mdbv6nAFg8hwZRRTIe?=
 =?us-ascii?Q?Zc1XDjPS7z0ss9DILPREVnDzhtE4QLBWgoj7KDrQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 496a0f75-7a8a-45f0-64b6-08db02b37732
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 11:16:42.7124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+U0bbTzFclQ3xtK+VUXLP/sCeZkNiMKQRQADKJw8vAw3ZS0I+eAq1q5ajsQiC82vdX75M1Gs4h1WuyOQWS29A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6163
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Jason Gunthorpe <jgg@nvidia.com> writes:

> On Tue, Jan 24, 2023 at 04:42:38PM +1100, Alistair Popple wrote:
>> Convert io_uring to use vm_account instead of directly charging pages
>> against the user/mm. Rather than charge pages to both user->locked_vm
>> and mm->pinned_vm this will only charge pages to user->locked_vm.
>
> I think this is a mistake in the first patch, the pinned_vm should
> still increment (but not checked against the rlimit), though its main
> purpose in this mode is for debugging in proc.

Sorry, didn't quite follow - are you saying we should always increment
mm->pinned_vm and only use VM_ACCOUNT_USER vs. TASK to select which one
the rlimit is enforced against?

> Jason

