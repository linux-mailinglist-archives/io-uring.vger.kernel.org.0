Return-Path: <io-uring+bounces-341-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B3A481B530
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 12:50:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5138287025
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 11:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D04436DCF9;
	Thu, 21 Dec 2023 11:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TfSooO66"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E1F6E2B0;
	Thu, 21 Dec 2023 11:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703159398; x=1734695398;
  h=date:from:to:cc:subject:message-id;
  bh=5Ugo6XPDXOGmB1QpXkg1/4Iemh7ExO/2PYOBM4Tr89A=;
  b=TfSooO66C4Y0Rw19+sYNeZBO8cCT2zquoUKx7WkyWX0o2ugS1ao+mjeF
   o2q/+9jFFwUqDzd/n4u20kw8KOKc+Z2LGKsYJovmXRwLJuOAE7tfupanU
   b+Aai/42dT1eJOhycKc4yw3PUU8K5ACwH6mPxv33x+94AwMOkMjjU6Pcc
   bDeRiQ7CPkobcIMB7YeUOwL3vMTmBVBoR75rB9tHQREbdn2UfFYivVdHW
   FNuaYNEWQTYFD/5YdKhQn91pH0dgeIhFuooMQEqm9SVmbbZcxsCKSqq0Z
   xPEYTm4hGcaMiFK8G6SL5UOqFAfS+Qxynkw3N+Qdjw34bKRUCbizWISs5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="17517252"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="17517252"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 03:49:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="1023838258"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="1023838258"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by fmsmga006.fm.intel.com with ESMTP; 21 Dec 2023 03:49:49 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rGHYh-0008IP-20;
	Thu, 21 Dec 2023 11:49:47 +0000
Date: Thu, 21 Dec 2023 19:48:56 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 amd-gfx@lists.freedesktop.org, chrome-platform@lists.linux.dev,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 intel-wired-lan@lists.osuosl.org, io-uring@vger.kernel.org,
 kunit-dev@googlegroups.com, kvm@vger.kernel.org,
 linux-afs@lists.infradead.org, linux-arm-msm@vger.kernel.org,
 linux-bcachefs@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-leds@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-um@lists.infradead.org, sparclinux@vger.kernel.org
Subject: [linux-next:master] BUILD REGRESSION
 20d857259d7d10cd0d5e8b60608455986167cfad
Message-ID: <202312211945.OCaEIYly-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 20d857259d7d10cd0d5e8b60608455986167cfad  Add linux-next specific files for 20231220

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202312202105.vqJ5GA70-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202312202115.oDmvN1VE-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202312202346.wk6hRusj-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202312210144.vItcGK51-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

