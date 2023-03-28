Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9E56CB460
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 04:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjC1CyR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 22:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjC1CyQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 22:54:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C6F1FF5
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 19:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679972051; x=1711508051;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HLeTu+dvmUY2uF8WBKBIyrG56I+eOytIdS1stx0P5Y0=;
  b=aR+cMI1uNpbARFl0Wl9Uz8zYKfeXXSuvMfbTTJwvf3l41P3ahcjusgkd
   3RBu8L6e3qgNbY1t4EYh4991JVGs1ARcZruydoJzN3VXoz+UVzqbdqms/
   jMyXegzObsgv8WV5UNOc6J57Fir4EpnFzIGrObuOePGX3RocUVTpua71w
   WWQofPzRN6EXcCluJbuwer7pTURpyRuZRBrQtV6b6G10bhq2GchiPK3Dj
   8fjO+Qav6VpMtabEFErCRkDfbaupF/cg2+DLm4e09L4HcPI9LSv3dMANz
   AbYOea4yu9619SrOZ0MZ6zg+d4IABdkvSp74pVnSFOHK13JMkq+WpHwLR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="342039078"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="log'?scan'208";a="342039078"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 19:54:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="633855362"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="log'?scan'208";a="633855362"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 27 Mar 2023 19:54:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 19:54:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 19:54:10 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 19:54:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gruUcCsAGY0sdW/tMLA0bFyeAqXYmIcGn2BEGaOFN/is7u8qh9K2VHVZphaqPo8boB/ncSZ2DQGSW6BWH8SALfHjbmfvnVlNLaNxBdx4zJuAlVOvaBt9OaDIqwDKmMFlIRaId7//1wWKyOvHl2CUMbocFI+STf0m9z2o6qf17jQvLZzEO7aq2M13u5d420zDt+QxQhHw64vptFhu5VuXkWkq58cv2pQnINLzZJweEmglMg+qASHuAmOZzryG4Ce5tMApzs5w0ahG3AdDwdcWic4w1SwvURDrJ4uyIoq2y4RF9xPnvl3RCK9pmLsKqB95JP7ETk+8qSAIM/JkbJflig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=caCGx5ESv1zDoSLCA/Kkjcdjs6iVjwYmMUTQqbzmuCw=;
 b=U34Oe+zU639xSCk9YXd5ytRJyqvpu0faNcM7mKRDj9dRfmnHV7V/blSrhY6jKal2+sg/GwFmFkeqZGyzC5j5mwXJqn/mXjMlqMiiBzEEfmxeeusQsCT4NibELWLJz3EiGfx56W2oNImCVu0fEUc0G3Ta/O7VRgAjWP+eKb6IC9C26pM36PYAQGFR6SBJ9+31z197JY1GnoMKf8KbQbznK+Zxmzdy/ps18ZkgnxMbRcWRg5Gge2SUTm5WJ9fjgH8qGpRbF//i8Ri12CPRI8IB0n1XfVmZvPVAG0gUPHzsR4iZnl4FyfBmdxk0Tujgky37cKHxhftuBsrBB0bs7a6PAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
 by DM6PR11MB4627.namprd11.prod.outlook.com (2603:10b6:5:2a2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.29; Tue, 28 Mar
 2023 02:54:07 +0000
Received: from PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239]) by PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239%6]) with mapi id 15.20.6222.030; Tue, 28 Mar 2023
 02:54:07 +0000
Date:   Tue, 28 Mar 2023 10:55:39 +0800
From:   Pengfei Xu <pengfei.xu@intel.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     io-uring <io-uring@vger.kernel.org>, <heng.su@intel.com>,
        <pengfei.xu@intel.com>
Subject: Re: [PATCH] io_uring/poll: clear single/double poll flags on poll
 arming
