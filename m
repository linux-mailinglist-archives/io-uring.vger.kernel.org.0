Return-Path: <io-uring+bounces-671-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D52D185E579
	for <lists+io-uring@lfdr.de>; Wed, 21 Feb 2024 19:22:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BEA21F254C0
	for <lists+io-uring@lfdr.de>; Wed, 21 Feb 2024 18:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100C58529C;
	Wed, 21 Feb 2024 18:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JjEkuW2p"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63D28529D;
	Wed, 21 Feb 2024 18:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708539725; cv=none; b=CBZTpIkPDuxzRt5W4GE2dIc1Phvsh/6qgOY3AhGgZ5pwLpHEWG9tx9lQ/e2JKf/u2MZo02vmPrm9x54nBxcnAoC9P/S+Md+JdKIf54F3HUvy4lQ7hCBf0iCBi05VSim2iEK4QttNh1VYUGmYzbDtdiCGz4zWX1ZJaDtDnicQjr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708539725; c=relaxed/simple;
	bh=NA5R5KV7j+MZl2nUEDEy7uEm1nrb4CGZZiINeB7Kukc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=soIF/rm/mbTyEsRNIDKNcc8JQBa12jqh9TXCcnLm8lAdIwUhxKVP105bMt9biUMDMSISO4CgXmFTHGTTKe9xT7FKDqtbKlr6CF6F5ejwvz/Z1adlMTfTNr7BbyNPiHAYEhxnsxl7c0/6FNW38+WwJykIymT9C8ezNJizVlmtKQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JjEkuW2p; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708539721; x=1740075721;
  h=date:from:to:cc:subject:message-id;
  bh=NA5R5KV7j+MZl2nUEDEy7uEm1nrb4CGZZiINeB7Kukc=;
  b=JjEkuW2pNWiGs+W2gam+1bkLqlVJWuaQ05nGdppesrqKmWeSz5cE8Qt6
   A4DoDJJ1GSFjmp+WIJazMsW2DlrkcIO5mnIMqiSKexZRqIn6478L+V245
   Sw0lKwQG7AVCBgBEB7MeoyeO+VGHjyREOVb3Ri7/TcCo4hVMaoY4C1TQR
   oiC03kXR5V188k334ifUnr7j59TSrPhxn/5pamA4noIqbHLsFsB2N9B1V
   T1JhEY9JeurnuoVjJrQ7q+M2eC91qDEb7HvkThwb2CfxeM3wwPQOPAdQG
   ohEE9X3HGienQHzvauaYIC34QuAAeU8aHkup8GhDBdLhqUrVIDD/Brfyo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="6494936"
X-IronPort-AV: E=Sophos;i="6.06,176,1705392000"; 
   d="scan'208";a="6494936"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 10:22:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,176,1705392000"; 
   d="scan'208";a="5178286"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 21 Feb 2024 10:21:53 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rcrDm-0005aG-16;
	Wed, 21 Feb 2024 18:21:34 +0000
Date: Thu, 22 Feb 2024 02:21:15 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org,
 kunit-dev@googlegroups.com, linux-arm-msm@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-leds@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-um@lists.infradead.org,
 mhi@lists.linux.dev, nouveau@lists.freedesktop.org,
 ntfs3@lists.linux.dev
Subject: [linux-next:master] BUILD REGRESSION
 4893c639cc3659cefaa675bf1e59f4e7571afb5c
Message-ID: <202402220210.eeg0x0hA-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 4893c639cc3659cefaa675bf1e59f4e7571afb5c  Add linux-next specific files for 20240221

Error/Warning: (recently discovered and may have been fixed)

ld.lld: error: undefined symbol: ipt_alloc_initial_table
ld.lld: error: undefined symbol: ipt_do_table
ld.lld: error: undefined symbol: ipt_register_table
ld.lld: error: undefined symbol: ipt_unregister_table_exit

Unverified Error/Warning (likely false positive, please contact us if interested):

