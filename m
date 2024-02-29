Return-Path: <io-uring+bounces-804-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED7986D29E
	for <lists+io-uring@lfdr.de>; Thu, 29 Feb 2024 19:55:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4B8F2884EC
	for <lists+io-uring@lfdr.de>; Thu, 29 Feb 2024 18:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3674134421;
	Thu, 29 Feb 2024 18:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kIpb/WEQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D78134418;
	Thu, 29 Feb 2024 18:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709232901; cv=none; b=bt61J+8xlJcPsUwGecv4ortyJjG9DOLjoq0AmH2utfAZV49rqRHpL64cCuBLLOlQOPvlD5O+Q+D0pUkL8YMMzEtUo5DVsTAo8yswruklfhXYzMM0o1v0bbqG/ITUkVTB+8hIlqeWcoLjsGLWdiWt+xcFSCYDGz1JCKCKa92dV6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709232901; c=relaxed/simple;
	bh=iuQxW1xjGSO1XEvAVIzIV7UsS7S6az+7Ews4t2OS5Ug=;
	h=Date:From:To:Cc:Subject:Message-ID; b=g16LVTaay1PyP0Lwy3xGiMKOZLYKvR2eoM16LFOpy3rbc/3HXA6ibGV5fm0scOTDqf4r+0xicQlW3DbxxYDhqS86/IuYVxTyvHmxKfjNz6zRHN4HSExpnr1ZArii04VoLA906QNu0LqR6Ee4netGXLk8VAfHEwEjw1gXX0t4w+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kIpb/WEQ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709232898; x=1740768898;
  h=date:from:to:cc:subject:message-id;
  bh=iuQxW1xjGSO1XEvAVIzIV7UsS7S6az+7Ews4t2OS5Ug=;
  b=kIpb/WEQx/apiO+sAbP13XfjNdbtXyon8RHJ4a9gbXZUvjN0AZmST2SX
   elpiJnmLjzSmLKUIr/Moxl/uYK1Vp9/W4dirGBnlMuoL9cGIbF7xleFU4
   7v80eLMK4v6Odkor4aGvjsF46+nAbHAFG7EBW5DJc4wkVG4eX+PJx4igs
   o15HV/tHixmnrjt8SCgJEEKYbOI783SCkIunr2BwsR4hK99+7J/PbKZfP
   1qypnXIs6YmKuHR4XdPJSYswRdmsHh3CeIGyOounmtfawT/BfetO0vdTK
   6tUAnqo1t7lPI2sJmESpt0LnZigX6tvr+5jV07raHjXV6grVUHOmCmBxg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="4308257"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="4308257"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 10:54:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="12532275"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 29 Feb 2024 10:54:51 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rflYP-000DCy-0n;
	Thu, 29 Feb 2024 18:54:49 +0000
Date: Fri, 01 Mar 2024 02:53:54 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, io-uring@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-sound@vger.kernel.org, mhi@lists.linux.dev,
 netdev@vger.kernel.org, nouveau@lists.freedesktop.org
Subject: [linux-next:master] BUILD REGRESSION
 f303a3e2bcfba900efb5aee55236d17030e9f882
Message-ID: <202403010245.MXVdcekk-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: f303a3e2bcfba900efb5aee55236d17030e9f882  Add linux-next specific files for 20240229

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202402292319.eHMsyI8L-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202403010220.WelHZqIi-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

