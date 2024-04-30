Return-Path: <io-uring+bounces-1695-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 66BD18B8144
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 22:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3FFE7B248B5
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 20:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0BCF199E9A;
	Tue, 30 Apr 2024 20:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n8wGtb7F"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29164199E96;
	Tue, 30 Apr 2024 20:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714508104; cv=none; b=YsJOUvt6vV+MyuCUFV2Vx9pJAmz6Z9+ssUezQJKtMDQpKGrDTndWYp0XJguuvrltBGGaiWzpAImvaIBB2XDFDDnz6/s/2+X5/GBGF2R+cN7548vGJPSpGwrQIgpaFBeYrtfJMhIe4XCbWau4zDCXlk0L32xLJDGADZIz4/uiksQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714508104; c=relaxed/simple;
	bh=ZafLxfI+Z/GIhZZqRQsDUhDD3XnYQA1a9EWeGEFS0wg=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ejd39rr+wI6bCS3kwdpI0PA5piPPQM3YJEaM0lCx6Xake3RPrU6/nAB06ukFR/FNjGAMHfMScBbPAsuzN37zt/efMEBFa9AxjfXQ1XOSIlF5Fft9AYwBvZrVTLc+WUEV75+VwJFcngxwcS5bS1wBJfrZ+w+i8v6EtrjhrAUDifA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n8wGtb7F; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714508100; x=1746044100;
  h=date:from:to:cc:subject:message-id;
  bh=ZafLxfI+Z/GIhZZqRQsDUhDD3XnYQA1a9EWeGEFS0wg=;
  b=n8wGtb7Fo6NLJ1b8FFns9upmw71hIgtYb3esOPNVBZlGQvrGA9Z+YETE
   vqxrneEWu2oB0zdSEPihEaVcxGG9bWm9Pgl0du6roYUssZoBINV9tcbdf
   uIehgN04nGSqEK5u1SKdTcbNpYvtg1I8OCCGmnY7lZZsCY7nLdzoVw+VP
   +dP8EeU92t9DhZvpGlXbj13hkpRHfgxoxvRQdqacw2FDGPrnrYnDY2erQ
   B/MHodrKZGXprwNqtGhYBOPDjTbTsubuMXhtK9j+h1BZNJYdYEvwuFjOA
   Sa3+yP4Or8vhlAQYAeDYDQoKTyGEm2QyKCwRmwyaCUyBsRn5iKk/Zdqyr
   A==;
X-CSE-ConnectionGUID: kzYi2If/Rwm6J14ZySXZ1w==
X-CSE-MsgGUID: Efob9qktQyynrXybpz065g==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10358855"
X-IronPort-AV: E=Sophos;i="6.07,243,1708416000"; 
   d="scan'208";a="10358855"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 13:14:54 -0700
X-CSE-ConnectionGUID: qp6YMwp+TsSexkVVR2GzOA==
X-CSE-MsgGUID: KrZvMl4uSsiQsmyNvi+utQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,243,1708416000"; 
   d="scan'208";a="31288691"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 30 Apr 2024 13:14:47 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s1tsC-0008VX-1f;
	Tue, 30 Apr 2024 20:14:44 +0000
Date: Wed, 01 May 2024 04:14:21 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 acrn-dev@lists.projectacrn.org, amd-gfx@lists.freedesktop.org,
 cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 io-uring@vger.kernel.org, iommu@lists.linux.dev,
 linux-arch@vger.kernel.org, linux-bcachefs@vger.kernel.org,
 linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-nvme@lists.infradead.org
Subject: [linux-next:master] BUILD REGRESSION
 d04466706db5e241ee026f17b5f920e50dee26b5
