Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E4857C0D7
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 01:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiGTXZ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 19:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiGTXZ2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 19:25:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBF82AE14;
        Wed, 20 Jul 2022 16:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658359525; x=1689895525;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V8CAtVz1ClPoMgyTr0C7U4L1AqZJfKnpW8WQXRN+N1I=;
  b=JucAyE0krhxBzd/5QLkH0HVefs9KRqckWXQZpk57y7aZ+jhiVfgfvRF/
   k+Ooqt10PuITL0mVlf8ikET9j9788FYgLj6BJnIe3oaQNmhc9pldimQB2
   sIz1gDLvXRKySuItflCVYY74Nk9qmVHB6IZHmqK4Mxo3zRo0L6DjRtVS4
   oKr2qVQsC1EyXfDz44QjNbuTYHEju+9hhgEh5ifGK0JSqeTo2qyC2SVVJ
   t+xmrS3bc+WdXkp0hww9jvAWGXVewWSJinX8iGt30vpYYC2EMDCHI+hWN
   a09uMAhtpUnxKIU8wFy611gATDJLCDUvFeqlD6Q9vjvM392uBIN4sgac8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="348600879"
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="348600879"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 16:25:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="630952119"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 20 Jul 2022 16:25:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 20 Jul 2022 16:25:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 20 Jul 2022 16:25:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 20 Jul 2022 16:25:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWAZsBinALTFVFCDP0JZbTOSiTzyprP664k6gjbwVFfxcBqFjnDPfhCiRnB3+1rFiAzh6p/AuvF2XekpSPJ+ar1EMk6DvnqdhI0kMOdqhXcfJ5+YAQsTOnppIU2EC3V0R+cnvvUO9hf0RoSUO35xezGbSkXZeAu3AzO8R8RK9NjyFkAj8nV0e6y7oBwK1DV+7sFNevTrOjjC7jfBjKm09FoSJ7akZaM9ueqXnTVp+cB193s2gwBv7e3xpUu/yBKhRvJvQvCQoJ/uHxkJKiZ4+cGfaiBAfCzZY9OX7Ok2NxU6xg1lez1cKXlhdTEWNSFEoGMxQprlT9eR8BHdOza66w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8CAtVz1ClPoMgyTr0C7U4L1AqZJfKnpW8WQXRN+N1I=;
 b=G/1yQFnCEBPLCYBoNUbH6argyDk3DUczFhJMmM14Agu4xK3GrLmJa4lLZyc9nMuQxk4DOc2jOGntbGUoI98J5ddmCJOq6o5E7HpDquxgP6EkJaeS/4j87WxEXB5YAwgqnvrHiB25CwbMACRMw9fc+JDC8eVLxEuxbJcaCv+SkP+WemdtAokhX2iVJKUsym11JQ2zbZpwx3WR4f0fKOo1LgTg6t1C9o4Q508luyzK/JOggy6VRsBXxvuoZoD5qfrvll9NdAkFvZsJ/ZWLEcc65fNPl2MvJZ6gWtEsRXaAv0UhLAondqNhpdHTDIe7ET7iA0dt1rRbMxaBJaFDzJKG5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by SN7PR11MB6680.namprd11.prod.outlook.com (2603:10b6:806:268::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Wed, 20 Jul
 2022 23:25:22 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32%4]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 23:25:22 +0000
Message-ID: <d855c72b-b06e-56c2-7be4-77648ba13d06@intel.com>
Date:   Thu, 21 Jul 2022 07:25:15 +0800
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
X-ClientProxiedBy: SG2PR02CA0064.apcprd02.prod.outlook.com
 (2603:1096:4:54::28) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08edb76a-80c8-4e59-fe31-08da6aa71e10
