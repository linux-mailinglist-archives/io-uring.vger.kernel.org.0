Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3029B6E4B22
	for <lists+io-uring@lfdr.de>; Mon, 17 Apr 2023 16:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjDQOPf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Apr 2023 10:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjDQOPZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Apr 2023 10:15:25 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB51AF02;
        Mon, 17 Apr 2023 07:15:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Avmozi7HwWqGZgboQpHbahzs7/AsRxEnvE4jMSp0bHP/bPFCGPoPEmml/aOpvlvLr5vPz2yvLpRSIw8shBf3q/oVNsPYvf0697rlAaMtDIkVbw4UcPRR4na7bm54OGmjX9qmjLYS2dCFxreZYnkr1ULdpXLXeSgCXAbnZScaqdfTmCRf984rkNAx46elqct+hED7U9ZYGZF9liqxJhezuB7NENbAQQLBw1bLfmupHApRVIY+P2dri8jC6gnDWyIau5wHSLjqEoEOYkhDxaq82HBh3D1mQCv41qAfjeQx01qtYWXLvE5v/EzcUIsiv/SXjEOEPv60Ldd6a4PqOQF+MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WfrXEzBwWiomCZmP9gORtGauH7ZNalgt/By5l6xbuts=;
 b=QflxD0AiPXLld4RU7t7/qk5jz0Bujsw/a20jgU4imM5J4W9HdXlPbCl8wn5mEzyK7odQTjOZgHdyzWVjSJBYLW4MpAjSgpj4adyagEOP6iTgHQ3PvEjAy4cZkXsA8AUzPyXfA84m4PF99sBGdVVs2p58MPaAYkJUv6EMyXtyUe7dNz02WHXuillTynvJXn18D1wCKoYQdlBmz39h/oqubMyYtFEppv6JX8ouJiWnz+SLAyFvcyqyHlchAudbLF6pfOkfSrcw6kRbx9uMwwGK6T0zHUHoBMGOtm/dVsKQwZvEVB8gJNFFdFGo2mwWvRkf7HRwTyrpBVfQymEb5SwJmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfrXEzBwWiomCZmP9gORtGauH7ZNalgt/By5l6xbuts=;
 b=WrbcrlSRoJGYW8FWdUw77woHsVcNknmvgkvtLFMcdyp/I/Lry4LMzWT3mrzFNeWSsFHMgICAypWJ/aAp6x7VqXrEPnUCt1f1Yw2uqz3h4twS1goJYugMV72yHME0r2uxc9H8g0fmssVCo0eMT94FG/l+V1/UftKP+AZAT3vh4eec2TbiViCdfLH/ZZRB3Bt25ZUOtYSh/mfzVIVYLYZpXJPN0QILKa7N1Ci0rbIQXob9hzHKS6+ExfsdoMyPT8c6MTt8m/S1kk9mqBIoSjcObcw2lcbNxRc4FRw1KQqCxYRMasGpDexll+juadPA0WoAxdSNxrM/P4eKgAcELDeCPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5213.namprd12.prod.outlook.com (2603:10b6:5:394::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 14:15:12 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 14:15:11 +0000
Date:   Mon, 17 Apr 2023 11:15:10 -0300
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
Message-ID: <ZD1UbgeoeNFEvv9/@nvidia.com>
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
 <b1f125c8-05ec-4b41-9b3d-165bf7694e5a@lucifer.local>
 <ZD1I8XlSBIYET9A+@nvidia.com>
 <34959b70-6270-46cf-94c5-d6da12b0c62d@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34959b70-6270-46cf-94c5-d6da12b0c62d@lucifer.local>
X-ClientProxiedBy: YT4PR01CA0004.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f2dd7b8-baef-4a8f-7150-08db3f4e2835
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jwIFZQKIo+9fSWhFf+EcUYaJa3ul4hs85jCCiCSxeyJsrZupdh+lToWFzM6ZqsgQ9Z/Ko1j5bXXavJyPljBmchkD/dpAivaSqxyhvUfzjmhzgv7KqsJDrlfm2mKU4WrI5VXEulYgIRDNiheaXPu2m3QdY5nyaO+X3UJRr0WJVlDcsOrLuAz5yH8dD846hjOkel0lm0QJrZ+mCXkbHg1bNhfLnsKxvfZBXmOOxcFxUlKi7/tteWnVhjplz/9VsQgHcj34PQa/yGvDomJIgyJAzKJgbADmEHeuFGx2xKdIE12cSwN5qhASJ7QQl1yf6B2bgT4BUh5sV4KkQYOZsGczeGGpgEhXbLBO8cWta5LmH5UhZDVno8Ak+Or5EZjm80kuYde93fLuFVQqyIqBD1TuV95Pz9ww9mM+1UlWzFBEFzYb/vEPze0/AZ4r75xCUe+vF2/k/YioolUAs///2pbzqLnk11NrL09tOUdncqTmR5qmoCBVZOxIU9i44Zb2Rfzwof5T7xn/yB4dVk10YO8oIXY1OIiod06mjVavtdEOT+eB5ivdx2R/OvVntIBquHrC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199021)(36756003)(2906002)(5660300002)(8936002)(8676002)(41300700001)(86362001)(38100700002)(478600001)(54906003)(2616005)(26005)(6506007)(6512007)(186003)(6486002)(6916009)(4326008)(66476007)(66556008)(66946007)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mSPY23IUhBa3uivgGO0EkNfMl+Izz8sLcy7zAdzokUK3PeKYH7Lp2OoKM2rL?=
 =?us-ascii?Q?qqtecas0VldkNttDG//PCy/Djw4VDFhkYm/kGOu9kq30wLmkM0YqS4f69Bb9?=
 =?us-ascii?Q?rgrQGiNZfKHf4RNYy8RjBU3FpHtwSy/GL0PvoQI3MtE9SlC1fSe+AF66lnZk?=
 =?us-ascii?Q?0mgpf57P2ZDfdlWO52G4ENasnmmfLjzFE5wpFNURFHGndwXDHHyczsY8ZuiP?=
 =?us-ascii?Q?k5djl+VXkhUe7qRsn4wUcJGPplzlWPao5f4Mes256OBJQH0eGPU752GOMJf3?=
 =?us-ascii?Q?5EsH0wEoM0hsCxIZXtN+boyA9fecFGsr12F6JKjlXzdD1h8I3s0Dgvz5zH5a?=
 =?us-ascii?Q?UID6qw/AdkyZpn5SFgN7+83m33RmfBJBdq4wnZx1pmXKwbUz8UhCX5FuvY/s?=
 =?us-ascii?Q?3rIM5sj5qnNsZlDwhyL1L/4wAkrHFDCzK/loAy3+dDhBCyqo2CtrWTdgMyP1?=
 =?us-ascii?Q?/Sg3iLC5Dprm4L9q+SPodAhlHxPBZsX7nESmtBkfzLJrVQ/XOcBw/v7c9gnu?=
 =?us-ascii?Q?Py6dbbBaFSDYT1z+yFhCtnp3Im0p4cCBFcIgnRf884Cpi7iIXcYmTx7sSIQQ?=
 =?us-ascii?Q?4YDZbWsy/9H3z2N58CrFk3jO8oFNFdsBTk91vNBlsqSkM7j+29AZnax8YVHb?=
 =?us-ascii?Q?/8HF8kXfUUDYQCmYfCZW1Siye3ONsX8wwkjcAtH5UsfxgbxfsuJsd4tnobnp?=
 =?us-ascii?Q?KIYwKpn0POLxOV/DMBbpRzthGMPc+o/xoaR8wE7j68sbGcEXB4STJVSfD4oa?=
 =?us-ascii?Q?eOWgseuEZmpuBoOslf/49jDdNb4b/fclxgMrsyIn+vgfU0gg5I1DnRkZXIv/?=
 =?us-ascii?Q?9GZvFN8iGAmQhLRVh7jK1p33yyFkh4tq/YPxINvv0EA0BqJxUDxHy7UMxisa?=
 =?us-ascii?Q?8BSea6vl02fyMWo2+bmcL3Y5xi6tUPI2o/KXS9qfSSHEtjY2w8BQL5CYS1AB?=
 =?us-ascii?Q?tqxs7imJJ/x2zx6pEE/7OE+yGkTs7ZaXZ4GwDuYYXhmlqQ7GBjqSribtSQNk?=
 =?us-ascii?Q?aqPgOJ2EE536JFhXR+mSyy4f1+MCRnsvlsPGyYC1akdWQ7ESSdSVCk4hrNI+?=
 =?us-ascii?Q?e0JIFMvOEsNaUXK7esyqV/2hvUI1p4F1tZtWx4+sItdDgiujmkNoX0mn1i8g?=
 =?us-ascii?Q?pyc2jPdYVXEJknoBDVDnicxFfzNmha+ASE6j1f7qc/gqKHwFHPbuFEVqn5mZ?=
 =?us-ascii?Q?1hBFVEAd824Q+8oYV6tDCrwSw++l4GCypbYm6KUt1A8pAP2deb8cYn6jkZi5?=
 =?us-ascii?Q?n+1JqgLXWbyPNPhsd9odMJdFSv9ZstbhTzusQtoGESS0T1pehapIs1x12ZBS?=
 =?us-ascii?Q?+e7sEdZF7DDXnfDUXS4W+nTXXZqr+6q8dcxC/5oKyKeiqj/bUmgmEdAkeWtk?=
 =?us-ascii?Q?bPZ/opV9SBLA4+UScyK/1bkOKaVn9eIl7GZwjUsx7sx7E6mxYEQ5Y4jx2rzd?=
 =?us-ascii?Q?bTozhJoy8ZOzY5R9+INiP4tVu1vwFj5dOdJxhIYu1ke1FjYMMQElQEBl2Wkj?=
 =?us-ascii?Q?SpBqep5mdTK050BxpT8xi0Ii/DsNH88CglPNrgYbNkrV1ijXexb0K2yZduat?=
 =?us-ascii?Q?hqTgpnsAWKmlbCn8k9l2BkM8XF/+ozbfKWjzR3km?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f2dd7b8-baef-4a8f-7150-08db3f4e2835
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 14:15:11.9383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KeroLZLKlk1i4/TAMlgmn1cHiRE/9qzkk+kHfD1rig4Yn9IgDPlb7gUapWyg5Oxx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5213
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 17, 2023 at 03:00:16PM +0100, Lorenzo Stoakes wrote:
> On Mon, Apr 17, 2023 at 10:26:09AM -0300, Jason Gunthorpe wrote:
> > On Mon, Apr 17, 2023 at 02:19:16PM +0100, Lorenzo Stoakes wrote:
> >
> > > > I'd rather see something like FOLL_ALLOW_BROKEN_FILE_MAPPINGS than
> > > > io_uring open coding this kind of stuff.
> > > >
> > >
> > > How would the semantics of this work? What is broken? It is a little
> > > frustrating that we have FOLL_ANON but hugetlb as an outlying case, adding
> > > FOLL_ANON_OR_HUGETLB was another consideration...
> >
> > It says "historically this user has accepted file backed pages and we
> > we think there may actually be users doing that, so don't break the
> > uABI"
> 
> Having written a bunch here I suddenly realised that you probably mean for
> this flag to NOT be applied to the io_uring code and thus have it enforce
> the 'anonymous or hugetlb' check by default?

Yes

> So you mean to disallow file-backed page pinning as a whole unless this
> flag is specified? 

Yes

> For FOLL_GET I can see that access to the underlying
> data is dangerous as the memory may get reclaimed or migrated, but surely
> DMA-pinned memory (as is the case here) is safe?

No, it is all broken, read-only access is safe.

We are trying to get a point where pin access will interact properly
with the filesystem, but it isn't done yet.

> Or is this a product more so of some kernel process accessing file-backed
> pages for a file system which expects write-notify semantics and doesn't
> get them in this case, which could indeed be horribly broken.

Yes, broadly

> I am definitely in favour of cutting things down if possible, and very much
> prefer the use of uaccess if we are able to do so rather than GUP.
> 
> I do feel that GUP should be focused purely on pinning memory rather than
> manipulating it (whether read or write) so I agree with this sentiment.

Yes, someone needs to be brave enough to go and try to adjust these
old places :)

I see in the git history this was added to solve CVE-2018-1120 - eg
FUSE can hold off fault-in indefinitely. So the flag is really badly
misnamed - it is "FOLL_DONT_BLOCK_ON_USERSPACE" and anon memory is a
simple, but overly narrow, way to get that property.

If it is changed to use kthread_use_mm() it needs a VMA based check
for the same idea.

Jason
