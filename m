Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7811551D62F
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 13:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242030AbiEFLJh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 07:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiEFLJg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 07:09:36 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821462B1A2;
        Fri,  6 May 2022 04:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651835152; x=1683371152;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/COp8gUNtv/XMz0nfxIIgbYPQUzYcinwKw57ktyNo6g=;
  b=EDOWJefL2kjeDVss2qb+KwExVf49dfaIPQyi5E8z8b15fe38hjKGPN71
   nYz2ByZJBWFc+I9ELfWloYfqVH3TjIChD+s6kz/mAsAfbV0D5j42H1wTs
   8DASpao2qTBIV8eNEO64Jp9ruotRstFEBXFgJm1X7Pn+FX9ccGqEowiFQ
   6KyhkJRa85PRg73XfUOyyflJB1brVlpFCQxFXSCqpoqfm6wgWEoWCZUxL
   S3ueBXrcAVfNeCiB/ixy/ma7wj+iLQHsBUUJNylZ9rqAF8uUmiQ2uEBQC
   JfCoxfpS2y7l8zHMVPtI8Zkm1Lb+Q47Lp/C1BuE5irElWTZRvqmaCEr/F
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="268582732"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="268582732"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 04:05:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="621781981"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 06 May 2022 04:05:50 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nmvmP-000DNW-Uk;
        Fri, 06 May 2022 11:05:49 +0000
Date:   Fri, 6 May 2022 19:04:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] io_uring: add a helper for poll clean
Message-ID: <202205061844.HxnOWhwG-lkp@intel.com>
References: <20220506070102.26032-5-haoxu.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506070102.26032-5-haoxu.linux@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Hao,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on f2e030dd7aaea5a937a2547dc980fab418fbc5e7]

url:    https://github.com/intel-lab-lkp/linux/commits/Hao-Xu/fast-poll-multishot-mode/20220506-150750
base:   f2e030dd7aaea5a937a2547dc980fab418fbc5e7
config: m68k-randconfig-r025-20220506 (https://download.01.org/0day-ci/archive/20220506/202205061844.HxnOWhwG-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/acb232e81643bd097278ebdc17038e6f280e7212
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hao-Xu/fast-poll-multishot-mode/20220506-150750
        git checkout acb232e81643bd097278ebdc17038e6f280e7212
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/io_uring.c: In function '__io_submit_flush_completions':
   fs/io_uring.c:2785:40: warning: variable 'prev' set but not used [-Wunused-but-set-variable]
    2785 |         struct io_wq_work_node *node, *prev;
         |                                        ^~~~
   fs/io_uring.c: In function 'io_apoll_task_func':
>> fs/io_uring.c:6067:9: error: implicit declaration of function '__io_poll_clean'; did you mean '__io_fill_cqe'? [-Werror=implicit-function-declaration]
    6067 |         __io_poll_clean(req);
         |         ^~~~~~~~~~~~~~~
         |         __io_fill_cqe
   cc1: some warnings being treated as errors


vim +6067 fs/io_uring.c

  6058	
  6059	static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
  6060	{
  6061		int ret;
  6062	
  6063		ret = io_poll_check_events(req, locked);
  6064		if (ret > 0)
  6065			return;
  6066	
> 6067		__io_poll_clean(req);
  6068	
  6069		if (!ret)
  6070			io_req_task_submit(req, locked);
  6071		else
  6072			io_req_complete_failed(req, ret);
  6073	}
  6074	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
