Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0863368CBBB
	for <lists+io-uring@lfdr.de>; Tue,  7 Feb 2023 02:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjBGBMB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Feb 2023 20:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBGBMA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Feb 2023 20:12:00 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75185B759;
        Mon,  6 Feb 2023 17:11:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FE0RBOP1ufGinZB2OVe0/4qu/Ss+7hQmEE9HMyp7WLof3zGGwIMwARfvnz4nLUihRjL0edUKRzh/yJntpymhSb63d1+cKZHNIzNZWN+mBGF9cH/nHa+gyp60Ob0fnx8mwjjQ7GfDPgTpQEMR0RjupqAkJApkHmdsmmdX8qXBFlRQW12MvlNrN8ssCCwwNAQDLKsQd6d8GaX3ax10/VheHX/fUNCybtcORsJFFZSuTBwpAp4w0QlA4DgHnUbSozdm2PslXqhFWrOMLo9kB4aF+9N4+pReXvWhHR3Y7O6Yi49pu7rHsule7kdklH6gm5AEe+ept/Peg6BrkrUV9TGSng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulzZsKnPwt8pnwF8OUVxD4NHDYhB5qj3lLTnLog7IN0=;
 b=oYcO3oX+Gk+/8SJc3uiCMf06DtAmpl2rV2r8Q8lJ5Ti5yP6ifE1DEZOH93pUkjdefcXTWD8TKTPdEEedXEQ364UqvnIjDXB9tIwt9dgKh7P5u7RdwPIZutDyRE0OAicPZ4jhLzwPTNEL3ElPaKfTd2ogp4oVfVIIcofWRqPMUS/zDHtBVc+wb5tsrfSJ4dhDRLo73L+UcDuzHRTYUxLxpae7BR4b4y6svL13a/EMZuxBfU/64v3pUIZp/Yl8nY1VKV4DtMv5LDVSSPJ0Bs6/jxlpnJ/xGyEA7qKEGQgs5KySsU3Uhhmk/yPs22UVPOy1Bon1JVh+uqP+f9GV3eMPhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulzZsKnPwt8pnwF8OUVxD4NHDYhB5qj3lLTnLog7IN0=;
 b=H+t/UgZB9U/N+FDkzaaK6EBmuKUq46RJshN9iy21tRecmBY0By929/pnJWlO0PIcmUNvb9G+4NfvWNAlfwsca+IbYFNnR3uBIPs9EEQXykof/lW0CVS9Rb/cmO9VHC4Kos6nZk3SbkqSVb6m5nd3aSysmozvSq3ZWTShHOa0l6zddgtEBqJMzLrfn7jMcsi6h6gI66CPJzw+9KFoyK717FkwcsbBrXe1ZVu7tO1wGbgspYQx96MaaKadkX98cgEDwcmlAvRXqseScroscmRs+Ayr2BbE/cEo7oDqNpMORNWXt84WwYuRqg9vI4JQyrzeNDzgjInn0hVisPxfup9PJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by CH0PR12MB5107.namprd12.prod.outlook.com (2603:10b6:610:be::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Tue, 7 Feb
 2023 01:11:56 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df%6]) with mapi id 15.20.6064.032; Tue, 7 Feb 2023
 01:11:56 +0000
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple@nvidia.com>
 <52d41a7e-1407-e74f-9206-6dd583b7b6b5@kernel.dk>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 09/19] io_uring: convert to use vm_account
