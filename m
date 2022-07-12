Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45925713EE
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 10:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiGLIHJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 04:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiGLIHG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 04:07:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B749E44F;
        Tue, 12 Jul 2022 01:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657613225; x=1689149225;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=clO4JDP3lUx7gu5luqJ+YFaJgLNvOruzhKIq4tHqfLs=;
  b=cnwhwCL/aSVYYAqVB60pwl02LOextqwP1fxdHlETHV+hhK4StIAt9zKP
   T6GDRxkh5ptwqYGG4X1Ab50R4OqAP32mJfiScTtAzJai+6ZPcXf48i7GZ
   l6AoUO0PZSv76ozzVu4rxC4vKApxetACXnPxOK7lODRaDA1oLjAw9rPGa
   2MV5I0f52X1dpH3wcsP9ZFFzvm71XbGKX9IGG9LMP95moDYx/GAnJSzEg
   42Igwjg6uM5/J7P/kyxZLVUXka6U49RAZm4ZXcscVPLpzJwjiew8hkwlH
   V+3PZ7DRZiZx/fbIuYWASmwC1DYXZQq+BkqgqPG+H9OBp77pLD7qK6IAv
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="284895922"
X-IronPort-AV: E=Sophos;i="5.92,265,1650956400"; 
   d="scan'208";a="284895922"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 01:07:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,265,1650956400"; 
   d="scan'208";a="697940677"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga002.fm.intel.com with ESMTP; 12 Jul 2022 01:07:04 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Jul 2022 01:07:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 12 Jul 2022 01:07:04 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 12 Jul 2022 01:07:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBaRjRC5bVHMUQK0qYhZGbNnrYvCHcBanUXFAVTqfLRGcIeS9sGk3ZniuM/MYiV6bB/RcWEAwmHmJVSIanzpBMTXIcfLQ3M3z1uhaX8XIMdNPyFj/pAODF7hxpy7ksY51eJ4TAdcPlBWmJ6rXVW7KMm0vKzXxPZRMoXOFgHL11PN3HUMgBrlrwpk1f9qRMKAlDhUJCfkh40KkYi0jTZDlRYfCD0+vjVjrkPYPvcHR9VLGRjAKUQY6tU0Q3C6JpQVExW45zwhnK3qiL9m4lRCalyon4GUUySSo6W/Jjaf7vvnxuZfAa9ZIKSx2BU3ruBv0AsTF8ueSGBtSxElWBs1dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wQ7EP4W3PGlPhfsZwEBjFVdrUaVFRgVyIF9Ql1FRdM=;
 b=QH7kcglBX7ZnYX3laYOWA3fNEAaNvyZWDlJMmd8hWNbqtrffEJKUfQ/vk33dk8BibRGroZ/kPpt3ALJK3onX+Tbj2LyNlZ9MZSoYipXCbTqEqKNjHiHsjiq4Ac0OtdTtiZRBwD7EAj5XfWmNAMYGSVhXE5vio0yuEJ1IQkY2kTCVViNvGrrB8gW5b3cDhxiU6uRVhAQMKLM+n7uR3xInVEa+kaF2bOMB8ZMuFpf1cKJUJkI2Boaut+mhHPuJYcMu04TsuyAKGDKTJYn6IRlp4/aPKOfIatTHP2wcQA6TkBTYlK3phBU287HVWQG0WepgjQqPM5xTjdsmLU4JfD2uMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by CY4PR11MB1750.namprd11.prod.outlook.com (2603:10b6:903:126::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Tue, 12 Jul
 2022 08:07:02 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32%4]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 08:07:02 +0000
Message-ID: <0d60aa42-a519-12ad-3c69-72ed12398865@intel.com>
Date:   Tue, 12 Jul 2022 16:06:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [LKP] Re: [io_uring] 584b0180f0:
 phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s
 -10.2% regression
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        kernel test robot <oliver.sang@intel.com>
CC:     LKML <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <lkp@lists.01.org>, <lkp@intel.com>
References: <20220527092432.GE11731@xsang-OptiPlex-9020>
 <2085bfef-a91c-8adb-402b-242e8c5d5c55@kernel.dk>
From:   Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <2085bfef-a91c-8adb-402b-242e8c5d5c55@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0050.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::19)
 To CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 694331db-91fe-4fc2-a7d3-08da63dd80a2