fs/pidfs.c:98 pidfd_show_fdinfo() error: 'pid' dereferencing possible ERR_PTR()
mm/userfaultfd.c:740 mfill_atomic() warn: inconsistent returns '&ctx->map_changing_lock'.

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- alpha-randconfig-r121-20240221
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- arc-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- arc-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- arm-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- arm-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- arm64-defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- arm64-randconfig-002-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- arm64-randconfig-003-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- csky-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- csky-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- csky-randconfig-002-20240221
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- i386-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- i386-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- i386-buildonly-randconfig-001-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- i386-randconfig-001-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- i386-randconfig-011-20240221
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- i386-randconfig-013-20240221
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- i386-randconfig-051-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- i386-randconfig-062-20240221
|   |-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|   |-- sound-core-sound_kunit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-snd_pcm_format_t-usertype-format-got-int
|   `-- sound-core-sound_kunit.c:sparse:sparse:restricted-snd_pcm_format_t-degrades-to-integer
|-- i386-randconfig-141-20240221
|   |-- drivers-bluetooth-btintel.c-btintel_read_version()-warn:passing-zero-to-PTR_ERR
|   `-- mm-page_owner.c-stack_print()-warn:unsigned-nr_entries-is-never-less-than-zero.
|-- loongarch-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- loongarch-randconfig-r064-20240221
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- loongarch-randconfig-r111-20240221
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- drivers-leds-flash-leds-ktd2692.c:sparse:sparse:symbol-ktd2692_timing-was-not-declared.-Should-it-be-static
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   |-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|   |-- sound-core-sound_kunit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-snd_pcm_format_t-usertype-format-got-int
|   `-- sound-core-sound_kunit.c:sparse:sparse:restricted-snd_pcm_format_t-degrades-to-integer
|-- loongarch-randconfig-r133-20240221
|   |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- microblaze-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- microblaze-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- microblaze-randconfig-r063-20240221
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- mips-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- nios2-randconfig-001-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- nios2-randconfig-002-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- openrisc-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- parisc-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- parisc-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- parisc-defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- parisc-generic-32bit_defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- parisc64-defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- powerpc-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- powerpc-randconfig-001-20240221
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- powerpc-randconfig-002-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- powerpc-randconfig-003-20240221
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- powerpc64-randconfig-001-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- powerpc64-randconfig-002-20240221
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- riscv-randconfig-r053-20240221
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- s390-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- sh-randconfig-001-20240221
|   |-- misc.c:(.text):undefined-reference-to-__ubsan_handle_out_of_bounds
|   `-- sh4-linux-ld:misc.c:(.text):undefined-reference-to-__ubsan_handle_out_of_bounds
|-- sh-randconfig-r112-20240221
|   |-- drivers-leds-flash-leds-ktd2692.c:sparse:sparse:symbol-ktd2692_timing-was-not-declared.-Should-it-be-static
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- sparc-allmodconfig
|   |-- Error:vdso-image-contains-dynamic-relocations
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- sparc64-linux-ld:vclock_gettime.c:(.text):undefined-reference-to-__ubsan_handle_shift_out_of_bounds
|   |-- sparc64-linux-objcopy:arch-sparc-vdso-vdso64.so.dbg:No-such-file
|   `-- vclock_gettime.c:(.text):undefined-reference-to-__ubsan_handle_shift_out_of_bounds
|-- sparc-randconfig-001-20240221
|   |-- Error:vdso-image-contains-dynamic-relocations
|   |-- sparc64-linux-ld:vclock_gettime.c:(.text):undefined-reference-to-__ubsan_handle_shift_out_of_bounds
|   |-- sparc64-linux-objcopy:arch-sparc-vdso-vdso64.so.dbg:No-such-file
|   `-- vclock_gettime.c:(.text):undefined-reference-to-__ubsan_handle_shift_out_of_bounds
|-- sparc-randconfig-002-20240221
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- sparc64-allmodconfig
|   |-- Error:vdso-image-contains-dynamic-relocations
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- sparc64-linux-ld:vclock_gettime.c:(.text):undefined-reference-to-__ubsan_handle_shift_out_of_bounds
|   |-- sparc64-linux-objcopy:arch-sparc-vdso-vdso64.so.dbg:No-such-file
|   `-- vclock_gettime.c:(.text):undefined-reference-to-__ubsan_handle_shift_out_of_bounds
|-- sparc64-allyesconfig
|   |-- Error:vdso-image-contains-dynamic-relocations
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- sparc64-linux-ld:vclock_gettime.c:(.text):undefined-reference-to-__ubsan_handle_shift_out_of_bounds
|   |-- sparc64-linux-objcopy:arch-sparc-vdso-vdso64.so.dbg:No-such-file
|   `-- vclock_gettime.c:(.text):undefined-reference-to-__ubsan_handle_shift_out_of_bounds
|-- sparc64-randconfig-001-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- um-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- um-randconfig-001-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- um-randconfig-r122-20240221
|   |-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|   |-- sound-core-sound_kunit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-snd_pcm_format_t-usertype-format-got-int
|   `-- sound-core-sound_kunit.c:sparse:sparse:restricted-snd_pcm_format_t-degrades-to-integer
|-- um-randconfig-r132-20240221
|   |-- arch-x86-um-vdso-vdso.so.dbg:undefined-symbols-found
|   |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- x86_64-buildonly-randconfig-002-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-buildonly-randconfig-003-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-randconfig-002-20240221
|   `-- include-kunit-test.h:warning:s-directive-argument-is-null
|-- x86_64-randconfig-003-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-randconfig-005-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-randconfig-014-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-randconfig-015-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-randconfig-016-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-randconfig-071-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-randconfig-072-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-randconfig-073-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-randconfig-103-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-randconfig-121-20240221
|   |-- drivers-leds-flash-leds-ktd2692.c:sparse:sparse:symbol-ktd2692_timing-was-not-declared.-Should-it-be-static
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- x86_64-randconfig-123-20240221
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   `-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
`-- x86_64-randconfig-161-20240221
    |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
    |-- fs-pidfs.c-pidfd_show_fdinfo()-error:pid-dereferencing-possible-ERR_PTR()
    `-- mm-page_owner.c-stack_print()-warn:unsigned-nr_entries-is-never-less-than-zero.
clang_recent_errors
|-- arm-defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- arm-randconfig-002-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- arm-randconfig-004-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- arm64-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- arm64-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- arm64-randconfig-r081-20240216
|   `-- mm-userfaultfd.c-mfill_atomic()-warn:inconsistent-returns-ctx-map_changing_lock-.
|-- hexagon-randconfig-r033-20220422
|   |-- ld.lld:error:undefined-symbol:ipt_alloc_initial_table
|   |-- ld.lld:error:undefined-symbol:ipt_do_table
|   |-- ld.lld:error:undefined-symbol:ipt_register_table
|   `-- ld.lld:error:undefined-symbol:ipt_unregister_table_exit
|-- i386-randconfig-006-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- i386-randconfig-016-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- i386-randconfig-053-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- i386-randconfig-054-20240221
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- i386-randconfig-061-20240221
|   |-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
|   |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|   |-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   |-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|   |-- sound-core-sound_kunit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-snd_pcm_format_t-usertype-format-got-int
|   `-- sound-core-sound_kunit.c:sparse:sparse:restricted-snd_pcm_format_t-degrades-to-integer
|-- i386-randconfig-063-20240221
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   `-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|-- i386-randconfig-r113-20240221
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le32
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:cast-to-restricted-__le64
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- include-trace-..-..-drivers-bus-mhi-host-trace.h:sparse:sparse:restricted-__le64-degrades-to-integer
|   |-- io_uring-io_uring.c:sparse:sparse:cast-to-restricted-io_req_flags_t
|   |-- sound-core-sound_kunit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-snd_pcm_format_t-usertype-format-got-int
|   `-- sound-core-sound_kunit.c:sparse:sparse:restricted-snd_pcm_format_t-degrades-to-integer
|-- powerpc-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- riscv-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- riscv-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- riscv-defconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- s390-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- s390-randconfig-r052-20240221
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-allmodconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- x86_64-allyesconfig
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- x86_64-buildonly-randconfig-001-20240221
|   |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|   `-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
|-- x86_64-buildonly-randconfig-006-20240221
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
|-- x86_64-randconfig-011-20240221
|   |-- arch-x86-entry-entry_fred.c:error:use-of-undeclared-identifier-POSTED_INTR_NESTED_VECTOR
|   |-- arch-x86-entry-entry_fred.c:error:use-of-undeclared-identifier-POSTED_INTR_VECTOR
|   `-- arch-x86-entry-entry_fred.c:error:use-of-undeclared-identifier-POSTED_INTR_WAKEUP_VECTOR
|-- x86_64-randconfig-075-20240221
|   |-- arch-x86-entry-entry_fred.c:error:use-of-undeclared-identifier-POSTED_INTR_NESTED_VECTOR
|   |-- arch-x86-entry-entry_fred.c:error:use-of-undeclared-identifier-POSTED_INTR_VECTOR
|   `-- arch-x86-entry-entry_fred.c:error:use-of-undeclared-identifier-POSTED_INTR_WAKEUP_VECTOR
|-- x86_64-randconfig-122-20240221
|   `-- drivers-video-backlight-ktd2801-backlight.c:sparse:sparse:symbol-ktd2801_timing-was-not-declared.-Should-it-be-static
`-- x86_64-randconfig-r123-20240221
    |-- drivers-gpu-drm-nouveau-nvkm-subdev-gsp-r535.c:warning:Function-parameter-or-struct-member-gsp-not-described-in-nvkm_gsp_radix3_sg
    |-- drivers-leds-flash-leds-ktd2692.c:sparse:sparse:symbol-ktd2692_timing-was-not-declared.-Should-it-be-static
    |-- fs-ntfs3-frecord.c:warning:unused-variable-i_size
    `-- fs-ntfs3-fslog.c:sparse:sparse:restricted-__le32-degrades-to-integer

