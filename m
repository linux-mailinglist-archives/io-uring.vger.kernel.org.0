Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA465AB4A8
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 17:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbiIBPHD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 11:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237112AbiIBPGo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 11:06:44 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC69D24BD9;
        Fri,  2 Sep 2022 07:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662129369; x=1693665369;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+u/+M+GVB//IFa5mAG5/Nmm+r8/YO9vetau5dx989Ow=;
  b=MPspPPsVy/aBM33UOV3ueo64K2AO+oAq/8Ell7CPs3p2DEJq09Ndji+3
   QeEc3XlDhLqf93u4nIRKFTFgI8yaMXnltxXsHsNTdqcBu3uqYql75p9Bl
   pRJyWXD1Qv+qi9pHFGOsd/MYb1WHuM0qsBlPYagh1LcJGfqQANDK9N4po
   /5pv0ZoqlAlS/yO+FIXE9mVRUAMlBqg1k6zs142UMU8po2mRioPAMmpsv
   +gWNGlGAlvO7LeXHjLNtPRZ4n+tzjuqik/I2Sc+JDvBsWHhP0A3CtWg+1
   8nyhFoxhBrPNEzr1aHPIg/JOM/c1icfTG89qPc0zkfx53rVwy7Eb1aGpT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="279008759"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="279008759"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 07:34:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="702162187"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Sep 2022 07:34:53 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oU7ky-0000C3-2Y;
        Fri, 02 Sep 2022 14:34:52 +0000
Date:   Fri, 2 Sep 2022 22:34:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stefan Roesch <shr@fb.com>, kernel-team@fb.com,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org, shr@fb.com, axboe@kernel.dk,
        josef@toxicpanda.com
Subject: Re: [PATCH v1 09/10] btrfs: make balance_dirty_pages nowait
 compatible
Message-ID: <202209022236.e41DKuIt-lkp@intel.com>
References: <20220901225849.42898-10-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901225849.42898-10-shr@fb.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Stefan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on b90cb1053190353cc30f0fef0ef1f378ccc063c5]

url:    https://github.com/intel-lab-lkp/linux/commits/Stefan-Roesch/io-uring-btrfs-support-async-buffered-writes/20220902-070208
base:   b90cb1053190353cc30f0fef0ef1f378ccc063c5
config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20220902/202209022236.e41DKuIt-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/b24b542d1de60f99e6bfeb7971168c9a9bc8b7e4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Stefan-Roesch/io-uring-btrfs-support-async-buffered-writes/20220902-070208
        git checkout b24b542d1de60f99e6bfeb7971168c9a9bc8b7e4
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "balance_dirty_pages_ratelimited_flags" [fs/btrfs/btrfs.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
