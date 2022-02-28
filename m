Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9CD4C637C
	for <lists+io-uring@lfdr.de>; Mon, 28 Feb 2022 08:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiB1HBi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Feb 2022 02:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiB1HBi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Feb 2022 02:01:38 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEEF673D5;
        Sun, 27 Feb 2022 23:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646031659; x=1677567659;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3HTqZ8cMCet+ihim5wkWp9ciLYvKVDk653uvsW5tke8=;
  b=WZ4M2BJ/1+z9BOa4PFrVMeojxpmpxpCWtyrd5Wt3IBYM0OZqKiTShP7+
   /UZpSzCGTZRPmPctA8K4mLGDtQ4eImtR+xT5YZvlJksDvTAWwQmyFboxI
   Yj6WFQ0wkBtppB6VyQNiPVxZ64O1WnZo4t+TeH7/qaCWqK+NTxnKUA60a
   Gz8raIgZG1JWeE0UuYquhqmFn8a6qFIc8Yf53Kqc+AY5IwrKmLlFFfRRB
   7PWmM1R12a/dibYRGOU/z+UYhq4C9BL6Owmcitb5Z8KIU2JSR9+qIFQOi
   MIeQ6lID46UXrvC3Roin96dj8F9hG4ZFtDe74hW2aIhDsAs8Ji0Y1SH0k
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="232792525"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="232792525"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 23:00:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="708542759"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 27 Feb 2022 23:00:56 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nOa1f-00078X-HT; Mon, 28 Feb 2022 07:00:55 +0000
Date:   Mon, 28 Feb 2022 15:00:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     kbuild-all@lists.01.org, Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] io_uring: Add support for napi_busy_poll
Message-ID: <202202281457.NLF9dxdF-lkp@intel.com>
References: <53ae4884ede7faab1f409ec635f723a0745d3656.1645981935.git.olivier@trillion01.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ae4884ede7faab1f409ec635f723a0745d3656.1645981935.git.olivier@trillion01.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Olivier,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.17-rc6]
[cannot apply to next-20220225]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Olivier-Langlois/io_uring-Add-support-for-napi_busy_poll/20220228-012140
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 2293be58d6a18cab800e25e42081bacb75c05752
config: mips-randconfig-s032-20220228 (https://download.01.org/0day-ci/archive/20220228/202202281457.NLF9dxdF-lkp@intel.com/config)
compiler: mipsel-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/65e72f78c66272f7cf0e87dfeef88f5b79de2d91
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Olivier-Langlois/io_uring-Add-support-for-napi_busy_poll/20220228-012140
        git checkout 65e72f78c66272f7cf0e87dfeef88f5b79de2d91
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   command-line: note: in included file:
   builtin:1:9: sparse: sparse: preprocessor token __ATOMIC_ACQUIRE redefined
   builtin:0:0: sparse: this was the original definition
   builtin:1:9: sparse: sparse: preprocessor token __ATOMIC_SEQ_CST redefined
   builtin:0:0: sparse: this was the original definition
   builtin:1:9: sparse: sparse: preprocessor token __ATOMIC_ACQ_REL redefined
   builtin:0:0: sparse: this was the original definition
   builtin:1:9: sparse: sparse: preprocessor token __ATOMIC_RELEASE redefined
   builtin:0:0: sparse: this was the original definition
   fs/io_uring.c: note: in included file (through include/trace/trace_events.h, include/trace/define_trace.h, include/trace/events/io_uring.h):
   include/trace/events/io_uring.h:509:1: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] op_flags @@     got restricted __kernel_rwf_t const [usertype] rw_flags @@
   include/trace/events/io_uring.h:509:1: sparse:     expected unsigned int [usertype] op_flags
   include/trace/events/io_uring.h:509:1: sparse:     got restricted __kernel_rwf_t const [usertype] rw_flags
   fs/io_uring.c:3257:24: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected void [noderef] __user * @@     got struct io_buffer *[assigned] kbuf @@
   fs/io_uring.c:3257:24: sparse:     expected void [noderef] __user *
   fs/io_uring.c:3257:24: sparse:     got struct io_buffer *[assigned] kbuf
   fs/io_uring.c:4803:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct file *file @@     got struct file [noderef] __rcu * @@
   fs/io_uring.c:4803:14: sparse:     expected struct file *file
   fs/io_uring.c:4803:14: sparse:     got struct file [noderef] __rcu *
   fs/io_uring.c:5637:37: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] result @@     got restricted __poll_t @@
   fs/io_uring.c:5637:37: sparse:     expected unsigned int [usertype] result
   fs/io_uring.c:5637:37: sparse:     got restricted __poll_t
   fs/io_uring.c:5642:71: sparse: sparse: restricted __poll_t degrades to integer
   fs/io_uring.c:5642:65: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted __poll_t [usertype] val @@     got unsigned int @@
   fs/io_uring.c:5642:65: sparse:     expected restricted __poll_t [usertype] val
   fs/io_uring.c:5642:65: sparse:     got unsigned int
   fs/io_uring.c:5642:52: sparse: sparse: incorrect type in initializer (different base types) @@     expected restricted __poll_t [usertype] mask @@     got unsigned short @@
   fs/io_uring.c:5642:52: sparse:     expected restricted __poll_t [usertype] mask
   fs/io_uring.c:5642:52: sparse:     got unsigned short
   fs/io_uring.c:5646:71: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected signed int [usertype] res @@     got restricted __poll_t [usertype] mask @@
   fs/io_uring.c:5646:71: sparse:     expected signed int [usertype] res
   fs/io_uring.c:5646:71: sparse:     got restricted __poll_t [usertype] mask
   fs/io_uring.c:5676:66: sparse: sparse: restricted __poll_t degrades to integer
   fs/io_uring.c:5676:55: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted __poll_t [usertype] val @@     got unsigned int @@
   fs/io_uring.c:5676:55: sparse:     expected restricted __poll_t [usertype] val
   fs/io_uring.c:5676:55: sparse:     got unsigned int
   fs/io_uring.c:5778:40: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected int mask @@     got restricted __poll_t [usertype] mask @@
   fs/io_uring.c:5778:40: sparse:     expected int mask
   fs/io_uring.c:5778:40: sparse:     got restricted __poll_t [usertype] mask
   fs/io_uring.c:5865:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted __poll_t [assigned] [usertype] mask @@
   fs/io_uring.c:5865:24: sparse:     expected int
   fs/io_uring.c:5865:24: sparse:     got restricted __poll_t [assigned] [usertype] mask
   fs/io_uring.c:5882:40: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected int mask @@     got restricted __poll_t [assigned] [usertype] mask @@
   fs/io_uring.c:5882:40: sparse:     expected int mask
   fs/io_uring.c:5882:40: sparse:     got restricted __poll_t [assigned] [usertype] mask
   fs/io_uring.c:5918:25: sparse: sparse: restricted __poll_t degrades to integer
   fs/io_uring.c:5918:48: sparse: sparse: incorrect type in initializer (different base types) @@     expected restricted __poll_t [usertype] mask @@     got unsigned int @@
   fs/io_uring.c:5918:48: sparse:     expected restricted __poll_t [usertype] mask
   fs/io_uring.c:5918:48: sparse:     got unsigned int
   fs/io_uring.c:5927:22: sparse: sparse: invalid assignment: |=
   fs/io_uring.c:5927:22: sparse:    left side has type restricted __poll_t
   fs/io_uring.c:5927:22: sparse:    right side has type int
   fs/io_uring.c:5932:30: sparse: sparse: invalid assignment: &=
   fs/io_uring.c:5932:30: sparse:    left side has type restricted __poll_t
   fs/io_uring.c:5932:30: sparse:    right side has type int
   fs/io_uring.c:5934:22: sparse: sparse: invalid assignment: |=
   fs/io_uring.c:5934:22: sparse:    left side has type restricted __poll_t
   fs/io_uring.c:5934:22: sparse:    right side has type int
   fs/io_uring.c:5950:33: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected int mask @@     got restricted __poll_t [usertype] mask @@
   fs/io_uring.c:5950:33: sparse:     expected int mask
   fs/io_uring.c:5950:33: sparse:     got restricted __poll_t [usertype] mask
   fs/io_uring.c:5950:50: sparse: sparse: incorrect type in argument 6 (different base types) @@     expected int events @@     got restricted __poll_t [usertype] events @@
   fs/io_uring.c:5950:50: sparse:     expected int events
   fs/io_uring.c:5950:50: sparse:     got restricted __poll_t [usertype] events
   fs/io_uring.c:6031:24: sparse: sparse: invalid assignment: |=
   fs/io_uring.c:6031:24: sparse:    left side has type unsigned int
   fs/io_uring.c:6031:24: sparse:    right side has type restricted __poll_t
   fs/io_uring.c:6032:65: sparse: sparse: restricted __poll_t degrades to integer
   fs/io_uring.c:6032:29: sparse: sparse: restricted __poll_t degrades to integer
   fs/io_uring.c:6032:38: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted __poll_t @@     got unsigned int @@
   fs/io_uring.c:6032:38: sparse:     expected restricted __poll_t
   fs/io_uring.c:6032:38: sparse:     got unsigned int
   fs/io_uring.c:6122:43: sparse: sparse: invalid assignment: &=
   fs/io_uring.c:6122:43: sparse:    left side has type restricted __poll_t
   fs/io_uring.c:6122:43: sparse:    right side has type int
   fs/io_uring.c:6123:62: sparse: sparse: restricted __poll_t degrades to integer
   fs/io_uring.c:6123:43: sparse: sparse: invalid assignment: |=
   fs/io_uring.c:6123:43: sparse:    left side has type restricted __poll_t
   fs/io_uring.c:6123:43: sparse:    right side has type unsigned int
