Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29A26E69A9
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 18:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjDRQgv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 12:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjDRQgq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 12:36:46 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2073.outbound.protection.outlook.com [40.107.95.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EADC65B;
        Tue, 18 Apr 2023 09:36:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/ePj7oxyGOtrINCOx8sj3yfX1z9hBlVgIWPkFRWJz/B1IX+d9Jm3visOekS3TEXlQ6wPHkOhsLqt6BFCrwbUfk2DeLZNHOkWmWfpKHQJNU4MHxPJf8SYf6ziw65Nb//Y5BZfxv/8TCtiyOGhjLf0QT2WLybU5oapYwunfTdWVV6mTA68itiaBl2sdWoQBfNIKOx6fqhzTr2bzXEZuKMCa1lv7FvAcoIEi+q2R8ZXnmIxYF/S3p98QZOPxMKgSm/O5t+8PexhlafaJmKXFnTqhui7iuuzseMcthjDON/32AuOVi1YEeO0fAo69TRKff+yTLE16qGMjFavhTWiJN7gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3yfyoZOSjHi9sictb6CoSwJsX2i2s1gmWZIri7dXgcI=;
 b=SPVf9l1rGojh1Yk9wLwrjseTlthcb9U0XE5FJGEAJ3QL3vPzYGFq5czU7pr8ACgjfnLrw8pJ7adQfX0Qa1uJnb/g5obT0vpa+T+UVo6HADE45L/OHioXF2btRqOIRTXNxqOky3ifECawyLaPU36Lx89z/i4ZtY/ei2P3GeI/6b5+tbE2nqpww5Kx65lIXCM7yyvyWety4MCArLRkEP8qvT84W6bY54n3voEQNYPvi42YrRYYrv4wj+52yr8E4Db1As7rZgfqCWX6T11g3GAx2PyzGMmwNXChTswQvirFFBMWxtedtSudDuiZy7ym5R3JvTO+kQWt9sSoAUCop/jXmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yfyoZOSjHi9sictb6CoSwJsX2i2s1gmWZIri7dXgcI=;
 b=qOrMwquMe0MX8rNpf00qT9iMDcT0+r3sHgDQnHx4EaztLCT3/xyld1fzsxFYwvl9NNsHeQTYLxGEC15ItK4aCa7aNFuqP4v8yO1w+f30A+bWhts9N5WxoMISlwn17ZjILRpnDQcMgMqa/mrvlMGNjFp1TIDJJwdObRTc+P+l67b4ra5Qd0ydD+H2EBBtkGPmHBx7YZggvzAKZ2PCer6kX/5XFb8yD9aXhjoTVb2hHbvBb4lvgps7zDnuGGk3421l0ZJksYVOls+Mm5NZyLfH7glmJdbVww75jOPLfarEhLs0d3rEczPSZc4RdnEGiIF69fRITEFvu+lE+PqHp7iMGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by DM6PR12MB5022.namprd12.prod.outlook.com (2603:10b6:5:20e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 16:36:43 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::94b9:a372:438d:94a2]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::94b9:a372:438d:94a2%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 16:36:42 +0000
Date:   Tue, 18 Apr 2023 13:36:41 -0300
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
Message-ID: <ZD7HGbdBt1XqIDX/@nvidia.com>
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
 <c19b3651-624b-f60e-3e63-fe9fadc6981f@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c19b3651-624b-f60e-3e63-fe9fadc6981f@gmail.com>
X-ClientProxiedBy: MN2PR15CA0031.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::44) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|DM6PR12MB5022:EE_
X-MS-Office365-Filtering-Correlation-Id: 3070d111-a1aa-4bfa-27f4-08db402b1751
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 557L1O4pCLYe7i7SRO4OEvJviCmWq9FFEDySvl7N1Xwd4O+J0kHxiy3VAlplBljATXeeaCie6TJEHhlU/tlOSu4CuQk0j08njCWJspxLGxgOOMLcBeznUVvAarnRyeqFmCqKqc79jYXQH6kbGo+oIdxm66ZTtqIZpnf3E+DxSihhRSlx2yKpuVV39X89OUL1eg9rOhtVfRJPrxjCA9QAqQilc26kDXPaMVC59fMktyDsr4Dw8HXvXW+z3MCuozkKu0irR4X1vekBV0jd4hkVBok81/jnFz44T7jhMW3qBKELFwrw8zBCSDTN1KulKAQ51mSDw3mOxBM668n258zAo1Xv8Cnew0RTZogHYVqhhM2SHpLdk8tI6YAQ20L+IgCUecGRGU96yiPzotb7pupq/ilG13r5p3c4dWNnr2zY3XVpKy7ANF5aZaetpdhEs3lxUaGk6rCZ44NQiHWQZ/K24ma+7EDKK8r0T7rFZIylVHBW6VLQoCTedUXN/ULAjd6EYHYpgz2kjJv5PogNveSxsN4m4VlulvOijQZvZS7U6am3e4UoOz+y5OdcaZOqdqQg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199021)(54906003)(478600001)(6486002)(83380400001)(6916009)(41300700001)(316002)(4326008)(66556008)(2616005)(186003)(26005)(6506007)(6512007)(53546011)(66946007)(66476007)(5660300002)(2906002)(8676002)(66899021)(36756003)(8936002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qs5U6TVnizWpEJmH0aN3HcG8RhUrvx3KZJyqgzuD8m27BlYOdv27q/4zSZZd?=
 =?us-ascii?Q?t+/JyBnn1yNb0Py5n2/Ey2EooFWJyGGqi24oyq3xhHDQaTBpyBNZzbRj4MM4?=
 =?us-ascii?Q?LjktBQ4oJ8XQXSepv3NGgFS2RL9gTdoa3OWpDTw3PIEJGt0OIo6c7MQSzfQu?=
 =?us-ascii?Q?wB52LExS33mbmNR1KjxGZ+pp497oMb0Ci1kNiOagWEVXi8ZZorngCJZ4Yqnh?=
 =?us-ascii?Q?HquYU5Pj8p8G+TWfcSCxOFAbEE6mK4ICX02Vl0YY5pTMwgbMVv89kDjZOMNw?=
 =?us-ascii?Q?7/dp6hXmYDCdjOGyl4a3bL1G7mpylNv/0WbmQYHL5Z9IV787456PHE+OQlXP?=
 =?us-ascii?Q?R4YZZOm6RqiA05ZWIEw0lx1ixA/oCUbu0s4unl/e70v9fFm36EpAXKnSHG+L?=
 =?us-ascii?Q?t3qzj+R1YpS3RbQguTjl4JIZjXQhbV5bUPimtcUY2wXWPdFGod7VHI/ezdpZ?=
 =?us-ascii?Q?RUhtZKBsAZcs3kOvCD2gFtM2JECdIENfzwvgRIdZTPPEkRTY3OS/a/6lB5Bo?=
 =?us-ascii?Q?9xJ0TeeXEP51NhDTOZcx4pNVhvWnzOtBtwXf+easoK+h0H2xXU8Uz1yRwfOF?=
 =?us-ascii?Q?w15f0TL6x2he5QVU3akzIYMyWmiyiw0fRz/CatHYfBkLfQSnlMpv7qMPSV0F?=
 =?us-ascii?Q?baZ0iI5o8zFyddnpR9crviJdQ9AUc/cMH0x5O7dt0lXRojIpTZ2Mv5FjZvbi?=
 =?us-ascii?Q?s2TBBMVIgibO1yAj7O3jRWZheHNB1qq4X5eFifo9TK/f7iTud/9Vg6y12/j9?=
 =?us-ascii?Q?jFv3AyfOYYCskrYqnbQ+qHESkIU0T2PEMJBvIqILC0BLuCPJ5fAz3Y34TZII?=
 =?us-ascii?Q?XpFXx5hphjySjAmhWva59g+TWvT4q627o/N6nj+bXRnpqqoBkqwd22oedtxp?=
 =?us-ascii?Q?e1MhoXiNyOKPE+OylkGnoUW9Icg8Dfoe1kril4/swobwzauxNiSlsZfkUpti?=
 =?us-ascii?Q?TorgxfFjB2hVymbsnMH7P7DPHhg3t9asFx597owDdkX0wkWXYqg64hvqzv/i?=
 =?us-ascii?Q?OQzjGoFsIEDxbLp59vFEHiX0gCQ1jxR1Nw8vQrGmjPjCRqE1HryJR3Y2MRvz?=
 =?us-ascii?Q?Z812bEMLtiBkAgLiQQI43+PpCi+yz7Ajj9uy6rWpFmtYIuEwkbStoTa3fo4m?=
 =?us-ascii?Q?+wGwWN5nDF+34q3CRMTt9W/N/4OuXjckOL3XLvzVIj9wr4bxllN4UNCtasL0?=
 =?us-ascii?Q?qkbEKTlE7gQ4lNUU0EXH5lnQ+Nzoh38BTQUnSC+X1xF6YfCnWhGBre9xyAne?=
 =?us-ascii?Q?F9ZlpRmboOASlYnDO3G4Ylv2F2ZSqKyUkFtn6VauY9RzH7zdTon1z+1iLN3C?=
 =?us-ascii?Q?wDH4QzwqC+bOQXIBhYu2+hsxfD0cXN4DltseOFnco8t3d5f9b24zFkksaCsE?=
 =?us-ascii?Q?Ey/zZ3TRcJ34H8I+/FWXsfmiWw26+602EpI9SVzQnClJvoUh6uaXz+usMHah?=
 =?us-ascii?Q?rSm/ksjbjhoXhxoFj0V2yiZ/KW7sfzoD4nwrhxivB3QqLjsZIjHNyqrVdU/l?=
 =?us-ascii?Q?bKgq0Iu5Omm+pg1mUnLlOBXnsjmhugI7Ujs8xqw/ehN1wdfvVJGJnwOHvv9h?=
 =?us-ascii?Q?uZ+Bw/OjN5iagjJ6iM08l8CQCRw7BqtNMbBiphvh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3070d111-a1aa-4bfa-27f4-08db402b1751
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 16:36:42.3961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xUtWteER+SDtsP+vXErXW78W/d/oaobctswcQnv4JV8mi+w/cSJ9VU+fvP7Y/puu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5022
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

On Tue, Apr 18, 2023 at 05:25:08PM +0100, Pavel Begunkov wrote:
> On 4/17/23 13:56, Jason Gunthorpe wrote:
> > On Sat, Apr 15, 2023 at 12:27:45AM +0100, Lorenzo Stoakes wrote:
> > > Commit edd478269640 ("io_uring/rsrc: disallow multi-source reg buffers")
> > > prevents io_pin_pages() from pinning pages spanning multiple VMAs with
> > > permitted characteristics (anon/huge), requiring that all VMAs share the
> > > same vm_file.
> > 
> > That commmit doesn't really explain why io_uring is doing such a weird
> > thing.
> > 
> > What exactly is the problem with mixing struct pages from different
> > files and why of all the GUP users does only io_uring need to care
> > about this?
> 
> Simply because it doesn't seem sane to mix and register buffers of
> different "nature" as one. 

That is not a good reason. Once things are converted to struct pages
they don't need to care about their "nature"

> problem. We've been asked just recently to allow registering bufs
> provided mapped by some specific driver, or there might be DMA mapped
> memory in the future.

We already have GUP flags to deal with it, eg FOLL_PCI_P2PDMA

> Rejecting based on vmas might be too conservative, I agree and am all
> for if someone can help to make it right.

It is GUP's problem to deal with this, not the callers.

GUP is defined to return a list of normal CPU DRAM in struct page
format. The caller doesn't care where or what this memory is, it is
all interchangable - by API contract of GUP itself.

If you use FOLL_PCI_P2PDMA then the definition expands to allow struct
pages that are MMIO.

In future, if someone invents new memory or new struct pages with
special needs it is their job to ensure it is blocked from GUP - for
*everyone*. eg how the PCI_P2PDMA was blocked from normal GUP.

io_uring is not special, there are many users of GUP, they all need to
work consistently.

> > Also, why is it doing this?
> 
> There were problems with filesystem mappings, I believe.
> Jens may remember what it was.

Yes, I know about this, but as above, io_uring is not special, if we
want to block this GUP blocks it to protect all users, not io_uring
just protects itself..

Jason
