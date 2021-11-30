Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927BE462A35
	for <lists+io-uring@lfdr.de>; Tue, 30 Nov 2021 03:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbhK3CMq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 21:12:46 -0500
Received: from mga05.intel.com ([192.55.52.43]:4077 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231473AbhK3CMq (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 29 Nov 2021 21:12:46 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="322362256"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="322362256"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 18:09:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="499570512"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 29 Nov 2021 18:09:26 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mrsaD-000Cc9-PE; Tue, 30 Nov 2021 02:09:25 +0000
Date:   Tue, 30 Nov 2021 10:09:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, shr@fb.com
Subject: Re: [PATCH v1 1/5] fs: make user_path_at_empty() take a struct
 filename
Message-ID: <202111301052.fMLJlgVf-lkp@intel.com>
References: <20211129221257.2536146-2-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129221257.2536146-2-shr@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Stefan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on c2626d30f312afc341158e07bf088f5a23b4eeeb]

url:    https://github.com/0day-ci/linux/commits/Stefan-Roesch/io_uring-add-xattr-support/20211130-061448
base:   c2626d30f312afc341158e07bf088f5a23b4eeeb
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20211130/202111301052.fMLJlgVf-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/01c97d7409d5384e3cb760a9a99fa0c61899fc18
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Stefan-Roesch/io_uring-add-xattr-support/20211130-061448
        git checkout 01c97d7409d5384e3cb760a9a99fa0c61899fc18
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "getname_flags" [fs/ocfs2/ocfs2.ko] undefined!
ERROR: modpost: "getname_flags" [fs/xfs/xfs.ko] undefined!
>> ERROR: modpost: "getname_flags" [fs/coda/coda.ko] undefined!

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
