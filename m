Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723AA578F3F
	for <lists+io-uring@lfdr.de>; Tue, 19 Jul 2022 02:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiGSA2H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 20:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbiGSA17 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 20:27:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A423AB05;
        Mon, 18 Jul 2022 17:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658190475; x=1689726475;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UVQousvbJvliigR5JbAcuIeEaA8onf7B9fQUwB2DcKc=;
  b=je0lai73gvInWEuX3SF32X+9xqMTNODDjDQ3JIT1C+/BMe8S/HUIqYnl
   wMEtIIAB7AHXOHfpMd7cg6DqLa8Kose4F7jkMd8ziDqxWGFFAY8iF8Y85
   ID0d1418jnlw0xQigM2PFSntWaFyB7fbjroUagBd8HhmLudentWNLXQI6
   B31KNTmsE/U++EMUfRVr2LXrwoSIqx1GbVDY7buP9ZEkHChNm+eZtdBON
   VeI67a3eFFZhBG/nzw6IVvS7qcX5eCddyxqG2DFsO8Xa5WU+z/DoJyMM5
   zv4FT6lUutDAUhrZAh8MTdHXJiBcQjL8av0eI57Gb1077+ElC01inZwaY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287500810"
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="287500810"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 17:27:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="843459269"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jul 2022 17:27:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 18 Jul 2022 17:27:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 18 Jul 2022 17:27:54 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Jul 2022 17:27:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dV0zEi43IIzagorNMsyVh3npc/9wNEFwa9UcEC32pewIl341zOSYDXkLYUCKTO6klLoKMRDYgitZ800O0n3y0HJeM6ZHqhDHcSjoFQD7QM1ObnDyW4VXilr9914nIbfoL8o9WaOA7mnwrH+2nQAZIWs5LqwcVg383fB66wx0He9sjfVP5uoJwd5w5rb9PO8PwjauhKY986QPS5f8KiDglFTuNNU6XqPrUO78BNzZOQvXXWnIVQwM8m6qU1HoCJfq41Y7hnHYwH+4Eq5kPpx5ZulfW5iqI7IKhmTzH9nezkeF7MyI1hpC9xulwChbwYyABh9yo7RS2vd9/aerLDTr0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sX5yweTilumokjX02w+xYbzRssY0cGVRoUqy5ULKp3E=;
 b=j05Kw16t1uDUQGgTVNThygf/rVKcPN+p3NePjfj4eQkHfinLuOMGVj9xyM0MiRC3Qo9fVejEGCIbPvHCy9M0or6gTh0dMRHIQL2dP+gul5vquEKpic8zebEJVzAFihRQ8RJ9pZceIDdT8Skw8EcspXyFdkQqz+KweIJ9WG3LHkK6ujZexnpUhHbN580F16SReeHUN+C6yEFpTN/sLWuy/AZpcT0pPPVymUht6uPy+pzSPWmtg/sYfswvJ2jyS0uif2Xjs3sO+nt2the4GdmhHbEA+zN0zrjvzAOeYIQD8divhTn6GWspS8nvhXI/KDfonYdGzdTCKNBr6rsfMxtSSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by MWHPR11MB0046.namprd11.prod.outlook.com (2603:10b6:301:67::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Tue, 19 Jul
 2022 00:27:53 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 00:27:53 +0000
Message-ID: <a6567482-0fcf-4bff-87e7-81a41a77e928@intel.com>
Date:   Tue, 19 Jul 2022 08:27:45 +0800
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
X-ClientProxiedBy: SG2PR04CA0166.apcprd04.prod.outlook.com (2603:1096:4::28)
 To CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3879723-392d-4db9-0b74-08da691d84bb
X-MS-TrafficTypeDiagnostic: MWHPR11MB0046:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fQdk6FHOfkCiIlzWuZU2ehhgbsrxvsS2EC1sO8aOSVHaRhlpbfNAzDW6DVGtNrFYJnhjDjZaDu88ckBzEdBS+cZfO68AliMIgZiZpK/HQd8sICQa/PFbEQfIQvD4w8hDU9I6L8AMJ+es8s4uJFR/20ROI6iiMq1PXXATR51/oNINcWCy9CVqa/QYoDIacZn1Y5JI9ZFRetu916g1O67rH/2w2JUQkUp/nr/5DTxLSSfm4dqWnSGHUMMI+omXKPZLMo4othK4sSrcCJihxChTuoLdc3OTCWbcn4+jn5niViMA3xFr3yJSbBkOtzdCwzEqIjM3sUzg846z1Ch07v05noqVQ3+4A2/G/aIq7l2Idz/bl5IryJqrIiFsQ9rLgtHz9lb4KYWsKizHQ2dib0Q8tpmhqKK+Ygb+bSzdTe0gZAZjOZfmR5BuYbEuKOIyx3OrjD47A69azKL5vo/tkV5l2Zlttn23UIzcat/eMzAxqcYMKXltV614AYWmYKFp5ydau1H7Kmj6KQIhF9ARH6+PyucE2g/qsR6hmGdtIFiL+I+pkHSQIR4vNPppgAI6yzqCe/MH6JRkq0rO/yBULps8PZCwG8IH72WQX+1+TO8ke5REgYHSl0rUPkrxXb47U3+qwF9CYH80xid43I4WUlfyj3Fi203S/vp3214EiszW6Dr7+6hpFeCjCA3+j3BjfbRsG9a8cOgtamM/wPYfzY/a6ptGmTPvYvZm9VXSdMSVO2h0zc2OmECkwhKh9lPSDpcIgpEvRDC37bY8OOXHKkK7obJ4EnU5WEY9S1CVXC4IQ1FRlmsue+5v1brqOwrLhMAq++wiU0kQ3lOwKT5HayzSPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(366004)(346002)(396003)(136003)(41300700001)(31696002)(6666004)(6486002)(478600001)(26005)(2616005)(186003)(53546011)(82960400001)(107886003)(110136005)(6506007)(6512007)(86362001)(2906002)(4744005)(5660300002)(31686004)(8936002)(36756003)(66476007)(8676002)(66556008)(38100700002)(66946007)(316002)(6636002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEtMdFRqU2JBWVdRSHQ0ZWVoL1R3aXNaWXlENEo3djJqb3VkUFdjT3VsbURE?=
 =?utf-8?B?Tlh4Q2tKOVRoeDlXSXNTZEZpM2Jmd2J6Wm80Y3k4VTRwdjNpd0Z2b0xvVWYy?=
 =?utf-8?B?TTFWSkZ1RndhbjBJOWJzR2x5QWtDS0hSbkx0WDg2NXhJbm8vZ2ltc09WcTY1?=
 =?utf-8?B?UDNpUUxsMFBnUEhudVNCY3F5N0FSOVNQc3lJUFZ6VmhRWkVlNjlQZ0RhNElI?=
 =?utf-8?B?TFhzTzRMT2owQUp1dGtaeWFTOVVDbmoxN0JDY01QZHF3ZWxWM3plTUR2T1pr?=
 =?utf-8?B?amsrVjZnbUpRUm9TUFZLQlZOZk11VStuZzBDaGNwakxJUi90and3dUU4eWNL?=
 =?utf-8?B?UjRSS3FoekJXUmw1UzdzeHdvRnhaVjRIc0RtbjY3clBRR05QU2xlZm5XYnhI?=
 =?utf-8?B?VzJ6Z3hDOC9SSW1adVRKd2xlVEY5Ni9OeWdaV2dQZVZvMVZ6bnpjVUVzTFds?=
 =?utf-8?B?RkhPYVF0UUZqc1ZBY1Nabk4zc0NvRUc2Y0R5OGRZOCtQa0MvajFLRXVkcHU4?=
 =?utf-8?B?N0RRSXY0Qk1YVVE5cmpORFp3bDlUQjhBc1RLL3M3bFFlYVBROStMalpxajlU?=
 =?utf-8?B?NHdSdi82VG9IaTRQWVpRbU9CK1RVamNyYkhiY1Y4a0llMDV5RGdVUHRYWkhx?=
 =?utf-8?B?OG9XWkNEb1ZhSGVjNHFDM2M1dlR0QjYweXNWZ2dTWWtEQTFJRU1rWkVEWTMy?=
 =?utf-8?B?RitLYXBwMjVramcwZ1pqSWlqWHhKWkxIZ1pONUtiVVIzQlE3M0JPQUlBYmpa?=
 =?utf-8?B?T01nQlQ4aSs1SDZrRzZ2eWhBWWtoMWE2LzZ2aEh5ZjdMYXBxUjA3NTZPVC9G?=
 =?utf-8?B?RW1nc1hWQzZKTk11ckFHQVFBNVVpNGFBWGhNMWRKQkJpSXJabWpORDJqZVEr?=
 =?utf-8?B?U0dRRFdMaEpIWFAvZjcrS0VyZTFEWGlFakpGY2ZtRUJmdDIxZlpOQW1ramkz?=
 =?utf-8?B?a1hLSDV2UVdyOUhsNFBNZ29TbDJKVWdidDZFY2xDd2gvdjNMVnlVYnFWNXZt?=
 =?utf-8?B?MUR6S0x1TnpKYlU5UWZ1RE9UeWJpc2RLSXlMOW53a1FzSHJlWkdHRGdrUEhV?=
 =?utf-8?B?SGJ5NWxQY2phTHpXc2dKY2w1YUcwVUpLb0xNdGI1ZDU2V3czaW1xTFB4VUw4?=
 =?utf-8?B?YkhGOUEzT0xHbmxrNUw1cno5R0c5SHpUK3Jrd0VxSmlIV05mYjRsRkxLZ3d2?=
 =?utf-8?B?emNNYzFJY1JWclZneVJPV3RoUDBraHBCbW9VbE5yQ2NMenZpbE5mZTF2NVlI?=
 =?utf-8?B?VFJKVnhnT2ttUVo2Q2d1cWNpZU44K1JFUUxDTlB3WitIOURtamw4ejRCZ2V6?=
 =?utf-8?B?akFRb2tUT1dUY281QnJ2L1RRZEozdldtTEN5VEZTVURPQzdRanB0T0J5eWww?=
 =?utf-8?B?VHdnbmlNZjNmeEJ5WEFySW1jcnZDdHl3UXVQMGpuaGRPVjdDRWNWak5NUG0r?=
 =?utf-8?B?YW1NdXZkTWVGZ2ZVU1duWXVUYTUwZCs0YkJxZXV5dzFheE1SWWJKRVkvRW92?=
 =?utf-8?B?dDcxTFppUVE4M3hZV0Uxb3JlQXNyYi90Y0pVcjlVZTNNSGx1VitWcTZoN2tr?=
 =?utf-8?B?ZHJKVVA1TEV2V2NEeTVRNm1vdmJpQjZvcm1ReEtPcDBaSjJMb1JPbytCVHdr?=
 =?utf-8?B?ZTluUWJWYVA4QnI0RjVkWldxRXNiVjFnR3lvVFRyRkpQUTNFSk0rZWVCSFhO?=
 =?utf-8?B?Vi9zRVRlSGk1ZG1JaThYMjhJeXF2R1pOM2tNTUJvdjJhQi9ZRGlNb1JUZGpR?=
 =?utf-8?B?VHVDa0t0UGQ1WENlTE5KcWl6NzJ4RzNtYVhXT0ljSTlWc1JLY2Zkam5haDYv?=
 =?utf-8?B?ODNyZmdkd1VCNFF0K0tWNkVqTFdQUkdUV3FPTGRHTU1wMWpwclZuci92SWYx?=
 =?utf-8?B?YXNrTU1FUGpiSlA0SXNMRG13NVpacHhlTWNURHY0M0VsK0JpWFJUYjR1Nzht?=
 =?utf-8?B?TEZZYWY3V1YycUxlWUNHRlBBNitCdWMyVUdMWVhMdVh3QlVjeFJGdnlYQlNv?=
 =?utf-8?B?aFd0d1dDZng2T2lEekNvMCtFb0pnU015OGtBU2U5SVg3bVBaYzg1U1ZEcXUr?=
 =?utf-8?B?UVpMTzRnQVdZQW5WaFlvSUJsWjFkdnAyb1BhcGV0cG1WNWlDY0J6TEtKMTRM?=
 =?utf-8?Q?3yM1gnArwr81n83hyDqAiR5IU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a3879723-392d-4db9-0b74-08da691d84bb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 00:27:53.1004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MMfvCzwqvHZOSkbYBhpphb/qA+UB0G5c8nx5LEm1sokFVShD2zZd/sdzMe/YPqFX5G4jK4xDqIz/3vdp7BLADA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0046
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
> 
My local testing system is also a vm with SATA disk. LKP test platform
is a native one with SATA disk.

I could reproduce the regression on both environment. I will try to use
nvme to host my local vm disk and check whether we could see something
different.


Regards
Yin, Fengwei
