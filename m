Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC725BA31B
	for <lists+io-uring@lfdr.de>; Fri, 16 Sep 2022 01:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIOXW7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Sep 2022 19:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIOXW6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Sep 2022 19:22:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C527C75A;
        Thu, 15 Sep 2022 16:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663284177; x=1694820177;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4Aotw1s2HbqfBcOfpO1TwzDGwI8uCbHCjQTddLKguTw=;
  b=cy3QCpyUKItDG03fuTj/4B2Ri9zu2kUc8NBFkE0H/OyJPJuWLaDuzNjk
   +xtRyZVyYJckON60X27k4grQywsHYfEgJoAoU7oZI7zqWyUD/EJTPvNYy
   alYgIYQXL8UY0JACDQPwf7d/p/J594mYgluY97AsbfLSM2KwZ8RcqzQna
   O1mlgpXQyIA34+vmKpZ16/rlx9+orLRyK1pXi5szPWj/yIiZlzbvO/ci8
   7K3HyFzzO7jhfIteAZcBSwM/EoF9wc5NNYGkgnRp8j9IaCBTbKxbguSyV
   omJjAtMCMplqo6gHjysmCTGpBNfqI7BfqX9T23aicNImwon/ShNGzevEx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="281893229"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="281893229"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 16:22:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="568623143"
Received: from lkp-server02.sh.intel.com (HELO 41300c7200ea) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 15 Sep 2022 16:22:54 -0700
Received: from kbuild by 41300c7200ea with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oYyC5-0001Aa-2R;
        Thu, 15 Sep 2022 23:22:53 +0000
Date:   Fri, 16 Sep 2022 07:22:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Alexander V. Buev" <a.buev@yadro.com>, linux-block@vger.kernel.org
Cc:     kbuild-all@lists.01.org, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, linux@yadro.com,
        "Alexander V. Buev" <a.buev@yadro.com>