>> fs/io_uring.c:7840:17: sparse: sparse: incompatible types in comparison expression (different signedness):
>> fs/io_uring.c:7840:17: sparse:    signed long long *
>> fs/io_uring.c:7840:17: sparse:    unsigned long long [usertype] *
   fs/io_uring.c:2294:17: sparse: sparse: context imbalance in 'handle_prev_tw_list' - different lock contexts for basic block
   fs/io_uring.c:8293:9: sparse: sparse: context imbalance in 'io_sq_thread_unpark' - wrong count at exit
   fs/io_uring.c:8304:9: sparse: sparse: context imbalance in 'io_sq_thread_park' - wrong count at exit

vim +7840 fs/io_uring.c

  7826	
  7827	#ifdef CONFIG_NET_RX_BUSY_POLL
  7828	static void io_adjust_busy_loop_timeout(struct timespec64 *ts,
  7829						struct io_wait_queue *iowq)
  7830	{
  7831		unsigned busy_poll_to = READ_ONCE(sysctl_net_busy_poll);
  7832		struct timespec64 pollto = ns_to_timespec64(1000 * (s64)busy_poll_to);
  7833	
  7834		if (timespec64_compare(ts, &pollto) > 0) {
  7835			*ts = timespec64_sub(*ts, pollto);
  7836			iowq->busy_poll_to = busy_poll_to;
  7837		} else {
  7838			s64 to = timespec64_to_ns(ts);
  7839	
> 7840			do_div(to, 1000);
  7841			iowq->busy_poll_to = to;
  7842			ts->tv_sec = 0;
  7843			ts->tv_nsec = 0;
  7844		}
  7845	}
  7846	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
