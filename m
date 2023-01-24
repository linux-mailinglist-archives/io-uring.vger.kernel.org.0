Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0132A679C45
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 15:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbjAXOo3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Jan 2023 09:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbjAXOo2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Jan 2023 09:44:28 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C748EC9;
        Tue, 24 Jan 2023 06:44:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8/bhQldsxQYt6pCXdDEGy8hvlGgC4tH8eaA1OuT2C8svSBwjS6n+AkPCzAIciXI5392wjfD0nJmvGVk3vz0pfJFgc9xPreT4qYc1ndHRyjGI7KpwVB3pM3JsxIfm8SRAkoerDTXaojjAfIix+FKl95S3epmobHIRLNmj6W+Fo/XfGnl04kAqeEou7kO0zhmdMxpalPOHaifQukn/TAFqWDZz50COgz8kHowTjEUuOD6RAbb76MhVViwLGtvhTckepV4Jr24RtnkkK+f7KVqKLCuzvq7ONsF9N8iZdDyxw4gXNPQtX694ZCA+t0dRJ1egGSPUPndRJgVb9ggPLTcXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IRHm2/zQ+7v5wmZb/FJyK3YCzESK/meL/Gv4ezwdRac=;
 b=jhmiMB5duHSx8WMh9J7rNQQPzt/Ai5ZQLORGgh0Q1OjTe55SzjLD1K9wiJnjBYZWauacIS1Z4H6IiZR2rj7eGvaBTnlf8Oe13xxOfTsfkpwN+sArtfydEvXLA7SODtsF5WymjZAJhqa3xjRjzKgqqY5ogy4+d7+GBbDoT2LHBz4y2FEaFS+42z1YOTxSzO8Fw5MgyJMuKSSbPcTlQSsKdx4E97TqCkPnbSVw9gw05ZC4LARonW+aI1m0A//g2X2SWtSZ8d8430TZzzmNVNPZucGl6ogAI17XZzf+AkfbSBzjoP13GKnltPR3kc7qxcs3epSokljAI/veDQoLOtodlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRHm2/zQ+7v5wmZb/FJyK3YCzESK/meL/Gv4ezwdRac=;
 b=JWSCAIs2SFD9upzteUIafUKRRpzcn3pDuQSqrGdqbl21L01tY5qvxi1ghbkKU3pbGqwGqr6RSy0SYPk8jS2n4kqpbJqamP8XTjdLNU1h/N2rm8ny39wSkDvEui5zB4U3wOTQZiQyzKhEEntFh8GF1ZFphaGko3ujSdm/i6eVeo3yHSvUSQ6FX++hVYyWXX/Gt49w7m+O4pX5rgT0CLFltvL3iE+klIKU6Ddlh//k5MGzbKh6YRrVNiJ2Yk/vyKjCKJwsHtoST+qbToTM/F2pZs1phUbX1W3q6qmaQ0F6xWbHu+hpgUYlpz8g6mNYmvfbjUz5bnxFGmwOQUm2D++WkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4195.namprd12.prod.outlook.com (2603:10b6:a03:200::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:44:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 14:44:25 +0000
