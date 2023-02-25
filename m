Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662D46A2B05
	for <lists+io-uring@lfdr.de>; Sat, 25 Feb 2023 18:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjBYRLo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Feb 2023 12:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBYRLn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Feb 2023 12:11:43 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5551042E;
        Sat, 25 Feb 2023 09:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677345102; x=1708881102;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=/wmzhNxDeMcFcsLck+WoGXoesP55t1mLA577Oo+iWV8=;
  b=Zqi74QDS720c77fRW5MRilYBviP9dNeN7+dfD9QSVgvYcpe+TMBj2DmO
   2G0ZNMQldVj981zyneHEwmbd/Y1mah3hHUAZ8kMbLrtuiqrLgl3NWqEGU
   sXLlsp7/x/Q8dTCGj5wQ8M7SIvHaC7sP/q5ecyYO/lCn2RCWjJeQUnLTm
   lhP+xsGztWi8iAKTetB1kU+16q86eQV+LPk/OkRYw+DdqVQB5QQUixrDo
   abWbP7H7tgl3eT3Zpi+vr9XmFNk+AVyRcJWZzd1emYTL84g6/cC/vwT1s
   ZnfduqCUswBSAhj0bUFG4KFC/CVYDFuUYYChcAlPbrTX9K6ihgnd/q+kG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="332369633"
X-IronPort-AV: E=Sophos;i="5.97,328,1669104000"; 
   d="scan'208";a="332369633"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2023 09:11:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="673233092"
X-IronPort-AV: E=Sophos;i="5.97,328,1669104000"; 
   d="scan'208";a="673233092"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 25 Feb 2023 09:11:39 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pVy5C-0003KB-0e;
        Sat, 25 Feb 2023 17:11:38 +0000
Date:   Sun, 26 Feb 2023 01:10:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-usb@vger.kernel.org, linux-mm@kvack.org,
        linux-bluetooth@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        io-uring@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 8232539f864ca60474e38eb42d451f5c26415856
Message-ID: <63fa411f.ZvVOisJt5OlLzGYF%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 8232539f864ca60474e38eb42d451f5c26415856  Add linux-next specific files for 20230225

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202302040652.zkUBTjyo-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302111601.jtY4lKrA-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302112104.g75cGHZd-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302210350.lynWcL4t-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

