Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0424D6CA7B4
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 16:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjC0Obk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 10:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjC0Obh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 10:31:37 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A560D9;
        Mon, 27 Mar 2023 07:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679927478; x=1711463478;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=V4HdO/wCXnZEq9bGSWy5icmFpkrtnY+w0QxMnsWGDjc=;
  b=nlbhjlUnfXDsa8/eBf1PWHxDDazy6ylYdhv0Z4UhaGbgSj+8Vs3UVMKV
   INwBvwwYIZ9XlvyGr79JcSGAOiYK7pQxbTg1yn33QMpLM0I43muyHSDHr
   gN/conZxCrDYD025VCFt7j8V9mdqXXatqkIyhsIXUXn/b1PgkVKwZruYD
   HPortibZ+Sj0orNuRYs6T3HTbUDrSZq2AuwsUR4l/bzR0Hzw6SG0TccUD
   x/sKxZ9bLpSujTK2LGAFra8UrgPStHSX/39uk8dlrkAgggUg6D0UzNbU4
   vz1RxPJledkstT1mSYnLNwMLGhZwr03W5rcYGrsD6362qi7fdfL5Zr0cW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="342680674"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="342680674"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 07:31:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="827051686"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="827051686"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 27 Mar 2023 07:31:14 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pgnsQ-000Hlu-03;
        Mon, 27 Mar 2023 14:31:14 +0000
Date:   Mon, 27 Mar 2023 22:30:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-wireless@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-gpio@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 011eb7443621f49ca1e8cdf9c74c215f25019118
Message-ID: <6421a899.CYoIodGi0EEt3iOT%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 011eb7443621f49ca1e8cdf9c74c215f25019118  Add linux-next specific files for 20230327

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202303082135.NjdX1Bij-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303161521.jbGbaFjJ-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:351:13: warning: variable 'bw_needed' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:352:25: warning: variable 'link' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:309:17: sparse:    int
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:309:17: sparse:    void
drivers/net/wireless/legacy/ray_cs.c:628:17: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
kernel/bpf/verifier.c:18485: undefined reference to `find_kallsyms_symbol_value'
verifier.c:(.text+0x1d110): undefined reference to `find_kallsyms_symbol_value'
verifier.c:(.text+0x37992): undefined reference to `find_kallsyms_symbol_value'

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/pinctrl/pinctrl-mlxbf3.c:162:20: sparse: sparse: symbol 'mlxbf3_pmx_funcs' was not declared. Should it be static?
drivers/s390/crypto/ap_bus.c:1596:20: error: initialization of 'ssize_t (*)(const struct bus_type *, char *)' {aka 'long int (*)(const struct bus_type *, char *)'} from incompatible pointer type 'ssize_t (*)(struct bus_type *, char *)' {aka 'long int (*)(struct bus_type *, char *)'} [-Werror=incompatible-pointer-types]
drivers/soc/fsl/qe/tsa.c:140:26: sparse: sparse: incorrect type in argument 2 (different address spaces)
drivers/soc/fsl/qe/tsa.c:150:27: sparse: sparse: incorrect type in argument 1 (different address spaces)
drivers/soc/fsl/qe/tsa.c:189:26: sparse: sparse: dereference of noderef expression
drivers/soc/fsl/qe/tsa.c:663:22: sparse: sparse: incorrect type in assignment (different address spaces)
drivers/soc/fsl/qe/tsa.c:673:21: sparse: sparse: incorrect type in assignment (different address spaces)
drivers/watchdog/imx2_wdt.c:442:22: sparse: sparse: symbol 'imx_wdt' was not declared. Should it be static?
drivers/watchdog/imx2_wdt.c:446:22: sparse: sparse: symbol 'imx_wdt_legacy' was not declared. Should it be static?
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
|-- alpha-randconfig-r001-20230327
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
|-- csky-randconfig-s043-20230326
|   `-- drivers-pinctrl-pinctrl-mlxbf3.c:sparse:sparse:symbol-mlxbf3_pmx_funcs-was-not-declared.-Should-it-be-static
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   `-- drivers-net-wireless-legacy-ray_cs.c:warning:strncpy-specified-bound-equals-destination-size
|-- ia64-buildonly-randconfig-r004-20230326
|   `-- kernel-bpf-verifier.c:undefined-reference-to-find_kallsyms_symbol_value
|-- ia64-randconfig-r003-20230326
|   `-- verifier.c:(.text):undefined-reference-to-find_kallsyms_symbol_value
|-- ia64-randconfig-s031-20230326
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:int
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   `-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:void
|-- loongarch-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- loongarch-defconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- microblaze-randconfig-s042-20230326
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:dereference-of-noderef-expression
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void-noderef-__iomem-addr
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-volatile-noderef-__iomem-addr-got-void-noderef-__iomem-addr
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-noderef-si_ram-got-void-noderef-__iomem
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-noderef-si_regs-got-void-noderef-__iomem

