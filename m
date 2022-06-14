Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B08854A3F0
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 03:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350410AbiFNB4a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 21:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350370AbiFNB43 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 21:56:29 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CFB33E2A;
        Mon, 13 Jun 2022 18:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655171788; x=1686707788;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4a+jPHOObt9OR33B0XgKHT4fzU9mQHDD/0VYl+JCSvE=;
  b=ng2bz0+6LpO8cFwGFpNuiZ8oPeeI5x3d8njzSyEy3CHIkTSlxkuQOqv5
   IqrEvK7RKel3rFT8wypNcuBkkEMl4EEMaQbUuZnhuZbzHetKbA7J6iUf/
   6RxTdEa9YpLCWN6h2dFyzxS5aUCSldoVcFX4gSw10rGzn5hbSDJlj+8fD
   50mP+Vc/R38NCfWYq6GVPBL0F5CDHcpWDxwKWDjeWF3NezjS9Tnicg0Vy
   FdWeGtuo5xNDP4DfgjDPSJXwc2cEdVjr1+2rascPPEmMGK/4bee2wrgCG
   eh2siCDC3H76jk92j2GUX2cMlwj85cHX/73T4u0gWKMqryWYWnMxfQ44U
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="276003992"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="276003992"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 18:56:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="588144341"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jun 2022 18:56:28 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 18:56:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 13 Jun 2022 18:56:28 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 13 Jun 2022 18:56:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7jxjWO7Ww5mrsttO/cjrUrIVuGkvvrm1MOWHE/xbgc9ER/qz5BubOVTzMr5pRkyAMM2401Stmkau8v/c9AJDQlN47B9MlqETi9tG+J1wqbtW+IZ8C/fIBldsUYmumCQ2HWjmqHCeCgwyi4vqlq2RfUIDQ/FLXZyN8SUrNH+mtAYsxcuHklCpEAeNYEr9141NZf24d27dLerv3EM8krnOPEc+Jm/4I1mRLsuKSByH61VILDhDADqzfwVNeH5CAMjTfypIpeL59BTjAiWkcmfoH8cv1wewQKsZwogvzo3aoJjOxgJc4pziYwOJTDxd1q4YzX6VNh6VHX3p8j1B64Qrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2C6EhLggu/HFbsN0FGwy5t/R7EgVhmlft9jFclRGeCI=;
 b=mhiZNCIJ/7uYPrxJOXmq3ywOEK7U4Zw5+8ofQKkCPNW8v+w7j0D4jTbIy1EBQD3FceAYo4w5j3wbX9qqUw+D7zRp50O3IXWNSwE66n2S7llEF4LlmGud7XWivQ7g6JzVnkAhaSFmaAS4QVs6iwlpTBikGcw1ZMdq0HcKAxIbwedZTnSJ6yh8uCRFuc714DnVbE+iEnekcjG7sNats6Oqd+eZ4yMYb8DZ03eBlbG21PEtfmHS2ibFETLVtq0sDtP2Sfx5u0Pj736H/SqC+0DZ0gUDPyvkCXGWq2+TkiFPV/FRhht6/eXRciHFR4cWVIquUw7zJSaxIL4guUDwcaUIOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by CH0PR11MB5266.namprd11.prod.outlook.com (2603:10b6:610:e1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Tue, 14 Jun
 2022 01:56:21 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::39e0:6f4d:9c2a:85d9]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::39e0:6f4d:9c2a:85d9%8]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 01:56:21 +0000
Message-ID: <2f623c4c-1837-4943-763c-d9b57e8cca95@intel.com>
Date:   Tue, 14 Jun 2022 09:54:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [LKP] Re: [io_uring] 584b0180f0:
 phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s
 -10.2% regression
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        kernel test robot <oliver.sang@intel.com>
CC:     LKML <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <lkp@lists.01.org>, <lkp@intel.com>, <guobing.chen@intel.com>,
        <ming.a.chen@intel.com>, <frank.du@intel.com>,
        <Shuhua.Fan@intel.com>, <wangyang.guo@intel.com>,
        <Wenhuan.Huang@intel.com>, <jessica.ji@intel.com>,
        <shan.kang@intel.com>, <guangli.li@intel.com>,
        <tiejun.li@intel.com>, <yu.ma@intel.com>, <dapeng1.mi@intel.com>,
        <jiebin.sun@intel.com>, <gengxin.xie@intel.com>,
        <fan.zhao@intel.com>
References: <20220527092432.GE11731@xsang-OptiPlex-9020>
 <2085bfef-a91c-8adb-402b-242e8c5d5c55@kernel.dk>
