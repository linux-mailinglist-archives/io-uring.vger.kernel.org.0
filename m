Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02566BECD5
	for <lists+io-uring@lfdr.de>; Fri, 17 Mar 2023 16:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjCQP1T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Mar 2023 11:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCQP1S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Mar 2023 11:27:18 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814A0900B6;
        Fri, 17 Mar 2023 08:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679066836; x=1710602836;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=4nsKQfG2TXVFlzS0a2xqd6TUaOzPnDxZ9w+isDZMppc=;
  b=Ra2/GTkWhkqzxVWbNPlW7azYgc23bRdQTrnvByIuM/oxVcvqEZNHIM65
   CUmw+M7NuWAEwi2EKIegXqvi7xqI62FI3lp8l9jJSxIl6cH4cxLWNdtYF
   YW8zAhVKALQm1S+Dk0XmENRLN1uP/vP8kRZ229kS+s5t/d1K3vFXen+HI
   r3qSTRHkP+kjelIpWFw1WkLcY79iKMtRkaK/ovjrycjNb4hKkWPAhrXY7
   5tvAv1A/nYUiGwrLjZbkRnPxIPhdASHI9G1GwgaEEl2pFOxZXhf8LEPr9
   pSCnNTFaA8Pr4wU6Pwp29kiuu26ep49ddZDSM1EKEEpS/a3EadO/TXg1f
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="318684204"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="318684204"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 08:26:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="854469627"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="854469627"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 17 Mar 2023 08:26:17 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pdBy7-0009RE-27;
        Fri, 17 Mar 2023 15:26:11 +0000
Date:   Fri, 17 Mar 2023 23:25:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     rcu@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-modules@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-crypto@vger.kernel.org, io-uring@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 6f08c1de13a9403341c18b66638a05588b2663ce
Message-ID: <6414867a.CJX/i0yulQyJmAbH%lkp@intel.com>
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
branch HEAD: 6f08c1de13a9403341c18b66638a05588b2663ce  Add linux-next specific files for 20230317

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202303081807.lBLWKmpX-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303082135.NjdX1Bij-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303151409.por0SBf7-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303161404.OrmfCy09-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303161521.jbGbaFjJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303171300.g6uEM0X9-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303171506.Af2gNUDA-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303171606.xoYwr7Lj-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Warning: Documentation/devicetree/bindings/input/snvs-pwrkey.txt references a file that doesn't exist: Documentation/devicetree/bindings/crypto/fsl-sec4.txt
Warning: Documentation/devicetree/bindings/rtc/snvs-rtc.txt references a file that doesn't exist: Documentation/devicetree/bindings/crypto/fsl-sec4.txt
Warning: MAINTAINERS references a file that doesn't exist: Documentation/devicetree/bindings/crypto/fsl-sec4.txt
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:258:10: warning: no previous prototype for 'link_timing_bandwidth_kbps' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_capability.c:2184: warning: expecting prototype for Check if there is a native DP or passive DP(). Prototype was for dp_is_sink_present() instead
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:309:17: sparse:    int
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:309:17: sparse:    void
drivers/net/wireless/legacy/ray_cs.c:628:17: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
include/linux/compiler_types.h:338:27: error: expression in static assertion is not an integer
include/linux/compiler_types.h:340:27: error: expression in static assertion is not an integer
include/linux/container_of.h:20:54: error: invalid use of undefined type 'struct module'
include/linux/rculist.h:392:21: error: invalid use of undefined type 'struct module'
include/linux/stddef.h:16:33: error: invalid use of undefined type 'struct module'
kernel/bpf/../module/internal.h:205:2: error: assigning to 'struct module *' from incompatible type 'void'
kernel/bpf/../module/internal.h:205:2: error: incomplete definition of type 'struct module'
kernel/bpf/../module/internal.h:205:2: error: offsetof of incomplete type 'typeof (*mod)' (aka 'struct module')
kernel/bpf/../module/internal.h:205:2: error: operand of type 'void' where arithmetic or pointer type is required
kernel/bpf/../module/internal.h:212:2: error: operand of type 'void' where arithmetic or pointer type is required
lib/dynamic_debug.c:947:6: warning: no previous prototype for function '__dynamic_ibdev_dbg' [-Wmissing-prototypes]

