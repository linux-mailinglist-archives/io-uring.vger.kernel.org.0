Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2622C57C27E
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 05:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiGUC76 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 22:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGUC75 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 22:59:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02037696A;
        Wed, 20 Jul 2022 19:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658372396; x=1689908396;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GhX4rH1we6auoH2Cp4z6k5FEnnI9JqDspoH+ETa9tyE=;
  b=J3s4fYBkjEYp2MlswGkJ+xqNy+9NovZNFDmLFOD0kTq24aleXQ9WFH+S
   JxN5354r26fMxtDbIZcmrRIzDBE3nstgvgAnxl8DkiY19sES8oW6MGwzC
   ZSxkJZ7QiB2vteZhwxXywWNYjJUlqC4Lyv/ntX5ZiFr1dQxD1Yq1vziuc
   XdDi7Ryz+4iG/AdJo6a+3nejyrueppUGa/PhZwfeFJFWFuFs25NIZCVm2
   HbZ16KmmZCbOfhJ1l+2Rkn50AMcQDZ4K9J439UTYZi0Zf4ITB7viLy+eL
   5GJhQoeKunAuWfM+LR2AwEZqtMBwKXA+o6rcDLYbebuqIFL8FrJUL94S6
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="373237515"
X-IronPort-AV: E=Sophos;i="5.92,288,1650956400"; 
   d="scan'208";a="373237515"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 19:59:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,288,1650956400"; 
   d="scan'208";a="844261510"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jul 2022 19:59:56 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 20 Jul 2022 19:59:56 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 20 Jul 2022 19:59:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 20 Jul 2022 19:59:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 20 Jul 2022 19:59:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgJyIcohxszntiElJe37eR6o0ENl4IryojVEmEXuq2ewQw5FG/Qg2nINJNQwPe6LhphN3eHyr/iyZisEA6VYsilu6aKh8OfADkCoHzd7VggmSrO59oWRThGgIS15hXKA2HV/lGDx/quHbB6WotU8mDEPE0wONfpKI3/W4b6JP5WL4soO/R9mCLJamlRa9SGZRTy/MfLnouZI0iX/QxwxS7U6jHTMmGZUp/P00BHjrP5KDuLLArBOnZcHZV3Q6nZEhkbHyLsYuPmE14CFSSZLX7h9rnf4Dxat4dKGMAlQyXW6BhkiPVp2n6o74A7gtWf0z8HpPbw0UcQqROFEof+PFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0nSp/BlgCZdNpybYgpWFPzzpTxdpGDWurd0wFHWBSQ=;
 b=j5HBYBVYzy4h/vy+BecfVu1WvLPegCMLWNnWg5aXgs1kVX5Puy1KDZDEUTxJMdMAqCp2RoggaM4jsjC/mWKdXEqLqbnXX8X8Sr+HTkgwqmE4vGgvnF1CMr3GxIn5CELgqUyIsbyyA6bnD9v3qPrpDHffS7iPwTzTiH7L1LJ0KRCKJ1bTvOvOaE7QyE6bV214nxtGHwxJrvYcjzRr8t9dpq7nQPckLiSfwn0PLta9sjBdpgtrCfc9Lw5zr+neDWR8+Y1WiRwlnp3vQm2OdUYEZpED/dntVbHnleK5dyWD1QMD3M2tHyUZUwS6F4C3eWpcvQwZDmcrpwKu5OetQNnneg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by SJ0PR11MB4975.namprd11.prod.outlook.com (2603:10b6:a03:2d0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 02:59:47 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32%4]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 02:59:47 +0000
Message-ID: <0863d7c1-1063-2a2a-d70d-764a7580c874@intel.com>
Date:   Thu, 21 Jul 2022 10:59:39 +0800
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
 <81af5cdf-1a13-db2c-7b7b-cfd86f1271e6@intel.com>
 <74d1f308-de03-fd5e-b7f0-0e17980f988e@kernel.dk>
 <2ec953da-78fd-df01-44cf-6f33a5e40864@intel.com>
 <f5d20f6c-5363-231b-b208-b577a59b4ae9@kernel.dk>
 <299889df-db40-e0e2-6bc6-d9eb784ebe89@kernel.dk>
