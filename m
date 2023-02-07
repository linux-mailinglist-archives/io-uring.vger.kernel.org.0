Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5029868DC40
	for <lists+io-uring@lfdr.de>; Tue,  7 Feb 2023 15:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjBGO4G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Feb 2023 09:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjBGO4A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Feb 2023 09:56:00 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF935126E9;
        Tue,  7 Feb 2023 06:55:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wc34L10N9d4FJPSsiOTaC9N7iXL6Qc0jzdj1/CDwmoj6mGDtdoOIPo9LyHAAJ/cZc7+XCAn43SwewS3rf7XnzERm5cv616jHdu4Rv3Tq5L6KMmQRxSWwq2csrn4UON+79neQ/PrCHbtqTBWoWxjR5FrW3j+c+5WCJntNowoW4X+pXfpNHkWNTfCc/tu5CHTzF2ra9AqcjHxXl3MRBa8LR9/I6bQHxN8iaWcpDg1DUB2zxXNxPrD//OWAMIh3yptjurrPBICMMbiUU/8qvMU1v6BzhjFpzjnMQhqLIg0sPTkuA48sP4pcb/W84l4wxhD+H4AOKWbgD5NGklnHLdez2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AaOLENurDLVnSrw9Yc9XhqQx5R/WT/mqqywhrEJHFYs=;
 b=OkRfTJ68p9PkA/ZuChTFMp3b6NZyZ0h7p+72aEf4vJymOX4h+L13L3VUeWaNYYFlp8RasGKtsSiPolWpnILCM2XMuIiNalQ36sLd11fYfT6kNfIF4luugtnHEe9HfW2935jCQTLlkbWL5LEZQ00D68gCoNy/Ou0/gPFgEkS29bDYPbSG1dEt7NuGGGWWZwKTcNwiEPa7iVqCZHjlAnZjgHJd+xE7kh6FrY1b9UWhqb21BTLchwui8D3j9/5IAMohtSgdYoKo74LMIW2BtgVsEKJLjocwqCkHoSZ4q4Ui/pe5+AZjWjWRBJmCUKMukyh1sQkakcjLE1phknDwaXRyow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AaOLENurDLVnSrw9Yc9XhqQx5R/WT/mqqywhrEJHFYs=;
 b=cW3mr57zpmCOyfnsv4+t8Bc6KGhWTLkl5Y+K7yPicWsJ65N55CS5eTA3bKY2IP7sezTgcZyOhpd6KbY6t5ZzciFSN48VX3ReQAzKf2LY1zlDCbRK2QiDCOXTehdwOpwbBEpWLNKuBaGegJTJLCFQWciT9P0she8WQavTfod6f/VsJQZdHJ61PspI5IJ32cq1L3gc22HRqTQ9Y5G5uyf04Ao5egF2V2MNaK6mUnlrqrcfYg2LJtCNwIIrDvgS6PrNODQUFuZ7xZjm70zmCp8ln12+2bpQZ58btQBS4GeVM11CDJ4LoAN47ty/Kh3ubYSOw/vz+QI7PKQy+f7GaPQhkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7874.namprd12.prod.outlook.com (2603:10b6:8:141::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 14:55:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Tue, 7 Feb 2023
 14:55:49 +0000
Date:   Tue, 7 Feb 2023 10:55:48 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org,
        surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 09/19] io_uring: convert to use vm_account
Message-ID: <Y+JmdMJhPEGN0Zw+@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple@nvidia.com>
 <52d41a7e-1407-e74f-9206-6dd583b7b6b5@kernel.dk>
 <87k00unusm.fsf@nvidia.com>
 <eff3cc48-7279-2fbf-fdbd-f35eff2124d0@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eff3cc48-7279-2fbf-fdbd-f35eff2124d0@kernel.dk>
