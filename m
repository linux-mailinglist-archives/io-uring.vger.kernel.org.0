Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8143A5790B4
	for <lists+io-uring@lfdr.de>; Tue, 19 Jul 2022 04:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbiGSCQ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 22:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236861AbiGSCQ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 22:16:56 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC242314D;
        Mon, 18 Jul 2022 19:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658197015; x=1689733015;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LjyNAUDGq4yv6sK7fjGgfZn0nn5FGcxtJeoNOFP0vF0=;
  b=IKUf1Pg5EHyVN+0Oc4cQRNYMnzEnrRz3zBjCT3InWoyZKiu/9+kWzwc1
   YZnDzrEnUeylE7AQXhIHqdFLBb+85hvuVXJtwMEieNTTNyoB2viUXlE2I
   TTbnoQbIHjoJRGYGTsbar/m7b4/iO1JAI+SrIZmaC191XsI3OfJSsq+3M
   lEukrCidCHcVJV+3nu/BERQLWFUZ2+UNHnfCooGpbRDsNfQYgkf+Sz5/D
   GviGuLbRgXBkOj33hsHBsQN2fXhNI6WFPyZINAslujzzQRgevLKKGrHOR
   LHOgfxxo8KNirgz5efKZ1uln3y3frIcMRSYW3luSgouiJRQElCro4ArN7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287515471"
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="287515471"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 19:16:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="630144888"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga001.jf.intel.com with ESMTP; 18 Jul 2022 19:16:53 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Jul 2022 19:16:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 18 Jul 2022 19:16:53 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Jul 2022 19:16:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgkJnNv3Qjdq3D/IwbHaN/i8S5jRGoL8GHX/VRjYZEi1sphSkfeXwefXe8MwerH0BS7Zgyx/RaBU4m6AESp53cbG/pTOlLGzI1XgK+v6GCt/83UDMpwclAzmDKHbUrz7CYjze3IuBULScY2f8HH0YPF5NT1uPvQjSt9XJljLmQrqkYUAcwKM4Cmi699/Lpj9EWd4YiQn1Rw0WkZtDnTrMKmZJ+EuwmbFJ+U5F3NI+CBODguvPrKBiTf9hI2qtMfH29sqNudvBsURG+sFP0hA/6gWMb5VAiAEBnjo6luToE+GT3ke1skchq9Wqna0/ChrtY/mq1K8ZykiGfIpeAIkLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ceYfnvhS5u2h415TbaUYrpLl4rDPRN7xyIUemD7SbM=;
 b=aIvE6ty28DmCrsQJWz46UW1hf8okRCV/1WGGpmtiiUyGOkkDft42ljlCOuEM3KMwcKHuBdAVnsBe2ORfixIhX4CQfP6ou6sSrWhCr4+/UpOVjj5ODZeu3074YlzOrIMQY47p87nYtoJLgsV69TlqU4sh4Gco3clG19tRUirLLSGfxQBIEyf3RIDGSbRNBgDnQzUv4XHBtP6J6cOK8uaMeUtuTyCyDnWECFxqvXEzjhfY/RveQIjvRlKh8ZCD9mN2vZsY81J8HLD64uIX90DFJLMxeuaHx9qBTM4Bh0LrR3vS9bzkFt1CBWBDBomjo+IJziWgEPIfLG51akwprIASGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by DM6PR11MB3388.namprd11.prod.outlook.com (2603:10b6:5:5f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Tue, 19 Jul
 2022 02:16:51 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 02:16:51 +0000
Message-ID: <81af5cdf-1a13-db2c-7b7b-cfd86f1271e6@intel.com>
Date:   Tue, 19 Jul 2022 10:16:43 +0800
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
 <0d60aa42-a519-12ad-3c69-72ed12398865@intel.com>
 <26d913ea-7aa0-467d-4caf-a93f8ca5b3ff@kernel.dk>
 <9df150bb-f4fd-7857-aea8-b2c7a06a8791@intel.com>
 <7146c853-0ff8-3c92-c872-ce6615baab40@kernel.dk>
From:   Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <7146c853-0ff8-3c92-c872-ce6615baab40@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0120.apcprd02.prod.outlook.com
 (2603:1096:4:92::36) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b41b5318-9217-4564-cace-08da692cbdc5
X-MS-TrafficTypeDiagnostic: DM6PR11MB3388:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z1g1ZJY9W3+ajyTBekuS3co2vCjRxBzt14rGmm3k9UeTP4lTpzVVAV4ySkNWoI8YFSlM4YCEutCeR2+mEZPsJ1vLhZk6C5qW0JbKmh4vg/mwpWs3MbqEK9ym6NBjIpxNlCUG37ELyeRvpHr5yfGqo4xDCaD/zmHl26JuPs8pXsSvX6PYzWB2um5cP/Gt1OyLeqnn/bPSJzK/pw3YHk+3oVWSk4QvpCL8KyPumugjkfB8qJ1BraGqTGtyTNpUPM5/KFUUEkFTHcEcBWfgzLwgrKFQgkOxOd8Glwkwi1/5RfB+I7pvLy8Z0zyiffgSrUve3dJ1x15n9Ir1cDorkbjU3PMm0JfdQnYVhFWS63hx4WKL8duOl5mMVo/npCm3fA5vlD4SIGAPyRN8q+Th4Ka6dFMmnZltjbn9JEiDRHzpJkk5/InSm3LVf6z5mpwp/Dx1JwfL5wtOqoaW/hOcYd/Ukq3vWKyzbFflJm9F2+eHhybxUdHlTWdk5DhrZkOGQ3/5SJRnfHPdTF/S8qUp2XvISSj7SZwHWvPbYM8eb19UwLMEBtas4vY2JjqQllPuMwfkJ2zhLMvHDlhrtEXA0tILBBU3nibg8Zp4EDGYMIpmxqEsNsAiwUnUzy7C9T+rniMNm1HTOU+O6nlre5PQ8oXyUq7o0q5AVl1M348F2Y2FOelSKz9US8dzhKvnYj2C5Sz0YIkM1P0jfTQEFofFLJEVXKlN7mZFkjk0m59hZwfzgIkckzHcm1exSyeLvlyFlK1ZRJVy4gy+/Las9Fi9okorohN+ercQy8n3o32aI0yDweYAqes/X1wZJhr6pneL6y4n+Ruz5FmS9lE6MW1tM8wHWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(136003)(39860400002)(346002)(66946007)(2616005)(66556008)(6512007)(478600001)(66476007)(8676002)(4326008)(186003)(107886003)(31686004)(26005)(6666004)(53546011)(41300700001)(36756003)(6486002)(8936002)(6506007)(5660300002)(6636002)(2906002)(82960400001)(38100700002)(86362001)(31696002)(110136005)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmdKeFg4S1lLMTlKK2ZhYnZZM2xjMmFNRWJlZ2dyT2ZDS0ZOY0tPUTNGVG82?=
 =?utf-8?B?NU1DRjdWZFViOU8zMnQvQzFndWNnZ005OG9ETThHOUdVV1VLQTFxYS9qMVlR?=
 =?utf-8?B?M1E4dUtpRU5OUDh2UmhEc2l1VjFtV3E4TFVOY2ErRDZ4L2NDak9pdzBIRlRG?=
 =?utf-8?B?c0Zyei81RjZ2NE8zMVduZjBQc3RyVnZISExyQ2tUcHlEVVBxZldSSytwbFRQ?=
 =?utf-8?B?aXp2YVVtdFFUT1lzRHgrenA2NUQvcVozeVgvOXU0WGZaS0M5SVQ2OWNueFU5?=
 =?utf-8?B?MWQvWkdhbkhWdHlQWHJTSDh3bmc4MDRmRmVCR0JqM1hOb2V5VGppbVZ2eFpW?=
 =?utf-8?B?dWZiWTdjajh2blFSZVI1Vkx5VU96eGFxYkNzemoyZmdTTGUzNGhXOWdWR1lJ?=
 =?utf-8?B?MFMyUHhUVXU2KzVSaURwTUh0TEEwNDYwMTN3M3c0TFBhR3NKNzNPRUlHNHlv?=
 =?utf-8?B?c1ZqNDYySTVQeUhUMEMzbjNuMnRScE9xL3E3UUxyZ08zU3BUclVLZUlmOUdO?=
 =?utf-8?B?aG9uZWw3MlY1K2JsTk4vNnN6YUZ3S0h4cU9RTWRqdEV0WEtld2UxZTFSMWcv?=
 =?utf-8?B?RW13TnZLMDlrb2g0YlB5OWo1aVQyQXp2MXRQc0FncFFsSC92Rlo0V3lSYXEr?=
 =?utf-8?B?ZEV1WVZHYURLa2psTURocS9wM25zYi96RUcveFVhQTZJTTEyZ0dCSzBQVVdE?=
 =?utf-8?B?Q2lUN2hRck9Lck1RUmZhNGJIU2Z0OGNZcnR4OWY2Nk5STk9JVHZYbTBlZ2JZ?=
 =?utf-8?B?RzVPL2EybVdwbC9sL29Qd2F4dXBRb2k4ZVNLQzB5QzhYbjVkM0hQS0s5S1dS?=
 =?utf-8?B?VWRIUWFhOUJZOHZaK3VWNGJaM0ZUNHJRWkNTWTF2VE5aZEpzNUxLL3JoTHQv?=
 =?utf-8?B?ZDdVbmNZcXhXTEtIalpTdTh2ZnVLakwwOHhpYlR5MEtKUjJBMDA2TTJaUFJq?=
 =?utf-8?B?UFVsRCt2UHI2eVlxRnliWkhBbkZNSjZjaksvODhNNjk3QTd4MWtCU3o1cVJJ?=
 =?utf-8?B?UFhpVnQ1YytuNTd2SjhRbldDU3drWlpGbWNoak9HTGd5NmJIQytwOGZpVWlY?=
 =?utf-8?B?WENQamJhL29aRDlRbXJENnR5bTNYRnhvMExaYXlWeXovQWU1SkdISDUzc2VC?=
 =?utf-8?B?WlFOSDU0QzNVbUt1bG9HdnNpaXNTZmZwVHE0UzNGblFEOHFwTUlDMXZpZ3Nk?=
 =?utf-8?B?aU1qYXkyNDlNdS9GQlBJT0ZLVkh1VktEc0x6cnBLVEpzU2p0eURRQjlYWXlJ?=
 =?utf-8?B?eTA1eVRuZzYyY3JQWjZKNml4bFdINEFqQTdWMFJSZjhyTXdqVGVtd0gzeWJM?=
 =?utf-8?B?UkF1MnZSYWlUUkNYRFdjZFErd0VJWm0rZFBEMWVQVEZ1VTVnT0l6ZXljYkM3?=
 =?utf-8?B?OE01d2d2OGNzelJFVE5pejExTTcvRU9uMndEMG5VQmxsVi9HaEZ3ZWJ1QW01?=
 =?utf-8?B?eG95VmhWVDA3OVJ4NTZqdythSTN1dk53emFZcUNmeUNKdnZ4UjZicGhVbUQy?=
 =?utf-8?B?Ty8vbHNZM25JQTloUkhSRnk5czBqbHJONjVzVlA3cmpYbnVzWER4VGQzcyth?=
 =?utf-8?B?eStXd2ZLWUtqRUlRM2VlY3VYVnljeFhPZXNLODNCRk9OVjY1R0dXWWliL0VJ?=
 =?utf-8?B?SXB1UnJzWmdmZzJNNzZvZ3RNZlpMSi83YzdtWUNKY0FWUUliN290aXAxSGkz?=
 =?utf-8?B?RFhMZE8yMkh1eG5wSXFNd1ZpbWxrT3R3V3BGUFR2VlhIRllOZzdnblR6UHVC?=
 =?utf-8?B?ZTRhQXZQNzRLMy9XbEIxT0ljcDRxTHFka1RaNkg5YlpOek9pSnNxUmUwK05a?=
 =?utf-8?B?M3Y3eDdJWmw0SVhGakU1ZWlrQUJndHZnS3lTNGVlV2UwbG54WUxKbThWUnBJ?=
 =?utf-8?B?VHBYWlh1NUl6Q2NlZkd2Smp1bU9kK1lIRWJ6QkM4bDBrc25kRmFobEYyOUNY?=
 =?utf-8?B?LzdzT3JtdzZtaHRUYkxEUXNsSi9sOHgwcjJQUkR3dnVRU1dRUlltc0hyZ3M5?=
 =?utf-8?B?eEVmUDQwL0QwYVZSTDR2aXl1RzIwUGk2aDhmaFo0SzluVE8zd2hhaHMwU24r?=
 =?utf-8?B?aytMM0dINFBGOE5uLzNNRUM5akttQXhRcE5vYU1pdlk4Zkc1VE5KS3diOXg4?=
 =?utf-8?B?QnVQNUMyVGV1QnpIM3h1bkcxQkpBRmo3THFCUmFYZEdpcUd6dnZyc3Z6OWwy?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b41b5318-9217-4564-cace-08da692cbdc5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 02:16:51.2505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGaxloVGSulsE/rXU/bIyGREbUB5lA/VhiZgQlWodlMfeuNlo9Yu5YZ5O855w3ugjmk4AvqfZFKc89T5TR1MFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3388
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

On 7/19/2022 12:27 AM, Jens Axboe wrote:
> On 7/17/22 9:30 PM, Yin Fengwei wrote:
>> Hi Jens,
>>
>> On 7/15/2022 11:58 PM, Jens Axboe wrote:
>>> In terms of making this more obvious, does the below also fix it for
>>> you?
>>
>> The regression is still there after applied the change you posted.
> 
> Still don't see the regression here, using ext4. I get about 1020-1045
> IOPS with or without the patch you sent.
> 
> This is running it in a vm, and the storage device is nvme. What is
> hosting your ext4 fs?
Just did more test with vm. The regression can't be reproduced with latest
code (I tried the tag v5.19-rc7) whatever the underneath storage is SATA
or NVME.

But the regression and the debugging patch from me could be reproduced
on both SATA and NVME if use commit 584b0180f0f4d6 as base commit
(584b0180f0f4d6 vs 584b0180f0f4d6 with my debugging patch).


Here is the test result I got:
NVME as host storage:
  5.19.0-rc7:
    write: IOPS=933, BW=937MiB/s (982MB/s)(18.3GiB/20020msec); 0 zone resets
    write: IOPS=993, BW=996MiB/s (1045MB/s)(19.5GiB/20020msec); 0 zone resets
    write: IOPS=1005, BW=1009MiB/s (1058MB/s)(19.7GiB/20020msec); 0 zone resets
    write: IOPS=985, BW=989MiB/s (1037MB/s)(19.3GiB/20020msec); 0 zone resets
    write: IOPS=1020, BW=1024MiB/s (1073MB/s)(20.0GiB/20020msec); 0 zone resets

  5.19.0-rc7 with my debugging patch:
    write: IOPS=988, BW=992MiB/s (1040MB/s)(19.7GiB/20384msec); 0 zone resets
    write: IOPS=995, BW=998MiB/s (1047MB/s)(20.1GiB/20574msec); 0 zone resets
    write: IOPS=996, BW=1000MiB/s (1048MB/s)(19.5GiB/20020msec); 0 zone resets
    write: IOPS=995, BW=998MiB/s (1047MB/s)(19.5GiB/20020msec); 0 zone resets
    write: IOPS=1006, BW=1009MiB/s (1058MB/s)(19.7GiB/20019msec); 0 zone resets

  584b0180f0:
    write: IOPS=1004, BW=1008MiB/s (1057MB/s)(19.7GiB/20020msec); 0 zone resets
    write: IOPS=968, BW=971MiB/s (1018MB/s)(19.4GiB/20468msec); 0 zone resets
    write: IOPS=982, BW=986MiB/s (1033MB/s)(19.3GiB/20020msec); 0 zone resets
    write: IOPS=1000, BW=1004MiB/s (1053MB/s)(20.1GiB/20461msec); 0 zone resets
    write: IOPS=903, BW=906MiB/s (950MB/s)(18.1GiB/20419msec); 0 zone resets

  584b0180f0 with my debugging the patch:
    write: IOPS=1073, BW=1076MiB/s (1129MB/s)(21.1GiB/20036msec); 0 zone resets
    write: IOPS=1131, BW=1135MiB/s (1190MB/s)(22.2GiB/20022msec); 0 zone resets
    write: IOPS=1122, BW=1126MiB/s (1180MB/s)(22.1GiB/20071msec); 0 zone resets
    write: IOPS=1071, BW=1075MiB/s (1127MB/s)(21.1GiB/20071msec); 0 zone resets
    write: IOPS=1049, BW=1053MiB/s (1104MB/s)(21.1GiB/20482msec); 0 zone resets


SATA disk as host storage:
  5.19.0-rc7:
    write: IOPS=624, BW=627MiB/s (658MB/s)(12.3GiB/20023msec); 0 zone resets
    write: IOPS=655, BW=658MiB/s (690MB/s)(12.9GiB/20021msec); 0 zone resets
    write: IOPS=596, BW=600MiB/s (629MB/s)(12.1GiB/20586msec); 0 zone resets
    write: IOPS=647, BW=650MiB/s (682MB/s)(12.7GiB/20020msec); 0 zone resets
    write: IOPS=591, BW=594MiB/s (623MB/s)(12.1GiB/20787msec); 0 zone resets

  5.19.0-rc7 with my debugging patch:
    write: IOPS=633, BW=637MiB/s (668MB/s)(12.6GiB/20201msec); 0 zone resets
    write: IOPS=614, BW=617MiB/s (647MB/s)(13.1GiB/21667msec); 0 zone resets
    write: IOPS=653, BW=657MiB/s (689MB/s)(12.8GiB/20020msec); 0 zone resets
    write: IOPS=618, BW=622MiB/s (652MB/s)(12.2GiB/20033msec); 0 zone resets
    write: IOPS=604, BW=608MiB/s (638MB/s)(12.1GiB/20314msec); 0 zone resets

  584b0180f0:
    write: IOPS=635, BW=638MiB/s (669MB/s)(12.5GiB/20020msec); 0 zone resets
    write: IOPS=649, BW=652MiB/s (684MB/s)(12.8GiB/20066msec); 0 zone resets
    write: IOPS=639, BW=642MiB/s (674MB/s)(13.1GiB/20818msec); 0 zone resets

  584b0180f0 with my debugging patch:
    write: IOPS=850, BW=853MiB/s (895MB/s)(17.1GiB/20474msec); 0 zone resets
    write: IOPS=738, BW=742MiB/s (778MB/s)(15.1GiB/20787msec); 0 zone resets
    write: IOPS=751, BW=755MiB/s (792MB/s)(15.1GiB/20432msec); 0 zone resets


Regards
Yin, Fengwei
