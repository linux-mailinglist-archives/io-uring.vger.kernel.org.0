Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D554C5ED3
	for <lists+io-uring@lfdr.de>; Sun, 27 Feb 2022 21:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiB0UmX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 27 Feb 2022 15:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiB0UmW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 27 Feb 2022 15:42:22 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440645D18D;
        Sun, 27 Feb 2022 12:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645994505; x=1677530505;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lpf29+QUqst4fhOu/mjpWEpnEDzDujK3LoS/vcmfBFw=;
  b=HThmEBTP15bV45+sofs6amCMTOH5Ao/Cqpca6CDTQvuqNaE1Yx8gLRXb
   bRsG2bsrfywRAreiOHoq4owpUE94ICbkeObPDJR4oy3ZsGOXg2MMpdcmV
   +KRH7FCa6ZSR694haT56M5ziG89yEN4JDO1qZgqlA07p7Z0XhFqv1VihH
   pqh4pv/Xm7EZEE8PJ3k3LYPIXIy2Exu6+GqnXsrwVSWuNePS9cCYcvUCo
   duPueXY0OLhTa1nR2/nwaYCVGuCChVxNd91qK/8ot4EpmOJ7w8/eCpKIO
   10kZm8h8aHhhN99ukJ966XuvGkhw/J54J8/todZ/PLLujcNnJ/B0XvDcu
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="251595768"
X-IronPort-AV: E=Sophos;i="5.90,141,1643702400"; 
   d="scan'208";a="251595768"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 12:41:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,141,1643702400"; 
   d="scan'208";a="593006858"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 27 Feb 2022 12:41:43 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nOQMQ-0006nO-FE; Sun, 27 Feb 2022 20:41:42 +0000
Date:   Mon, 28 Feb 2022 04:41:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     kbuild-all@lists.01.org, Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] io_uring: Add support for napi_busy_poll
Message-ID: <202202280400.HHUsYqhX-lkp@intel.com>
References: <53ae4884ede7faab1f409ec635f723a0745d3656.1645981935.git.olivier@trillion01.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ae4884ede7faab1f409ec635f723a0745d3656.1645981935.git.olivier@trillion01.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Olivier,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[cannot apply to v5.17-rc5 next-20220225]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Olivier-Langlois/io_uring-Add-support-for-napi_busy_poll/20220228-012140
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 2293be58d6a18cab800e25e42081bacb75c05752
config: arc-randconfig-r043-20220227 (https://download.01.org/0day-ci/archive/20220228/202202280400.HHUsYqhX-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/65e72f78c66272f7cf0e87dfeef88f5b79de2d91
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Olivier-Langlois/io_uring-Add-support-for-napi_busy_poll/20220228-012140
        git checkout 65e72f78c66272f7cf0e87dfeef88f5b79de2d91
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   fs/io_uring.c: In function '__io_submit_flush_completions':
   fs/io_uring.c:2531:40: warning: variable 'prev' set but not used [-Wunused-but-set-variable]
    2531 |         struct io_wq_work_node *node, *prev;
         |                                        ^~~~
   In file included from ./arch/arc/include/generated/asm/div64.h:1,
                    from include/linux/math.h:5,
                    from include/linux/kernel.h:25,
                    from fs/io_uring.c:42:
   fs/io_uring.c: In function 'io_adjust_busy_loop_timeout':
>> include/asm-generic/div64.h:222:35: warning: comparison of distinct pointer types lacks a cast
     222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
         |                                   ^~
   fs/io_uring.c:7840:17: note: in expansion of macro 'do_div'
    7840 |                 do_div(to, 1000);
         |                 ^~~~~~


vim +222 include/asm-generic/div64.h

^1da177e4c3f41 Linus Torvalds     2005-04-16  215  
^1da177e4c3f41 Linus Torvalds     2005-04-16  216  /* The unnecessary pointer compare is there
^1da177e4c3f41 Linus Torvalds     2005-04-16  217   * to check for type safety (n must be 64bit)
^1da177e4c3f41 Linus Torvalds     2005-04-16  218   */
^1da177e4c3f41 Linus Torvalds     2005-04-16  219  # define do_div(n,base) ({				\
^1da177e4c3f41 Linus Torvalds     2005-04-16  220  	uint32_t __base = (base);			\
^1da177e4c3f41 Linus Torvalds     2005-04-16  221  	uint32_t __rem;					\
^1da177e4c3f41 Linus Torvalds     2005-04-16 @222  	(void)(((typeof((n)) *)0) == ((uint64_t *)0));	\
911918aa7ef6f8 Nicolas Pitre      2015-11-02  223  	if (__builtin_constant_p(__base) &&		\
911918aa7ef6f8 Nicolas Pitre      2015-11-02  224  	    is_power_of_2(__base)) {			\
911918aa7ef6f8 Nicolas Pitre      2015-11-02  225  		__rem = (n) & (__base - 1);		\
911918aa7ef6f8 Nicolas Pitre      2015-11-02  226  		(n) >>= ilog2(__base);			\
c747ce4706190e Geert Uytterhoeven 2021-08-11  227  	} else if (__builtin_constant_p(__base) &&	\
461a5e51060c93 Nicolas Pitre      2015-10-30  228  		   __base != 0) {			\
461a5e51060c93 Nicolas Pitre      2015-10-30  229  		uint32_t __res_lo, __n_lo = (n);	\
461a5e51060c93 Nicolas Pitre      2015-10-30  230  		(n) = __div64_const32(n, __base);	\
461a5e51060c93 Nicolas Pitre      2015-10-30  231  		/* the remainder can be computed with 32-bit regs */ \
461a5e51060c93 Nicolas Pitre      2015-10-30  232  		__res_lo = (n);				\
461a5e51060c93 Nicolas Pitre      2015-10-30  233  		__rem = __n_lo - __res_lo * __base;	\
911918aa7ef6f8 Nicolas Pitre      2015-11-02  234  	} else if (likely(((n) >> 32) == 0)) {		\
^1da177e4c3f41 Linus Torvalds     2005-04-16  235  		__rem = (uint32_t)(n) % __base;		\
^1da177e4c3f41 Linus Torvalds     2005-04-16  236  		(n) = (uint32_t)(n) / __base;		\
c747ce4706190e Geert Uytterhoeven 2021-08-11  237  	} else {					\
^1da177e4c3f41 Linus Torvalds     2005-04-16  238  		__rem = __div64_32(&(n), __base);	\
c747ce4706190e Geert Uytterhoeven 2021-08-11  239  	}						\
^1da177e4c3f41 Linus Torvalds     2005-04-16  240  	__rem;						\
^1da177e4c3f41 Linus Torvalds     2005-04-16  241   })
^1da177e4c3f41 Linus Torvalds     2005-04-16  242  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
