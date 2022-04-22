Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9031B50C32B
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 01:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbiDVWdZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 18:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbiDVWct (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 18:32:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82792BEE96
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650662772; x=1682198772;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=6HVPKIT8YWPaqTwWDMHfwemyumlmE7HoktIqFzrDaFI=;
  b=UPOVl0uZY7siFxiDdpA1M6GbFiosXFi2cskJjbj9jRtBcjG+9Diglzim
   0gkK8OVnv1SU6XS5vKEWTSGQY4HkDRgt4bK6FTrjDQRLj3n2ICwFSSgX0
   ymJJL4F3zkX4jITN+iYy7mt6P9BWtCIo1t87itTDTk+4naXnTtmaHuOox
   PB/ECvfJjIJSTk/hp1z6CwHE68nzwOly+cwgjLu0FdROz7Ped6NLEtqHi
   nJydCbxxvCqoekdAHaoj2iC1YYJEFreoBMxSAfxbfKsqc5tR/da6/wo+z
   lhnlPCjG9G4GDKiFC63RGJ5PUsmfcZAUGN3Qaxs7XIPMc6+brlwXmRbZt
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="245345437"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="245345437"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 13:03:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="806136099"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 22 Apr 2022 13:03:10 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 22 Apr 2022 13:03:10 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 22 Apr 2022 13:03:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 22 Apr 2022 13:03:10 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 22 Apr 2022 13:03:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IbgHBWtBgwKVsmOMovRd9ggGRwSUZLpNfZoFW2fdlVLJzsU6Rhoqe/kl/jVK/ViwcXVJuoqr+ZWc7D6cyaSM+ZlHefAX2R4HGSoi/yn2ZocblQmVGcxAlVVF/bc09PfD2xx97V85Z0RK23tpBZWJ6dMedp+zwMFEZRW6TgoXruWBoOxHRixs34vF66klAdD0Br5tHshgcsPjMh/uhQZTLJre9v2a66BWiYpm+e43Buv3Je3NJ3oXtOWp4IOkmfjc8656hUSBzbjt825idrBIkg9jGLcLq9X+CYlD2x6FMbcuNhXEfXLChpSdjR0SSF1tjXGfK7mWQTtSieZJSCun5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ZbhOkPEqnzu4T+007+bOeHhQv2mC6RLbkL7cffdELc=;
 b=fShivY8FOT1edN6DtCAg6lp2AgdHEKprLUlLAu8jC+8wumW38FJ+pTZq+kCJr4O/ayWSTWmQbiMSKqTRKt9u0ZvUUu2+8qwAqq41xl/3hPaR5tbt0rd8i17Eo+zE/vCK51sOrvjllaGvQQnx2aKdNkvXfp9ltHe6LuR7ZTeaBtjYwMbL1kYLsmAeUIiKMEcjiPPaJb7jpJItJV6uRPM4f+LeqjTTcz4lo23ezHxUCeT8Byxi34gUZMAd4VWkcPIlkKqp+HDdwgs9d4kHvmNll9aOaektOUrgYiQNjcWfJgBzC5UCOwxM3FGV0mWeKlmcXdQSU+W/oxIjdhCPfk3/sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2824.namprd11.prod.outlook.com (2603:10b6:a02:c3::12)
 by CH0PR11MB5691.namprd11.prod.outlook.com (2603:10b6:610:110::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 20:03:02 +0000
Received: from BYAPR11MB2824.namprd11.prod.outlook.com
 ([fe80::b92d:4523:d758:69cf]) by BYAPR11MB2824.namprd11.prod.outlook.com
 ([fe80::b92d:4523:d758:69cf%7]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 20:03:02 +0000
Message-ID: <d48eaf9a-1e7e-0355-2a23-456f9cd5b0bf@intel.com>
Date:   Fri, 22 Apr 2022 13:03:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: memory access op ideas
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>,
        <io-uring@vger.kernel.org>
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
From:   "Walker, Benjamin" <benjamin.walker@intel.com>
In-Reply-To: <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::8) To BYAPR11MB2824.namprd11.prod.outlook.com
 (2603:10b6:a02:c3::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a50acd97-aa73-49a6-8a27-08da249b1b31
X-MS-TrafficTypeDiagnostic: CH0PR11MB5691:EE_
X-Microsoft-Antispam-PRVS: <CH0PR11MB5691B1BD89AAAB345FCFAF73EFF79@CH0PR11MB5691.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Byq5xqI0/iqu2LK6iJgjGMpIEAozBjQsONQdJypmqCGi2xylZvKVlFojYCas4fLjR3sTVw4InkRwQXub0s/C+iLekVPfOx7JSG5csrexUH/I5s3vvXS+ntqmnBaOO2i714FwDQKaUEUOdZGCDsanoDSoP5sFrqIuuJZ/6G9T7S/3aQKIt1IoaSv01Y7+7QbGGRF/hdSoTUeJbScuKY1iWRp0Vqdcq32aLMud/Yfl9JFSTJDRfZFirEHrwNNd8V2U9RgpPiwrzpo+8afFTpoR0SZ5tTmVY3dR8rklRt4h6ZUTep3scRDoZfPOCIDXZhbx4FmTB5KmH5AiLnPACxXW8F+TcanBP8Ch7R5rVkDN0W59KGenD+2QyIJ98bDM0PbiYs1y2Xo62H62+U/CeilcDCY++2W1UjVFvfgaFasJCiY3N/m64I985ygjqlGYYa7c8Muui1JZg/EE3WXQ1KhYhnKVt299L24i5lV5YtZkHAyuho0iHoIMtBL3q8taRYOeoR4rhyIByItyU8xLOTe4iHG89o2Nq8NbqSp4LrFzMrA7z4GEotsLi4FoIRIn1d9RFZtSZXtKu16fao9Oks9n8X2XmAzpWOXxZJ7NX/vn8oe9DHoRQSzaSn+f9cQSTg9+RK1d8pKampw1KoPOMtNZkZDNLUrBR86aUVZV26eIS+YpJG7bv55JwK7twKp3NEpqHTurVjCptE/R2RLhwYJYs/AmCjzKEdoNfuCzRqtQcSpn+y8yBjB8upbmEaptk0VP/fhVSXpB6tZ+8UePNeNZBVwmDo4ZAWYDpun4dI+iqQPy6lf5wxl87bilEGlTO0nQmea5UuUfy2QHRKr/NvVLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(186003)(3480700007)(2616005)(26005)(36756003)(6512007)(31686004)(83380400001)(6506007)(53546011)(110136005)(38100700002)(8676002)(66556008)(66476007)(82960400001)(86362001)(31696002)(2906002)(8936002)(316002)(5660300002)(508600001)(6486002)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1ViOFBuVmtVaCtTalFYbDBRaktpR0RWY1VZYk1SS1VLeFhabU5OOTBBRktT?=
 =?utf-8?B?YnBxb2dIOHlqaWlnWkdiV1RCRkMwaHJ0WGpVRkpYa2Z4c0R1bFJwQTFkSUF0?=
 =?utf-8?B?dGY4SCtqME1XLzJBdy91MXVOTGppamNWSVFRQVNjei9USXRCUVoycWxYeTN0?=
 =?utf-8?B?QmxjUmJrNzZ4MktLR3o3bG93RFdGSmFiRmxWT2lBZ0JRWHhjdVNMTEZCUWpN?=
 =?utf-8?B?Y0x5c29DemFQeUdxNkpSNTZLNnR0MFNqekhZeHAwL0J4dXp1LzB3WURKYjVH?=
 =?utf-8?B?QTRSbWk1TnlQNXhuM01BaDFiOExyUmNWV3pMYzA4WE9ueHFzTVRpMk90MHdx?=
 =?utf-8?B?YksvWE1aUlpGRGNVanNsWE42Y3RzOXRFSU1DMXl6UWsyaTd6czUzNDRab2FC?=
 =?utf-8?B?VmJBOGM4a0MyeTEwOWplcDFraWFPUmJsVTNIbmRWalVheUR4OEUzV0IwVmh5?=
 =?utf-8?B?WUx5QnE5a2VZOE1lZWxhTlJud1hEa1FkNFB3Wkh4bk81M3k5NW4zU1JrdHBz?=
 =?utf-8?B?cUdMYjU0U3gvdDkyTm5LU2Y1Q3l6K2diWGZWUlo2REIyWDMwSjd2UFRuZnNx?=
 =?utf-8?B?bG43Zmc4ZWR5ckp2TlkxRmRpZVhYdXAxaTk3ZUtFNmg1ZWg1OUFaSXNsTWlu?=
 =?utf-8?B?OEJocEZKcXdROG1LdlZnSDRDR2c1ekVmMWYyTGF4RkxweVRYc21MY1FTTDdJ?=
 =?utf-8?B?NjFacE5ZanZzZXUvWWl2dFJzVFVNcjFyYWQ4M01YRktHdDhobzk4R1EybS9V?=
 =?utf-8?B?cU9DMi9LUGEwTERMblZocWlBZitueHJZNUdJTDEzOEltN0lPR0JqM3U2Uitq?=
 =?utf-8?B?WlpGdUlhM005NkZQL1FBbWV1bHFuNVpXdDVPdWhXaVV1VWUxVFpLNCtNUkNT?=
 =?utf-8?B?Zk83WG8zQkNBMHdJNWNackhxQklmNUtTMTk3MGl5TGFxVXErcmhwdEpsSFFn?=
 =?utf-8?B?QjN1U2NnUGU4V1F5SE90NmprcnVMbGVLVGRuT252UUdablJRdXJpWGxESmNQ?=
 =?utf-8?B?S1c3cDg1MGgveThkRlV1b1VlZmt4ekpSaVM4dDVlZGt1T0d2anc5OVJMczg2?=
 =?utf-8?B?WnduaTVMTWFHcGxZYnk5YmpDSlBxK2RyMGZTcWV5aDFSZ1JIK2IyMDQzUGY0?=
 =?utf-8?B?YkpyK1F2YnA4RXk5Skx6UmZhTExyNDdlSWdzTXE0VU1uT2JGN1pJTWk1Z1hU?=
 =?utf-8?B?bkppVnVzRndWOFNQWjNsbUhiZTRqRFIxSzF0enZZbk1ZakdoRUVQQUZxRnlu?=
 =?utf-8?B?Y0x6ckVYODdqVW5pSlFUSGFCV3hEa2o4ZllnTHZZbEVFbjhQUEFCcndKeEU4?=
 =?utf-8?B?eHNQempqS1ZwdGJzckY0MTdmNVNUempzc0VFUjdmQ2JIZy9xRTcrNytDd253?=
 =?utf-8?B?dnFtLzBONmNiOFJXazBqN2Jwa2E4OWk2d2lIbEVEM0RGZGRBWldHamdhZmpl?=
 =?utf-8?B?cFViRWdibjRkanZ6emJaMjA2WGM4eWpmRVlDNVNiTlozQmNHNW9OdUpPNXF2?=
 =?utf-8?B?bUdPYTIyNXdkb0NRVklZK1lCMUhNMkk1UWUyY1g4bERXT3IveEVyM2VmUC9p?=
 =?utf-8?B?anlFdmdocUJWcG96eUNyVGt5ek5zUGJsdXg0dVFCOVYzOHZoeFA2c1c5TTgy?=
 =?utf-8?B?ZXpscGdidkxrcFVyYTE2a0hYa0NHNFlXc3REUzZHd1F4ZXVndEhZdHRLN25n?=
 =?utf-8?B?K0luVlFqaWJibFNnK3FHeXNNZTlNSmpMOHpVRWlRNFJNZ3Y4RWtiV1EzMk1F?=
 =?utf-8?B?UU1ZVVFNd3U3L2pMbFZYay9ieWdrTzY2TGxKdlpGT1lGNFBLWjM0eHRvUTJl?=
 =?utf-8?B?alcxUUZmWEp3T0pRZ0NiT2V2VTU5ZmxtWi9GYkttdUNXSjloZCttRkZtSElG?=
 =?utf-8?B?azRNSWxWeDV3bUN6QSswdW1UejljUkZUdFpmN1lYYk5jTERQL2VMZkZ4ZnZp?=
 =?utf-8?B?d2pLNGwzeEZiSWpxczEzdmFNWkhkSFM2RXVJZ0FsUSszcmZjZ1U1OWVBVWpK?=
 =?utf-8?B?Z2U1QlVNak1rN2Zlay9RcEdIRmZQMkRteUdpTzZZbDVRVUhiclV0dzJVYi9K?=
 =?utf-8?B?VTRCKzJycFdwaHpBK05za3lmMDFJY0FUQzEyNFpFZXMzQ1JWcEZnUWZWTVdW?=
 =?utf-8?B?cG41cUk5SVAyQngxWXB6dmRMQ2Y0SXJuaTdlajBpcWE4UFNzaGt6ZUtIQUk0?=
 =?utf-8?B?amR3d1phTS9HdDg4ckNtekZlOVFQeEdhZWlQMGZXOHRGZDVVTDQ3ME15OHNo?=
 =?utf-8?B?VUJQeHpFM2dlOHdQME1CR243VXVEU2k4ZWFUczQ4L2VuNVd4U05TTjQ4cUMv?=
 =?utf-8?B?dUJ4TXFuQ3hkNGh2N2RIdVYveE5rMVVUTWQ3TURmdGEya1VFKzZVTUJBVHVo?=
 =?utf-8?Q?1pZCOBif7tQH3uaU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a50acd97-aa73-49a6-8a27-08da249b1b31
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 20:03:02.2202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UTcD3oGAHDmipECwbqI8oNKS2uHq+ekplDzYFXeCEFX3Ns5EqkvxEXIPeRySJ9+DpxX7668JID9sxkHGy2GT1Y9/m5qd3suH0WNBtXyGEc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5691
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/2022 7:50 AM, Jens Axboe wrote:
> On 4/13/22 4:33 AM, Avi Kivity wrote:
>> Unfortunately, only ideas, no patches. But at least the first seems very easy.
>>
>>
>> - IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op
>> itself (1-8 bytes) to a user memory location specified by the op.
>>
>>
>> Linked to another op, this can generate an in-memory notification
>> useful for busy-waiters or the UMWAIT instruction
>>
>> This would be useful for Seastar, which looks at a timer-managed
>> memory location to check when to break computation loops.
> 
> This one would indeed be trivial to do. If we limit the max size
> supported to eg 8 bytes like suggested, then it could be in the sqe
> itself and just copied to the user address specified.
> 
> Eg have sqe->len be the length (1..8 bytes), sqe->addr the destination
> address, and sqe->off the data to copy.
> 
> If you'll commit to testing this, I can hack it up pretty quickly...
> 
>> - IORING_OP_MEMCPY - asynchronously copy memory
>>
>>
>> Some CPUs include a DMA engine, and io_uring is a perfect interface to
>> exercise it. It may be difficult to find space for two iovecs though.
> 
> I've considered this one in the past too, and it is indeed an ideal fit
> in terms of API. Outside of the DMA engines, it can also be used to
> offload memcpy to a GPU, for example.
> 
> The io_uring side would not be hard to wire up, basically just have the
> sqe specfy source, destination, length. Add some well defined flags
> depending on what the copy engine offers, for example.
> 
> But probably some work required here in exposing an API and testing
> etc...
> 

I'm about to send a set of patches to associate an io_uring with a 
dmaengine channel to this list. I'm not necessarily thinking of using it 
to directly drive the DMA engine itself (although we could, and there's 
some nice advantages to that), but rather as a way to offload data 
copies/transforms on existing io_uring operations. My primary focus has 
been the copy between kernel and user space when receiving from a socket.

Upcoming DMA engines also support SVA, allowing them to copy from kernel 
to user without page pinning. We've got patches for full SVA enabling in 
dmaengine prepared, such that each io_uring can allocate a PASID 
describing the user+kernel address space for the current context, 
allocate a channel via dmaengine and assign it the PASID, and then do 
DMA between kernel/user with new dmaengine APIs without any page pinning.

As preparation, I have submitted a series to dmaengine that allows for 
polling and out-of-order completions. See 
https://lore.kernel.org/dmaengine/20220201203813.3951461-1-benjamin.walker@intel.com/T/#u. 
This is a necessary first step.

I'll get the patches out ASAP as an RFC. I'm sure my approach was 
entirely wrong, but you'll get the idea.

Thanks,
Ben