Message-ID: <ZCJXK29jnRXAW6FO@xpf.sh.intel.com>
References: <61e3fefd-0a99-5916-c049-9143d3342379@kernel.dk>
Content-Type: multipart/mixed; boundary="aPi2dJHnmmmy17mS"
Content-Disposition: inline
In-Reply-To: <61e3fefd-0a99-5916-c049-9143d3342379@kernel.dk>
X-ClientProxiedBy: SG2PR01CA0160.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::16) To PH0PR11MB4839.namprd11.prod.outlook.com
 (2603:10b6:510:42::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4839:EE_|DM6PR11MB4627:EE_
X-MS-Office365-Filtering-Correlation-Id: 30328d7c-5f2f-42ee-667f-08db2f37b2d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dRi/YqM5C61hxrOBSuMbtNxIVVt8VdK3tWUhMT2f+tNgHqxdhw7Nk8mJ+Q2NDrjT5lAYVnJXHk4+KnlEdI4xEaZXLkT8VX+PJ39WMuCDXwJbJZFsqjPy+FHwfTfv3yYFbvCS8I03SwCVBc+yrPkNplhXsEVpjaleNSDG5HsozibG02vVHJGsqljIii50Hllqhzlc9FEOsGjqydrLxstZ0XDXh8wHpKKcqQNMf14gRJU7OkKv9yCv3keUUv7uAfg9g40zhpuon2EUFr4N7Z0jQAqAl8yf/qJor9FQI4ce8Lg6LqBrCC9ys8XxWkDXbweoYywG+yjEZfTItH1U5HtoA+wHRjgD7hdTHmab9FWWKue8+rHrNprVROpnFLuwX0iCLGgGuZ6y3J4rsvR8XCiaN54jK6l50XITrJzPobwFOBj25b0PNueVoe2QixPLxHAO7/xW83NChSeJ5zo6ioRes6jmvdYYvtUiF0TW1u1wNpe4R5fG3bUdKTaLU4DL09pyC+4EX1qtSWB3x5Y7gLDNa+J0Cwta+k6667jMOHZ121YA/P75sJYdwEDdM8Gjo4xajd00GoPAhIF6N3qpdjceVlicFrQVfKLBFpO1W285AeU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4839.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(346002)(396003)(39860400002)(451199021)(83380400001)(21480400003)(8676002)(66946007)(66556008)(2906002)(66476007)(6512007)(4326008)(6916009)(966005)(478600001)(44144004)(316002)(186003)(26005)(53546011)(6506007)(235185007)(107886003)(6666004)(44832011)(86362001)(41300700001)(8936002)(6486002)(82960400001)(38100700002)(5660300002)(2700100001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Q4l+v8KI47+mIw1ZBsritBo/mcBURxKZPWShOBM6kcoQTNdF6C7zzFIGHKs?=
 =?us-ascii?Q?jUjuL4hpoc2rFKSnA6kghsACtyWzuM9+VOCjJJVNTQpPQJk83wmmCzztX6o7?=
 =?us-ascii?Q?dLFoynbY0lGDzpiJMIe7/r3+H8bWzZIoDLJI+OsTYOhgGN6XIkMi2+8sWobh?=
 =?us-ascii?Q?kfJhcCQJTFoJIubhPSqBVhaG/3HmSd7Bs5lisadX3AOsYuYoNLbb0MU4lnfc?=
 =?us-ascii?Q?G3g27maxuzMGPBE8Oanx7gRLKquMOantJ5ewqWgN5VV4OP/BG//9WLG9BqPk?=
 =?us-ascii?Q?ofWmbH+WeWQMrEZJqL8vY8E0j5DA+JLrmTs4yjQBtlVuesS9zLPwieFEcWIR?=
 =?us-ascii?Q?wFLTWewPaVizEzhnIHzQPCd2DN4ydpDpBeorpD04h3jG15HKj3B0uT4u9KNn?=
 =?us-ascii?Q?44p48wSqWJaSmY0NDoOuG1WJHgKn5ESjJXzTIUeDwPT3MNd9fFoHhrMMq3z1?=
 =?us-ascii?Q?evW8uILvCoQ38v6v1IIzViF53Mgz61u7inI46mlna0mHN7WSbvpukqPfnu79?=
 =?us-ascii?Q?Ji0k8U9UDhdu0ItONsL78pVa0j64V9PznVrTeLnT6K44kx9v9kPDBY4yBNIM?=
 =?us-ascii?Q?waA18xtoTr1p9+QQP2M3tSL+PWWVWpt4PMbv92ICRuUHVP3Zi6ys7Xx0QtRd?=
 =?us-ascii?Q?Y6ym8IxiPiK7Yhs+Mt4oA+Y7g/Cp7KQ28Z4pFqBoD2M49uaRa/1a30pKN+J9?=
 =?us-ascii?Q?m1ZwrTYdMGeO4e/xJbjuOz/GxvAZgCxfm4E9HOwQ6G1iYdKimIKcTAK94Z85?=
 =?us-ascii?Q?0yx0MVUQ1AGsJzGDEJHRqMUa8/7ViuoGAkcevF6u9mjLM1DFKnTlmFqW4SxK?=
 =?us-ascii?Q?5BA0EJDqhqI0kTUIjx4OXiqtbZaXmY+mNpzpOLfDM6HfUV6EtqTh6vq5y7gY?=
 =?us-ascii?Q?iA8X2ZBboZi0T9mNZNFEfEooTZxeFcHCXGHpCRD3cIbOG8YWyBRjjHq2IFZY?=
 =?us-ascii?Q?PRL8iBzRpQlDtQMZvF2T5taQPevXLGgTawnYq/jZk0kF25Hl9VwuVE4fSIGn?=
 =?us-ascii?Q?+s1lq+pvphQTUlph8dU1423PD/QVBRLftKPrDLbI4pVBEAGHA9xY/zRuLSMt?=
 =?us-ascii?Q?stx1OKxduJpr0yr7TkPfFeJ7ZxLVUeeg82C5KjJAZeKGkp7vwId0k8q7+cdS?=
 =?us-ascii?Q?REMYUDop1i8h2q9Mp+zNvq4yFWN2O3Cmk27UjJmX4KRIdA3wvr1BYXv3M3KX?=
 =?us-ascii?Q?Jr9bG3x4+qidfrAtZ8XQCuWVXRscugIZ3yDLMi4+X7qU7WHZIaxH+jF2BHp7?=
 =?us-ascii?Q?6uv2N4N2SIQyblxdR4fVsnrgFNIvAG8fZ5eR/1GTeoRQE7+N+pgLGpHh1O1f?=
 =?us-ascii?Q?BVReU+DSyoJWdochkX5b+NLAiD/S0fMJS44EPk2YRVTeukRxYz8DqNDcIILO?=
 =?us-ascii?Q?wb5WmDOOYofqIjd0zjCGK/DpO/aXisJi3nyua6M1+WyqwlhqVCde4qgBUsTN?=
 =?us-ascii?Q?E7YXD8jwJim/CFzPDDCoBDbLJmYaQwiktw6r9LWiSLqWWFJZ8KywCzoIx7x+?=
 =?us-ascii?Q?WRNGU24HIEhDLKFrWKvgkZFuDZJOKiV5bLMahBtrI37YfAZ1KRZnL8yIZRXd?=
 =?us-ascii?Q?KpEX2H/c8kOkRd7eKkKEio7hkyIq4YhHzHa8fUlLw1YVFCPr/NoSalKjhee+?=
 =?us-ascii?Q?HA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30328d7c-5f2f-42ee-667f-08db2f37b2d4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4839.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 02:54:07.7192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Qd31OBnUEeHmx7vt+L/qHgB2kag7GIXHB3ZAIN/7oo6feEHXY+ErcDOujy0fymUNzabGwrU8kqHUz8iIW4lMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4627
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--aPi2dJHnmmmy17mS
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

Hi Jens Axboe,

On 2023-03-27 at 20:08:25 -0600, Jens Axboe wrote:
> Unless we have at least one entry queued, then don't call into
> io_poll_remove_entries(). Normally this isn't possible, but if we
> retry poll then we can have ->nr_entries cleared again as we're
> setting it up. If this happens for a poll retry, then we'll still have
> at least REQ_F_SINGLE_POLL set. io_poll_remove_entries() then thinks
> it has entries to remove.
> 
> Clear REQ_F_SINGLE_POLL and REQ_F_DOUBLE_POLL unconditionally when
> arming a poll request.
> 
> Fixes: c16bda37594f ("io_uring/poll: allow some retries for poll triggering spuriously")
> Cc: stable@vger.kernel.org
> Reported-by: Pengfei Xu <pengfei.xu@intel.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 795facbd0e9f..55306e801081 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -726,6 +726,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
>  	apoll = io_req_alloc_apoll(req, issue_flags);
>  	if (!apoll)
>  		return IO_APOLL_ABORTED;
> +	req->flags &= ~(REQ_F_SINGLE_POLL | REQ_F_DOUBLE_POLL);
>  	req->flags |= REQ_F_POLLED;
>  	ipt.pt._qproc = io_async_queue_proc;
>  
  Thanks for your patch!
  I have tested the above patch on top of v6.3-rc4 kernel.
  This issue was fixed.
  Reproduced code from syzkaller: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/repro.c
  One more info, bisect methodology comes from myself, not from syzkaller.

  Thanks!
  BR.
  -Pengfei(Intel)

> -- 
> Jens Axboe
> 

--aPi2dJHnmmmy17mS
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="v63rc4_fix.log"

[    0.000000] Linux version 6.3.0-rc4-fix-dirty (root@xpf.sh.intel.com) (gcc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-18), GNU ld version 2.36.1-2.el8) #4 SMP PREEMPT_DYNAMIC Tue Mar 28 10:36:27 CST 2023
[    0.000000] Command line: console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0 thunderbolt.dyndbg
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Hygon HygonGenuine
[    0.000000]   Centaur CentaurHauls
[    0.000000]   zhaoxin   Shanghai  
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x200: 'Protection Keys User registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[9]:  832, xstate_sizes[9]:    8
[    0.000000] x86/fpu: Enabled xstate features 0x207, context size is 840 bytes, using 'compacted' format.
[    0.000000] signal: max sigframe size: 3632
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000007fffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000800000-0x0000000000807fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000808000-0x000000000080ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000810000-0x00000000008fffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000900000-0x000000007e80bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007e80c000-0x000000007e80dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007e80e000-0x000000007e8b5fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007e8b6000-0x000000007e8c3fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007e8c4000-0x000000007e8ddfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007e8de000-0x000000007e9edfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007e9ee000-0x000000007eb1afff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007eb1b000-0x000000007fb9afff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fb9b000-0x000000007fbf2fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007fbf3000-0x000000007fbfafff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007fbfb000-0x000000007fbfefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007fbff000-0x000000007ff4ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ff50000-0x000000007ff6ffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007ff70000-0x000000007fffffff] ACPI NVS
[    0.000000] printk: bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x7e802018-0x7e80ba57] usable ==> usable
[    0.000000] e820: update [mem 0x7e802018-0x7e80ba57] usable ==> usable
[    0.000000] e820: update [mem 0x7e7db018-0x7e801e57] usable ==> usable
[    0.000000] e820: update [mem 0x7e7db018-0x7e801e57] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000007fffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000800000-0x0000000000807fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x0000000000808000-0x000000000080ffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000810000-0x00000000008fffff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x0000000000900000-0x000000007e7db017] usable
[    0.000000] reserve setup_data: [mem 0x000000007e7db018-0x000000007e801e57] usable
[    0.000000] reserve setup_data: [mem 0x000000007e801e58-0x000000007e802017] usable
[    0.000000] reserve setup_data: [mem 0x000000007e802018-0x000000007e80ba57] usable
[    0.000000] reserve setup_data: [mem 0x000000007e80ba58-0x000000007e80bfff] usable
[    0.000000] reserve setup_data: [mem 0x000000007e80c000-0x000000007e80dfff] ACPI data
[    0.000000] reserve setup_data: [mem 0x000000007e80e000-0x000000007e8b5fff] usable
[    0.000000] reserve setup_data: [mem 0x000000007e8b6000-0x000000007e8c3fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000007e8c4000-0x000000007e8ddfff] reserved
[    0.000000] reserve setup_data: [mem 0x000000007e8de000-0x000000007e9edfff] usable
[    0.000000] reserve setup_data: [mem 0x000000007e9ee000-0x000000007eb1afff] reserved
[    0.000000] reserve setup_data: [mem 0x000000007eb1b000-0x000000007fb9afff] usable
[    0.000000] reserve setup_data: [mem 0x000000007fb9b000-0x000000007fbf2fff] reserved
[    0.000000] reserve setup_data: [mem 0x000000007fbf3000-0x000000007fbfafff] ACPI data
[    0.000000] reserve setup_data: [mem 0x000000007fbfb000-0x000000007fbfefff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000007fbff000-0x000000007ff4ffff] usable
[    0.000000] reserve setup_data: [mem 0x000000007ff50000-0x000000007ff6ffff] reserved
[    0.000000] reserve setup_data: [mem 0x000000007ff70000-0x000000007fffffff] ACPI NVS
[    0.000000] efi: EFI v2.7 by EDK II
[    0.000000] efi: SMBIOS=0x7fbcc000 ACPI=0x7fbfa000 ACPI 2.0=0x7fbfa014 MEMATTR=0x7efb2698 
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
[    0.000000] Hypervisor detected: KVM
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000002] kvm-clock: using sched offset of 3111447768 cycles
[    0.000663] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.002733] tsc: Detected 806.400 MHz processor
[    0.003491] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.003507] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.003536] last_pfn = 0x7ff50 max_arch_pfn = 0x400000000
[    0.004000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.004000] Using GB pages for direct mapping
[    0.004000] Secure boot disabled
[    0.004000] ACPI: Early table checksum verification disabled
[    0.004000] ACPI: RSDP 0x000000007FBFA014 000024 (v02 BOCHS )
[    0.004000] ACPI: XSDT 0x000000007FBF90E8 00004C (v01 BOCHS  BXPC     00000001      01000013)
[    0.004000] ACPI: FACP 0x000000007FBF6000 000074 (v01 BOCHS  BXPC     00000001 BXPC 00000001)
[    0.004000] ACPI: DSDT 0x000000007FBF7000 0017BD (v01 BOCHS  BXPC     00000001 BXPC 00000001)
[    0.004000] ACPI: FACS 0x000000007FBFD000 000040
[    0.004000] ACPI: APIC 0x000000007FBF5000 000080 (v01 BOCHS  BXPC     00000001 BXPC 00000001)
[    0.004000] ACPI: HPET 0x000000007FBF4000 000038 (v01 BOCHS  BXPC     00000001 BXPC 00000001)
[    0.004000] ACPI: WAET 0x000000007FBF3000 000028 (v01 BOCHS  BXPC     00000001 BXPC 00000001)
[    0.004000] ACPI: BGRT 0x000000007E80D000 000038 (v01 INTEL  EDK2     00000002      01000013)
[    0.004000] ACPI: Reserving FACP table memory at [mem 0x7fbf6000-0x7fbf6073]
[    0.004000] ACPI: Reserving DSDT table memory at [mem 0x7fbf7000-0x7fbf87bc]
[    0.004000] ACPI: Reserving FACS table memory at [mem 0x7fbfd000-0x7fbfd03f]
[    0.004000] ACPI: Reserving APIC table memory at [mem 0x7fbf5000-0x7fbf507f]
[    0.004000] ACPI: Reserving HPET table memory at [mem 0x7fbf4000-0x7fbf4037]
[    0.004000] ACPI: Reserving WAET table memory at [mem 0x7fbf3000-0x7fbf3027]
[    0.004000] ACPI: Reserving BGRT table memory at [mem 0x7e80d000-0x7e80d037]
[    0.004000] No NUMA configuration found
[    0.004000] Faking a node at [mem 0x0000000000000000-0x000000007ff4ffff]
[    0.004000] NODE_DATA(0) allocated [mem 0x7febf000-0x7fee9fff]
[    0.004000] Zone ranges:
[    0.004000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.004000]   DMA32    [mem 0x0000000001000000-0x000000007ff4ffff]
[    0.004000]   Normal   empty
[    0.004000]   Device   empty
[    0.004000] Movable zone start for each node
[    0.004000] Early memory node ranges
[    0.004000]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.004000]   node   0: [mem 0x0000000000100000-0x00000000007fffff]
[    0.004000]   node   0: [mem 0x0000000000808000-0x000000000080ffff]
[    0.004000]   node   0: [mem 0x0000000000900000-0x000000007e80bfff]
[    0.004000]   node   0: [mem 0x000000007e80e000-0x000000007e8b5fff]
[    0.004000]   node   0: [mem 0x000000007e8de000-0x000000007e9edfff]
[    0.004000]   node   0: [mem 0x000000007eb1b000-0x000000007fb9afff]
[    0.004000]   node   0: [mem 0x000000007fbff000-0x000000007ff4ffff]
[    0.004000] Initmem setup node 0 [mem 0x0000000000001000-0x000000007ff4ffff]
[    0.004000] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.004000] On node 0, zone DMA: 96 pages in unavailable ranges
[    0.004000] On node 0, zone DMA: 8 pages in unavailable ranges
[    0.004000] On node 0, zone DMA: 240 pages in unavailable ranges
[    0.004000] On node 0, zone DMA32: 2 pages in unavailable ranges
[    0.004000] On node 0, zone DMA32: 40 pages in unavailable ranges
[    0.004000] On node 0, zone DMA32: 301 pages in unavailable ranges
[    0.004000] On node 0, zone DMA32: 100 pages in unavailable ranges
[    0.004000] On node 0, zone DMA32: 176 pages in unavailable ranges
[    0.004000] ACPI: PM-Timer IO Port: 0xb008
[    0.004000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.004000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.004000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.004000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.004000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.004000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.004000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.004000] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.004000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.004000] e820: update [mem 0x7ee61000-0x7ee69fff] usable ==> reserved
[    0.004000] TSC deadline timer available
[    0.004000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.004000] kvm-guest: KVM setup pv remote TLB flush
[    0.004000] kvm-guest: setup PV sched yield
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x00800000-0x00807fff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x00810000-0x008fffff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x7e7db000-0x7e7dbfff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x7e801000-0x7e801fff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x7e802000-0x7e802fff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x7e80b000-0x7e80bfff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x7e80c000-0x7e80dfff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x7e8b6000-0x7e8c3fff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x7e8c4000-0x7e8ddfff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x7e9ee000-0x7eb1afff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x7ee61000-0x7ee69fff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x7fb9b000-0x7fbf2fff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x7fbf3000-0x7fbfafff]
[    0.004000] PM: hibernation: Registered nosave memory: [mem 0x7fbfb000-0x7fbfefff]
[    0.004000] [mem 0x80000000-0xffffffff] available for PCI devices
[    0.004000] Booting paravirtualized kernel on KVM
[    0.004000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.004000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.004000] percpu: Embedded 65 pages/cpu s229376 r8192 d28672 u1048576
[    0.004000] pcpu-alloc: s229376 r8192 d28672 u1048576 alloc=1*2097152
[    0.004000] pcpu-alloc: [0] 0 1 
[    0.004000] kvm-guest: PV spinlocks enabled
[    0.004000] PV qspinlock hash table entries: 256 (order: 0, 4096 bytes, linear)
[    0.004000] Fallback order for Node 0: 0 
[    0.004000] Built 1 zonelists, mobility grouping on.  Total pages: 513188
[    0.004000] Policy zone: DMA32
[    0.004000] Kernel command line: net.ifnames=0 console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0 thunderbolt.dyndbg
[    0.004000] random: crng init done
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.004000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    0.004000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.004000] Memory: 1935300K/2093296K available (34816K kernel code, 4578K rwdata, 9804K rodata, 10400K init, 31852K bss, 157740K reserved, 0K cma-reserved)
[    0.004000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] kmemleak: Kernel memory leak detector disabled
[    0.004000] ftrace: allocating 68797 entries in 269 pages
[    0.004000] ftrace: allocated 269 pages with 4 groups
[    0.004000] Dynamic Preempt: voluntary
[    0.004000] Running RCU self tests
[    0.004000] Running RCU synchronous self tests
[    0.004000] rcu: Preemptible hierarchical RCU implementation.
[    0.004000] rcu:     RCU lockdep checking is enabled.
[    0.004000] rcu:     RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=2.
[    0.004000]  Trampoline variant of Tasks RCU enabled.
[    0.004000]  Rude variant of Tasks RCU enabled.
[    0.004000]  Tracing variant of Tasks RCU enabled.
[    0.004000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.004000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.004000] Running RCU synchronous self tests
[    0.004000] NR_IRQS: 524544, nr_irqs: 440, preallocated irqs: 16
[    0.004000] rcu: srcu_init: Setting srcu_struct sizes based on contention.
[    0.004000] Console: colour dummy device 80x25
[    0.004000] printk: console [ttyS0] enabled
[    0.004000] printk: bootconsole [earlyser0] disabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        8192
[    0.004000] ... CLASSHASH_SIZE:          4096
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.004000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.004000] ... CHAINHASH_SIZE:          32768
[    0.004000]  memory used by lock dependency info: 6365 kB
[    0.004000]  memory used for stack traces: 4224 kB
[    0.004000]  per task-struct memory footprint: 1920 bytes
[    0.004000] ACPI: Core revision 20221020
[    0.004000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604467 ns
[    0.004000] APIC: Switch to symmetric I/O mode setup
[    0.004000] x2apic enabled
[    0.004000] Switched APIC routing to physical x2apic.
[    0.004000] kvm-guest: setup PV IPIs
[    0.004000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.004000] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0xb9fb05486c, max_idle_ns: 440795231721 ns
[    0.171114] Calibrating delay loop (skipped) preset value.. 1612.80 BogoMIPS (lpj=3225600)
[    0.172157] pid_max: default: 32768 minimum: 301
[    0.178426] LSM: initializing lsm=capability,yama,integrity
[    0.179107] Yama: becoming mindful.
[    0.179666] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes, linear)
[    0.180604] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes, linear)
[    0.182521] CPU0: Thermal monitoring enabled (TM1)
[    0.183121] x86/cpu: User Mode Instruction Prevention (UMIP) activated
[    0.184125] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.184806] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.185573] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
[    0.186645] Spectre V2 : WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!
[    0.187110] Spectre V2 : Mitigation: Enhanced / Automatic IBRS
[    0.187836] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[    0.188854] Spectre V2 : Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT
[    0.189779] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    0.191106] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
[    0.192157] MMIO Stale Data: Unknown: No mitigations
[    0.273896] Freeing SMP alternatives memory: 56K
[    0.274492] Running RCU synchronous self tests
[    0.275041] Running RCU synchronous self tests
[    0.275275] smpboot: CPU0: Genuine Intel(R) 0000 (family: 0x6, model: 0xb7, stepping: 0x0)
[    0.276525] cblist_init_generic: Setting adjustable number of callback queues.
[    0.277410] cblist_init_generic: Setting shift to 1 and lim to 1.
[    0.278180] cblist_init_generic: Setting shift to 1 and lim to 1.
[    0.278973] cblist_init_generic: Setting shift to 1 and lim to 1.
[    0.279137] Running RCU-tasks wait API self tests
[    0.383215] Performance Events: Alderlake Hybrid events, full-width counters, Intel PMU driver.
[    0.384734] core: cpu_core PMU driver: 
[    0.385221] ... version:                2
[    0.385721] ... bit width:              48
[    0.386229] ... generic registers:      6
[    0.386727] ... value mask:             0000ffffffffffff
[    0.387110] ... max period:             00007fffffffffff
[    0.387769] ... fixed-purpose events:   3
[    0.388266] ... event mask:             0001000f0000003f
[    0.389079] rcu: Hierarchical SRCU implementation.
[    0.389681] rcu:     Max phase no-delay instances is 1000.
[    0.392137] Callback from call_rcu_tasks_trace() invoked.
[    0.392871] unchecked MSR access error: WRMSR to 0x38f (tried to write 0x0001000f0000003f) at rIP: 0xffffffff810dcc2c (native_write_msr+0xc/0x30)
[    0.394478] Call Trace:
[    0.394794]  <TASK>
[    0.395068]  __intel_pmu_enable_all.constprop.49+0xb5/0x140
[    0.395103]  intel_pmu_enable_all+0x1e/0x30
[    0.395103]  x86_pmu_enable+0x46d/0x5a0
[    0.395103]  ? write_comp_data+0x2f/0x90
[    0.395103]  perf_pmu_enable+0x53/0x70
[    0.395103]  ctx_resched+0x14d/0x1e0
[    0.395103]  __perf_install_in_context+0x2f7/0x470
[    0.395103]  ? __pfx_remote_function+0x10/0x10
[    0.395103]  ? __pfx_remote_function+0x10/0x10
[    0.395103]  remote_function+0x80/0xa0
[    0.395103]  ? __pfx_remote_function+0x10/0x10
[    0.395103]  generic_exec_single+0x124/0x190
[    0.395103]  smp_call_function_single+0x11c/0x240
[    0.395103]  ? __pfx_remote_function+0x10/0x10
[    0.395103]  ? __sanitizer_cov_trace_pc+0x25/0x60
[    0.395103]  ? write_comp_data+0x2f/0x90
[    0.395103]  perf_install_in_context+0x2d8/0x300
[    0.395103]  ? __pfx___perf_install_in_context+0x10/0x10
[    0.395103]  perf_event_create_kernel_counter+0x284/0x2b0
[    0.395103]  ? __pfx_watchdog_overflow_callback+0x10/0x10
[    0.395103]  hardlockup_detector_event_create+0x46/0xd0
[    0.395103]  hardlockup_detector_perf_init+0x18/0x80
[    0.395103]  watchdog_nmi_probe+0x17/0x20
[    0.395103]  lockup_detector_init+0x40/0xb0
[    0.395103]  kernel_init_freeable+0x37e/0x760
[    0.395103]  ? __pfx_kernel_init+0x10/0x10
[    0.395103]  kernel_init+0x24/0x1e0
[    0.395103]  ? __pfx_kernel_init+0x10/0x10
[    0.395103]  ret_from_fork+0x29/0x50
[    0.395103]  </TASK>
[    0.395221] smp: Bringing up secondary CPUs ...
[    0.396081] x86: Booting SMP configuration:
[    0.396618] .... node  #0, CPUs:      #1
[    0.397307] smp: Brought up 1 node, 2 CPUs
[    0.397307] smpboot: Max logical packages: 1
[    0.399117] smpboot: Total of 2 processors activated (3225.60 BogoMIPS)
[    0.400184] devtmpfs: initialized
[    0.400184] x86/mm: Memory block size: 128MB
[    0.403317] ACPI: PM: Registering ACPI NVS region [mem 0x00800000-0x00807fff] (32768 bytes)
[    0.404289] ACPI: PM: Registering ACPI NVS region [mem 0x00810000-0x008fffff] (983040 bytes)
[    0.405374] ACPI: PM: Registering ACPI NVS region [mem 0x7e8b6000-0x7e8c3fff] (57344 bytes)
[    0.406418] ACPI: PM: Registering ACPI NVS region [mem 0x7fbfb000-0x7fbfefff] (16384 bytes)
[    0.407120] ACPI: PM: Registering ACPI NVS region [mem 0x7ff70000-0x7fffffff] (589824 bytes)
[    0.408322] Running RCU synchronous self tests
[    0.408878] Running RCU synchronous self tests
[    0.409459] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.410656] futex hash table entries: 512 (order: 4, 65536 bytes, linear)
[    0.411251] pinctrl core: initialized pinctrl subsystem

