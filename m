Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E501D57C28D
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 05:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiGUDIz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 23:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiGUDI3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 23:08:29 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237D777574;
        Wed, 20 Jul 2022 20:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658372909; x=1689908909;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OZeIPdmy0S/rHB9bkfPrt0aP30Vvn5TwZg2Y+Zmmu6Y=;
  b=FqEAlvMPx4W5t4zfVabgpyNHa4mgNTDSUS79A2K1+RCnsYtZE8tnDO50
   QaTzgfkjpW2aJ22DNxiM5krmnSAyAQJLDGi+cu/s+GCGyqSWfcGRc0pCI
   +7F+n7omMqtfXLKrM07HwPrpqC3GMar3dkAwjjyA6ez8JlmplmYzY/kpw
   v3MBXddUyr+BeNXJYoTJbMlCwaaIGWJHB7fJywpk6Ev1dn1unV3cy9UMa
   M1GYWLW4RJXjs/ci+QxEoz3EYNK7m8Luyt8YddeaqfKqqDwfHXzXymKI+
   jYBU1OSpTMWeV8Gryut2viyxH+7Hc4BcwAlUl5TFAJRvDq4/2UzGYUzUI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="373238606"
X-IronPort-AV: E=Sophos;i="5.92,288,1650956400"; 
   d="scan'208";a="373238606"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 20:08:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,288,1650956400"; 
   d="scan'208";a="625927483"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 20 Jul 2022 20:08:28 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 20 Jul 2022 20:08:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 20 Jul 2022 20:08:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 20 Jul 2022 20:08:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kwf83Y1ysbqpEv91tXZxDrzQithAWQ9DSR7YJMtD7PRQ6j8DBtZkHkzYDnLey2J6ha8wBoP7j/C17S3I2V7fa8pIcY6/XBw5BksHBYqHVq/ZPgVtKYZXnLwHuQfbEswGIgBpjIr++KHyO2/zuIjaDuh994PtyPfBXcwQ2bsbhV5il942/2p99Sce3eqWtzoi1Je5yU9hYGkZX5CqXmvy0HhpRH+uC1FyhcZJxtk52UAc8AHKDKVMqyUmni7c3j9RviFM5RMouoi3/nT766FEc6eZ0MMCG9akU4pJaEz9nm6hUVhwebl9QxBIt7IMCei+gpSTyMI2HSZSDm9LgMHG6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZeIPdmy0S/rHB9bkfPrt0aP30Vvn5TwZg2Y+Zmmu6Y=;
 b=MHxD17MD97kHsOhQi0hGS8lgbqVSxDZZ6lJQWpxxkQPoGRt8W/xg59p7HFDFp/aDq9b7bTbr+Fc4ZXayaZUDnCGHV60Gx16coh32JEIrRLbefYF3F80NdnIyT9oQUJ3DNbIL/79hJ70FFreagrXEIQRrzrpBePqqFgamzam/lHEhGYwPq3AjrVvIcdPuti5aj3LLS2zLt7mWBsa3hKySXLDnBLx6xBlpR9NoV7ar1WCAbyXJOgjssyZySRzjKETfW8Tju6ZzNjTcRqkqLrBEh5gwEk9xDVBobThJcSkWpIBp9F36gmF190k3hNGxBc3fSM8IXKcHkbmsMKjb51wCjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by BL3PR11MB6411.namprd11.prod.outlook.com (2603:10b6:208:3ba::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 03:08:26 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32%4]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 03:08:26 +0000
Message-ID: <c5b81a15-275a-900a-b7d3-afd65f301ea3@intel.com>
Date:   Thu, 21 Jul 2022 11:08:14 +0800
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
From:   Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <f5d20f6c-5363-231b-b208-b577a59b4ae9@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0028.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::15)
 To CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08cdda55-8e2c-4e75-e5e4-08da6ac6473b
