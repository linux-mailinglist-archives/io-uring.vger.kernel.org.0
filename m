Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9FF50E944
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 21:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242882AbiDYTRq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 15:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242232AbiDYTRp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 15:17:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D552E0BA
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 12:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650914080; x=1682450080;
  h=message-id:date:from:to:subject:
   content-transfer-encoding:mime-version;
  bh=uvHwezmduvrcXEymMgHu2Py8gzeGCm4wRB1LJ1LjafI=;
  b=egsVGmYknbo5JxoCNm/VdDXs+ixSAcnvtdPMOX1Nl8HJxMDPSXShrEEA
   VIEHTvPCBazUkSofVP78zrtdlnE7SZ0XgnDDF7gOSEee4lElRUi0rKJOD
   DTR7hLQ2UP4jy4/qrAM70rtr+Nkyvw8CH/sGGBlp5Gg/CcSJ3r6fSYI1h
   ekfkwC2Fg/W90KCHE/3roO+zFSV6UGox2iJ6tPlIkUrPjMPbFn/W3MlIb
   y5N6x8IinjyYeux4mseqJe8xm3UPPk0e8cv/iVNtbpnZv70AJ9uwx5yzY
   9MD4IGCnhN0+DBx8bc96kzQVzLgPXKP7X+YlkcRpi4y4pERBqz5Pjxzqu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="262939486"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="262939486"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 12:14:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="660295091"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga002.fm.intel.com with ESMTP; 25 Apr 2022 12:14:39 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 12:14:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 25 Apr 2022 12:14:39 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Apr 2022 12:14:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTXLHXfVE1wAbloDwPyBRwGmeusYkeci680xBPsklKyrmUJXXnQcrqCEyXqpDASlE3K3hSzmb8chCrtZ8QFcpOwT4Nhi0zqptQDPSaJ4DIwSa53Ry172rNtEzGOo+9RtqSKBUsnShx+9NZvGve68oecDISevrDz684xYF/xwzkdptJ8gd9XF7zMgZMQgxKEz5LThSg97HtcW728IDCa2RaKYD7zh3Do4plD7uVcnm7Y+dm8nTt16VIpVrd04LR8X92IsO8vPw6ZSvo/Zm1XFvibYQaJ+I+oONTreosR1O5U5Ub3wVDmm6oyWkj5UDwzXhDk0IoPpjdwTflK3Fw4Wkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sabD6DVL+DN46Ie80uNm+D+Wf/EFD1PTI+PlgxZKeJQ=;
 b=PfDYAo9sNxWp0w9hryDlwWzOKtNFzNworMyIYjVrki6Wd0CYF7+tuIHBh078Vr1gDb5K0lqgZvbkQQg4F4bQIObtzQKuXoOi3pDroOmKQK4j1JexvCqkr1CRE9fK/Nv1DKPmpOs1HlZdcADvzwwUSbptfX3gMh3S4GbMg0O3adsTf3dbGQ7BVa+gboyRUp3lm4cTkWNp5ZWwYFzw8KVXschw09BbOvKsCJmJpFq6tuaF4qybp8QhfghbJwWknp8ljuelcZ7WwAn/V5Vu8T9v8A+3Pdr/m+yyoVgTKY7DfSKYWYH5kAgaglUDffSFa9jDNLwt/NB7nW39kpxegyFfFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2824.namprd11.prod.outlook.com (2603:10b6:a02:c3::12)
 by MN2PR11MB3853.namprd11.prod.outlook.com (2603:10b6:208:ea::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Mon, 25 Apr
 2022 19:14:35 +0000
Received: from BYAPR11MB2824.namprd11.prod.outlook.com
 ([fe80::b92d:4523:d758:69cf]) by BYAPR11MB2824.namprd11.prod.outlook.com
 ([fe80::b92d:4523:d758:69cf%7]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 19:14:35 +0000
Message-ID: <4ae47d07-d3ce-34ba-2c49-4a4c64e8e4b4@intel.com>
Date:   Mon, 25 Apr 2022 12:14:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Content-Language: en-US
From:   "Walker, Benjamin" <benjamin.walker@intel.com>
To:     Jens Axboe <axboe@kernel.dk>, <hch@lst.de>, <jgg@nvidia.com>,
        <io-uring@vger.kernel.org>
Subject: [RFC 1/1] DMA offload for io_uring
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::25) To BYAPR11MB2824.namprd11.prod.outlook.com
 (2603:10b6:a02:c3::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2785f1e4-a287-4b11-7054-08da26efd614
X-MS-TrafficTypeDiagnostic: MN2PR11MB3853:EE_
X-Microsoft-Antispam-PRVS: <MN2PR11MB3853008364FC34198FD23474EFF89@MN2PR11MB3853.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jrnv9JwSeRhd55jnMRNr7gGB7TX6dx1MNetb21gzahtacXlXgMrxc9AmfFChArZhMTwp3eF9yHbCSuylC6BsyZ+z8twGxAgbdX5UBEG3GvuAoXiIVBfdWp9R/5JYplChM9gcrCYaWE+kJekmvCe9dIqLXxmH4W4TbYQtD4F3aIUp6WGMbA/0I4SVhHiARrSMvav5ESbOTZzCrUF7baoiXdhTEImBcz3KGSOLFR0MtCjma5/EIJSAdvQT7SEQjHyGwCF5x8eONNbY3PDyjnOtyxpZ+BLUFqXswQlhmGTIPwIZjRG0st7F94DEmHMyndvWmkyefN57vhXq5kJmO4XS+V7To9T1zy7ocCuRHYUOJ8UsMGC+CXbkAN1S/ytg1szJBB0l8SsQFMqi8sbKlPTdmT5JObVTr5Q8GWmHtnwPUYwxyE4timBUtu4tdrUIV/dn/6BNib52Eza8Gc4cGSmngl1rF5yisJtgNdGhl7mNdBoGYV1S4w0fnGOcZVJllAgY4U1noUtHhcitwDzM5fOCNumi0Sy6k+H5rWApUX6LJIYR+mfu2c2qU2KhZJyQ1osrkerGZ+R7mO+T0PWUPk/1tMGhjG6K9sPXsNb2DW/vf6DRXTrXYYTOSB4uf6HrEe+EXDkQYICS7p3WyWIHIvioHtYFqAlQFWfeKtOqxO6gis6/kvq4tOEt2OVGyAvaFfOIa1IqFMk9zb3miPcbqmBQgd1tNv4zpOWuOKISGiS4CNmj0Z6v+CTLV7QBsSlRHMu+ZjExDXJ9zK1bX/AZ9XGwaaxZ0EtEuQAYqA07Jg0ahU3OALxB6ZKa1z8Cf+86bzjzA4PcfX+CLe9IPy3RpCOb6DCx5QJCrkztAQKaeaT3zo4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(2616005)(66476007)(186003)(31686004)(66946007)(86362001)(66556008)(31696002)(36756003)(316002)(30864003)(5660300002)(8936002)(6512007)(26005)(966005)(83380400001)(6486002)(508600001)(6506007)(38100700002)(2906002)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUgxV0JEL3FyZ2ZVemx6elNnTTl5bTU2TE1VUnNiaUpjQXJWUHpXMjUzZGtQ?=
 =?utf-8?B?OHhPWmVZNWh5Q21LNEk4U2lieHQ3Vk8weUNsTGMyRlZEUGJSUXZ1TEpjV3BZ?=
 =?utf-8?B?Q2U4aUNPNnlUaWU0Rno4VWM2UndUTTdTUDFHN0RJODVqSSs5L2lYYWhRWXYr?=
 =?utf-8?B?WlNOZUN0a1l1cmx4QWpsVkFxY2x1TVcyRXprU0xwakhqYUFlbEhQM1oxelNN?=
 =?utf-8?B?VHZBNlAvbXB3SUUxZ0dVV2didVN6WEtoenBHUnQzdU9nK2xObHh0bVNaM2dV?=
 =?utf-8?B?NzBVSlQrc095NUpRV2xGcERkOTAvVWV3V3RWYWlrdFM1NFBhekQvS244Mnhi?=
 =?utf-8?B?SUdBTDF3ZHBnOS9wcThsTSt6dXdzU2E2MWVYY3UzeHlnKzBheTNHcndZTDRi?=
 =?utf-8?B?TWNZSTE0RFU5V0FtUk1OUEtmZTU5TUE5OCt2SFYvOGY5bmdmamh4bTY1WEk3?=
 =?utf-8?B?L3dYZ09POXNuV0hROG1aK0JybC82ekZDR0Nnd0VxR25XaFhCcUpqYkt1U2dk?=
 =?utf-8?B?UHNObFlnRW1QbVdFMWNkR2Z1UnY5SVNia1dkQmE1R2Nvd3pUVkdSMElFS3ho?=
 =?utf-8?B?bm9Yd2FZaW9sT3NQamE5N3p2azUvTEYySjdrR3NUT09Gd20zcDNucGUxOCtP?=
 =?utf-8?B?dkQzOWdDSFBxQS9GZEpDRFZKcENRTDQxVS93UjBWTnZpZzdidDdlbCtRSk11?=
 =?utf-8?B?cVRLUmFQL3lKY2o3VXk4WjJLVnQzUEE4amErYmV2VHAxNitwc2lScVpEUzRz?=
 =?utf-8?B?V0gzcEpTK1NGbGppbkpGbVY4ZkRPekFJaG9EZmZjZmQxNTBiMWdSTHpOckRE?=
 =?utf-8?B?OEV2NHppRUtMYTVreTlVSFRsVE5wM1hqKzBSVEZ6UjhXK1RVZVIzOXdQV0J6?=
 =?utf-8?B?akVkN1Yva2tlbFM2MS9DclB1eXYvbmlvU0hnWXY4R1JaYndiNWNpL2lUNFdq?=
 =?utf-8?B?bVpGRjZzY0o2VlNDRnl1cjBjTUFlYmRBVWVEWXZVYXVKN1BIL3hYSVo5UkJm?=
 =?utf-8?B?QmtXeTFHSGxZTWJrRGNLY1BkMjdZWjBPamUrK3VNTVVnY0FwTkEvYnYyTzJo?=
 =?utf-8?B?TEw3eDNnYVZ1RHh2Qjd1WGtvRHkzeFhRdTcwbm5wbVZVUUZOeUJZd3lpWVlN?=
 =?utf-8?B?TnZaUDJiOUh2aEdTK0FqanMxSjNtUTliL3huUXB1MHlIL2FqTVExVU9QVW1M?=
 =?utf-8?B?elB4Qkc2N1VFOU5TRk4wVkEzK1F6ckpFOFhFNG5BZWVqOHdIbkhtYWFWRlls?=
 =?utf-8?B?d3J5K1hkSzEyZ2J2YWZlamF6ZlpuYjJUSmc2dmxHSTR6YXZ6Sm8zZlh6alpp?=
 =?utf-8?B?Z1MrL0YrdnFRaC8rclZDcUhLdjdjZk83bzdYcUxPalpOS3JpQjJiQUU3ZUxs?=
 =?utf-8?B?VW9lcUtrM0trNEFGSUpEYlVYNGY5STlhZEVkaUNhZ25Md3Bka3Q2WFNNRi9w?=
 =?utf-8?B?R3JUR0kzSXZ0Yy96bTM2MERlSzhJMkJZbisyeUZzU3hISGNnR3J4U1pEYUNT?=
 =?utf-8?B?a1BOSTdkREJVbHR1Y3R2d3RES1E3dTI2MmE0eitvQjFZUmFnb0xETk1xa0Ix?=
 =?utf-8?B?aWxES0NuOWlraTVuR1UvbXFMSEh4bUJsUFdrTkFaK2Rnd25DTWFEMU1HQWt2?=
 =?utf-8?B?SmVoSkw4bFFKSk9obFV2WUc2UFhMZmI0ck1kYWwyU05aVE8yRVR5S0NDNWhI?=
 =?utf-8?B?OWJUSTFaaVovU1RUMmNOSEdLTkpZV3g4UHJpaDQ5ck5uUkZ1SGJ6NzViRXpn?=
 =?utf-8?B?cWsyS3hBWUlxYUNjVzNPSVdxcmlHYVRObU9lcnVjRDd6RjBFSXdxazZBZ0hG?=
 =?utf-8?B?TEpyZU0zdFNvMTdSTHRTZVcyL0J3cDRHZjVvdkxPRk9UMkF4VU5hK0xhRkZP?=
 =?utf-8?B?YUt6OEtKVXVxUWZZM1JWMzlzc2pEQlVFcEtSUWZuMDhlbmd4R3hHYnZLTlRu?=
 =?utf-8?B?S0FKbXpEUjNiMEtvNytGemtpV01XN3g5V0U0UGlBUm5kY25yb2JYWEcwMk43?=
 =?utf-8?B?cmRmcGxQU1M1c2hUWWwwUGxadUxxd0dvSWpiTTRPeWpsZ0N6Wlp2WFVORFdF?=
 =?utf-8?B?RklxVzZSWVJvSXVSNHRwU1Y1b2RNWDl3WmJHZ3loUmo4MU04ZHlKS21BVXpB?=
 =?utf-8?B?Vy9CY21RS3NuNXBta1hmRHBvVklzdzdrSlM3RXExSzZFMnh2MU9vcHZ0bXRk?=
 =?utf-8?B?Wk0yck9XWGMwaXUraTMxMHp4cWxrOEE0VHpkT0ZUY25tZG9acjF1S2xqWDNT?=
 =?utf-8?B?OUxLVHZWdlFCSnNsaHRLN0NESHpvNEs0L1NyMGVUb3NhYWxPc1UwNDFNMWxI?=
 =?utf-8?B?eXIycjQyc0FMUko1ZzBUNTFoOEtZanlSUnh4YmQzZjVKVDlVQ3Zzc3dIcFVm?=
 =?utf-8?Q?0xU9pXeQnCGorXDg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2785f1e4-a287-4b11-7054-08da26efd614
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 19:14:35.8143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pO9S5uCP7coG+veMQHyhqQOGeD4Ur1DYnmSpq8lQXxNzujVst5G0j/tdavyFJ4Ew3pjiENeJH2f2Rkb248RnKs+YJLcwO/aVWA7TdOio2po=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3853
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi all,

Recently, I’ve been toying with an idea for io_uring that I'd like to 
run by the experts here for offloading data copies from kernel memory to 
user space (say, during a read or a recv) to a DMA engine. I have a 
patch series that sort of works, of which I've included the one io_uring 
patch here. The rest of the series is available on GitHub[1], but only 
this one touches io_uring.

As background, we often find that the bottleneck in a wide variety of 
applications is the copy_to_user() call to copy data from a TCP/UDP/Unix 
socket to user-space buffers. The basic concept I'm proposing is to 
offload that data copy to a DMA engine. This has been done before in the 
NET_DMA framework, but that has since been removed. That previous 
attempt had a couple of problems that lead to its removal. Namely:

- The DMA engine operated on physical addresses, requiring page pinning 
overhead that was frequently just too much to overcome.
- It was synchronous. These DMA engines work best asynchronously.
- It wasn't safe during fork().

I'm specifically working with Intel's DSA (idxd driver) which supports 
Shared Virtual Addressing. DSA is still best used asynchronously with 
queue depth larger than 1, but it solves the page pinning overhead issue 
above. Note that this patch is not directly tied to idxd or Intel 
hardware - it's all written against generic APIs - but those generic 
APIs are newly proposed and need to still be discussed on their proper 
lists. In the worst case, we may have to resort back to page-pinning (or 
relying on fixed buffers). I have some additional discussion of the SVA 
stuff inline with the patch below.

The second point - synchronous usage - is where io_uring comes in. 
Instead of being forced to complete a data copy synchronously within the 
context of a single system call like a recv(), we can now asynchronously 
offload these copies to a DMA channel allocated per io_uring and post 
completions back to the cqring whenever they finish. This allows us to 
build up queue depth at the DMA engine (by having it work on data copies 
for multiple different recv operations at once).

A quick summary of the patch below:

- Attempt to allocate a DMA channel, set up/bind PASID, etc.  whenever 
an io_uring is created. Release when the io_uring is destroyed. If it 
fails, just don't support offloading.
- For each read operation, set a flag in the kiocb to indicate it 
supports offloading copy-to-user operations and set a new function 
pointer on the kiocb that can be called to queue up a copy operation. As 
part of this call, the lower level module (tcp or whatever) provides a 
callback that's called when the dma operation is done, to be used for 
clean-up (i.e. releasing sk_buffs for tcp).
- If the lower layer file completes a request, io_uring checks if a DMA 
operation was queued up as part of that processing. If it finds one, it 
treats the request as if it returned -EIOCBQUEUED.
- It periodically polls for DMA completions. I'm sure I'm not polling in 
the right places. I think the sqthread keeps going to sleep on me. When 
it finds completions, it completes the associated kiocbs.

This is all specific to the read opcode currently, but I certainly want 
it to also work for recv so a lot of this logic probably has to get 
moved up a level to avoid duplicating.

To test this I created a simple kernel character device backed by a 
single 4k page[2]. In the .read_iter callback, it checks if the kiocb 
supports this offload and uses it. I've only been running in SQPOLL mode 
currently.

I made some comments inline on my own patch too.

[1] https://github.com/intel/idxd-driver/commits/iouring-dma-offload
[2] 
https://github.com/intel/idxd-driver/commit/c3b2f1bd741e6a1a3119ce637f8a057482e56932

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4715980e90150..f9ec02068f5cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -81,6 +81,8 @@
  #include <linux/tracehook.h>
  #include <linux/audit.h>
  #include <linux/security.h>
+#include <linux/dmaengine.h>
+#include <linux/iommu.h>

  #define CREATE_TRACE_POINTS
  #include <trace/events/io_uring.h>
@@ -384,6 +386,14 @@ struct io_ring_ctx {
          unsigned        sq_thread_idle;
      } ____cacheline_aligned_in_smp;

+    struct {
+        struct dma_chan        *chan;
+        struct iommu_sva    *sva;
+        unsigned int        pasid;
+        struct io_dma_task    *head;
+        struct io_dma_task    *tail;
+    } dma;
+

There's probably something in the kernel for a singly-linked list with a 
tail pointer, but I just made my own for now. That's why I have the 
*head and *tail.

      /* IRQ completion list, under ->completion_lock */
      struct io_wq_work_list    locked_free_list;
      unsigned int        locked_free_nr;
@@ -479,6 +489,17 @@ struct io_uring_task {
      bool            task_running;
  };

+struct io_dma_task {
+    struct io_kiocb        *req;
+    dma_cookie_t        cookie;
+    struct iov_iter        *dst;
+    struct iov_iter        *src;
+    u32            len;
+    ki_copy_to_iter_cpl    cb_fn;
+    void            *cb_arg;
+    struct io_dma_task    *next;
+};
+
  /*
   * First field must be the file pointer in all the
   * iocb unions! See also 'struct kiocb' in <linux/fs.h>
@@ -891,6 +912,10 @@ struct io_kiocb {
      /* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
      struct io_buffer        *kbuf;
      atomic_t            poll_refs;
+
+    /* for tasks leveraging dma-offload this is refcounted */
+    unsigned int            dma_refcnt;
+    int                dma_result;
  };

The refcnt is because a single io_kiocb could generate more than one DMA 
task.

  struct io_tctx_node {
@@ -3621,6 +3646,154 @@ static bool need_read_all(struct io_kiocb *req)
          S_ISBLK(file_inode(req->file)->i_mode);
  }

+static size_t __io_dma_copy_to_iter(struct kiocb *iocb,
+        struct iov_iter *dst_iter, struct iov_iter *src_iter,
+        ki_copy_to_iter_cpl cb_fn, void *cb_arg,
+        unsigned long flags)
+{
+    struct io_kiocb *req;
+    struct io_ring_ctx *ctx;
+    struct device *dev;
+    struct dma_async_tx_descriptor *tx;
+    struct io_dma_task *dma;
+    int rc;
+
+    req = container_of(iocb, struct io_kiocb, rw.kiocb);
+    ctx = req->ctx;
+    dev = ctx->dma.chan->device->dev;
+
+    rc = iov_iter_count(src_iter);
+
+    if (!dma_map_sva_sg(dev, dst_iter, dst_iter->nr_segs, 
DMA_FROM_DEVICE)) {
+        return -EINVAL;
+    }
+
+    if (!dma_map_sva_sg(dev, src_iter, src_iter->nr_segs, DMA_TO_DEVICE)) {
+        dma_unmap_sva_sg(dev, dst_iter, dst_iter->nr_segs, 
DMA_FROM_DEVICE);
+        return -EINVAL;
+    }
+
+    /* Remove the interrupt flag. We'll poll for completions. */
+    flags &= ~(unsigned long)DMA_PREP_INTERRUPT;
+
+    tx = dmaengine_prep_memcpy_sva_kernel_user(ctx->dma.chan, dst_iter, 
src_iter, flags);
+    if (!tx) {
+        rc = -EFAULT;
+        goto error_unmap;
+    }
+
+    dma = kzalloc(sizeof(*dma), GFP_KERNEL);
+    if (!dma) {
+        rc = -ENOMEM;
+        goto error_unmap;
+    }

A memory allocation for every DMA operation is obviously not a good 
design choice. This should be in a pool or something, and it should 
back-pressure if the pool runs out with -EAGAIN I think.

+
+    txd_clear_parent(tx);
+
+    dma->req = req;
+    dma->dst = dst_iter;
+    dma->src = src_iter;
+    dma->len = rc;
+    dma->cb_fn = cb_fn;
+    dma->cb_arg = cb_arg;
+    dma->cookie = dmaengine_submit(tx);
+    if (dma_submit_error(dma->cookie)) {
+        rc = -EFAULT;
+        goto error_free;
+    }
+
+    req->dma_refcnt++;
+
+    dma_async_issue_pending(ctx->dma.chan);
+
+    if (ctx->dma.tail)
+        ctx->dma.tail->next = dma;
+    else
+        ctx->dma.head = dma;
+    ctx->dma.tail = dma;
+
+    return rc;
+
+error_free:
+    kfree(dma);
+error_unmap:
+    dma_unmap_sva_sg(dev, dst_iter, dst_iter->nr_segs, DMA_FROM_DEVICE);
+    dma_unmap_sva_sg(dev, src_iter, src_iter->nr_segs, DMA_TO_DEVICE);
+
+    return rc;
+}
+
+static int __io_dma_poll(struct io_ring_ctx *ctx)
+{
+    struct io_dma_task *dma, *next, *prev;
+    int ret;
+    struct io_kiocb *req;
+    struct device *dev;
+
+    if (!ctx->dma.chan)
+        return 0;
+
+    dev = ctx->dma.chan->device->dev;
+
+    dma = ctx->dma.head;
+    prev = NULL;
+    while (dma != NULL) {
+        next = dma->next;
+
+        ret = dma_async_is_tx_complete(ctx->dma.chan, dma->cookie);
+
+        if (ret == DMA_IN_PROGRESS) {
+            /*
+             * Stop polling here. We rely on completing operations
+             * in submission order for error handling below to be
+             * correct. Later entries in this list may well be
+             * complete at this point, but we cannot process
+             * them yet. Re-ordering, fortunately, is rare.
+             */
+            break;
+        }
+
+        dma_unmap_sva_sg(dev, dma->dst, dma->dst->nr_segs, 
DMA_FROM_DEVICE);
+        dma_unmap_sva_sg(dev, dma->src, dma->src->nr_segs, DMA_TO_DEVICE);
+
+        req = dma->req;
+
+        if (ret == DMA_COMPLETE) {
+            /*
+             * If this DMA was successful and no earlier DMA failed,
+             * we increment the total amount copied. Preserve
+             * earlier failures otherwise.
+             */
+            if (req->dma_result >= 0)
+                req->dma_result += dma->len;
+        } else {
+            /*
+             * If this DMA failed, report the whole operation
+             * as a failure. Some data may have been copied
+             * as part of an earlier DMA operation that will
+             * be ignored.
+             */
+            req->dma_result = -EFAULT;
+        }
+
+        if (dma->cb_fn)
+            dma->cb_fn(&req->rw.kiocb, dma->cb_arg, req->dma_result >= 
0 ? dma->len : req->dma_result);
+
+        kfree(dma);
+        req->dma_refcnt--;
+
+        prev = dma;
+        dma = next;
+    }
+
+    /* Remove all the entries we've processed */
+    ctx->dma.head = dma;
+    if (!dma)
+        ctx->dma.tail = NULL;
+
+    return ctx->dma.head ? 1 : 0;
+}
+
  static int io_read(struct io_kiocb *req, unsigned int issue_flags)
  {
      struct io_rw_state __s, *s = &__s;
@@ -3665,8 +3838,28 @@ static int io_read(struct io_kiocb *req, unsigned 
int issue_flags)
          return ret;
      }

+    /* Set up support for copy offload */
+    if (req->ctx->dma.chan != NULL) {
+        struct kiocb *kiocb = &req->rw.kiocb;
+
+        kiocb->ki_flags |= IOCB_DMA_COPY;
+        kiocb->ki_copy_to_iter = __io_dma_copy_to_iter;
+        req->dma_refcnt = 0;
+        req->dma_result = 0;
+    }
+
      ret = io_iter_do_read(req, &s->iter);

+    if ((kiocb->ki_flags & IOCB_DMA_COPY) != 0) {
+        if (req->dma_refcnt > 0) {
+            /* This offloaded to a DMA channel. Async punt. */
+            ret = -EIOCBQUEUED;
+        }
+
+        kiocb->ki_flags &= ~IOCB_DMA_COPY;
+        kiocb->ki_copy_to_iter = NULL;
+    }
+
      if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
          req->flags &= ~REQ_F_REISSUE;
          /* IOPOLL retry should happen for io-wq threads */
@@ -7526,6 +7720,12 @@ static int __io_sq_thread(struct io_ring_ctx 
*ctx, bool cap_entries)
              revert_creds(creds);
      }

