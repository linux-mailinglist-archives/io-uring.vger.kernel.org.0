Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF18A5779BE
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 05:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiGRDay (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jul 2022 23:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiGRDay (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jul 2022 23:30:54 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86399DF02;
        Sun, 17 Jul 2022 20:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658115051; x=1689651051;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x6tfO87yWIVFECmoXDc5LHCLcOn1RTFkwEDyzMMm47I=;
  b=cyVkaDn2/G7lrcH5+SahtVCSWAnaEjvwstzZ2Y82kQSJ/ktWKpsTqBgN
   hcYYTJYhX9k/Reqf3yPJn2qnefBZ8zjnO6rCyfN7afGUb9jtWj+EIRQZN
   tk/R3B6+MwRAC4UTfqEokTuDkIN+SsDl8gRtnFlv9jm3xgQhvuity2tgt
   Y2UNXcS58KicdYNA/V5DnUfrHwgHPvToN9RYkqUYcst1H9Bg5j0CJzyts
   we6RiUlMGKDXZVakmoAScSCbVmCZUGKQyCFVje28fNHBeDirvi10JnwMW
   eQLDLiDc+tqlMz0y20RyR7/06p7Zg84RnrKR3MzDG5p4OB7cgBeTPQxnz
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="350085668"
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="350085668"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2022 20:30:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="773583669"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 17 Jul 2022 20:30:50 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 17 Jul 2022 20:30:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 17 Jul 2022 20:30:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 17 Jul 2022 20:30:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXAebPEtUq8Lb2vXeXnwka1fub1SuRDoGAYeto/7F3/X6tezx3qlOlbZo5wkU3Fwamz7KH/ZySmlTxgmv5W/u312viacgQ9xSFWeeGtYpYMIYTDP+XDVWnCtJb5go0WKTGxO32ltgkVKq78hGrhwNgROpbbcFQAaVKQ+K9filHlGt5z3/5yyDt56L3AV9Lt6QoVzA7/phe74oEFocleKXrQJ+xqSzXxEtG1KklngqrvwNKN4/y4M1jsX2cS2JYV652HjlfIHNsJwa61d3SUiB0ovx+wPmxUVHOB+QU8WchExBCuZHnLSwpNTRM0HMkWtumWbiLezXIZc0kVoIlUF3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbLglWrA3PEh3VZuSZoZ5g2ow+uYhrqU40EV4kWqw4g=;
 b=W1gs6DzirfpLiY06P+QHH7q9er09k15NasOl7sVQ/yzkML307rqFbBsReQzhnE588YU083JyaePXStqCcnKbWRBuYShKygE9ecwEVpf5t2xPaXb27FW842yhFBSZ+T+sXP774k3/Q22gQouPMKcG9HdHp07gkWAQ8J7xJkfIUzn0wWrU8Lb4bMCfAO+FPRfY3nLFTu1qgcYOrmAQeL49SifaT9m+GdY34fQQdEYKg00oIBae4uhOpI3uXy7mjEVG9ivPvwvzLKTDydq3Lcg+LugOT2tXk8jp15ocpx3160moIdBUMylRaatLGM0eOl7ZSTsZgLd3LNb8IUyetBsXzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by BN8PR11MB3554.namprd11.prod.outlook.com (2603:10b6:408:88::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Mon, 18 Jul
 2022 03:30:43 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 03:30:42 +0000
Message-ID: <9df150bb-f4fd-7857-aea8-b2c7a06a8791@intel.com>
Date:   Mon, 18 Jul 2022 11:30:34 +0800
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
X-ClientProxiedBy: SG2P153CA0019.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::6)
 To CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22fc08b8-2ad3-4b3b-174e-08da686de4af
X-MS-TrafficTypeDiagnostic: BN8PR11MB3554:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xXLdxP+Pc1lROx/5S2zHpcBgDjKaSB8/1JCDRnP1uGWdZYYx3nnZveE9iG2ANUjUwXCC9osoQY60oCGxxqntpfnBl/yOs7BWVQhVLgiM0KHadD2J0zmfaJNfCJqQnMzYY7D5GlUmZgtShT5nb0ovI1TPgq/NFB8sP1d1IcJxuIxjveCCEuf41gO0xTwSyxL7UA3ZHy05Am9QUAGAydqgtnuESACN9VTI2Weuu9wnsANrBUAPJmov6nCJEGoH3L86G8UasLgFymqN0soVKFvKeU/t3eUfCgxUgtIXhy/pzvggGe2iONa5wzKkDxinBxvrt+Mpvnv9WZyOsgtI7J/u1ZhbTQfgDSMa+slSsn0tE1TmRNkygwnWbsuP+HoEvJsQHh1xyaGIx+Wl7habAJ9/wQYmvuAEHqWa19wEwHMForWhekTdHb12TGpN2ICZNwElFe1M7DJyV/yIJo19wulai3RB/TjCxfkpDZMzwb5qTNL+rAVFX6HQq5OVV+v2EeGNyF74+HP/uAVgpPzBxRHaDLm7jrV3wwBBnCpBxkwVjuETWbJZuDUulDHBckPy/VF+7Wf15q12Q/fj8o7lB7Rir+ml/8iPdTrgM+LWBmxQeL1O5BekWBfAo3d3OiiBBAkTgcdH2FUEONFuo7ue4NkphV5rQr/b7cGwbLwltLC3KFv0KfUZyUSbE2v1iCgvDXRDft+EwtlLJlWnTX/rXuT5kFDZL3xTpPdaMY5kqAKkBZV+n1pM+4zSFbIga4qCimB6W8nIf/sWqW/Yh6tfEO8cg+DgmlhYEcBeDUjh2602Fo++SK26HN4Zo6NV37GvEHnBm9z7YQmPwURRGuQ0cGHVpvsX4XK7SqrCvKzNQ37bfXw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(39860400002)(376002)(366004)(346002)(4326008)(6636002)(5660300002)(316002)(66476007)(66946007)(66556008)(8676002)(8936002)(83380400001)(2906002)(82960400001)(31686004)(36756003)(38100700002)(86362001)(31696002)(6506007)(6512007)(6666004)(26005)(53546011)(6486002)(41300700001)(478600001)(186003)(2616005)(107886003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azM0Z0R4SytZT3FUa21vUVk4VDBrVFR2NElwYXg1QmFrVHpjQVNEM2hVUUIr?=
 =?utf-8?B?NGFROXZ0ZzNmbWRFYUlRN2hnd2RzamkwL3BqbkZGUG9Id0hVcDRMV3laNi9B?=
 =?utf-8?B?SVA2S0k1Qk15MXliYTc3Zk03VnlaMWwxNXd3dUpIRFFnL3BPaDNIUEY2TEtS?=
 =?utf-8?B?QXRvcXllOXFBQm9yUDh2ZUZQMm1CMFlzSlFjS1Q3MGFyQjNVaDFTVEllc3d5?=
 =?utf-8?B?Y29vdDA2TFRRRkhQNXN4bmR4N0ZiSDB2ZGpaUmNJNXlSaURUbFV4bkcrcEJ5?=
 =?utf-8?B?dEg0WjYxdVBoRlhMUHllNEVHUkVRRkpyM0F1Yng1bW15bDhWRmRlajdGUURJ?=
 =?utf-8?B?ek1xY3dROVVMVXpPd3RzNStwZTZyaENmSkZKSDVtbXhxUmp5d1JXYmRVTE0r?=
 =?utf-8?B?V1pTU2lHR0o4akxzVTdEWStKQTExMU5Fdjl2SVp0M2FZRnVuNjl1dEMyZUVN?=
 =?utf-8?B?SVduY285OUg5UWh6am8zWUM4bkxZM2JqdWRSNm1BM0NLK3ZxN25iMEsxcHd3?=
 =?utf-8?B?R2dpK3RaODJoN0hubExGSkZmRFYreG0rcFl5cHRodUpLNTVjU25VcTVHaUwv?=
 =?utf-8?B?TVBvSHZpWXZ4aWx3WTBWNjgvbXV1SVQ2bG1jRXJ2SnZtcVZMcDgxUkg5RHcx?=
 =?utf-8?B?bzNhNkZvWmtNRlZKWGR5UEtGbVJhZS92YWw2QmtNRFArNFB4YXZjWUVZN01r?=
 =?utf-8?B?aEtOY1oyNy9NNnNJYndZVUlXUGxRSFFadXZ1OVpqVVlDMWxEb1kyNmpHMUZt?=
 =?utf-8?B?c2R6Y3JxdWtYaDgxRDk2Vy9jWGl1cHJRc2RZRzRyckJyM1Zva2tVaDYxZkll?=
 =?utf-8?B?UjdHU29wTmR6YUt6NTJQNGo2cFJSQ0czOFdKbmhadE5ORTlITGpYRlowWnVI?=
 =?utf-8?B?ZUtleGJ6VStQZE8xOUd6SFF1QTI2d1czM2QxQ3dzTlVmSTZ4NkU0VlBZRlJw?=
 =?utf-8?B?N2V3V0FJaUJ5QTdZMEFpOGdEaFM5S1E2SEhjYkZ6Y2FIczlXK3l3WGlwZWRy?=
 =?utf-8?B?YnRyV25MTWx3UkVDTU5MZmdDOFZ2VWh0b052enVLNTN0NEYrRnR5Q0FjOS9t?=
 =?utf-8?B?aUYwckFucVQ1WUUxcDBqWDJzWXJhWCsvaEU3b2NtMmZUa05LdFdJeWZaV2VM?=
 =?utf-8?B?RlZhaHZTeVFrdzVFa1VjcksxbU1JbFo1bHJiQjUvbGxlTjI4ajlFSHdqOEdI?=
 =?utf-8?B?Tnl0dHZwUmFnRnVBbElaNUR1Mzd6U3JuejdJT3I1RTlmQW1JK2hOeVQ2aEZE?=
 =?utf-8?B?VUtxN0ZBaDNKZ2x6clBJdEtjUytCTitZNGpNOTgyN0JsUFdMNyt4Nmxad0F2?=
 =?utf-8?B?azZPaDhBb0ZVekZ6SDJaZ0FEWlpadVpPZVNkVXgrNDg1dmo3UXJXMkxsSThO?=
 =?utf-8?B?SThRWVhnZDd6ekJHZ0tLNDRTcGlQZ3lTOXQ2bEVGRklpa0duNVBZOWdLZVhq?=
 =?utf-8?B?ZkRmRjNjd200MG0va0MyL1pmQm1YNUVlWXM1S3BTZzFiOW85aG9oZWhIU2k2?=
 =?utf-8?B?c0J6cUg0MW5NMmUyYWk1Sm5WOENBUTI0MFNxWHdhWWs2WWRWenVUSkVMZXpM?=
 =?utf-8?B?L3dBYmlxcjZMMmRHSFVmcnVJejF5Nmk0dTB4bEtLQUdGTU5vbVFzbHVkSFlG?=
 =?utf-8?B?UTVRbDZjQ09sVHVrcnFwZElTY3VzczVOMVFIQThad3ZyMVhJejRYbzlFTjYw?=
 =?utf-8?B?Q3ZuT2o3dW9ySC9vR3Fpb1JGT0Jtc3ZYVkhNWGlrMnJreWN4Qk1lMjJkckJp?=
 =?utf-8?B?NjMxWTlUVm4vWjhoTldBZnBEdjNld2JUVForV1lLMzRrUUxJaG9jUFdMRndq?=
 =?utf-8?B?S05YeTVQWVZYNVBSUHozTU9aMng3SGFwT05KcFFGVDBJYkt3NVYyQ0J4MGtp?=
 =?utf-8?B?cHRlVkFpL05RNHZFYjlxNVVpOWozVTliRHZFQ2xUcjV2eVlSWTc5YTRnNmRT?=
 =?utf-8?B?dFpWMWl0NER5RCtJczBZMUttQW9kcGpUMFl5Vkxsbm5ITXFSYjFqVzl3aEkz?=
 =?utf-8?B?ekh3V2lUTFkrL1pUVTAwRUpZVjFXdzZpTnZhcjFqdTh2L0ZpT1U0V0o3SzJu?=
 =?utf-8?B?SXEwemNsRlptSHhPbVptSVVlanRQYk5zRmFmQmxCeHNxci9jKzFmaXdkbTkw?=
 =?utf-8?Q?zgD7oJGAhvBZXFoFxMCT55ZWA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22fc08b8-2ad3-4b3b-174e-08da686de4af
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 03:30:42.6719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3SF8YSnxadt7Afjz27wyeuZGrenJ1PMyiRqfQeY5FQxkNx3zMfhsO5PcDZGEKyV+jkHiU8AXpR6XCzn6uMUB2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3554
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

On 7/15/2022 11:58 PM, Jens Axboe wrote:
> In terms of making this more obvious, does the below also fix it for
> you?

The regression is still there after applied the change you posted.


Your change can't be applied to v5.18 (the latest commit on master branch).
I changed it a little bit to be applied:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e0823f58f7959..0bf7f3d18d46e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3762,9 +3762,6 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
        if (unlikely(!file || !(file->f_mode & mode)))
                return -EBADF;

-       if (!io_req_ffs_set(req))
-               req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
-
        kiocb->ki_flags = iocb_flags(file);
        ret = kiocb_set_rw_flags(kiocb, req->rw.flags);
        if (unlikely(ret))
@@ -7114,8 +7111,13 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
                req->file = io_file_get_fixed(req, req->fd, issue_flags);
        else
                req->file = io_file_get_normal(req, req->fd);
-       if (req->file)
+       if (req->file) {
+               if (!io_req_ffs_set(req))
+                       req->flags |= io_file_get_flags(req->file) <<
+                                               REQ_F_SUPPORT_NOWAIT_BIT;
+
                return true;
+       }

        req_set_fail(req);
        req->result = -EBADF;


Regards
Yin, Fengwei