X-MS-TrafficTypeDiagnostic: SN7PR11MB6680:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k2iY06bxRXic6hd0yA9rfkqHyMPIupvnDjDGoz6aMJatPzo3SIUsJEYf+pz9bxrYpxD2H3kJ+YuQ8k3zL27Fqn56IIRUHvu4n3lTUeUNPyNUCefPuGK1df+Dmg+QomhlzbFzdG0uo1oAmKR4HIikfHQeHVLUPZZ80oR+w4+H/2ew4bE900wUQIGOGnYDkTalzfoio+UJv8ILhMthNo3aatoeWupCNhJDe3k8zr8SSCSeIHBRurMA/U/kejMOrn5Z1mboqlgMOPbLddc2R8JO58to0cfS4WAze2MFX6gfvQ53LHQPShxTZ6+KlOBVBpu6EnVBg2/ymqo3OjTEZLCHt9fDqn8EBHGankRUOtuzWMONnEwFvKReXtS5aJyAAm+vJu1wls/bO1z90IZWQSLDhGd5d+fG5p0ieoM1zZR/y655/S96rG5x8UXlsG/wYsN7FtRrJYXGL+wknswSos81BEH8y4kEcClpDw+xjbno7j9R/Z5pfpZgjhtKvKBpZD7FCZcrhP52vmwB5q8Lf7rVbsZEfhg6NQIuLfm15mxm7wuDXgksnxBf91tvfRuw9T5RBKcHq8rQAbq5zsopbLOJ6QtnSYvsKnvrZO66No7IsbG7pAhkmmR2/vZvAvhJcPXPDhXavpIWjkbHQ1Wf8ry+SHpAoQa5ULV4Vp6020k6Dk6lHoWKgmCiLa1IGxuGMvi4OuQGskArNaWXCKfYwbJ1r69CV8qfXIit11xzZ5iRVE0rZkBnJW0z43RqlBbaXsq4Enf7RnzixF6ZEAjG+0/bwy8fYK0KvmfcxipU2iFVpL7WjfquDbWL9tweOgITcHrFhuv7mf8czjcFdRODICZJQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(376002)(136003)(396003)(366004)(5660300002)(36756003)(31696002)(107886003)(186003)(6512007)(82960400001)(558084003)(2616005)(38100700002)(86362001)(6636002)(41300700001)(31686004)(8936002)(6486002)(316002)(478600001)(4326008)(110136005)(26005)(53546011)(66946007)(8676002)(66556008)(6506007)(2906002)(6666004)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzI5ZE5MZ1JETUhBWlNBTzdJbDZRY1pCVzNydUNjWW1DTS9qd21mMjhqTGpH?=
 =?utf-8?B?bnlxNHNNbEJmSUpQSW5CeUNwQVo1WEtaTXUzQXJ0ekY2NTlOYWJqSWZTa3NF?=
 =?utf-8?B?eWRlam40NllQeXVGZEM4UnFIQmNiaHdpK0xpRXpkRjdvRmhRZVV5OTNOSm8z?=
 =?utf-8?B?ck92cUdDdUVCUElydVczZUtBZEI1Tml5UFVUbEsrWmJiV3Q2c3pxckF6aTha?=
 =?utf-8?B?TktwNHk1L2hrU1l2TG9MZmpzcmJaV09uVlBWd3ZycUJHL3UwcGlSSkRGMU5E?=
 =?utf-8?B?eWRtSm1UL0xCNkZ3YWRpWGNTZkQrK0FCaDRMcnVmL0gzdk0vVlVSM2ZZZzcy?=
 =?utf-8?B?L1c5QkxUTGgzK3BNY1dFTEZHUGtMbm1VQUJjbFAyMVdXd1J3azA5VURqcDVN?=
 =?utf-8?B?dC9ETkNqY0Z4N3FGT2p3M1h0TmY1NTJrZ2xpOTRNWlBsblduTHhCLy9VRlMv?=
 =?utf-8?B?Wisyb3Myb1dhMkpXL2RMSG45VWp3OUYvRXpTU1JxU3F1c0dKTFNkM3owWkkv?=
 =?utf-8?B?R0Q3ZWFZRXhoNGN5WVZZdS9JVHV0dlFQOXFWWU44Zjk4bWd5ME10QUF0dWFZ?=
 =?utf-8?B?LzZ1OTNBK0RvcWRYMkFRS2FBVkROdmRYSGkyNFc4OWFSQzgrOVRkZVFqSFN5?=
 =?utf-8?B?T0NyY1QzS2o2ZEZhQ21aWUhabDgyYmk5dGl2RmV0Q1RmcHNBVWhITS9SMjAz?=
 =?utf-8?B?a0ZObVA1aDJVYjVXbjZyZUZPSGx6L3VJUVo3TDNKRWlYQVdoWkk3VDVaTTY1?=
 =?utf-8?B?ajM0RWxpUHBraWpxa1ZZeklhR2UxdkNVTXBDMEFaS0N1S0pXckNlR3o4OXF6?=
 =?utf-8?B?YWNTbFNNZ2daNjhWdmVaR2RVM0E4UHhPd0NzYXBydy83SEFSTUo2Ym1icjRn?=
 =?utf-8?B?QTN0czRZeEk0a1JKVUhIMDJCSzZVWTI3bFBSZ0dBTTFXbWw4L0hiano1WCto?=
 =?utf-8?B?UUc5MUJjdlRaMnEzUk9ZdTFBOHBwSFd1cjRFNjgyeGR4eGxLZnVMT01wL1Rp?=
 =?utf-8?B?V1ZhbVpSTnBYSjl5dlB1RlhkdzdtaEtrTGU4NjVYWXoxbHJrK3BrckdZclB3?=
 =?utf-8?B?S0swSGFXWlU4LzhaNS9HcWFuTDJpU3p1Q0F0YnF3T2xjSkh4UTh2WmRqZVV0?=
 =?utf-8?B?ckplV0VkdG16MlFJczNXeWNzcDlxMmxVUitKSFNHcjU2OC9hN1V6Wk1ONTdi?=
 =?utf-8?B?ejROZlo5MEpiOTEvQU5JWnEwdGtvekhBb294VGkwQi9RSTJjS1UrUVpEbXd0?=
 =?utf-8?B?RnlPa2o5R2cvQWFLdzZLbXRsc25NZlREQnhTQXo1Q3NiTXd2VkFldUc0ZlVE?=
 =?utf-8?B?OCtFeFhscmZxVTNieHFUb01YYXEreTRDNVprVkVDeG80WGRsMXVqakpNdWIy?=
 =?utf-8?B?czNIQnhzVjNNVk9zQTNFYzhJeURQYUJDSGdKRXR5V0Q4Z3ZQNVRiUzVLcjBL?=
 =?utf-8?B?azNPT24veHkvSEV1amFqNXVPTnJhTlNLY1d6aDErcEZGV21wYzBtU0lMMlA4?=
 =?utf-8?B?SWRSTFA4czh2VGZQTEtjajFmTHNaZW0yNzBFY29OWGZTTVp1NFVSYzA3WW8v?=
 =?utf-8?B?NTNJS2lNZGRTcFhIcUlBeHNqVy9HNXg2NExLTm02d29mYkEvc1ZxQVE1OXcw?=
 =?utf-8?B?Ym5jWjlCeFZ6TEp0dkVmUCtidUhoUDlIbTdWQldzYkZ0dVZPL0UxeWF4QlRY?=
 =?utf-8?B?Skc2Ukxnc1VNc3JGSmJ2WVA0ZW9QYkFUSDl4OFF3WGhZcUNraG00STRFZUZT?=
 =?utf-8?B?ZUJreXMxdlRWUWZidTBQTy9LSUVYemt5eHZIMFlOdUwrUGNIbWIxV0hURFM2?=
 =?utf-8?B?QnNPd2NWZGVSSmx3dGZHTHRVSG1lVUl5NTJmQU12N3Bha2ZOLy9vUU9PWHVw?=
 =?utf-8?B?eCs3RlpVWW9wQnhxcmVMd0JTTXJWV2NwaW1ldEFQejg2YjJRNDlBQkN2Y0pk?=
 =?utf-8?B?SVI1Q2pySG94MXZld0E5L1Bva1p4aStYRFhvQUtia1BpQklhb2w2ams2MXZy?=
 =?utf-8?B?enJmL1dWK3BYRTA1TERueVR6YldnaFVQZWUzYSsrbVZCUDRTZ2t3STVSRDk1?=
 =?utf-8?B?WTMybWk5SG1LRmQ1NEo1UHYzTGQzaHBWY0pJd0NHbTVrYS9nOHR4Q0Nndm1H?=
 =?utf-8?Q?g0VOwJXqMTTMJMkY00//zfyP0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08edb76a-80c8-4e59-fe31-08da6aa71e10
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 23:25:22.6296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6D8zLdpYwBnkuDkOXKyxc8z+oJPwac6GQO8Vn2SBbeetaqkOCZsmTnaS0hB4RWs0gtef3sJhkVlk7VhrwIb9gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6680
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



On 7/21/2022 2:13 AM, Jens Axboe wrote:
> Can you try this? It's against 5.19-rc7.
Sure. I will try it and share the test result. Thanks.


Regards
Yin, Fengwei
