Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CD251D826
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 14:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349759AbiEFMvL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 08:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245378AbiEFMvK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 08:51:10 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A9911A19;
        Fri,  6 May 2022 05:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651841247; x=1683377247;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1JBwQExLjRf+shqSc42QfV8mXfEQe1cLSimGmvbq6XQ=;
  b=WMtueZu5wxcA7fvc6SS8kjFq9azBoI9+qlUoIJZ0Uvgd2wAHcGyUfsD8
   8EnLrcZgRsOt5/KK77gz0R2bLU7Hti5eFfYcYO5HW8JympOqSAvFUgKQN
   uI2IL1AkMmv28n+V8O6sXZ7hlJZEX6pEOlXPyGAX6tS5dyr+Xmvttr9pj
   aPYn9aD++pYLcos5Vv4bqLNP8wI8pqOsmJ1aLUR8shIuftD+mTG3lUydn
   LhOku1tofd9GCwVufDo232otP5HjxnA1R76ox2ahWRPkUgWv8xyAg/nzo
   b1S9CEIqac7vuNt/BxHFUE1OQqJs95TepumbMqHCTypntSBDBYieFfXzb
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="293664437"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="293664437"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 05:47:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="537872611"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2022 05:47:25 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nmxMi-000DTq-IJ;
        Fri, 06 May 2022 12:47:24 +0000
Date:   Fri, 6 May 2022 20:47:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] io_uring: add a helper for poll clean
Message-ID: <202205062033.yS62xm5Z-lkp@intel.com>
References: <20220506070102.26032-5-haoxu.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506070102.26032-5-haoxu.linux@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
config: mips-pic32mzda_defconfig (https://download.01.org/0day-ci/archive/20220506/202205062033.yS62xm5Z-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5e004fb787698440a387750db7f8028e7cb14cfc)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/acb232e81643bd097278ebdc17038e6f280e7212
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hao-Xu/fast-poll-multishot-mode/20220506-150750
        git checkout acb232e81643bd097278ebdc17038e6f280e7212
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> fs/io_uring.c:6067:2: error: call to undeclared function '__io_poll_clean'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           __io_poll_clean(req);
           ^
   fs/io_uring.c:6067:2: note: did you mean '__io_fill_cqe'?
   fs/io_uring.c:2141:20: note: '__io_fill_cqe' declared here
   static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
                      ^
   1 error generated.


vim +/__io_poll_clean +6067 fs/io_uring.c

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