elapsed time: 731m

configs tested: 180
configs skipped: 3

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                            hsdk_defconfig   gcc  
arc                   randconfig-001-20240221   gcc  
arc                   randconfig-002-20240221   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                          collie_defconfig   gcc  
arm                                 defconfig   clang
arm                          gemini_defconfig   clang
arm                      jornada720_defconfig   clang
arm                   randconfig-001-20240221   clang
arm                   randconfig-002-20240221   clang
arm                   randconfig-003-20240221   gcc  
arm                   randconfig-004-20240221   clang
arm                       spear13xx_defconfig   gcc  
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-001-20240221   gcc  
arm64                 randconfig-002-20240221   gcc  
arm64                 randconfig-003-20240221   gcc  
arm64                 randconfig-004-20240221   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240221   gcc  
csky                  randconfig-002-20240221   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
hexagon               randconfig-001-20240221   clang
hexagon               randconfig-002-20240221   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240221   gcc  
i386         buildonly-randconfig-002-20240221   clang
i386         buildonly-randconfig-003-20240221   gcc  
i386         buildonly-randconfig-004-20240221   gcc  
i386         buildonly-randconfig-005-20240221   gcc  
i386         buildonly-randconfig-006-20240221   gcc  
i386                                defconfig   clang
i386                  randconfig-001-20240221   gcc  
i386                  randconfig-002-20240221   clang
i386                  randconfig-003-20240221   clang
i386                  randconfig-004-20240221   gcc  
i386                  randconfig-005-20240221   gcc  
i386                  randconfig-006-20240221   clang
i386                  randconfig-011-20240221   gcc  
i386                  randconfig-012-20240221   clang
i386                  randconfig-013-20240221   gcc  
i386                  randconfig-014-20240221   clang
i386                  randconfig-015-20240221   gcc  
i386                  randconfig-016-20240221   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240221   gcc  
loongarch             randconfig-002-20240221   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                        mvme147_defconfig   gcc  
m68k                        mvme16x_defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
mips                           ip32_defconfig   clang
mips                      loongson3_defconfig   gcc  
mips                          malta_defconfig   gcc  
mips                      maltaaprp_defconfig   clang
mips                         rt305x_defconfig   clang
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240221   gcc  
nios2                 randconfig-002-20240221   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                generic-32bit_defconfig   gcc  
parisc                randconfig-001-20240221   gcc  
parisc                randconfig-002-20240221   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc               randconfig-001-20240221   gcc  
powerpc               randconfig-002-20240221   gcc  
powerpc               randconfig-003-20240221   gcc  
powerpc                     tqm8548_defconfig   clang
powerpc64             randconfig-001-20240221   gcc  
powerpc64             randconfig-002-20240221   gcc  
powerpc64             randconfig-003-20240221   gcc  
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
riscv                 randconfig-001-20240221   clang
riscv                 randconfig-002-20240221   gcc  
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                                defconfig   clang
s390                  randconfig-001-20240221   clang
s390                  randconfig-002-20240221   clang
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                          landisk_defconfig   gcc  
sh                    randconfig-001-20240221   gcc  
sh                    randconfig-002-20240221   gcc  
sh                   secureedge5410_defconfig   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240221   gcc  
sparc64               randconfig-002-20240221   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                             i386_defconfig   gcc  
um                    randconfig-001-20240221   gcc  
um                    randconfig-002-20240221   clang
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-001-20240221   clang
x86_64       buildonly-randconfig-002-20240221   gcc  
x86_64       buildonly-randconfig-003-20240221   gcc  
x86_64       buildonly-randconfig-004-20240221   clang
x86_64       buildonly-randconfig-005-20240221   clang
x86_64       buildonly-randconfig-006-20240221   clang
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20240221   gcc  
x86_64                randconfig-002-20240221   gcc  
x86_64                randconfig-003-20240221   gcc  
x86_64                randconfig-004-20240221   gcc  
x86_64                randconfig-005-20240221   gcc  
x86_64                randconfig-006-20240221   gcc  
x86_64                randconfig-011-20240221   clang
x86_64                randconfig-012-20240221   gcc  
x86_64                randconfig-013-20240221   clang
x86_64                randconfig-014-20240221   gcc  
x86_64                randconfig-015-20240221   gcc  
x86_64                randconfig-016-20240221   gcc  
x86_64                randconfig-071-20240221   gcc  
x86_64                randconfig-072-20240221   gcc  
x86_64                randconfig-073-20240221   gcc  
x86_64                randconfig-074-20240221   gcc  
x86_64                randconfig-075-20240221   clang
x86_64                randconfig-076-20240221   gcc  
x86_64                          rhel-8.3-rust   clang
xtensa                            allnoconfig   gcc  
xtensa                  nommu_kc705_defconfig   gcc  
xtensa                randconfig-001-20240221   gcc  
xtensa                randconfig-002-20240221   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

