Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFCC5B2C4B
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 04:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiIIC5t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 22:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiIIC5s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 22:57:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E329C98A6B;
        Thu,  8 Sep 2022 19:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662692268; x=1694228268;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GYQjXMogk3Q/eRyj0b2IEL6FDeWTskgZLPR8V3YfuB4=;
  b=V5r7T4/bELCHZtnCSfJyBuH/wuTqnbt/Rs+T46zYZVmFqexWZ+TBRDB9
   guaLK6Oy8qPehrPVTYCY5TRyNy584e3PTem+UU53OX5aalQ/5WPNYVwB5
   c7QcLyj9vwf8G/7CV3UjvF3lywBNGNKVb7JnaFv/JTAYiY5B8wGuKo7Vn
   HuEOaVD4yJdwontRgSZR8/RIZ7DL4vb/UOo2mrOxzSUYNwh6co/KzxZR5
   JVjUASsTOQrG/DL8Yn0iU+yDt0CgpYh4OMQzlo0Gemjpo/zxZlROUs2x5
   YwwaCSwKiobsMqs0Psqohk4uaxQcOt+dXuBp6ca/SmnuvwyqnwYDX+FOx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298183684"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298183684"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 19:57:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="943610211"
Received: from lkp-server02.sh.intel.com (HELO b2938d2e5c5a) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 08 Sep 2022 19:57:44 -0700
Received: from kbuild by b2938d2e5c5a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWUD9-0000dR-2e;
        Fri, 09 Sep 2022 02:57:43 +0000
Date:   Fri, 9 Sep 2022 10:57:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, asml.silence@gmail.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH for-next v6 1/5] io_uring: add io_uring_cmd_import_fixed
Message-ID: <202209091034.1uWUabFo-lkp@intel.com>
References: <20220908183511.2253-2-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908183511.2253-2-joshi.k@samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Kanchan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.0-rc4 next-20220908]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchan-Joshi/io_uring-add-io_uring_cmd_import_fixed/20220909-033508
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220909/202209091034.1uWUabFo-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0b61830b28b6a720a99d34aba08d3d466fe516ec
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kanchan-Joshi/io_uring-add-io_uring_cmd_import_fixed/20220909-033508
        git checkout 0b61830b28b6a720a99d34aba08d3d466fe516ec
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/unix/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from net/unix/scm.c:11:
>> include/linux/io_uring.h:65:5: warning: no previous prototype for function 'io_uring_cmd_import_fixed' [-Wmissing-prototypes]
   int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
       ^
   include/linux/io_uring.h:65:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
   ^
   static 
   1 warning generated.


vim +/io_uring_cmd_import_fixed +65 include/linux/io_uring.h

    46	
    47	static inline void io_uring_files_cancel(void)
    48	{
    49		if (current->io_uring) {
    50			io_uring_unreg_ringfd();
    51			__io_uring_cancel(false);
    52		}
    53	}
    54	static inline void io_uring_task_cancel(void)
    55	{
    56		if (current->io_uring)
    57			__io_uring_cancel(true);
    58	}
    59	static inline void io_uring_free(struct task_struct *tsk)
    60	{
    61		if (tsk->io_uring)
    62			__io_uring_free(tsk);
    63	}
    64	#else
  > 65	int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
    66				      struct iov_iter *iter, void *ioucmd)
    67	{
    68		return -EOPNOTSUPP;
    69	}
    70	static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
    71			ssize_t ret2)
    72	{
    73	}
    74	static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
    75				void (*task_work_cb)(struct io_uring_cmd *))
    76	{
    77	}
    78	static inline struct sock *io_uring_get_socket(struct file *file)
    79	{
    80		return NULL;
    81	}
    82	static inline void io_uring_task_cancel(void)
    83	{
    84	}
    85	static inline void io_uring_files_cancel(void)
    86	{
    87	}
    88	static inline void io_uring_free(struct task_struct *tsk)
    89	{
    90	}
    91	static inline const char *io_uring_get_opcode(u8 opcode)
    92	{
    93		return "";
    94	}
    95	#endif
    96	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
