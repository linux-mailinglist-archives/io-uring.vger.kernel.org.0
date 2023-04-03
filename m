Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F506D552E
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 01:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbjDCXWz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Apr 2023 19:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbjDCXWy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Apr 2023 19:22:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E3B1BC;
        Mon,  3 Apr 2023 16:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680564172; x=1712100172;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=0GMN8BMPXoRScxdXasX++WZ+3bDkfK4Q2lFPxzZv0M8=;
  b=b18L+GmpaWgxPsfK6BJ53gdP5Og8m22mqYOjC9e595ZWKfcLOwc9w0eQ
   PhsKHqnaFGk3+RHSFBhWrxzirndp3AdFFKF8o6PE9kfmrQCxIHy+ZWFP3
   f1uAyDm6RBu2swmdQ2DlawOeSNxDwuynWX4/FESmAbWBRaE1btKtecX6g
   dVF8lei0+iZPQNx8B/iRnvq5NggV7m2w2VQaDK+mePf2e+14gXXJySvOa
   Sep0RfDxiHviMD1LXB3Tf0W5v3m3rMd049dmKcbPe2Slu/Gv7EyImW+1X
   URAFwUZ2OFhP1rkiNZ+KyI0Px4xTpG/HlheSKqqsUFuhHZYDU/sJ65LH8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="344604335"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="344604335"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 16:22:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="750684865"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="750684865"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 03 Apr 2023 16:22:48 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjTVf-000Ow9-1h;
        Mon, 03 Apr 2023 23:22:47 +0000
