Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E6577C92B
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 10:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbjHOIKq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 04:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbjHOIKj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 04:10:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD0C1703
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 01:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692087038; x=1723623038;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8nKycNtMcpOafKP7h4F+VxvHWli/fLAnMPYDcCzXGEg=;
  b=kMpCEldBh4nbmkkqZ3BiDN3Pm6bGlUaSqQxH5+gT4jYaYFpG8NULkTMA
   Otk27+fbAa9eC2PzhGeFAzg+5Awp4EtZ7aMa5V8fo4V0Wa7/Ki4sd/UPY
   hjqiTYj21yIkcuvt0nPB1L0Zeu9HLBJdM0rnKTZcMAkvIVgjOo8JWJtTT
   pmfZOXxzTLwuOTPfTSbWmBFhnC6nRnCGCzEYkYKyIZCDmgMzH8HZnRNvn
   nW91+dx7E2ci/0a3KMSJCXz6UyxBki4tzE5t0J0byW1wIE0ThsdFm5tPi
   SIHd7luMkrABWjjm8D4XrSKXqk7nKsJkYcTECFgXlzcK+mkQBPfX5J5Ds
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="369702872"
X-IronPort-AV: E=Sophos;i="6.01,174,1684825200"; 
   d="scan'208";a="369702872"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 01:10:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="803737487"
X-IronPort-AV: E=Sophos;i="6.01,174,1684825200"; 
   d="scan'208";a="803737487"
Received: from lkp-server02.sh.intel.com (HELO b5fb8d9e1ffc) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 15 Aug 2023 01:10:36 -0700
Received: from kbuild by b5fb8d9e1ffc with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qVp8N-0000mp-2f;
        Tue, 15 Aug 2023 08:10:35 +0000
Date:   Tue, 15 Aug 2023 16:09:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH 3/9] mm: Call free_transhuge_folio() directly from
 destroy_large_folio()
Message-ID: <202308151509.ErdX8wsj-lkp@intel.com>
References: <20230815032645.1393700-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815032645.1393700-4-willy@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Matthew,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.5-rc6 next-20230809]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthew-Wilcox-Oracle/io_uring-Stop-calling-free_compound_page/20230815-112847
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20230815032645.1393700-4-willy%40infradead.org
patch subject: [PATCH 3/9] mm: Call free_transhuge_folio() directly from destroy_large_folio()
config: arm-randconfig-r046-20230815 (https://download.01.org/0day-ci/archive/20230815/202308151509.ErdX8wsj-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce: (https://download.01.org/0day-ci/archive/20230815/202308151509.ErdX8wsj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308151509.ErdX8wsj-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/page_alloc.c:615:3: error: call to undeclared function 'free_transhuge_folio'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     615 |                 free_transhuge_folio(folio);
         |                 ^
   1 error generated.


vim +/free_transhuge_folio +615 mm/page_alloc.c

   604	
   605	void destroy_large_folio(struct folio *folio)
   606	{
   607		enum compound_dtor_id dtor = folio->_folio_dtor;
   608	
   609		if (folio_test_hugetlb(folio)) {
   610			free_huge_page(folio);
   611			return;
   612		}
   613	
   614		if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR) {
 > 615			free_transhuge_folio(folio);
   616			return;
   617		}
   618	
   619		VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
   620		compound_page_dtors[dtor](&folio->page);
   621	}
   622	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
