Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F5169E4FD
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 17:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbjBUQoL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Feb 2023 11:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbjBUQoL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Feb 2023 11:44:11 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6702A6FE;
        Tue, 21 Feb 2023 08:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676997816; x=1708533816;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GEqS54iOqnAwTwLmO/BPPAys2FtJiNPO2POhdEFOgNM=;
  b=AxDXen8nKZf+I5Av5//a+oAcrOVh4MxOoHoCrKKO99ljfuWnycO2rrPq
   9XsjegMZ0IPOdrxkmwVvvQIbly52ZkkKevtGghbM1Udt5H+dbBr0jlwZe
   U5nPX4nuNFoMR7RgfG4M9mwufJKD+Rl4Ww+6IXoJbeRjyz5/pZd1jykm7
   acR2q/3J5gK1YA273pXhKhoIwRvCo8zA+/XaWKVnAq4z2xh/BhfOjOPUI
   +kK3V2nwSC+je+M6xbArAsSGhNbR/p286FdIVu2/SHkuDX+9EO4GRrg2A
   nO2iYLZ/Raj2HMuqIrH1RPaCPZHuCmYR8cTApKe3zOf5KWKkOe1KTPpe9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="334877889"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="334877889"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 08:39:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="814564772"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="814564772"
Received: from lkp-server01.sh.intel.com (HELO eac18b5d7d93) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 21 Feb 2023 08:39:28 -0800
Received: from kbuild by eac18b5d7d93 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pUVfr-00002h-1W;
        Tue, 21 Feb 2023 16:39:27 +0000
Date:   Wed, 22 Feb 2023 00:39:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Breno Leitao <leitao@debian.org>, axboe@kernel.dk,
        asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
        gustavold@meta.com, leit@meta.com
Subject: Re: [PATCH 2/2] io_uring: Add KASAN support for alloc_caches
Message-ID: <202302220015.B4dQkwgA-lkp@intel.com>
References: <20230221135721.3230763-2-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221135721.3230763-2-leitao@debian.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Breno,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.2 next-20230221]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Breno-Leitao/io_uring-Add-KASAN-support-for-alloc_caches/20230221-220039
patch link:    https://lore.kernel.org/r/20230221135721.3230763-2-leitao%40debian.org
patch subject: [PATCH 2/2] io_uring: Add KASAN support for alloc_caches
config: powerpc-allnoconfig (https://download.01.org/0day-ci/archive/20230222/202302220015.B4dQkwgA-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d909e43a1659897df77bc1373d3c24cc0d9129cf
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Breno-Leitao/io_uring-Add-KASAN-support-for-alloc_caches/20230221-220039
        git checkout d909e43a1659897df77bc1373d3c24cc0d9129cf
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302220015.B4dQkwgA-lkp@intel.com/

All errors (new ones prefixed by >>):

   io_uring/io_uring.c: In function '__io_submit_flush_completions':
   io_uring/io_uring.c:1502:40: warning: variable 'prev' set but not used [-Wunused-but-set-variable]
    1502 |         struct io_wq_work_node *node, *prev;
         |                                        ^~~~
   io_uring/io_uring.c: In function 'io_uring_acache_free':
>> io_uring/io_uring.c:2781:36: error: invalid application of 'sizeof' to incomplete type 'struct io_async_msghdr'
    2781 |                             sizeof(struct io_async_msghdr));
         |                                    ^~~~~~


vim +2781 io_uring/io_uring.c

  2777	
  2778		io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free,
  2779				    sizeof(struct async_poll));
  2780		io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free,
> 2781				    sizeof(struct io_async_msghdr));
  2782	}
  2783	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