Date:   Tue, 24 Jan 2023 10:44:24 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 09/19] io_uring: convert to use vm_account
Message-ID: <Y8/uyBKHf5XoXvTW@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9f63cf4ab74d6e56e434c1c3d7c98352bb282895.1674538665.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f63cf4ab74d6e56e434c1c3d7c98352bb282895.1674538665.git-series.apopple@nvidia.com>
X-ClientProxiedBy: MN2PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:208:120::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4195:EE_
X-MS-Office365-Filtering-Correlation-Id: 1472bd8a-deee-49cc-aae6-08dafe197d48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rkAM9kOpn4CTZICxZ+gC32ARE4eKwzGXjBa7IgcVXwiGi4bZ81drBDjRSe3ayfiWvf0h0lLqZolipQ1W6lUApTo2m+80yCIcgMBcTvm2qMkO5DPl8WZX6oIbvSoO7jDubVjNOXyOD5oDL2LhJl54BX7zn1e+yWFurmcNa4S0hZdLAa/WwXM4eUrPhPxfrnGE6ZLab0etU+BmxvwMOG3nxuLobZ2fevMb+KTJzJVma54sAuP4VLnmCzNd+7MshfpvTEL5ENOakNYbZlDjvdaNcQEjaZzVSl2nShghuh3Mb94IbBNybMkQ35ALGqy8+UPiGahAOKJyvlBg5yAg5LL9dExRVZEJ4apaX4VPuEzwJzy/V0GSNtj70nvokyk8ZhCv+l5JXZNld9MY9ENcVkDQzIwcXy9MWSnRA2xXEu/TmOgTS8mdQCRLJNOTK6+22F/dX12AbRREUz7jJXmyPrvWyhSWpbVoqErBElSosRcCeKWnDUFVYyEGTDKsz66ddAltltX58x22W1zZnn1Qx+gd4tRitza56vBLMpf4LCXiLBy6WkCyCX4lJbf7k31VQyDoRqmfupDqFTV4/qhWouDRBwlmCGHlwQIoBHf4oVMZDH28ZhCMuyzXgyWZmH2JBo41GZ8roaur2lIlLjqey1jaWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199015)(36756003)(41300700001)(86362001)(7416002)(8936002)(5660300002)(4326008)(6862004)(4744005)(2906002)(38100700002)(83380400001)(6486002)(478600001)(66946007)(6512007)(26005)(6506007)(186003)(8676002)(316002)(37006003)(54906003)(2616005)(6636002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+bb7f6BgOBy6VjWf+jh6VJ7WrjD2UrL2H8Kf5uJZ+sWf7e5EzN9yJU1XVWPT?=
 =?us-ascii?Q?pjGzsCmXmy0X4ffr/gqAmy3KaNYlHRFCsZR8tOltaDEtmCpSrGEjbdDNgPpY?=
 =?us-ascii?Q?enagC4eVTi/gMzmo26muGRnqCZ9xslY/eB6gaTG70YJGAZmTjXc/vciFSxHN?=
 =?us-ascii?Q?AVEfP1TWZjvrX544jmb0el30WZYZcvlfJVpc+TncKZfKPXx6qaNFLU1Wx2Gw?=
 =?us-ascii?Q?cbZDKHrlI1TLWVrg0ax0wYFdJjwOzrk+9wbsMglPrH98+DytlgCjOQYZzPc8?=
 =?us-ascii?Q?m2jyDKUpJylErMCNAwKXFFYI+Wh3Tdr8h2uDZjJWvB9JPpcnxvOJRxHaPA5k?=
 =?us-ascii?Q?LPIph1NhEi2mpdZgmqOdfnomXehNg+wEliyhn4OnZ7010jcpkIC09W/Bgkko?=
 =?us-ascii?Q?HflqQP2jPDKwYBuLek2zMK2mjEwyhJUu6XpoPA1Uqg7hoFyGj1OYZqcZrjGp?=
 =?us-ascii?Q?wuFoKqO4e2cnWqrTqYU5toV8d3euDYYUCq3f2cb8RK5KdQb+rXXHx2hV49jl?=
 =?us-ascii?Q?Nf4Ktj8q/cXl4bOBzXdMHr9Akur3hzbQWLRZvSSz3Mk26P73G74mHgmHQ3ZI?=
 =?us-ascii?Q?k+JZFjnE72PoL7k/P3rMUNrtw9V0nAbrkScSWRPAwegqeJGk8AFpDK2GJBm9?=
 =?us-ascii?Q?PHR5SusTwh2LbKmZOpv9l8Ty+yBKty5xKAvsuQYHYLZGcqW+oYyRmK4wbT4M?=
 =?us-ascii?Q?7QuIx59c+8DWgspT8FWg92+VjfGlMCrBJynzU55sEXMyqWgjcMqVKe94/cna?=
 =?us-ascii?Q?SYgSbhGQe3fHujYYxBsxhUBEwyT8wqOdOpbFo2XHYjrj/MOCPJK01lupw1pt?=
 =?us-ascii?Q?RqqrFvAG9sTH2xvWbgW1cNj8gFtbx4fmLGsnf/6QU57U6ksizdzxI1qyIlpV?=
 =?us-ascii?Q?PW6+7FwMMgJmA1qHTw4SKNt0XczDXldyEEweg7MRyFCsndiJ/GfTkP0GMCSm?=
 =?us-ascii?Q?H7FlbWJmAVp7g76N5j2StrhQxjvVpo1C2zsKNVF/jCdX86Y8x8NVYnDy8n+D?=
 =?us-ascii?Q?h394Sw+wlx3R0R4GcAHOI7tFUeimdPaNW4LCSCFd4ErF1pJpxRtCGrth7fbc?=
 =?us-ascii?Q?bH6JNI+8ciVe6w77oRwPAkIdxvhuFh2yKtVJQ/2BSNPwtxJ+JY1wYdMyBBly?=
 =?us-ascii?Q?YMg7neD5av133MAsUyVnQ5yMDzKyDH6qH2Ed3ObG/wjLkuS0HgTYPivm7MXm?=
 =?us-ascii?Q?I7eUA0ZZlLMoPwks2HVEJ69eMTGVDzuA7pz7vUwf+1+yY0dWM5yPwV11SOp4?=
 =?us-ascii?Q?Ssmcu15dX7GiNYd5cG89ULLVAkXZpkYB8MwMfjcNxeNILerJH8WVz5aQF83+?=
 =?us-ascii?Q?T6LXp8JjFwmAyBHpBXb67dcGh+ncM7r6bhACHi3D2qtK9wHXcO6IKFneapGO?=
 =?us-ascii?Q?Rns8gRKHsBOat8QfYLbfSwnFdUjZg7uASm9xGh8oSKBAbBEbN124jJIR0YfG?=
 =?us-ascii?Q?YwnP2iQ75MyBMJ8FDqo5V3z6BB3NrnDB0eF7qV59Pp0Qf9Bo8zz4Aoz6WsKP?=
 =?us-ascii?Q?bkCFgzFK/zgSO/cdRKMBIADUuF3aA4BJS5N7cl00ZBRzIWMmw0QjjPnLNS/G?=
 =?us-ascii?Q?JD5ClDzmXLxMIMer+OvGo2S60IvIHZA5S3/Kzda7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1472bd8a-deee-49cc-aae6-08dafe197d48
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:44:25.7305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hAO1JluyH5dqic/CttkROlav6uFFjbcF6ThHDJM/mc5FXp8arCaWxIwOlYey8ebR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4195
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jan 24, 2023 at 04:42:38PM +1100, Alistair Popple wrote:
> Convert io_uring to use vm_account instead of directly charging pages
> against the user/mm. Rather than charge pages to both user->locked_vm
> and mm->pinned_vm this will only charge pages to user->locked_vm.

I think this is a mistake in the first patch, the pinned_vm should
still increment (but not checked against the rlimit), though its main
purpose in this mode is for debugging in proc.

Jason
