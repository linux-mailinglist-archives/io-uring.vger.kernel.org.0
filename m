Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E026E484D
	for <lists+io-uring@lfdr.de>; Mon, 17 Apr 2023 14:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjDQM4o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Apr 2023 08:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDQM4m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Apr 2023 08:56:42 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C8E19AD;
        Mon, 17 Apr 2023 05:56:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNNnHh8qliD75IkO4m77DgiP24T5e6+CADApYkhYgfaD8FJ0UbFd1rXPPEdl9LS6r8bSTZR+NKm1QDAJy+Xpo2yzS9HtR2LXfw7oMI1/YB3NtlnJw87dS909HmfzdwO5R4ocjoTcQqVsxV3gHpAu/0GJj6dMEVGGfXz0umWWa9l4sQHY7CPp4n5oeq12f7xDqFJEVDbjBgrlsU3D2n/lzqps09qFz/oAZlrcbh+cBE9h86TA1Qqvf10/ufMr/5TNSRiuXlmLpBCe6tijh76pvZRNAp8IRfu1+kGvY9z9GPnwJ7b4IPZVzg5m8uyx0I+EzUDpk2ZNheNAFmZzjZDAmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3o/ZGVMHgJgCGsCcIUxvVIDrVElHRF3Kh5Dd3QooAyQ=;
 b=k/krOZ32MarygqZ4BtJXccdkLj4kEs+paq8W+SeMhFSTgQTR6nndpBGxmQ9bWN98yn0jvWneifwbB0CJWgwdzx2zLJBWRVrHbZ2L3ngQ+y8vKrPMyWeFf/FpHyPjLEEshD/aIV3TDfC4zgefpabhvnkzWRtjO9oSAVpGBYUsOLZFZe6GSoz3jn12gCTVI7tZ8UmoQZXpD3keNfYPW7tQokaRq76IXTnIGPsW67pCj/RZiCp3dxCe9IDK92y1iCgPZiKZ73cNCvD27ccHk6o8wpdj7ee2SL+qAXYKI8Ih8nCIjTcz3u4zwdoNzDTpRI+6JwNfPOKAqezG+dXxWwSc0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3o/ZGVMHgJgCGsCcIUxvVIDrVElHRF3Kh5Dd3QooAyQ=;
 b=kJknsXRT+0MozHJ5+fsBVfi3ZRxf82y2oDwlc/53Fwv6YdsZ2DA1YOgwla/WOMyVGUexwUtbiiNIYldUmmy9BdOsTHqB6KsbGQOEuDxwKN/b1drl58E2KA0g19jU5nHpkIf0evqDJaltactVZTBbPp97gUPhFP6nDnWYhADlDuBPowh+uRYG2SaAOVC6pDo2LGNHnhVxowdrFuGbtzciLEavuqT/N/y1oKQZXDSiR+n99M0rfHNJ7dTzrTYoZBpUS8isHoVV8cIvMDRMweg/eZV094spBLsXReebhJjNMl4g8DCEcAgsLSokwxCTQQIFjnhB8mJdjyffc5eHwQBiHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7120.namprd12.prod.outlook.com (2603:10b6:303:222::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:56:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 12:56:37 +0000
Date:   Mon, 17 Apr 2023 09:56:34 -0300
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
Message-ID: <ZD1CAvXee5E5456e@nvidia.com>
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
X-ClientProxiedBy: YTBP288CA0013.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7120:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c73ca46-294b-4f45-f3a9-08db3f432db1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ne1rww8joAIOjG56bsNvH9J/EFJwY+TjNJL7LIHWFLEPKgmZYdyFO8jh86HAB7XSh1Nxea38/8pJGQRFUUbgQ23YRWfdirn0uWjx6XZOW/WgUtoJgXgYnGwtj/ZPfZCBVe2J0jhGYSXCf9Rcov3bqk6U9FRdRQRfgitIfp0Ia20oL+oMmKIY8GLmoWVD610+lueMgyd12GAx2TXlaayUZ/noJMxoeiOxQOyypjyNUWE26W6pb8iUKf2qeH3KQjIrwR6wKoTmGNtb5sVydMQxpD0ca9URghu7gGxs2kxaQcOpGTbps7CzVW9HM8FeJGyV32blPFGL6Cq2TH8Am5MUWYAfEdvgm2LEAs8M+4Z9o4LdZzEfZVodFdBNJLRsoH8VBZpQZGXaSjM2Js+TDwazdh0d66f+XBKgBSdD1eFMsYptkCOZngWbGPopBnlasuBKc0cIdJw2D7x+1UOAlQWcgZVGDcCAzX5JSy2C43pEPKicJPpu1q+cr3rVJIIXTLXxseqz5ojE8Gwbt1LGSlovBuC/9aByeKEq+3tZiDtY8gKWFFuQ8ULqgEUDBgfEaEC0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199021)(4326008)(26005)(6512007)(8936002)(8676002)(36756003)(41300700001)(86362001)(316002)(5660300002)(66946007)(66556008)(66476007)(6916009)(6506007)(54906003)(38100700002)(2906002)(6486002)(6666004)(186003)(2616005)(478600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mO91zWmvp+UPfmwm3K4XL60OB088s1VhbcLHEhVlt8zSGcaMvNwj8CW6NLDd?=
 =?us-ascii?Q?UqEgD1yOLMX24/WP2dqxad1d86Ww3TxRI/w6SIBHRYkOMgr5rZa12OO+MX/F?=
 =?us-ascii?Q?ufcz7US+v7ZogD1e0kXdbsZUig6j63f8nEeGS9CEsEoloQsv3KqXher0PC2U?=
 =?us-ascii?Q?CgmepravneCR//pK3GPK689RvvaOhYdlOJp2tckaIgAoC9c6wId4vjiGcCoF?=
 =?us-ascii?Q?SEP65UyN8Qt8JWffwzIm6J6XmQL/9bUUGK3kr4lHABem5uxSf44kEMYUIdlh?=
 =?us-ascii?Q?tKnTyvQXdqE1EPDgvZPFpGznjdXX01Tbb8EUgYfeESSBuwESTj2pZryYnfVQ?=
 =?us-ascii?Q?mSZ2rFsXL01uNgnfnEfNqJZ0cYGo73SYHMru5PeGMFXf1rucLrdYWnEpMW5O?=
 =?us-ascii?Q?nOmGK7aMBzTCG3/H52M6GzkBLmMm8DtyGJic9SdV9hCv8ucejHjllJcZYwnD?=
 =?us-ascii?Q?7vegRSIXAjNB37AvBUZPAbuy+dG0vP624uNyimb1ZzU+MrrBQ8TsPP1hz1b7?=
 =?us-ascii?Q?B3iIedDNY6R0zBDTgu/gCqF9rstu/qJtheJDFSElNgWs946baNHloPdmb2V9?=
 =?us-ascii?Q?iSsXcp6i3jLOrgTYC59CqwJvHyfHqdijzY3MacMlfh+Ezw52XFT/QnBhzZvq?=
 =?us-ascii?Q?sDLzYeN2Jko+mua0A8n/2X3rHin4QxDAAt1woMyxqj9FhJZg6VbLUGwQ2EXb?=
 =?us-ascii?Q?ly7B0/wnUxOFJ8qVyyjKEuc25W/s+n+QeASeNPMqomknu2A2m8H8tjr+afnA?=
 =?us-ascii?Q?23VFBhDR/tAWxfONsM6qP8N9Yu22ff4mCfUPXzehbXegHcIdmIkm0Bpsm3Qu?=
 =?us-ascii?Q?eqmitielCSGYqZ7e9w9gn/PW4W181jJQhTJlWI3f4biRLewsvBJUhFDAxMm5?=
 =?us-ascii?Q?f5HWemfhXfjS4XBy28KQ7Hu4WdSGN0l1WjPdcv+TtKmGGGq9mZJFsmaZa9jv?=
 =?us-ascii?Q?xev8FiXTOTcss0Snv3bg86cpQ02nkjmXnz8kywwI0QCLC1lPe+cjBXbckBbY?=
 =?us-ascii?Q?o3z5xVLr+aM2v0s4lKlD85V0GM4uM2IPLd/+RRdIlm2uQOokWADkbPzbdaRT?=
 =?us-ascii?Q?RWir+YvSCB6tRq6Mp8pfLpkjFHcuyumcDR9iDlXgEDcYT53LAW/1PXlxJLpr?=
 =?us-ascii?Q?AkRGiiYK9/FxN86YMACXQa133dBg3ZrHxqkZRsXe7EXZsRnLAsUeSMW81wvL?=
 =?us-ascii?Q?uPsw5Cm8KKxv6YA1eQiluYJTcpIdQWgSyQBEB9oKwSxX4gTyXfrBn1perFSD?=
 =?us-ascii?Q?I9jyJlzyqDadEQwKQ3KzZB7YZ6unydjnXIqTxA0Ns9W6MKjztIYacbq4BqMP?=
 =?us-ascii?Q?CJJ2FzBlvwgXekcKVxLhxnE8+AljATzHGxLfoFb/TSRYF2WekvIuprFHCsAI?=
 =?us-ascii?Q?4UqTNvLLOBkgHwf1gTO2f/javFtJJc2i/toD6l2OEyJYe6j/YZuYfTD6matR?=
 =?us-ascii?Q?Gr/h93J7K9gLWhiXG1C0Mr17m+dxABZvyMHnec7zUtS5uBypyTt1tNk9Llpf?=
 =?us-ascii?Q?5Ee4zsnyBKCxJLDaSZBc/t3qMejc0eST2cn1EmBI2Utw8lFJn5vq4QmVxKwD?=
 =?us-ascii?Q?808tm+7mcppagLWvHDA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c73ca46-294b-4f45-f3a9-08db3f432db1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:56:37.1390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vhSj4P8azZAVohUmq3ftzSgajJMHG4Ax5ddSUQZ8xZZ4PHK8smPOTIZ4YpBQGgZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7120
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Apr 15, 2023 at 12:27:45AM +0100, Lorenzo Stoakes wrote:
> Commit edd478269640 ("io_uring/rsrc: disallow multi-source reg buffers")
> prevents io_pin_pages() from pinning pages spanning multiple VMAs with
> permitted characteristics (anon/huge), requiring that all VMAs share the
> same vm_file.

That commmit doesn't really explain why io_uring is doing such a weird
thing.

What exactly is the problem with mixing struct pages from different
files and why of all the GUP users does only io_uring need to care
about this?

If there is no justification then lets revert that commit instead.

>  		/* don't support file backed memory */
> -		for (i = 0; i < nr_pages; i++) {
> -			if (vmas[i]->vm_file != file) {
> -				ret = -EINVAL;
> -				break;
> -			}
> -			if (!file)
> -				continue;
> -			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file)) {
> -				ret = -EOPNOTSUPP;
> -				break;
> -			}
> -		}
> +		file = vma->vm_file;
> +		if (file && !vma_is_shmem(vma) && !is_file_hugepages(file))
> +			ret = -EOPNOTSUPP;
> +

Also, why is it doing this?

All GUP users don't work entirely right for any fops implementation
that assumes write protect is unconditionally possible. eg most
filesystems.

We've been ignoring blocking it because it is an ABI break and it does
sort of work in some cases.

I'd rather see something like FOLL_ALLOW_BROKEN_FILE_MAPPINGS than
io_uring open coding this kind of stuff.

Jason