Date:   Tue, 07 Feb 2023 12:03:33 +1100
In-reply-to: <52d41a7e-1407-e74f-9206-6dd583b7b6b5@kernel.dk>
Message-ID: <87k00unusm.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::10) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|CH0PR12MB5107:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fb48ebc-2476-4309-bf48-08db08a84dfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DvBhmIIBdNmnOrjEdAzXhygP+ivXWssRxDit82uAtG/TTXCj3hhoFqRYuOy8AmYhARF8wMWuzG/qEcGJRj7aH0qPUummaJ2K7WPEVu041q7tVEEhUHP9jGBskHqmrMnmqqceVfNZnF0FlSsRUMYs9B5maA7VDfoVQ0Cu0C4XnJR1Uv7LYNWwaQu9Vp79NRlLDF78F8x+Im4Ttd0muHACuqf0iNg8rUoYFMGNnW7g4tGNz4J6/k2stMYKgIv75c9I4fQEagr2WyCtNMen7irZD26j+S/5hG+t7H59xAiQCeu1EpQZgskWdgVxEHVU516El2vncmHuBicr767Hczpwh4HKQtaJiUYg4KBMl/kMcLbpkS6D8V3OV1RbakobP8VLv9rlDZCtEa1Paj9uoxoXUsgUqARxzyvGnQJ5tUioKFlxQD25k6nymoluXPpNHhPc5NuFeL1UfIguy6u5Krq5nnoLczN1UBD68u3J0sSBdoUOpG0LhubVO6XvNqbIYn+d+eyCuuWieNd8fsTznJ7IlSCBhTKzg9v0YsJPf1HILn1my0EwM4JVaR9dAOXQdCBWYZIB6dTF0VRtTJbPw6rGal/lAvTlo4TFCdkXwzponxSiJ+5jA/xqeFSbm/CzaSOh5DfWlMSn2mVgKLCvPK1hNzeWUT8YOHvM788W7P36bI7Na3nV/V6UWzXXBRzIVAwXy5lmowPQ/i4A1PtaYFRNjIMwD8ttnOJ+o0hz6IH8CfqWd8dKWHI3HQYKphTFAmNEnJ5fLPaIdhSsJDBxbByDkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199018)(83380400001)(86362001)(36756003)(6916009)(66556008)(38100700002)(4326008)(66946007)(66476007)(2616005)(8676002)(6506007)(6666004)(54906003)(478600001)(26005)(186003)(53546011)(8936002)(966005)(5660300002)(316002)(6486002)(7416002)(41300700001)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWg3VTVMQStmYUR5QmlkN0hHdnloVkFuZzVUSURNMzh2dzg2MWNMVkp0bFU4?=
 =?utf-8?B?TXVmQVlTVFVhSUExNlkybWs2cVVqbzZjMXhNQXJCVWE3OVhKNmFyWTVEZUh1?=
 =?utf-8?B?THVvbnVxV3R1ZER2WjVMKzF1OGJHU2JITGVMRVZJaFMrWU5HbnY1a0NEUmVj?=
 =?utf-8?B?SUNGTC9sWmhNOG13MXV6QXF6ek9Vd3A3UHVFYjY2QkpzWEVhQnpFdTdzT0Zn?=
 =?utf-8?B?bURRS0xOT0dnM0R2bW9qVlA4VmJuL2pTbE5LVzJqcWNKQ1VabnA5QXgycUNH?=
 =?utf-8?B?aDJHZko0c1dMNDR5aThiMlc0WHpiNTlRN3E0eSs3R1VhWWM4dnBnSjEvNGhq?=
 =?utf-8?B?dDR0UFVVa29aSENtVTh0ZzhpdU9ESncvdzZ6Z0d4ZXRxVStUcDdoKy8zTHJI?=
 =?utf-8?B?aGpheW14U1ltRlpsclFvd09PeEN2NytOU21UeEU4NDArK01MVHh4VXB0RUlj?=
 =?utf-8?B?a3FHSGFLQTFpUXJab1E3TzM0UnMzMWZXK1FxcXdlTmhTKzByYjI1eFU2c1Vm?=
 =?utf-8?B?cFFmTnl1MEkrSlBTYnZuVVlRamd5L2tMcW1VY1Y3YTlKTmZxTFZLV0gxODZK?=
 =?utf-8?B?amtocmxUOWlpWkxlREdMNmdtbnZWNVEyMFpWN0xOYmcwaVluODNKMnZ0QlF0?=
 =?utf-8?B?YXpXZHdlMjduQUErQzlCYktLcUxpdktRdlV4YmFOMGdpWmN4alpQVkNMKy9y?=
 =?utf-8?B?eGh0MkFqejBncUdWNFBsaVp3Y0c1cXY5aU91KzNHR2NDMkc0VlJGNXNxYzF6?=
 =?utf-8?B?WEt5MS9hOWV5cFJXcVlyaFVoTkUzZDF6dGJ5Z0FPZTdsVVljVTlTOTc5cWdj?=
 =?utf-8?B?RFo5UktuTFBKRGhxdkpFYWpuQkk5eHcwYm00S2FmaThvWS9UQThBRmZXTThS?=
 =?utf-8?B?WkxIeXE3MVZQa3VpcTk4ZnBpSmF6WTQxUS9kcVZNZjA1L1Z1RUpwMCtWR2Nk?=
 =?utf-8?B?czBzOXdaYzFodk5XK1ZkRmVNVFlNNGxMUU14bkM0eUJmd2tIcHo3akp6blJ1?=
 =?utf-8?B?V1VsTzJOYjl2WWpBZkE5emdIRlZNUDBmZ2ZPaXNRL3EvaDF0U0RPZjRBOHFJ?=
 =?utf-8?B?Y3FjUEdDTnpKclYzNWFWVWNhSnJndGxKcWt4L3Z3UFhHUVhTMVArTnFSRnNY?=
 =?utf-8?B?MXVVdk5iVXJJamppdHdWbUZ1TmhMUmVKekY1b1RsQldrLytzdmtyWEJNVjVU?=
 =?utf-8?B?UG5XRWx0Tjg1Y0RmMTk1MTFWYk9YZzlYMW5UUnVaNjJ5T2I2STBFbXdBaUFi?=
 =?utf-8?B?bkZDMFNHM2JrNFlBdlcxM0JxWnJROStNQzh5M0JqZ1dnWW1UM0VVQ0I5YUQy?=
 =?utf-8?B?RUVlS1JjT1B4MzdBZC92SWNnYW9XUGxzNU11WkY3OE5Pc05XZzNrSlh3YjhL?=
 =?utf-8?B?NWFlUlExNzEyamtKVzdqVC9Qb201alI1cGYySzZPWm9ZSzhWVHNxTVZYbXZQ?=
 =?utf-8?B?QlIvYXF5UEtkRk9sTzJlcWZLRzEzWXd4eFpBUWhBaDBmYzZQNjU0L25lQWRW?=
 =?utf-8?B?bmIvbVVKS0VwVTZnZzNVKzVKUis1TG54SlNDY3BhZm05aWQxSVBQVDZEdWM2?=
 =?utf-8?B?WGxJRUFSTFJOOFBOYVR0SUIzdlRVdWtWRzJDamZJZlROTzN1TXdOd3Y4N1hC?=
 =?utf-8?B?VXZrMzcxWE9RVVMzVXY4OEloYjFSYTgraExZcE9tY0dtcnhocklId2FEeDgy?=
 =?utf-8?B?cEdTMGxsT2k2SDJ0Yk5KU0NUVmxsekpudlVLSGFOcVNzQjlYV010VjdqWkMw?=
 =?utf-8?B?RWJRa3R0VG42RGFBOHZQRkZYWHRPUDBhaDV3Uzl4RE5ZYitSdUtMWDJocWxY?=
 =?utf-8?B?SE92eXZpSTk4UEVwdjdrR2FTWVA4QzhQbjloYVJsSFpBNlNhL2xvT2lJVmVy?=
 =?utf-8?B?NDRhWHM1a0dCUmN4K2VXQXZNaU1NNmRIVG14TmNJaHBZYTJia0dGT3hhTTd2?=
 =?utf-8?B?YWRWSU1MNTlHZUJLQi9IT1VHclkxWndyeE5OVWNwQlUzTkhHTTlrLzZDM3VT?=
 =?utf-8?B?RkxQMmNoTXQwZW9QaitpUWROdTFYdE1XZGZOVXdlSDhhVkhubEEwVk1pNjRL?=
 =?utf-8?B?ZmxIQmlsME1UZ0ZSK2pOWS9vMm5MTVh6T3JyeWNCZldRQS9zYmFMSUN3amRQ?=
 =?utf-8?Q?NwqxvY6rok/UijyaFthKG701I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb48ebc-2476-4309-bf48-08db08a84dfb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 01:11:56.2210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /5NFCdfWxqV09kgKurnP/sTRr0IlB65uKItveawSC4BIbc9GeDGAmhvroM78OBrJ68ZKE4Y94BXJfqeeDU9GBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5107
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Jens Axboe <axboe@kernel.dk> writes:

> On 2/6/23 12:47=E2=80=AFAM, Alistair Popple wrote:
>> Convert io_uring to use vm_account instead of directly charging pages
>> against the user/mm. Rather than charge pages to both user->locked_vm
>> and mm->pinned_vm this will only charge pages to user->locked_vm.
>
> Not sure how we're supposed to review this, when you just send us 9/19
> and vm_account_release() is supposedly an earlier patch in this series.
>
> Either CC the whole series, or at least the cover letter, core parts,
> and the per-subsystem parts.

Ok, thanks. Will be sure to add everyone to the cover letter and patch
01 when I send the next version.

For reference the cover letter is here:

https://lore.kernel.org/linux-mm/cover.c238416f0e82377b449846dbb2459ae9d703=
0c8e.1675669136.git-series.apopple@nvidia.com/

And the core patch that introduces vm_account is here:

https://lore.kernel.org/linux-mm/e80b61561f97296a6c08faeebe281cb949333d1d.1=
675669136.git-series.apopple@nvidia.com/

No problem if you want to wait for the resend/next version before
taking another look though.