+    /*
+     * TODO: This is not right. It should probably only change ret if
+     * ret is 0. I'm just trying to keep the sq thread awake while 
there's DMA tasks outstanding.
+     */
+    ret = __io_dma_poll(ctx);
+
      return ret;
  }

@@ -9429,6 +9629,95 @@ static void io_wait_rsrc_data(struct io_rsrc_data 
*data)
          wait_for_completion(&data->done);
  }

+static void io_release_dma_chan(struct io_ring_ctx *ctx)
+{
+    unsigned long dma_sync_wait_timeout = jiffies + msecs_to_jiffies(5000);
+    struct io_dma_task *dma, *next;
+    int ret;
+
+    if (ctx->dma.chan != NULL) {
+        dma = ctx->dma.head;
+        while (dma) {
+            next = dma->next;
+
+            do {
+                ret = dma_async_is_tx_complete(ctx->dma.chan, dma->cookie);
+
+                if (time_after_eq(jiffies, dma_sync_wait_timeout)) {
+                    break;
+                }
+            } while (ret == DMA_IN_PROGRESS);
+
+            if (ret == DMA_IN_PROGRESS) {
+                pr_warn("Hung DMA offload task %p\n", dma);
+
+                kfree(dma);
+            }
+
+            dma = next;
+        }
+
+        ctx->dma.head = NULL;
+        ctx->dma.tail = NULL;
+    }
+
+    if (ctx->dma.sva && !IS_ERR(ctx->dma.sva))
+        iommu_sva_unbind_device(ctx->dma.sva);
+    if (ctx->dma.chan && !IS_ERR(ctx->dma.chan))
+        dma_release_channel(ctx->dma.chan);
+    ctx->dma.chan = NULL;
+}
+
+static int io_allocate_dma_chan(struct io_ring_ctx *ctx,
+                struct io_uring_params *p)
+{
+    dma_cap_mask_t mask;
+    struct device *dev;
+    int rc = 0;
+    struct dma_chan_attr_params param;
+    int flags = IOMMU_SVA_BIND_KERNEL;
+
+    dma_cap_zero(mask);
+    dma_cap_set(DMA_MEMCPY, mask);
+    dma_cap_set(DMA_KERNEL_USER, mask);
+
+    ctx->dma.chan = dma_request_chan_by_mask(&mask);
+    if (IS_ERR(ctx->dma.chan)) {
+        rc = PTR_ERR(ctx->dma.chan);
+        goto failed;
+    }
+
+    dev = ctx->dma.chan->device->dev;
+    ctx->dma.sva = iommu_sva_bind_device(dev, ctx->mm_account, flags);
+    if (IS_ERR(ctx->dma.sva)) {
+        rc = PTR_ERR(ctx->dma.sva);
+        goto failed;
+    }
+
+    ctx->dma.pasid = iommu_sva_get_pasid(ctx->dma.sva);
+    if (ctx->dma.pasid == IOMMU_PASID_INVALID) {
+        rc = -EINVAL;
+        goto failed;
+    }
+
+    param.p.pasid = ctx->dma.pasid;
+    param.p.priv = true;
+
+    if (dmaengine_chan_set_attr(ctx->dma.chan, DMA_CHAN_SET_PASID, 
&param)) {
+        rc = -EINVAL;
+        goto failed;
+    }
+
+    ctx->dma.head = NULL;
+    ctx->dma.tail = NULL;
+
+    return 0;
+
+failed:
+    io_release_dma_chan(ctx);
+    return rc;
+}
+

