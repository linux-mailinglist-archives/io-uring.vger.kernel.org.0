Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E065422CE
	for <lists+io-uring@lfdr.de>; Wed,  8 Jun 2022 08:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiFHBVj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jun 2022 21:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1575050AbiFGX0h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jun 2022 19:26:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C53408394;
        Tue,  7 Jun 2022 14:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654637915; x=1686173915;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1ePpN/66ifBUrXzD9UOlIVYgsb6yN+4qexSlGr5Seyw=;
  b=RhLFYNAkUEfnswm2y3glPoipKSF3gjtRZGkORETmRtoxhy9e0q90OWi+
   tdkc26e4A93qbJbSkHcdNeg/R+dc90QcnO+1dSnfjkaVYzkFPNAXwdDb8
   KyS1S25Z5NI2xTab0L5S6Oysa3XnXPgD9MlfeHNuK0abWM6Q2EgpAfHCn
   3e5SR47LWX8UA3fIUiEhw5yCcdxl5TsYRT4N36WibxZZW61AOMw6FzyDv
   RtiOMqAiDOk8cu/Ac+VVQWt/d6z+7OtE22LxEKAPQDJnS18hYSRPjGOHG
   qN21Qy9uJEfS3cu0YeiUDPMrN9O7vp+rqSVuCKOXFoOYcrY15jPWqMz6f
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="363093372"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="363093372"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 14:38:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="565615057"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 07 Jun 2022 14:38:07 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nygtq-000Dyj-A4;
        Tue, 07 Jun 2022 21:38:06 +0000
Date:   Wed, 8 Jun 2022 05:38:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: Re: [PATCH 4/5] io_uring: support nonblock try for splicing from
 pipe to pipe
Message-ID: <202206080550.7nXmrsiv-lkp@intel.com>
References: <20220607080619.513187-5-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607080619.513187-5-hao.xu@linux.dev>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Hao,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on d8271bf021438f468dab3cd84fe5279b5bbcead8]

url:    https://github.com/intel-lab-lkp/linux/commits/Hao-Xu/support-nonblock-submission-for-splice-pipe-to-pipe/20220607-161605
base:   d8271bf021438f468dab3cd84fe5279b5bbcead8
config: mips-buildonly-randconfig-r001-20220607 (https://download.01.org/0day-ci/archive/20220608/202206080550.7nXmrsiv-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project b92436efcb7813fc481b30f2593a4907568d917a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/96683840c3f19b77a536a259094d24e0cd93ebc0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hao-Xu/support-nonblock-submission-for-splice-pipe-to-pipe/20220607-161605
        git checkout 96683840c3f19b77a536a259094d24e0cd93ebc0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> io_uring/splice.c:91:6: warning: no previous prototype for function 'io_splice_support_nowait' [-Wmissing-prototypes]
   bool io_splice_support_nowait(struct file *in, struct file *out)
        ^
   io_uring/splice.c:91:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   bool io_splice_support_nowait(struct file *in, struct file *out)
   ^
   static 
   1 warning generated.


vim +/io_splice_support_nowait +91 io_uring/splice.c

    90	
  > 91	bool io_splice_support_nowait(struct file *in, struct file *out)
    92	{
    93		if (get_pipe_info(in, true) && get_pipe_info(out, true))
    94			return true;
    95	
    96		return false;
    97	}
    98	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