X-MS-TrafficTypeDiagnostic: CY4PR11MB1750:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sfv6jMXN6QRXpTPMZwLAC0vCs2vthCqXh0zRU2fl7A4pF6hEJK554y+25QalHwmXfNHCPYRfGx54eAwvUj/0T6r9sFUyq4iVAPJsqhl9RWQ/6ulbql7cxm5Ad9DSyaqTgSaPQ74ue4mOMl8niPcZLKq2TAZcrdlxryVts7Y7Z+nQZjDewsoZEjq04KZ+SInGUNZMTAkbVWGQhZBYPuc3v16gTZXIYHAegJZpPDELhCLhqRltyCIGC1EAfeqmjOMwcc4XJzZ1TaANghYyimf7E/3N80UVHyF9tlG7wCRCvOXQqI2iZ+vKDXRllKTKpI+5qPcbzIK1yTN7zTG6IqCJKQqlCILdbIOd4Yt9Bx0AwORFBaccbQz3mTjFntCLnbdMowKQoXA5oupYGMDVhlBT5fyQPy5ypKiJZHqst7CUvbkcscwx1jAC/nU87lh3O41IEueKWpyUPoiOjdlenMjVE1ElJzv7mbqJY4DvLMDdUuZwL7oBLkEQ5ciMOaaCP1kDFsOji9PWE2XDca367+yh+ZQQAFg9XM8J2JwrOhmq9AH4zrCQeFBvT7bgot/BaQQ/By+4qIVGVRWRaCI3Usj5xscZw+hpvPIP1RXy0NRMBPS7dNTkIibQGmzZ5FawLA5C7zeC8oodVVkbbbR4OMk7jCrqZueE5f4fFO9b+dxvLGy1cke6WMaB5hmnN99XpCvQgctIskuN/nk+8vzytuFV1393r1RgN6iDdcHavqwULIjyI1fcQ6JEaFSlzVHXS3Z3XHht4IHTzqVmBQIHmOi2VUwKrxcj2GR5gYrwq6b4u/Jk0WXVk7pOowWYe/MW938/gqt9t/NWpxh7ckiN4zCAJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(366004)(346002)(376002)(66556008)(66476007)(186003)(8676002)(6666004)(5660300002)(83380400001)(4326008)(2616005)(66946007)(107886003)(82960400001)(38100700002)(53546011)(31696002)(6636002)(8936002)(6486002)(31686004)(110136005)(6512007)(2906002)(6506007)(316002)(86362001)(41300700001)(26005)(478600001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TStpcFl4ZU9KSGJEZ3Vid2pzdmQxN0xPcHJ1OVRYcEczbExSdjA0TFEwVkky?=
 =?utf-8?B?V1R6cERZZHdkMkNvcHUwYklLajljdllFUWg0VDZ3cko0WFp4dmZLNmZnbFJG?=
 =?utf-8?B?VXFqcUNDeGlNejhPN1ZBdmRwRm0rWFNNYTltTnNZYzQ4ci9PcEMyYWk1bXh6?=
 =?utf-8?B?cVpZcGI5b1JwUGpzVXNadWU1dHRxRG9ybWUrT0tHZjRyOXJ2L0FPWFQ5aktv?=
 =?utf-8?B?MHJ5VkQwaXFoTTc0RUUvRkRIV3FtMmNsUmNyeFpMSGEvQi9wS0k1KzRZVFQ2?=
 =?utf-8?B?RmRra0k3U0JJSjdscHROUEJyL21MNTBFQWhFWkRzNUVKQkdmVFlaY1hwNHB2?=
 =?utf-8?B?UmROT1BBQmQ0RzJ1MUZpeWhvYnBSRVFoWEwyRG9TSElBdnFTdmN6SlI4cmhm?=
 =?utf-8?B?aEoyanZFOXJFdFZTcDRjek9OWUlXK2d3bzNBaWFSNXF3ZHpJTjEwNWFMR3py?=
 =?utf-8?B?T1dyL1RKWXhpNjdIWDVjeWlqZUNSSGlWYi9iakNwMnZuRVduTUp1YWtmMWQr?=
 =?utf-8?B?ZEhidHpRbzl1aEo3MWlCVzJWQ0hFVVY4ZllwU3lERWx4QmZMankzYzlocytv?=
 =?utf-8?B?VklybVk0dVZzOHhQazQ2VCtoTzRVNGtDc3lvc1phNGhiU1M4TlBLOE1jL2Fj?=
 =?utf-8?B?M1BGNFNucFFGNWUvc2lzMllYMVFWNWlFa1U1ZDBnR2RCOGlGNitzSDdUbDJy?=
 =?utf-8?B?YTN2dktwTzMzRFVPcFRXdFVTcUVXdDNTVzFtVk0zaExzb3JkSHlVZHY1bm52?=
 =?utf-8?B?UUt5bjZaZktTSUV3eVdMVzBLallyNThHZFdiT2RBS21rOFZxUmFiU1d1VEpN?=
 =?utf-8?B?L2hXU2dvakRYYndxMWxmZGhkZzhabkRybk5oblJyWUgvcUM3d0oyQVZ2NE5Z?=
 =?utf-8?B?cHNURUZYZVQ3NDB0YnpWa2NaM1R2alR6aldQcFRLM0g0YTRaL3NFdG16ZXFk?=
 =?utf-8?B?dExVcWRPZXNSZG55dm5PZWxyMzErSkREZlZxUVNkQ2U0UGtKV3JJYktiR3lh?=
 =?utf-8?B?b3VQQXU5dFFnYUxtU29WUHdMUHhoVHR4Snphb2tFWUwvZ3l3RmZCS25ac3JL?=
 =?utf-8?B?UVV0V0ZRcjVmbTdmNUlRbURzbEZPNWtqYVB5OEs2M3NuWmM1RDllSVl4M0x2?=
 =?utf-8?B?T25QQ1BPc0doVEUrVUdTa0RIZ3U4eG9OK1JWeWg2N21nRDd6Z28xVWNpd2ZW?=
 =?utf-8?B?ak8rY1R5WDlSclhMYXhTZHpFQnJEUi9EWVJycHU0Q1phSktHTXZXc3VCZGl2?=
 =?utf-8?B?cDRtVEs0YmZtU2dGNjZ0RXdkQisyZjFTUzg4bFR1aWNpV0xZRWlMU2tOYjZZ?=
 =?utf-8?B?T1h0cEZiQmNLbkxYWkRVTXM5cDJLa0FQZnczOE1aYXlqVkVlcjZuVnhLNmlu?=
 =?utf-8?B?OTVCT3NJc05BVEF3cFU4VDVKTDRITWtyR2RtMThvK2UxWEZITmFxb0YzMGJo?=
 =?utf-8?B?Sk5JdTZmbGlxTVpOWXJEaFN4bVBnZGhqbzR4eVlmOTc1L2ZkTXZYWDM1Y2hh?=
 =?utf-8?B?ZmNNTjNWK2l3UStoUy9OdSsyd0E4emMyNEpnTVZnc3BUdjJUSnZkZ3QxNkR5?=
 =?utf-8?B?WWpzckMvWTBnc2N0OU9TNm55aEs5dVcyU1p4SjFwZ2psK1NxRzc2dkU4cDR1?=
 =?utf-8?B?T3ZhR1FRalVJaU1TbWlsOEtROS9hWXY0Wml2V1lVK0djSk8wL0Ridkc2K2JL?=
 =?utf-8?B?MGhTYkxtendrZ3pPRDBXb2dPWTN5ZC9ONG9MY3h5cEJNQU5VRW1YRGRveE1s?=
 =?utf-8?B?YzJoRnhyaFp1UEVJb2t3aUNvQldGWmhFT1NWMnJJRXJTU3N1UEtmY2NLM1Bx?=
 =?utf-8?B?VU5BeW5UejZud041NUplVUdJdEVOTmlOajQ2VEtFMDBYMzdaZ2YwYzFpM2F0?=
 =?utf-8?B?OVBrY2pJR1VZY05DeEw1OU5WRkJxd2UrOENjRFpoYjNGYkROUjVpRjFaTS9h?=
 =?utf-8?B?bkEwRDlkaHFlMFpqZERUOWhGeVZ3Zi80SGlYWkZqVWV5MVBLYVB4ZndkY2NF?=
 =?utf-8?B?S0JFOWdrNEVUZWRWM2FFTUpHcVRIL21zMG1ySmhINFV6dTJiM2d4aHEya0lP?=
 =?utf-8?B?bzJ2bG1JZmZoUHJDbFJLTjBOUmdtZTNwRjBvYjEvcWVmOTNmTk1iUmQ3SXpN?=
 =?utf-8?Q?KC/ei36Q89iPZhBfPWUIoHe+q?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 694331db-91fe-4fc2-a7d3-08da63dd80a2
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 08:07:02.5912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KgoFhFHG3QqJ1sgt3NRGs4ZiJ+3qPxvi8vC67lQoYn+T2whjf1BJHzAt/Mwi5oeiKEN0M4oBgzF74b1LAzOFQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1750
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

On 5/27/2022 9:50 PM, Jens Axboe wrote:
> I'm a bit skeptical on this, but I'd like to try and run the test case.
> Since it's just a fio test case, why can't I find it somewhere? Seems
> very convoluted to have to setup lkp-tests just for this. Besides, I
> tried, but it doesn't work on aarch64...
Recheck this regression report. The regression could be reproduced if
the following config file is used with fio (tag: fio-3.25) :

	[global]
	rw=write
	ioengine=io_uring
	iodepth=64
	size=1g
	direct=1
	buffered=1
	startdelay=5
	force_async=4
	ramp_time=5
	runtime=20
	time_based
	clat_percentiles=0
	disable_lat=1
	disable_clat=1
	disable_slat=1
	filename=test_fiofile
	[test]
	name=test
	bs=1M
	stonewall

Just FYI, a small change to commit: 584b0180f0f4d67d7145950fe68c625f06c88b10:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 969f65de9972..616d857f8fc6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3181,8 +3181,13 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
        struct kiocb *kiocb = &req->rw.kiocb;
        unsigned ioprio;
+       struct file *file = req->file;
        int ret;

+       if (likely(file && (file->f_mode & FMODE_WRITE)))
+               if (!io_req_ffs_set(req))
+                       req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
+
        kiocb->ki_pos = READ_ONCE(sqe->off);

        ioprio = READ_ONCE(sqe->ioprio);

could make regression gone. No idea how req->flags impact the write performance. Thanks.


Regards
Yin, Fengwei
