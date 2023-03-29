Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6665F6CECB9
	for <lists+io-uring@lfdr.de>; Wed, 29 Mar 2023 17:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjC2PXJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Mar 2023 11:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjC2PXI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Mar 2023 11:23:08 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4FB4202;
        Wed, 29 Mar 2023 08:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680103381; x=1711639381;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=ptksIPCBqJcaNVtPPwyP250IRCPyy9oaMGihhbuBLbg=;
  b=ePKlvhRNWFbIPO9lm0G7JgEJO7rXO4JPXAaZfXywle0BGjdr+WBnq40M
   /sRfRvszWMcSF5J5Zk/0aUtgZYy++MlyxQzo2i/1a+A6x31GSORmnlKEC
   zZS9Sc5bV53QSPIz0xiQ9BP0alLMutlZJNU70f/yG/hBquXrZwS/R3vLb
   E+MMqbZ4WfNKYMbuwIPK56Yvt3Tmcltn/iwciYuJGkkxAQa2u6N10ceuA
   aOHGKOIRItEn+WyZBYHw/g9kapnf2J9alkGP/qOadnA9h7QSwSbB3rBdz
   NN5Ak+ejbaWwJpGHPRHIuXzKuxbVZcoiDyTX77qJL8S1J8r6e68zFOogZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="368679511"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="368679511"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 08:22:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="716912773"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="716912773"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2023 08:21:57 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1phXca-000Jf0-1i;
        Wed, 29 Mar 2023 15:21:56 +0000
