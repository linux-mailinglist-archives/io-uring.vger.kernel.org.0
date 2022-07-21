Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A33357D76A
	for <lists+io-uring@lfdr.de>; Fri, 22 Jul 2022 01:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiGUXn6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 19:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGUXn5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 19:43:57 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB0F26563
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 16:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658447036; x=1689983036;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=t6lFWw64WnkipMGLWeZIWDSrFea7/qRNow8bL97TQa4=;
  b=cq0M3xl+yfIP1W/zlkWuGsPKY/PJ35aL1H5AVTXAluzvNIncDNqhw7bb
   QP0UgwNPRmU42gKcYAQBULcvHd2YZtHcgHiRTMVdJfSzb7nrAFvgk5B9S
   wRNkgMOO/UpKVU7JnTbB0sGUr8qppcVea1Mcbeeq7Kv0m0DvPz4C8EwHd
   8sD4xmo7Wr0/rkbAehPN3p2cEYKskzLP1tHmHlyRTqP2ga6uvtxDfzVod
   gvRBWcSllTQE3UgV+n+KblJGlPESJi5L2/IHrfGmKxKzfgIlNvrKhRxJo
   L7mwHWkrPisNDfmb4deCSH1ltRAFHdrKwWKeTplHggVBuD8qQHpuqzBuO
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="266970764"
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="266970764"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 16:43:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="656974431"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 21 Jul 2022 16:43:52 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 16:43:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 16:43:52 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 16:43:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXGQkIzcTDXUpU9J6UK8Vgc5ju3TXmn5wM46DwyGnnu0R+r/3ln7xUEM8dJNSaVqbf9HFOs2tW6mzerFGlMuM67zxZS6xo411U6roJ6Xd4mBI+uLhtja5fFMorQ2336t5lGtEPyIQ3GRgrycpGwACqXlwX/17Tpe7zf4dS2DZMFCE1Pjvo42qw64dWPCCiB0x9SgYR3j57IBA0asRGftTm+ze0kopM5OfN4z9E/pL2zCS4ocxx6LzRd5cdOSVViayhyqvY5ClnuSx63Fw2pNvUI2kpCQmI+wjhG2heTa0z47BFiJ/sJ0XjUJpSNYh63QuTGnwD1sVwXpEuKXxNa11A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxp8W7MsYSyy+hffON3WmNGUWq3EXRtHH6oxTgSSFKw=;
 b=Xn2Gz+deSjuNJSxvoin5mSusxC2/LKdmJwpfeFJiB5r9v34p9/gwpOHChLy9sI01OzE4SBRINv24MJ6WuAkSQ5q3PusE/ZujK/HxNS2mjuXOq0EtgPycLk8zxTapNYEzh41Z2uTmq/MwzMWEQEzE2N0PNFqokdWtGu4YqMovVec3P/ZvSQgDRRicG/HWnzxTx3l17S+33Aa7juqm6D5lYQ2hVvs6xFIomAeuK7vbbwi2m2chPzqlQbUtkqhMGVDMg+uPTcXPe1m8QE+OIMKZ1A7Y3dSwqQAgjcv6iT486E3R83t8//Z3S+bChUNPsl/UbIreQfJGAh3Sf0NKTmBe4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by CO1PR11MB4931.namprd11.prod.outlook.com (2603:10b6:303:9d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 23:43:31 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32%4]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 23:43:31 +0000
Message-ID: <3088d30d-567c-c64f-fe68-3585967afef4@intel.com>
Date:   Fri, 22 Jul 2022 07:43:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH] io_uring: ensure REQ_F_ISREG is set async offload
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <a4c89aea-bc3c-b2f6-a1ae-2121e3353d79@kernel.dk>
From:   Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <a4c89aea-bc3c-b2f6-a1ae-2121e3353d79@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0012.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::24)
 To CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6403cde-72a5-4782-bfd7-08da6b72d187
