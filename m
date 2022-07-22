Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABBD257D7A1
	for <lists+io-uring@lfdr.de>; Fri, 22 Jul 2022 02:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbiGVAOh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 20:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbiGVAOg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 20:14:36 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E36312AAC;
        Thu, 21 Jul 2022 17:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658448875; x=1689984875;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2PIJKeRHLkcyqYFcpmXXbs0b2mGiyoYSnorAdJIVD5Y=;
  b=aPhHM1IbvSuuxquDOTGxojs8r7Ooo4Gqis2KBf/1uztBAwzTl3rcfZO+
   Hb4pcBuBiJyi7iQwmVRuy/v9kkld4h/KirawSYGaCOW5FFh4ICXmwu31I
   w8P1EnGCd2Z4HGCH+k+eC6SFngRF2yfe46aqmXe9DzkT7UDa4YVL4v/GA
   GA916nPpcHsgubj53eTiV3Dr0llpxOpDrpW4CjjC7PMqdSX41igJ1wH7x
   3zFKA/aI5qHLEsbI1tp9SeZ+K0M+PgDQuslzNg104AqZkS5dmgCHhSOc8
   KOXgHs5PBbgPZZLz/sbSr3h6Kni06pJXT5RlVKrmq+jDNy+8ADOr9ltCN
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="348900456"
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="348900456"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 17:14:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="688099395"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Jul 2022 17:14:34 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 17:14:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 17:14:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 17:14:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8P70FTne9XOJTsxG0kuKj3u8EUP0VWQn9UDdf/UsUTffo+l9OZ/WGVg8CbjKdCcPmHN6005Wztp5mljYSZXarJSTSU+FKF3gNgCDS0huiLO8spkKxCXcKMPvnDnPFoSS29r3Lovo7ZGBtlfSZrcpFhYdRyBfpJfLythyknBPQBicZj0WkGrYMZbMQkP1YuJQ8RiWaKSnSzr8QBp+u8181UcYgCeYAGT8qhYrqpHgB2pHfE68fj3KUrWv+4cyXHiDCB7xgYS5arYJAdjK8hlr8h5a7L9Vv7fAcMli30LTkPIIzD+TIzrgXX6gD42JiuzHGs18rl1Qz193mdTXzf9ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BWlyxbG/DP4Y5gAW9c3viWFFScPNOUFOhhDDW1oXLSw=;
 b=Obv8wN0h0VGc+CCjztEHYpOUtfnPpSqDASaOLq6ZKh8Bo4OqojQRgj+Dm7xlYQ9x9E8hfSO4ksQzAheOosmS+VvxBcDETJPgaTMgq+XB5NaIJEVRMc+rmxDSQsuhvbn34HzivuO9Y39SsNF/mXEmWxhhPfAGUGAO71UKXeAQtsH7ppeOUILIHkC5XJpwRrC+FmN1zHx6zptwhvGjKa6eygcn35Bm+8ofmMqlK+58Q9IEusmuHuW5RNebigClKo93OHkRKMcWD9HH8fWicIk5N/Pm7168lXufjJtmrqS9+Fefr9nZmLiqyOJjmYTilZKLXnjVVNkPSdcU7WyTbnQMpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6311.namprd11.prod.outlook.com (2603:10b6:8:a6::21) by
 BYAPR11MB3590.namprd11.prod.outlook.com (2603:10b6:a03:b2::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.21; Fri, 22 Jul 2022 00:14:31 +0000
Received: from DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::3154:e32f:e50c:4fa6]) by DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::3154:e32f:e50c:4fa6%6]) with mapi id 15.20.5438.017; Fri, 22 Jul 2022
 00:14:30 +0000
