Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486FC507A41
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 21:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbiDSTdI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 15:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbiDSTdH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 15:33:07 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC18827B21;
        Tue, 19 Apr 2022 12:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650396622; x=1681932622;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=e6THYDkb8diYYyXW2oJvqfK4IRAs59NV4HszoRowTgg=;
  b=nF4JUO384z3BrvYcQNng9B6eGYNXRxBwbtFqTxSV9DEgaSM3lJX26PVk
   /MdI0YMkBNeGMXG2lNBigue6fFndrnz05UsPtMyPPvvR1+wEllgwjGRq3
   bH6InvJ5LYoqz41LKM0OpycRVxGr5eCwfEzKC8a2hqg2zSjZD2Kq9043p
   gOJ2CGA+Scbd9VOmYOGKGlXBTvcfGz2dXacBHERWXEae++jNrCrxvyyuo
   FEHp+WRm5a1zhOR3YWHyS5DBdh1EVLLaNnNh7PXL57JXqcnvE+Xt+dn5O
   k7iCh99dBq4IA+DtQsWuW4Ij1jx9/yyWCmmarVgzpJzQJytKI3sOvUlC4
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="264026529"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="264026529"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 12:30:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="861859334"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 19 Apr 2022 12:30:19 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ngtYJ-00067Y-0R;
        Tue, 19 Apr 2022 19:30:19 +0000
Date:   Wed, 20 Apr 2022 03:29:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-media@vger.kernel.org,
        linux-edac@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        io-uring@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 634de1db0e9bbeb90d7b01020e59ec3dab4d38a1
Message-ID: <625f0dac.FpRyWRTzc3sv78rQ%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 634de1db0e9bbeb90d7b01020e59ec3dab4d38a1  Add linux-next specific files for 20220419

Error/Warning reports:

