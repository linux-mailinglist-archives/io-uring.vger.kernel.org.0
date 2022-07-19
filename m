Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025385795B2
	for <lists+io-uring@lfdr.de>; Tue, 19 Jul 2022 10:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbiGSI7B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jul 2022 04:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiGSI7A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jul 2022 04:59:00 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C695205D8;
        Tue, 19 Jul 2022 01:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658221139; x=1689757139;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iYPzKwUOKkNjVW1ZAZGVg1BLycU9yHftV15yHm9+9ZY=;
  b=CecgMcODoppGVQx7PpmYWIuaQw+9Ke5Mgdn3O4NrUe2sMNprOztAL4kE
   VDPnEklicucAm5rrLDcvqjI7P8ADprP9sUyrFf7LG3xOQCsvll2yD+lbK
   h6dJxv5SsrTDqBD04NZEEka1vVrymca6mzjA7X5cDYm4zq0fRfPH92wb7
   YVRZoAaXGLlWynrUPacpkFwKKd4p81MAhp+h2NbedV5mv68N/FRei8i6T
   7FfMFEjjFYJ2b27iqDnpARioPYSgdMRIuiYRkY5fzROXhkFZCvZS18BKL
   paryRoHRQmiCclqrGYMNs8g1A64dr7TFDpzeqL6cgNR6oJV3FOPlit2+h
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="284001414"
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="284001414"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 01:58:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="843580503"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jul 2022 01:58:59 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 19 Jul 2022 01:58:59 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 19 Jul 2022 01:58:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 19 Jul 2022 01:58:58 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 19 Jul 2022 01:58:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1mdvapK8odfFT2q74vjpSuH6+fXkJtjzBDFo++tCqQaJHoEpGTY1muBSlXmJJ+aZ4I568aeG0GU2khPiN0OzH2Ij7unCYnmkW4kyzGuz+aeWJRxJwnQg7K/L2RCotFjQxphAieDlugne6cAsEM6ttCov3W4CkE3AXYL9CdV2Nk+UhhlJMnZlR9P/LzxstnMMo0x3FpmRNpXLwvOYfY3brscyjlk0TM4RJQVZtDIh7/CVwLHiMTZMcRaa6HSoKQBeGbhdsGaAWhZbtmUzM1OEUS/25Lk5xzrhHvUdFKs4GpN+feY24c4LlYeP7mzG7Bw/40r3NqTXjPFfj79tCyKng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CeVw6O6tivRSMFY04JZZ5zPUrZW4pmjRSKZweKBPuLQ=;
 b=QOIPOKAd1ZUSc0INFAGPWCGkBfF3oO/HZdim9+Xww9TazHWFYcEnm7Qp6XMJfU+aTUJ8doB5Nom869dsnagaGJx9Scoe5T51389rDr6bqxtQaQROwofd30phSxUBK0sLDuIWJdBUihyhFuJOEO/yntFV/NPJ/JQOrXLjhacznkPIP3LNaHNidpu8hss6GxP1vv7ATrv2CjMO7lsXb0fMLOUnJc2xs52hkkyDBPcGA3fiIfNxDvYtHvPOxOjdTUpHZqLoWagj5vp4A/iRDI17OQdrSdmSj90EeL6DE+YfCII8Cpfm7ldviFU9gmkwpx+58UMkz+ImcYZ7oJ94wlmcgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by DM4PR11MB5295.namprd11.prod.outlook.com (2603:10b6:5:392::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Tue, 19 Jul
 2022 08:58:56 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::552f:2392:56f8:ca32%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 08:58:56 +0000
Message-ID: <2ec953da-78fd-df01-44cf-6f33a5e40864@intel.com>
Date:   Tue, 19 Jul 2022 16:58:48 +0800
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
From:   Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <74d1f308-de03-fd5e-b7f0-0e17980f988e@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0093.apcprd03.prod.outlook.com
 (2603:1096:4:7c::21) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 148e3336-e1f1-467e-2060-08da6964e94d
X-MS-TrafficTypeDiagnostic: DM4PR11MB5295:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y/CnW6qRz9mFG0N+UVswHeZh8sd5U/8Uwof64rH2EOhV3YC2ZzvxHzaIliLod5nRrPhhe97815X8zl9XKUv+7wSV+37QYRoIYyKxVS9d/zaVdYd/Y8kJ8XAsHwlc00dn65Jp+FDbNyLEKj83svGn2paM8X3aMLEeomBIpVN1fdjcNzhi2z61425NKSstC5EmAZstmJxIDddf8EgmIrgeNdfeBCF3g/Ed+VdAX3G8nNOljiUp+qr5+Sv/85c/kRhh8VP6PZEz93X7M/Fu+zUF4DmwBmL3/XSAeyJHESOeb99vmUhThjhnjdGTDE2DPlRrGeC7sSH9Dl4NcKcHsiaZlSQOloVvrU/T6jeNCvRTQpb6FpyrT3mrhw2KxrL3SYcNSCBOt0eGAt7op2WgqdJxcYRkeQ8X39pSYnalewSolOPAr53Tp/M7Ma6pzygpox8ZiSBg7FMVTX/psVhOjKmokITESoNgN475Fk29eUEZIFa+C6+4MnuvXxRI+bwh+QxUT7BpjUu37H0nDw8Up1RKe+TmxczhJs2ixIoQUDU6sNJeI90xKDgwGA8IY0G9qSKCQORGDG6zimr+zTyZJaefEE6S5hBj/ABJY5vmvUYD5G/X6R+ma+KphLEnhnWiyxslwlHv3eNAjZkfkGp5tb4wy+DbrzvLf0j2+c1wMpzJgyYyRTRLh+60ZwD5TvCVFUihUizn/koowBoq0jdA7CN6BI04CguwGYwEK2AOQyInHiHdGxHC9qQ911CkxwIijuO0TTV+UfsoYTCqY/WqKyXJ3JOvPz/JAA1ZVfIAfW4qPSzE8bYoAVpChG38CvgPwks8GxS0ivYUphNb41qxRxNf+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(136003)(346002)(396003)(39860400002)(66476007)(8676002)(66946007)(66556008)(4326008)(316002)(110136005)(8936002)(86362001)(36756003)(6636002)(31686004)(2906002)(82960400001)(38100700002)(31696002)(26005)(478600001)(53546011)(6506007)(41300700001)(6486002)(83380400001)(6666004)(2616005)(6512007)(107886003)(5660300002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEZRZEZWRDhyQzB1WXZwUUhIL2ZEZzN6VTZXc2VRQlVKdk9aQVBoSmdmSHFH?=
 =?utf-8?B?MjU0RGtaS005TTdFSUkwVFpoS1ZvQ21vU2lIUThtU1FXYWlsZWJ2LzZTbnlp?=
 =?utf-8?B?NXI5cE1zVTRxZkM0bVRGaFBGeFVyaElsNXIvaG5qV1Nmd0ZVekZVWTFkeDBK?=
 =?utf-8?B?eTVvQ3JxRkZ6OHhmQjFBMWFMU3RuOFd2MVhoRjh3TUY2bk1pQlRnMjBGVW9q?=
 =?utf-8?B?dm9Ba0ZsTTZ4VEg0WGltY1ZaWXhCVWdZd0s3SEZVN0FhT2NlT21tL2lpU1hx?=
 =?utf-8?B?QjduMFc2Q01NRVN4UkxLSlBUK2JZeGUyUVppMWovdDUxcnBEQVlFM2tDNURF?=
 =?utf-8?B?Vm05YVhtZVoxR3RzM2FSSER5ZkxVZHk5NmcrR2hEZWtWODRaakJNRHV3anNX?=
 =?utf-8?B?RUtoNkJ6aVVBcElDbnMwK1MxN1lIcWhXQ2VyVTlUUGtnUWRiaFNxNEhPRjhm?=
 =?utf-8?B?ZW9LWHdGRTg3TFREcXdBYzJwdk1HOXJGbWU5TnJXSDRHSUpLcUtKOXg5Y3hJ?=
 =?utf-8?B?Y2tYWExoVjdUR0MyOTIrUzNHSmd6UlFHZDdoaEZKSGdvak1BODU3b1hZbHhY?=
 =?utf-8?B?bDJ4bjlHN2VycHQ5dHhDVFc2c2pqSElldk0rbHk0Vjh0OVNmR1oyeHpxMk03?=
 =?utf-8?B?Vk80Y1Mzd3Rsem5iNzkrSXJCQkxQdGZlYXlURWtnOEZiaW1GaFBtWG9URzcy?=
 =?utf-8?B?QW9BTWhyRHNGZnE2bjBOQkExNWxuNGY5bHUzdDBDZzhVYTJqK3c1TUZiS1lZ?=
 =?utf-8?B?WlJzd1BZT3I4ZGFRSC9WK2NTSXVKRnJSeTcyNHNIR0N3dDZQRnpWOUVjU0Rj?=
 =?utf-8?B?OGhFRUlEUllOTnhVUTNtQXBER0UxRUJteVBPMnlpL0R5akdPYUpBNDFheVd4?=
 =?utf-8?B?MzVhZG9Tclh5Q3hIQ3duUnBZL3lCVUNPRHlpT3daSDQyc1FKVkVFdExBck1L?=
 =?utf-8?B?OFVPWEY1QU02OVU4azJOZjZicG5ZeGI5dlhCcVB1dHdRRUxXUDk0UTg1a3RP?=
 =?utf-8?B?cW82N0FoRlVpT01icnJ1NUNTSUtBVjNQdmozZVJ5azluTStjeXNvQVFEajBB?=
 =?utf-8?B?djIvcW4zOEtCMkNWamRQbml5SUhXVVZkYmlwdW00TTcvTzNSVTJpVE8vYXVY?=
 =?utf-8?B?VWdla0RRREdQa1lmZm8xRmk0NFQ1QUE4alBvcUE5QVQyUkQxOEtYWWFSNXJD?=
 =?utf-8?B?ZXdrdkU2YUlTdDFpRFFZYmVveEZwVEE2bFMrWUF4ZkdIWSsvalE3UXoyV012?=
 =?utf-8?B?dlFrcGJHbHNjeWc5NHdtM01BNWtacXpkVXNadVZHcnB1LzY1QnpUblcvMWFN?=
 =?utf-8?B?TUc4UjNxajZGV1lCWjNpeElySUVpdHFMeUJWaTh4ak4vd0x1a1dUUE4vZy9s?=
 =?utf-8?B?U3E4R1N3d2UwWnRPdEh5Mmg1MmZCSkZJRnd6Y1czWkd0L2pYVXdEMkV5WG9u?=
 =?utf-8?B?Y1VqNVUwL0l0OW03SU9vU0JXY2VjRjB6QXRTZS80OWRmR3hNbG5wdGx6NnJG?=
 =?utf-8?B?dHNKV3g5VFFaWEFxNDF2dGVjZnVLWW9nUXQwdG5XeTQ1VDErM09JaDhMVUtl?=
 =?utf-8?B?b0I0WUVqejVpUGlpQTR5Nm9PN0lvcjRWajFyZFZoM2h3UmpKSkNtcEIzQjhz?=
 =?utf-8?B?dWZXblp2eWZpa3FjaWRkMHBQRCsyK2ZlQjhLT3VidlNaWlZyYnNBbnlNUG45?=
 =?utf-8?B?UWQ0VkZ2VTM4bUlCZ1NjMTBwV3Y0dXkwbklQUWdXQnhMVmZBcHFDbmlEbWx3?=
 =?utf-8?B?clQ3TkJINGtsTlo1VFpsM0NXVTNNc2VYcTZMTmRZOUJsbXpFeGRRVE9HeEJl?=
 =?utf-8?B?Ly90S3UxZ1U1WmdRdi96YUE2MFVlcDUraCtERmNFS3hNQk1PeFdLcGZjTHgr?=
 =?utf-8?B?RUtmWmNObk05UWMvVWZWYjJHaTZOdk15VnUwU0twaGZRZ0xpbjMxMUVjRHlw?=
 =?utf-8?B?bUJLUUFRb2Jsa1lhZ25mWEMrTHhqR0JFNVJDZCtQTW1POWRydkdQM0FhMGtx?=
 =?utf-8?B?SWVqL1haQlh5OUhCWmVUMjZrbnpVUnNPRlZXWWZTc09LWlN2ZFM4NzJ6dUVE?=
 =?utf-8?B?L2R6QjdvSWxVeit3bkhmY1hOVzh6dEwrdml6aCtsQTlWZVlBelA5TXg3ZFFw?=
 =?utf-8?Q?HF9nVxlrjnO7BYcosu2VHv8b5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 148e3336-e1f1-467e-2060-08da6964e94d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 08:58:56.1119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4La+mErpmMYsHS5Pnkktd62VDwHTavlCM24gg6eqvWcYwc3cbYQNu8NLX9wZXrY9OBEEItrb227WNDgp3NqTpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5295
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

On 7/19/2022 10:29 AM, Jens Axboe wrote:
> I'll poke at this tomorrow.

Just FYI. Another finding (test is based on commit 584b0180f0):
If the code block is put to different function, the fio performance result is
different:

Patch1:
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 616d857f8fc6..b0578a3d063a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3184,10 +3184,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
        struct file *file = req->file;
        int ret;

-       if (likely(file && (file->f_mode & FMODE_WRITE)))
-               if (!io_req_ffs_set(req))
-                       req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
-
        kiocb->ki_pos = READ_ONCE(sqe->off);

        ioprio = READ_ONCE(sqe->ioprio);
@@ -7852,6 +7848,10 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
                return 0;
        }

+       if (likely(req->file))
+               if (!io_req_ffs_set(req))
+                       req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
+
        io_queue_sqe(req);
        return 0;


Patch2:
diff --git a/fs/io_uring.c b/fs/io_uring.c
index b0578a3d063a..af705e7ba8d3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7639,6 +7639,11 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 static inline void io_queue_sqe(struct io_kiocb *req)
        __must_hold(&req->ctx->uring_lock)
 {
+
+       if (likely(req->file))
+               if (!io_req_ffs_set(req))
+                       req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
+
        if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL))))
                __io_queue_sqe(req);
        else
@@ -7848,10 +7853,6 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
                return 0;
        }

-       if (likely(req->file))
-               if (!io_req_ffs_set(req))
-                       req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
-
        io_queue_sqe(req);
        return 0;
 }

Patch3:
diff --git a/fs/io_uring.c b/fs/io_uring.c
index af705e7ba8d3..5771d6d0ad8a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7598,6 +7598,10 @@ static inline void __io_queue_sqe(struct io_kiocb *req)
        struct io_kiocb *linked_timeout;
        int ret;

+       if (likely(req->file))
+               if (!io_req_ffs_set(req))
+                       req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
+
        ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);

        if (req->flags & REQ_F_COMPLETE_INLINE) {
@@ -7640,10 +7644,6 @@ static inline void io_queue_sqe(struct io_kiocb *req)
        __must_hold(&req->ctx->uring_lock)
 {

-       if (likely(req->file))
-               if (!io_req_ffs_set(req))
-                       req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
-
        if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL))))
                __io_queue_sqe(req);
        else


The test result (confirmed on my own test env and LKP):
    patch1 and patch2 have no regression. patch3 has regression.


Regards
Yin, Fengwei
