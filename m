Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08DA6CCA0E
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 20:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjC1SfX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 14:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC1SfW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 14:35:22 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E42F19F;
        Tue, 28 Mar 2023 11:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680028521; x=1711564521;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=BeQ/zO5tBpJqenzqiAW7Jszl5ERiiqTZmgr4aBbjDak=;
  b=cJy576AaUPg6PMzHDIsEV9cdt1nUQ0rW6h8HKA8+hJJE1u9LkPV3GbIj
   iL/3N8YyUttTNKGvKYLXTVXG1gFXKmOwdkTVUKj8KuuHj6t7QQsoPed17
   HuF4tpxno6aokp8G0jwFsMpZVpCoBO+3MVgwEhHoASPf3uVp3XFsswvSy
   YdYAW9uPm/gekDpzrOHsaIaue+T+MAPNqVztBJsR/X3AKh/MUT7ZtvVyU
   WyHyNPyiZDK4THrP/FNK9fVUperWXmgQqF7KihLQrrjBkxSNyNwTIsSMe
   2Vy5fafcg7Htrh1R0nNDPAvhyMUVbv/ooopzsfTInuShLcM1NDpTn2BgR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="342247521"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="342247521"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 11:35:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="773246016"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="773246016"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Mar 2023 11:35:17 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1phEA8-000Ior-2G;
        Tue, 28 Mar 2023 18:35:16 +0000
Date:   Wed, 29 Mar 2023 02:34:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-wireless@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        io-uring@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 a6faf7ea9fcb7267d06116d4188947f26e00e57e
Message-ID: <6423333e.lGUVMQXkx2DT8H2X%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: a6faf7ea9fcb7267d06116d4188947f26e00e57e  Add linux-next specific files for 20230328

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202303161521.jbGbaFjJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303281539.zzI4vpw1-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:351:13: warning: variable 'bw_needed' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:352:25: warning: variable 'link' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/legacy/ray_cs.c:628:17: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
drivers/perf/arm_pmuv3.c:44:2: error: use of undeclared identifier 'PERF_MAP_ALL_UNSUPPORTED'
drivers/perf/arm_pmuv3.c:59:2: error: use of undeclared identifier 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
drivers/perf/arm_pmuv3.c:61:13: error: use of undeclared identifier 'OP_READ'
drivers/perf/arm_pmuv3.c:61:25: error: use of undeclared identifier 'RESULT_ACCESS'
drivers/perf/arm_pmuv3.c:61:3: error: call to undeclared function 'C'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/perf/arm_pmuv3.c:61:5: error: use of undeclared identifier 'L1D'
drivers/perf/arm_pmuv3.c:62:25: error: use of undeclared identifier 'RESULT_MISS'
drivers/perf/arm_pmuv3.c:64:5: error: use of undeclared identifier 'L1I'
drivers/perf/arm_pmuv3.c:67:5: error: use of undeclared identifier 'DTLB'

Unverified Error/Warning (likely false positive, please contact us if interested):