elapsed time: 721m

configs tested: 110
configs skipped: 10

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r001-20230327   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r024-20230326   gcc  
arc                  randconfig-r043-20230326   gcc  
arc                  randconfig-r043-20230327   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r002-20230327   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r023-20230326   clang
arm                  randconfig-r034-20230326   gcc  
arm                  randconfig-r036-20230327   clang
arm                  randconfig-r046-20230326   clang
arm                  randconfig-r046-20230327   gcc  
arm64                            allyesconfig   gcc  
arm64        buildonly-randconfig-r002-20230326   clang
arm64                               defconfig   gcc  
arm64                randconfig-r026-20230326   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r005-20230326   gcc  
csky                 randconfig-r033-20230326   gcc  
hexagon              randconfig-r002-20230326   clang
hexagon              randconfig-r024-20230327   clang
hexagon              randconfig-r041-20230326   clang
hexagon              randconfig-r041-20230327   clang
hexagon              randconfig-r045-20230326   clang
hexagon              randconfig-r045-20230327   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r006-20230327   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a006-20230327   gcc  
i386                 randconfig-a016-20230327   clang
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r003-20230326   gcc  
ia64                 randconfig-r022-20230326   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch    buildonly-randconfig-r005-20230327   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r016-20230327   gcc  
loongarch            randconfig-r021-20230326   gcc  
loongarch            randconfig-r023-20230327   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r003-20230327   gcc  
m68k         buildonly-randconfig-r004-20230326   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r036-20230326   gcc  
microblaze   buildonly-randconfig-r004-20230327   gcc  
microblaze   buildonly-randconfig-r005-20230326   gcc  
microblaze           randconfig-r005-20230327   gcc  
microblaze           randconfig-r032-20230327   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r031-20230326   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r012-20230327   gcc  
nios2                randconfig-r015-20230327   gcc  
openrisc             randconfig-r001-20230326   gcc  
openrisc             randconfig-r026-20230327   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                      ppc44x_defconfig   clang
powerpc                      ppc6xx_defconfig   gcc  
powerpc              randconfig-r006-20230326   clang
powerpc              randconfig-r025-20230326   gcc  
powerpc              randconfig-r032-20230326   clang
powerpc                     tqm8541_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r001-20230326   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r011-20230327   clang
riscv                randconfig-r033-20230327   gcc  
riscv                randconfig-r042-20230326   gcc  
riscv                randconfig-r042-20230327   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r044-20230326   gcc  
s390                 randconfig-r044-20230327   clang
sh                               allmodconfig   gcc  
sh                   randconfig-r006-20230327   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r031-20230327   gcc  
sparc64              randconfig-r003-20230327   gcc  
sparc64              randconfig-r004-20230326   gcc  
sparc64              randconfig-r004-20230327   gcc  
sparc64              randconfig-r013-20230327   gcc  
sparc64              randconfig-r035-20230326   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230327   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a006-20230327   gcc  
x86_64               randconfig-a016-20230327   clang
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r006-20230326   gcc  
xtensa               randconfig-r021-20230327   gcc  
xtensa               randconfig-r022-20230327   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