Date:   Thu, 21 Jul 2022 17:14:20 -0700
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
Subject: Re: [PATCH] fs: Call kmap_local_page() in copy_string_kernel()
Message-ID: <Ytnr3IhSkDOjqbZ1@iweiny-desk3>
References: <20220710100136.25496-1-fmdefrancesco@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220710100136.25496-1-fmdefrancesco@gmail.com>
X-ClientProxiedBy: SJ0PR05CA0201.namprd05.prod.outlook.com
 (2603:10b6:a03:330::26) To DM4PR11MB6311.namprd11.prod.outlook.com
 (2603:10b6:8:a6::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55526f5a-02da-4703-cf78-08da6b7724d1
X-MS-TrafficTypeDiagnostic: BYAPR11MB3590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TlbSlknmpHEkDeN542HSZ9m9+Sdbz9MSToyInr59UYEGyIctmpAM5OIMN0fgj6ZuwxZ7WS3MNCbQw+BTH/HUa4cW+SN/WWYJb06HbEvupwbUDSJzlhiMtXAUBwYB6uZvNGS52/dZsUeX9GBoi9NrVU+6OiD87cpuxJbFziVNvG5m8SHcljY0fi9Dm0dxawnZk4sh3oYOJ0VUhqYyKlCUmV77e3mCQf1Z6CkpNaE/qKEwP/BhdyGyMJ/i/H6da+Qwt/NXXgbUITgpZRLhyWLOUYM6jNTuKoSHew4XbxVSCIT4qfj8VgImKXaXJAWlIHbtInU+AV9nrRSGJbQlN9hw3IsPhxjut/5SMkzSrdP7XJqWnspTVKYesTJ2VIaupSCHnj2L98kPNR9IdtdTVHTTrnuql3HGo0BK2uX/OKBO3atJG8s/e/a+vTLElbhWS46xj4q6LeKIrZXG0A7f/C9H/G2ZBPsPyzA9NVrYq0yzi0e1AtI9Gtls8o6Yrs/R7/BxWkNFKjiNa0qfBiONdysiNS2yiG5ecP0bWUuMYAjEyroUtkjEK8N7wekA9UehIJKWyKqcXDfA78MsAOd2Tk3FzboTxtkzAtmBB7eJipKkNrRHcdyoOVs61onAS0yPhIWYQgmosfS/UpQVxpIh9qL84xJFkDMNKWp+Gep+rv5gtnBbJCSLc6ghfja/x6cJ6VC4m+xIvpp/1KbEO4yuXRSKGBGUSPVv9wvE2qCBnuS7TZ8dgltA3J2pDJGu+A5rbp3HgvtobBIMg4y+HFacFs24AvhYpTVzzVDDcrUQAdGPZxsUwlduOlJUr+0uYSbhCFLD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6311.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(136003)(366004)(346002)(376002)(396003)(66946007)(38100700002)(33716001)(186003)(66476007)(4326008)(26005)(8676002)(83380400001)(66556008)(9686003)(6512007)(966005)(6506007)(6666004)(8936002)(6486002)(41300700001)(7416002)(478600001)(6916009)(44832011)(5660300002)(2906002)(82960400001)(54906003)(86362001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WjWILRGnvuBg4k1bKJ5GvpgMFb429mGS8L7csu1TIkAkgNdmWLFxVgONVr31?=
 =?us-ascii?Q?LhTsZnGTMdWkA8S7JtXHz7OP1J2YenJ6UonU+5coVFvYzd6W/8BHWoGq0wpS?=
 =?us-ascii?Q?MRXZIT6h1AEFuX93mrO8QJowVzXgd3/F8qZfWGRtqmWe5Ct3dgjVKC7eak14?=
 =?us-ascii?Q?GSNwKqQxsInM4aUwOcGsxLeFhQbj4q3b/jcUE0x2gb/6w1rUu8omW9P4S/EF?=
 =?us-ascii?Q?1vu1OM6qM6fzsZDup+P7lsFAE1MM2WcuUZaO8eXwHpcLPKqrLI5V3a37Cp0F?=
 =?us-ascii?Q?/TcyRZrf0klDoJCooDnZFqx7Vb2YanRSHmYta9WctdsolTERwpfJC+dtsRDx?=
 =?us-ascii?Q?5YnNLHjuJQuKq4khzzKPUuJSADK3ISX+pyhHayfOOwoKssVwOHQWNhp5i5Tf?=
 =?us-ascii?Q?LwdfFKXizpvXs71uA7aQhc4e/X+M4mc2tr6tGWAKleGtqNhiign+GH6FIbZY?=
 =?us-ascii?Q?yhUDziT5ClGCEeX+PLIM9KXYgsqR0+d9NR+FYDnqFBC0wCKnry0RXfIGEnj0?=
 =?us-ascii?Q?ebErm66sCnhY5EwPFxzaXS9NUhJj+v4KkaqSRxIkurGwhgqKBp4UNmuM/I/W?=
 =?us-ascii?Q?mf86edmT2YGAaWhkEynolj51VxCwYpG4WBxn4BPPLLv01weKDJe9QTpNO0oq?=
 =?us-ascii?Q?kvVkkh4yPP8nFS/T5IRlkEseo/EkiS7ISzjC3kdNdCEwVnLaX0mMeJLgxKBD?=
 =?us-ascii?Q?+d6kXVGAu7J74uPIwSsVs/eYEnBXchFCCHUBvok2qWU1x1DnxPpRaxoxMaoq?=
 =?us-ascii?Q?mcxKnzSmkYQctng4VjUaZXQLVNxoc18oiT8ISbGwPqKFMM9C/8a6vsY1OIkO?=
 =?us-ascii?Q?7VJsLjAa66JMSNrC3zTnC5CTGKpBXupc9a/EkQRNFcZu+szWbHgqwGdwPu03?=
 =?us-ascii?Q?Qr43wlW16Uwy+7ApveJS1lFbrnlqQjQHP2XzR4rON3kHaiVN7jt0NInIGqKu?=
 =?us-ascii?Q?pe5om5FwrgRvPbsLdQpafm3mqdiXmJwUExwlPI7rxH6tLGytdtSgBSbFb+qX?=
 =?us-ascii?Q?Mn6OfTjVfcXgkAgxeP/6JBEjnrdMsYmZW48BT/a0Wl5oW09Lu/AQqG1nfTOK?=
 =?us-ascii?Q?CCw/xXdsA63O39f2Xx8Zw9SB4SyH9W1+bksaIXj79jswZoHjcJ8bv/1Q7r+A?=
 =?us-ascii?Q?eDcHAieJq0FL0Y9/L0e2pE8SzluQp/YM/2tiERpd/PFPdTi5yoUvdw2OWrzY?=
 =?us-ascii?Q?3TdcGa4NhtXbgSzhe5swaLlJwBbmV28udVbCXArFfhotI9hvRxFCtSXFY2Fv?=
 =?us-ascii?Q?52zkIMC/4rXot3eHKmnfKw/iMbNVbByeASETYw3xV2L62vnMq7p5Zd0SSfpB?=
 =?us-ascii?Q?qVXbULoa95binYCOAn5TYIKAgRB3gDJTSwjI5p1C2KpaFL8+vbqqS9FS7xLb?=
 =?us-ascii?Q?9r8yUfKivrnXpYZ8CB7sUFHjdEuZ+weK8jXdIgIl1R4X8Q/p/z3G4Ad4O3n/?=
 =?us-ascii?Q?kS2tS2KE5nODqVCgv+gzfneMWqkqC4n6thzUWIPZV8mwJIMOWJsh08QZ/obo?=
 =?us-ascii?Q?jV59NuExyGh+fLrJPiqSViOBTN36z5Wv8Fi6NxILxSC/fWZ+bKIM2R4rVzr5?=
 =?us-ascii?Q?MjTV8rmUssXpIXmch9OpItA4Ng8H/vu+XW0gMLk7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55526f5a-02da-4703-cf78-08da6b7724d1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6311.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 00:14:30.6864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: prgdSKDxEJxiOdp5KZM1kgZoISq/vsMTY11MIsre7DusiU8UxC/Q1VImTKUy0T8LroS670vWmZGP1QnRcQjWmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3590
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jul 10, 2022 at 12:01:36PM +0200, Fabio M. De Francesco wrote:
> The use of kmap_atomic() is being deprecated in favor of kmap_local_page().
> 
> With kmap_local_page(), the mappings are per thread, CPU local, not
> globally visible and can take page faults. Furthermore, the mappings can be
> acquired from any context (including interrupts).
> 
> Therefore, use kmap_local_page() in copy_string_kernel() instead of
> kmap_atomic().
> 
> Tested with xfstests on a QEMU + KVM 32-bits VM booting a kernel with
> HIGHMEM64GB enabled.
> 
> Suggested-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> ---
> 
> I sent a first patch to fs/exec.c for converting kmap() and kmap_atomic()
> to kmap_local_page():
> https://lore.kernel.org/lkml/20220630163527.9776-1-fmdefrancesco@gmail.com/
> 
> Some days ago, Ira Weiny, while he was reviewing that patch, made me notice
> that I had overlooked a second kmap_atomic() in the same file (thanks):
> https://lore.kernel.org/lkml/YsiQptk19txHrG4c@iweiny-desk3/
> 
> I've been asked to send this as an additional change. This is why there will
> not be any second version of that previous patch.
> 
>  fs/exec.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 4a2129c0d422..5fa652ca5823 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -639,11 +639,11 @@ int copy_string_kernel(const char *arg, struct linux_binprm *bprm)
>  		page = get_arg_page(bprm, pos, 1);
>  		if (!page)
>  			return -E2BIG;
> -		kaddr = kmap_atomic(page);
> +		kaddr = kmap_local_page(page);
>  		flush_arg_page(bprm, pos & PAGE_MASK, page);

I really question why we can't use memcpy_to_page() here and move the
flush_arg_page() prior to the mapping?

flush_arg_page() only calls flush_cache_page() which does not need the
mapping to work correctly AFAICT.

Ira

>  		memcpy(kaddr + offset_in_page(pos), arg, bytes_to_copy);
>  		flush_dcache_page(page);
> -		kunmap_atomic(kaddr);
> +		kunmap_local(kaddr);
>  		put_arg_page(page);
>  	}
>  
> -- 
> 2.36.1
> 