FAILED: load BTF from vmlinux: No data available
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_optc.c:294:6: warning: no previous prototype for 'optc3_wait_drr_doublebuffer_pending_clear' [-Wmissing-prototypes]
drivers/pcmcia/pxa2xx_sharpsl.c:206:5: warning: no previous prototype for function 'pcmcia_collie_init' [-Wmissing-prototypes]
include/asm-generic/div64.h:238:36: error: passing argument 1 of '__div64_32' from incompatible pointer type [-Werror=incompatible-pointer-types]

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/usb/gadget/composite.c:2082:33: sparse: sparse: restricted __le16 degrades to integer
io_uring/rsrc.c:1262 io_sqe_buffer_register() error: uninitialized symbol 'folio'.
mm/page_alloc.c:257:1: sparse: sparse: symbol 'check_pages_enabled' was not declared. Should it be static?
net/bluetooth/hci_sync.c:2403 hci_pause_addr_resolution() warn: missing error code? 'err'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-randconfig-s041-20230222
|   `-- mm-page_alloc.c:sparse:sparse:symbol-check_pages_enabled-was-not-declared.-Should-it-be-static
|-- arc-allyesconfig
|   `-- include-asm-generic-div64.h:error:passing-argument-of-__div64_32-from-incompatible-pointer-type
|-- arm-allmodconfig
|   `-- include-asm-generic-div64.h:error:passing-argument-of-__div64_32-from-incompatible-pointer-type
|-- arm-allyesconfig
|   `-- include-asm-generic-div64.h:error:passing-argument-of-__div64_32-from-incompatible-pointer-type
|-- arm-randconfig-s051-20230222
|   `-- drivers-usb-gadget-composite.c:sparse:sparse:restricted-__le16-degrades-to-integer
|-- arm64-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn30-dcn30_optc.c:warning:no-previous-prototype-for-optc3_wait_drr_doublebuffer_pending_clear
|-- i386-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn30-dcn30_optc.c:warning:no-previous-prototype-for-optc3_wait_drr_doublebuffer_pending_clear
|-- i386-randconfig-s001
|   |-- drivers-gpu-drm-i915-gem-i915_gem_ttm.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-vm_fault_t-assigned-usertype-ret-got-int
|   `-- drivers-usb-gadget-composite.c:sparse:sparse:restricted-__le16-degrades-to-integer
|-- i386-randconfig-s002
|   `-- drivers-gpu-drm-i915-gem-i915_gem_ttm.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-vm_fault_t-assigned-usertype-ret-got-int
|-- i386-randconfig-s003
|   `-- drivers-usb-gadget-composite.c:sparse:sparse:restricted-__le16-degrades-to-integer
|-- loongarch-randconfig-m041-20230225
|   `-- io_uring-rsrc.c-io_sqe_buffer_register()-error:uninitialized-symbol-folio-.
|-- openrisc-randconfig-r014-20230225
|   `-- FAILED:load-BTF-from-vmlinux:No-data-available
|-- openrisc-randconfig-s052-20230222
|   `-- drivers-usb-gadget-composite.c:sparse:sparse:restricted-__le16-degrades-to-integer
|-- parisc-randconfig-m031-20230223
|   `-- net-bluetooth-hci_sync.c-hci_pause_addr_resolution()-warn:missing-error-code-err
|-- powerpc-allmodconfig
|   `-- include-asm-generic-div64.h:error:passing-argument-of-__div64_32-from-incompatible-pointer-type
|-- x86_64-allnoconfig
|   `-- Warning:Documentation-devicetree-bindings-usb-rockchip-dwc3.yaml-references-a-file-that-doesn-t-exist:Documentation-devicetree-bindings-phy-phy-rockchip-inno-usb2.yaml
|-- x86_64-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn30-dcn30_optc.c:warning:no-previous-prototype-for-optc3_wait_drr_doublebuffer_pending_clear
|-- x86_64-randconfig-m001
|   `-- io_uring-rsrc.c-io_sqe_buffer_register()-error:uninitialized-symbol-folio-.
`-- x86_64-randconfig-s021
    `-- drivers-usb-gadget-composite.c:sparse:sparse:restricted-__le16-degrades-to-integer
clang_recent_errors
`-- arm-collie_defconfig
    `-- drivers-pcmcia-pxa2xx_sharpsl.c:warning:no-previous-prototype-for-function-pcmcia_collie_init

elapsed time: 730m

configs tested: 46
configs skipped: 5

tested configs:
alpha                               defconfig   gcc  
arc                          axs103_defconfig   gcc  
arc                                 defconfig   gcc  
arm                          collie_defconfig   clang
arm                                 defconfig   gcc  
arm                      jornada720_defconfig   gcc  
arm64                               defconfig   gcc  
csky                                defconfig   gcc  
i386                                defconfig   gcc  
ia64                                defconfig   gcc  
loongarch                           defconfig   gcc  
m68k                         amcore_defconfig   gcc  
m68k                                defconfig   gcc  
microblaze                          defconfig   gcc  
mips                        bcm47xx_defconfig   gcc  
mips                       lemote2f_defconfig   clang
mips                     loongson1c_defconfig   clang
mips                     loongson2k_defconfig   clang
mips                           mtx1_defconfig   clang
mips                      pic32mzda_defconfig   clang
mips                        qi_lb60_defconfig   clang
mips                          rm200_defconfig   clang
nios2                               defconfig   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                    klondike_defconfig   gcc  
powerpc                  mpc885_ads_defconfig   clang
powerpc                      pasemi_defconfig   gcc  
powerpc                     skiroot_defconfig   clang
riscv                               defconfig   gcc  
riscv                          rv32_defconfig   gcc  
s390                                defconfig   gcc  
sh                         apsh4a3a_defconfig   gcc  
sh                        dreamcast_defconfig   gcc  
sh                          landisk_defconfig   gcc  
sh                          polaris_defconfig   gcc  
sh                           se7343_defconfig   gcc  
sparc                            alldefconfig   gcc  
sparc                               defconfig   gcc  
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                              defconfig   gcc  
xtensa                  cadence_csp_defconfig   gcc  
xtensa                       common_defconfig   gcc  
xtensa                generic_kc705_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