X-ClientProxiedBy: MN2PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:208:23b::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7874:EE_
X-MS-Office365-Filtering-Correlation-Id: c310ee7b-eef7-4953-1536-08db091b665d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LGZOffktNrlfW9IV0eMfqPENxyaTQRqyv75eh8DnfhqrKzrDqX+vnfaHbF/mR212zn0NJjsgw1MsCVLGzZep+dei+SFCH3dfIGm1I5vR+a0Kl+JpBJFWVJwbxQ5vVfbqDBzAqyzrGvds6yn1dGScHX/+vSvePfMv74tC++9x0cUGAdirjY2pcCKBkkeN+wdEYYzMc5KxTQKIQzHam2mA1pEofnRDNCIOQwwbKGtN/3k3YRhVEzy5EBoEFC3RcRZQkUu/AkymTNazJ4yrTaqvHpKmu0NtZfuUpjJQkn02uLDlD7B7m7UQtzdCv1Y3UOyMfBreTjF9tqZaArSGKKaikdbv8DlyAntYV7VcCkzMvpXKZhOv8hMEsxOim3GSIHqF9OeodqwYvRZEbvKGA+jWVoXnB6fyyYO6+eyBFjMSQSlyHy0TYZts10MOZ7qW5syN39Vyo2xwDdkW3k/IgTKgGlv7e8HL+Af75XiDImmrw5rDtd/5K36n0GRoHfMWxxMdpDpzYjTW9sKg4SiZ/8avU98DM3WUc5TYVNKAMIgIvFRLvyYMJSXTGMyX22D56IhpssMSElwywb50RwhmJ4r5ZEtXjSj9IetPIXcc1DVPiyr6hVkwHweyB71VF8/o3oV/4VftWo0kFy0cDv/86m04kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199018)(5660300002)(4744005)(2906002)(36756003)(7416002)(86362001)(8936002)(41300700001)(316002)(186003)(54906003)(38100700002)(6916009)(6512007)(66476007)(66946007)(66556008)(478600001)(8676002)(4326008)(26005)(2616005)(83380400001)(6506007)(66899018)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v8+dojwfK3vQbmyoSC7XFNlANfA4r3Ey7nd5lnjTKv/4Cg1yhMJLicp3IeQc?=
 =?us-ascii?Q?AA2CEjDQiiWkwyZf+0B2T0LdXoM0zHnD9Ac3Fj+vg5a4q3zOsfpabpG0NP0V?=
 =?us-ascii?Q?yKsf0a/m2qsg/U2n+IWsdbZZKDqiMzSewJpEBxyCe+0LO3ZG3LwqdFS57+v8?=
 =?us-ascii?Q?v0VU1C8iEf00x3vSBJx/t3jQtGcMRq7VEdJKxoR7qzsl1Iml14t1UO2bsDDb?=
 =?us-ascii?Q?Kdfw6ZR2WZSF9euxwdOFbPMerAEEdr4i/YS3mVJ07OewdoQ8PBKEqJPb8QZd?=
 =?us-ascii?Q?PzMomKvGNd7apTQVNPdPmlLIHai4YnvVe13DqEFpQ06KEr75+BXdRtDw3wWJ?=
 =?us-ascii?Q?0eHDCe/irRhzKqRBkkVcV+gKpk/MVjqvCc6aXVrB9RXnnuDme2Xy/S8JBr56?=
 =?us-ascii?Q?hT1a6ul5vIPqrwVeFyCgCFLtMLTF0nhL8oqarzBZUf4kHvOtR1a13SI5wcsN?=
 =?us-ascii?Q?9tGW9y9w8MFdRpul64evwjBGSFKxPor7YMTDE8gv5U1UJrAIdRBXYrCmrNvz?=
 =?us-ascii?Q?QBhLN2n4xFEkIboCuGBS7NtuB4wVkQqnqjhdPlfGtYxbq95Zh4he1CfQWCFn?=
 =?us-ascii?Q?2qiQKHMSdWk3bRZYKYMLn4yV5FgCu1jGQ+Qk/IyUnCpNJvdsX7oU+rWDVMTT?=
 =?us-ascii?Q?b5ZwOE6nv+EUbbHkX5cILetyyLrBHRBDeS0K7nJfgrOwE+4f/NYc4GeWseSS?=
 =?us-ascii?Q?2gy6DqcQci0PkKE043MjlmuAWHfm3ICaJdT5mrWj8bBWH2iRG3PTddM9JToS?=
 =?us-ascii?Q?lTgAMN+lfqypMqzYyUw0kiLGTGY2VKSv7Hi1pYuCAlkgouGpgeoKSsR9VaaS?=
 =?us-ascii?Q?ThqgOjmIRg1FrH4NwC18RnfMBK+t49BUYT5vX7p+J012Ruqnxcfq4820IGyh?=
 =?us-ascii?Q?D3BkmDg6eTvKfuR3UsHF7tYpTiOOSF8o15PO0cCJEkkmrpF7IuboX5f+j50l?=
 =?us-ascii?Q?SsqbTpITwl7gyGJeksPzPDZVMX38VsWTCWvD2X4qwQ0TVVoqUqfLWU07OpR0?=
 =?us-ascii?Q?R9nc07H7hAEYI5O91st2ryzkpBMAwGSO6ncT2zJJRVWZOTamnJXdxIP8wNqF?=
 =?us-ascii?Q?/rXU46h2vOGxxJSDNxh6oB8iG5pzR5E+u5AOoZZwCf1R885UQQjbaZ+hsjoB?=
 =?us-ascii?Q?df9nrgcAiyt2RtXgd5ZF0qiFzrNCxYKXQjfALgzqZ0uB91hhjnV4+i0fjPAI?=
 =?us-ascii?Q?zYxGEy8HF8+N7Rahd2yHjEMOdGLoENluqY44y4M/99n8g/l5pNDsbax32kZt?=
 =?us-ascii?Q?IHjMUOKJlRzdYIOcxhp5D8e4As4wWFAFuU3tnsAzAye/g8xHZLivgQxLUNVn?=
 =?us-ascii?Q?LN1GQqqVXTopUhj9bmwwIBVlwiVkINBCedj030O17+PCQ+M0HsLVa5vy6W7R?=
 =?us-ascii?Q?7DGiBGIq9v3jqvV9OO5uDfyZnkNkbmocaS9UIhH4FByT7aCQ6TSQSikoiWOM?=
 =?us-ascii?Q?shOGQepexalrPDf9/SKXR3sb/mxgiZo1zsJAv/3X+LFmIjhoe9LaExFEh7+I?=
 =?us-ascii?Q?g31BHkqOefiSlNAubKSWBg8arHXRNzmC3ODZGPSfqBgn+6WtPH2XyzOMIxOZ?=
 =?us-ascii?Q?YKHwikn+IIfCemO2eAUGWPp3k+bBPfn08O7/Qe4E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c310ee7b-eef7-4953-1536-08db091b665d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 14:55:49.1075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ieEMflrR2+0Mxi7ReO5EKqlJ9irYdqDNketM6XqDgr8Rq41/HjYbd1VXx547D2c6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7874
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 07, 2023 at 07:28:56AM -0700, Jens Axboe wrote:

> Outside of that, we're now doubling the amount of memory associated with
> tracking this. That isn't necessarily a showstopper, but it is not
> ideal. I didn't take a look at the other conversions (again, because
> they were not sent to me), but seems like the task_struct and flags
> could just be passed in as they may very well be known to many/most
> callers?

For places doing the mm accounting type it cannot use the task struct
as the underlying mm can be replaced and keep the task, IIRC.

We just had a bug in VFIO related to this..

If we could go back from the mm to the task (even a from a destroyed
mm though) that might work to reduce storage?

Jason

