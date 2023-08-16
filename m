Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD0077ED94
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 01:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347077AbjHPXC0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 19:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347074AbjHPXBy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 19:01:54 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E7A13E;
        Wed, 16 Aug 2023 16:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692226913; x=1723762913;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/1Pgc5ZLLVtqXovljZ8gKehJhR/4lKHUPgw7kHyu7qM=;
  b=MedHnc5HkLqAb78Plg13/YMvkFgL5WOl+HZZWAR0DRYVOk9BXo9uRxfv
   dR/aEBKLksot2DmDpbmMrFYrXC0IiHtrkdJ9FNWeJ/JijsbMbR6z/h1XR
   SkQ/KPWIBaGKhn5KiYVyiWMqH4tJseDi5F4uOWtQOHkFEpR9GB3KA2Z5x
   B2vb2s47yzlrduyI4i+ONhvMUn+75P4c4RYb7JtADQ8PMU/NFmNrI2b0z
   1iA1LuIavkt4xHQVUUdW+Oba9TPQ+r8wgP5djfqUHwL9IjQrvSG/X2avp
   O+ehDolh079+UQKVM9/lja8ZzC1toLXDs6+leJuAaoOyeGQ89r3a3Qhzp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="362811969"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="362811969"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 16:01:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="908168026"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="908168026"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 16 Aug 2023 16:01:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 16 Aug 2023 16:01:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 16 Aug 2023 16:01:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 16 Aug 2023 16:01:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXOQjzKdx9QngpkbXYDbcX4AKKcPFQcxWn75txqMMXiQSqwr1I5aIRno6IV4/IWnDY3P8Cw4lLvajGR57NgvKDh2hL3meHXNtruCrWnAFVsThMigoRDzxUEZoPxGym58SFYHQsyU37zGhAT3T4kiyVtmrefbhBCSAuDn+M1OlySdz3rdtrGva1BUc55vfLUy0PCHGLiJUFwJda7CXZRZdnl+aY+WB5Oo7boASOXbW58PPGxpj4pEtOpYKgTltc5oxDV1I74h5WmOGiomFAvnyYkrAKoHgRZ6NpNWrcfBIiRRPqzR/zkNdl+2YCOmJ+vL2hsVGQfVBzfWYG7aCvZWTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EcgDZ5F8YlNjY3r9cL456EBFETO92qZDUM1wqWhh6Bs=;
 b=FZkrHa1f/HEss8F5XDm1I1Q1ZOnznuP91C+gkw4LV83BEAwke5S+xInzl1Iabxd9uBtpUIbm30TYhxbuNGGtjfsG1MKBcd3AQ8jJOksSTBDQPw8AQiWMTAgGcTa4zCuoKzq5QO0TAKQb8miwFZGBIwM+3kNXf54p0Dh9V4o/yRyhXiNWSPk0EKzrd/TCofsjQj5hz2NNCuJvMYZAw1NNE6en49FU1LWUlXw3StpSV02a0Sw7M2RHN/5uhGniGEiFFLpW6sg42JJefcIZQ12l31lVliFuH3dkOfSWgT9A8d9hv1mLoJ/VIf6NfUeMML5Lv+ZI0uSv7U8H+/k9chnPIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by MN0PR11MB6087.namprd11.prod.outlook.com (2603:10b6:208:3cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Wed, 16 Aug
 2023 23:01:43 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::221b:d422:710b:c9e6]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::221b:d422:710b:c9e6%3]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 23:01:43 +0000
Message-ID: <cf03e925-ee7b-4441-a30a-45c4b46380aa@intel.com>
Date:   Thu, 17 Aug 2023 07:01:04 +0800
User-Agent: Mozilla Thunderbird
From:   "Yin, Fengwei" <fengwei.yin@intel.com>
Subject: Re: [linus:master] [io_uring] caec5ebe77:
 stress-ng.io-uring.ops_per_sec -33.1% regression
To:     Jens Axboe <axboe@kernel.dk>,
        kernel test robot <oliver.sang@intel.com>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <ying.huang@intel.com>, <feng.tang@intel.com>,
        "Yin, Fengwei" <fengwei.yin@intel.com>
References: <202307060958.3594f22f-oliver.sang@intel.com>
 <80519d5f-e328-4ea4-a488-00209432d5d9@intel.com>
 <8a19b81a-10ed-4d65-9fbd-433af11e822f@kernel.dk>