(.text+0xd84): undefined reference to `__generic_xchg_called_with_bad_pointer'
.tmp_gl_rotate.o:(.text+0x8e0): undefined reference to `__generic_xchg_called_with_bad_pointer'
arch/x86/um/sysrq_64.c:20:51: error: call to undeclared function 'task_pid_nr'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_state.c:329: warning: Excess function parameter 'context' description in 'dc_state_rem_all_planes_for_stream'
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_state.c:329: warning: Function parameter or struct member 'state' not described in 'dc_state_rem_all_planes_for_stream'
drivers/gpu/drm/amd/amdgpu/../display/dc/dc_dmub_srv.c:540: warning: Function parameter or struct member 'context' not described in 'populate_subvp_cmd_drr_info'
drivers/vfio/pci/virtio/main.c:550:6: warning: no previous prototype for 'virtiovf_pci_aer_reset_done' [-Wmissing-prototypes]
drivers/vfio/pci/virtio/main.c:550:6: warning: no previous prototype for function 'virtiovf_pci_aer_reset_done' [-Wmissing-prototypes]

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_state.c:130:30: sparse: sparse: Using plain integer as NULL pointer
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_state.c:49:15: sparse: sparse: memcpy with byte count of 215064
{standard input}:25290: Warning: overflow in branch to .L4737; converted into longer instruction sequence
{standard input}:48638: Warning: overflow in branch to .L4807; converted into longer instruction sequence
{standard input}:48900: Warning: overflow in branch to .L4815; converted into longer instruction sequence
{standard input}:49917: Warning: overflow in branch to .L4691; converted into longer instruction sequence
{standard input}:6801: Warning: overflow in branch to .L1615; converted into longer instruction sequence

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arc-allmodconfig
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arc-randconfig-001-20231220
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arc-randconfig-002-20231220
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arc-randconfig-r111-20231220
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:sparse:sparse:memcpy-with-byte-count-of
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   `-- lib-zstd-compress-zstd_fast.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|-- arm-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arm-randconfig-002-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arm-randconfig-003-20231220
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arm-randconfig-004-20231220
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arm64-defconfig
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l0_free_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l0_prealloc_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l1_free_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l1_prealloc_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-pvr_dev-description-in-pvr_mmu_backing_page
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-sgt-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-sgt_offset-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   `-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|-- arm64-randconfig-001-20231220
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-lib-zlib_inflate-zlib_inflate.o
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arm64-randconfig-002-20231220
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arm64-randconfig-003-20231220
|   `-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|-- arm64-randconfig-004-20231220
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l0_free_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l0_prealloc_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l1_free_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l1_prealloc_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-pvr_dev-description-in-pvr_mmu_backing_page
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-sgt-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-sgt_offset-description-in-pvr_mmu_op_context
|   `-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|-- csky-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- csky-allyesconfig
|   |-- (.text):undefined-reference-to-__generic_xchg_called_with_bad_pointer
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- csky-randconfig-001-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- csky-randconfig-002-20231220
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   `-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|-- i386-buildonly-randconfig-001-20231220
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-exportfs-exportfs.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-lib-zlib_inflate-zlib_inflate.o
|-- i386-buildonly-randconfig-002-20231220
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-lib-zlib_inflate-zlib_inflate.o
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-buildonly-randconfig-006-20231220
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-003-20231220
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-051-20231220
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-052-20231220
|   `-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|-- i386-randconfig-054-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- i386-randconfig-061-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- i386-randconfig-062-20231220
|   |-- drivers-hwmon-max31827.c:sparse:sparse:dubious:x-y
|   |-- fs-afs-main.c:sparse:sparse:cast-removes-address-space-__rcu-of-expression
|   |-- fs-afs-main.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-callback_head-head-got-struct-callback_head-noderef-__rcu
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- i386-randconfig-063-20231220
|   |-- drivers-hwmon-max31827.c:sparse:sparse:dubious:x-y
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- i386-randconfig-141-20231220
|   |-- lib-kunit-device.c-kunit_device_register_with_driver()-warn:passing-zero-to-ERR_CAST
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|   |-- lib-zstd-common-bits.h-ZSTD_countLeadingZeros32()-warn:inconsistent-indenting
|   |-- lib-zstd-common-bits.h-ZSTD_countTrailingZeros32()-warn:inconsistent-indenting
|   |-- lib-zstd-compress-..-common-bits.h-ZSTD_countLeadingZeros32()-warn:inconsistent-indenting
|   |-- lib-zstd-compress-..-common-bits.h-ZSTD_countLeadingZeros64()-warn:inconsistent-indenting
|   |-- lib-zstd-compress-..-common-bits.h-ZSTD_countTrailingZeros32()-warn:inconsistent-indenting
|   |-- lib-zstd-compress-..-common-bits.h-ZSTD_countTrailingZeros64()-warn:inconsistent-indenting
|   |-- lib-zstd-decompress-..-common-bits.h-ZSTD_countLeadingZeros32()-warn:inconsistent-indenting
|   |-- lib-zstd-decompress-..-common-bits.h-ZSTD_countTrailingZeros32()-warn:inconsistent-indenting
|   `-- lib-zstd-decompress-..-common-bits.h-ZSTD_countTrailingZeros64()-warn:inconsistent-indenting
|-- i386-randconfig-r064-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- loongarch-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- loongarch-defconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- loongarch-randconfig-001-20231220
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- loongarch-randconfig-002-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- loongarch-randconfig-r131-20231220
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- drivers-hwmon-max31827.c:sparse:sparse:dubious:x-y
|   `-- lib-zstd-compress-zstd_fast.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|-- microblaze-allmodconfig
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- microblaze-allyesconfig
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- microblaze-randconfig-r012-20220831
|   |-- (.text):undefined-reference-to-__generic_xchg_called_with_bad_pointer
|   `-- tmp_gl_rotate.o:(.text):undefined-reference-to-__generic_xchg_called_with_bad_pointer
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- mips-decstation_defconfig
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-lib-zlib_inflate-zlib_inflate.o
|-- nios2-randconfig-001-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- nios2-randconfig-002-20231220
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- openrisc-allyesconfig
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- parisc-allmodconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-tty-serial-8250_parisc.o
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- parisc-allyesconfig
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- parisc-randconfig-001-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- parisc-randconfig-002-20231220
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- powerpc-ppc64_defconfig
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- powerpc-randconfig-001-20231220
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:Unsupported-size-for-__xchg_relaxed
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- powerpc-randconfig-003-20231220
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- powerpc-randconfig-r122-20231220
|   |-- drivers-hwmon-max31827.c:sparse:sparse:dubious:x-y
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|   |-- lib-raid6-altivec4.c:sparse:incomplete-type-static-toplevel-unative_t
|   |-- lib-raid6-altivec4.c:sparse:int-static-signed-toplevel-disable_kernel_altivec(-...-)
|   |-- lib-raid6-altivec4.c:sparse:int-static-toplevel-unative_t
|   |-- lib-raid6-altivec8.c:sparse:incomplete-type-static-toplevel-unative_t
|   |-- lib-raid6-altivec8.c:sparse:int-static-signed-toplevel-disable_kernel_altivec(-...-)
|   |-- lib-raid6-altivec8.c:sparse:int-static-toplevel-unative_t
|   `-- lib-zstd-compress-zstd_fast.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|-- powerpc64-randconfig-001-20231220
|   `-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|-- powerpc64-randconfig-002-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- powerpc64-randconfig-003-20231220
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- powerpc64-randconfig-r061-20231220
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- riscv-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- riscv-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- riscv-randconfig-001-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- riscv-randconfig-002-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- riscv-randconfig-r003-20220327
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|-- s390-allmodconfig
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-s390-block-dasd_diag_mod.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-s390-block-dasd_eckd_mod.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-s390-block-dasd_fba_mod.o
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- s390-allyesconfig
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- s390-defconfig
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- s390-randconfig-r123-20231220
|   |-- drivers-hwmon-max31827.c:sparse:sparse:dubious:x-y
|   |-- fs-bcachefs-btree_iter.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   |-- fs-bcachefs-btree_iter.c:sparse:struct-btree_path
|   |-- fs-bcachefs-btree_iter.c:sparse:struct-btree_path-noderef-__rcu
|   |-- fs-bcachefs-btree_locking.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   |-- fs-bcachefs-btree_locking.c:sparse:struct-btree_path
|   |-- fs-bcachefs-btree_locking.c:sparse:struct-btree_path-noderef-__rcu
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- io_uring-register.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|   `-- lib-zstd-compress-zstd_fast.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|-- sh-allmodconfig
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- sh-allnoconfig
|   `-- standard-input:Warning:overflow-in-branch-to-.L1609-converted-into-longer-instruction-sequence
|-- sh-allyesconfig
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- sh-buildonly-randconfig-r003-20230216
|   `-- standard-input:Warning:overflow-in-branch-to-.L4815-converted-into-longer-instruction-sequence
|-- sh-buildonly-randconfig-r004-20230415
|   `-- standard-input:Warning:overflow-in-branch-to-.L4691-converted-into-longer-instruction-sequence
|-- sh-randconfig-001-20231220
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- sh-randconfig-002-20231220
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|   `-- standard-input:Warning:overflow-in-branch-to-.L4819-converted-into-longer-instruction-sequence
|-- sh-randconfig-r002-20221009
|   `-- standard-input:Warning:overflow-in-branch-to-.L4807-converted-into-longer-instruction-sequence
|-- sh-randconfig-r033-20220124
|   `-- standard-input:Warning:overflow-in-branch-to-.L1615-converted-into-longer-instruction-sequence
|-- sh-randconfig-r051-20231127
|   `-- standard-input:Warning:overflow-in-branch-to-.L4737-converted-into-longer-instruction-sequence
|-- sparc-allmodconfig
|   |-- arch-sparc-kernel-module.c:warning:variable-strtab-set-but-not-used
|   |-- arch-sparc-mm-init_64.c:warning:variable-hv_pgsz_idx-set-but-not-used
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- sparc-allnoconfig
|   |-- arch-sparc-mm-leon_mm.c:warning:variable-paddrbase-set-but-not-used
|   `-- arch-sparc-mm-srmmu.c:warning:variable-clear-set-but-not-used
|-- sparc-defconfig
|   |-- arch-sparc-kernel-module.c:warning:variable-strtab-set-but-not-used
|   |-- arch-sparc-mm-leon_mm.c:warning:variable-paddrbase-set-but-not-used
|   `-- arch-sparc-mm-srmmu.c:warning:variable-clear-set-but-not-used
|-- sparc-randconfig-001-20231220
|   |-- (.head.text):relocation-truncated-to-fit:R_SPARC_WDISP22-against-init.text
|   |-- arch-sparc-kernel-module.c:warning:variable-strtab-set-but-not-used
|   |-- arch-sparc-mm-leon_mm.c:warning:variable-paddrbase-set-but-not-used
|   |-- arch-sparc-mm-srmmu.c:warning:variable-clear-set-but-not-used
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|   |-- parport_pc.c:(.text):undefined-reference-to-ebus_dma_enable
|   |-- parport_pc.c:(.text):undefined-reference-to-ebus_dma_irq_enable
|   |-- parport_pc.c:(.text):undefined-reference-to-ebus_dma_register
|   |-- sparc-linux-ld:parport_pc.c:(.text):undefined-reference-to-ebus_dma_enable
|   |-- sparc-linux-ld:parport_pc.c:(.text):undefined-reference-to-ebus_dma_irq_enable
|   |-- sparc-linux-ld:parport_pc.c:(.text):undefined-reference-to-ebus_dma_prepare
|   |-- sparc-linux-ld:parport_pc.c:(.text):undefined-reference-to-ebus_dma_request
|   |-- sparc-linux-ld:parport_pc.c:(.text):undefined-reference-to-ebus_dma_residue
|   |-- sparc-linux-ld:parport_pc.c:(.text):undefined-reference-to-ebus_dma_unregister
|   `-- sparc-linux-ld:parport_pc.c:(.text):undefined-reference-to-ns87303_lock
|-- sparc-randconfig-002-20231220
|   |-- arch-sparc-mm-init_64.c:warning:variable-hv_pgsz_idx-set-but-not-used
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- sparc64-allmodconfig
|   |-- arch-sparc-kernel-module.c:warning:variable-strtab-set-but-not-used
|   |-- arch-sparc-mm-init_64.c:warning:variable-hv_pgsz_idx-set-but-not-used
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- sparc64-allyesconfig
|   |-- arch-sparc-kernel-module.c:warning:variable-strtab-set-but-not-used
|   |-- arch-sparc-mm-init_64.c:warning:variable-hv_pgsz_idx-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- sparc64-defconfig
|   |-- arch-sparc-kernel-module.c:warning:variable-strtab-set-but-not-used
|   `-- arch-sparc-mm-init_64.c:warning:variable-hv_pgsz_idx-set-but-not-used
|-- sparc64-randconfig-001-20231220
|   |-- arch-sparc-mm-init_64.c:warning:variable-pagecv_flag-set-but-not-used
|   `-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|-- sparc64-randconfig-002-20231220
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-lib-zlib_inflate-zlib_inflate.o
|   |-- arch-sparc-kernel-module.c:warning:variable-strtab-set-but-not-used
|   |-- arch-sparc-mm-init_64.c:warning:variable-hv_pgsz_idx-set-but-not-used
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- sparc64-randconfig-r062-20231220
|   |-- arch-sparc-kernel-module.c:warning:variable-strtab-set-but-not-used
|   |-- arch-sparc-mm-init_64.c:warning:variable-pagecv_flag-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- um-randconfig-001-20231220
|   `-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|-- um-randconfig-002-20231220
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- um-randconfig-r133-20231220
|   |-- fs-afs-main.c:sparse:sparse:cast-removes-address-space-__rcu-of-expression
|   |-- fs-afs-main.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-callback_head-head-got-struct-callback_head-noderef-__rcu
|   |-- fs-bcachefs-btree_iter.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   |-- fs-bcachefs-btree_iter.c:sparse:struct-btree_path
|   |-- fs-bcachefs-btree_iter.c:sparse:struct-btree_path-noderef-__rcu
|   |-- fs-bcachefs-btree_locking.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   |-- fs-bcachefs-btree_locking.c:sparse:struct-btree_path
|   |-- fs-bcachefs-btree_locking.c:sparse:struct-btree_path-noderef-__rcu
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|   `-- lib-zstd-compress-zstd_fast.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|-- x86_64-buildonly-randconfig-001-20231220
|   `-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|-- x86_64-buildonly-randconfig-002-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-buildonly-randconfig-003-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-buildonly-randconfig-004-20231220
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-buildonly-randconfig-005-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-002-20231221
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-003-20231221
|   `-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|-- x86_64-randconfig-004-20231221
|   `-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|-- x86_64-randconfig-006-20231221
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   `-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|-- x86_64-randconfig-101-20231220
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-102-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-103-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-104-20231220
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-161-20231220
|   |-- drivers-scsi-fcoe-fcoe_sysfs.c-store_ctlr_mode()-warn:unsigned-ctlr-mode-is-never-less-than-zero.
|   |-- lib-kunit-device.c-kunit_device_register_with_driver()-warn:passing-zero-to-ERR_CAST
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|   |-- lib-zstd-common-bits.h-ZSTD_countLeadingZeros32()-warn:inconsistent-indenting
|   |-- lib-zstd-common-bits.h-ZSTD_countTrailingZeros32()-warn:inconsistent-indenting
|   |-- lib-zstd-compress-..-common-bits.h-ZSTD_countLeadingZeros32()-warn:inconsistent-indenting
|   |-- lib-zstd-compress-..-common-bits.h-ZSTD_countLeadingZeros64()-warn:inconsistent-indenting
|   |-- lib-zstd-compress-..-common-bits.h-ZSTD_countTrailingZeros32()-warn:inconsistent-indenting
|   |-- lib-zstd-compress-..-common-bits.h-ZSTD_countTrailingZeros64()-warn:inconsistent-indenting
|   |-- lib-zstd-decompress-..-common-bits.h-ZSTD_countLeadingZeros32()-warn:inconsistent-indenting
|   `-- lib-zstd-decompress-..-common-bits.h-ZSTD_countTrailingZeros64()-warn:inconsistent-indenting
|-- x86_64-randconfig-r051-20231220
|   |-- drivers-net-ethernet-intel-ice-ice_base.c:error:storage-size-of-desc-isn-t-known
|   |-- drivers-net-ethernet-intel-ice-ice_base.c:error:variable-desc-has-initializer-but-incomplete-type
|   |-- drivers-net-ethernet-intel-ice-ice_base.c:warning:unused-variable-desc
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-r063-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-r113-20231220
|   |-- drivers-hwmon-max31827.c:sparse:sparse:dubious:x-y
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- xtensa-randconfig-001-20231220
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- xtensa-randconfig-002-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
`-- xtensa-randconfig-r054-20231220
    |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
    |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
    |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
    |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
    |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
    |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
    |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
    `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
clang_recent_errors
|-- arm-defconfig
|   |-- WARNING:modpost:vmlinux:section-mismatch-in-reference:at91_poweroff_probe-(section:.text)-at91_wakeup_status-(section:.init.text)
|   |-- WARNING:modpost:vmlinux:section-mismatch-in-reference:at91_shdwc_probe-(section:.text)-at91_wakeup_status-(section:.init.text)
|   `-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|-- arm64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l0_free_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l0_prealloc_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l1_free_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l1_prealloc_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-pvr_dev-description-in-pvr_mmu_backing_page
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-sgt-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-sgt_offset-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-leds-leds-max5970.c:warning:variable-num_leds-set-but-not-used
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-function-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l0_free_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l0_prealloc_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l1_free_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-l1_prealloc_tables-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-pvr_dev-description-in-pvr_mmu_backing_page
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-sgt-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-imagination-pvr_mmu.c:warning:Excess-struct-member-sgt_offset-description-in-pvr_mmu_op_context
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-leds-leds-max5970.c:warning:variable-num_leds-set-but-not-used
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-function-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- hexagon-allmodconfig
|   |-- drivers-leds-leds-max5970.c:warning:variable-num_leds-set-but-not-used
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- hexagon-allyesconfig
|   |-- drivers-leds-leds-max5970.c:warning:variable-num_leds-set-but-not-used
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- hexagon-randconfig-001-20231220
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- hexagon-randconfig-r121-20231220
|   |-- drivers-hwmon-max31827.c:sparse:sparse:dubious:x-y
|   |-- drivers-leds-leds-max5970.c:warning:variable-num_leds-set-but-not-used
|   |-- fs-bcachefs-btree_iter.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   |-- fs-bcachefs-btree_iter.c:sparse:struct-btree_path
|   |-- fs-bcachefs-btree_iter.c:sparse:struct-btree_path-noderef-__rcu
|   |-- fs-bcachefs-btree_locking.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   |-- fs-bcachefs-btree_locking.c:sparse:struct-btree_path
|   |-- fs-bcachefs-btree_locking.c:sparse:struct-btree_path-noderef-__rcu
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|   `-- lib-zstd-compress-zstd_fast.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|-- i386-randconfig-011-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- i386-randconfig-012-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- i386-randconfig-013-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- i386-randconfig-016-20231220
|   |-- drivers-net-ethernet-intel-ice-ice_base.c:error:variable-has-incomplete-type-struct-xsk_cb_desc
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-leds-leds-max5970.c:warning:variable-num_leds-set-but-not-used
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-function-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- powerpc-allyesconfig
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-leds-leds-max5970.c:warning:variable-num_leds-set-but-not-used
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-function-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- riscv-randconfig-r132-20231220
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_iter.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   |-- fs-bcachefs-btree_iter.c:sparse:struct-btree_path
|   |-- fs-bcachefs-btree_iter.c:sparse:struct-btree_path-noderef-__rcu
|   |-- fs-bcachefs-btree_locking.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   |-- fs-bcachefs-btree_locking.c:sparse:struct-btree_path
|   |-- fs-bcachefs-btree_locking.c:sparse:struct-btree_path-noderef-__rcu
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|   `-- lib-zstd-compress-zstd_fast.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|-- s390-randconfig-001-20231220
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-base-regmap-regmap-mmio.o
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-s390-block-dasd_diag_mod.o
|   `-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-drivers-s390-block-dasd_eckd_mod.o
|-- um-randconfig-002-20231221
|   `-- arch-x86-um-sysrq_64.c:error:call-to-undeclared-function-task_pid_nr-ISO-C99-and-later-do-not-support-implicit-function-declarations-Werror-Wimplicit-function-declaration
|-- x86_64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-leds-leds-max5970.c:warning:variable-num_leds-set-but-not-used
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-function-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|   |-- drivers-leds-leds-max5970.c:warning:variable-num_leds-set-but-not-used
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- drivers-vfio-pci-virtio-main.c:warning:no-previous-prototype-for-function-virtiovf_pci_aer_reset_done
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-buildonly-randconfig-001-20231221
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-buildonly-randconfig-003-20231221
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-buildonly-randconfig-004-20231221
|   |-- WARNING:modpost:missing-MODULE_DESCRIPTION()-in-fs-exportfs-exportfs.o
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-buildonly-randconfig-005-20231221
|   `-- drivers-gpu-drm-msm-disp-dpu1-dpu_encoder.c:warning:Excess-struct-member-debugfs_root-description-in-dpu_encoder_virt
|-- x86_64-buildonly-randconfig-006-20231221
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-001-20231220
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-002-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-004-20231220
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-011-20231221
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-012-20231221
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-013-20231221
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Excess-function-parameter-context-description-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_state.c:warning:Function-parameter-or-struct-member-state-not-described-in-dc_state_rem_all_planes_for_stream
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dc_dmub_srv.c:warning:Function-parameter-or-struct-member-context-not-described-in-populate_subvp_cmd_drr_info
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn35-dcn35_hwseq.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-014-20231221
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-015-20231221
|   `-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|-- x86_64-randconfig-016-20231221
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-072-20231221
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-073-20231221
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-074-20231221
|   |-- fs-bcachefs-btree_update_interior.c:warning:Function-parameter-or-struct-member-path_idx-not-described-in-bch2_btree_insert_node
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-075-20231221
|   `-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|-- x86_64-randconfig-076-20231221
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
|   |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
|   `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create
|-- x86_64-randconfig-121-20231220
|   |-- drivers-hwmon-max31827.c:sparse:sparse:dubious:x-y
|   |-- drivers-infiniband-hw-bnxt_re-qplib_fp.c:sparse:left-side-has-type-restricted-__le64
|   |-- drivers-infiniband-hw-bnxt_re-qplib_fp.c:sparse:right-side-has-type-unsigned-long-long
|   |-- drivers-infiniband-hw-bnxt_re-qplib_fp.c:sparse:sparse:invalid-assignment:
|   |-- drivers-infiniband-hw-bnxt_re-qplib_rcfw.c:sparse:left-side-has-type-restricted-__le16
|   |-- drivers-infiniband-hw-bnxt_re-qplib_rcfw.c:sparse:right-side-has-type-unsigned-long
|   |-- drivers-infiniband-hw-bnxt_re-qplib_rcfw.c:sparse:sparse:invalid-assignment:
|   |-- drivers-pwm-pwm-cros-ec.c:warning:Excess-struct-member-dev-description-in-cros_ec_pwm_device
|   |-- fs-afs-main.c:sparse:sparse:cast-removes-address-space-__rcu-of-expression
|   |-- fs-afs-main.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-callback_head-head-got-struct-callback_head-noderef-__rcu
|   `-- lib-zstd-compress-zstd_fast.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|-- x86_64-randconfig-122-20231220
|   |-- drivers-hwmon-max31827.c:sparse:sparse:dubious:x-y
|   `-- lib-zstd-compress-zstd_fast.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|-- x86_64-randconfig-123-20231220
|   `-- lib-zstd-compress-zstd_fast.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
`-- x86_64-rhel-8.3-rust
    |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-drv-not-described-in-kunit_device_register_with_driver
    |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register
    |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_device_register_with_driver
    |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-name-not-described-in-kunit_driver_create
    |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register
    |-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_device_register_with_driver
    `-- lib-kunit-device.c:warning:Function-parameter-or-struct-member-test-not-described-in-kunit_driver_create

elapsed time: 1494m

configs tested: 188
configs skipped: 3

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                   randconfig-001-20231220   gcc  
arc                   randconfig-002-20231220   gcc  
arc                           tb10x_defconfig   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   gcc  
arm                              allyesconfig   gcc  
arm                       aspeed_g5_defconfig   gcc  
arm                                 defconfig   clang
arm                   randconfig-001-20231220   gcc  
arm                   randconfig-002-20231220   gcc  
arm                   randconfig-003-20231220   gcc  
arm                   randconfig-004-20231220   gcc  
arm                           spitz_defconfig   clang
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-001-20231220   gcc  
arm64                 randconfig-002-20231220   gcc  
arm64                 randconfig-003-20231220   gcc  
arm64                 randconfig-004-20231220   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20231220   gcc  
csky                  randconfig-002-20231220   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
hexagon               randconfig-001-20231220   clang
hexagon               randconfig-002-20231220   clang
i386                             allmodconfig   clang
i386                              allnoconfig   clang
i386                             allyesconfig   clang
i386         buildonly-randconfig-001-20231220   gcc  
i386         buildonly-randconfig-002-20231220   gcc  
i386         buildonly-randconfig-003-20231220   gcc  
i386         buildonly-randconfig-004-20231220   gcc  
i386         buildonly-randconfig-005-20231220   gcc  
i386         buildonly-randconfig-006-20231220   gcc  
i386                                defconfig   gcc  
i386                  randconfig-001-20231220   gcc  
i386                  randconfig-002-20231220   gcc  
i386                  randconfig-003-20231220   gcc  
i386                  randconfig-004-20231220   gcc  
i386                  randconfig-005-20231220   gcc  
i386                  randconfig-006-20231220   gcc  
i386                  randconfig-011-20231220   clang
i386                  randconfig-012-20231220   clang
i386                  randconfig-013-20231220   clang
i386                  randconfig-014-20231220   clang
i386                  randconfig-015-20231220   clang
i386                  randconfig-016-20231220   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20231220   gcc  
loongarch             randconfig-002-20231220   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                         apollo_defconfig   gcc  
m68k                                defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                              allnoconfig   clang
mips                             allyesconfig   gcc  
mips                       bmips_be_defconfig   gcc  
mips                      bmips_stb_defconfig   clang
mips                     decstation_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20231220   gcc  
nios2                 randconfig-002-20231220   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                randconfig-001-20231220   gcc  
parisc                randconfig-002-20231220   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   clang
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc                   currituck_defconfig   gcc  
powerpc                       ebony_defconfig   clang
powerpc                        icon_defconfig   clang
powerpc                      pcm030_defconfig   gcc  
powerpc                       ppc64_defconfig   gcc  
powerpc               randconfig-001-20231220   gcc  
powerpc               randconfig-002-20231220   gcc  
powerpc               randconfig-003-20231220   gcc  
powerpc64             randconfig-001-20231220   gcc  
powerpc64             randconfig-002-20231220   gcc  
powerpc64             randconfig-003-20231220   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   clang
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                 randconfig-001-20231220   gcc  
riscv                 randconfig-002-20231220   gcc  
riscv                          rv32_defconfig   clang
s390                             allmodconfig   gcc  
s390                              allnoconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                  randconfig-001-20231220   clang
s390                  randconfig-002-20231220   clang
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                            hp6xx_defconfig   gcc  
sh                    randconfig-001-20231220   gcc  
sh                    randconfig-002-20231220   gcc  
sh                           se7780_defconfig   gcc  
sh                             sh03_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20231220   gcc  
sparc64               randconfig-002-20231220   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                    randconfig-001-20231220   gcc  
um                    randconfig-002-20231220   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           alldefconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-001-20231220   gcc  
x86_64       buildonly-randconfig-001-20231221   clang
x86_64       buildonly-randconfig-002-20231220   gcc  
x86_64       buildonly-randconfig-002-20231221   clang
x86_64       buildonly-randconfig-003-20231220   gcc  
x86_64       buildonly-randconfig-003-20231221   clang
x86_64       buildonly-randconfig-004-20231220   gcc  
x86_64       buildonly-randconfig-004-20231221   clang
x86_64       buildonly-randconfig-005-20231220   gcc  
x86_64       buildonly-randconfig-006-20231220   gcc  
x86_64       buildonly-randconfig-006-20231221   clang
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20231220   clang
x86_64                randconfig-001-20231221   gcc  
x86_64                randconfig-002-20231220   clang
x86_64                randconfig-002-20231221   gcc  
x86_64                randconfig-003-20231220   clang
x86_64                randconfig-003-20231221   gcc  
x86_64                randconfig-004-20231220   clang
x86_64                randconfig-004-20231221   gcc  
x86_64                randconfig-005-20231221   gcc  
x86_64                randconfig-006-20231221   gcc  
x86_64                randconfig-011-20231221   clang
x86_64                randconfig-012-20231221   clang
x86_64                randconfig-013-20231221   clang
x86_64                randconfig-014-20231221   clang
x86_64                randconfig-015-20231221   clang
x86_64                randconfig-016-20231221   clang
x86_64                randconfig-071-20231221   clang
x86_64                randconfig-072-20231221   clang
x86_64                randconfig-073-20231221   clang
x86_64                randconfig-074-20231221   clang
x86_64                randconfig-075-20231221   clang
x86_64                randconfig-076-20231221   clang
x86_64                          rhel-8.3-rust   clang
xtensa                            allnoconfig   gcc  
xtensa                  cadence_csp_defconfig   gcc  
xtensa                randconfig-001-20231220   gcc  
xtensa                randconfig-002-20231220   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