Date:   Wed, 29 Mar 2023 23:21:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     virtualization@lists.linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-wireless@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-clk@vger.kernel.org, io-uring@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 198925fae644b0099b66fac1d972721e6e563b17
Message-ID: <64245763.70Rd23mcjZbCPFF8%lkp@intel.com>
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
branch HEAD: 198925fae644b0099b66fac1d972721e6e563b17  Add linux-next specific files for 20230329

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202303082135.NjdX1Bij-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303161521.jbGbaFjJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303291916.ovLFJk2i-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/base/power/domain.c:3090:23: error: 'struct dev_pm_info' has no member named 'runtime_error'
drivers/base/power/domain.c:3092:28: error: 'struct dev_pm_info' has no member named 'disable_depth'
drivers/base/power/domain.c:3094:28: error: 'struct dev_pm_info' has no member named 'runtime_status'
drivers/base/power/domain.c:654:20: error: 'pm_wq' undeclared (first use in this function)
drivers/base/power/domain.c:853:39: error: 'struct dev_pm_info' has no member named 'ignore_children'
drivers/base/power/domain_governor.c:85:24: error: 'struct dev_pm_info' has no member named 'ignore_children'
drivers/clk/clk-sp7021.c:316:8: warning: result of comparison of constant 18446744073709551615 with expression of type 'typeof (_Generic((_m), char: (unsigned char)0, unsigned char: (unsigned char)0, signed char: (unsigned char)0, unsigned short: (unsigned short)0, short: (unsigned short)0, unsigned int: (unsigned int)0, int: (unsigned int)0, unsigned long: (unsigned long)0, long: (unsigned long)0, unsigned long long: (unsigned long long)0, long long: (unsigned long long)0, default: (_m)))' (aka 'unsigned int') is always false [-Wtautological-constant-out-of-range-compare]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:351:13: warning: variable 'bw_needed' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:352:25: warning: variable 'link' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:309:17: sparse:    int
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:309:17: sparse:    void
drivers/net/wireless/legacy/ray_cs.c:628:17: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/pinctrl/pinctrl-mlxbf3.c:162:20: sparse: sparse: symbol 'mlxbf3_pmx_funcs' was not declared. Should it be static?
drivers/soc/fsl/qe/tsa.c:140:26: sparse: sparse: incorrect type in argument 2 (different address spaces)
drivers/soc/fsl/qe/tsa.c:140:9: sparse: sparse: incorrect type in argument 2 (different address spaces)
drivers/soc/fsl/qe/tsa.c:150:16: sparse: sparse: incorrect type in argument 1 (different address spaces)
drivers/soc/fsl/qe/tsa.c:150:27: sparse: sparse: incorrect type in argument 1 (different address spaces)
drivers/soc/fsl/qe/tsa.c:189:26: sparse: sparse: dereference of noderef expression
drivers/soc/fsl/qe/tsa.c:663:22: sparse: sparse: incorrect type in assignment (different address spaces)
drivers/soc/fsl/qe/tsa.c:673:21: sparse: sparse: incorrect type in assignment (different address spaces)
drivers/virtio/virtio_ring.c:2784:3: warning: Value stored to 'err' is never read [clang-analyzer-deadcode.DeadStores]
drivers/watchdog/imx2_wdt.c:442:22: sparse: sparse: symbol 'imx_wdt' was not declared. Should it be static?
drivers/watchdog/imx2_wdt.c:446:22: sparse: sparse: symbol 'imx_wdt_legacy' was not declared. Should it be static?
include/linux/gpio/consumer.h: linux/err.h is included more than once.
include/linux/gpio/driver.h: asm/bug.h is included more than once.
io_uring/io_uring.c:432 io_prep_async_work() error: we previously assumed 'req->file' could be null (see line 425)
io_uring/kbuf.c:221 __io_remove_buffers() warn: variable dereferenced before check 'bl->buf_ring' (see line 219)
net/mac80211/mesh_pathtbl.c:616:24: warning: Value stored to 'cache' during its initialization is never read [clang-analyzer-deadcode.DeadStores]

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   `-- drivers-net-wireless-legacy-ray_cs.c:warning:strncpy-specified-bound-equals-destination-size
|-- alpha-randconfig-r021-20230326
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- arc-randconfig-r043-20230328
|   |-- drivers-base-power-domain.c:error:pm_wq-undeclared-(first-use-in-this-function)
|   |-- drivers-base-power-domain.c:error:struct-dev_pm_info-has-no-member-named-disable_depth
|   |-- drivers-base-power-domain.c:error:struct-dev_pm_info-has-no-member-named-ignore_children
|   |-- drivers-base-power-domain.c:error:struct-dev_pm_info-has-no-member-named-runtime_error
|   |-- drivers-base-power-domain.c:error:struct-dev_pm_info-has-no-member-named-runtime_status
|   `-- drivers-base-power-domain_governor.c:error:struct-dev_pm_info-has-no-member-named-ignore_children
|-- arc-randconfig-s032-20230329
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:int
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:void
|   |-- drivers-pinctrl-pinctrl-mlxbf3.c:sparse:sparse:symbol-mlxbf3_pmx_funcs-was-not-declared.-Should-it-be-static
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:dereference-of-noderef-expression
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void-noderef-__iomem-addr
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-volatile-noderef-__iomem-addr-got-void-noderef-__iomem-addr
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-noderef-si_ram-got-void-noderef-__iomem
|   `-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-noderef-si_regs-got-void-noderef-__iomem
|-- arm-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- arm64-randconfig-r031-20230327
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
clang_recent_errors
|-- powerpc-randconfig-r036-20230326
|   `-- drivers-clk-clk-sp7021.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((_m)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(unsigned-char)-unsigned-
`-- riscv-randconfig-c006-20230326
    |-- drivers-virtio-virtio_ring.c:warning:Value-stored-to-err-is-never-read-clang-analyzer-deadcode.DeadStores
    `-- net-mac80211-mesh_pathtbl.c:warning:Value-stored-to-cache-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores

elapsed time: 722m

configs tested: 142
configs skipped: 11

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r021-20230326   gcc  
alpha                randconfig-r024-20230327   gcc  
alpha                randconfig-r032-20230327   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r001-20230326   gcc  
arc                  randconfig-r012-20230326   gcc  
arc                  randconfig-r025-20230327   gcc  
arc                  randconfig-r034-20230329   gcc  
arc                  randconfig-r043-20230327   gcc  
arc                  randconfig-r043-20230328   gcc  
arc                  randconfig-r043-20230329   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r033-20230326   gcc  
arm                  randconfig-r046-20230327   gcc  
arm                  randconfig-r046-20230329   gcc  
arm                             rpc_defconfig   gcc  
arm                       spear13xx_defconfig   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r031-20230327   gcc  
arm64                randconfig-r035-20230329   gcc  
csky                                defconfig   gcc  
hexagon              randconfig-r005-20230326   clang
hexagon              randconfig-r013-20230327   clang
hexagon              randconfig-r021-20230327   clang
hexagon              randconfig-r023-20230327   clang
hexagon              randconfig-r041-20230329   clang
hexagon              randconfig-r045-20230327   clang
hexagon              randconfig-r045-20230329   clang
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
ia64                 randconfig-r004-20230326   gcc  
ia64                 randconfig-r031-20230326   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r012-20230327   gcc  
loongarch            randconfig-r021-20230329   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r002-20230329   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r022-20230326   gcc  
m68k                 randconfig-r035-20230327   gcc  
microblaze           randconfig-r006-20230326   gcc  
microblaze           randconfig-r016-20230327   gcc  
microblaze           randconfig-r023-20230329   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r002-20230326   gcc  
mips                 randconfig-r002-20230327   clang
mips                 randconfig-r034-20230326   gcc  
nios2        buildonly-randconfig-r003-20230329   gcc  
nios2        buildonly-randconfig-r006-20230327   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r006-20230327   gcc  
nios2                randconfig-r015-20230327   gcc  
nios2                randconfig-r023-20230326   gcc  
openrisc             randconfig-r032-20230329   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r001-20230327   gcc  
parisc               randconfig-r022-20230329   gcc  
parisc               randconfig-r025-20230329   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r034-20230327   gcc  
powerpc              randconfig-r036-20230326   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r025-20230326   gcc  
riscv                randconfig-r031-20230329   gcc  
riscv                randconfig-r042-20230326   gcc  
riscv                randconfig-r042-20230327   clang
riscv                randconfig-r042-20230329   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390         buildonly-randconfig-r004-20230327   clang
s390                                defconfig   gcc  
s390                 randconfig-r015-20230326   gcc  
s390                 randconfig-r026-20230329   clang
s390                 randconfig-r044-20230328   gcc  
s390                 randconfig-r044-20230329   clang
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r005-20230326   gcc  
sh                            hp6xx_defconfig   gcc  
sh                   randconfig-r011-20230327   gcc  
sh                   randconfig-r024-20230329   gcc  
sh                   randconfig-r026-20230326   gcc  
sh                   randconfig-r032-20230326   gcc  
sh                           se7724_defconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r004-20230327   gcc  
sparc                randconfig-r016-20230326   gcc  
sparc                randconfig-r035-20230326   gcc  
sparc                randconfig-r036-20230327   gcc  
sparc64      buildonly-randconfig-r005-20230329   gcc  
sparc64      buildonly-randconfig-r006-20230329   gcc  
sparc64              randconfig-r005-20230327   gcc  
sparc64              randconfig-r033-20230329   gcc  
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
x86_64               randconfig-r003-20230327   gcc  
x86_64               randconfig-r014-20230327   clang
x86_64                               rhel-8.3   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
