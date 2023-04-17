Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CA86E50C4
	for <lists+io-uring@lfdr.de>; Mon, 17 Apr 2023 21:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjDQTYL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Apr 2023 15:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDQTYK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Apr 2023 15:24:10 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3741C4ECA;
        Mon, 17 Apr 2023 12:24:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3o0UC+TixfKzIPd3K/otry4/gPFLKLWEhuf7BzPhrvfQAq4bRYnQGxIMJnl30fBFEsuOp9LxDfHuvYsbWXfHxeVPGTHr7jy82Y8ICLfJOzElKHGDFgO8/ceijlBxifT9Z+5rGA0/XrxuRo9mnWkdi70Z9uz8586z0K71ESYJje5lb5W75XyOZY0LnXWc4B+YVyxSfw5IFpXKNx7/0sksRdnip9cbHjD+jQqmt501XG+gTpKHf9IeA4hQDEb8EChqHOksSOoD6+sjNwznQwT3zIbxSTAVO0Tmc4lGpCGUDCLJPy34trPcUjIcD3vW5VVqHxIoa2RlTE9lEoVc595SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhhSUquaux509G+wwsjE7LFwIvnRfTkx246gMaxS/Bk=;
 b=VyuUdoVCDdd3qYN4IoPHfJn+wkdFuOgD+41aMkfk8DsK0t7Z6tBPzfbmeOFbYoVjhnPZnRpqlboLObgiLgPZ/WmH/O7Itj+Amx1QFlRb8E8TQ6x36h8CgL3QHXEDr7HDrfHM8hOeIun08Y8TZb+7FANoYCcFIuus3BzypkFMN+5QDLMVEkIuAGzX7iesnzFCuB8AexP7lt5J2uhxiynMHpYg+V9R7AVcWCYRSsR+ziNvCAZaIsc4Nw40xd8RkUhCQ5twGbOxK/1VCWQnqJANG5gR06usb4TP9TktBZyR/jDsMKvJnO4M6r82IG+l19L2xbvN6jZcN2gjfJb+yDXK7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhhSUquaux509G+wwsjE7LFwIvnRfTkx246gMaxS/Bk=;
 b=KFeoBLaQ/xTk9NmYym8wprYBZpZCUn7ApxQoit9I2kzjw40aHA3n/7d6TgJocGPl1esciOaRGrNiYYtH102sR3eGNkTNb85N7YTzby+FUlc1l+S25ryzcJCXinlHXTOR1QaEmyyFhHCEaE7vWTs6SkBGaAvG3gosB6/t57fxUmsb1+AwjfQQl5RK1QOpqjJwp1VBv1PB0ppkRQv1CdnsfhZEwYu7yxxmNU6X47oZyxvHeJYajaDblk6kEXCKM8KNU45RiGkMA+QKCBboi8UeFFyhz+KENQSv3+1NZdQER8ik4AL0Wb/s5tyvA/4MoX1W5Ew5gtJDayMYhdeoxLjNHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7252.namprd12.prod.outlook.com (2603:10b6:806:2ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Mon, 17 Apr
 2023 19:24:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 19:24:06 +0000
Date:   Mon, 17 Apr 2023 16:24:04 -0300
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
Message-ID: <ZD2c1CB4FmUVuMln@nvidia.com>
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
 <b1f125c8-05ec-4b41-9b3d-165bf7694e5a@lucifer.local>
 <ZD1I8XlSBIYET9A+@nvidia.com>
 <b661ca21-b436-44cf-b70d-0b126989ab33@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b661ca21-b436-44cf-b70d-0b126989ab33@lucifer.local>
X-ClientProxiedBy: YT2PR01CA0017.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7252:EE_
X-MS-Office365-Filtering-Correlation-Id: dce73cb4-b230-4d9d-bc8d-08db3f794fcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gg1bIJpdE1k5VjpA1a8vv0vGtiOfdQaXYEWmibCb418U2Z51EG4nVsXwIZErfrb93lET2pKkxLDTnC1CY7IZwVkr9zpel6pXK58/V3Ii/Y42xJRLJJy4YdjMJ22uyHWNxT8U8GmfViQzsITK9zwsoDuEdWbNuRVzsklMOw9cn0VIMZdCkkMKciL9/DedTw1baL6VhElSmi8tKlB1u9MaogAYS2DJ06FPAOLAfoOunWW8v1ECXiWrzrfW98hrR8nLJKM9g/GX8/LuqyBuyTbJforRS14NzbUPIPhwDvaHKOfx0vAzYoRo3Hs8LOgdSuynvegOlh+ReGmYNbazYfot/JcE1bBVk8l7AdOKwafwpKJGN/1ZJtxj66AKy27DXvLWDZqrW2R27uDHsnzPaHSnZGyEWDyHB/G8do5ioYgXQoge7QXEXHQFM2ARfSuDId7uf5iQD8F8NooxOFZDgFt1WEhprTK6Idb6FRfdi9edpK3D10bbBkPMRxpTJ8PiIHiZjpAr4BJJ9ncEEUvDkUYgPjO4Y+f/ud1o9pSQxR3sHK9k5R5eWYYRcKtfgzhTXZuU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(451199021)(5660300002)(6486002)(6916009)(66476007)(66556008)(2906002)(4326008)(66946007)(36756003)(86362001)(8936002)(41300700001)(38100700002)(478600001)(316002)(8676002)(54906003)(6506007)(6512007)(26005)(2616005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FVLDNCu7PxCeS9/Ru1RxSAYoQPDUrFJyuPyaR9sRVV4lt+tDt9/xPbggspyn?=
 =?us-ascii?Q?9ZsoowfU5mgaMLw1lWZLbyUsyDxR3MSFP5xLF+Bz4+TQeywl3hRuidHjNSvd?=
 =?us-ascii?Q?INzDgV0svSSbT1AjTmctQ8cI5spiHmMx5iioxHNfsxAEUSvk7BeLTF+x3ZnQ?=
 =?us-ascii?Q?VhiorlxOXviwEKb+i4vB9qpact9nA8KFt6qqvzr6IqSDcHjAnTJS3wnb3GGz?=
 =?us-ascii?Q?7oJZXXHd1rO2P+92DIdws8dMJmWqWa72MgwhJaVm5iigqQshFx5SDPbx5cyH?=
 =?us-ascii?Q?59w8eSmjWShIlXepNzN0t8t1Sbb/BgCWIuZcwVIw/PGHlBwnBAHmtFiLmv7g?=
 =?us-ascii?Q?uXoV2m6gTq3emVMFeHIoFhC0KVBGILkg1md7CU6b0661exdq4i7WuZ5l2J4R?=
 =?us-ascii?Q?xMpccFdtcxveqEAbiTxLPj+XolrMPBe+z+zUQHqSkls5wIXhkCir8e5lnATJ?=
 =?us-ascii?Q?GU9GrJOTfIukH5cxKzjlxfG7ZiKR+yW6DMv8tfxryuwCPA2nKdl4CU+YCqpi?=
 =?us-ascii?Q?G2rap3xA+H1rA3tHMU7k0YMrD94Bl1mtOPPHtN2Wu7UPWZ05d2nOsO77Irfu?=
 =?us-ascii?Q?yEbt9ejXDpDn6cTNhGLQiUMfa5eyRdwfAKRLxS66MJiBuXrfMoBKUsfkihxx?=
 =?us-ascii?Q?n0DHgLlsBziK25aBQWdw3+8Vxm9iE8xOsrKYwTC6lUD2i2YPcHy1OCCMwPap?=
 =?us-ascii?Q?yfmF+y82cue3CRoLAH9ktpYztNKuvADNrF256xR0m7G2+SJTctJSj3cDWzO3?=
 =?us-ascii?Q?MieTpwFvBv4Vxd+R2NSInde9B3I/ulrOlx42mDE1L8d+HskcOPBefqgb2BaQ?=
 =?us-ascii?Q?BT/paHCO1ZPLV8y5z+7cXzqLD3xjqMjFlJVBdR2ohVor8gSpkSkaS2ftFaMO?=
 =?us-ascii?Q?2Xka5Ccz88UBcIECBOutdZYRx0auzey7cUzagulAbjpnbK5jz0CvJz4c3uNd?=
 =?us-ascii?Q?ozHDnltnitt+mpQ9SdVqNMyUDW5sqgkFdIxFcEUqARIkWzt/QFD7bXzqyThJ?=
 =?us-ascii?Q?WUX3DJlhCwj/J1XO+UGS93uQ42jwMYY4gUi1y0f2g1xFtNMSZC0beH8edkZX?=
 =?us-ascii?Q?ljREukp3kZEDzdziGihuleQjJF2D2HTfE6renOkFcYEr2Knfu31uz6oapbkk?=
 =?us-ascii?Q?OWsP4DdM1nvm/tcYcAWKgh6WncYQJEgqJDJ8f7ovy6a3hTXbhPuF1+5GeHFx?=
 =?us-ascii?Q?eo9kyFZnwFkVq32sam1qOeCt88z8WaPSclAg46KNLqxmyRRgMarUcEjI7R7J?=
 =?us-ascii?Q?o+T3sN5Dw5fiOE/KEHElepcGCAd09n+DN3G6EtSIO6EKgg398HCkUjNsnOud?=
 =?us-ascii?Q?cGgWVvELAH+wrXtA3EAz1FOkIRGvxco/jxzoBUNIttsog+20Bn7iVEvGafQl?=
 =?us-ascii?Q?Gzle7odkHoBssremzJ2lt1A5kSBePGlsJtLHW9r6RFtt3eIu5VqGMESY0Ol4?=
 =?us-ascii?Q?nIROZyK3/gaPgSlnBlyEcEzMMvfkuXdedCAoLX8bSjUa1ovojI5N+lLQg3EY?=
 =?us-ascii?Q?Q6UwmMpB9VI37Ov1x7ibVZ+lMtLWFH1gOCD9k74iQFd11yLBHMu6d7oDEsyy?=
 =?us-ascii?Q?wWFNFls1MDHNLSFgDmKKM5sCrwajmHP1DSAhV2K5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dce73cb4-b230-4d9d-bc8d-08db3f794fcf
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 19:24:06.6792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qHGvlgUTksPZCjSQmMlWeKTO2RtxRIHVK6tNqaKOkOi4RvV6Xwh7eJrAGMCspR6X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7252
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 17, 2023 at 08:00:48PM +0100, Lorenzo Stoakes wrote:

> So I don't think this route is plausible unless you were thinking of
> somehow offloading to a thread?

ah, fair enough
 
> In any case, if we institute the FOLL_ALLOW_BROKEN_FILE_MAPPINGS flag we
> can just drop FOLL_ANON altogether right, as this will be implied and
> hugetlb should work here too?

Well.. no, as I said read-only access to the pages works fine, so GUP
should not block that. It is only write that has issues

> Separately, I find the semantics of access_remote_vm() kind of weird, and
> with a possible mmap_lock-free future it does make me wonder whether
> something better could be done there.

Yes, it is very weird, kthread_use_mm is much nicer.
 
> (Section where I sound like I might be going mad) Perhaps having some means
> of context switching into the kernel portion of the remote process as if
> were a system call or soft interrupt handler and having that actually do
> the uaccess operation could be useful here?

This is the kthread_use_mm() approach, that is basically what it
does. You are suggesting to extend it to kthreads that already have a
process attached...

access_remote_vm is basically copy_to/from_user built using kmap and
GUP.

even a simple step of localizing FOLL_ANON to __access_remote_vm,
since it must have the VMA nyhow, would be an improvement.

Jason
