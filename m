Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DC650E7C3
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237371AbiDYSI0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237543AbiDYSIY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:08:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD7C340E6
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650909918; x=1682445918;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=rU4S/WESKMzBtR0pcC9siTrtxb3luFt8o0tdhapJonY=;
  b=PYnTinQ9gjzqDpAminTBZeQTGXKXrklxBa1JDFcXMm7dlY1gld+wKhxY
   MGr/iivpVGUMUh4IXxYEPyiieoagV7AE/IWIYPcpOk1+nrEkRgt4GmxNl
   YJFOsuO+HCCCMXJBDRIQ8wDtLxxVWPW6WdEjRikYfHoMisXUXsvrz0P7e
   riPh34/MoxqxXAqXjMqyWeVO67DR8lYcYXnEP4eKP3BnSlH3HLrs9A8Ij
   PlHUa2tpN2MW7NORJY6CqQU9wSWsdRoie27uZqbBYic8rrDVoSafXUaeI
   OIgNJ5TapETPegp0pqOQrvXS9AOoR6j1OOOFurK+QdFFKLZfIoKIIlzcI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="252694368"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="252694368"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 11:05:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="579412350"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 25 Apr 2022 11:05:17 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 11:05:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 25 Apr 2022 11:05:17 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Apr 2022 11:05:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RM3uOOP1b20QdNb0LwETnVurB0fUM+8F9y0BNIlWHOoqvgH/Mlj5N0Ne/O3NQ6QTqRSbWvKxzK2om/FyDPisrQHfL2x8+2Hb3Yq3wCVVZn25LA7ckzlee/AtDhYoTM+7XNUXVMW+1+iwVANRRovo9Z+x81Z2yE1UqEm+nKkMgCiP4+kgzT5slXGaQ+VPugT5aB7un6AyXYwaGWABQbw81ve7i6z/QVIDVhlHMh3DUnHrUkGeuTAjMl/48x7uLNxgeg+1Sy7cyXN/H4AXYmLejENGc8piQbbI3kcfiuz5Ma7lOJdH/XlLiu696WqmAl0MIuXyrXoOzvIQV+X24PJKVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5b4uF+y0pXjUreo5Jcf/LLvLzlowi+9qZm3D73fewi8=;
 b=SxiwbpVb/pa0bNDsSkBnwsPsEQ9pl0yDjdDl6NS/DTZJcC16Cp6MhpWoZVVreJa5njag6MeHNjVja+Be7LVygdxCPGKFXXsS1RblTXEYIGoRK0revRyrQ9/DwPS7in8dk6CiVXlxYt+0Wcew69wEX5pZcJoKK6+F+AmjfBoGrK9pU/U8lWYzU9amsKRmqne/JPrqejhD/pJC0pxij+U6L+6w3WRvAW1x43Qz2uya0HJ+t9vKEbCr6n544+1EdjShu2vAUgSJhzlveeelPRgXwBVSFhc0y5euI777DinTOXjkahfgQOXgpzOOGjU6/T/RdRi1NOa9dAgVl3eK7316Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2824.namprd11.prod.outlook.com (2603:10b6:a02:c3::12)
 by BN0PR11MB5759.namprd11.prod.outlook.com (2603:10b6:408:164::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Mon, 25 Apr
 2022 18:05:14 +0000
Received: from BYAPR11MB2824.namprd11.prod.outlook.com
 ([fe80::b92d:4523:d758:69cf]) by BYAPR11MB2824.namprd11.prod.outlook.com
 ([fe80::b92d:4523:d758:69cf%7]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 18:05:14 +0000
Message-ID: <1fec3fda-152e-c03f-73ef-2ca4468ee069@intel.com>
Date:   Mon, 25 Apr 2022 11:05:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: memory access op ideas
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>,
        <io-uring@vger.kernel.org>
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
 <c03c4041-ed0f-2f6f-ed84-c5afe5555b4f@scylladb.com>
 <1acd11b7-12e7-d31b-775a-4f62895ac2f7@kernel.dk>
 <ee3f7e59-e7a1-9638-cb9a-4b2c15a5f945@scylladb.com>
 <d4321b8e-7d6a-7279-5e89-7e688a087a36@kernel.dk>
 <14e61ff5-2985-3ca5-b227-8d36db95b7bd@scylladb.com>
 <c925572e-9509-77bd-0992-3ac439fb0aac@kernel.dk>
From:   "Walker, Benjamin" <benjamin.walker@intel.com>
In-Reply-To: <c925572e-9509-77bd-0992-3ac439fb0aac@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:a03:217::28) To BYAPR11MB2824.namprd11.prod.outlook.com
 (2603:10b6:a02:c3::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4199b02a-0fd2-4421-37a9-08da26e62584
X-MS-TrafficTypeDiagnostic: BN0PR11MB5759:EE_
X-Microsoft-Antispam-PRVS: <BN0PR11MB575975C1469D7ADD37D3123DEFF89@BN0PR11MB5759.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QRH6dIvG3xOJUX0Sq/O1SpzCtOTSNCYJqVgcAr1suo1tCe7ZR7RtOs4Ewt1+wiCc1IwI8ocj87cKvV91figgmsdbw1Ihqo+NQu9D9Tshy50k+eAg0QG3F4zJdKPUzqO6ihj+XvOG7ZCsORwapQz0eC4w0PLNFtj8PUyODZoYxmFGR/QjBQQjEBfyJr9kuS/QZzuTVF49zuuR6UXopYcR4G6vPg5Cdi5MMzeWEA7sy8Im1tNzjYoc9n0wqLmrh8w5EnDs58X0Pv/oL/sKZzcBH5GesEKIiDHeGFIOtDe4gVqQnHAXa5gDGpIA+1IKxwNmlSv8par5x7r24bzqaJhmGqDwVU4K2zS8X2VkV/p2pn+eyC5W+1AE4XAGSKTtDAwiS5l3OySPdSemz7Eu54FWJoN3dvxecbTqt5VL8D/tn5JfJ1Py8GNrfmr8llh5Il6gLhArEW/+dOiRAUgW+KQB0//SacMJG3wXYbgNY1pvt7NZdeAFTv3DktL1w+dQlrZhjws64zZW9WkM8Xgsa8DlKFxjT7qB3zxaEK0eAM0fngZHZdqgKpOV0SneiwysKr7eSHLQyA0hdvYOlzMtGHOgsScZaNw5OB+pGuBmQPp5D2wxZnpgtvjHWNm1JxxU4adBAlaodBAGO2g4/MZ5C1jUYQxEQGIK2LkbGBg2I1Qg5iPhZSWOc+n0js79FmeWRJ/rVRrKY8ZhesaC0hdJ6AWMKaiL8IWMhkoLoXs/lYvyu18=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(38100700002)(316002)(186003)(86362001)(31696002)(8936002)(5660300002)(6486002)(83380400001)(110136005)(53546011)(6506007)(82960400001)(2906002)(508600001)(8676002)(3480700007)(26005)(6512007)(31686004)(36756003)(66476007)(66556008)(2616005)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDFWV2gvblZ0TGJXY2FUVkdtTGU0RU9QNzhCOTRCeEI3czB0V3ErWFhsOFFp?=
 =?utf-8?B?dkp6dHhnZjVDV0JDTXJPWWdUbDVISThiSE5YeGtGVWFUcFg5bzM5RXVhanlj?=
 =?utf-8?B?eTVSME5TRWpFM2lYSTFEZy9WaDZOVWp3ZUh4UE40em5wSXhUNFEzSFNYQ04v?=
 =?utf-8?B?cm9IaWw4MFNyRU1GUHZ2MHNkNG5QOHdNZ3YzazBaRmpicEFYU3ltTHRTdlJ5?=
 =?utf-8?B?MGFhUE9IelZQb1hSSEN4K1JabWN3TEloSkpNMXkxZUZONFRaUTZiL0RVa0Zo?=
 =?utf-8?B?M091TUcxb3htay9XaW1oWmN5TlRwUEJEamNwZzdMZm96b1ZES2dUc2U4Q1Fu?=
 =?utf-8?B?UGkxZ2dMZ2xDUnN4b0RJcXk3SFZYTUEySmRnVTJpalYrcWg3QmxZdE1VUXJ5?=
 =?utf-8?B?aTdreFRiNGc0ZmZUMVd1dTRPcm1vbHg0OThuUHdwajhRS2J6c2FJdGJpS083?=
 =?utf-8?B?elRGSHJKcktEOU9MektYZlVSQWl2NTg3WDFNcXozdS9wWGRQQUQzL0J6NG1h?=
 =?utf-8?B?c2dyam1QRGlFaTVJVllXenkrU2ZaMFh5Vm5oeHNVUmhGSW1uOEJEUkdJUSt1?=
 =?utf-8?B?cjJSWmNXUGlrZnNJM2dnVTdSVmRpbGtVVmFrQ0luZ1EyME01S3dMQmM0WHNO?=
 =?utf-8?B?NmloeTU1REhuVFNKN3JsdDNtQkQycmczN25xcVluWkR5TFNFRi96bUNud3Bl?=
 =?utf-8?B?a2JIUWUwZHNicU82K3VoZ3NZZXdkNDRsL0JibmVNNDNlMDVzM3NROEF4OENC?=
 =?utf-8?B?Mjg2Rjl5NkxJL2lZd2tBQ1dwQVhna0MrSnBvSGV1bEhPdUVTZUxOVkN0b0ZD?=
 =?utf-8?B?WDJSR2hURThyUDJyMFZtODRqU0V1YThVdSt6Z04rLy9UYSt5ZDhSSFBEYmZ6?=
 =?utf-8?B?cVBWdDNkTmZ0UC9QZWxRQUdBVnBvdXhiZDZtSDZveHhtb3JLZjlZbXpmL0JL?=
 =?utf-8?B?VE4rOWNQRzNneFBmYW8veVVJT3hRTWVkYVhHcDYwZFZVNDlPK0UxSVhCRFpJ?=
 =?utf-8?B?Y1JsWVlETkZEYUd0T3U1ZkRJS0Q0MWxCdmxaTVNNVG9rQ0o4SlpLYmVpMU13?=
 =?utf-8?B?bVhpeHNoWGVoRVIxMWFSL0srZFF0cVBKSXgvK3YwQzlMZzg5TWdaelFQZzNC?=
 =?utf-8?B?bHZ5TWYwV0RMNFhBREQwRFprV3EyL1VITitDVGltcVh4VXlGbnZmS1NVbDBL?=
 =?utf-8?B?QThpV0VUa0g3TWdwTnR4Y1Y0b0tVL1J5WXRLUDQ1RFZHYzNxRkZRc21xQ2kv?=
 =?utf-8?B?aEsyOFFEQVBkcWY4YmxSd1NNb0lDUmhzWFNuN2RmZGlVK3AvSzd2aE9zTHB5?=
 =?utf-8?B?L0ZtakZ5Y2Y5MG02QXl5U0xtditJMmtWYUZGL09VdlJPbGIwVzVsbUJjbFEw?=
 =?utf-8?B?Y0tVS09iN0dFZDQ5a2NQU2s0REk5U25XNktyVGtYeDl3YmVTSk5ST0dTSEpi?=
 =?utf-8?B?bnlyVXFGMG9ZamFTNjVVUmZ5MnVURkZVdzV0d2lNN1g2YUdteEs2MmVuVFZD?=
 =?utf-8?B?c013dGtPMW9TVWhBWDZIMXR1dEVZOUJVdVZwTzRCQWlMenRMZzl5NUlFVXJk?=
 =?utf-8?B?a2JLRmFPVjlBSUpQdW9tYll3c0VPbUZ1bE53VWYvSlBIWVg5RWVVTU9LZ1hh?=
 =?utf-8?B?WWkzYjRBb1BGd2hHdXJWMExGRWpETXZoamVaN010UzNOcWF3VkE4a3RIOGQ5?=
 =?utf-8?B?VUtBRlNjZVArZ1VFeFpESmV3M1NKWUVQMmV5WExvMFFLT0RobWNlN2ZGb0t0?=
 =?utf-8?B?S0dJdlFSVlRxcnAyeUhRMnViRk1QUXA1T0xLd0p2d3Z3d0RoczZwaS9KRnAv?=
 =?utf-8?B?ZWIwcUJtVmFyNFJqUHducFJUQTgzNjJxLzdGZU9MNFpFTTZiS0lwU3pqalBI?=
 =?utf-8?B?TndWWFVucG90dXpYNzc1cTJuZENSM0JnWDJLcFBqQWh4bW5NQWIwL0tWWGZH?=
 =?utf-8?B?SGNwdEt4dml3dHlrT3VYVitBRDN6SlFHbnJsY3VJbTl1dTJoWGtDaFcycS9z?=
 =?utf-8?B?N1RVUkVGbVhwVlVvSWoxSTRrZTNzZ1Y0T2p6OVpmR2EzaGJBanBYa1lTUkNw?=
 =?utf-8?B?d2RleUZyTkQ3emI0V1FXYXBqdy9FN053UERiMFlGZ2F0V1U0SkFlR2hzUzg0?=
 =?utf-8?B?Y0JVUUd0OEFFY0pxSk9Yem5kb01qRjhWbDM5UWtkY0E3bTRGamcxOHdjMkQz?=
 =?utf-8?B?bFBFVXdQcVIyZ21QcmpTam0zRTB1c0NJbzYvVDRudzMrcTN2a3RzMW5sejBo?=
 =?utf-8?B?akp6V1lGREE1Rk1uajR4MllKTTF1ZUxjY2g4ODdUdWFFYVFUdGhQM1Z3Rnhp?=
 =?utf-8?B?UlYrZDBsRDBQVWwwTThlQ3FrdzhJd3VTeEtsTzNubis3c1R4aytBckJMeGVI?=
 =?utf-8?Q?JA+d4ytvXKqlaLjw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4199b02a-0fd2-4421-37a9-08da26e62584
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 18:05:14.1195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mrwFGYA1TRLQF4cgGri9Qb30baiLR3rSKF7DpAwERS0Iivnqc2Z1TDeyOmjf4eyPC9UYu7p7Ic+8YIHqHJZ4kobsueWicSAmJSa8fdjrF0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5759
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/24/2022 5:45 PM, Jens Axboe wrote:
> On 4/24/22 8:56 AM, Avi Kivity wrote:
>>
>> On 24/04/2022 16.30, Jens Axboe wrote:
>>> On 4/24/22 7:04 AM, Avi Kivity wrote:
>>>> On 23/04/2022 20.30, Jens Axboe wrote:
>>>>> On 4/23/22 10:23 AM, Avi Kivity wrote:
>>>>>> Perhaps the interface should be kept separate from io_uring. e.g. use
>>>>>> a pidfd to represent the address space, and then issue
>>>>>> IORING_OP_PREADV/IORING_OP_PWRITEV to initiate dma. Then one can copy
>>>>>> across process boundaries.
>>>>> Then you just made it a ton less efficient, particularly if you used the
>>>>> vectored read/write. For this to make sense, I think it has to be a
>>>>> separate op. At least that's the only implementation I'd be willing to
>>>>> entertain for the immediate copy.
>>>>
>>>> Sorry, I caused a lot of confusion by bundling immediate copy and a
>>>> DMA engine interface. For sure the immediate copy should be a direct
>>>> implementation like you posted!
>>>>
>>>> User-to-user copies are another matter. I feel like that should be a
>>>> stand-alone driver, and that io_uring should be an io_uring-y way to
>>>> access it. Just like io_uring isn't an NVMe driver.
>>> Not sure I understand your logic here or the io_uring vs nvme driver
>>> reference, to be honest. io_uring _is_ a standalone way to access it,
>>> you can use it sync or async through that.
>>>
>>> If you're talking about a standalone op vs being useful from a command
>>> itself, I do think both have merit and I can see good use cases for
>>> both.

I'm actually not so certain the model where io_uring has special 
operations for driving DMA engines works out. I think in all cases you 
can accomplish what you want by reading or writing to existing file 
constructs, and just having those transparently offload to a DMA engine 
if one is available on your behalf.

As a concrete example, let's take an inter-process copy. The main 
challenges with this one are the security model (who's allowed to copy 
where?) and synchronization between the two applications (when did the 
data change?).

Rather, I'd consider implementing the inter-process copy using an 
existing mechanism like a Unix domain socket. The sender maybe does a 
MSG_ZEROCOPY send via io_uring, and the receiver does an async recv, and 
the kernel can use a DMA engine to move the data directly between the 
two buffers if it has one avaiable. Then you get the existing security 
model and coordination, and software works whether there's a DMA engine 
available or not.

It's a similar story for copying to memory on a PCI device. You'd need 
some security model to decide you're allowed to copy there, which is 
probably best expressed by opening a file that represents that BAR and 
then doing reads/writes to it.

This is at least the direction I've been pursuing. The DMA engine 
channel is associated with the io_uring and the kernel just 
intelligently offloads whatever it can.

>>
>>
>> I'm saying that if dma is exposed to userspace, it should have a
>> regular synchronous interface (maybe open("/dev/dma"), maybe something
>> else). io_uring adds asynchrony to everything, but it's not
>> everything's driver.
> 
> Sure, my point is that if/when someone wants to add that, they should be
> free to do so. It's not a fair requirement to put on someone doing the
> initial work on wiring this up. It may not be something they would want
> to use to begin with, and it's perfectly easy to run io_uring in sync
> mode should you wish to do so. The hard part is making the
> issue+complete separate actions, rolling a sync API on top of that would
> be trivial.

Just FYI but the Intel idxd driver already has a userspace interface 
that's async/poll-mode. Commands are submitted to a mmap'd portal using 
the movdir64/enqcmd instructions directly. It does not expose an fd you 
can read/write to in order to trigger copies, so it is not compatible 
with io_uring, but it doesn't really need to be since it is already async.

What isn't currently exposed to userspace is access to the "dmaengine" 
framework. Prior to the patchset I have pending that I linked earlier in 
the thread, the "dmaengine" framework couldn't really operate in 
async/poll mode and handle out-of-order processing, etc. But after that 
series maybe.

> 
>> Anyway maybe we drifted off somewhere and this should be decided by
>> pragmatic concerns (like whatever the author of the driver prefers).
> 
> Indeed!
> 