Subject: Re: [PATCH v4 2/3] block: io-uring: add READV_PI/WRITEV_PI operations
Message-ID: <202209160737.29uHLqYq-lkp@intel.com>
References: <20220909122040.1098696-3-a.buev@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909122040.1098696-3-a.buev@yadro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Alexander,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.0-rc5 next-20220915]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-V-Buev/implement-direct-IO-with-integrity/20220909-202433
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: parisc-randconfig-s053-20220914 (https://download.01.org/0day-ci/archive/20220916/202209160737.29uHLqYq-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/81de858455c5cf1e5870106f544fe1fd179fa324
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alexander-V-Buev/implement-direct-IO-with-integrity/20220909-202433
        git checkout 81de858455c5cf1e5870106f544fe1fd179fa324
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=parisc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
   io_uring/rw_pi.c: note: in included file (through io_uring/io_uring.h):
   io_uring/slist.h:138:29: sparse: sparse: no newline at end of file
   io_uring/rw_pi.c:248:27: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void *private @@     got void [noderef] __user * @@
   io_uring/rw_pi.c:248:27: sparse:     expected void *private
   io_uring/rw_pi.c:248:27: sparse:     got void [noderef] __user *
   io_uring/rw_pi.c:458:43: sparse: sparse: Using plain integer as NULL pointer
   io_uring/rw_pi.c:543:43: sparse: sparse: Using plain integer as NULL pointer
>> io_uring/rw_pi.c:266:17: sparse: sparse: cast removes address space '__user' of expression
   io_uring/rw_pi.c:266:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct iovec [noderef] __user *uvec @@     got struct iovec * @@
   io_uring/rw_pi.c:266:14: sparse:     expected struct iovec [noderef] __user *uvec
   io_uring/rw_pi.c:266:14: sparse:     got struct iovec *
   io_uring/rw_pi.c:275:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct iovec [noderef] __user *uvec @@     got struct iovec * @@
   io_uring/rw_pi.c:275:14: sparse:     expected struct iovec [noderef] __user *uvec
   io_uring/rw_pi.c:275:14: sparse:     got struct iovec *
>> io_uring/rw_pi.c:266:17: sparse: sparse: cast removes address space '__user' of expression
   io_uring/rw_pi.c:266:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct iovec [noderef] __user *uvec @@     got struct iovec * @@
   io_uring/rw_pi.c:266:14: sparse:     expected struct iovec [noderef] __user *uvec
   io_uring/rw_pi.c:266:14: sparse:     got struct iovec *
   io_uring/rw_pi.c:275:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct iovec [noderef] __user *uvec @@     got struct iovec * @@
   io_uring/rw_pi.c:275:14: sparse:     expected struct iovec [noderef] __user *uvec
   io_uring/rw_pi.c:275:14: sparse:     got struct iovec *
>> io_uring/rw_pi.c:266:17: sparse: sparse: cast removes address space '__user' of expression
   io_uring/rw_pi.c:266:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct iovec [noderef] __user *uvec @@     got struct iovec * @@
   io_uring/rw_pi.c:266:14: sparse:     expected struct iovec [noderef] __user *uvec
   io_uring/rw_pi.c:266:14: sparse:     got struct iovec *
   io_uring/rw_pi.c:275:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct iovec [noderef] __user *uvec @@     got struct iovec * @@
   io_uring/rw_pi.c:275:14: sparse:     expected struct iovec [noderef] __user *uvec
   io_uring/rw_pi.c:275:14: sparse:     got struct iovec *
>> io_uring/rw_pi.c:266:17: sparse: sparse: cast removes address space '__user' of expression
   io_uring/rw_pi.c:266:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct iovec [noderef] __user *uvec @@     got struct iovec * @@
   io_uring/rw_pi.c:266:14: sparse:     expected struct iovec [noderef] __user *uvec
   io_uring/rw_pi.c:266:14: sparse:     got struct iovec *
   io_uring/rw_pi.c:275:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct iovec [noderef] __user *uvec @@     got struct iovec * @@
   io_uring/rw_pi.c:275:14: sparse:     expected struct iovec [noderef] __user *uvec
   io_uring/rw_pi.c:275:14: sparse:     got struct iovec *

vim +/__user +266 io_uring/rw_pi.c

   255	
   256	
   257	static inline int
   258	io_import_iovecs_pi(int io_dir, struct io_kiocb *req, struct iovec **iovec,
   259				struct io_rw_state *s_data, struct __io_rw_pi_state *s_pi)
   260	{
   261		struct io_rw_pi *rw = io_kiocb_to_cmd(req, struct io_rw_pi);
   262		struct iovec __user *uvec;
   263		ssize_t ret;
   264	
   265		/* data */
 > 266		uvec = (struct iovec *)u64_to_user_ptr(rw->addr);
   267		iovec[DATA] = s_data->fast_iov;
   268		ret = __import_iovec(io_dir, uvec, rw->nr_segs,
   269					UIO_FASTIOV, iovec + DATA,
   270					&s_data->iter, req->ctx->compat);
   271	
   272		if (unlikely(ret <= 0))
   273			return (ret) ? ret : -EINVAL;
   274		/* pi */
   275		uvec = (struct iovec *)rw->kiocb.private;
   276		iovec[PI] = s_pi->fast_iov;
   277		ret = __import_iovec(io_dir, uvec, rw->nr_pi_segs,
   278					UIO_FASTIOV_PI, iovec + PI,
   279					&s_pi->iter, req->ctx->compat);
   280		if (unlikely(ret <= 0)) {
   281			if (iovec[DATA])
   282				kfree(iovec[DATA]);
   283			return (ret) ? ret : -EINVAL;
   284		}
   285	
   286		/* save states */
   287		io_rw_pi_state_iter_save(s_data, s_pi);
   288	
   289		return 0;
   290	}
   291	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
