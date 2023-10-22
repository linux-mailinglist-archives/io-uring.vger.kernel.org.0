Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC2E7D2591
	for <lists+io-uring@lfdr.de>; Sun, 22 Oct 2023 21:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbjJVTGh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Oct 2023 15:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJVTGg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Oct 2023 15:06:36 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2072.outbound.protection.outlook.com [40.107.212.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B69FF2;
        Sun, 22 Oct 2023 12:06:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqWnu9V41NSi0nySSYTXzuKSMK3yi8RARJL0O4IeBeWrXN3U7GCVtt3pyg0LX4xvrhgTBsBTf2cmcxAsu+Jpj+NVtd50R39XOh+DKk8/Q0s4UxgFPy0Mn9xRt+MsdvxeAsaPvihNuzcXOv6mBZCVp22EJo8eMYID+2R7wQEHM0Wb9gYGy+9VnOmjOwu8ooWdBtC/GJkvaeRwLain/W9Xa8YLBYzifEJZ7VrlgKaDAZ1ZqMigR6gplj9eC2K95H7UOiqDfhuDnyRbVak5fWNtxwf8U+SkgONtTAIZdH3E23TuviCpTftE6kR8lbeVp0KJZghEgzsuPSL+iV/cVOJ0wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcpvUX1wvVxXxiQyFny6niGKeJaTGBoYpamCTQeIJbI=;
 b=dvM+D5v7lVoKnUC/WBnzf9CEWUF2PzU0O9o4jFbU3ywEBVMGxE8KOIsuyNT+fJ0yWyGJS3mm63oKGYsq52pb13O26n8wx/jcbbPvlh2D09zjfFKvwRLYzXGyosYjO7KKZ3bxcYUfNNMNxHVBbt118bxadUmWlboqMhp8R4gizq2uvmqLSKdGdm9APT7VcNujCGbX4Elhjd3ksPwsIDnwjatq29Df/orCpMIWyefbSbRGDOCQscR5SECv56zAQUOeipQDqNAkkzgG9wOoskrWXlFgKeFkv+KtOpjHvTJVlEkhdZ2o/vxys4oreGMsNCcW0r0jZ2UAZBldtjNASF95Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcpvUX1wvVxXxiQyFny6niGKeJaTGBoYpamCTQeIJbI=;
 b=Bb825LN704l7ibTvVAmFVzikAP56RhF7gA1GvSIK26W/I6VBJvehJHWPw9u50bPp6zL99Iwd/+nYOwqfOv6EV7OkdLo7933ssvMzWFQMBL5TI59K9yy3kgbiznugtfnjBEG/pKaCyPGRrgtKRyDKWxJwaVIftD+ycKQwBxyiIuwkWP/atJsFTSTkvxdWEKQ5d3+7CZmydmbd7CGTq+FRc0JmQBb9L7sb4PaQoGDTgaE/rBx1FA091uTW9kpeo6PWtP6BEdRnDH+o8RfBHGNgKB8D/JeiN8gB9bfgVQ8Z7Y7Jn8oahFtcgMuFz8l4YnmkcKUV/XZDltqITrSniCXiFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 PH0PR12MB5417.namprd12.prod.outlook.com (2603:10b6:510:e1::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.31; Sun, 22 Oct 2023 19:06:31 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2f76:f9ae:3051:7a44]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2f76:f9ae:3051:7a44%5]) with mapi id 15.20.6907.025; Sun, 22 Oct 2023
 19:06:31 +0000
