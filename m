Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F26C56C20B
	for <lists+io-uring@lfdr.de>; Sat,  9 Jul 2022 01:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238380AbiGHUSx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 16:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239177AbiGHUSv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 16:18:51 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC4A2DA8D;
        Fri,  8 Jul 2022 13:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657311530; x=1688847530;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VVk3DH0J2s/uapV8NWCtaDc5GhklK5rVSPC7QvYirRw=;
  b=I4HWS6DW7TPURtJjOnNQ6FJ8zcQK4/+AoZQ+SxXW0YrpJjx6kIRAiRP+
   n0B2inkLJolYzsb8b/ZaeZPl2hn8l7xS7dcM3v8CBjVeiIZqL1XKvH0qB
   /pS7cKrMOKJhaJh0iU6lCuTJF4G9+XqXeZjwSVCpHwGzVYVSj7sVDK8+P
   gjucFaHCmQBOMThQ/59wdzTwY4hBet0KtvHNe1Z6soSMusHZx/xuw/9ky
   IBqzdbOq7DoXhmvgPmwbXJDvW7WEddrpQlj/AHhBlKbdiEJpJTLBUDi+c
   HLXm/G+W6dtj6TubPJugXzCLj3DG+qLdOJT/veETJ79nr47UHsun056SZ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="284380544"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="284380544"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 13:18:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="770891287"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga005.jf.intel.com with ESMTP; 08 Jul 2022 13:18:48 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Jul 2022 13:18:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 8 Jul 2022 13:18:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 8 Jul 2022 13:18:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlBVGPo8ZOdxlkMKPoWw0QOF56YXG2y36tAURuXdUcHD/PwkriuF26XUwC303gnupt9O2WyUKd0/dN2BhBiIhI5CCNAD7BVzXC5KrAOaU5VELoBAb41FiR1iH66MeUSKYzwl6D6irmihmHung985geHzv1tchy3UkoAJzEGrhWvS8OfxukFqd+J6zteLzV80LBIa9qev4+OJ4ajxOfm7fsDyUgciMRXnQntDkTOLWVKm8RPMQm5PT7+77H4V+FplQ0HEc/+KhCiOEY8Zt67jeC6pBOc5mVhddxzAdHKw1sXEBPP2h9mY5Tb7ucT97v6gz0RRLGY5WgS2W2tq/wH47A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dY29o8B4Mhyqv6tEXPMBWAevROIgmOmlR/cMTPpMT4=;
 b=N/pBaYNacXdRDAb7L46BJba6HBWDcET68gyNZH+U1BOn94tLhxMS1TAn7s5p7qpEL5161rHAx5PVUoWYgOwdcwC35oQ1Jj/mDdZi4SFecJWUliWsoJRIwpGxPpsbdKwkKGSouoeBlfmWqD2VKoQaE69ScA08JszFR26E6JsNnavwCmkxWvpEmMhluAnLrV5V9q157LAYpAU8IUUGHAx+q2qbNSj0VmcPswZuTxeKIgvOOp25qMIQXDUUPaEPmQkiS+6sJLBtENryUM1QAqnpO3ZV6k6JojbJP/X8Gh7uQIMMDXYRPMfR/fLSpuofZyKSvhICkKQHf+ASGTRWcdxTdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6311.namprd11.prod.outlook.com (2603:10b6:8:a6::21) by
 MWHPR11MB1296.namprd11.prod.outlook.com (2603:10b6:300:1d::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.18; Fri, 8 Jul 2022 20:18:45 +0000
Received: from DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::f188:57e2:349e:51da]) by DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::f188:57e2:349e:51da%9]) with mapi id 15.20.5417.020; Fri, 8 Jul 2022
 20:18:45 +0000
Date:   Fri, 8 Jul 2022 13:18:35 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
CC:     Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "Matthew Wilcox" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "Palmer Dabbelt" <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Nathan Chancellor" <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, <linux-aio@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <nvdimm@lists.linux.dev>,
        <io-uring@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <llvm@lists.linux.dev>