Message-ID: <202405010414.1nlkOC6t-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: d04466706db5e241ee026f17b5f920e50dee26b5  Add linux-next specific files for 20240430

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202404301738.J71xGyaR-lkp@intel.com

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/virt/acrn/mm.c:217 acrn_vm_ram_map() error: uninitialized symbol 'start_pfn'.
drivers/virt/acrn/mm.c:224 acrn_vm_ram_map() error: uninitialized symbol 'ret'.
net/ipv6/route.c:5712 rt6_fill_node() error: we previously assumed 'dst' could be null (see line 5697)

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- arc-allmodconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- arc-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- arc-randconfig-r121-20240430
|   |-- drivers-hwmon-pmbus-xdp710.c:sparse:sparse:symbol-micro_ohm_rsense-was-not-declared.-Should-it-be-static
|   |-- fs-bcachefs-btree_cache.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-task_struct-got-unsigned-long
|   `-- fs-ext4-orphan.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le32-_prev_-got-unsigned-long
|-- arc-randconfig-r122-20240430
|   |-- block-blk-mq.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-request
|   |-- block-blk-mq.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-request
|   |-- block-blk-mq.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-request-got-unsigned-long
|   |-- drivers-dma-buf-dma-fence-chain.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-dma_fence-noderef-__rcu
|   |-- drivers-dma-buf-dma-fence-chain.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-dma_fence-noderef-__rcu
|   |-- drivers-dma-buf-dma-fence-chain.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-dma_fence-noderef-__rcu-got-unsigned-long
|   |-- drivers-nvme-target-fabrics-cmd.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-nvmet_ctrl
|   |-- drivers-nvme-target-fabrics-cmd.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-nvmet_ctrl
|   |-- drivers-nvme-target-fabrics-cmd.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-nvmet_ctrl-got-unsigned-long
|   |-- fs-btrfs-raid56.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-btrfs_stripe_hash_table
|   |-- fs-btrfs-raid56.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-btrfs_stripe_hash_table
|   |-- fs-btrfs-raid56.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-btrfs_stripe_hash_table-got-unsigned-long
|   |-- fs-crypto-hooks.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-char
|   |-- fs-crypto-hooks.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-char
|   |-- fs-crypto-hooks.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-char-got-unsigned-long
|   |-- fs-crypto-keysetup.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-fscrypt_inode_info
|   |-- fs-crypto-keysetup.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-fscrypt_inode_info
|   |-- fs-crypto-keysetup.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-fscrypt_inode_info-got-unsigned-long
|   |-- fs-debugfs-file.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-void
|   |-- fs-debugfs-file.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-void
|   |-- fs-debugfs-file.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-void-got-unsigned-long
|   |-- fs-ext4-orphan.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-restricted-__le32-_n_
|   |-- fs-ext4-orphan.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-restricted-__le32-_o_
|   |-- fs-libfs.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-dentry
|   |-- fs-libfs.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-dentry
|   |-- fs-libfs.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-dentry-got-unsigned-long
|   |-- fs-locks.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-file_lock_context
|   |-- fs-locks.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-file_lock_context
|   |-- fs-locks.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-file_lock_context-got-unsigned-long
|   |-- fs-notify-mark.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-fsnotify_mark_connector-noderef-__rcu
|   |-- fs-notify-mark.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-fsnotify_mark_connector-noderef-__rcu
|   |-- fs-notify-mark.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-fsnotify_mark_connector-noderef-__rcu-got-unsigned-long
|   |-- fs-overlayfs-readdir.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-file
|   |-- fs-overlayfs-readdir.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-file
|   |-- fs-overlayfs-readdir.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-file-got-unsigned-long
|   |-- fs-posix_acl.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-posix_acl
|   |-- fs-posix_acl.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-posix_acl
|   |-- fs-posix_acl.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-posix_acl-got-unsigned-long
|   |-- fs-super.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-workqueue_struct
|   |-- fs-super.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-workqueue_struct
|   |-- fs-super.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-workqueue_struct-got-unsigned-long
|   |-- io_uring-io_uring.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-llist_node
|   |-- io_uring-io_uring.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-llist_node
|   |-- io_uring-io_uring.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-llist_node-got-unsigned-long
|   |-- kernel-locking-osq_lock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-optimistic_spin_node-got-unsigned-long
|   |-- kernel-sched-core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-wake_q_node
|   |-- kernel-sched-core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-wake_q_node
|   |-- kernel-sched-core.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-wake_q_node-got-unsigned-long
|   |-- kernel-task_work.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-callback_head
|   |-- kernel-task_work.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-callback_head
|   |-- kernel-task_work.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-callback_head-got-unsigned-long
|   |-- kernel-trace-ring_buffer.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-buffer_page
|   |-- kernel-trace-ring_buffer.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-list_head
|   |-- kernel-trace-ring_buffer.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-buffer_page
|   |-- kernel-trace-ring_buffer.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-list_head
|   |-- kernel-trace-ring_buffer.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-buffer_page-got-unsigned-long
|   |-- kernel-trace-ring_buffer.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-list_head-got-unsigned-long
|   |-- lib-generic-radix-tree.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-genradix_node
|   |-- lib-generic-radix-tree.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-genradix_root
|   |-- lib-generic-radix-tree.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-genradix_node
|   |-- lib-generic-radix-tree.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-genradix_root
|   |-- lib-generic-radix-tree.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-genradix_node-got-unsigned-long
|   |-- lib-generic-radix-tree.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-genradix_root-got-unsigned-long
|   |-- lib-llist.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-llist_node
|   |-- lib-llist.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-llist_node
|   |-- lib-llist.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-llist_node-got-unsigned-long
|   |-- lib-rhashtable.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-bucket_table
|   |-- lib-rhashtable.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-union-nested_table
|   |-- lib-rhashtable.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-bucket_table
|   |-- lib-rhashtable.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-union-nested_table
|   |-- lib-rhashtable.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-bucket_table-got-unsigned-long
|   |-- lib-rhashtable.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-union-nested_table-got-unsigned-long
|   |-- mm-huge_memory.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-folio
|   |-- mm-huge_memory.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-folio
|   |-- mm-huge_memory.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-folio-got-unsigned-long
|   |-- mm-memcontrol.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-mem_cgroup-got-unsigned-long
|   |-- mm-memcontrol.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-obj_cgroup-got-unsigned-long
|   |-- mm-oom_kill.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-new-got-struct-mm_struct
|   |-- mm-oom_kill.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-long-usertype-old-got-struct-mm_struct
|   `-- mm-oom_kill.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-struct-mm_struct-got-unsigned-long
|-- arm-allmodconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- arm-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- arm64-defconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- csky-allmodconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- csky-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- csky-randconfig-r053-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- i386-allmodconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- i386-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- i386-buildonly-randconfig-003-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- i386-randconfig-003-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- i386-randconfig-005-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- i386-randconfig-053-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- i386-randconfig-062-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- loongarch-allmodconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- m68k-allmodconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- m68k-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- m68k-randconfig-r133-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- microblaze-allmodconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- microblaze-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- mips-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- mips-ip27_defconfig
|   `-- arch-mips-sgi-ip27-ip27-irq.c:warning:unused-variable-i
|-- nios2-allmodconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- nios2-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- openrisc-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- parisc-allmodconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- parisc-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- parisc-randconfig-r063-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- powerpc-allmodconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- powerpc-randconfig-002-20240430
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-calcs-dcn_calc_auto.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-calcs-dcn_calc_math.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-calcs-dcn_calcs.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn20-dcn20_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn20-display_mode_vba_20.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn20-display_mode_vba_20v2.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn20-display_rq_dlg_calc_20.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn20-display_rq_dlg_calc_20v2.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn21-display_mode_vba_21.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn21-display_rq_dlg_calc_21.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn30-dcn30_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn30-display_mode_vba_30.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn30-display_rq_dlg_calc_30.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn301-dcn301_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn302-dcn302_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn303-dcn303_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn31-dcn31_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn31-display_mode_vba_31.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn31-display_rq_dlg_calc_31.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn314-dcn314_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn314-display_mode_vba_314.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn314-display_rq_dlg_calc_314.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn32-dcn32_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn32-display_mode_vba_32.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn32-display_mode_vba_util_32.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn32-display_rq_dlg_calc_32.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn321-dcn321_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn35-dcn35_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn351-dcn351_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dcn401-dcn401_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-display_mode_vba.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dml1_display_rq_dlg_calc.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml-dsc-rc_calc_fpu.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-display_mode_core.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-display_mode_util.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml21-dml21_translation_helper.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml21-dml21_utils.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml21-src-dml2_core-dml2_core_dcn4.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml21-src-dml2_core-dml2_core_dcn4_calcs.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml21-src-dml2_core-dml2_core_shared.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml21-src-dml2_dpmm-dml2_dpmm_dcn4.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml21-src-dml2_mcg-dml2_mcg_dcn4.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml21-src-dml2_pmo-dml2_pmo_dcn3.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml21-src-dml2_pmo-dml2_pmo_dcn4.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml21-src-dml2_pmo-dml2_pmo_dcn4_fams2.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml21-src-dml2_standalone_libraries-lib_float_math.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml21-src-dml2_top-dml_top_mcache.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml2_mall_phantom.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml2_policy.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml2_translation_helper.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml2_utils.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   |-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml2_wrapper.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|   `-- powerpc-linux-ld:drivers-gpu-drm-amd-display-dc-dml2-dml_display_rq_dlg_calc.o-uses-hard-float-arch-powerpc-kernel-udbg.o-uses-soft-float
|-- powerpc-randconfig-r061-20240430
|   `-- ERROR:drm_dsc_pps_payload_pack-drivers-gpu-drm-panel-panel-lg-sw43408.ko-undefined
|-- riscv-randconfig-001-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- s390-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- sparc-allmodconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- sparc-randconfig-002-20240430
|   `-- (.head.text):relocation-truncated-to-fit:R_SPARC_WDISP22-against-init.text
|-- sparc-randconfig-r113-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- sparc64-allmodconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- sparc64-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- sparc64-randconfig-001-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- sparc64-randconfig-r131-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- um-allyesconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- x86_64-randconfig-004-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- x86_64-randconfig-005-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
`-- xtensa-randconfig-001-20240430
    `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
