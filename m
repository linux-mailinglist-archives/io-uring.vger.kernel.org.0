Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE5C6E83CA
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 23:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbjDSVbd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 17:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbjDSVba (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 17:31:30 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA529766;
        Wed, 19 Apr 2023 14:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681939868; x=1713475868;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uzaEvtKF/wb+BpZHv45rlTavjENU0eMCTHpvxq+55cw=;
  b=cBzO+UZukpQmV8H79i1QE1aJb16knkvmRD8Jhu4KyfYmNinUuPaIVQGk
   EotCIs2v3vM3tZfZ3XsUohFVRR8apEh2PhGUUl7X348RP8xDfwYAGijQU
   YHFGQAztSq0a9ciXeYv3EQHhzaebrCyWQY+00gv0jDFfKoKR11/aAsxcm
   6XO0MhFMosJ1Uq+nSdIemHDYioewdpjfbmuwIs2cu826bfOJnz+kxiAgW
   3tvZRaWOYfpiFt6S20VDphy6GX+G2VUKW8WZHNdT8ZwIVJik6vOMXr9kj
   HQ+KY1m6VLXFKt0YAPU/k5U+Cav/X9MeWamAxCkBoKkCy731oUUyvjapa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="334382342"
X-IronPort-AV: E=Sophos;i="5.99,210,1677571200"; 
   d="scan'208";a="334382342"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 14:31:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="756241128"
X-IronPort-AV: E=Sophos;i="5.99,210,1677571200"; 
   d="scan'208";a="756241128"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 19 Apr 2023 14:31:05 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ppFOK-000fCq-0s;
        Wed, 19 Apr 2023 21:31:04 +0000
Date:   Thu, 20 Apr 2023 05:30:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     luhongfei <luhongfei@vivo.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        opensource.kernel@vivo.com, luhongfei <luhongfei@vivo.com>
Subject: Re: [PATCH] io_uring: Optimization of buffered random write
Message-ID: <202304200502.T4Waeqad-lkp@intel.com>
References: <20230419092233.56338-1-luhongfei@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419092233.56338-1-luhongfei@vivo.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi luhongfei,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.3-rc7 next-20230418]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/luhongfei/io_uring-Optimization-of-buffered-random-write/20230419-172539
patch link:    https://lore.kernel.org/r/20230419092233.56338-1-luhongfei%40vivo.com
patch subject: [PATCH] io_uring: Optimization of buffered random write
config: i386-randconfig-a012-20230417 (https://download.01.org/0day-ci/archive/20230420/202304200502.T4Waeqad-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/620dbcc5ab192992f08035fd9d271ffffb8ff043
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review luhongfei/io_uring-Optimization-of-buffered-random-write/20230419-172539
        git checkout 620dbcc5ab192992f08035fd9d271ffffb8ff043
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304200502.T4Waeqad-lkp@intel.com/

All errors (new ones prefixed by >>):

>> io_uring/io_uring.c:2091:25: error: no member named 'rw' in 'struct io_kiocb'
           if (!is_write || (req->rw.kiocb.ki_flags & IOCB_DIRECT))
                             ~~~  ^
   1 error generated.


vim +2091 io_uring/io_uring.c

  2073	
  2074	static inline void io_queue_sqe(struct io_kiocb *req)
  2075		__must_hold(&req->ctx->uring_lock)
  2076	{
  2077		int ret;
  2078		bool is_write;
  2079	
  2080		switch (req->opcode) {
  2081		case IORING_OP_WRITEV:
  2082		case IORING_OP_WRITE_FIXED:
  2083		case IORING_OP_WRITE:
  2084			is_write = true;
  2085			break;
  2086		default:
  2087			is_write = false;
  2088			break;
  2089		}
  2090	
> 2091		if (!is_write || (req->rw.kiocb.ki_flags & IOCB_DIRECT))
  2092			ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
  2093		else
  2094			ret = io_issue_sqe(req, 0);
  2095	
  2096		/*
  2097		 * We async punt it if the file wasn't marked NOWAIT, or if the file
  2098		 * doesn't support non-blocking read/write attempts
  2099		 */
  2100		if (likely(!ret))
  2101			io_arm_ltimeout(req);
  2102		else
  2103			io_queue_async(req, ret);
  2104	}
  2105	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
