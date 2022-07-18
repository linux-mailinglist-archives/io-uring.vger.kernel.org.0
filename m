Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320A0577920
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 02:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiGRA6e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jul 2022 20:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiGRA6d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jul 2022 20:58:33 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD6B11801;
        Sun, 17 Jul 2022 17:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658105912; x=1689641912;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VwNYcMv8p52T8q7HxZq23nL9XWHcD5bwwcmro3bWEo0=;
  b=bG5ympABtrWISj90xYiQUUKGtEfVhkLJp5eNrtjgdUuMUJGUjvc9JUbd
   l1k4Vfb/4PpECPOfGKNQuHumKtZghj4WUnSM1pDAPOpQuvNyQHAUf8M89
   frsC1iH+4D2QEqRal6TrBiNpRwnUAGOqHsAuxcG27uK8iz8C7qd5GwUFh
   JXM/k82WVIlhnVYsQKzB10Yoh50GyG8jJuvEzuIs2J/1h2Zm31JZE22wc
   Z+cYHKl8uS6dTLqdCQeOc1Hmj74FhHsMsmiqRjLS+8DKVxu3/XpFRDbBM
   YEuSvWj3mq4PVPn/PfyQTbx8dY4pBaJhAbIt7jzqzBADkghCpzKMPb5oW
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="311783215"
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="311783215"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2022 17:58:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="624517370"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 17 Jul 2022 17:58:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 17 Jul 2022 17:58:30 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 17 Jul 2022 17:58:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 17 Jul 2022 17:58:29 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 17 Jul 2022 17:58:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dX5ZMyp9SFfRZEfeZ2DGP+2y+hb2s6JQmnvhbTz8+yFZlco2stE/JlC6YY4sg/iYVsKcK0bhpLhXLKavhyH46wp1c8NEIQLIsod6bAVReCOK6ZlXhyQ1CbpN8G/Ki+Tjz+DMQnHCnNoHv9eEHIVylhgp8z+nIY5YhYNbYd5nO4hgSe7AbNBfDkTJI6yKKYITbh9RSLQPRM+gBDs9teoLmcT/RMlOEdDfbOW94rpny4RbYm0C1G4IuYupjBZlazWNtonNU5CzkHcaYJIBlwZrBeXjGyKqcAgbwMV0Nnd2F5zVoa+EVBp35EV4Wdz4wleKrzwCHTMfQFb7mI5ho+VpOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQKXHnlHy86H87gS0ve0xPP7QjIah/8Ybm0R9WMekpc=;
 b=YFBWfBK9RUz0r1DeOmVQtU5hFz9Pk248bQddXQv7f7pGKExTvVZC1zk1JoPQIfIsmQuMsCR/OpPjqLO+sKwAIpJvQAO5mVBWj+AKO3run0Ponc8vq+DnBF8DwcZVgeZ1N2AjSeHFRmkIY4RRe1xQiu+2vQ1qQrEu6Eh7Pe9cJYfxgiDSFQSRc3pPqUWS9kV5hGGGi67vbk2dc2f1B1Ofo9k8YFwv3C3c6Zu9/9xCzrTNNnP0Eln7JGJJzDF0ASKiNuld6zRqIkHuQfY2zaHOMm8wyQMJsMRnBwUzUSqikuf0bYpHjXbpNZi7hCyYlz1iqWh9ZtAU1rHLs4dPF6pXXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by SJ0PR11MB5136.namprd11.prod.outlook.com (2603:10b6:a03:2d1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Mon, 18 Jul
 2022 00:58:26 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 00:58:26 +0000
Message-ID: <6d70460d-0a85-4104-9abc-dd100af99e6f@intel.com>
Date:   Mon, 18 Jul 2022 08:58:17 +0800
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
From:   Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <26d913ea-7aa0-467d-4caf-a93f8ca5b3ff@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0129.apcprd03.prod.outlook.com
 (2603:1096:4:91::33) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e85b0044-e857-46b7-c74a-08da68589f16
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5136:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2mOttZPGOZXE4CdA5XL6R0/m0savI8SRPrvoiqcFB7FszCJwRx6OR5ROOWi+QHmX/ybJ9liR0n2J55O6qnBVVBc7L7/idP5ZFVAENFNs7T67IBv/uhFmjv/bYwuj0+g1b8Z/kKx4Gzwz+8DX/s7Z6T4sQruQ1Zd3TifRsUxRmmm+jX1dxMD+QTAYoKLdLuN2ZBYm85jSYA7fb/BAysRhznsgFfhKJzzSGm7rgxOwToy3yd0oI0DJ8z+1iepfdfCOhIHZtDH4xmZe/IMbXXwe7NRDMnRmh8OAwRdVo7f6T7wg+3ynRSkYp1qgMOGjEBMC7GWdOtek3IwL6KcTPeGhvPIZN9o03fEGBXvj4ST7+XrIk6W5U9+9LalHjZ4WBdl/Q80K6wCfuwVut8YI761b+Ykfg146UewV5hSo2c4IMXucoVZPcnoHESlRXo0aTtlql4PbEcIFGsYA9YE3ETbNw/EUVRW49pzGWFkfi4cEpU+u7XFYRNmnkcTU4qGYm1GWsndKiWv/qD/I/tVRUuoXjqzW9/fMmTerwY+E6L44Z7zAFSTMPEA0mxiQbR73mEjdTVP1NXRpLueBeJ+LTBQbv7kJ7XsUsBqBDDeMYo3lDOsfLdib6v1u5LI+jW2+vhwNgfVXMIXBw7XfC4lL5c0VILIGtjNgCLJNWmzI7xrYlDOMgEBerAksrHKQdDWiNWdKLWIxIblGb4IGpwxRVI/ZTy4O2mKB2IKZvFlu9xLAc6J6zZ4K/R28FpVxwDtdnV8vgQDTgXMHKlobOEbkLMrtodjTs4eNKuP7tpkXqOqy8OEWSag2Z8JkAFYHh4hKnCFqNdIL+idV9MYBy1652x1i21r/lmL449HJMrro55rc9LOvChEl6sUSOZq7Bk7BdNjx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39860400002)(346002)(396003)(366004)(110136005)(8936002)(478600001)(66946007)(66556008)(66476007)(86362001)(8676002)(31686004)(4326008)(316002)(6636002)(6486002)(2616005)(36756003)(31696002)(6666004)(38100700002)(6506007)(53546011)(2906002)(26005)(6512007)(41300700001)(82960400001)(107886003)(186003)(83380400001)(5660300002)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXJuayswTUtXV0JZb0pmNjFnTWpqemhBQlRabmZNeWR4UGhNSFNaMWNTN3R3?=
 =?utf-8?B?dVkrcTZjbXBHbUlGZzd1bGdLcFhGaXhJaU13UEZKQ3hvRUJ6U2hxNk5aSmRD?=
 =?utf-8?B?ZWFQb01ZV2w4b2pTYzJRc2FyRlNxNmt4Tk5WM3pYdCsrM0dPUVBPdXN6V3c4?=
 =?utf-8?B?TTJBSWJFeHo0YzkyY1NETU9ZSFJCcTFuTmpFdTdwK3p0bTNhY1JFZVBEQmgy?=
 =?utf-8?B?QlNQM1Uyb0lBcW8vK3V6cms1TE1BeGFBWE5nYXlJMzZpZjhJdUNpd2ZlUjFJ?=
 =?utf-8?B?UG5xYmxNWDgzcEtIM0ZZVFZVNmJWNDg3QytGV1RVdSs1Nll3RFRQUEpUeGNX?=
 =?utf-8?B?eHFQa01PWWhBazZxRS9NWVNqa0o5UDJCbG8wTDdZeEVXUHNJQ3RnUzFqKzF5?=
 =?utf-8?B?N3plV1A3R1hObnUvMnlYZTIxRTRWZHhJWE1jVXp4b3lVa09KNkF4U1Vncllw?=
 =?utf-8?B?ZEFVU3ZnUU9sbjN0aTJuTzBIZVEwcU4rOGNGR042VHZUUlkrd1V2RFNPRTdP?=
 =?utf-8?B?TG1XVDJzTzZ1czNISkx5bklrUlVFMC9nS0l0YTVTMXdMQk9HMjRrK1hlV3c4?=
 =?utf-8?B?TlpOaCtzbEpsNHJZNHgrYU4vNXh3LzAwUzRVc1U0cXkrUDM1VWw5dW9SOHNM?=
 =?utf-8?B?ckNwWUFOU0tHczlNay9xZHZLN2xGTTErYmFmZnlPbVp5a3ZWV1JEWnk3QW9k?=
 =?utf-8?B?dDNQMVo2NFBacDd5VFdRMy9PYjBBUkNoZUpWZ2V0bk54SVpSSVdPcmRIRkJh?=
 =?utf-8?B?Y0tSWElLclBuZjVleWFwTjdqZ1JwdkFYVXlrbHJIUDk3cEN3d2s0c0NWbGdt?=
 =?utf-8?B?RXRRRDJFRTdSMXBYNTYyODlnUEUrSFJJMW1WbFQ5UlpyVnQ3Y1preTNId0pp?=
 =?utf-8?B?NVI2Wm91dEM4THcxY1h2WEhzcUNuTXk4THpXeUFxalM2Nm81WFliYmVQMThm?=
 =?utf-8?B?MElIWGZTMUNjWlMySHJva0RhUzhMdHJVVXJsQ2hjNWZtNXBLdDNCMXZYYU1T?=
 =?utf-8?B?d01xbmw1ZnlOU001aTE4N09RdTBLdGViNjNNbGRxRllYRkZFcVJHYjU3VDkw?=
 =?utf-8?B?RnEyV1c0ZWJDR2JEYUMxTzh1dm11ZjFYaFFYN1hXb1IrWndENEpBWGtVdUVl?=
 =?utf-8?B?alVlaEU1SHNJYk9KWko2SVRPYlk0cmRsam5WZ1B0WjFEemxhcXlZTzdHY1Jj?=
 =?utf-8?B?Q3hVakU0MHFkNmcyWU9UN2ZzLzEzTVNEWFJjMm5ycWEyRUJFNGFQNFNiYTA1?=
 =?utf-8?B?VldNbVJ1MkgyZ2QyRnU4ZFdLUHFSL3JIOFZyWEZZdXU5QWNLVER1Q1NVQlZm?=
 =?utf-8?B?bzJBYXQzc2hBcVhhNWl0N2xabWdydEtzVXZOeVF5dllVTkJQeGNjMDhBNUM3?=
 =?utf-8?B?R0s1UEROQnNIYTJvNTdaNW45S3djL3BJdUFvZ3l2NXN4VUc4R0ZOSklOZWFY?=
 =?utf-8?B?dml3SHpkRFlLSGlLOXdTYWlMWUJvK1N5TWFzTlpYU1JIMGZESFBjSks5citW?=
 =?utf-8?B?T3BLemRoTUhDNVNyOWtLUVN6eWlKdTZJSk1GVTZ3U3hQcWtCakU3Rk4xTWF4?=
 =?utf-8?B?SDFnTWN0QmFZTTlzdm5lWEttaUY2Y1VKRzErZDlvWWFKa0xkNThIMU00UjIz?=
 =?utf-8?B?MjBVNm9oTmNVMDl6anJpeElXcGxsZHZubFhsVkUrdTBTbCtBeFovQkNVdzZI?=
 =?utf-8?B?enQxQld1TUExblBXUVlUNEVHd0t5dFpoQUo0UTNZcmxrekNSL2VRNUZEVnJB?=
 =?utf-8?B?Y0dHRUhTaXhteW1RMGhUSFo4MFZ4bUEyUzhhU3hmWTZGMVhEUkFoRW9mdXRQ?=
 =?utf-8?B?UjJsU3JkU3k5QTlUcmNrTlZ0QTJXTFhlUVNrazBqdzluUmI2S3BNcDAxenY5?=
 =?utf-8?B?T2pmbHdWSUtiRnJxOWVXVnJJOEZmYWFQeUhhMGJLUWo3ZkxXM3dYdlRjYWVD?=
 =?utf-8?B?YTdqdVV0UHVBQnhSdkdIenBCbWJkT0VSZWJlRXJQRnNEQXh2aTBTN0lLYWVI?=
 =?utf-8?B?SmtYTUdzaWpudmU0K0NFZ0NGMVFPVDYxNi9pSkJoNzlnZjAwNVFYVk1Kait0?=
 =?utf-8?B?bjI5MDdEcmdnZDVYeURhN29MbHhieHBRcnkvZHRYVDdic1U2Q0l6VWR5Y3hP?=
 =?utf-8?Q?7CAXNO55qVghAPyEm8VN7OubO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e85b0044-e857-46b7-c74a-08da68589f16
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 00:58:26.5253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VAfyi4Einkn9F4l66iwn/yfBNpT9m21tUg0J9xAOkPnCVi1EH9kRjv1zDBJCJHDOjpGGBkHNNpaIpOaPyYc7AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5136
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 7/15/2022 11:58 PM, Jens Axboe wrote:
> I can't really explain that either, at least not immediately. I tried
> running with and without that patch, and don't see any difference here.
> In terms of making this more obvious, does the below also fix it for
> you?
I will try the fix and let you know the result.

> 
> And what filesystem is this being run on?
I am using ext4 and LKP are also using ext4. Thanks.


Regards
Yin, Fengwei

> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a01ea49f3017..797fad99780d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4269,9 +4269,6 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>  	if (unlikely(!file || !(file->f_mode & mode)))
>  		return -EBADF;
>  
> -	if (!io_req_ffs_set(req))
> -		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
> -
>  	kiocb->ki_flags = iocb_flags(file);
>  	ret = kiocb_set_rw_flags(kiocb, req->rw.flags);
>  	if (unlikely(ret))
> @@ -8309,7 +8306,13 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
>  	else
>  		req->file = io_file_get_normal(req, req->cqe.fd);
>  
> -	return !!req->file;
> +	if (unlikely(!req->file))
> +		return false;
> +
> +	if (!io_req_ffs_set(req))
> +		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
> +
> +	return true;
>  }
>  
>  static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