Message-ID: <1673427d-b449-4f9e-b344-027c0dc2ec9f@nvidia.com>
Date:   Sun, 22 Oct 2023 22:06:24 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND 00/11] Zero copy network RX using io_uring
To:     David Wei <dw@davidwei.uk>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230826011954.1801099-1-dw@davidwei.uk>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230826011954.1801099-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P265CA0007.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::18) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|PH0PR12MB5417:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c919382-f52a-4c5d-a77f-08dbd3320039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pHJ3kt5hkggcnDYjNX6XeVJTMPlO6jh4hNL4Yi2Z/cudzD+w9EY4pQ8tZPto+tcABkTE+s2Wx3ma13PiGXSoFO2sJ4uu9OoxNe6dZ0Og2hs7o3EApkLbzgRwVn4jYrUWSnKURb2SYWHyusZktXqXMQD3FvKtAmR2IDxWr80/yHOkuGGwi1ZZB4dWK5JY+5KzikEdOjnUOdoUUJyb3C8LTUycXu9+PK2nKCMitahsdUXGaQxXX42P8GDfVwsham9DxZI0UC4usjLxt95I7vPDPRbFfHKE4QH+O4sQj439XbIaEjmwsxUrSbyU9o5Gp4hz+rhldTrJ2F8T9s6XtdRIBLkfH2q2WSX0TcgudkUmXCrsXvAFzVey38PnvPP/d1vfkFLGmytQAY3dQCIaQ5clvUCnmpRPAgSEr0g21MNVvE+s841BD++SCBEhB6PFXhAk6ES9GYG6eV2uow4xbrZ3X7P0OfREoZjXJ+FZNOs7i2PEYueuxtFy+Z2aEi7tKORmYEpBUpNn5FHKxGiCa7AlvTq29RUVtYarpdlDZLx1Jb9MC10Bqq+TUyH1PWbbO3xtA6qi1qx1cYIhNXaCdmZFb/TrpZelHpKbg8rjUjZJMDpu4wSMWfi4PECrSl5MgP4eTnt9NUtcn5UdePRv+48hpnuxfESUd9TVweGlAQ+IHiyhHKg3W6llIxoOqbeCydJfc8zaGjemhdP0FB6lYFGASKiD2MPmPk5ZCYTrJh59onY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(136003)(346002)(39860400002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(83380400001)(31686004)(2906002)(36756003)(8936002)(4326008)(8676002)(53546011)(26005)(2616005)(38100700002)(6666004)(316002)(5660300002)(31696002)(6506007)(478600001)(6512007)(966005)(6486002)(86362001)(110136005)(41300700001)(66946007)(66476007)(66556008)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWt6aG5tVDFiYlVtOHdRcHp3Z0s0TTF1QlJ6N3VFN2pBQ3lvV0dBbGswNzMr?=
 =?utf-8?B?RE9tSVZYUVFxRkZ3L1lLSmdDMXdSUjhMSXdLWTV5RTZ3UGVML2srMzRLUDdW?=
 =?utf-8?B?bHB4U25Fam9aOGVldXRSRVBiekRSYmZMU0ROblV3aWZXMVg3S3YwbTlsaHBk?=
 =?utf-8?B?eHppcG9DYkJXbHEyQXhtUytLdzJpVXdBV3NLNGNaRERpZjI2REV6RzBUczVO?=
 =?utf-8?B?OUZaYjNkdUxTSE5PWFd3NGZwWVpRcjZTN0lkY1Bia1ZZR3NlQmt0VTE4dzgw?=
 =?utf-8?B?Q2gwcWtmNTdac04wOHZBSG5ETGR1MTlqTVRKWGtXMHFFNXRjUUpXaGlZb05O?=
 =?utf-8?B?RHYza1Z3UXN2cmpBaFpJQjN4aWNvbThXY0JnTkszQUovOE5ad2IrUGhFOXRj?=
 =?utf-8?B?RzQ5azlPQjM5VWhRaGtmZVkzNnlLOE51VnV1Vk9hT3p2YURpUS9zYzF2R3Ar?=
 =?utf-8?B?YTBnTWdhckl2U0h5L0U4L2VBM2ZkNnBuUFRSWGpSc2huYjBsK2NjemZGaDly?=
 =?utf-8?B?RFhFTkpJaWhOc3VvR29KaUphdnFISEJTNkp2N0JTL2t2SmsrVHp3YVpxaUNx?=
 =?utf-8?B?REJhUGtjbnh1S05id1RpaHhVcit0U25lSnRBeWt3Ky9JK1lqK3ZYYVZVMGZz?=
 =?utf-8?B?MHRKZ2JzWXFEZkJNNHlieFJsaFVhRktuQWxJbjF5Z1VGbitLUlp0Qk9nd0Q1?=
 =?utf-8?B?ejZTK3pEdGFIRXJPQ1A0Ni8yV1FTek94NEp1TFZCWDc3Nzh6Nms0dmJDSUZ5?=
 =?utf-8?B?bi96aW5KMXdCcm9TbHRjWVpMZUxnQlBUME5zalhxVnJMeVRZTE0xbDIxL3hj?=
 =?utf-8?B?RHk1TXdVMUtoRzlRL0FwYm1tMldvODM1a25vemVERHlKVUgxK0szbkFHVE5I?=
 =?utf-8?B?ZXBmVEo5bldEcVR2QkZsYkN2aFQzalRxbUtDblJoSEtlN2Jacy9HR1J6NmhN?=
 =?utf-8?B?N0FOVDdPOFRrcWpNbFQ2NXRoSWxKZm9qQnQ3ZXQvZjU0UW1FWWFpVk0xcURI?=
 =?utf-8?B?aHVnMU92YTM4V0N0WGVRYkNQU1o2TnBncXJHQlFVMzM1a05OMHdPK0R2UWts?=
 =?utf-8?B?NFRwcW9WUmcweTFVd2cxWGs2T0ZJRzB0cWpoN0d4bUVsRFJ2WVlWR0lQRWlR?=
 =?utf-8?B?NmRrZmwyTVgrZXhmRGRleUd5Q0xMWVkzM2Y5YlVsQ00zUWlDc0RTSkJ4Ris5?=
 =?utf-8?B?eGdCS2kvV2xmTDA5eWU1SExKazJpMzMwZUQrbUdFYWNUREQ2T0tadjNCb3JO?=
 =?utf-8?B?MHlGM3pUUGZkOG9STVcreEVESmRHNFI4aUxvT09tbW1YU1hhRXl0OWRwakJG?=
 =?utf-8?B?Z2Z0NWN0K1FUa0RTTk9aMWt5Wm9nbG0wWkU0T1VlZ0ZBSHpITlNaeE9Rbk5P?=
 =?utf-8?B?MnJFRm9OeU1CN01EbTlLdEVoYWhzY2NNSVRvSnN2VUVmM2g5L2hiZGxwQmJO?=
 =?utf-8?B?YStqRjRxRm80UmhSUnZZaW04N2tCT1BWdGtOUjJLMURERUNiOENES1BweDE3?=
 =?utf-8?B?bTFZNWxhTS9mZmFDLy94cExjaVlGMzdMSStFRmx6UGhJbEMvWXBqQzJvend2?=
 =?utf-8?B?Z0pTSFRWVHppQWdlWmhmeUxWMDYxZVBUSUVJQldjZWp1RVhRWkdDQUxGdVl2?=
 =?utf-8?B?V1ZJRG00RGVKU0oySXJZQ05LeXcxVU1QeHFFa1ByMElZdXk4bDdHK2lmWUVl?=
 =?utf-8?B?S1JEQkt3QjlIcTlNMXF5OXZnRFNwUm5ETUhrMVlZOVZLSDI1aDkySDdINlIx?=
 =?utf-8?B?di9XQ1UrT2xxdlVvUWVPZlNuTGF4UDVMR0tXYzZMVTlPS0VEMjNKVTlTeVUv?=
 =?utf-8?B?UGhaOGd2RGZzS2FDaUwwTXByaFhvVHRlUHFGSzNSSlhMWWFiTGpJbElPeEVy?=
 =?utf-8?B?c1R1WjFXS1gvMm5ES3ZuKzUzcUwvWkZIaGczdVVQbzE2ai9icHpHd0hDaURW?=
 =?utf-8?B?WGowVmI0SVVLVFpiUHc3N1dBN3paVVgvWlRPRU42emFCTTd6OHR0ZDArMk9B?=
 =?utf-8?B?aDN6K1UxWDM0MnQzL1UzRHZndkt4aHFIUnp3WGdxK09mUGthQlZKQ05Ed2JL?=
 =?utf-8?B?eEx5c280a1AzUEVxdEk2MVdXVitCLzBuUXJ1N2wxMkZQUXBxNUNlQ3VIMU05?=
 =?utf-8?Q?NcoCnTVJH4XIwTt6u0h0b7vkv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c919382-f52a-4c5d-a77f-08dbd3320039
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2023 19:06:31.5074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5zsxyHmXQnCP4Bcaa4MkEABhYlEp2k0UMOSNwxm+TyiCY+rezbJ+7AXJUzMHGzt1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5417
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/08/2023 4:19, David Wei wrote:
> From: David Wei <davidhwei@meta.com>
> 
> This patchset is a proposal that adds zero copy network RX to io_uring.
> With it, userspace can register a region of host memory for receiving
> data directly from a NIC using DMA, without needing a kernel to user
> copy.
> 
> Software support is added to the Broadcom BNXT driver. Hardware support
> for receive flow steering and header splitting is required.
> 
> On the userspace side, a sample server is added in this branch of
> liburing:
> https://github.com/spikeh/liburing/tree/zcrx2
> 
> Build liburing as normal, and run examples/zcrx. Then, set flow steering
> rules using ethtool. A sample shell script is included in
> examples/zcrx_flow.sh, but you need to change the source IP. Finally,
> connect a client using e.g. netcat and send data.
> 
> This patchset + userspace code was tested on an Intel Xeon Platinum
> 8321HC CPU and Broadcom BCM57504 NIC.
> 
> Early benchmarks using this prototype, with iperf3 as a load generator,
> showed a ~50% reduction in overall system memory bandwidth as measured
> using perf counters. Note that DDIO must be disabled on Intel systems.
> 
> Mina et al. from Google and Kuba are collaborating on a similar proposal
> to ZC from NIC to devmem. There are many shared functionality in netdev
> that we can collaborate on e.g.:
> * Page pool memory provider backend and resource registration
> * Page pool refcounted iov/buf representation and lifecycle
> * Setting receive flow steering
> 
> As mentioned earlier, this is an early prototype. It is brittle, some
> functionality is missing and there's little optimisation. We're looking
> for feedback on the overall approach and points of collaboration in
> netdev.
> * No copy fallback, if payload ends up in linear part of skb then the
>   code will not work
> * No way to pin an RX queue to a specific CPU
> * Only one ifq, one pool region, on RX queue...
> 
> This patchset is based on the work by Jonathan Lemon
> <jonathan.lemon@gmail.com>:
> https://lore.kernel.org/io-uring/20221108050521.3198458-1-jonathan.lemon@gmail.com/

Hello David,

This work looks interesting, is there anywhere I can read about it some
more? Maybe it was presented (and hopefully recorded) in a recent
conference?
Maybe something geared towards adding more drivers support?

I took a brief look at the bnxt patch and saw you converted the page
pool allocation to data pool allocation, I assume this is done for data
pages only, right? Headers are still allocated on page pool pages?

Thanks