Content-Language: en-US
In-Reply-To: <8a19b81a-10ed-4d65-9fbd-433af11e822f@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:4:195::19) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|MN0PR11MB6087:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f3a9213-b5eb-4b79-3309-08db9eacc22a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FDJSWVmNhkF+Fg3sDOmycbepnziZ1/K+ysVw1rXlwPfF8cVQrDgQw9kTW80ffZWIF1KlythLbx7n98/VBYcpxAByBwrOrk+Kk3LHMcgirgmqxzQex6rjMKnPo3DUWKa5MIoJfJ4b36WHUN+S6Lxco54cnxKaoTE0X3jajQuCi0WSDTVIDhx5YXMYqPhbXtw5bx9pxPzI1SsFoGw+zs4sJwM9RY7yDq42e6zuPLiEeKYwffiCK2mq+Ivqp8q+hmO/W+3C2U/8Zhmix4QNK/8/Qmz9r5wRfS7HxSBh+yVzHHVi2OiU3e0Agou/RDujVAkYlrR28CIIdecmkMIpZgY5b95JIvCILzfCZ/x6hclni66rvICPNVZmbJnfSRSMt6XWfCfA8BUypdwIYsFCCeMOutJO35+3JoYkhnbBNs1zyVbPsh0hmoZHjSGYx3hwqC2X5bwXtEJZQ99CX0cvpPMeOcwDqtOq/jIBUGLmsI5zVwlh4lo0hHNf8tEzCC1uKCrI3yxB/M58HE9nSJp1Bcthh0YeheoLeX9aKem4nC6grb1kGLBEL8GoVxJzOi8OIvbmOvA+6YFZilK/JuheVsTbrFye3hYJMzOXM9C2J8tPORtdvvu5NbR1tAheQz4Vh2mFiIqql9SlW8LDMiiP1iYD1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(136003)(396003)(39860400002)(1800799009)(451199024)(186009)(2906002)(83380400001)(26005)(86362001)(478600001)(36756003)(6506007)(107886003)(6486002)(2616005)(6666004)(6512007)(53546011)(31696002)(5660300002)(41300700001)(6636002)(316002)(66946007)(66556008)(66476007)(110136005)(31686004)(8676002)(4326008)(8936002)(82960400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1BnbkpHNUhqMmNmNVpwWkVsS211Q0EvWTVzbktXMTJDa0RiNUxlWGdscW91?=
 =?utf-8?B?eExFVUZyREdmOTZtckJMWVZac2F1em9GRlNhakRDS0xqK2U0dWZYQWdETU1R?=
 =?utf-8?B?NWI0QWFyNzJJbUd0VFRwbzd6TWVGNVNvTitHU3BVdVM0S3JSMFdhcHhWdHF1?=
 =?utf-8?B?VWFYckxYQW9vWVpZVmh5NGRYTkJ5WEVKbjZaT1dPcUsxcVdKRjZlV3Qvb1d1?=
 =?utf-8?B?YzZleVRSRElINVNlQ2hlaC9VdFcxWjhGcm42ajQzTU0wM0lqZzNVQmFDdnRS?=
 =?utf-8?B?eEg4NUtyczFDZE5mMG9mUXlhaHBwT2tJbkIxeDlkUi9zV3pzc0ZUWE5EN2dP?=
 =?utf-8?B?WWhUdXBDNzZnMzViNGt0WTl3Q0dwNkJmcTBVK082cnFISWluN1lOcXI3a1pv?=
 =?utf-8?B?UWIyYVZSOEdqOG5wYzJWbzhsV2ZQMVBDYjV0bXFNeDlabmRhVG0xNk9HT3A4?=
 =?utf-8?B?M1lqS2l3MmQ2dEgrSU5CWWxMenNZbkFhU2xNaytnOFpzdDhrYzVPVHg1T00z?=
 =?utf-8?B?SHcrZzVQem5scXhIdk9KQ3JwWk1UbXFMWW9JUU81andsVzZkbU42WHdiTEJo?=
 =?utf-8?B?R3F3ZmJyMXI0SGk3ZnZKM0dkcHZrUTducStZMUhiYWpYb0xxTjFQRkFBRGln?=
 =?utf-8?B?MUxWV3BSMDQyakhKSTU5R2Z3V0hGZUErelgrc2hhYkZJalVnT0xFbTI0Vm05?=
 =?utf-8?B?bHFiU1NKOStYblpGN0xSZUxMNnErZTdSVlNsV0huSGxtZWR1NWl0ekM4UENN?=
 =?utf-8?B?Z0d1dzlLU0lML2NDYXBpVW53NnJLRG1ROWlCcDBTMmNiQWZEZ1ErbGtWV1Jn?=
 =?utf-8?B?SnpoNlZsd2JWQ2JQTDg2bjlOd2t2OG5hTURQNHBtOEg4SGNMQTh4akthN3po?=
 =?utf-8?B?NzdEV1Y4Qk9JamlYcS84S2REa1dWelZMMWhMRGhuS3FHUWZocEpFTElJYkhM?=
 =?utf-8?B?TkNqU1pHeDJ6ZUh6aTRuWDBmbDNwY0FRZlhOdzE5WTRDelRUckQ0L2w5SXYy?=
 =?utf-8?B?STZnSVliR2tCMzhpRDV1eE1VZGN1VFlUYndNcWNXdGM0UHBWSU9XQjlTa0dj?=
 =?utf-8?B?QzlITzdHa01rSlk1Z2lKRUVUcW5rOUVKNE5XdHp2QVprRnFCZjRvYjNPQkZv?=
 =?utf-8?B?UFlrZDNmeHJsemZFS29WK0h6VkRtR3RqVnM2RDRnaW02S0tPNFRFK25MUm82?=
 =?utf-8?B?MjNqSk91VUZrZ0dRQWZISStBOGlGTUkxa3ZVMUJBQzBaR3owR1BjZHBqYk4r?=
 =?utf-8?B?eXBFaURZWVhMSkRENzl6U0NhMW9EcGg5V3FtTXlrWm8xTzFzZ3ZLdERVbXNU?=
 =?utf-8?B?RE4yZUthejlmMkNtUkxsZ2dkOEFXVnZyTXN2dUdIWEdNSTg1OEhHUmRMQTdE?=
 =?utf-8?B?UWpwZVVtYU5qM3dXdi9EZm9pWXlLa1FqU05UUG5XZUxzTkIzc1dsUzNCanFE?=
 =?utf-8?B?ZjI4S2ZJQmpsQ2NOdXlhbTVrOTRxN0V2Y1hrVFM2M2pwM290aFdLT29jUjNz?=
 =?utf-8?B?V1lmM1lkenRVUy9qZmhTcjBaYWpKNEdJc3hUU21PbUk0V0RlS2J3ZVhPSEUr?=
 =?utf-8?B?NVBxK1ZaMTVaanFFRXpxaVkxWG1NQmZHbWJ4Tk01cEhUNkVVQ0NmVjAxY2wr?=
 =?utf-8?B?dkJXL3RxZVh1cVJPOGFyNE5kMkJ1MEdyTWdKRnpCSGlvNFJaaUpSdWZoTGF6?=
 =?utf-8?B?SHZTbmY0cFBic3NtUlZTTFZ4Q3hVQjF6QVRkbWJzK1Nyb2c5a09aeGp3dGZu?=
 =?utf-8?B?MmpVQUp1bThRclUyMnhUTEZzUXFhMjh4MXBRMitycWxoYVU4MkV0amJQS0RX?=
 =?utf-8?B?akxEeURSb0gyN0JtenJVSnFDTEZrL3RuZVFpVGlGVk84N2tDc0FUREhyOUZw?=
 =?utf-8?B?VVZYWVlONUsrLyt5RUNlL0J0Y3JOU2Q2L1ErQmlITXIwMGtHQStmVGpLR2dU?=
 =?utf-8?B?YUNrNExnZlJNdHFJWDM1RktXcjVxTUlEMVU3azZ5ZVUvRzNuSlhtQkNNNWRZ?=
 =?utf-8?B?ejNBcmIrbk90R1lVUDZoRkcvWUpMVFRqZ2sxdTU0ZFp4NEpseVU2SWE4WDRE?=
 =?utf-8?B?a3ZabnBPb3NnRzU2bVZqQm9sMmN1QjI4dHV1akhEaFdmOXRoU3ZqNHQwSmJl?=
 =?utf-8?B?YlhNcGNIKzBOWFJEdGVRYlZ3NWVnL04vaUVoNFk5NlFGWCt3a0tnNDBQQWIr?=
 =?utf-8?B?ZHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f3a9213-b5eb-4b79-3309-08db9eacc22a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2023 23:01:43.3640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGU7409dvWpwnnxs47v+o8j3IFgQJ1GEO+9kFbLFdKFxVkTkN9GVRxJ/BGOp2QsOKxj7ST4mtvn+jRYPbzLUcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6087
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

On 8/17/2023 3:27 AM, Jens Axboe wrote:
>>  static const struct file_operations shmem_file_operations = {
>>         .mmap           = shmem_mmap,
>> -       .open           = generic_file_open,
>> +       .open           = shmem_file_open,
>>         .get_unmapped_area = shmem_get_unmapped_area,
>>  #ifdef CONFIG_TMPFS
>>         .llseek         = shmem_file_llseek,
>>
>> The performance change when running stress-ng.io_uring with testing file
>> in tmpfs is gone.
>>
>> This is just the information FYI. I may miss something obviously here. Thanks.
> This actually highlighted a problem with the old nowait logic, in that
> it assumed !bdev would mean that nowait was fine. Looking at shmem, we
> definitely need IOCB_NOWAIT handling in there to make that safe. So the
> old code was buggy, and conversely, we can't also just add the
> FMODE_NOWAIT without first making those improvements to shmem first.
Thanks a lot for the explanation.

> 
> Basically you'd want to ensure that the read_iter and write_iter paths
> honor IOCB_NOWAIT. Once that's done, then FMODE_NOWAIT can indeed be set
> in the open helper.
> 
> I might take a stab at this, but I'm out sick right now so don't think
> it'd be cohesive if I did it right now.
Take care.


Regards
Yin, Fengwei
