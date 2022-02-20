Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4855F4BD220
	for <lists+io-uring@lfdr.de>; Sun, 20 Feb 2022 22:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241496AbiBTVyT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Feb 2022 16:54:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238095AbiBTVyS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Feb 2022 16:54:18 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BC7433BE;
        Sun, 20 Feb 2022 13:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645394037; x=1676930037;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OvZacn+75grqTdxisrO7o848PoTXuiF8srTholpZHMg=;
  b=GnBHQzMn5uGMckzAyG7N25zAjFojAk5om+u9ULLoSIqrvw4KQkwihQg9
   wk+q5TmiqZcJ6yZrcBEW5Yypsp2vhhlkDxrxX4Xoq2M7Ea/6zEgBmUdpi
   T1BLhpnYvVXWhFgkpUHeopYaYyTIrXFJ2JwFj//f/b2ZnjeTn4IIa1bI9
   wwxCpgY/+XCkKBH34Gr7Xv72EbT+5q0TzF6TdRXqlC0g3MKC2o7Ox1db9
   L1rueMyFzueL5UnepoPd8Q6ddf+IBptfmuTZPuWhhsI1sEBXDVTzYALQD
   ++udqvvYpEVDwDxxK/Xp+sPEhX/SZkyaA777zSFlDR0RsUOw3cnZpnp2j
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="251351811"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="251351811"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 13:53:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="627182313"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Feb 2022 13:53:54 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLu9R-0000tZ-UX; Sun, 20 Feb 2022 21:53:53 +0000
Date:   Mon, 21 Feb 2022 05:53:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     kbuild-all@lists.01.org, Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] io_uring: Add support for napi_busy_poll
Message-ID: <202202210549.F7sXEkKs-lkp@intel.com>
References: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Olivier,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.17-rc4]
[cannot apply to next-20220217]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Olivier-Langlois/io_uring-Add-support-for-napi_busy_poll/20220220-190634
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 4f12b742eb2b3a850ac8be7dc4ed52976fc6cb0b
config: riscv-randconfig-r042-20220220 (https://download.01.org/0day-ci/archive/20220221/202202210549.F7sXEkKs-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/ad36ae938f354b0cd3b38716572385f710accdb0
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Olivier-Langlois/io_uring-Add-support-for-napi_busy_poll/20220220-190634
        git checkout ad36ae938f354b0cd3b38716572385f710accdb0
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   riscv32-linux-ld: fs/io_uring.o: in function `.L0 ':
>> io_uring.c:(.text+0x8d04): undefined reference to `__divdi3'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