arch/parisc/kernel/firmware.c:1271 pdc_soft_power_button_panic() error: uninitialized symbol 'flags'.
include/linux/gpio/consumer.h: linux/err.h is included more than once.
include/linux/gpio/driver.h: asm/bug.h is included more than once.
io_uring/io_uring.c:432 io_prep_async_work() error: we previously assumed 'req->file' could be null (see line 425)
io_uring/kbuf.c:221 __io_remove_buffers() warn: variable dereferenced before check 'bl->buf_ring' (see line 219)

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   `-- drivers-net-wireless-legacy-ray_cs.c:warning:strncpy-specified-bound-equals-destination-size
|-- alpha-randconfig-r012-20230327
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- arm-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   `-- drivers-net-wireless-legacy-ray_cs.c:warning:strncpy-specified-bound-equals-destination-size
|-- loongarch-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- loongarch-buildonly-randconfig-r001-20230326
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- loongarch-defconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- mips-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- parisc-randconfig-m031-20230326
|   |-- arch-parisc-kernel-firmware.c-pdc_soft_power_button_panic()-error:uninitialized-symbol-flags-.
|   |-- io_uring-io_uring.c-io_prep_async_work()-error:we-previously-assumed-req-file-could-be-null-(see-line-)
|   `-- io_uring-kbuf.c-__io_remove_buffers()-warn:variable-dereferenced-before-check-bl-buf_ring-(see-line-)
|-- parisc-randconfig-r025-20230326
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
clang_recent_errors
`-- arm-randconfig-r024-20230326
    |-- drivers-perf-arm_pmuv3.c:error:call-to-undeclared-function-C-ISO-C99-and-later-do-not-support-implicit-function-declarations
    |-- drivers-perf-arm_pmuv3.c:error:use-of-undeclared-identifier-DTLB
    |-- drivers-perf-arm_pmuv3.c:error:use-of-undeclared-identifier-L1D
    |-- drivers-perf-arm_pmuv3.c:error:use-of-undeclared-identifier-L1I
    |-- drivers-perf-arm_pmuv3.c:error:use-of-undeclared-identifier-OP_READ
    |-- drivers-perf-arm_pmuv3.c:error:use-of-undeclared-identifier-PERF_CACHE_MAP_ALL_UNSUPPORTED
    |-- drivers-perf-arm_pmuv3.c:error:use-of-undeclared-identifier-PERF_MAP_ALL_UNSUPPORTED
    |-- drivers-perf-arm_pmuv3.c:error:use-of-undeclared-identifier-RESULT_ACCESS
    `-- drivers-perf-arm_pmuv3.c:error:use-of-undeclared-identifier-RESULT_MISS

elapsed time: 829m

configs tested: 123
configs skipped: 13

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r003-20230326   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r005-20230326   gcc  
alpha                randconfig-r012-20230327   gcc  
alpha                randconfig-r013-20230326   gcc  
alpha                randconfig-r015-20230327   gcc  
alpha                randconfig-r016-20230326   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r001-20230327   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r002-20230326   gcc  
arc                  randconfig-r043-20230326   gcc  
arc                  randconfig-r043-20230327   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r003-20230327   clang
arm                  randconfig-r011-20230326   clang
arm                  randconfig-r046-20230326   clang
arm                  randconfig-r046-20230327   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky         buildonly-randconfig-r004-20230327   gcc  
csky                                defconfig   gcc  
hexagon              randconfig-r015-20230326   clang
hexagon              randconfig-r041-20230326   clang
hexagon              randconfig-r041-20230327   clang
hexagon              randconfig-r045-20230326   clang
hexagon              randconfig-r045-20230327   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230327   gcc  
i386                 randconfig-a002-20230327   gcc  
i386                 randconfig-a003-20230327   gcc  
i386                 randconfig-a004-20230327   gcc  
i386                 randconfig-a005-20230327   gcc  
i386                 randconfig-a006-20230327   gcc  
i386                 randconfig-a011-20230327   clang
i386                 randconfig-a012-20230327   clang
i386                 randconfig-a013-20230327   clang
i386                 randconfig-a014-20230327   clang
i386                 randconfig-a015-20230327   clang
i386                 randconfig-a016-20230327   clang
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r005-20230327   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch    buildonly-randconfig-r001-20230326   gcc  
loongarch    buildonly-randconfig-r006-20230326   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r012-20230326   gcc  
loongarch            randconfig-r024-20230326   gcc  
loongarch            randconfig-r036-20230328   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r001-20230326   gcc  
m68k                 randconfig-r016-20230327   gcc  
microblaze   buildonly-randconfig-r004-20230326   gcc  
microblaze           randconfig-r026-20230326   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips         buildonly-randconfig-r002-20230326   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r023-20230327   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r004-20230326   gcc  
parisc               randconfig-r021-20230326   gcc  
parisc               randconfig-r022-20230327   gcc  
parisc               randconfig-r025-20230326   gcc  
parisc               randconfig-r033-20230328   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r006-20230326   clang
powerpc              randconfig-r031-20230328   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r042-20230326   gcc  
riscv                randconfig-r042-20230327   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r013-20230327   clang
s390                 randconfig-r024-20230327   clang
s390                 randconfig-r044-20230326   gcc  
s390                 randconfig-r044-20230327   clang
sh                               allmodconfig   gcc  
sh                   randconfig-r002-20230327   gcc  
sh                   randconfig-r006-20230327   gcc  
sh                   randconfig-r023-20230326   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r001-20230327   gcc  
sparc                randconfig-r011-20230327   gcc  
sparc                randconfig-r014-20230326   gcc  
sparc                randconfig-r021-20230327   gcc  
sparc                randconfig-r026-20230327   gcc  
sparc64      buildonly-randconfig-r002-20230327   gcc  
sparc64      buildonly-randconfig-r005-20230327   gcc  
sparc64              randconfig-r003-20230326   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230327   gcc  
x86_64               randconfig-a002-20230327   gcc  
x86_64               randconfig-a003-20230327   gcc  
x86_64               randconfig-a004-20230327   gcc  
x86_64               randconfig-a005-20230327   gcc  
x86_64               randconfig-a006-20230327   gcc  
x86_64               randconfig-a011-20230327   clang
x86_64               randconfig-a012-20230327   clang
x86_64               randconfig-a013-20230327   clang
x86_64               randconfig-a014-20230327   clang
x86_64               randconfig-a015-20230327   clang
x86_64               randconfig-a016-20230327   clang
x86_64                               rhel-8.3   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
