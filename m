Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5DB5B2D51
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 06:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiIIETz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 00:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiIIETw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 00:19:52 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FCB1F60E;
        Thu,  8 Sep 2022 21:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662697190; x=1694233190;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eSrNIJmzCvQPmppednT9KsYGtdgqhbjbMBSL7ABNuFE=;
  b=L3tlBXr7y/clvetqJDhsc3Bh3qdsPD/zzOxzl81dtZ6mYUr/OqxpkbK6
   0yAV8Yw0GH2mTWXdN57gaCX0sq7eU/WlhTUq2Hbo+se82sI18HFrAyyQc
   3xPMVpt7HJi0FZW1ljrAbR9Fxdu754L29TaI055yq+Sw7ZHQXnIGPGDGi
   SvEVk46yRlJ2Ox/BCGR6C0SCptfTBNENNVlzR+XTnmUNaQdTFNtYJtbKQ
   dhLImmkwzrnjSE6Kv9fptJDvL94XdlkfFukNWRYl6ao1rfoEXYQqeFVhn
   wWfDJgKwnEqQraXEhzLCbDsa94VqCd5R1VPdSS6mUfNOVf0kVSo3C+U4Q
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="277125911"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="277125911"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 21:19:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="704273208"
Received: from lkp-server02.sh.intel.com (HELO b2938d2e5c5a) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Sep 2022 21:19:47 -0700
Received: from kbuild by b2938d2e5c5a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWVUY-0000i7-1P;
        Fri, 09 Sep 2022 04:19:46 +0000
Date:   Fri, 9 Sep 2022 12:19:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, asml.silence@gmail.com
Cc:     kbuild-all@lists.01.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH for-next v6 1/5] io_uring: add io_uring_cmd_import_fixed
Message-ID: <202209091233.3r9bDGWS-lkp@intel.com>
References: <20220908183511.2253-2-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908183511.2253-2-joshi.k@samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Kanchan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on axboe-block/for-next]
[also build test ERROR on linus/master v6.0-rc4 next-20220908]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchan-Joshi/io_uring-add-io_uring_cmd_import_fixed/20220909-033508
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: riscv-nommu_virt_defconfig (https://download.01.org/0day-ci/archive/20220909/202209091233.3r9bDGWS-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0b61830b28b6a720a99d34aba08d3d466fe516ec
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kanchan-Joshi/io_uring-add-io_uring_cmd_import_fixed/20220909-033508
        git checkout 0b61830b28b6a720a99d34aba08d3d466fe516ec
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   riscv64-linux-ld: kernel/exit.o: in function `io_uring_cmd_import_fixed':
>> exit.c:(.text+0x642): multiple definition of `io_uring_cmd_import_fixed'; kernel/fork.o:fork.c:(.text+0x6e8): first defined here
   riscv64-linux-ld: fs/exec.o: in function `io_uring_cmd_import_fixed':
   exec.c:(.text+0xc6e): multiple definition of `io_uring_cmd_import_fixed'; kernel/fork.o:fork.c:(.text+0x6e8): first defined here

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
