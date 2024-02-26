Return-Path: <io-uring+bounces-768-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9889A8681A1
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 21:00:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 062BA1F270AF
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26D38130E24;
	Mon, 26 Feb 2024 20:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GE+EblzH"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D473B130E46;
	Mon, 26 Feb 2024 20:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708977638; cv=none; b=n41ydShpyt/aNPHpTg9ZnMcRvSSogRlWmQV0jh0Drqrkyfmtk8a06B46IYztrCZVd4IzfRT7ujCFz6CEXuQ+Hvy0TuGpAuV4JFoIeTrmZd0HNXm9m18ghLJVEjWMRjxNx80UKBhSmtzxz+nFmD1JupWGvhe/S1IpW0NsTWVW6pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708977638; c=relaxed/simple;
	bh=/EH3F5q1f9nRNybuQ4fC//Sp0wZ24X0rMldM/Njia4A=;
	h=Date:From:To:Cc:Subject:Message-ID; b=jginVa3GuV29u8oDxBLpc59ULUx6VzeRZlQ+f93wc3kljEXn6Si6nm0HVVIzEDElGz9XXv0M/6PtKt30B65RuOxPph/YWbkpOW3u6bHANeUqWAXeIH4NjYRD27JkR8XlcEUHAN+ZxfJj8QcbpeSBAqoTpkZyNx8W5q0RV+dRXY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GE+EblzH; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708977634; x=1740513634;
  h=date:from:to:cc:subject:message-id;
  bh=/EH3F5q1f9nRNybuQ4fC//Sp0wZ24X0rMldM/Njia4A=;
  b=GE+EblzHo5ZIAo1o5OB6ml37shAy6UdqH3jz5Mpu3S+If7ByUdzMtJor
   KI+GP2SUYQSeNnovXgb10z3bGQmCVReDr4WP1Ikv3SaMF2xe6fdCT+u5e
   X0Fx1kjarrCOtMFWRL0PDLbwDOjT65vuEfnH4TcROoPeb/OdhuhsX7hYI
   jz1wOzea9zxm+YouAyMk6DP1cmO3GqWo4rXnUg7wYAxiGZfDSGqOuIsUE
   U+RcoKh0qVGwj58U6HO+UDNTQ7ayl3D5rkR1V5qYb9+7sY4/y2ALq1127
   iad+xehPz8QUWdgraUw4BynUmp8EmpMKgR+7iYjYwFin5MdJMGJFA7QeP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3136222"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="3136222"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 12:00:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="11408942"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 26 Feb 2024 12:00:23 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1reh8s-000AcZ-26;
	Mon, 26 Feb 2024 20:00:20 +0000
Date: Tue, 27 Feb 2024 03:58:10 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 io-uring@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-leds@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-pm@vger.kernel.org, linux-sound@vger.kernel.org,
 linux-usb@vger.kernel.org, mhi@lists.linux.dev,
 nouveau@lists.freedesktop.org, ntfs3@lists.linux.dev
Subject: [linux-next:master] BUILD REGRESSION
 8552c902efe7ef670b6961fb8885b67961aeb629
Message-ID: <202402270303.PmvmQrJV-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 8552c902efe7ef670b6961fb8885b67961aeb629  Add linux-next specific files for 20240226

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202402261912.yAxZePRG-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/gpu/drm/xe/xe_ggtt.c:78:9: error: implicit declaration of function 'writeq'; did you mean 'writeb'? [-Werror=implicit-function-declaration]
fs/ubifs/journal.c:369: warning: expecting prototype for wake_up_reservation(). Prototype was for add_or_start_queue() instead
make[2]: *** kselftest/livepatch/test_modules: No such file or directory.  Stop.

Unverified Error/Warning (likely false positive, please contact us if interested):