A lot of the APIs being called above are new in this patch series and 
they're not at all reviewed or approved by their maintainers, so this 
could entirely change. What these do is set up the IOMMU for SVA by 
creating a mapping for the current mm context plus the kernel static 
map, and assigning that mapping to a PASID. All of the offloads 
performed here are issued by the kernel using that PASID - the PASID or 
the ability to directly trigger DMA is not ever exposed to userspace. 
This should be the same security model as using the CPU to copy, so we 
believe it does not present any extra security risks or data access 
capabilities. But I'm sure there will be some strong opinions on these.

  static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
  {
      io_sq_thread_finish(ctx);
@@ -9475,6 +9764,8 @@ static __cold void io_ring_ctx_free(struct 
io_ring_ctx *ctx)
  #endif
      WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));

+    io_release_dma_chan(ctx);
+
      io_mem_free(ctx->rings);
      io_mem_free(ctx->sq_sqes);

@@ -10165,6 +10456,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, 
fd, u32, to_submit,
          if (submitted != to_submit)
              goto out;
      }
+
+    __io_dma_poll(ctx);
+
      if (flags & IORING_ENTER_GETEVENTS) {
          const sigset_t __user *sig;
          struct __kernel_timespec __user *ts;
@@ -10536,6 +10830,12 @@ static __cold int io_uring_create(unsigned 
entries, struct io_uring_params *p,
          goto err;
      io_rsrc_node_switch(ctx, NULL);

+    ret = io_allocate_dma_chan(ctx, p);
+    if (ret) {
+        pr_info("io_uring was unable to allocate a DMA channel. 
Offloads unavailable.\n");
+        ret = 0;
+    }
+
      memset(&p->sq_off, 0, sizeof(p->sq_off));
      p->sq_off.head = offsetof(struct io_rings, sq.head);
      p->sq_off.tail = offsetof(struct io_rings, sq.tail);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e2d892b201b07..7a44fa15f05b3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -317,6 +317,11 @@ enum rw_hint {
  /* can use bio alloc cache */
  #define IOCB_ALLOC_CACHE    (1 << 21)

+/* iocb->ki_copy_to_iter can be used to offload data copies */
+#define IOCB_DMA_COPY        (1 << 22)
+
+typedef void (*ki_copy_to_iter_cpl)(struct kiocb *, void *, int);
+
  struct kiocb {
      struct file        *ki_filp;

@@ -330,6 +335,12 @@ struct kiocb {
      u16            ki_hint;
      u16            ki_ioprio; /* See linux/ioprio.h */
      struct wait_page_queue    *ki_waitq; /* for async buffered IO */
+
+    size_t (*ki_copy_to_iter)(struct kiocb *, struct iov_iter *dst_iter,
+        struct iov_iter *src_iter,
+        ki_copy_to_iter_cpl cb_fn, void *cb_arg,
+        unsigned long flags);
+
      randomized_struct_fields_end
  };