(.text+0x721c): undefined reference to `__divdi3'
arm-linux-gnueabi-ld: file.c:(.text+0x958): undefined reference to `__aeabi_ldivmod'
arm-linux-gnueabi-ld: inode.c:(.text+0x48e): undefined reference to `__aeabi_ldivmod'
data.o:(.text+0x33e0): undefined reference to `__moddi3'
drivers/hid/amd-sfh-hid/amd_sfh_pcie.c:413:34: error: 'struct cpuinfo_loongarch' has no member named 'x86'
drivers/leds/leds-gpio-register.c:23:25: warning: attribute declaration must precede definition [-Wignored-attributes]
file.c:(.text+0x944): undefined reference to `__aeabi_ldivmod'
file.o:(.text+0x820c): undefined reference to `__moddi3'
file.o:(.text+0x97d0): undefined reference to `__divdi3'
gc.o:(.text+0x4874): undefined reference to `__moddi3'
include/linux/dpll.h:179:1: warning: control reaches end of non-void function [-Wreturn-type]
inode.c:(.text+0x47a): undefined reference to `__aeabi_ldivmod'
inode.o:(.text+0x1328): undefined reference to `__moddi3'
microblaze-linux-ld: data.o:(.text+0x33fc): undefined reference to `__moddi3'
microblaze-linux-ld: data.o:(.text+0x3418): undefined reference to `__divdi3'
microblaze-linux-ld: file.o:(.text+0x8228): undefined reference to `__moddi3'
microblaze-linux-ld: file.o:(.text+0x8244): undefined reference to `__divdi3'
microblaze-linux-ld: gc.o:(.text+0x4890): undefined reference to `__moddi3'
microblaze-linux-ld: gc.o:(.text+0x48ac): undefined reference to `__divdi3'
microblaze-linux-ld: inode.o:(.text+0x1344): undefined reference to `__moddi3'
microblaze-linux-ld: inode.o:(.text+0x1360): undefined reference to `__divdi3'
microblaze-linux-ld: namei.o:(.text+0x1940): undefined reference to `__moddi3'
microblaze-linux-ld: namei.o:(.text+0x195c): undefined reference to `__divdi3'
microblaze-linux-ld: segment.o:(.text+0xda30): undefined reference to `__moddi3'
microblaze-linux-ld: segment.o:(.text+0xda4c): undefined reference to `__divdi3'
microblaze-linux-ld: xattr.o:(.text+0x1930): undefined reference to `__moddi3'
microblaze-linux-ld: xattr.o:(.text+0x194c): undefined reference to `__divdi3'
namei.o:(.text+0x1924): undefined reference to `__moddi3'
segment.o:(.text+0xda14): undefined reference to `__moddi3'
xattr.o:(.text+0x1914): undefined reference to `__moddi3'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- arc-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- arm-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- arm-randconfig-001-20240116
|   |-- arm-linux-gnueabi-ld:file.c:(.text):undefined-reference-to-__aeabi_ldivmod
|   |-- arm-linux-gnueabi-ld:inode.c:(.text):undefined-reference-to-__aeabi_ldivmod
|   |-- file.c:(.text):undefined-reference-to-__aeabi_ldivmod
|   `-- inode.c:(.text):undefined-reference-to-__aeabi_ldivmod
|-- arm-randconfig-r131-20240229
|   |-- drivers-leds-flash-leds-ktd2692.c:sparse:sparse:symbol-ktd2692_timing-was-not-declared.-Should-it-be-static
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- arm64-defconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- arm64-randconfig-002-20240229
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- csky-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- csky-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- csky-randconfig-002-20240229
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- i386-allmodconfig
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-max_group_count-not-described-in-drm_dp_tunnel_mgr_create
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tracker-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tunnel-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:expecting-prototype-for-drm_dp_tunnel_atomic_get_allocated_bw().-Prototype-was-for-drm_dp_tunnel_get_allocated_bw()-instead
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-max_group_count-not-described-in-drm_dp_tunnel_mgr_create
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tracker-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tunnel-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:expecting-prototype-for-drm_dp_tunnel_atomic_get_allocated_bw().-Prototype-was-for-drm_dp_tunnel_get_allocated_bw()-instead
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- i386-buildonly-randconfig-003-20240229
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- i386-buildonly-randconfig-005-20240229
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- i386-randconfig-012-20240229
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- i386-randconfig-061-20240229
|   |-- drivers-leds-flash-leds-ktd2692.c:sparse:sparse:symbol-ktd2692_timing-was-not-declared.-Should-it-be-static
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   `-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|-- i386-randconfig-062-20240229
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- i386-randconfig-063-20240229
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- i386-randconfig-141-20240228
|   `-- include-linux-dpll.h:warning:control-reaches-end-of-non-void-function
|-- loongarch-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- loongarch-allyesconfig
|   `-- drivers-hid-amd-sfh-hid-amd_sfh_pcie.c:error:struct-cpuinfo_loongarch-has-no-member-named-x86
|-- loongarch-defconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- loongarch-randconfig-002-20240229
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- m68k-allmodconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- m68k-allyesconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- microblaze-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- microblaze-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- microblaze-randconfig-r022-20220915
|   |-- (.text):undefined-reference-to-__divdi3
|   |-- data.o:(.text):undefined-reference-to-__moddi3
|   |-- file.o:(.text):undefined-reference-to-__divdi3
|   |-- file.o:(.text):undefined-reference-to-__moddi3
|   |-- gc.o:(.text):undefined-reference-to-__moddi3
|   |-- inode.o:(.text):undefined-reference-to-__moddi3
|   |-- microblaze-linux-ld:data.o:(.text):undefined-reference-to-__divdi3
|   |-- microblaze-linux-ld:data.o:(.text):undefined-reference-to-__moddi3
|   |-- microblaze-linux-ld:file.o:(.text):undefined-reference-to-__divdi3
|   |-- microblaze-linux-ld:file.o:(.text):undefined-reference-to-__moddi3
|   |-- microblaze-linux-ld:gc.o:(.text):undefined-reference-to-__divdi3
|   |-- microblaze-linux-ld:gc.o:(.text):undefined-reference-to-__moddi3
|   |-- microblaze-linux-ld:inode.o:(.text):undefined-reference-to-__divdi3
|   |-- microblaze-linux-ld:inode.o:(.text):undefined-reference-to-__moddi3
|   |-- microblaze-linux-ld:namei.o:(.text):undefined-reference-to-__divdi3
|   |-- microblaze-linux-ld:namei.o:(.text):undefined-reference-to-__moddi3
|   |-- microblaze-linux-ld:segment.o:(.text):undefined-reference-to-__divdi3
|   |-- microblaze-linux-ld:segment.o:(.text):undefined-reference-to-__moddi3
|   |-- microblaze-linux-ld:xattr.o:(.text):undefined-reference-to-__divdi3
|   |-- microblaze-linux-ld:xattr.o:(.text):undefined-reference-to-__moddi3
|   |-- namei.o:(.text):undefined-reference-to-__moddi3
|   |-- segment.o:(.text):undefined-reference-to-__moddi3
|   `-- xattr.o:(.text):undefined-reference-to-__moddi3
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- nios2-allmodconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- nios2-allyesconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- nios2-randconfig-001-20240229
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- openrisc-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- openrisc-randconfig-r122-20240229
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- drivers-leds-flash-leds-ktd2692.c:sparse:sparse:symbol-ktd2692_timing-was-not-declared.-Should-it-be-static
|-- parisc-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- parisc-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- parisc-defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- parisc64-defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- powerpc-randconfig-r121-20240229
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   |-- drivers-leds-flash-leds-ktd2692.c:sparse:sparse:symbol-ktd2692_timing-was-not-declared.-Should-it-be-static
|   |-- kernel-power-energy_model.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-em_perf_state-table-got-struct-em_perf_state-noderef-__rcu
|   |-- kernel-power-energy_model.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-kref-kref-got-struct-kref-noderef-__rcu
|   |-- kernel-power-energy_model.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-objp-got-struct-em_perf_table-noderef-__rcu-assigned-em_table
|   `-- kernel-power-energy_model.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-em_perf_state-new_ps-got-struct-em_perf_state-noderef-__rcu
|-- powerpc64-randconfig-001-20240229
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- s390-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- s390-randconfig-002-20240229
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- sh-allmodconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- sh-allyesconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- sparc-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- sparc-randconfig-002-20240229
|   `-- (.head.text):relocation-truncated-to-fit:R_SPARC_WDISP22-against-init.text
|-- sparc64-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- sparc64-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- um-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- x86_64-randconfig-011-20240229
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- x86_64-randconfig-013-20240229
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- x86_64-randconfig-014-20240229
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- x86_64-randconfig-016-20240229
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-max_group_count-not-described-in-drm_dp_tunnel_mgr_create
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tracker-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tunnel-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:expecting-prototype-for-drm_dp_tunnel_atomic_get_allocated_bw().-Prototype-was-for-drm_dp_tunnel_get_allocated_bw()-instead
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- x86_64-randconfig-075-20240229
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- x86_64-randconfig-121-20240229
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-leds-flash-leds-ktd2692.c:sparse:sparse:symbol-ktd2692_timing-was-not-declared.-Should-it-be-static
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   |-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|   |-- kernel-power-energy_model.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-em_perf_state-table-got-struct-em_perf_state-noderef-__rcu
|   |-- kernel-power-energy_model.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-kref-kref-got-struct-kref-noderef-__rcu
|   |-- kernel-power-energy_model.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-objp-got-struct-em_perf_table-noderef-__rcu-assigned-em_table
|   `-- kernel-power-energy_model.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-em_perf_state-new_ps-got-struct-em_perf_state-noderef-__rcu
|-- x86_64-randconfig-161-20240229
|   |-- drivers-acpi-property.c-acpi_data_add_buffer_props()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- fs-proc-proc_sysctl.c-proc_sys_call_handler()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- io_uring-filetable.c-io_alloc_file_tables()-error:kvcalloc()-does-not-make-sense-for-no-sleep-code
|   |-- kernel-resource.c-walk_system_ram_res_rev()-error:kvcalloc()-does-not-make-sense-for-no-sleep-code
|   |-- lib-stackdepot.c-stack_depot_init()-error:kvcalloc()-does-not-make-sense-for-no-sleep-code
|   |-- net-ethtool-common.c-ethtool_get_max_rxnfc_channel()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- net-ipv4-fib_semantics.c-fib_create_info()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   `-- net-ipv4-tcp_metrics.c-tcp_metrics_hash_alloc()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|-- x86_64-randconfig-r113-20240229
|   |-- drivers-leds-flash-leds-ktd2692.c:sparse:sparse:symbol-ktd2692_timing-was-not-declared.-Should-it-be-static
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- xtensa-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
`-- xtensa-randconfig-002-20240229
    `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