X-MS-TrafficTypeDiagnostic: BL3PR11MB6411:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZijohFnts/Tmx/4yjqDGY3rySIKfi0ayJxUvU6piMJ4bF2DGUBXYHb09sHxoDk7Bs9bKtBxrSfx84siH6Xv7ols3NvilpAYpnyMz0s3fqM0EmcMH0AEVZhzyKmw0yNsTovzGEGIA+bCJtmm9cDC/7fDMieFjiZbh0NEIXMqrmNflofgYL9S9UtxLvkpTmznP+s3vHpFqik5zh7ynJLvJZ501x1hrVipyzKU6uxej/otIW26fylZBCKyeNoxrJDe6m5VOBKVIZ9+ivu6FXux82lOpw2vzeovfrbyoZDmtwVOmXppCN/byR+zpy3V3Cp8vbz805F4J+XW6SjAhsQ+hrzC4Pkj9mX559w5eyiLQttYiA0BycKzcn04r8mmVUGZAiPag2nn0X6htN4F4QAbnG1l2pxmL527ssFm/eli1nizmmc21PLn7GVRHA5zRi6/mBQMFNKmj/UieRwuR26zfvRaRon7QI7chBZCzlxbrK2AOELtLD/x93Pt9l54EsU7TRjsprgqpFlbmZALsnCxyU5npyTCCFaVraf2LRUZ7ycAKdYU75ks+sua+RUK8uuGKEbgm6sC44i2c0eMfT6SsifgNoKH885VMREw6tzjcDXZl9lERmEYnQwwMDsumM/NWGM5Ak1HjIkEz8xOIQJOEScNx3xyolelO4+8SxoEiDZy5vRpX8L/uzyxMaIm3bFwVqeLIQ8tzJy03SwWQ5bt3r+9M+17dvle5GDrJ2/mVtWXoCZhGvior9vm2PdDzGieEdNjgLvvGXC6kwDvp5JKL4MCeHEc7XQ8YdJ1lK7HIHxI7NyqYDlYxJkoeWwkf3OYQyWbfB7FOWksp5vgacimB5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(366004)(39860400002)(396003)(136003)(5660300002)(4326008)(8936002)(66946007)(4744005)(66556008)(66476007)(8676002)(2906002)(83380400001)(31696002)(82960400001)(86362001)(36756003)(38100700002)(6512007)(26005)(110136005)(41300700001)(107886003)(316002)(53546011)(6486002)(6636002)(6506007)(478600001)(186003)(2616005)(6666004)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UENETWR1VE9QaHlqRmNZMDRBNERnc1RwdXJ6UkRXUGoxVllVRytPS1BiSE9z?=
 =?utf-8?B?dVlXVDdDd3R4Smk1NlpPVnpXdGF5WnRLM3gxWGFCaUJON3lpTHBLRjYzZWJp?=
 =?utf-8?B?R0lha00wMTRVOUtYdDlHRG42S1J3am5pY0I0ZUtoanRyMzEwSGVQTEwrZER4?=
 =?utf-8?B?NjErenp1UU9Yam5EZ1JWS1l5MFJUQTdsU2I5c0lRa2VEdTlVM3JiMEhjbVJH?=
 =?utf-8?B?N0RRUzhxRFpna2xRbjh5c0Fadm5jZ0ZTbVRGcUVLMlZUbUgwenR5Y2V2Ylkw?=
 =?utf-8?B?RDlZNGRpQUhycFY2WkhraEdrQkh1U1FEK1AwelhrNHd5VEh0VUJNcCswMVJk?=
 =?utf-8?B?VGc0RHdiaVkxSVJLNG54SGNnSXlRNENSTzFXNWZBUDFacld0d3hEUVJ4R0M0?=
 =?utf-8?B?eDQyMEtEU2dITEljbGcxUmdhdG9pOUZTbVp0RWpwcW1Jam9Wb3U1Mjd1V3pR?=
 =?utf-8?B?Z1JhZmpYZElna1RPdStrZmZjcGV5TkVteGgwenpOYnRGOUtBOHE3WWhWUzZk?=
 =?utf-8?B?ZmlUKzVZNVBqMVBxNGVqcEI2d1Nmc0pvbENvaFN2RUNPQ0k4UXIxeGc4WlZG?=
 =?utf-8?B?aDQ4cGtqV21TRHJnMTdrS0kvT0k3K2RSc0R5SGJlUFViTy9XTUFSOC9BRW9F?=
 =?utf-8?B?SzNpN3RoRVRnc2JabG9vTTUvQWJrYm50SzJJUFZxdEJoN0dNSnMyUnI5NXB4?=
 =?utf-8?B?Q1RJNml6UDUzUjcrMnIrVDlxMmVsUDBtVVlPcVNHNmJkWVBoMys1dm92akVW?=
 =?utf-8?B?Yk8yMEdZTUk5T2xpUmsvdzFuaFZxU2dnaWZqaHBTSnNlNEUvMlEwTmRzYm0w?=
 =?utf-8?B?eCtQOGNjMGsyUWErNWpwVzFtaC9lS05zaVRIK2tnbXh0bTc5dHdnSFlKQjNj?=
 =?utf-8?B?dUsvVCtMeGdBZXk4QWVtbzYvSytlWlJzamthc21QZGVyV09nV0NWTnpQZTls?=
 =?utf-8?B?RXo5bTNhSzU5WmtySmdXUm1FTzZwVDkzQWxlemowUG5TcXpCU0xjVEJIYVZs?=
 =?utf-8?B?aUN1VVRDa3JKbWZLMGhLTU05VG80aHJTV1RHb0dpeDVGT2wxa0xXaFJKRXNB?=
 =?utf-8?B?U2FJOWJYK0JQR2JGTlZRaTdIMXdlZmxaVklFMWduT0M4ekdQa2d2dU9WYlM2?=
 =?utf-8?B?ZTBtbGtmT0cwM3M0cWs5L1kwZjU4UytjMW53MDhCRUlCRWVhN254KytxVWc1?=
 =?utf-8?B?TEhndS8rRUdBbnlUZWxYKzM2U0lsNHNpZll0ck9RVWRYaXNyVFg1M1hlaTZQ?=
 =?utf-8?B?T1dRWEY4V1VnOXp2c2gwZjhIMUdmRmEvZUdnS0RiS0M5ME5kbFRpTm1iUDZZ?=
 =?utf-8?B?Q1ZxYUV3d2w3cWMwRzhDRWFWdUM0bDIwaDd2VE1BYzBFaUxkMDc4elFOQlRX?=
 =?utf-8?B?b0dJMTZCanRkUTYyYVZDNUU0NElaMk5PNXAydkl0Z3lCY08zT0xxNENMbUZ0?=
 =?utf-8?B?d0FETGNLaStiWVBrVUUwSnZGZERSa0ZFTU5FQlN5d1l2NU1KK3FubTU3RnBT?=
 =?utf-8?B?aWs2WW54ZnBLV2RERUdLZk1lNldUVnRSRTI0aklKSS95OFFZa2hjbDY1dXZr?=
 =?utf-8?B?ZXhHdmg1M0hkYThFK1ZiMzZOaElZelNSSnNScm80TzgrMUpZZ1NxM0VXQm1H?=
 =?utf-8?B?S1Bob21SUHlrNFpOWFF6aDBlaUxlamJnMjF5akt3em5LVlZTbjJBaHQyaHRO?=
 =?utf-8?B?bUJJS1pSaXdHYWdWQ05uRnA4MUtEU2d3ZFhqam1IMEJVd09HT2VyVDNha3Zl?=
 =?utf-8?B?TjRTZ3pLYlRuQVZacjBrMkNTYXRKalI3ME9FVWhqeTFRWXQyZ3ViR1JjVGNy?=
 =?utf-8?B?OEZXS1Rzb2hKaDB1MElxNm5PU1phdHF0MDJaSllVSmdnSytFN0w0N3Q3dzRV?=
 =?utf-8?B?QjJNRUhBRG85M3JqK3FTQ2R5RHdQc3VLVEtmQkdGVFhEYWhTa0hFMmRGVURE?=
 =?utf-8?B?UVdKM1pYV3VSOFRldldvd2kvTFFNNWZlTGMvNlBzRXRxa3VndTJIK05TSGds?=
 =?utf-8?B?UUNJQVRRU2JmbjFsK3Q2ZnduamFubXNSTHFLVzRDZGQ5V0l0Rkh2R2xhK0lU?=
 =?utf-8?B?V3B1WEZDOGhtcEIwVFNWOTRQbTVUcTdxdG9OazR0bmN5VXFJWXViMGNTendu?=
 =?utf-8?B?Z2szdllBNnNCRXgxd1ptS2orTktBQVhYTUppazcvY0VucTdRRnVLejlZMDlr?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08cdda55-8e2c-4e75-e5e4-08da6ac6473b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 03:08:26.0021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 92VzbEkP4TjYQ8s3zcI+o/Jyh+BI4MhWJoB7CJjJpFbDFtGD0Yu0mhkVjsUNscFeYfqdmyNiD6LD2snIKowIGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6411
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

On 7/21/2022 1:24 AM, Jens Axboe wrote:
> I think this turned out to be a little bit of a goose chase. What's
> happening here is that later kernels defer the file assignment, which
> means it isn't set if a request is queued with IOSQE_ASYNC. That in
> turn, for writes, means that we don't hash it on io-wq insertion, and
> then it doesn't get serialized with other writes to that file.
Thanks a lot for the detail behavior explanation.


Regards
Yin, Fengwei