From:   Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <2085bfef-a91c-8adb-402b-242e8c5d5c55@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0157.apcprd04.prod.outlook.com (2603:1096:4::19)
 To CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 514e293a-c493-47b7-32c5-08da4da91436
X-MS-TrafficTypeDiagnostic: CH0PR11MB5266:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CH0PR11MB5266325E8A5CFDDC38DD0B3FEEAA9@CH0PR11MB5266.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NgpwhHq1ujXFL1qFWHOJtlD3pkRHN1rKNwH4usdn0N6PSaKXz6UMmjMTv4k7UB2CEpxt8anmIj16Ym0Gs1P0WmU8Jz+UdPzK3nOFHTujcpxIXQEebuG3ZN+ob/qVf8ng3MzExSpOyV7O7w2sQpCTopDQERIu4cOjRkKm+szN5yrIDGabTd5TSUUcMhdYmXdvaD+VIW7LUnoP2a1myTnV6kv3XfSG3HR1wFsx2N+JiqmgsOlM0jEa7OQf6TEEKO2DvIM6FHuf56h5DOHEOeiBTIvJk5vxTEY+L+2SzWz2gG0ZH8cMjURj2gcGXebtlr0sq/OSvqgZjOzMUdoZ2bq2SuTLw7NklgLWBXEcMI4KSXdl4y7euvPr6nkP8lQhzH/I/lDr83Cw4PVu8S7afetgTj2CsM47tFPwJrIgP8bl2cwG6HlfdkRNKFWilLzDJByxZPZGrQQ1Dnvkipa1fOXdWBwimVHC/RXXYXR9z1wZlTU9sAP3InjBKFzpr8JrqAmbSGd4yMQL35ze8stSoT1AWoMfPyyY4UUkccFyZkPIgZcfS8PsjTDGxOweUYmvYhAPgA8rX/Jz58V4LlHBj9qpYZPlq1kkTZZlYYRxuwpUyBYOtBnu0sOpg0PAGkPyWFAqucJ8BAI+uihI9+MusXmhU44q27pcjcuyIGI3rUYOvp76Szmn54Z1h/SNk1TWvh8fABLrMzKs0hB5p3AvmHQ40JulR28jXqx6QbaqTfGLS+jAyxHZ3E+724/COiXkqDZyWttUqNcW9wYLHF2VO1ITE7gKT2OoNpuqXLt0x48rPTxdbE63mfyEx2vL4Xv2JfB9VsSWER/CYQ9uvMtA+M3IGCou46Jc0+tZ19OXYAbQVJA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(6512007)(26005)(66556008)(4326008)(966005)(36756003)(6636002)(110136005)(83380400001)(107886003)(8676002)(82960400001)(2616005)(508600001)(316002)(6506007)(186003)(53546011)(2906002)(31696002)(6666004)(86362001)(31686004)(66946007)(5660300002)(38100700002)(66476007)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wkw2dUVqcDBaL3NOcDNCZnJIL01CWVRvWFhCRzRRaVh1SzRoK1VYbFZVVGh6?=
 =?utf-8?B?eVdVRnFKdXVYdC9yRnlyRGJNZzNmWUlhbE5WUG5oUDFQZTdGbHFwazk5amdK?=
 =?utf-8?B?bHRJOVRTZDRmNGdTNTRzV2hsYVAzcW9wQm5ucUM2MTE2RmZtNVFtSlZMSElw?=
 =?utf-8?B?YXMxaUhTakpFMG9rNnpkYkFnT3VPZFJuMW1vZ1VieURlNXFmTURDb0JjY0lz?=
 =?utf-8?B?RG1ueFU5UFRsZ3RtaVJCVm5IVXJ5MExGeXhkYXR2akl5SXhOeXd2dU9Zb29V?=
 =?utf-8?B?MWwyMndQWFNtVklKck9qdUUrc01UVHUxRTFWOGlYVGM2SmJ6Q2JQNE5ZbW1w?=
 =?utf-8?B?U2NMOTR5SXBmVTNzRXpZZW4wZXM4eHVXczdIMkRFWGF3OWJYRWJ3amJBMmJ4?=
 =?utf-8?B?c1pDUzF2SXFRYXFUWTZIbUkyRXROUFZPcCtlZHpNaStlWSt6MjI4UkREVU5p?=
 =?utf-8?B?dHZVaHZRcjFWWXNOL090SjRCR2hnS1lHLzNjV0Vldy9wMVhIVVNMV3dlQVBQ?=
 =?utf-8?B?T2ducHIxQ29PRllBalI5NkNQcU5hK3A3b21pZ3VBVzhQRHc0M0pHTlFabTFY?=
 =?utf-8?B?S1p6NE5pRnA5NGh0SURIa1JPZjdTeGF2T1NGNVhZeEszUll3UXhiVzVNdjBj?=
 =?utf-8?B?NHNQTEtGM1Vrd0V3UkE1VXV6NWFvRnkwK29qazFYcG9lQkEvdFNFMlVNWU5J?=
 =?utf-8?B?NVc5ME5lTDFucHhrejFHV2N1L3ZWcGxqSWhEWEo5REljZ2t4MEtqSkVMWFRz?=
 =?utf-8?B?VVRLWDlMM0M5R2FMbVMrMGxlakpCZ1pteU1ER2Fyc0Q1dGxZVUlxd2VvTTZC?=
 =?utf-8?B?RHQxTHJhQW5kUFJ0NktxNlZNb3I5ZHJoNmhnWVByT3ZTQ3NHOHh5Y0plSlUy?=
 =?utf-8?B?NGVjTjNQL3RkOUI2YjdHSlpQbXc0QTJIMW9nYzNJM1hFTTljL2YxTitrNThO?=
 =?utf-8?B?czNqZml5bDdsajRXL2ZaZENHMkFzQ3BsQzl2RDRhRjNoK3YrYUVTOXQvbis1?=
 =?utf-8?B?aEtKRnZYVGhGV2Ryek9VL3JidkZ6K1A2WWcyTGt6anByT1BlU1d0K00yT0sy?=
 =?utf-8?B?MzRIRXBhTGVNK0J5OWVheEJzNlBoUGZSVlI4ZlhRaG45YjQvK3AxYWRRTml2?=
 =?utf-8?B?ZlVGM2ZZWWVTYS9yTDl5Y001NWhnMmliUFl6WG5iVi9YUTV0bGlUcVkzcjZL?=
 =?utf-8?B?bFpYTFpOeWw4dThPUXhrUkhyOTNYVXlWZ1c1TWNMRXp0c251S0VzU1lqamZY?=
 =?utf-8?B?VTA2MmFaRW1DU3kvYWxJRGwxek5WMjVUL2pIdU5PT2pJRStJQ3ZiTjVMV0Z2?=
 =?utf-8?B?eUNEWHpUeUV4b1dieUxZcTg1YmpOeGR5MUFlc3VRTlZtVkRQcVFISHFCR3Fs?=
 =?utf-8?B?Tnd1VFBJQmRYbmZLNXF6ZDcrblB6T29oeWxXenpncXdWWFEwMnJIU0dpa3ky?=
 =?utf-8?B?YmdJcU5qcVJFNVdmTGExcGV2RzhXTEh2K2lGQWFLVjVDaFJ1Rm8xMmMxYzFN?=
 =?utf-8?B?V3A3a3VycmpSQ0tqYlNTTXhGMVluYndzeVozOC9uTGU5SmZhZVplYW02YWl0?=
 =?utf-8?B?OS9STmxBcDE0SkEwMGMzL05yWnBTNU1SWHhWVDIyRkFxWnlKVXhCL1lFdXdK?=
 =?utf-8?B?SEg0YXZETDJkUWlZbnduU3k1RkQrTGp6cFZnQlI5WUVzTlJZb2Rwd0NkVmFY?=
 =?utf-8?B?dlp6dFpTMUt4aUZvT0N3aEJISkdsZDBoTUlwejJwUlk1bng2VGlxTjkvKzMy?=
 =?utf-8?B?QUtIeklVZlNSOWgydkVEYUhvblh6Q2Zja0hYMlRyNFpEMzJVUHQrMFRXMy93?=
 =?utf-8?B?L2Y2bVlkNzliUzFjR0c5WEpGTVdnWUhwYVd0K0dzVFpsSHdTbTdxUkZFNjV2?=
 =?utf-8?B?M1NRZkZBZ0lyQnJzSlZOZ0xrYTlJV29qWTJ3Qmw0SjZheFl4YysvdktYSkJZ?=
 =?utf-8?B?SUVsUlBVZ1pEYVlFY1d3MkkxNUIwQWRqdjZNZUJLTTR2VHBJaDMzNHNRNWtn?=
 =?utf-8?B?d0dwWXcwdU01ekU5bW1vTHpGRFJ1MktvR2U1eThZbURxck1aUm9UYThkZFdo?=
 =?utf-8?B?cjZPYVF0dVZTSVF3TVBjc1FsNVdYYytRZ0JablVOQnZWVWtaWTdxWDl1MHhP?=
 =?utf-8?B?TW1NRlpQSXZXbVhRRzNMOURhaCtEcjgwMVdTRmlvQnFRczJ2RXhEMlBUSXJl?=
 =?utf-8?B?Z3JxR1J1eDdUTUc2VzlIc0l4TnlDcHpsYXlXWUp0MXRhRjNKRDR4MlQ0cnln?=
 =?utf-8?B?aTUrbzlTdzVLdlYrZ3oxcTVjSjc4eTJZeFplUlF1cHUvOHQ0ZjMycm16WHVx?=
 =?utf-8?B?aUNCcGNlWVFrZE13RlVDaDBVYndIcDdNV1VxK2o1N0F1YWZyaVNHSGRGakZ2?=
 =?utf-8?Q?jWlLQNv9ZWx8+fHE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 514e293a-c493-47b7-32c5-08da4da91436
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 01:56:21.3222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYG28pZDkFPUm7MH5pfp6ra0xtCz97cVUn+/ju9mLz50ZPBmN3ejGLnbt8/cbJK4/F5gFEaaeCYtO4qzjAlMGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5266
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 5/27/2022 9:50 PM, Jens Axboe wrote:
> On 5/27/22 3:24 AM, kernel test robot wrote:
>>
>>
>> Greeting,
>>
>> FYI, we noticed a -10.2% regression of phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s due to commit:
>>
>>
>> commit: 584b0180f0f4d67d7145950fe68c625f06c88b10 ("io_uring: move read/write file prep state into actual opcode handler")
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>>
>> in testcase: phoronix-test-suite
>> on test machine: 96 threads 2 sockets Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 512G memory
>> with following parameters:
>>
>> 	test: fio-1.14.1
>> 	option_a: Sequential Write
>> 	option_b: IO_uring
>> 	option_c: Yes
>> 	option_d: Yes
>> 	option_e: 1MB
>> 	option_f: Default Test Directory
>> 	cpufreq_governor: performance
>> 	ucode: 0x500320a
>>
>> test-description: The Phoronix Test Suite is the most comprehensive testing and benchmarking platform available that provides an extensible framework for which new tests can be easily added.
>> test-url: http://www.phoronix-test-suite.com/
> 
> I'm a bit skeptical on this, but I'd like to try and run the test case.
> Since it's just a fio test case, why can't I find it somewhere? Seems
> very convoluted to have to setup lkp-tests just for this. Besides, I
> tried, but it doesn't work on aarch64...
> 
We re-run the test and still could get exactly same test result. We noticed
following info from perf profile:

     14.40 ± 21%     +71.3       85.71 ±  2%  perf-profile.calltrace.cycles-pp.io_wqe_worker.ret_from_fork
     14.25 ± 21%     +71.4       85.64 ±  2%  perf-profile.calltrace.cycles-pp.io_worker_handle_work.io_wqe_worker.ret_from_fork
     14.23 ± 21%     +71.4       85.63 ±  2%  perf-profile.calltrace.cycles-pp.io_issue_sqe.io_wq_submit_work.io_worker_handle_work.io_wqe_worker.ret_from_fork
     14.23 ± 21%     +71.4       85.64 ±  2%  perf-profile.calltrace.cycles-pp.io_wq_submit_work.io_worker_handle_work.io_wqe_worker.ret_from_fork
     14.22 ± 21%     +71.4       85.63 ±  2%  perf-profile.calltrace.cycles-pp.io_write.io_issue_sqe.io_wq_submit_work.io_worker_handle_work.io_wqe_worker
     14.10 ± 21%     +71.5       85.62 ±  2%  perf-profile.calltrace.cycles-pp.ext4_buffered_write_iter.io_write.io_issue_sqe.io_wq_submit_work.io_worker_handle_work
      0.00           +80.9       80.92 ±  2%  perf-profile.calltrace.cycles-pp.osq_lock.rwsem_optimistic_spin.rwsem_down_write_slowpath.ext4_buffered_write_iter.io_write
      0.00           +83.0       82.99 ±  2%  perf-profile.calltrace.cycles-pp.rwsem_optimistic_spin.rwsem_down_write_slowpath.ext4_buffered_write_iter.io_write.io_issue_sqe
      0.00           +83.6       83.63 ±  2%  perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.ext4_buffered_write_iter.io_write.io_issue_sqe.io_wq_submit_work

The above operations takes more time with the patch applied.
It looks like the inode lock contention raised a lot with
the patch.

Frankly, we can't connect this behavior with the patch. Just
list here for your information. Thanks.


Regards
Yin, Fengwei