From:   Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <299889df-db40-e0e2-6bc6-d9eb784ebe89@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0208.apcprd04.prod.outlook.com
 (2603:1096:4:187::10) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa0f3185-dcb7-4152-968c-08da6ac5120a
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4975:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kCymW7rHOhpr+wqzospE5g05qkNifBDQlgLX0/jBnqGzeh3CT9Ryx9oKN9R76lQnghNM15YQxMIblmKnm8Be3900hpZP1W+vPW/GQG+/PloH39gBsyH5KbxbHwj7r4+Fh5ClkxxnW7ZqhDRHl9moFZ130FLusc2qIJsrxhxDmLzgHdJr/vCrTz8tI36s2cqus+OGDhIV4W3qm+S/DbXW6FJZ6dRe9ODP4RFGbOV7OwLi0zLf24PsxJEU3IsQzHzUeeWyxczbCURA7GmGsawzVbCO7DA3G/k6WIWwO/vmH5aas8osVYAQLTkPfeuru6nEPGu2s5IIMZUTKBhYmVApD265FUHTNEi/Ue/4q+3y/XXQBSfuwhlE0hlc7W7OMwghoHAvvuyE1wAvg/vt1hC1DYbXQW/DFKfF9nkUqZgyrMWkvW+A5wcsrK1L5Y6N4dyl/N26QDSOA1jTPZr3AP6uyShKjGHQLRWlGsFJeKbYUYoiwzH7UxdanVZI1U0QAp+wtFbMudTkwwA+9oGp1EsqRCJBz1eQgB0/5qMK96RIV/HwEhy9Lh5CiSYYqAfggNoXl6Ml8GTzVhlpVxO/ixzMVRTj5VZwLbQt95XHRY1xxsYhIvKo7g/DBnqaIGmD1I4o6VZUD7EdWkYj7rG83zX+xTQ/BG37JUDVxggtgg6T70LqEtrPCCTdQ63svsBVKjcB5pwRAYz+GdwzEaecJVCmVSeJXDreMUdbw9h4dyI1bJF86EBidfOjRpXeQ4mRH8Ulz+Ra/PV6G7xBdfMNJ3gH+hFwLenavQb5LI1eCa78i0AqfaNXFWGC8L2E8ndha4+6huJIbhYmD0dwoSEw3KkflQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(366004)(346002)(136003)(39860400002)(26005)(36756003)(31696002)(6486002)(2616005)(6666004)(31686004)(86362001)(41300700001)(6506007)(38100700002)(53546011)(478600001)(82960400001)(6636002)(110136005)(8936002)(2906002)(5660300002)(66556008)(6512007)(8676002)(186003)(316002)(4326008)(83380400001)(107886003)(66946007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODMyUlZpRndkNEc4MFp1KytCd3FHS2FpR3RxaUk3dkRkYmNSMjZpQUIxNUNY?=
 =?utf-8?B?QTA2Qm43WlRFOC8rcm13OGpwdVc2REpDdzJlRHBvVnpMcUZlV3RlUzNVRHEw?=
 =?utf-8?B?ZkNRUHdIZi9hc1A3b0srYVJHSUZmL0ZSVy95RTVjTWIrdmJYaExEbTlPSFVX?=
 =?utf-8?B?UHNTemlxYUdoK1Nvd1pQY3JYdkJwZU83MUJKQjBJK3MwY2UxVFBrQ2FWalVy?=
 =?utf-8?B?Q01BdkVhZHVrZzNpZ0JqV3FVeUl6aW13bFA4cWJ5c3hNZEpVQzVQa1A3cG5R?=
 =?utf-8?B?N0NvNjVJbysvdHhIQmhiUjRERjhsSW5EdHROdVFHcWlFQ3BOZWNVOERXQy9i?=
 =?utf-8?B?WGY5cVBlSWFkSWFGWnlnMUlLeG85TUN0Y0pvYWhpaW0wTEVtLzUzZ0JTOFJ2?=
 =?utf-8?B?ZWRFOUllWlRSWEJoZUV2Nit0QndUaUYvWlY2RURBYk8rUitZd0EydWxEb280?=
 =?utf-8?B?MkNqRlZ3blRFNmNKeGs0dTNqZEE0blJwcE04NHo2Wi9LZDNVTWNtWGRVOGI1?=
 =?utf-8?B?UlprZ0FZK3lDbEZOSGFORzJQWTYvSndZVmlweWpkbHpJN282ZVVKVStidjF2?=
 =?utf-8?B?M3loMUtOeURZRmNaYzl5eE8xTW9kZ3lhOGtpM1lkZ1hyYThBUVkyVEFTL09j?=
 =?utf-8?B?a1NMSFFoM0lTNndXUVcyWmtaUERFcEs4YUo5dk1DRWt3TEhiOUJUMUI4alFi?=
 =?utf-8?B?UUpVYzk4RnZaYndsaU1NRzJHdThMNy9SUmk5TWVJeUtSN2F6bVo4WVFsUVYz?=
 =?utf-8?B?WnowbXRSdlpUYXN4Z1BGTWJoZ3IyUjIyU2R6U2oxazFiRmdXUnZySFZ3SkNi?=
 =?utf-8?B?YmNBblFVMHFuNDZzWi84bW9WK1lNYjhmc0g1bmt0OEg5UFRuYjVsTWIyNnpR?=
 =?utf-8?B?SEVMejZWSllKSE1KOFFYdGs2cG82VU5Iamk2cVpzOXgzUUx0SUpzeFJJaHJW?=
 =?utf-8?B?alpON3k1dHRqWTZ4dU5EdG1WQ3d4eXBNcy9KK2RydGRxZUdQejAwSGs1UGNh?=
 =?utf-8?B?K2ZwUDdyeFdmR1IwMmNDTFBuQVF0cnZ4OTl5dGFMWHQyVDFUUHU3UTRyUnZy?=
 =?utf-8?B?OFk1SEgzSWRQQXpFMVZhanI0bjR4NzhrOEpEUVMwZzFQYkJhYUJEZlFvQ3pO?=
 =?utf-8?B?czg0OG5OZTE2UHl4T0hrakpFMnJISWRqK1d2VDFqMThPdENLWXZQanNJUEpp?=
 =?utf-8?B?cjdFTW9iQzdVdklJeU5VbmdUQVV4dkh0K1MyREtmczdyS085c0hYd2REdUk2?=
 =?utf-8?B?TTREdmJlY1dWN1hMR1o4YUt2SmZPOXk5bEtUVUpIeW0xRys0d0ZUQ3JXbFVU?=
 =?utf-8?B?bDB4RzRwQ1JvSVhOZG5qaldjaTZoRjY4ZFgwV1FMeTlDL0JHY3RpaU8wYzVo?=
 =?utf-8?B?MUtOTHNCQmZxbk0zRVVKWHhrQ1dvR1JqOHhWZVo2U2hTQ1VGZ0VXNFplRGVK?=
 =?utf-8?B?eEtqQ2hFOGoyK3pGT3JNTlliR3F0WWYyUUlvbUNtd2lBa1VqS0tscmtVbk5Z?=
 =?utf-8?B?ak9mWnQ4Z3VuMDIySjl6UWowUzUyU3NHR0J6Kys5OTBwaFdGdG1FeVpDK0kv?=
 =?utf-8?B?L2RhNTEyY1RMcHJ2MjI5b05kVlRPZlVCM3NDWDFoUGdhMTY1RjJEcjJmckZ1?=
 =?utf-8?B?dmYzWXRDc2RwWE5ITnBXUGVPbnBHYXZZeWRCSURsRFF4Z1pwMmFibzR4UmlH?=
 =?utf-8?B?RXo5ZUZOYndydU9pVG9sczhwMzAvaWhXTW9HOXZvcmI3Ylg3d3h3ZlhKeWs5?=
 =?utf-8?B?Rmp5SVZIQ05WS3VCZndDVThvcUNVS3dxTG9MQWN6YWdDMFJwdmc2bHY0NnNH?=
 =?utf-8?B?RDV2bW5Vem5rME5jc2dGcmJMU3Brd2FyZFB5SFhiR2R6VERaNUt0cEpxcURM?=
 =?utf-8?B?N1JDcmN6aHNpazJsVzlCLzI4cjJZc2VkZm9FMm9ldWtXWUtmTlVkV0ZiQzJ3?=
 =?utf-8?B?eUZXSWdkVlhEbVBCaC9xbFJDNTg3V1gzSDkveXNPb2YzL0NCVldoNkZmbHFW?=
 =?utf-8?B?SUdrZWh4N3cvV05ta0kwZy9JN2pqK3RPVzRPSDFHZmlaclR4K0I5YXBsRE1L?=
 =?utf-8?B?b2xNdHVQNElOUU80VFlOK0N5d0EwMzBxZEZweW9RQUV4UDFGSTQxTnJyZCt3?=
 =?utf-8?Q?Mq8zitoDdVdg/sm83Un4Ev6f2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa0f3185-dcb7-4152-968c-08da6ac5120a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 02:59:47.3568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V5joaJIGsoUwTtnmtDuaAGG1kLSUlTnFnmvTlMrnr0/GLU0m5J0Cx2ukJ5Utljh+4PnHmtw2Zy/wSjK8OBzyPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4975
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

On 7/21/2022 2:13 AM, Jens Axboe wrote:
> Can you try this? It's against 5.19-rc7.
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a01ea49f3017..34758e95990a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2015,6 +2015,64 @@ static inline void io_arm_ltimeout(struct io_kiocb *req)
>  		__io_arm_ltimeout(req);
>  }
>  
> +static bool io_bdev_nowait(struct block_device *bdev)
> +{
> +	return !bdev || blk_queue_nowait(bdev_get_queue(bdev));
> +}
> +
> +/*
> + * If we tracked the file through the SCM inflight mechanism, we could support
> + * any file. For now, just ensure that anything potentially problematic is done
> + * inline.
> + */
> +static bool __io_file_supports_nowait(struct file *file, umode_t mode)
> +{
> +	if (S_ISBLK(mode)) {
> +		if (IS_ENABLED(CONFIG_BLOCK) &&
> +		    io_bdev_nowait(I_BDEV(file->f_mapping->host)))
> +			return true;
> +		return false;
> +	}
> +	if (S_ISSOCK(mode))
> +		return true;
> +	if (S_ISREG(mode)) {
> +		if (IS_ENABLED(CONFIG_BLOCK) &&
> +		    io_bdev_nowait(file->f_inode->i_sb->s_bdev) &&
> +		    file->f_op != &io_uring_fops)
> +			return true;
> +		return false;
> +	}
> +
> +	/* any ->read/write should understand O_NONBLOCK */
> +	if (file->f_flags & O_NONBLOCK)
> +		return true;
> +	return file->f_mode & FMODE_NOWAIT;
> +}
> +
> +static inline bool io_file_supports_nowait(struct io_kiocb *req)
> +{
> +	return req->flags & REQ_F_SUPPORT_NOWAIT;
> +}
> +
> +/*
> + * If we tracked the file through the SCM inflight mechanism, we could support
> + * any file. For now, just ensure that anything potentially problematic is done
> + * inline.
> + */
> +static unsigned int io_file_get_flags(struct file *file)
> +{
> +	umode_t mode = file_inode(file)->i_mode;
> +	unsigned int res = 0;
> +
> +	if (S_ISREG(mode))
> +		res |= FFS_ISREG;
> +	if (__io_file_supports_nowait(file, mode))
> +		res |= FFS_NOWAIT;
> +	if (io_file_need_scm(file))
> +		res |= FFS_SCM;
> +	return res;
> +}
> +
>  static void io_prep_async_work(struct io_kiocb *req)
>  {
>  	const struct io_op_def *def = &io_op_defs[req->opcode];
> @@ -2031,6 +2089,9 @@ static void io_prep_async_work(struct io_kiocb *req)
>  	if (req->flags & REQ_F_FORCE_ASYNC)
>  		req->work.flags |= IO_WQ_WORK_CONCURRENT;
>  
> +	if (req->file && !io_req_ffs_set(req))
> +		req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
> +
>  	if (req->flags & REQ_F_ISREG) {
>  		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
>  			io_wq_hash_work(&req->work, file_inode(req->file));
> @@ -3556,64 +3617,6 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
>  	}
>  }
>  
> -static bool io_bdev_nowait(struct block_device *bdev)
> -{
> -	return !bdev || blk_queue_nowait(bdev_get_queue(bdev));
> -}
> -
> -/*
> - * If we tracked the file through the SCM inflight mechanism, we could support
> - * any file. For now, just ensure that anything potentially problematic is done
> - * inline.
> - */
> -static bool __io_file_supports_nowait(struct file *file, umode_t mode)
> -{
> -	if (S_ISBLK(mode)) {
> -		if (IS_ENABLED(CONFIG_BLOCK) &&
> -		    io_bdev_nowait(I_BDEV(file->f_mapping->host)))
> -			return true;
> -		return false;
> -	}
> -	if (S_ISSOCK(mode))
> -		return true;
> -	if (S_ISREG(mode)) {
> -		if (IS_ENABLED(CONFIG_BLOCK) &&
> -		    io_bdev_nowait(file->f_inode->i_sb->s_bdev) &&
> -		    file->f_op != &io_uring_fops)
> -			return true;
> -		return false;
> -	}
> -
> -	/* any ->read/write should understand O_NONBLOCK */
> -	if (file->f_flags & O_NONBLOCK)
> -		return true;
> -	return file->f_mode & FMODE_NOWAIT;
> -}
> -
> -/*
> - * If we tracked the file through the SCM inflight mechanism, we could support
> - * any file. For now, just ensure that anything potentially problematic is done
> - * inline.
> - */
> -static unsigned int io_file_get_flags(struct file *file)
> -{
> -	umode_t mode = file_inode(file)->i_mode;
> -	unsigned int res = 0;
> -
> -	if (S_ISREG(mode))
> -		res |= FFS_ISREG;
> -	if (__io_file_supports_nowait(file, mode))
> -		res |= FFS_NOWAIT;
> -	if (io_file_need_scm(file))
> -		res |= FFS_SCM;
> -	return res;
> -}
> -
> -static inline bool io_file_supports_nowait(struct io_kiocb *req)
> -{
> -	return req->flags & REQ_F_SUPPORT_NOWAIT;
> -}
> -
>  static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct kiocb *kiocb = &req->rw.kiocb;
> 
> -- Jens Axboe
This change could make regression gone. The test result is as following:
28d3a5662d44077aa6eb42bfcfa is your patch


584b0180f0f4d67d                   v5.19-rc7 28d3a5662d44077aa6eb42bfcfa
---------------- --------------------------- ---------------------------
       fail:runs  %reproduction    fail:runs  %reproduction    fail:runs
           |             |             |             |             |
        503:3         9297%         782:3          178%         509:3     dmesg.timestamp:last
          3:3            0%           3:3            0%           3:3     pmeter.pmeter.fail
           :3          100%           3:3          100%           3:3     kmsg.I/O_error,dev_loop#,sector#op#:(READ)flags#phys_seg#prio_class
           :3         3755%         112:3         4016%         120:3     kmsg.timestamp:I/O_error,dev_loop#,sector#op#:(READ)flags#phys_seg#prio_class
        465:3         9221%         742:3          235%         473:3     kmsg.timestamp:last
         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \
    972.00            -0.3%     968.67           +11.4%       1082        phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.iops
    975.00            -0.3%     972.33           +11.5%       1086        phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s

Comparing to v5.19-rc7 and 584b0180f0f4d67d, it could bring 11% regression back.
Thanks.


Regards
Yin, Fengwei