Unverified Error/Warning (likely false positive, please contact us if interested):

crypto/rng.c:206:27: warning: Value stored to 'istat' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/usb/host/xhci-rcar.c:239:34: warning: unused variable 'usb_xhci_of_match' [-Wunused-const-variable]
drivers/watchdog/imx2_wdt.c:442:22: sparse: sparse: symbol 'imx_wdt' was not declared. Should it be static?
drivers/watchdog/imx2_wdt.c:446:22: sparse: sparse: symbol 'imx_wdt_legacy' was not declared. Should it be static?
include/linux/gpio/consumer.h: linux/err.h is included more than once.
include/linux/gpio/driver.h: asm/bug.h is included more than once.
io_uring/io_uring.c:432 io_prep_async_work() error: we previously assumed 'req->file' could be null (see line 425)
io_uring/kbuf.c:221 __io_remove_buffers() warn: variable dereferenced before check 'bl->buf_ring' (see line 219)

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:no-previous-prototype-for-link_timing_bandwidth_kbps
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:expecting-prototype-for-Check-if-there-is-a-native-DP-or-passive-DP().-Prototype-was-for-dp_is_sink_present()-inste
|   `-- drivers-net-wireless-legacy-ray_cs.c:warning:strncpy-specified-bound-equals-destination-size
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:no-previous-prototype-for-link_timing_bandwidth_kbps
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:expecting-prototype-for-Check-if-there-is-a-native-DP-or-passive-DP().-Prototype-was-for-dp_is_sink_present()-inste
|-- arc-randconfig-r006-20230313
|   |-- include-linux-compiler_types.h:error:expression-in-static-assertion-is-not-an-integer
|   |-- include-linux-container_of.h:error:invalid-use-of-undefined-type-struct-module
|   |-- include-linux-rculist.h:error:invalid-use-of-undefined-type-struct-module
|   `-- include-linux-stddef.h:error:invalid-use-of-undefined-type-struct-module
|-- arc-randconfig-r013-20230312
|   |-- include-linux-compiler_types.h:error:expression-in-static-assertion-is-not-an-integer
|   |-- include-linux-container_of.h:error:invalid-use-of-undefined-type-struct-module
|   |-- include-linux-rculist.h:error:invalid-use-of-undefined-type-struct-module
|   `-- include-linux-stddef.h:error:invalid-use-of-undefined-type-struct-module
|-- arm-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:no-previous-prototype-for-link_timing_bandwidth_kbps
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:expecting-prototype-for-Check-if-there-is-a-native-DP-or-passive-DP().-Prototype-was-for-dp_is_sink_present()-inste
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:no-previous-prototype-for-link_timing_bandwidth_kbps
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:expecting-prototype-for-Check-if-there-is-a-native-DP-or-passive-DP().-Prototype-was-for-dp_is_sink_present()-inste
|-- arm-buildonly-randconfig-r003-20230313
|   |-- include-linux-compiler_types.h:error:expression-in-static-assertion-is-not-an-integer
|   |-- include-linux-container_of.h:error:invalid-use-of-undefined-type-struct-module
|   |-- include-linux-rculist.h:error:invalid-use-of-undefined-type-struct-module
|   `-- include-linux-stddef.h:error:invalid-use-of-undefined-type-struct-module
|-- arm-randconfig-s051-20230312
|   |-- drivers-watchdog-imx2_wdt.c:sparse:sparse:symbol-imx_wdt-was-not-declared.-Should-it-be-static
|   `-- drivers-watchdog-imx2_wdt.c:sparse:sparse:symbol-imx_wdt_legacy-was-not-declared.-Should-it-be-static
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:no-previous-prototype-for-link_timing_bandwidth_kbps
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:expecting-prototype-for-Check-if-there-is-a-native-DP-or-passive-DP().-Prototype-was-for-dp_is_sink_present()-inste
|-- csky-randconfig-r025-20230313
|   |-- include-linux-compiler_types.h:error:expression-in-static-assertion-is-not-an-integer
|   |-- include-linux-container_of.h:error:invalid-use-of-undefined-type-struct-module
|   |-- include-linux-rculist.h:error:invalid-use-of-undefined-type-struct-module
|   `-- include-linux-stddef.h:error:invalid-use-of-undefined-type-struct-module
|-- csky-randconfig-r031-20230313
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:no-previous-prototype-for-link_timing_bandwidth_kbps
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:expecting-prototype-for-Check-if-there-is-a-native-DP-or-passive-DP().-Prototype-was-for-dp_is_sink_present()-inste
|-- csky-randconfig-s043-20230312
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:int
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   `-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:void
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:no-previous-prototype-for-link_timing_bandwidth_kbps
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:expecting-prototype-for-Check-if-there-is-a-native-DP-or-passive-DP().-Prototype-was-for-dp_is_sink_present()-inste
|-- ia64-allmodconfig
clang_recent_errors
|-- arm-randconfig-c002-20230312
|   `-- crypto-rng.c:warning:Value-stored-to-istat-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
|-- arm64-randconfig-r005-20230312
|   |-- kernel-bpf-..-module-internal.h:error:assigning-to-struct-module-from-incompatible-type-void
|   |-- kernel-bpf-..-module-internal.h:error:incomplete-definition-of-type-struct-module
|   |-- kernel-bpf-..-module-internal.h:error:offsetof-of-incomplete-type-typeof-(-mod)-(aka-struct-module-)
|   `-- kernel-bpf-..-module-internal.h:error:operand-of-type-void-where-arithmetic-or-pointer-type-is-required
|-- hexagon-buildonly-randconfig-r004-20230312
|   |-- drivers-usb-host-xhci-rcar.c:warning:unused-variable-usb_xhci_of_match
|   |-- kernel-bpf-..-module-internal.h:error:assigning-to-struct-module-from-incompatible-type-void
|   |-- kernel-bpf-..-module-internal.h:error:incomplete-definition-of-type-struct-module
|   `-- kernel-bpf-..-module-internal.h:error:offsetof-of-incomplete-type-typeof-(-mod)-(aka-struct-module-)
|-- i386-randconfig-a012-20230313
|   `-- lib-dynamic_debug.c:warning:no-previous-prototype-for-function-__dynamic_ibdev_dbg
|-- i386-randconfig-a013-20230313
|   `-- lib-dynamic_debug.c:warning:no-previous-prototype-for-function-__dynamic_ibdev_dbg
|-- i386-randconfig-a016-20230313
|   `-- lib-dynamic_debug.c:warning:no-previous-prototype-for-function-__dynamic_ibdev_dbg
|-- powerpc-randconfig-r002-20230312
|   `-- kernel-bpf-..-module-internal.h:error:operand-of-type-void-where-arithmetic-or-pointer-type-is-required
|-- riscv-randconfig-r002-20230312
|   |-- kernel-bpf-..-module-internal.h:error:assigning-to-struct-module-from-incompatible-type-void
|   |-- kernel-bpf-..-module-internal.h:error:incomplete-definition-of-type-struct-module
|   |-- kernel-bpf-..-module-internal.h:error:offsetof-of-incomplete-type-typeof-(-mod)-(aka-struct-module-)
|   `-- kernel-bpf-..-module-internal.h:error:operand-of-type-void-where-arithmetic-or-pointer-type-is-required
`-- riscv-randconfig-r042-20230313
    |-- kernel-bpf-..-module-internal.h:error:assigning-to-struct-module-from-incompatible-type-void
    |-- kernel-bpf-..-module-internal.h:error:incomplete-definition-of-type-struct-module
    |-- kernel-bpf-..-module-internal.h:error:offsetof-of-incomplete-type-typeof-(-mod)-(aka-struct-module-)
    `-- kernel-bpf-..-module-internal.h:error:operand-of-type-void-where-arithmetic-or-pointer-type-is-required

elapsed time: 723m

configs tested: 133
configs skipped: 9

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r002-20230313   gcc  
arc                  randconfig-r006-20230313   gcc  
arc                  randconfig-r013-20230312   gcc  
arc                  randconfig-r023-20230313   gcc  
arc                  randconfig-r043-20230312   gcc  
arc                  randconfig-r043-20230313   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r003-20230313   gcc  
arm                                 defconfig   gcc  
arm                       imx_v4_v5_defconfig   clang
arm                         lpc18xx_defconfig   gcc  
arm                  randconfig-r004-20230313   clang
arm                  randconfig-r012-20230312   clang
arm                  randconfig-r046-20230312   clang
arm                  randconfig-r046-20230313   gcc  
arm                           sama5_defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r005-20230312   clang
csky                                defconfig   gcc  
csky                 randconfig-r022-20230313   gcc  
csky                 randconfig-r023-20230312   gcc  
csky                 randconfig-r025-20230313   gcc  
csky                 randconfig-r031-20230313   gcc  
hexagon      buildonly-randconfig-r004-20230312   clang
hexagon      buildonly-randconfig-r005-20230313   clang
hexagon              randconfig-r001-20230313   clang
hexagon              randconfig-r022-20230312   clang
hexagon              randconfig-r041-20230312   clang
hexagon              randconfig-r041-20230313   clang
hexagon              randconfig-r045-20230312   clang
hexagon              randconfig-r045-20230313   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r002-20230313   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230313   gcc  
i386                 randconfig-a002-20230313   gcc  
i386                 randconfig-a003-20230313   gcc  
i386                 randconfig-a004-20230313   gcc  
i386                 randconfig-a005-20230313   gcc  
i386                 randconfig-a006-20230313   gcc  
i386                 randconfig-a011-20230313   clang
i386                 randconfig-a012-20230313   clang
i386                 randconfig-a013-20230313   clang
i386                 randconfig-a014-20230313   clang
i386                 randconfig-a015-20230313   clang
i386                 randconfig-a016-20230313   clang
i386                          randconfig-c001   gcc  
i386                 randconfig-r032-20230313   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r001-20230312   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r006-20230312   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                            q40_defconfig   gcc  
microblaze   buildonly-randconfig-r003-20230312   gcc  
microblaze           randconfig-r011-20230312   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                     cu1000-neo_defconfig   clang
mips                      pic32mzda_defconfig   clang
mips                 randconfig-r025-20230312   clang
nios2                               defconfig   gcc  
nios2                randconfig-r003-20230313   gcc  
nios2                randconfig-r015-20230312   gcc  
nios2                randconfig-r036-20230313   gcc  
openrisc     buildonly-randconfig-r001-20230312   gcc  
openrisc     buildonly-randconfig-r006-20230312   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r021-20230313   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                    amigaone_defconfig   gcc  
powerpc                      bamboo_defconfig   gcc  
powerpc                   bluestone_defconfig   clang
powerpc      buildonly-randconfig-r001-20230313   clang
powerpc      buildonly-randconfig-r004-20230313   clang
powerpc                  iss476-smp_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r002-20230312   clang
riscv                randconfig-r042-20230312   gcc  
riscv                randconfig-r042-20230313   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r044-20230312   gcc  
s390                 randconfig-r044-20230313   clang
sh                               allmodconfig   gcc  
sh                               j2_defconfig   gcc  
sh                   randconfig-r024-20230313   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r004-20230312   gcc  
sparc                randconfig-r014-20230312   gcc  
sparc                randconfig-r033-20230313   gcc  
sparc                randconfig-r035-20230313   gcc  
sparc64              randconfig-r021-20230312   gcc  
sparc64              randconfig-r026-20230312   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230313   gcc  
x86_64               randconfig-a002-20230313   gcc  
x86_64               randconfig-a003-20230313   gcc  
x86_64               randconfig-a004-20230313   gcc  
x86_64               randconfig-a005-20230313   gcc  
x86_64               randconfig-a006-20230313   gcc  
x86_64                        randconfig-a011   gcc  
x86_64                        randconfig-a012   clang
x86_64                        randconfig-a013   gcc  
x86_64                        randconfig-a014   clang
x86_64                        randconfig-a015   gcc  
x86_64                        randconfig-a016   clang
x86_64               randconfig-r026-20230313   clang
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r005-20230313   gcc  
xtensa               randconfig-r016-20230312   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