X-MS-TrafficTypeDiagnostic: CO1PR11MB4931:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJNtg14wqMVUXkYAkAx6/rTGdNs4x9hwbilziChjoLh3gnae6+9VY6CqNvbzkxenVaAbhW0TtzIxs0pYSEg1ZG1s66Lqjsg+4IZaIIYVqonY15pmMfcqyWUQHKd7f4D+iFGthplugvAi4X6uDlS6iZ8dFxg9nIY7plyqS+3poJB4zlbRHd+MBRhR8OyTjbZ5+9BJd0ZYoQ6k+xjnFTqlmrzccqoucNgKdG1ApBDJXnhlKvkh0Cw3mQRrHc7D67YN/MiEcQyqOSROIxOiuz/jJcXM/qClhUEqQcVzx+1UZHVsHgQbp0E+kDHmFpC0+MX+SxmXbFnKHuBU1tn4rwK/5VBGN3yr34UodJHD986YXRwBEC4FWkcvk50Stv/cIe8upM7Qo6vHSHK0sasgyJmkP6C5lCJzoVaTGxd9wWB+47sxgxYNFqEK9o4ffHZ6m03C7wjc+gqivQrJu4tSXs1mMLtX2SrEzljW277Ogiel3RVobkca29x1ecn5spU2Q12GTb/Vwf39yMFb7XQXCjn+8Ow3wDKR2vQ45UTngXjTvPCzBDIxPQ30458luBQR93i3cDO8ohtYAQLUipiAwsmRWVVsMeS/gEjw0jgn6T8lA/8GPNR2HZi74tIyu+Kzyurki72A1mC2/jBVB+CWmkycAHp6z5XBHUg25UwmRbzwm9CZtzJMoIToGM7q41dzJIztGjVylk1qqxhCWF7w3HIcrl0/ACm/YSBEZVNDuB5hyTIJBfVKNBdc4heUaU6sLnf7IblUpXlyP3WUGU5UbCp9N7Tn9NvpAj/ilsl9LZAOhvNSsdvZWKGDUO5j+UDiaC1MNx9br/f0GT3y/TEd8setrbngB8PSJa0jfZPH+HcsrD8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(366004)(136003)(396003)(39860400002)(5660300002)(2906002)(26005)(8936002)(82960400001)(31686004)(38100700002)(66556008)(186003)(110136005)(6486002)(316002)(36756003)(8676002)(66946007)(2616005)(66476007)(83380400001)(6512007)(966005)(6666004)(6506007)(53546011)(31696002)(41300700001)(478600001)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU44Y2pzWjM3aTRGQVU4ckNORXRpUkpCYm1ETjg4akxFZlZHM0JFVWI5RVoy?=
 =?utf-8?B?aUQ5WFp6L3NFSjUveEVyNlZhcFJLUjBZc29waU0xcEhHUW4wODhxUytXQkFM?=
 =?utf-8?B?UFJrVDJGMHNQeG1CMnpjM1N3THo5WXNBdTd2YjFraXlmditOTFZIUGFWalkv?=
 =?utf-8?B?bXZnOHF1OGdoSHcwWmwrblRGT3JXTkNYOFdNTmFGTVUwQk1KNXN5VXRmSWZP?=
 =?utf-8?B?TFplcnNuN21POVdqWGNuNjJ4WWpYTjlLcW1GdVowelNqNjY4U2t1MERtcVFj?=
 =?utf-8?B?NGlxVjNjOGF5UEpheFkrVEdWakljMExJT0hMdi9pQmRpUjVGVkhZbXpXNnlX?=
 =?utf-8?B?ekdGQTV2VjJWSDQzWnExQnpPMnMxT1krSVRScENRWlA5dFVqREpDSW80TVpS?=
 =?utf-8?B?aGVGeVYzbjZrbGE4NzIwQnNycmVYb2l0d2RBMDBxd0gvMzZXalFtODVFUzNE?=
 =?utf-8?B?VllhMlNPeWkweXpQZGlTckE2djBNdnQzMm9SWjhJVDVkSERscEJUcllFWnB4?=
 =?utf-8?B?cUhkWExhVlJhLzczcFlkTWlGK0p4VkEyMHlINXVLZkR6VkMyMDFwVSt5NTFK?=
 =?utf-8?B?SmNPWDRBVzkxQlNlaFR0b21ock9TRlV1QVRrWUEzMmQ3WlRLMVIzMldnRGlJ?=
 =?utf-8?B?TVlheWErZ3FkTm5KYm9CK3B4YkJpOE93VW1HMlNvay9MUDJaN1BwTmtObEdX?=
 =?utf-8?B?M0pPM0M4eUpkZ05kOXowWDRXWkJiaTR4NGxQcDBIU0RlSVBZRG9YYXh3OHJt?=
 =?utf-8?B?L2tBaDE4WTZFZENnVVUwN08vaC8ybWRyUWZ5bWI2Rk9oT0FQYnBNUmRSbjM1?=
 =?utf-8?B?cTY2MjQ1QXpYaGlpbEFPZlpYNkovZ1o5TDkxSWVmby9Oem5QR0xUVE5aaVhF?=
 =?utf-8?B?Vk1sMmhZOFhiVzdxNlBnb084ZXBQbXZVZDJ4WUxXclpwTUlDL0Vhd29YajlT?=
 =?utf-8?B?ZWN3bHpoc05SYy9BeUkvN0FUb0YyVlNIdWM2aDBHaHdVa2s4K2pLa0phZnZH?=
 =?utf-8?B?dlE5RUNrck1PNWNlTDhxVnVsdDk1SEZwQnVmek1LT0x4M1VxTkNZdVVqWlFy?=
 =?utf-8?B?Zkx3aWQ5SlpoR2I5Z3JKbmxycGhKNk9TenBRejE0amtXQzgrLytWdXRtT3cy?=
 =?utf-8?B?bHI2anViL0pzL3lSaC80K2ticENTMld2Mlp6ZjF0dnQ1T0RHWllNbE9wcjhO?=
 =?utf-8?B?ZTNxanh0TlBpZWs2bXhVTDZtUEhGVysvbC9QR2I0WnZkSHg0elVZRVJMR1lQ?=
 =?utf-8?B?N1hCeFNOcDU3UDlha2hUNzlWaXo4enBnRVl1ZGJ4OXFiVEJoR1FRazVsWGh2?=
 =?utf-8?B?TlZVZHlxRjdkY042dXdJOTcvWGVTeWxtaU5oKy9SdjE5aGpXQUlxZGhFS0Nh?=
 =?utf-8?B?aE9jVXNIRGhaRjJvNTY5WkZVMUtaVXYzYzc2K2ZUQmowZUQ3ekNzemtjUmhH?=
 =?utf-8?B?TC94T1N5RDJ1allZV1YxWk83YklyQXpMVWlSY1l1dEVWVnlXYldSaFdxc1Bx?=
 =?utf-8?B?T1NRTHovamRRcEs1YnJJZ0xnWkxLTXhqa3hKNUFVRERXNCtaNllsU1c1WUhr?=
 =?utf-8?B?QzV5RmVPNVpOcTdnMzI5VmJFb3V6SlI3U0EwS1JsMXBtR2doZlpSQ05ZdUdr?=
 =?utf-8?B?aGJuTzliMVJpSnpBbHpXSHgzQmMvelc5Z3QrUXczdFlMYllrN2U1ZXFvdEpk?=
 =?utf-8?B?MFN0cWUrcVFmTkk2bTdYOTlUdFlxRlNocEl3cTBpVkhuVnNRTFlqT2Rlb0dP?=
 =?utf-8?B?dlFWN0tIWjZCSDllTTZ3M05USVlrVWtkSHNDcGgwdlhRMlRpTDlEelJzT2pP?=
 =?utf-8?B?WDZHZ1hKY1ZkU3FManE1c1ptazVUTWFtaXdYVVliRzBPK1crVkRJRDlIYXJP?=
 =?utf-8?B?bXZlN3lGeUhVRHlHcU5HVDUrRGxlUHNSdGpEMlgvazhLdXQwK1U1Vk1PZThB?=
 =?utf-8?B?R1JPdjNpTjR3SkZVYm9YcWR6KzJueVhMenlBd25yYVQvLzNYWXprNDhrUnNL?=
 =?utf-8?B?VW5hQ0gydHR5MWJZYTFuQTQwOStpd1JQUjNFN3p6cDMzTmdsa0JWcGpDMUpE?=
 =?utf-8?B?RGxsRVlmMkN3TkQ1MkhYMzYrb0lla2RRb0dzRlZyQ2s1MXMwcU4wamFCUllm?=
 =?utf-8?Q?MiFM02NueZrsqwuM6hko6rq6z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6403cde-72a5-4782-bfd7-08da6b72d187
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 23:43:31.5718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8euG3bp8OEkdiv1pRBI2KCXWvk+vJQMfqQzfCtJC4I2+uagyRwGhWr8ukcknP+O+/acTrkBehM8dsJYSb+Yl+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4931
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 7/21/2022 11:11 PM, Jens Axboe wrote:
> If we're offloading requests directly to io-wq because IOSQE_ASYNC was
> set in the sqe, we can miss hashing writes appropriately because we
> haven't set REQ_F_ISREG yet. This can cause a performance regression
> with buffered writes, as io-wq then no longer correctly serializes writes
> to that file.
> 
> Ensure that we set the flags in io_prep_async_work(), which will cause
> the io-wq work item to be hashed appropriately.
> 
> Fixes: 584b0180f0f4 ("io_uring: move read/write file prep state into actual opcode handler")
> Link: https://lore.kernel.org/io-uring/20220608080054.GB22428@xsang-OptiPlex-9020/
> Reported-and-tested-by: Yin Fengwei <fengwei.yin@intel.com>
This issue is reported by (from the original report):