clang_recent_errors
|-- arm-defconfig
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- arm-randconfig-002-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- arm-randconfig-003-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- arm64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-operation-between-different-enumeration-types-(-enum-amd_asic_type-and-enum-amd_chip_flags-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-between-different-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu_ras_mca_block-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_insert-Werror-Wunused-function
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_iter_next-Werror-Wunused-function
|   |-- drivers-gpu-drm-i915-display-intel_cursor.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_ddi.c:error:arithmetic-between-different-enumeration-types-(-enum-transcoder-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_display.c:error:arithmetic-between-different-enumeration-types-(-enum-phy-and-enum-port-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_display.c:error:arithmetic-between-different-enumeration-types-(-enum-transcoder-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_display_irq.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_display_irq.c:error:arithmetic-between-different-enumeration-types-(-enum-transcoder-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_dpll_mgr.c:error:arithmetic-between-different-enumeration-types-(-enum-tc_port-and-enum-intel_dpll_id-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_hotplug.c:error:arithmetic-between-different-enumeration-types-(-enum-hpd_pin-and-enum-port-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_pipe_crc.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_tc.c:error:arithmetic-between-different-enumeration-types-(-enum-intel_display_power_domain-and-enum-tc_port-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_vdsc.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-skl_universal_plane.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-skl_watermark.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
|   |-- drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operation-between-different-enumeration-types-(-enum-radeon_family-and-enum-radeon_chip_flags-)-Werror-Wenum-enum-conversion
|   |-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|   |-- include-linux-vmstat.h:error:arithmetic-between-different-enumeration-types-(-enum-node_stat_item-and-enum-lru_list-)-Werror-Wenum-enum-conversion
|   `-- include-linux-vmstat.h:error:arithmetic-between-different-enumeration-types-(-enum-zone_stat_item-and-enum-numa_stat_item-)-Werror-Wenum-enum-conversion
|-- hexagon-allmodconfig
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_insert-Werror-Wunused-function
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_iter_next-Werror-Wunused-function
|   |-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|   |-- include-asm-generic-io.h:error:performing-pointer-arithmetic-on-a-null-pointer-has-undefined-behavior-Werror-Wnull-pointer-arithmetic
|   `-- include-linux-vmstat.h:error:arithmetic-between-different-enumeration-types-(-enum-node_stat_item-and-enum-lru_list-)-Werror-Wenum-enum-conversion
|-- hexagon-allyesconfig
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_insert-Werror-Wunused-function
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_iter_next-Werror-Wunused-function
|   |-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|   |-- include-asm-generic-io.h:error:performing-pointer-arithmetic-on-a-null-pointer-has-undefined-behavior-Werror-Wnull-pointer-arithmetic
|   `-- include-linux-vmstat.h:error:arithmetic-between-different-enumeration-types-(-enum-node_stat_item-and-enum-lru_list-)-Werror-Wenum-enum-conversion
|-- i386-buildonly-randconfig-002-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- i386-randconfig-001-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- i386-randconfig-054-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- powerpc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-operation-between-different-enumeration-types-(-enum-amd_asic_type-and-enum-amd_chip_flags-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-between-different-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu_ras_mca_block-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_insert-Werror-Wunused-function
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_iter_next-Werror-Wunused-function
|   |-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
|   |-- drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operation-between-different-enumeration-types-(-enum-radeon_family-and-enum-radeon_chip_flags-)-Werror-Wenum-enum-conversion
|   |-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|   |-- include-linux-vmstat.h:error:arithmetic-between-different-enumeration-types-(-enum-node_stat_item-and-enum-lru_list-)-Werror-Wenum-enum-conversion
|   `-- include-linux-vmstat.h:error:arithmetic-between-different-enumeration-types-(-enum-zone_stat_item-and-enum-numa_stat_item-)-Werror-Wenum-enum-conversion
|-- powerpc-randconfig-003-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- powerpc64-randconfig-001-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- powerpc64-randconfig-003-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- riscv-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2-dml21-src-dml2_dpmm-dml2_dpmm_dcn4.c:error:arithmetic-between-enumeration-type-enum-dentist_divider_range-and-floating-point-type-double-Werror-Wenum-floa
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-operation-between-different-enumeration-types-(-enum-amd_asic_type-and-enum-amd_chip_flags-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-between-different-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu_ras_mca_block-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_insert-Werror-Wunused-function
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_iter_next-Werror-Wunused-function
|   |-- drivers-gpu-drm-i915-display-intel_cursor.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_ddi.c:error:arithmetic-between-different-enumeration-types-(-enum-transcoder-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_display.c:error:arithmetic-between-different-enumeration-types-(-enum-phy-and-enum-port-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_display.c:error:arithmetic-between-different-enumeration-types-(-enum-transcoder-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_display_irq.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_display_irq.c:error:arithmetic-between-different-enumeration-types-(-enum-transcoder-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_dpll_mgr.c:error:arithmetic-between-different-enumeration-types-(-enum-tc_port-and-enum-intel_dpll_id-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_hotplug.c:error:arithmetic-between-different-enumeration-types-(-enum-hpd_pin-and-enum-port-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_pipe_crc.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_tc.c:error:arithmetic-between-different-enumeration-types-(-enum-intel_display_power_domain-and-enum-tc_port-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_vdsc.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-skl_universal_plane.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-skl_watermark.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
|   |-- drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operation-between-different-enumeration-types-(-enum-radeon_family-and-enum-radeon_chip_flags-)-Werror-Wenum-enum-conversion
|   |-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|   |-- include-linux-vmstat.h:error:arithmetic-between-different-enumeration-types-(-enum-node_stat_item-and-enum-lru_list-)-Werror-Wenum-enum-conversion
|   `-- include-linux-vmstat.h:error:arithmetic-between-different-enumeration-types-(-enum-zone_stat_item-and-enum-numa_stat_item-)-Werror-Wenum-enum-conversion
|-- riscv-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2-dml21-src-dml2_dpmm-dml2_dpmm_dcn4.c:error:arithmetic-between-enumeration-type-enum-dentist_divider_range-and-floating-point-type-double-Werror-Wenum-floa
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-operation-between-different-enumeration-types-(-enum-amd_asic_type-and-enum-amd_chip_flags-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-between-different-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu_ras_mca_block-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_insert-Werror-Wunused-function
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_iter_next-Werror-Wunused-function
|   |-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
|   |-- drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operation-between-different-enumeration-types-(-enum-radeon_family-and-enum-radeon_chip_flags-)-Werror-Wenum-enum-conversion
|   |-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|   |-- include-linux-vmstat.h:error:arithmetic-between-different-enumeration-types-(-enum-node_stat_item-and-enum-lru_list-)-Werror-Wenum-enum-conversion
|   `-- include-linux-vmstat.h:error:arithmetic-between-different-enumeration-types-(-enum-zone_stat_item-and-enum-numa_stat_item-)-Werror-Wenum-enum-conversion
|-- s390-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_drv.c:error:bitwise-operation-between-different-enumeration-types-(-enum-amd_asic_type-and-enum-amd_chip_flags-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ras.c:error:arithmetic-between-different-enumeration-types-(-enum-amdgpu_ras_block-and-enum-amdgpu_ras_mca_block-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_cursor.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_ddi.c:error:arithmetic-between-different-enumeration-types-(-enum-transcoder-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_display.c:error:arithmetic-between-different-enumeration-types-(-enum-phy-and-enum-port-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_display.c:error:arithmetic-between-different-enumeration-types-(-enum-transcoder-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_display_irq.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_display_irq.c:error:arithmetic-between-different-enumeration-types-(-enum-transcoder-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_dpll_mgr.c:error:arithmetic-between-different-enumeration-types-(-enum-tc_port-and-enum-intel_dpll_id-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_hotplug.c:error:arithmetic-between-different-enumeration-types-(-enum-hpd_pin-and-enum-port-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_pipe_crc.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_tc.c:error:arithmetic-between-different-enumeration-types-(-enum-intel_display_power_domain-and-enum-tc_port-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-intel_vdsc.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-skl_universal_plane.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-i915-display-skl_watermark.c:error:arithmetic-between-different-enumeration-types-(-enum-pipe-and-enum-intel_display_power_domain-)-Werror-Wenum-enum-conversion
|   |-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
|   |-- drivers-gpu-drm-radeon-radeon_drv.c:error:bitwise-operation-between-different-enumeration-types-(-enum-radeon_family-and-enum-radeon_chip_flags-)-Werror-Wenum-enum-conversion
|   |-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|   |-- include-asm-generic-io.h:error:performing-pointer-arithmetic-on-a-null-pointer-has-undefined-behavior-Werror-Wnull-pointer-arithmetic
|   |-- include-linux-vmstat.h:error:arithmetic-between-different-enumeration-types-(-enum-node_stat_item-and-enum-lru_list-)-Werror-Wenum-enum-conversion
|   `-- include-linux-vmstat.h:error:arithmetic-between-different-enumeration-types-(-enum-zone_stat_item-and-enum-numa_stat_item-)-Werror-Wenum-enum-conversion
|-- x86_64-allnoconfig
|   |-- Warning:MAINTAINERS-references-a-file-that-doesn-t-exist:Documentation-devicetree-bindings-display-exynos
|   |-- Warning:MAINTAINERS-references-a-file-that-doesn-t-exist:Documentation-devicetree-bindings-reserved-memory-qcom
|   `-- net-ipv6-udp.c:trace-events-udp.h-is-included-more-than-once.
|-- x86_64-allyesconfig
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_insert-Werror-Wunused-function
|   |-- drivers-gpu-drm-drm_mm.c:error:unused-function-drm_mm_interval_tree_iter_next-Werror-Wunused-function
|   |-- drivers-gpu-drm-pl111-pl111_versatile.c:error:cast-to-smaller-integer-type-enum-versatile_clcd-from-const-void-Werror-Wvoid-pointer-to-enum-cast
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- x86_64-buildonly-randconfig-006-20240430
|   |-- drivers-iommu-amd-pasid.c:error:call-to-undeclared-function-mmu_notifier_register-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- drivers-iommu-amd-pasid.c:error:call-to-undeclared-function-mmu_notifier_unregister-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- x86_64-randconfig-001-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- x86_64-randconfig-002-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- x86_64-randconfig-012-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- x86_64-randconfig-014-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- x86_64-randconfig-101-20240430
|   `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used
|-- x86_64-randconfig-161-20240430
|   |-- drivers-virt-acrn-mm.c-acrn_vm_ram_map()-error:uninitialized-symbol-ret-.
|   |-- drivers-virt-acrn-mm.c-acrn_vm_ram_map()-error:uninitialized-symbol-start_pfn-.
|   `-- net-ipv6-route.c-rt6_fill_node()-error:we-previously-assumed-dst-could-be-null-(see-line-)
`-- x86_64-randconfig-r123-20240430
    `-- drivers-usb-dwc3-core.c:warning:variable-hw_mode-set-but-not-used

elapsed time: 751m

configs tested: 170
configs skipped: 4

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                     haps_hs_smp_defconfig   gcc  
arc                        nsim_700_defconfig   gcc  
arc                   randconfig-001-20240430   gcc  
arc                   randconfig-002-20240430   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   clang
arm                              allyesconfig   gcc  
arm                                 defconfig   clang
arm                       imx_v6_v7_defconfig   clang
arm                            mmp2_defconfig   gcc  
arm                       multi_v4t_defconfig   clang
arm                        mvebu_v5_defconfig   gcc  
arm                   randconfig-001-20240430   clang
arm                   randconfig-002-20240430   clang
arm                   randconfig-003-20240430   clang
arm                   randconfig-004-20240430   clang
arm64                            allmodconfig   clang
arm64                             allnoconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-001-20240430   clang
arm64                 randconfig-002-20240430   gcc  
arm64                 randconfig-003-20240430   clang
arm64                 randconfig-004-20240430   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20240430   gcc  
csky                  randconfig-002-20240430   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
hexagon               randconfig-002-20240430   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20240430   gcc  
i386         buildonly-randconfig-002-20240430   clang
i386         buildonly-randconfig-003-20240430   gcc  
i386         buildonly-randconfig-004-20240430   clang
i386         buildonly-randconfig-005-20240430   clang
i386         buildonly-randconfig-006-20240430   gcc  
i386                                defconfig   clang
i386                  randconfig-001-20240430   clang
i386                  randconfig-002-20240430   gcc  
i386                  randconfig-003-20240430   gcc  
i386                  randconfig-004-20240430   gcc  
i386                  randconfig-005-20240430   gcc  
i386                  randconfig-006-20240430   gcc  
i386                  randconfig-011-20240430   gcc  
i386                  randconfig-012-20240430   clang
i386                  randconfig-013-20240430   clang
i386                  randconfig-014-20240430   gcc  
i386                  randconfig-015-20240430   gcc  
i386                  randconfig-016-20240430   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20240430   gcc  
loongarch             randconfig-002-20240430   gcc  
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
mips                           ip27_defconfig   gcc  
mips                      malta_kvm_defconfig   gcc  
mips                malta_qemu_32r6_defconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20240430   gcc  
nios2                 randconfig-002-20240430   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                randconfig-001-20240430   gcc  
parisc                randconfig-002-20240430   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   clang
powerpc                      bamboo_defconfig   clang
powerpc                      chrp32_defconfig   clang
powerpc                        icon_defconfig   gcc  
powerpc                     ksi8560_defconfig   gcc  
powerpc                   microwatt_defconfig   gcc  
powerpc                       ppc64_defconfig   clang
powerpc               randconfig-001-20240430   gcc  
powerpc               randconfig-002-20240430   gcc  
powerpc               randconfig-003-20240430   clang
powerpc64                        alldefconfig   clang
powerpc64             randconfig-001-20240430   clang
powerpc64             randconfig-002-20240430   clang
powerpc64             randconfig-003-20240430   clang
riscv                            allmodconfig   clang
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   clang
riscv                               defconfig   clang
riscv                 randconfig-001-20240430   gcc  
riscv                 randconfig-002-20240430   clang
s390                             allmodconfig   clang
s390                              allnoconfig   clang
s390                             allyesconfig   gcc  
s390                                defconfig   clang
s390                  randconfig-001-20240430   gcc  
s390                  randconfig-002-20240430   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                    randconfig-001-20240430   gcc  
sh                    randconfig-002-20240430   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20240430   gcc  
sparc64               randconfig-002-20240430   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   gcc  
um                                  defconfig   clang
um                             i386_defconfig   gcc  
um                    randconfig-001-20240430   clang
um                    randconfig-002-20240430   clang
um                           x86_64_defconfig   clang
x86_64                            allnoconfig   clang
x86_64                           allyesconfig   clang
x86_64       buildonly-randconfig-001-20240430   gcc  
x86_64       buildonly-randconfig-002-20240430   clang
x86_64       buildonly-randconfig-003-20240430   clang
x86_64       buildonly-randconfig-004-20240430   clang
x86_64       buildonly-randconfig-005-20240430   clang
x86_64       buildonly-randconfig-006-20240430   clang
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20240430   clang
x86_64                randconfig-002-20240430   clang
x86_64                randconfig-003-20240430   gcc  
x86_64                randconfig-004-20240430   gcc  
x86_64                randconfig-005-20240430   gcc  
x86_64                randconfig-006-20240430   clang
x86_64                randconfig-012-20240430   clang
x86_64                randconfig-013-20240430   gcc  
x86_64                randconfig-014-20240430   clang
x86_64                          rhel-8.3-rust   clang
xtensa                            allnoconfig   gcc  
xtensa                randconfig-001-20240430   gcc  
xtensa                randconfig-002-20240430   gcc  
xtensa                         virt_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