Subject: Re: [PATCH] fs: Replace kmap{,_atomic}() with kmap_local_page()
Message-ID: <YsiQptk19txHrG4c@iweiny-desk3>
References: <20220630163527.9776-1-fmdefrancesco@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220630163527.9776-1-fmdefrancesco@gmail.com>
X-ClientProxiedBy: BYAPR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::49) To DM4PR11MB6311.namprd11.prod.outlook.com
 (2603:10b6:8:a6::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f27b0ca9-3d98-41ff-4538-08da611f0f05
X-MS-TrafficTypeDiagnostic: MWHPR11MB1296:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h4AKFrD5SWs8KrDKuR0224t5bcnBpaCVkXRD/Tu0RPfmlp90uOpVT7UPwuhiKloGlM1kK1piwZHYjij1mFkFbSAXkawR2n0FhWShgxeTjse7MCGlxA62QR/SNGUIxhRh+bkQYMtYu2hKzsO0BVzX/LQDGwEypqf+9KG+R/hAz2g+LCdERO4zyfivriWmczWFataBJlGvSj/4wo1at2JvudlUqJHRHuxWsF3KxlpQku78C5t9ZVqBT7MbUWT5fAJLe452BH0hDsSS6f3vraNmHoupJci5gBkF7SR0a6ZMuqEH1PFjB7tuwI3iYbUnV9jDviiE7HOjtZLqVTUSC1dUKxRQkY0setOqCfLCTBT8nGaI/Bf5h4OepEyOYuxR2z5U+k6Xi0f1ZO+4SFnzOH9zPLkPEKI741ON8V+zhGyXtpPWFgWSqMNaJnXgRjPSNoNKJH/ipg1aG4ey6zicbRwRJiKZVRLipU9o0juy+zVR/1cYb8f89AY4TvWROQsefCE4aTTlvr8MZJnYeJCPanZrft/fYbRAdkamFJvHTUWdfLiwaY+qowHfuUggmhBGW9JZNuI8gdIRH4SsBoRnCmDAqI53G9aEOpKHjNqlvuvDvnoqK1i8VqciW08dVmNq9hOutX4UoQQUa+ZZ9uXo5hDqXzGbRSsG71z7morYIMvpVYeO2dp6sfL52wajjuhY8ipBBBUPFkrHpRUg/WBis98KFb7L+FJOwp0cT3FShrYVmpeOIa45QfW3OCQLjOu2tT/8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6311.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(396003)(136003)(376002)(39860400002)(346002)(8676002)(66946007)(2906002)(66476007)(38100700002)(33716001)(83380400001)(4326008)(66556008)(8936002)(41300700001)(86362001)(5660300002)(7416002)(82960400001)(6506007)(9686003)(6666004)(54906003)(186003)(6486002)(44832011)(316002)(6916009)(6512007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TRSjz3bBhhXqkrGhdMGqvCE8WJuRTFDICGtL22yi1BRfJu1G57KI4+oM3BsZ?=
 =?us-ascii?Q?cIsV86JGFPND923/5wcFVejez2ucZl/IHLTofg0b4w1nrXllV2GEXtuMtNZe?=
 =?us-ascii?Q?CAQag4n31avWzmKmd3dLZmJ4QyIEP2RWIywUDyA5fN3S5PvaT6d0bj20Ctpw?=
 =?us-ascii?Q?rowt9Gfazh5DRCE55hazf55xPQQMVSF3aEtkLMdzp2CovLqERCWPX3Fr1DzG?=
 =?us-ascii?Q?OZy1MM4Mq6MNg40qtMWExNYVdCj3qenwhTtSPFOg0Mmq8gS/VFB8CH4S69aW?=
 =?us-ascii?Q?cutxQ44ECvALRXhT/bFkea+rPLf6ggNmyBlA7qlc4lg81+F32lWWPMq2bdLl?=
 =?us-ascii?Q?/dGWS7aBdpbjI5zQa+bZjsOgufforGBN8Sh8Ogvg5Zo2SdOJOVz0CFzqPYij?=
 =?us-ascii?Q?x5J6B1Ok/flZN3E4JTiFziOb8ea5MfZpciQHqseWn8SIfeh/jPoxN2Zj4cUa?=
 =?us-ascii?Q?N5fNEHLHHMftLqqJPYxF8z/qtLhCTQqyoCVugubP374jekCr0v0q8i3lgDGd?=
 =?us-ascii?Q?kZuYZrFyBxrF7Kfb6fgpf7hmbsfNg1iUKAKWhiLu0H8Ds9OS9AgKbRb0SUAI?=
 =?us-ascii?Q?uvSjjeh/Ej/UHvhksxLmCGJRjQFbPdU3mJtsUKXaYTrpuZk5Ij33HpM0hbVY?=
 =?us-ascii?Q?VTWdweEVcIMPO+Q/sC2KnPqzkrdlbdUTXsFQ5Ra/c0k7lFkwpd+dHrjcoyDS?=
 =?us-ascii?Q?6aJFy5Ophe1L9gaBNNZhP6yDscodfam7RuRfbAb2NRccIdbBcBlldwWxee3W?=
 =?us-ascii?Q?UUo/Uv3vtNUPMDEhTJMRFyxZSSMDyLPEqoUYr5ZZz3M2wHRkM2Rjrcyi0G7G?=
 =?us-ascii?Q?AmgRoFEmO+h1XYfgIuIuKlPdLrJlneBcN9HhUxV3CVXOkEhA+WK1clqVKsCo?=
 =?us-ascii?Q?ccMnxf2AnwHRQTFi8heTOGMwZ5hyd3dThisR1vWJLEdwpiZgU6L6F0kdCf9p?=
 =?us-ascii?Q?vddFPlM4s+aJ2I6+k80oxO8+LWrQ9s2akw9NLXM9KZGm2KetFm0pA+iBfh4j?=
 =?us-ascii?Q?XtRQiuMXMQ30M3vZA2AxuwSODL9sEluQ4/9j6yhiHuHng16dJC4pOcmq8grK?=
 =?us-ascii?Q?QW958p/tc0kn19RDVuWtxqe/pT1DdRlivF9S/jsQezZ7obGorXakHVp7V0Fc?=
 =?us-ascii?Q?384tkoaU0ILblfdc7eyCyOkj03IZvoo9BBMO3TTFAW11vl8NjNc0dalsCYbM?=
 =?us-ascii?Q?PuubtWMP0KrgaOscF396sbedG8GBAQUaYJqkWaTRlDaQsfYqMDsyzurRLprI?=
 =?us-ascii?Q?PrPRXxEIm+HQ91snYkEkEeH4z8OERqyBL4nyvE38ARnvt6O9op7LIKPobDWd?=
 =?us-ascii?Q?XnBBYayIxpwvlgJ94bpgiAFoNgEKoBWj2gE5JPLukYYU/zRvLDyw6GOrlIUS?=
 =?us-ascii?Q?vADVQqehfu0WQXxos5FU0CacSlFoS+PDc0CTYfJgbdmoTfWay7+dHkdMlXLf?=
 =?us-ascii?Q?9lonRaBwrJje9zOo+548YmnUZunjykk7pc0MrmxawYVktXlgSn3mKMYfsC5l?=
 =?us-ascii?Q?oaCKLW1ZQ0l5PxHd1+WuxRhbx5uVUmKEYCUX/0Z3bx5jrDMuTHN7QupR9ZcA?=
 =?us-ascii?Q?15AdWzWj7HqEjKzZ6MS23pfyfw6yUsQ1DUQjQy9OBDJNxIlCQCn6WhUBygyj?=
 =?us-ascii?Q?Jao5t7ws7bcUOyrQiD265PxtuE3O0eQd6ruWhC7xP53u?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f27b0ca9-3d98-41ff-4538-08da611f0f05
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6311.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 20:18:45.1949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kKweMs2Qyq8SjHVNH9lAGi4PWUc2cI+aObiL4wPSXvutv0f/KPGsyLHXGCm4XVAoWLn2UIw38A3IJ3c/sG7oCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1296
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 30, 2022 at 06:35:27PM +0200, Fabio M. De Francesco wrote:
> The use of kmap() and kmap_atomic() are being deprecated in favor of
> kmap_local_page().
> 
> With kmap_local_page(), the mappings are per thread, CPU local and not
> globally visible. Furthermore, the mappings can be acquired from any
> context (including interrupts).
> 
> Therefore, use kmap_local_page() in exec.c because these mappings are per
> thread, CPU local, and not globally visible.
> 
> Tested with xfstests on a QEMU + KVM 32-bits VM booting a kernel with
> HIGHMEM64GB enabled.
> 
> Suggested-by: Ira Weiny <ira.weiny@intel.com>

This looks good but there is a kmap_atomic() in this file which I _think_ can
be converted as well.  But that is good as a separate patch.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> ---
>  fs/exec.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 0989fb8472a1..4a2129c0d422 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -583,11 +583,11 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
>  
>  				if (kmapped_page) {
>  					flush_dcache_page(kmapped_page);
> -					kunmap(kmapped_page);
> +					kunmap_local(kaddr);
>  					put_arg_page(kmapped_page);
>  				}
>  				kmapped_page = page;
> -				kaddr = kmap(kmapped_page);
> +				kaddr = kmap_local_page(kmapped_page);
>  				kpos = pos & PAGE_MASK;
>  				flush_arg_page(bprm, kpos, kmapped_page);
>  			}
> @@ -601,7 +601,7 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
>  out:
>  	if (kmapped_page) {
>  		flush_dcache_page(kmapped_page);
> -		kunmap(kmapped_page);
> +		kunmap_local(kaddr);
>  		put_arg_page(kmapped_page);
>  	}
>  	return ret;
> @@ -883,11 +883,11 @@ int transfer_args_to_stack(struct linux_binprm *bprm,
>  
>  	for (index = MAX_ARG_PAGES - 1; index >= stop; index--) {
>  		unsigned int offset = index == stop ? bprm->p & ~PAGE_MASK : 0;
> -		char *src = kmap(bprm->page[index]) + offset;
> +		char *src = kmap_local_page(bprm->page[index]) + offset;
>  		sp -= PAGE_SIZE - offset;
>  		if (copy_to_user((void *) sp, src, PAGE_SIZE - offset) != 0)
>  			ret = -EFAULT;
> -		kunmap(bprm->page[index]);
> +		kunmap_local(src);
>  		if (ret)
>  			goto out;
>  	}
> @@ -1680,13 +1680,13 @@ int remove_arg_zero(struct linux_binprm *bprm)
>  			ret = -EFAULT;
>  			goto out;
>  		}
> -		kaddr = kmap_atomic(page);
> +		kaddr = kmap_local_page(page);
>  
>  		for (; offset < PAGE_SIZE && kaddr[offset];
>  				offset++, bprm->p++)
>  			;
>  
> -		kunmap_atomic(kaddr);
> +		kunmap_local(kaddr);
>  		put_arg_page(page);
>  	} while (offset == PAGE_SIZE);
>  
> -- 
> 2.36.1
> 