clang_recent_errors
|-- arm-defconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- arm64-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- hexagon-allmodconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- hexagon-allyesconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- i386-randconfig-003-20240229
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-max_group_count-not-described-in-drm_dp_tunnel_mgr_create
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tracker-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tunnel-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:expecting-prototype-for-drm_dp_tunnel_atomic_get_allocated_bw().-Prototype-was-for-drm_dp_tunnel_get_allocated_bw()-instead
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- i386-randconfig-013-20240229
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- i386-randconfig-015-20240229
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- i386-randconfig-141-20240229
|   |-- drivers-acpi-property.c-acpi_data_add_buffer_props()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- drivers-gpu-drm-drm_property.c-drm_property_create_blob()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- drivers-media-common-videobuf2-videobuf2-dma-sg.c-vb2_dma_sg_alloc()-error:kvcalloc()-does-not-make-sense-for-no-sleep-code
|   |-- drivers-media-v4l2-core-v4l2-event.c-v4l2_event_subscribe()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- drivers-media-v4l2-core-v4l2-subdev.c-__v4l2_subdev_state_alloc()-error:kvcalloc()-does-not-make-sense-for-no-sleep-code
|   |-- drivers-media-v4l2-core-v4l2-subdev.c-v4l2_subdev_init_stream_configs()-error:kvcalloc()-does-not-make-sense-for-no-sleep-code
|   |-- drivers-scsi-sd_zbc.c-sd_zbc_revalidate_zones()-error:kvcalloc()-does-not-make-sense-for-no-sleep-code
|   |-- fs-btrfs-free-space-tree.c-alloc_bitmap()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- fs-btrfs-raid56.c-btrfs_alloc_stripe_hash_table()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- fs-btrfs-scrub.c-scrub_setup_ctx()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- fs-proc-proc_sysctl.c-proc_sys_call_handler()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- io_uring-filetable.c-io_alloc_file_tables()-error:kvcalloc()-does-not-make-sense-for-no-sleep-code
|   |-- kernel-resource.c-walk_system_ram_res_rev()-error:kvcalloc()-does-not-make-sense-for-no-sleep-code
|   |-- lib-stackdepot.c-stack_depot_init()-error:kvcalloc()-does-not-make-sense-for-no-sleep-code
|   |-- net-ethtool-common.c-ethtool_get_max_rxnfc_channel()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- net-ipv4-fib_semantics.c-fib_create_info()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- net-ipv4-tcp_metrics.c-tcp_metrics_hash_alloc()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- sound-core-info.c-snd_info_text_entry_write()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|   |-- sound-core-memalloc.c-snd_dma_sg_fallback_alloc()-error:kvcalloc()-does-not-make-sense-for-no-sleep-code
|   `-- sound-soc-intel-atom-sst-sst.c-intel_sst_suspend()-error:kvzalloc()-does-not-make-sense-for-no-sleep-code
|-- i386-randconfig-r123-20240229
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-leds-flash-leds-ktd2692.c:sparse:sparse:symbol-ktd2692_timing-was-not-declared.-Should-it-be-static
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- mips-bcm47xx_defconfig
|   `-- drivers-leds-leds-gpio-register.c:warning:attribute-declaration-must-precede-definition
|-- powerpc-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- powerpc-randconfig-003-20240229
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- powerpc64-randconfig-002-20240229
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- riscv-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- riscv-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- riscv-defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- s390-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- x86_64-allmodconfig
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-max_group_count-not-described-in-drm_dp_tunnel_mgr_create
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tracker-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tunnel-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:expecting-prototype-for-drm_dp_tunnel_atomic_get_allocated_bw().-Prototype-was-for-drm_dp_tunnel_get_allocated_bw()-instead
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- x86_64-allyesconfig
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-max_group_count-not-described-in-drm_dp_tunnel_mgr_create
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tracker-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tunnel-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:expecting-prototype-for-drm_dp_tunnel_atomic_get_allocated_bw().-Prototype-was-for-drm_dp_tunnel_get_allocated_bw()-instead
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- x86_64-randconfig-001-20240229
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-max_group_count-not-described-in-drm_dp_tunnel_mgr_create
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tracker-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tunnel-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:expecting-prototype-for-drm_dp_tunnel_atomic_get_allocated_bw().-Prototype-was-for-drm_dp_tunnel_get_allocated_bw()-instead
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- x86_64-randconfig-003-20240229
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-max_group_count-not-described-in-drm_dp_tunnel_mgr_create
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tracker-not-described-in-drm_dp_tunnel_put
|   |-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:Function-parameter-or-struct-member-tunnel-not-described-in-drm_dp_tunnel_put
|   `-- drivers-gpu-drm-display-drm_dp_tunnel.c:warning:expecting-prototype-for-drm_dp_tunnel_atomic_get_allocated_bw().-Prototype-was-for-drm_dp_tunnel_get_allocated_bw()-instead
|-- x86_64-randconfig-004-20240229
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- x86_64-randconfig-005-20240229
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- x86_64-randconfig-122-20240229
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   |-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
`-- x86_64-randconfig-123-20240229
    |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
    |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
    |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
    |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
    `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t

elapsed time: 730m

configs tested: 179
configs skipped: 3

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                   randconfig-001-20240229   gcc  
arc                   randconfig-002-20240229   gcc  
arc                    vdk_hs38_smp_defconfig   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                                 defconfig   clang
arm                          gemini_defconfig   clang
arm                      integrator_defconfig   clang
arm                      jornada720_defconfig   clang
arm                         mv78xx0_defconfig   clang
arm                          pxa3xx_defconfig   clang
arm                   randconfig-001-20240229   gcc  
arm                   randconfig-002-20240229   gcc  
arm                   randconfig-003-20240229   clang
arm                   randconfig-004-20240229   gcc  
arm                           spitz_defconfig   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-001-20240229   clang
arm64                 randconfig-002-20240229   gcc  
arm64                 randconfig-003-20240229   clang
arm64                 randconfig-004-20240229   clang
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240229   gcc  
csky                  randconfig-002-20240229   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
hexagon               randconfig-001-20240229   clang
hexagon               randconfig-002-20240229   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240229   clang
i386         buildonly-randconfig-002-20240229   gcc  
i386         buildonly-randconfig-003-20240229   gcc  
i386         buildonly-randconfig-004-20240229   clang
i386         buildonly-randconfig-005-20240229   gcc  
i386         buildonly-randconfig-006-20240229   gcc  
i386                                defconfig   clang
i386                  randconfig-001-20240229   clang
i386                  randconfig-002-20240229   gcc  
i386                  randconfig-003-20240229   clang
i386                  randconfig-004-20240229   gcc  
i386                  randconfig-005-20240229   gcc  
i386                  randconfig-006-20240229   gcc  
i386                  randconfig-011-20240229   gcc  
i386                  randconfig-012-20240229   gcc  
i386                  randconfig-013-20240229   clang
i386                  randconfig-014-20240229   clang
i386                  randconfig-015-20240229   clang
i386                  randconfig-016-20240229   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240229   gcc  
loongarch             randconfig-002-20240229   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                           sun3_defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                           jazz_defconfig   clang
mips                          rm200_defconfig   gcc  
mips                        vocore2_defconfig   clang
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240229   gcc  
nios2                 randconfig-002-20240229   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                randconfig-001-20240229   gcc  
parisc                randconfig-002-20240229   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc                     ep8248e_defconfig   gcc  
powerpc                     ksi8560_defconfig   gcc  
powerpc               randconfig-001-20240229   clang
powerpc               randconfig-002-20240229   gcc  
powerpc               randconfig-003-20240229   clang
powerpc                 xes_mpc85xx_defconfig   gcc  
powerpc64             randconfig-001-20240229   gcc  
powerpc64             randconfig-002-20240229   clang
powerpc64             randconfig-003-20240229   clang
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
riscv                 randconfig-001-20240229   clang
riscv                 randconfig-002-20240229   clang
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                                defconfig   clang
s390                  randconfig-001-20240229   clang
s390                  randconfig-002-20240229   gcc  
sh                               alldefconfig   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                    randconfig-001-20240229   gcc  
sh                    randconfig-002-20240229   gcc  
sh                          sdk7780_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240229   gcc  
sparc64               randconfig-002-20240229   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                             i386_defconfig   gcc  
um                    randconfig-001-20240229   gcc  
um                    randconfig-002-20240229   gcc  
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-001-20240229   gcc  
x86_64       buildonly-randconfig-002-20240229   clang
x86_64       buildonly-randconfig-003-20240229   gcc  
x86_64       buildonly-randconfig-004-20240229   gcc  
x86_64       buildonly-randconfig-005-20240229   gcc  
x86_64       buildonly-randconfig-006-20240229   gcc  
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20240229   clang
x86_64                randconfig-002-20240229   clang
x86_64                randconfig-003-20240229   clang
x86_64                randconfig-004-20240229   clang
x86_64                randconfig-005-20240229   clang
x86_64                randconfig-006-20240229   clang
x86_64                randconfig-011-20240229   gcc  
x86_64                randconfig-012-20240229   gcc  
x86_64                randconfig-013-20240229   gcc  
x86_64                randconfig-014-20240229   gcc  
x86_64                randconfig-015-20240229   gcc  
x86_64                randconfig-016-20240229   gcc  
x86_64                randconfig-071-20240229   clang
x86_64                randconfig-072-20240229   clang
x86_64                randconfig-073-20240229   clang
x86_64                randconfig-074-20240229   clang
x86_64                randconfig-075-20240229   gcc  
x86_64                randconfig-076-20240229   clang
x86_64                          rhel-8.3-rust   clang
xtensa                            allnoconfig   gcc  
xtensa                randconfig-001-20240229   gcc  
xtensa                randconfig-002-20240229   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

