Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF036E81E2
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 21:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjDST1N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 15:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjDST1K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 15:27:10 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1CF5FDD;
        Wed, 19 Apr 2023 12:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681932429; x=1713468429;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7frGXROc0MT874Q+MjeIB9HRPtgS95QE0EOYR0PppuM=;
  b=IjIZijVDMDSnCxI9kmuYlpR7HHpnpWsKS33l1loEBEPxV4+BqDiHdw/3
   E9e03OiUiSFIAbaDvd4psm20giE+PJwQZktsOnG7mxz96U8Qn2haGW1+R
   xEejd1XsRKc2NG+YZU0AH6jWz3YW4Po/HvhayjpasdJlaTLZ2VzuBMDoi
   BFWBDdRC6/DjxUwc7yKX6MeG+AMhGPoExPtvEurThKIkUbvX99te6LW9r
   ehiGLADrXfDN/tH0lou6c2OWFyKaFjyBcN7uXMzD6rN77q8shnr7SY5Hj
   wZqrzaJVjC9zSCtD+lR1rLCOiVGysWZ6J94FRNx2JyiOa9yZiEw8NLDmD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="334357811"
X-IronPort-AV: E=Sophos;i="5.99,210,1677571200"; 
   d="scan'208";a="334357811"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 12:27:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="756217021"
X-IronPort-AV: E=Sophos;i="5.99,210,1677571200"; 
   d="scan'208";a="756217021"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 19 Apr 2023 12:27:07 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ppDSH-000f7f-1N;
        Wed, 19 Apr 2023 19:27:01 +0000
Date:   Thu, 20 Apr 2023 03:26:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     luhongfei <luhongfei@vivo.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     oe-kbuild-all@lists.linux.dev, opensource.kernel@vivo.com,
        luhongfei <luhongfei@vivo.com>
Subject: Re: [PATCH] io_uring: Optimization of buffered random write
Message-ID: <202304200351.LIOui4Xc-lkp@intel.com>
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20230420/202304200351.LIOui4Xc-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/620dbcc5ab192992f08035fd9d271ffffb8ff043
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review luhongfei/io_uring-Optimization-of-buffered-random-write/20230419-172539
        git checkout 620dbcc5ab192992f08035fd9d271ffffb8ff043
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304200351.LIOui4Xc-lkp@intel.com/

All errors (new ones prefixed by >>):

   io_uring/io_uring.c: In function 'io_queue_sqe':
>> io_uring/io_uring.c:2091:30: error: 'struct io_kiocb' has no member named 'rw'
    2091 |         if (!is_write || (req->rw.kiocb.ki_flags & IOCB_DIRECT))
         |                              ^~


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