Date:   Tue, 04 Apr 2023 07:22:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     platform-driver-x86@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        io-uring@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 31bd35b66249699343d2416658f57e97314a433a
Message-ID: <642b5fbb.jG7DppFs8DO3Bu12%lkp@intel.com>
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
branch HEAD: 31bd35b66249699343d2416658f57e97314a433a  Add linux-next specific files for 20230403

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202303082135.NjdX1Bij-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303161521.jbGbaFjJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202304040401.IMxt7Ubi-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:351:13: warning: variable 'bw_needed' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:352:25: warning: variable 'link' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:309:17: sparse:    int
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:309:17: sparse:    void
drivers/net/wireless/legacy/ray_cs.c:628:17: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/acpi/property.c:985 acpi_data_prop_read_single() error: potentially dereferencing uninitialized 'obj'.
drivers/cdx/cdx.c:393:20: error: initialization of 'ssize_t (*)(const struct bus_type *, const char *, size_t)' {aka 'long int (*)(const struct bus_type *, const char *, long unsigned int)'} from incompatible pointer type 'ssize_t (*)(struct bus_type *, const char *, size_t)' {aka 'long int (*)(struct bus_type *, const char *, long unsigned int)'} [-Werror=incompatible-pointer-types]
drivers/pinctrl/pinctrl-mlxbf3.c:162:20: sparse: sparse: symbol 'mlxbf3_pmx_funcs' was not declared. Should it be static?
drivers/soc/fsl/qe/tsa.c:140:26: sparse: sparse: incorrect type in argument 2 (different address spaces)
drivers/soc/fsl/qe/tsa.c:150:27: sparse: sparse: incorrect type in argument 1 (different address spaces)
drivers/soc/fsl/qe/tsa.c:189:26: sparse: sparse: dereference of noderef expression
drivers/soc/fsl/qe/tsa.c:663:22: sparse: sparse: incorrect type in assignment (different address spaces)
drivers/soc/fsl/qe/tsa.c:673:21: sparse: sparse: incorrect type in assignment (different address spaces)
drivers/usb/typec/ucsi/ucsi_glink.c:248:20: sparse: sparse: restricted __le32 degrades to integer
drivers/usb/typec/ucsi/ucsi_glink.c:81:23: sparse: sparse: incorrect type in assignment (different base types)
drivers/usb/typec/ucsi/ucsi_glink.c:82:22: sparse: sparse: incorrect type in assignment (different base types)
drivers/usb/typec/ucsi/ucsi_glink.c:83:24: sparse: sparse: incorrect type in assignment (different base types)
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
|-- alpha-randconfig-s051-20230403
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:int
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:void
|   `-- drivers-pinctrl-pinctrl-mlxbf3.c:sparse:sparse:symbol-mlxbf3_pmx_funcs-was-not-declared.-Should-it-be-static
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
|   |-- drivers-cdx-cdx.c:error:initialization-of-ssize_t-(-)(const-struct-bus_type-const-char-size_t)-aka-long-int-(-)(const-struct-bus_type-const-char-long-unsigned-int)-from-incompatible-pointer-type-ssize
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- i386-randconfig-m021-20230403
|   |-- drivers-acpi-property.c-acpi_data_prop_read_single()-error:potentially-dereferencing-uninitialized-obj-.
|   |-- io_uring-io_uring.c-io_prep_async_work()-error:we-previously-assumed-req-file-could-be-null-(see-line-)
|   `-- io_uring-kbuf.c-__io_remove_buffers()-warn:variable-dereferenced-before-check-bl-buf_ring-(see-line-)
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   `-- drivers-net-wireless-legacy-ray_cs.c:warning:strncpy-specified-bound-equals-destination-size
|-- ia64-randconfig-r003-20230403
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- ia64-randconfig-r025-20230402
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- ia64-randconfig-r026-20230402
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- loongarch-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- loongarch-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- loongarch-defconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used

elapsed time: 724m

configs tested: 140
configs skipped: 9

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r033-20230402   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r006-20230402   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r011-20230402   gcc  
arc                  randconfig-r022-20230402   gcc  
arc                  randconfig-r034-20230403   gcc  
arc                  randconfig-r043-20230402   gcc  
arc                  randconfig-r043-20230403   gcc  
arc                    vdk_hs38_smp_defconfig   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r003-20230403   clang
arm                                 defconfig   gcc  
arm                          exynos_defconfig   gcc  
arm                  randconfig-r023-20230402   gcc  
arm                  randconfig-r046-20230402   gcc  
arm                  randconfig-r046-20230403   clang
arm                         s5pv210_defconfig   clang
arm                        shmobile_defconfig   gcc  
arm                           stm32_defconfig   gcc  
arm                        vexpress_defconfig   clang
arm64                            allyesconfig   gcc  
arm64        buildonly-randconfig-r002-20230403   clang
arm64        buildonly-randconfig-r004-20230402   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r023-20230403   gcc  
csky                                defconfig   gcc  
hexagon              randconfig-r016-20230403   clang
hexagon              randconfig-r034-20230402   clang
hexagon              randconfig-r035-20230403   clang
hexagon              randconfig-r041-20230403   clang
hexagon              randconfig-r045-20230402   clang
hexagon              randconfig-r045-20230403   clang
i386                              allnoconfig   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230403   clang
i386                 randconfig-a002-20230403   clang
i386                 randconfig-a003-20230403   clang
i386                 randconfig-a004-20230403   clang
i386                 randconfig-a005-20230403   clang
i386                 randconfig-a006-20230403   clang
i386                 randconfig-a011-20230403   gcc  
i386                 randconfig-a012-20230403   gcc  
i386                 randconfig-a013-20230403   gcc  
i386                 randconfig-a014-20230403   gcc  
i386                 randconfig-a015-20230403   gcc  
i386                 randconfig-a016-20230403   gcc  
i386                 randconfig-r006-20230403   clang
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r003-20230403   gcc  
ia64                 randconfig-r025-20230402   gcc  
ia64                 randconfig-r026-20230402   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch    buildonly-randconfig-r001-20230402   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r031-20230402   gcc  
m68k                             allmodconfig   gcc  
m68k                          amiga_defconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r012-20230403   gcc  
m68k                 randconfig-r031-20230403   gcc  
m68k                 randconfig-r032-20230403   gcc  
microblaze   buildonly-randconfig-r002-20230402   gcc  
microblaze           randconfig-r004-20230403   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                           gcw0_defconfig   gcc  
nios2                         3c120_defconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r012-20230402   gcc  
openrisc             randconfig-r006-20230403   gcc  
openrisc             randconfig-r021-20230402   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r011-20230403   gcc  
parisc               randconfig-r024-20230402   gcc  
parisc               randconfig-r033-20230403   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                     asp8347_defconfig   gcc  
powerpc      buildonly-randconfig-r006-20230403   gcc  
powerpc                  iss476-smp_defconfig   gcc  
powerpc              randconfig-r014-20230402   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r004-20230403   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r035-20230402   gcc  
riscv                randconfig-r042-20230402   clang
riscv                randconfig-r042-20230403   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r003-20230403   clang
s390                 randconfig-r005-20230403   clang
s390                 randconfig-r013-20230402   clang
s390                 randconfig-r025-20230403   gcc  
s390                 randconfig-r044-20230403   gcc  
sh                               allmodconfig   gcc  
sh                   randconfig-r016-20230402   gcc  
sh                   randconfig-r032-20230402   gcc  
sh                          urquell_defconfig   gcc  
sparc        buildonly-randconfig-r005-20230403   gcc  
sparc                               defconfig   gcc  
sparc64      buildonly-randconfig-r003-20230402   gcc  
sparc64                             defconfig   gcc  
sparc64              randconfig-r014-20230403   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230403   clang
x86_64               randconfig-a002-20230403   clang
x86_64               randconfig-a003-20230403   clang
x86_64               randconfig-a004-20230403   clang
x86_64               randconfig-a005-20230403   clang
x86_64               randconfig-a006-20230403   clang
x86_64               randconfig-a011-20230403   gcc  
x86_64               randconfig-a012-20230403   gcc  
x86_64               randconfig-a013-20230403   gcc  
x86_64               randconfig-a014-20230403   gcc  
x86_64               randconfig-a015-20230403   gcc  
x86_64               randconfig-a016-20230403   gcc  
x86_64               randconfig-r013-20230403   gcc  
x86_64               randconfig-r022-20230403   gcc  
x86_64               randconfig-r036-20230403   clang
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r005-20230402   gcc  
xtensa               randconfig-r015-20230403   gcc  
xtensa               randconfig-r024-20230403   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