If you fix the issue, kindly add following tag
Reported-by: kernel test robot <oliver.sang@intel.com>



Regards
Yin, Fengwei

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> Yin, this is the 5.20 version. Once this lands upstream, I'll get the
> 5.19/18 variant sent to stable as well. Thanks!
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 624535c62565..4b3fd645d023 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -406,6 +406,9 @@ static void io_prep_async_work(struct io_kiocb *req)
>  	if (req->flags & REQ_F_FORCE_ASYNC)
>  		req->work.flags |= IO_WQ_WORK_CONCURRENT;
>  
> +	if (req->file && !io_req_ffs_set(req))
> +		req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
> +
>  	if (req->flags & REQ_F_ISREG) {
>  		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
>  			io_wq_hash_work(&req->work, file_inode(req->file));
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 868f45d55543..5db0a60dc04e 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -41,6 +41,11 @@ struct file *io_file_get_normal(struct io_kiocb *req, int fd);
>  struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
>  			       unsigned issue_flags);
>  
> +static inline bool io_req_ffs_set(struct io_kiocb *req)
> +{
> +	return req->flags & REQ_F_FIXED_FILE;
> +}
> +
>  bool io_is_uring_fops(struct file *file);
>  bool io_alloc_async_data(struct io_kiocb *req);
>  void io_req_task_work_add(struct io_kiocb *req);
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index ade3e235f277..c50a0d66d67a 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -647,11 +647,6 @@ static bool need_read_all(struct io_kiocb *req)
>  		S_ISBLK(file_inode(req->file)->i_mode);
>  }
>  
> -static inline bool io_req_ffs_set(struct io_kiocb *req)
> -{
> -	return req->flags & REQ_F_FIXED_FILE;
> -}
> -
>  static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>  {
>  	struct io_rw *rw = io_kiocb_to_cmd(req);
> 