https://lore.kernel.org/linux-mm/202204081656.6x4pfen4-lkp@intel.com
https://lore.kernel.org/linux-mm/202204140108.DeRAhWEn-lkp@intel.com
https://lore.kernel.org/linux-mm/202204192051.BH3Il8DE-lkp@intel.com
https://lore.kernel.org/lkml/202204140043.Tx7BIBvI-lkp@intel.com
https://lore.kernel.org/llvm/202203241958.Uw9bWfMD-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/bus/mhi/host/main.c:787:13: warning: parameter 'event_quota' set but not used [-Wunused-but-set-parameter]
drivers/gpu/drm/amd/amdgpu/../display/dc/virtual/virtual_link_hwss.c:32:6: warning: no previous prototype for 'virtual_setup_stream_attribute' [-Wmissing-prototypes]
kernel/sched/sched.h: linux/static_key.h is included more than once.
ntb_perf.c:(.text+0x6052): undefined reference to `__umoddi3'

Unverified Error/Warning (likely false positive, please contact us if interested):

Makefile:684: arch/h8300/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
arch/s390/include/asm/spinlock.h:81:3: error: unexpected token in '.rept' directive
arch/s390/include/asm/spinlock.h:81:3: error: unknown directive
arch/s390/include/asm/spinlock.h:81:3: error: unmatched '.endr' directive
arch/s390/lib/spinlock.c:78:3: error: unexpected token in '.rept' directive
arch/s390/lib/spinlock.c:78:3: error: unknown directive
arch/s390/lib/spinlock.c:78:3: error: unmatched '.endr' directive
drivers/bus/mhi/host/main.c:1580:4: warning: Attempt to free released memory [clang-analyzer-unix.Malloc]
drivers/dma-buf/st-dma-fence-unwrap.c:125:13: warning: variable 'err' set but not used [-Wunused-but-set-variable]
drivers/edac/edac_device.c:73 edac_device_alloc_ctl_info() warn: Please consider using kcalloc instead
drivers/edac/edac_mc.c:369 edac_mc_alloc() warn: Please consider using kcalloc instead
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubp.c:57:6: warning: no previous prototype for 'hubp31_program_extended_blank' [-Wmissing-prototypes]
drivers/gpu/drm/solomon/ssd130x.c:486:2: warning: Undefined or garbage value returned to caller [clang-analyzer-core.uninitialized.UndefReturn]
drivers/hwmon/da9055-hwmon.c:201:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/hwmon/scpi-hwmon.c:121:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/hwmon/vt8231.c:634:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/tty/synclink_gt.c:3432:2: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/chipidea/core.c:956:10: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/core.c:1664:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/video/fbdev/matrox/matroxfb_base.c:1094:5: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/vme/bridges/vme_tsi148.c:754:2: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
kernel/bpf/syscall.c:4944:13: warning: no previous prototype for function 'unpriv_ebpf_notify' [-Wmissing-prototypes]
kernel/module/main.c:2189:4: warning: Null pointer passed as 1st argument to memory copy function [clang-analyzer-unix.cstring.NullArg]
kernel/module/main.c:924:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
lib/vsprintf.c:2781:5: warning: Null pointer passed as 1st argument to memory copy function [clang-analyzer-unix.cstring.NullArg]
lib/vsprintf.c:2801:12: warning: Dereference of null pointer (loaded from variable 'str') [clang-analyzer-core.NullDereference]
make[1]: *** No rule to make target 'arch/h8300/Makefile'.
mm/memory.c: linux/mm_inline.h is included more than once.
net/ipv4/tcp_cong.c:430:32: warning: Division by zero [clang-analyzer-core.DivideZero]

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- alpha-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- alpha-randconfig-r002-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- arc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- arc-randconfig-r025-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arc-randconfig-r026-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arc-randconfig-r036-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arm-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- arm-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- arm-randconfig-c002-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arm64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- arm64-randconfig-s031-20220419
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- mm-memory.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-unsigned-long-zap_flags-got-restricted-zap_flags_t
|   `-- mm-memory.c:sparse:sparse:symbol-vma_needs_copy-was-not-declared.-Should-it-be-static
|-- csky-randconfig-r033-20220419
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- h8300-allmodconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-allyesconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-defconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn31-dcn31_hubp.c:warning:no-previous-prototype-for-hubp31_program_extended_blank
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- i386-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn31-dcn31_hubp.c:warning:no-previous-prototype-for-hubp31_program_extended_blank
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- i386-randconfig-a001
|   `-- ntb_perf.c:(.text):undefined-reference-to-__umoddi3
|-- i386-randconfig-m021
|   |-- drivers-edac-edac_device.c-edac_device_alloc_ctl_info()-warn:Please-consider-using-kcalloc-instead
|   `-- drivers-edac-edac_mc.c-edac_mc_alloc()-warn:Please-consider-using-kcalloc-instead
|-- i386-randconfig-s001
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- mm-memory.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-unsigned-long-zap_flags-got-restricted-zap_flags_t
|   `-- mm-memory.c:sparse:sparse:symbol-vma_needs_copy-was-not-declared.-Should-it-be-static
|-- i386-randconfig-s002
|   |-- fs-hugetlbfs-inode.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-zap_flags-got-restricted-zap_flags_t-usertype
|   |-- mm-hugetlb.c:sparse:sparse:restricted-zap_flags_t-degrades-to-integer
|   |-- mm-memory.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-unsigned-long-zap_flags-got-restricted-zap_flags_t
|   `-- mm-memory.c:sparse:sparse:symbol-vma_needs_copy-was-not-declared.-Should-it-be-static
|-- ia64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- ia64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- ia64-randconfig-p002-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- ia64-randconfig-r003-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- m68k-allmodconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- m68k-allyesconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- mips-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- mips-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- mips-randconfig-c023-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- mips-randconfig-r001-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- nios2-allmodconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- nios2-allyesconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- openrisc-randconfig-r022-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- parisc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- parisc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- parisc-buildonly-randconfig-r003-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- powerpc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- powerpc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- powerpc-buildonly-randconfig-r001-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- powerpc64-randconfig-m031-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- riscv-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- riscv-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- riscv-randconfig-r042-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- s390-allmodconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- s390-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- sh-allmodconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sparc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- sparc-randconfig-r012-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sparc-randconfig-r013-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sparc64-randconfig-r031-20220419
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sparc64-randconfig-s032-20220419
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- fs-hugetlbfs-inode.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-zap_flags-got-restricted-zap_flags_t-usertype
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- mm-hugetlb.c:sparse:sparse:restricted-zap_flags_t-degrades-to-integer
|   |-- mm-memory.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-unsigned-long-zap_flags-got-restricted-zap_flags_t
|   `-- mm-memory.c:sparse:sparse:symbol-vma_needs_copy-was-not-declared.-Should-it-be-static
|-- x86_64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- x86_64-allnoconfig
|   |-- kernel-sched-sched.h:linux-static_key.h-is-included-more-than-once.
|   `-- mm-memory.c:linux-mm_inline.h-is-included-more-than-once.
|-- x86_64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- x86_64-randconfig-m001
|   |-- drivers-edac-edac_device.c-edac_device_alloc_ctl_info()-warn:Please-consider-using-kcalloc-instead
|   `-- drivers-edac-edac_mc.c-edac_mc_alloc()-warn:Please-consider-using-kcalloc-instead
|-- x86_64-randconfig-s021
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- mm-memory.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-unsigned-long-zap_flags-got-restricted-zap_flags_t
|   `-- mm-memory.c:sparse:sparse:symbol-vma_needs_copy-was-not-declared.-Should-it-be-static
|-- x86_64-randconfig-s022
|   |-- fs-hugetlbfs-inode.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-zap_flags-got-restricted-zap_flags_t-usertype
|   |-- mm-hugetlb.c:sparse:sparse:restricted-zap_flags_t-degrades-to-integer
|   |-- mm-memory.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-unsigned-long-zap_flags-got-restricted-zap_flags_t
|   `-- mm-memory.c:sparse:sparse:symbol-vma_needs_copy-was-not-declared.-Should-it-be-static
|-- x86_64-rhel-8.3-kselftests
|   |-- fs-hugetlbfs-inode.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-zap_flags-got-restricted-zap_flags_t-usertype
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- mm-hugetlb.c:sparse:sparse:restricted-zap_flags_t-degrades-to-integer
|   |-- mm-memory.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-unsigned-long-zap_flags-got-restricted-zap_flags_t
|   `-- mm-memory.c:sparse:sparse:symbol-vma_needs_copy-was-not-declared.-Should-it-be-static
|-- xtensa-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
`-- xtensa-randconfig-r023-20220419
    `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used

