Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98916C3671
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 17:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjCUQA7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Mar 2023 12:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbjCUQA5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Mar 2023 12:00:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075821A7;
        Tue, 21 Mar 2023 09:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679414451; x=1710950451;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=wR+qOUFezBzfBJcOKdG10nv4u1T4zv+Wyk0SxjOOgKo=;
  b=PSfJYPrDMPv+xP7VxzHbDq3yu/dwSZAPbl34RnnHX7NQFmGxfs2zj7eT
   z/Gv/Az8ePZT5aBmbaeNIfyFvoK2jQRcebKnV8KjgM990CWsKi9oi1DYN
   i421K0kv0ex8Zl4jdhQSjgvsm1pWM9xBwK4KwRZFBvMx8gKUXimaMetbG
   1i9p7GsDgueupJh8FVduuxRT+eP6RRsh7j7KpUFRLoetAZnQ0FuzWm5GW
   eS/18/oG4KSRs+GzoFwG2QWI1ZHRj6Ll+FFyma9hqvu/htbLN6Xhdvahw
   b7I3NkQHsGdg82Trib8qjpRkczY8G4znwuDZf5NFcTHSPcH7+Hh9R67ro
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="339018618"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="339018618"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 09:00:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="825003199"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="825003199"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 21 Mar 2023 09:00:43 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1peePd-000C79-1U;
        Tue, 21 Mar 2023 16:00:37 +0000