[    0.412464] *************************************************************
[    0.413294] **     NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE    **
[    0.414128] **                                                         **
[    0.414952] **  IOMMU DebugFS SUPPORT HAS BEEN ENABLED IN THIS KERNEL  **
[    0.415109] **                                                         **
[    0.415934] ** This means that this kernel is built to expose internal **
[    0.416771] ** IOMMU data structures, which may compromise security on **
[    0.417612] ** your system.                                            **
[    0.418452] **                                                         **
[    0.419108] ** If you see this message and you are not debugging the   **
[    0.419946] ** kernel, report this immediately to your vendor!         **
[    0.420786] **                                                         **
[    0.421624] **     NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE    **
[    0.422461] *************************************************************
[    0.423192] PM: RTC time: 02:28:26, date: 2023-03-28
[    0.425213] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.426407] DMA: preallocated 256 KiB GFP_KERNEL pool for atomic allocations
[    0.427117] DMA: preallocated 256 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[    0.428077] DMA: preallocated 256 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.429086] audit: initializing netlink subsys (disabled)
[    0.429802] audit: type=2000 audit(1679970507.091:1): state=initialized audit_enabled=0 res=1
[    0.429802] thermal_sys: Registered thermal governor 'fair_share'
[    0.429802] thermal_sys: Registered thermal governor 'bang_bang'
[    0.431110] thermal_sys: Registered thermal governor 'step_wise'
[    0.431859] thermal_sys: Registered thermal governor 'user_space'
[    0.432632] cpuidle: using governor ladder
[    0.433911] cpuidle: using governor menu
[    0.434635] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.435338] PCI: Using configuration type 1 for base access
[    0.436763] kprobes: kprobe jump-optimization is enabled. All kprobes are optimized if possible.
[    0.622877] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
[    0.623111] HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
[    0.623922] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
[    0.624743] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
[    0.626742] ACPI: Added _OSI(Module Device)
[    0.627111] ACPI: Added _OSI(Processor Device)
[    0.627659] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.628237] ACPI: Added _OSI(Processor Aggregator Device)
[    0.632506] ACPI: 1 ACPI AML tables successfully acquired and loaded
[    2.616574] Callback from call_rcu_tasks_rude() invoked.
[    2.657518] ACPI: Interpreter enabled
[    2.657518] ACPI: PM: (supports S0 S3 S4 S5)
[    2.657518] ACPI: Using IOAPIC for interrupt routing
[    2.657709] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.659112] PCI: Using E820 reservations for host bridge windows
[    2.660318] ACPI: Enabled 2 GPEs in block 00 to 0F
[    2.672076] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.672849] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI EDR HPX-Type3]
[    2.673831] acpi PNP0A03:00: _OSC: not requesting OS control; OS requires [ExtendedConfig ASPM ClockPM MSI]
[    2.675041] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended configuration space under this bridge
[    2.676724] acpiphp: Slot [3] registered
[    2.677264] acpiphp: Slot [4] registered
[    2.677796] acpiphp: Slot [5] registered
[    2.678327] acpiphp: Slot [6] registered
[    2.678855] acpiphp: Slot [7] registered
[    2.679156] acpiphp: Slot [8] registered
[    2.679686] acpiphp: Slot [9] registered
[    2.680220] acpiphp: Slot [10] registered
[    2.680761] acpiphp: Slot [11] registered
[    2.681302] acpiphp: Slot [12] registered
[    2.681842] acpiphp: Slot [13] registered
[    2.682382] acpiphp: Slot [14] registered
[    2.682920] acpiphp: Slot [15] registered
[    2.683160] acpiphp: Slot [16] registered
[    2.683699] acpiphp: Slot [17] registered
[    2.684242] acpiphp: Slot [18] registered
[    2.684782] acpiphp: Slot [19] registered
[    2.685322] acpiphp: Slot [20] registered
[    2.685861] acpiphp: Slot [21] registered
[    2.686399] acpiphp: Slot [22] registered
[    2.686937] acpiphp: Slot [23] registered
[    2.687160] acpiphp: Slot [24] registered
[    2.687704] acpiphp: Slot [25] registered
[    2.688242] acpiphp: Slot [26] registered
[    2.688780] acpiphp: Slot [27] registered
[    2.689320] acpiphp: Slot [28] registered
[    2.689857] acpiphp: Slot [29] registered
[    2.690399] acpiphp: Slot [30] registered
[    2.690939] acpiphp: Slot [31] registered
[    2.695126] PCI host bridge to bus 0000:00
[    2.695630] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    2.696453] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    2.697277] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    2.698184] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff window]
[    2.699093] pci_bus 0000:00: root bus resource [mem 0x100000000-0x17fffffff window]
[    2.700028] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.700785] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    2.700785] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    2.701303] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    2.703103] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    2.703103] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    2.703103] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    2.703103] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    2.703103] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    2.711362] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    2.712592] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    2.713478] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    2.714649] pci 0000:00:02.0: [1234:1111] type 00 class 0x030000
[    2.715852] pci 0000:00:02.0: reg 0x10: [mem 0x80000000-0x80ffffff pref]
[    2.717778] pci 0000:00:02.0: reg 0x18: [mem 0x81020000-0x81020fff]
[    2.720898] pci 0000:00:02.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
[    2.721812] pci 0000:00:02.0: BAR 0: assigned to efifb
[    2.722483] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    2.725360] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    2.726524] pci 0000:00:03.0: reg 0x10: [mem 0x81000000-0x8101ffff]
[    2.727400] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    2.729727] pci 0000:00:03.0: reg 0x30: [mem 0xfffc0000-0xffffffff pref]
[    2.753459] ACPI: PCI: Interrupt link LNKA configured for IRQ 11
[    2.754493] ACPI: PCI: Interrupt link LNKB configured for IRQ 11
[    2.755382] ACPI: PCI: Interrupt link LNKC configured for IRQ 10
[    2.756395] ACPI: PCI: Interrupt link LNKD configured for IRQ 10
[    2.757282] ACPI: PCI: Interrupt link LNKS configured for IRQ 9
[    2.759176] iommu: Default domain type: Translated 
[    2.759696] iommu: DMA domain TLB invalidation policy: lazy mode 
[    2.761294] SCSI subsystem initialized
[    2.763186] Callback from call_rcu_tasks() invoked.
[    2.763248] libata version 3.00 loaded.
[    2.763930] ACPI: bus type USB registered
[    2.764450] usbcore: registered new interface driver usbfs
[    2.765110] usbcore: registered new interface driver hub
[    2.765747] usbcore: registered new device driver usb
[    2.766422] pps_core: LinuxPPS API ver. 1 registered
[    2.766996] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.767123] PTP clock support registered
[    2.767673] EDAC MC: Ver: 3.0.0
[    2.767722] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    2.767791] efivars: Registered efivars operations
[    2.768067] NetLabel: Initializing
[    2.768511] NetLabel:  domain hash size = 128
[    2.771112] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    2.771844] NetLabel:  unlabeled traffic allowed by default
[    2.772615] PCI: Using ACPI for IRQ routing
[    2.772615] PCI: pci_cache_line_size set to 64 bytes
[    2.772615] e820: reserve RAM buffer [mem 0x00810000-0x008fffff]
[    2.772615] e820: reserve RAM buffer [mem 0x7e7db018-0x7fffffff]
[    2.772615] e820: reserve RAM buffer [mem 0x7e802018-0x7fffffff]
[    2.772615] e820: reserve RAM buffer [mem 0x7e80c000-0x7fffffff]
[    2.772615] e820: reserve RAM buffer [mem 0x7e8b6000-0x7fffffff]
[    2.772615] e820: reserve RAM buffer [mem 0x7e9ee000-0x7fffffff]
[    2.772615] e820: reserve RAM buffer [mem 0x7ee61000-0x7fffffff]
[    2.772615] e820: reserve RAM buffer [mem 0x7fb9b000-0x7fffffff]
[    2.772615] e820: reserve RAM buffer [mem 0x7ff50000-0x7fffffff]
[    2.772615] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    2.772615] pci 0000:00:02.0: vgaarb: bridge control possible
[    2.772627] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    2.775112] vgaarb: loaded
[    2.775512] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.775995] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    2.781360] clocksource: Switched to clocksource kvm-clock
[    2.844415] VFS: Disk quotas dquot_6.6.0
[    2.844923] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.845925] pnp: PnP ACPI init
[    2.846575] pnp 00:02: [dma 2]
[    2.847602] pnp: PnP ACPI: found 6 devices
[    2.858885] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    2.860232] NET: Registered PF_INET protocol family
[    2.861081] IP idents hash table entries: 32768 (order: 6, 262144 bytes, linear)
[    2.862729] tcp_listen_portaddr_hash hash table entries: 1024 (order: 4, 73728 bytes, linear)
[    2.863813] Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    2.864764] TCP established hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    2.865867] TCP bind hash table entries: 16384 (order: 9, 2359296 bytes, linear)
[    2.867423] TCP: Hash tables configured (established 16384 bind 16384)
[    2.868291] UDP hash table entries: 1024 (order: 5, 163840 bytes, linear)
[    2.869158] UDP-Lite hash table entries: 1024 (order: 5, 163840 bytes, linear)
[    2.870126] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    2.871154] RPC: Registered named UNIX socket transport module.
[    2.871899] RPC: Registered udp transport module.
[    2.872485] RPC: Registered tcp transport module.
[    2.873071] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.873873] pci 0000:00:03.0: can't claim BAR 6 [mem 0xfffc0000-0xffffffff pref]: no compatible bridge window
[    2.875097] pci 0000:00:03.0: BAR 6: assigned [mem 0x81040000-0x8107ffff pref]
[    2.876004] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    2.876769] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    2.877543] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    2.878390] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff window]
[    2.879247] pci_bus 0000:00: resource 8 [mem 0x100000000-0x17fffffff window]
[    2.880279] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.881001] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.881840] PCI: CLS 0 bytes, default 64
[    2.882361] ACPI: bus type thunderbolt registered
[    2.883189] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0xb9fb05486c, max_idle_ns: 440795231721 ns
[    2.886245] Initialise system trusted keyrings
[    2.886852] Key type blacklist registered
[    2.887466] workingset: timestamp_bits=36 max_order=19 bucket_order=0
[    2.888292] zbud: loaded
[    2.889109] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.890399] NFS: Registering the id_resolver key type
[    2.891040] Key type id_resolver registered
[    2.891582] Key type id_legacy registered
[    2.892099] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    2.892942] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
[    2.893973] fuse: init (API version 7.38)
[    2.894632] SGI XFS with ACLs, security attributes, realtime, quota, no debug enabled
[    2.895926] 9p: Installing v9fs 9p2000 file system support
[    2.901611] Key type asymmetric registered
[    2.902148] Asymmetric key parser 'x509' registered
[    2.902782] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 243)
[    2.903793] io scheduler mq-deadline registered
[    2.904374] io scheduler bfq registered
[    2.905147] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.906257] IPMI message handler: version 39.2
[    2.906850] ipmi device interface
[    2.908394] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.909452] ACPI: button: Power Button [PWRF]
[    2.910633] ERST DBG: ERST support is disabled.
[    2.911591] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    2.912450] serial 00:04: using ACPI '\_SB.PCI0.ISA.COM1' for 'rs485-term' GPIO lookup
[    2.912471] acpi PNP0501:00: GPIO: looking up rs485-term-gpios
[    2.912480] acpi PNP0501:00: GPIO: looking up rs485-term-gpio
[    2.912487] serial 00:04: using lookup tables for GPIO lookup
[    2.912501] serial 00:04: No GPIO consumer rs485-term found
[    2.912509] serial 00:04: using ACPI '\_SB.PCI0.ISA.COM1' for 'rs485-rx-during-tx' GPIO lookup
[    2.912524] acpi PNP0501:00: GPIO: looking up rs485-rx-during-tx-gpios
[    2.912533] acpi PNP0501:00: GPIO: looking up rs485-rx-during-tx-gpio
[    2.912541] serial 00:04: using lookup tables for GPIO lookup
[    2.912547] serial 00:04: No GPIO consumer rs485-rx-during-tx found
[    2.913001] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.919924] Linux agpgart interface v0.103
[    2.920971] ACPI: bus type drm_connector registered
[    2.930075] brd: module loaded
[    2.935430] loop: module loaded
[    2.937141] ata_piix 0000:00:01.1: version 2.13
[    2.938202] scsi host0: ata_piix
[    2.938916] scsi host1: ata_piix
[    2.939448] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc040 irq 14
[    2.940286] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc048 irq 15
[    2.941828] mdio_bus fixed-0: using lookup tables for GPIO lookup
[    2.941836] mdio_bus fixed-0: No GPIO consumer reset found
[    2.942091] tun: Universal TUN/TAP device driver, 1.6
[    2.942854] e100: Intel(R) PRO/100 Network Driver
[    2.943463] e100: Copyright(c) 1999-2006 Intel Corporation
[    2.944166] e1000: Intel(R) PRO/1000 Network Driver
[    2.944771] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    3.051856] ACPI: \_SB_.LNKC: Enabled at IRQ 10
[    3.099316] ata2: found unknown device (class 0)
[    3.100586] ata1: found unknown device (class 0)
[    3.101898] ata2.00: ATAPI: QEMU DVD-ROM, 2.5+, max UDMA/100
[    3.103098] ata1.00: ATA-7: QEMU HARDDISK, 2.5+, max UDMA/100
[    3.103820] ata1.00: 16777216 sectors, multi 16: LBA48 
[    3.105644] scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    2.5+ PQ: 0 ANSI: 5
[    3.107263] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    3.108362] sd 0:0:0:0: [sda] 16777216 512-byte logical blocks: (8.59 GB/8.00 GiB)
[    3.109321] sd 0:0:0:0: [sda] Write Protect is off
[    3.109921] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.109948] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.111223] sd 0:0:0:0: [sda] Preferred minimum I/O size 512 bytes
[    3.112907] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.5+ PQ: 0 ANSI: 5
[    3.132012] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    3.133760] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.395789] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    3.396640] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    3.397532] e1000e: Intel(R) PRO/1000 Network Driver
[    3.398140] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    3.398902] igb: Intel(R) Gigabit Ethernet Network Driver
[    3.399595] igb: Copyright (c) 2007-2014 Intel Corporation.
[    3.400335] PPP generic driver version 2.4.2
[    3.401308] VFIO - User Level meta-driver version: 0.3
[    3.402473] usbcore: registered new interface driver uas
[    3.403176] usbcore: registered new interface driver usb-storage
[    3.404004] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.405796] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.406430] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.407566] mousedev: PS/2 mouse device common for all mice
[    3.409072] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    3.410712] rtc_cmos 00:05: RTC can wake from S4
[    3.411984] input: VirtualPS/2 VMware VMMouse as /devices/platform/i8042/serio1/input/input4
[    3.413658] input: VirtualPS/2 VMware VMMouse as /devices/platform/i8042/serio1/input/input3
[    3.415043] rtc_cmos 00:05: registered as rtc0
[    3.415730] rtc_cmos 00:05: setting system clock to 2023-03-28T02:28:29 UTC (1679970509)
[    3.416720] rtc_cmos 00:05: using ACPI '\_SB.PCI0.ISA.RTC' for 'wp' GPIO lookup
[    3.416739] acpi PNP0B00:00: GPIO: looking up wp-gpios
[    3.416748] acpi PNP0B00:00: GPIO: looking up wp-gpio
[    3.416755] rtc_cmos 00:05: using lookup tables for GPIO lookup
[    3.416763] rtc_cmos 00:05: No GPIO consumer wp found
[    3.416877] rtc_cmos 00:05: alarms up to one day, y3k, 242 bytes nvram
[    3.417698] i2c_dev: i2c /dev entries driver
[    3.418361] device-mapper: core: CONFIG_IMA_DISABLE_HTABLE is disabled. Duplicate IMA measurements will not be recorded in the IMA log.
[    3.419864] device-mapper: uevent: version 1.0.3
[    3.420597] device-mapper: ioctl: 4.47.0-ioctl (2022-07-28) initialised: dm-devel@redhat.com
[    3.421632] intel_pstate: CPU model not supported
[    3.422265] sdhci: Secure Digital Host Controller Interface driver
[    3.423016] sdhci: Copyright(c) Pierre Ossman
[    3.423602] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.424356] ledtrig-cpu: registered to indicate activity on CPUs
[    3.425212] efifb: probing for efifb
[    3.425715] efifb: framebuffer at 0x80000000, using 1876k, total 1875k
[    3.426514] efifb: mode is 800x600x32, linelength=3200, pages=1
[    3.427262] efifb: scrolling: redraw
[    3.427707] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    3.430943] Console: switching to colour frame buffer device 100x37
[    3.432726] fb0: EFI VGA frame buffer device
[    3.433316] pstore: Registered efi_pstore as persistent store backend
[    3.434380] drop_monitor: Initializing network drop monitor service
[    3.435299] NET: Registered PF_INET6 protocol family
[    3.437832] Segment Routing with IPv6
[    3.438326] In-situ OAM (IOAM) with IPv6
[    3.438852] NET: Registered PF_PACKET protocol family
[    3.439657] 9pnet: Installing 9P2000 support
[    3.440245] Key type dns_resolver registered
[    3.441398] IPI shorthand broadcast: enabled
[    3.452283] sched_clock: Marking stable (3288003182, 163103815)->(3510610267, -59503270)
[    3.453680] registered taskstats version 1
[    3.454338] Loading compiled-in X.509 certificates
[    3.455030] zswap: loaded using pool lzo/zbud
[    3.465556] Key type .fscrypt registered
[    3.466047] Key type fscrypt-provisioning registered
[    3.466692] pstore: Using crash dump compression: deflate
[    3.468142] Key type encrypted registered
[    3.468660] ima: No TPM chip found, activating TPM-bypass!
[    3.469332] ima: Allocated hash algorithm: sha1
[    3.469912] ima: No architecture policies found
[    3.470516] evm: Initialising EVM extended attributes:
[    3.471157] evm: security.selinux
[    3.471569] evm: security.SMACK64
[    3.471980] evm: security.SMACK64EXEC
[    3.472432] evm: security.SMACK64TRANSMUTE
[    3.472936] evm: security.SMACK64MMAP
[    3.473390] evm: security.apparmor
[    3.473813] evm: security.ima
[    3.474183] evm: security.capability
[    3.474624] evm: HMAC attrs: 0x1
[    3.475924] PM:   Magic number: 15:221:461
[    3.476786] RAS: Correctable Errors collector initialized.
[    3.478394] md: Waiting for all devices to be available before autodetect
[    3.478928] md: If you don't use raid, use raid=noautodetect
[    3.479403] md: Autodetecting RAID arrays.
[    3.479740] md: autorun ...
[    3.479971] md: ... autorun DONE.
[    3.521402] EXT4-fs (sda): INFO: recovery required on readonly filesystem
[    3.521958] EXT4-fs (sda): write access will be enabled during recovery
[    3.566764] EXT4-fs (sda): recovery complete
[    3.568620] EXT4-fs (sda): mounted filesystem 23a53bb9-f815-47a5-b74c-5e08f7731193 with ordered data mode. Quota mode: none.
[    3.569544] VFS: Mounted root (ext4 filesystem) readonly on device 8:0.
[    3.570559] devtmpfs: mounted
[    3.576773] Freeing unused decrypted memory: 2036K
[    3.578958] Freeing unused kernel image (initmem) memory: 10400K
[    3.579472] Write protecting the kernel read-only data: 45056k
[    3.580937] Freeing unused kernel image (rodata/data gap) memory: 436K
[    3.656757] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    3.657273] Run /sbin/init as init process
[    3.657604]   with arguments:
[    3.657608]     /sbin/init
[    3.657613]   with environment:
[    3.657617]     HOME=/
[    3.657622]     TERM=linux
[    3.734361] systemd[1]: RTC configured in localtime, applying delta of 0 minutes to system time.
[    3.757907] systemd[1]: systemd 239 (239-49.el8) running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=legacy)
[    3.759784] systemd[1]: Detected virtualization kvm.
[    3.760198] systemd[1]: Detected architecture x86-64.
[    3.809325] systemd[1]: Set hostname to <test>.
[    4.019713] systemd[1]: Listening on Journal Socket.
[    4.020976] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    4.022648] systemd[1]: Reached target Swap.
[    4.023642] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    4.025145] systemd[1]: Listening on udev Kernel Socket.
[    4.047355] systemd[1]: Starting Remount Root and Kernel File Systems...
[    4.199570] EXT4-fs (sda): re-mounted 23a53bb9-f815-47a5-b74c-5e08f7731193. Quota mode: none.
[    5.647520] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[    5.648613] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    5.847753] Spectre V2 : WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!
[    5.848948] Spectre V2 : WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!
[   14.012455] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=340 'systemd'

--aPi2dJHnmmmy17mS--