clang_recent_errors
|-- arm-randconfig-c002-20220419
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-module-main.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functio
|   `-- kernel-module-main.c:warning:Null-pointer-passed-as-1st-argument-to-memory-copy-function-clang-analyzer-unix.cstring.NullArg
|-- hexagon-randconfig-r041-20220419
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- hexagon-randconfig-r045-20220419
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- i386-randconfig-a002
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- i386-randconfig-a004
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- i386-randconfig-a011
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- i386-randconfig-a013
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- i386-randconfig-a015
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- i386-randconfig-c001
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|   |-- kernel-module-main.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functio
|   |-- kernel-module-main.c:warning:Null-pointer-passed-as-1st-argument-to-memory-copy-function-clang-analyzer-unix.cstring.NullArg
|   |-- lib-vsprintf.c:warning:Dereference-of-null-pointer-(loaded-from-variable-str-)-clang-analyzer-core.NullDereference
|   |-- lib-vsprintf.c:warning:Null-pointer-passed-as-1st-argument-to-memory-copy-function-clang-analyzer-unix.cstring.NullArg
|   `-- net-ipv4-tcp_cong.c:warning:Division-by-zero-clang-analyzer-core.DivideZero
|-- riscv-randconfig-c006-20220419
|   |-- drivers-bus-mhi-host-main.c:warning:Attempt-to-free-released-memory-clang-analyzer-unix.Malloc
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- drivers-gpu-drm-solomon-ssd13.c:warning:Undefined-or-garbage-value-returned-to-caller-clang-analyzer-core.uninitialized.UndefReturn
|   |-- drivers-hwmon-da9055-hwmon.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous
|   |-- drivers-hwmon-scpi-hwmon.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-f
|   |-- drivers-hwmon-vt8231.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-funct
|   |-- drivers-tty-synclink_gt.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-fu
|   |-- drivers-usb-chipidea-core.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-
|   |-- drivers-usb-gadget-udc-core.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- drivers-video-fbdev-matrox-matroxfb_base.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-
|   |-- drivers-vme-bridges-vme_tsi148.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analo
|   `-- kernel-module-main.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functio
|-- s390-randconfig-c005-20220419
|   |-- arch-s390-include-asm-spinlock.h:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unknown-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unmatched-.endr-directive
|   |-- arch-s390-lib-spinlock.c:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-lib-spinlock.c:error:unknown-directive
|   |-- arch-s390-lib-spinlock.c:error:unmatched-.endr-directive
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|-- s390-randconfig-r032-20220419
|   |-- arch-s390-include-asm-spinlock.h:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unknown-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unmatched-.endr-directive
|   |-- arch-s390-lib-spinlock.c:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-lib-spinlock.c:error:unknown-directive
|   |-- arch-s390-lib-spinlock.c:error:unmatched-.endr-directive
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|-- s390-randconfig-r035-20220419
|   |-- arch-s390-include-asm-spinlock.h:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unknown-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unmatched-.endr-directive
|   |-- arch-s390-lib-spinlock.c:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-lib-spinlock.c:error:unknown-directive
|   |-- arch-s390-lib-spinlock.c:error:unmatched-.endr-directive
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- x86_64-allmodconfig
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- x86_64-randconfig-a001
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- x86_64-randconfig-a005
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|-- x86_64-randconfig-a012
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- x86_64-randconfig-a014
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|-- x86_64-randconfig-a016
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
`-- x86_64-randconfig-c007
    |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
    |-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
    |-- kernel-module-main.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functio
    |-- kernel-module-main.c:warning:Null-pointer-passed-as-1st-argument-to-memory-copy-function-clang-analyzer-unix.cstring.NullArg
    `-- net-ipv4-tcp_cong.c:warning:Division-by-zero-clang-analyzer-core.DivideZero

elapsed time: 723m

configs tested: 129
configs skipped: 4

gcc tested configs:
arm                              allyesconfig
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allmodconfig
ia64                             allmodconfig
i386                             allyesconfig
ia64                             allyesconfig
i386                          randconfig-c001
parisc                           allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
alpha                            allyesconfig
arc                              allyesconfig
nios2                            allyesconfig
arm                         axm55xx_defconfig
openrisc                            defconfig
sh                           se7724_defconfig
sh                             espt_defconfig
sh                          rsk7201_defconfig
xtensa                       common_defconfig
arm                         nhk8815_defconfig
sh                            hp6xx_defconfig
sh                               j2_defconfig
sh                   secureedge5410_defconfig
arm                        multi_v7_defconfig
sparc                       sparc32_defconfig
ia64                            zx1_defconfig
powerpc                    klondike_defconfig
powerpc                         ps3_defconfig
mips                         tb0226_defconfig
sh                             sh03_defconfig
powerpc                     taishan_defconfig
m68k                        stmark2_defconfig
h8300                               defconfig
powerpc                 mpc8540_ads_defconfig
arm                          badge4_defconfig
riscv                               defconfig
sh                         microdev_defconfig
sh                          rsk7203_defconfig
powerpc                     pq2fads_defconfig
arc                          axs103_defconfig
riscv                            allyesconfig
x86_64                        randconfig-c001
arm                  randconfig-c002-20220419
ia64                                defconfig
m68k                                defconfig
m68k                             allyesconfig
m68k                             allmodconfig
nios2                               defconfig
alpha                               defconfig
csky                                defconfig
arc                                 defconfig
xtensa                           allyesconfig
parisc                              defconfig
parisc64                            defconfig
s390                             allmodconfig
s390                                defconfig
s390                             allyesconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
sparc                               defconfig
sparc                            allyesconfig
mips                             allmodconfig
mips                             allyesconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
powerpc                          allyesconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
riscv                randconfig-r042-20220419
s390                 randconfig-r044-20220419
arc                  randconfig-r043-20220419
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                                  kexec
x86_64                          rhel-8.3-func
x86_64                               rhel-8.3
x86_64                         rhel-8.3-kunit
x86_64                           allyesconfig

clang tested configs:
arm                  randconfig-c002-20220419
powerpc              randconfig-c003-20220419
x86_64                        randconfig-c007
mips                 randconfig-c004-20220419
i386                          randconfig-c001
s390                 randconfig-c005-20220419
riscv                randconfig-c006-20220419
arm                          collie_defconfig
mips                      maltaaprp_defconfig
mips                   sb1250_swarm_defconfig
powerpc                        icon_defconfig
arm                        neponset_defconfig
powerpc                 mpc8272_ads_defconfig
powerpc                      obs600_defconfig
powerpc                        fsp2_defconfig
riscv                    nommu_virt_defconfig
mips                          malta_defconfig
powerpc                     tqm8560_defconfig
mips                        bcm63xx_defconfig
arm                        mvebu_v5_defconfig
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
hexagon              randconfig-r041-20220419
hexagon              randconfig-r045-20220419

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