{standard input}:1344: Warning: overflow in branch to .L91; converted into longer instruction sequence

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- arc-allmodconfig
|   `-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|-- arm-multi_v7_defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- arm-tegra_defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- arm64-randconfig-001-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- arm64-randconfig-002-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- arm64-randconfig-003-20240226
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- csky-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- csky-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- csky-randconfig-002-20240226
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- csky-randconfig-r052-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- i386-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- i386-randconfig-052-20240226
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- i386-randconfig-053-20240226
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- i386-randconfig-054-20240226
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- i386-randconfig-061-20240226
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- i386-randconfig-141-20240226
|   |-- drivers-usb-typec-tcpm-tcpm.c-tcpm_pd_svdm()-error:uninitialized-symbol-modep_prime-.
|   |-- drivers-usb-typec-ucsi-ucsi_acpi.c-ucsi_dell_sync_write()-warn:missing-error-code-ret
|   `-- mm-page_owner.c-stack_print()-warn:unsigned-nr_entries-is-never-less-than-zero.
|-- loongarch-defconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- loongarch-randconfig-001-20240226
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- m68k-randconfig-r051-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- m68k-randconfig-r061-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- m68k-randconfig-r111-20240226
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|   |-- sound-core-sound_kunit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-snd_pcm_format_t-usertype-format-got-int
|   `-- sound-core-sound_kunit.c:sparse:sparse:restricted-snd_pcm_format_t-degrades-to-integer
|-- m68k-randconfig-r121-20240226
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|   |-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|   |-- sound-core-sound_kunit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-snd_pcm_format_t-usertype-format-got-int
|   `-- sound-core-sound_kunit.c:sparse:sparse:restricted-snd_pcm_format_t-degrades-to-integer
|-- microblaze-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- microblaze-randconfig-r064-20240226
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- nios2-allmodconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- nios2-allyesconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- nios2-randconfig-001-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- nios2-randconfig-r112-20240226
|   |-- drivers-leds-flash-leds-ktd2692.c:sparse:sparse:symbol-ktd2692_timing-was-not-declared.-Should-it-be-static
|   |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|   |-- sound-core-sound_kunit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-snd_pcm_format_t-usertype-format-got-int
|   `-- sound-core-sound_kunit.c:sparse:sparse:restricted-snd_pcm_format_t-degrades-to-integer
|-- parisc-defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- parisc64-defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- powerpc-randconfig-002-20240226
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- powerpc64-randconfig-r123-20240226
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|   |-- kernel-power-energy_model.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-em_perf_state-table-got-struct-em_perf_state-noderef-__rcu
|   |-- kernel-power-energy_model.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-kref-kref-got-struct-kref-noderef-__rcu
|   |-- kernel-power-energy_model.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-objp-got-struct-em_perf_table-noderef-__rcu-assigned-em_table
|   `-- kernel-power-energy_model.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-em_perf_state-new_ps-got-struct-em_perf_state-noderef-__rcu
|-- riscv-randconfig-r053-20240226
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- sh-allmodconfig
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- sh-randconfig-001-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- sh-randconfig-r025-20230513
|   `-- standard-input:Warning:overflow-in-branch-to-.L91-converted-into-longer-instruction-sequence
|-- sh-randconfig-r113-20240226
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- sparc-randconfig-002-20240226
|   |-- (.head.text):relocation-truncated-to-fit:R_SPARC_WDISP22-against-init.text
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- sparc64-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- sparc64-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- sparc64-randconfig-002-20240226
|   |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- um-randconfig-002-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-buildonly-randconfig-006-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-randconfig-072-20240226
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-randconfig-121-20240226
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   `-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|-- x86_64-randconfig-122-20240226
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   |-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|   |-- sound-core-sound_kunit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-snd_pcm_format_t-usertype-format-got-int
|   `-- sound-core-sound_kunit.c:sparse:sparse:restricted-snd_pcm_format_t-degrades-to-integer
|-- x86_64-randconfig-123-20240226
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- x86_64-randconfig-r132-20240226
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- x86_64-randconfig-r133-20240226
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   `-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|-- x86_64-rhel-8.3-bpf
|   `-- make:kselftest-livepatch-test_modules:No-such-file-or-directory.-Stop.
|-- xtensa-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-gpu-drm-xe-xe_ggtt.c:error:implicit-declaration-of-function-writeq
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
`-- xtensa-randconfig-002-20240226
    `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
clang_recent_errors
|-- arm64-randconfig-r054-20240226
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- hexagon-randconfig-002-20240226
|   |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- i386-buildonly-randconfig-001-20240226
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- i386-buildonly-randconfig-003-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- i386-buildonly-randconfig-004-20240226
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- i386-buildonly-randconfig-005-20240226
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- i386-buildonly-randconfig-006-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- i386-randconfig-001-20240226
|   |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- i386-randconfig-051-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- i386-randconfig-062-20240226
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- i386-randconfig-063-20240226
|   `-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|-- powerpc-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- powerpc-randconfig-003-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- powerpc64-randconfig-001-20240226
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- powerpc64-randconfig-003-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- riscv-allmodconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- riscv-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- riscv-defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- s390-randconfig-001-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- s390-randconfig-r122-20240226
|   |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|   |-- sound-core-sound_kunit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-snd_pcm_format_t-usertype-format-got-int
|   `-- sound-core-sound_kunit.c:sparse:sparse:restricted-snd_pcm_format_t-degrades-to-integer
|-- x86_64-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- x86_64-allyesconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ubifs-journal.c:warning:expecting-prototype-for-wake_up_reservation().-Prototype-was-for-add_or_start_queue()-instead
|-- x86_64-randconfig-013-20240226
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- x86_64-randconfig-102-20240226
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
`-- x86_64-randconfig-161-20240226
    |-- mm-page_owner.c-stack_print()-warn:unsigned-nr_entries-is-never-less-than-zero.
    `-- mm-userfaultfd.c-uffd_move_lock()-error:we-previously-assumed-src_vmap-could-be-null-(see-line-)

elapsed time: 737m

configs tested: 179
configs skipped: 4

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                          axs103_defconfig   gcc  
arc                                 defconfig   gcc  
arc                        nsim_700_defconfig   gcc  
arc                   randconfig-001-20240226   gcc  
arc                   randconfig-002-20240226   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                          collie_defconfig   gcc  
arm                                 defconfig   clang
arm                      footbridge_defconfig   clang
arm                        multi_v7_defconfig   gcc  
arm                   randconfig-001-20240226   clang
arm                   randconfig-002-20240226   clang
arm                   randconfig-003-20240226   clang
arm                   randconfig-004-20240226   gcc  
arm                           sunxi_defconfig   gcc  
arm                           tegra_defconfig   gcc  
arm                         wpcm450_defconfig   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-001-20240226   gcc  
arm64                 randconfig-002-20240226   gcc  
arm64                 randconfig-003-20240226   gcc  
arm64                 randconfig-004-20240226   clang
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240226   gcc  
csky                  randconfig-002-20240226   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
hexagon               randconfig-001-20240226   clang
hexagon               randconfig-002-20240226   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240226   clang
i386         buildonly-randconfig-002-20240226   gcc  
i386         buildonly-randconfig-003-20240226   clang
i386         buildonly-randconfig-004-20240226   clang
i386         buildonly-randconfig-005-20240226   clang
i386         buildonly-randconfig-006-20240226   clang
i386                                defconfig   clang
i386                  randconfig-001-20240226   clang
i386                  randconfig-002-20240226   gcc  
i386                  randconfig-003-20240226   clang
i386                  randconfig-004-20240226   gcc  
i386                  randconfig-005-20240226   clang
i386                  randconfig-006-20240226   clang
i386                  randconfig-011-20240226   gcc  
i386                  randconfig-012-20240226   gcc  
i386                  randconfig-013-20240226   gcc  
i386                  randconfig-014-20240226   gcc  
i386                  randconfig-015-20240226   gcc  
i386                  randconfig-016-20240226   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240226   gcc  
loongarch             randconfig-002-20240226   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                        bcm47xx_defconfig   clang
mips                      fuloong2e_defconfig   gcc  
mips                      maltaaprp_defconfig   clang
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240226   gcc  
nios2                 randconfig-002-20240226   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                randconfig-001-20240226   gcc  
parisc                randconfig-002-20240226   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc                  iss476-smp_defconfig   gcc  
powerpc               randconfig-001-20240226   clang
powerpc               randconfig-002-20240226   gcc  
powerpc               randconfig-003-20240226   clang
powerpc                     tqm5200_defconfig   gcc  
powerpc64             randconfig-001-20240226   clang
powerpc64             randconfig-002-20240226   gcc  
powerpc64             randconfig-003-20240226   clang
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
riscv                 randconfig-001-20240226   clang
riscv                 randconfig-002-20240226   clang
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                                defconfig   clang
s390                  randconfig-001-20240226   clang
s390                  randconfig-002-20240226   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                          polaris_defconfig   gcc  
sh                    randconfig-001-20240226   gcc  
sh                    randconfig-002-20240226   gcc  
sh                           se7206_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240226   gcc  
sparc64               randconfig-002-20240226   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                             i386_defconfig   gcc  
um                    randconfig-001-20240226   clang
um                    randconfig-002-20240226   gcc  
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-001-20240226   clang
x86_64       buildonly-randconfig-002-20240226   gcc  
x86_64       buildonly-randconfig-003-20240226   gcc  
x86_64       buildonly-randconfig-004-20240226   clang
x86_64       buildonly-randconfig-005-20240226   gcc  
x86_64       buildonly-randconfig-006-20240226   gcc  
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20240226   gcc  
x86_64                randconfig-002-20240226   gcc  
x86_64                randconfig-003-20240226   clang
x86_64                randconfig-004-20240226   clang
x86_64                randconfig-005-20240226   clang
x86_64                randconfig-006-20240226   gcc  
x86_64                randconfig-011-20240226   clang
x86_64                randconfig-012-20240226   clang
x86_64                randconfig-013-20240226   clang
x86_64                randconfig-014-20240226   clang
x86_64                randconfig-015-20240226   clang
x86_64                randconfig-016-20240226   clang
x86_64                randconfig-071-20240226   clang
x86_64                randconfig-072-20240226   gcc  
x86_64                randconfig-073-20240226   gcc  
x86_64                randconfig-074-20240226   clang
x86_64                randconfig-075-20240226   gcc  
x86_64                randconfig-076-20240226   clang
x86_64                          rhel-8.3-rust   clang
xtensa                            allnoconfig   gcc  
xtensa                  cadence_csp_defconfig   gcc  
xtensa                randconfig-001-20240226   gcc  
xtensa                randconfig-002-20240226   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