Date:   Wed, 22 Mar 2023 00:00:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     rcu@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-modules@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 f3594f0204b756638267242e26d9de611435c3ba
Message-ID: <6419d481.N8bGPVo0VkImpoue%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: f3594f0204b756638267242e26d9de611435c3ba  Add linux-next specific files for 20230321

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202303082135.NjdX1Bij-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303161521.jbGbaFjJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303190142.TjYYpbba-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303211332.MILzGUKQ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303212204.3G5mRatJ-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Warning: MAINTAINERS references a file that doesn't exist: Documentation/ABI/obsolete/sysfs-selinux-checkreqprot
Warning: MAINTAINERS references a file that doesn't exist: Documentation/ABI/obsolete/sysfs-selinux-disable
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:309:17: sparse:    int
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:309:17: sparse:    void
drivers/gpu/drm/imx/lcdc/imx-lcdc.c:411:11: error: call to undeclared function 'devm_drm_of_get_bridge'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/gpu/drm/imx/lcdc/imx-lcdc.c:411:18: error: implicit declaration of function 'devm_drm_of_get_bridge' [-Werror=implicit-function-declaration]
drivers/gpu/drm/imx/lcdc/imx-lcdc.c:411:9: error: incompatible integer to pointer conversion assigning to 'struct drm_bridge *' from 'int' [-Wint-conversion]
drivers/gpu/drm/imx/lcdc/imx-lcdc.c:449:15: error: implicit declaration of function 'drm_bridge_attach' [-Werror=implicit-function-declaration]
drivers/gpu/drm/imx/lcdc/imx-lcdc.c:449:61: error: use of undeclared identifier 'DRM_BRIDGE_ATTACH_NO_CONNECTOR'
drivers/gpu/drm/imx/lcdc/imx-lcdc.c:449:68: error: 'DRM_BRIDGE_ATTACH_NO_CONNECTOR' undeclared (first use in this function)
drivers/gpu/drm/imx/lcdc/imx-lcdc.c:449:8: error: call to undeclared function 'drm_bridge_attach'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/net/wireless/legacy/ray_cs.c:628:17: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
include/linux/compiler_types.h:338:27: error: expression in static assertion is not an integer
include/linux/container_of.h:20:54: error: invalid use of undefined type 'struct module'
include/linux/rculist.h:392:21: error: invalid use of undefined type 'struct module'
include/linux/stddef.h:16:33: error: invalid use of undefined type 'struct module'
kernel/bpf/../module/internal.h:205:2: error: assigning to 'struct module *' from incompatible type 'void'
kernel/bpf/../module/internal.h:205:2: error: incomplete definition of type 'struct module'
kernel/bpf/../module/internal.h:205:2: error: offsetof of incomplete type 'typeof (*mod)' (aka 'struct module')
kernel/bpf/../module/internal.h:205:2: error: operand of type 'void' where arithmetic or pointer type is required

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/iommu/iommufd/selftest.c:295:21: sparse: sparse: symbol 'mock_iommu_device' was not declared. Should it be static?
drivers/soc/fsl/qe/tsa.c:140:26: sparse: sparse: incorrect type in argument 2 (different address spaces)
drivers/soc/fsl/qe/tsa.c:150:27: sparse: sparse: incorrect type in argument 1 (different address spaces)
drivers/soc/fsl/qe/tsa.c:189:26: sparse: sparse: dereference of noderef expression
drivers/soc/fsl/qe/tsa.c:663:22: sparse: sparse: incorrect type in assignment (different address spaces)
drivers/soc/fsl/qe/tsa.c:673:21: sparse: sparse: incorrect type in assignment (different address spaces)
drivers/watchdog/imx2_wdt.c:442:22: sparse: sparse: symbol 'imx_wdt' was not declared. Should it be static?
drivers/watchdog/imx2_wdt.c:446:22: sparse: sparse: symbol 'imx_wdt_legacy' was not declared. Should it be static?
io_uring/io_uring.c:432 io_prep_async_work() error: we previously assumed 'req->file' could be null (see line 425)
io_uring/kbuf.c:221 __io_remove_buffers() warn: variable dereferenced before check 'bl->buf_ring' (see line 219)

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   `-- drivers-net-wireless-legacy-ray_cs.c:warning:strncpy-specified-bound-equals-destination-size
|-- arc-randconfig-r043-20230319
|   |-- include-linux-compiler_types.h:error:expression-in-static-assertion-is-not-an-integer
|   |-- include-linux-container_of.h:error:invalid-use-of-undefined-type-struct-module
|   |-- include-linux-rculist.h:error:invalid-use-of-undefined-type-struct-module
|   `-- include-linux-stddef.h:error:invalid-use-of-undefined-type-struct-module
|-- arm64-randconfig-r035-20230319
|   |-- include-linux-compiler_types.h:error:expression-in-static-assertion-is-not-an-integer
|   |-- include-linux-container_of.h:error:invalid-use-of-undefined-type-struct-module
|   |-- include-linux-rculist.h:error:invalid-use-of-undefined-type-struct-module
|   `-- include-linux-stddef.h:error:invalid-use-of-undefined-type-struct-module
|-- ia64-allmodconfig
|   `-- drivers-net-wireless-legacy-ray_cs.c:warning:strncpy-specified-bound-equals-destination-size
|-- m68k-randconfig-r026-20230319
|   |-- drivers-gpu-drm-imx-lcdc-imx-lcdc.c:error:DRM_BRIDGE_ATTACH_NO_CONNECTOR-undeclared-(first-use-in-this-function)
|   |-- drivers-gpu-drm-imx-lcdc-imx-lcdc.c:error:implicit-declaration-of-function-devm_drm_of_get_bridge
|   `-- drivers-gpu-drm-imx-lcdc-imx-lcdc.c:error:implicit-declaration-of-function-drm_bridge_attach
|-- nios2-randconfig-r025-20230319
|   |-- include-linux-compiler_types.h:error:expression-in-static-assertion-is-not-an-integer
|   |-- include-linux-container_of.h:error:invalid-use-of-undefined-type-struct-module
|   |-- include-linux-rculist.h:error:invalid-use-of-undefined-type-struct-module
|   `-- include-linux-stddef.h:error:invalid-use-of-undefined-type-struct-module
|-- openrisc-randconfig-r031-20230319
|   |-- include-linux-compiler_types.h:error:expression-in-static-assertion-is-not-an-integer
|   |-- include-linux-container_of.h:error:invalid-use-of-undefined-type-struct-module
|   |-- include-linux-rculist.h:error:invalid-use-of-undefined-type-struct-module
|   `-- include-linux-stddef.h:error:invalid-use-of-undefined-type-struct-module
|-- parisc-randconfig-r022-20230319
|   |-- include-linux-compiler_types.h:error:expression-in-static-assertion-is-not-an-integer
|   |-- include-linux-container_of.h:error:invalid-use-of-undefined-type-struct-module
|   |-- include-linux-rculist.h:error:invalid-use-of-undefined-type-struct-module
|   `-- include-linux-stddef.h:error:invalid-use-of-undefined-type-struct-module
|-- parisc64-allmodconfig
|   `-- drivers-net-wireless-legacy-ray_cs.c:warning:strncpy-specified-bound-equals-destination-size
|-- powerpc-randconfig-r013-20230320
|   |-- include-linux-compiler_types.h:error:expression-in-static-assertion-is-not-an-integer
|   |-- include-linux-container_of.h:error:invalid-use-of-undefined-type-struct-module
|   |-- include-linux-rculist.h:error:invalid-use-of-undefined-type-struct-module
|   `-- include-linux-stddef.h:error:invalid-use-of-undefined-type-struct-module
|-- powerpc-randconfig-r015-20230320
|   |-- include-linux-compiler_types.h:error:expression-in-static-assertion-is-not-an-integer
|   |-- include-linux-container_of.h:error:invalid-use-of-undefined-type-struct-module
|   |-- include-linux-rculist.h:error:invalid-use-of-undefined-type-struct-module
|   `-- include-linux-stddef.h:error:invalid-use-of-undefined-type-struct-module
|-- powerpc-randconfig-s033-20230319
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:dereference-of-noderef-expression
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-noderef-__iomem-addr-got-void-noderef-__iomem-addr
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-noderef-__iomem-addr-got-void-noderef-__iomem-addr
|   |-- drivers-soc-fsl-qe-tsa.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-noderef-si_ram-got-void-noderef-__iomem
clang_recent_errors
|-- arm-randconfig-r003-20230319
|   |-- kernel-bpf-..-module-internal.h:error:assigning-to-struct-module-from-incompatible-type-void
|   |-- kernel-bpf-..-module-internal.h:error:incomplete-definition-of-type-struct-module
|   |-- kernel-bpf-..-module-internal.h:error:offsetof-of-incomplete-type-typeof-(-mod)-(aka-struct-module-)
|   `-- kernel-bpf-..-module-internal.h:error:operand-of-type-void-where-arithmetic-or-pointer-type-is-required
|-- hexagon-buildonly-randconfig-r006-20230319
|   |-- kernel-bpf-..-module-internal.h:error:assigning-to-struct-module-from-incompatible-type-void
|   |-- kernel-bpf-..-module-internal.h:error:incomplete-definition-of-type-struct-module
|   |-- kernel-bpf-..-module-internal.h:error:offsetof-of-incomplete-type-typeof-(-mod)-(aka-struct-module-)
|   `-- kernel-bpf-..-module-internal.h:error:operand-of-type-void-where-arithmetic-or-pointer-type-is-required
|-- mips-randconfig-r005-20230319
|   |-- kernel-bpf-..-module-internal.h:error:assigning-to-struct-module-from-incompatible-type-void
|   |-- kernel-bpf-..-module-internal.h:error:incomplete-definition-of-type-struct-module
|   |-- kernel-bpf-..-module-internal.h:error:offsetof-of-incomplete-type-typeof-(-mod)-(aka-struct-module-)
|   `-- kernel-bpf-..-module-internal.h:error:operand-of-type-void-where-arithmetic-or-pointer-type-is-required
|-- s390-randconfig-r044-20230319
|   |-- drivers-gpu-drm-imx-lcdc-imx-lcdc.c:error:call-to-undeclared-function-devm_drm_of_get_bridge-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   |-- drivers-gpu-drm-imx-lcdc-imx-lcdc.c:error:call-to-undeclared-function-drm_bridge_attach-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   |-- drivers-gpu-drm-imx-lcdc-imx-lcdc.c:error:incompatible-integer-to-pointer-conversion-assigning-to-struct-drm_bridge-from-int
|   `-- drivers-gpu-drm-imx-lcdc-imx-lcdc.c:error:use-of-undeclared-identifier-DRM_BRIDGE_ATTACH_NO_CONNECTOR
`-- x86_64-buildonly-randconfig-r001-20230320
    |-- kernel-bpf-..-module-internal.h:error:assigning-to-struct-module-from-incompatible-type-void
    |-- kernel-bpf-..-module-internal.h:error:incomplete-definition-of-type-struct-module
    |-- kernel-bpf-..-module-internal.h:error:offsetof-of-incomplete-type-typeof-(-mod)-(aka-struct-module-)
    `-- kernel-bpf-..-module-internal.h:error:operand-of-type-void-where-arithmetic-or-pointer-type-is-required

elapsed time: 728m

configs tested: 138
configs skipped: 11

tested configs:
alpha                            alldefconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r024-20230320   gcc  
alpha                randconfig-r032-20230319   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r005-20230319   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r012-20230319   gcc  
arc                  randconfig-r016-20230319   gcc  
arc                  randconfig-r043-20230319   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                      integrator_defconfig   gcc  
arm                         orion5x_defconfig   clang
arm                  randconfig-r003-20230319   clang
arm                  randconfig-r046-20230319   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r003-20230320   clang
arm64                randconfig-r035-20230319   gcc  
csky         buildonly-randconfig-r003-20230319   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r002-20230320   gcc  
csky                 randconfig-r026-20230319   gcc  
hexagon      buildonly-randconfig-r006-20230319   clang
hexagon              randconfig-r041-20230319   clang
hexagon              randconfig-r045-20230319   clang
i386                             allyesconfig   gcc  
i386                         debian-10.3-func   gcc  
i386                   debian-10.3-kselftests   gcc  
i386                        debian-10.3-kunit   gcc  
i386                          debian-10.3-kvm   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                          randconfig-a001   gcc  
i386                          randconfig-a002   clang
i386                          randconfig-a003   gcc  
i386                          randconfig-a004   clang
i386                          randconfig-a005   gcc  
i386                          randconfig-a006   clang
i386                 randconfig-a011-20230320   gcc  
i386                 randconfig-a012-20230320   gcc  
i386                 randconfig-a013-20230320   gcc  
i386                 randconfig-a014-20230320   gcc  
i386                 randconfig-a015-20230320   gcc  
i386                 randconfig-a016-20230320   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r011-20230320   gcc  
ia64                 randconfig-r024-20230319   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r006-20230319   gcc  
loongarch            randconfig-r021-20230320   gcc  
loongarch            randconfig-r034-20230319   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r003-20230320   gcc  
m68k                                defconfig   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips         buildonly-randconfig-r001-20230319   clang
mips                            gpr_defconfig   gcc  
mips                 randconfig-r005-20230319   clang
mips                 randconfig-r005-20230320   gcc  
mips                           xway_defconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r012-20230320   gcc  
nios2                randconfig-r014-20230319   gcc  
nios2                randconfig-r025-20230319   gcc  
nios2                randconfig-r033-20230319   gcc  
nios2                randconfig-r036-20230319   gcc  
openrisc     buildonly-randconfig-r004-20230319   gcc  
openrisc             randconfig-r016-20230320   gcc  
openrisc             randconfig-r031-20230319   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r022-20230319   gcc  
parisc               randconfig-r025-20230320   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc      buildonly-randconfig-r006-20230320   gcc  
powerpc                        fsp2_defconfig   clang
powerpc                mpc7448_hpc2_defconfig   gcc  
powerpc              randconfig-r013-20230320   gcc  
powerpc              randconfig-r015-20230320   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r001-20230320   clang
riscv                randconfig-r042-20230319   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390         buildonly-randconfig-r004-20230320   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r004-20230320   clang
s390                 randconfig-r006-20230320   clang
s390                 randconfig-r044-20230319   clang
sh                               alldefconfig   gcc  
sh                               allmodconfig   gcc  
sh                         ecovec24_defconfig   gcc  
sh                   randconfig-r013-20230319   gcc  
sh                   randconfig-r014-20230320   gcc  
sh                   randconfig-r023-20230319   gcc  
sh                          rsk7269_defconfig   gcc  
sh                          sdk7786_defconfig   gcc  
sh                             sh03_defconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r002-20230319   gcc  
sparc64              randconfig-r015-20230319   gcc  
sparc64              randconfig-r026-20230320   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230320   clang
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230320   clang
x86_64               randconfig-a002-20230320   clang
x86_64               randconfig-a003-20230320   clang
x86_64               randconfig-a004-20230320   clang
x86_64               randconfig-a005-20230320   clang
x86_64               randconfig-a006-20230320   clang
x86_64                        randconfig-a011   gcc  
x86_64                        randconfig-a012   clang
x86_64                        randconfig-a013   gcc  
x86_64                        randconfig-a014   clang
x86_64                        randconfig-a015   gcc  
x86_64                        randconfig-a016   clang
x86_64                        randconfig-k001   clang
x86_64               randconfig-r023-20230320   gcc  
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r001-20230319   gcc  
xtensa                    smp_lx200_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
