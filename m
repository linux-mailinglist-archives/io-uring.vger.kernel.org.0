Return-Path: <io-uring+bounces-9234-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 767FEB30875
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 23:37:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25FF71D000FB
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 21:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1D82C11CA;
	Thu, 21 Aug 2025 21:37:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA8B2C0261
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 21:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755812236; cv=none; b=LNovXRcdtmh9wbKatVxNCYh3L718nPOEojHOndgxaOY/TyTHkBYrHgTP3vP4w0jdMpjLNEseuK5scsLnzJbR4VPqTp3ZtwADw+sNoBMgqrji9zn1q5IUiZU5HmS1fx5WS4XZkDbtN/X/TIUmPcXtvggvtw+wFNmmisJRIZ9j7LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755812236; c=relaxed/simple;
	bh=D7mG/7eHvAByRVz7e7xhMg1OUUyaclPfbPriELhFlwc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=UI24Lbg626WTNP/+7se1rAbqCzA8cQ/CgNt6HyK/oTVG47NUC/7r8x30M90oUE+RCdk5jGdlJKOQah9V3CQiFeGaJXKkRLjPc7C8Hu6UBJPB/KT4fJSlvVcpG9FSJSzTAnuBcU8TC3lmABdV+PrGI1O4ueKRoeE3fkzCInrdMy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e67df0ed87so42689865ab.2
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 14:37:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755812234; x=1756417034;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4cr6QMqKu3ZXE5LbmZFl5rCj+PzGQQulyaw1Vp4aNc=;
        b=LA7T5gIDIfMoeSzDTTpM/ZGjE1EJJytnKWIlpNJQ3A+wx2totvRdkANyXr/WAC2PgO
         D/VkiA6kYC8l220KDXjV0myxWaDZRiW70MQb4YFfQWhxkolanCaf5xp4mjXdzVzCnf0j
         +N0JteR3uFQ/hCp15VG2ZJY7CC7XS10vJQX33bXFoBTtZwb1jeHbuBw/+h32QhJRoBdT
         Djyz2ecwbU4NUGjhffOizaMBKatdtTfnOPfwpz2egcXilHh8dhBpm/CoQrOZwQps5rOB
         s/vJ8xg6tqbslTRKnt5hdBNyYh2iENG/pQsY2sweewfoIeZuuxsBT2hlECanFYiInxVh
         Mt9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUVhow41gjUz4wuyswnsXmVC4rhX1rf/BxjQXyjY7ILaj63fJd/fPYAmnXcPKyLlUkTTSmusiTBcA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxklr5B4IVWHmSpPcwBm9xgC/OiacDJe3w9uU64IobAQHrJaI2l
	riCYyB+kmjR6hzsTpBSUnPTqvP0IL7zGClSDVHiQLkBOPT9TajTIr47ZpYXksQ1h0JFFnAiKlCQ
	3G90n9BEa0CSy+JMJ9FSQPZC2+SmLkVK7IOihZu+Y8jiOYGz4ccxnrgUCJpM=
X-Google-Smtp-Source: AGHT+IF7KMX4PQ9MbhjzaZS9KH1hsBks7Ag/V1kb+FvUzHNpAJ+XwFEszukCkWQQAtI/yieVASDRCVnTSkaGoVJY87X1Pd3k81yl
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19c6:b0:3e6:6c55:643 with SMTP id
 e9e14a558f8ab-3e9201f3d92mr16380665ab.7.1755812233632; Thu, 21 Aug 2025
 14:37:13 -0700 (PDT)
Date: Thu, 21 Aug 2025 14:37:13 -0700
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a79189.050a0220.cb3d1.0004.GAE@google.com>
Subject: [syzbot ci] Re: mm: remove nth_page()
From: syzbot ci <syzbot+ci0b43493baa45553d@syzkaller.appspotmail.com>
To: agordeev@linux.ibm.com, airlied@gmail.com, akpm@linux-foundation.org, 
	alex.williamson@redhat.com, alex@ghiti.fr, andreas@gaisler.com, 
	aou@eecs.berkeley.edu, axboe@kernel.dk, borntraeger@linux.ibm.com, 
	bp@alien8.de, brett.creeley@amd.com, cassel@kernel.org, 
	catalin.marinas@arm.com, chenhuacai@kernel.org, christophe.leroy@csgroup.eu, 
	cl@gentwo.org, dave.hansen@linux.intel.com, davem@davemloft.net, 
	david@redhat.com, dennis@kernel.org, dgilbert@interlog.com, 
	dlemoal@kernel.org, dri-devel@lists.freedesktop.org, dvyukov@google.com, 
	elver@google.com, glider@google.com, gor@linux.ibm.com, hannes@cmpxchg.org, 
	hca@linux.ibm.com, herbert@gondor.apana.org.au, 
	intel-gfx@lists.freedesktop.org, io-uring@vger.kernel.org, 
	iommu@lists.linux.dev, jackmanb@google.com, 
	james.bottomley@hansenpartnership.com, jani.nikula@linux.intel.com, 
	jason@zx2c4.com, jesper.nilsson@axis.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jhubbard@nvidia.com, joonas.lahtinen@linux.intel.com, 
	kasan-dev@googlegroups.com, kernel@xen0n.name, kevin.tian@intel.com, 
	kvm@vger.kernel.org, lars.persson@axis.com, liam.howlett@oracle.com, 
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, linux-mmc@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	m.szyprowski@samsung.com, maddy@linux.ibm.com, martin.petersen@oracle.com, 
	maximlevitsky@gmail.com, mhocko@suse.com, mingo@redhat.com, 
	mpe@ellerman.id.au, muchun.song@linux.dev, netdev@vger.kernel.org, 
	npiggin@gmail.com, oakad@yahoo.com, osalvador@suse.de, palmer@dabbelt.com, 
	paul.walmsley@sifive.com, peterx@redhat.com, robin.murphy@arm.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, shameerali.kolothum.thodi@huawei.com, 
	shuah@kernel.org, simona@ffwll.ch, surenb@google.com, svens@linux.ibm.com, 
	tglx@linutronix.de, tj@kernel.org, torvalds@linux-foundation.org, 
	tsbogend@alpha.franken.de, tursulin@ursulin.net, ulf.hansson@linaro.org, 
	vbabka@suse.cz, virtualization@lists.linux.dev, will@kernel.org, 
	wireguard@lists.zx2c4.com, x86@kernel.org, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm: remove nth_page()
https://lore.kernel.org/all/20250821200701.1329277-1-david@redhat.com
* [PATCH RFC 01/35] mm: stop making SPARSEMEM_VMEMMAP user-selectable
* [PATCH RFC 02/35] arm64: Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
* [PATCH RFC 03/35] s390/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
* [PATCH RFC 04/35] x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
* [PATCH RFC 05/35] wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
* [PATCH RFC 06/35] mm/page_alloc: reject unreasonable folio/compound page sizes in alloc_contig_range_noprof()
* [PATCH RFC 07/35] mm/memremap: reject unreasonable folio/compound page sizes in memremap_pages()
* [PATCH RFC 08/35] mm/hugetlb: check for unreasonable folio sizes when registering hstate
* [PATCH RFC 09/35] mm/mm_init: make memmap_init_compound() look more like prep_compound_page()
* [PATCH RFC 10/35] mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()
* [PATCH RFC 11/35] mm: sanity-check maximum folio size in folio_set_order()
* [PATCH RFC 12/35] mm: limit folio/compound page sizes in problematic kernel configs
* [PATCH RFC 13/35] mm: simplify folio_page() and folio_page_idx()
* [PATCH RFC 14/35] mm/mm/percpu-km: drop nth_page() usage within single allocation
* [PATCH RFC 15/35] fs: hugetlbfs: remove nth_page() usage within folio in adjust_range_hwpoison()
* [PATCH RFC 16/35] mm/pagewalk: drop nth_page() usage within folio in folio_walk_start()
* [PATCH RFC 17/35] mm/gup: drop nth_page() usage within folio when recording subpages
* [PATCH RFC 18/35] io_uring/zcrx: remove "struct io_copy_cache" and one nth_page() usage
* [PATCH RFC 19/35] io_uring/zcrx: remove nth_page() usage within folio
* [PATCH RFC 20/35] mips: mm: convert __flush_dcache_pages() to __flush_dcache_folio_pages()
* [PATCH RFC 21/35] mm/cma: refuse handing out non-contiguous page ranges
* [PATCH RFC 22/35] dma-remap: drop nth_page() in dma_common_contiguous_remap()
* [PATCH RFC 23/35] scatterlist: disallow non-contigous page ranges in a single SG entry
* [PATCH RFC 24/35] ata: libata-eh: drop nth_page() usage within SG entry
* [PATCH RFC 25/35] drm/i915/gem: drop nth_page() usage within SG entry
* [PATCH RFC 26/35] mspro_block: drop nth_page() usage within SG entry
* [PATCH RFC 27/35] memstick: drop nth_page() usage within SG entry
* [PATCH RFC 28/35] mmc: drop nth_page() usage within SG entry
* [PATCH RFC 29/35] scsi: core: drop nth_page() usage within SG entry
* [PATCH RFC 30/35] vfio/pci: drop nth_page() usage within SG entry
* [PATCH RFC 31/35] crypto: remove nth_page() usage within SG entry
* [PATCH RFC 32/35] mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()
* [PATCH RFC 33/35] kfence: drop nth_page() usage
* [PATCH RFC 34/35] block: update comment of "struct bio_vec" regarding nth_page()
* [PATCH RFC 35/35] mm: remove nth_page()

and found the following issue:
general protection fault in kfence_guarded_alloc

Full report is available here:
https://ci.syzbot.org/series/f6f0aea1-9616-4675-8c80-f9b59ba3211c

***

general protection fault in kfence_guarded_alloc

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      da114122b83149d1f1db0586b1d67947b651aa20
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/705b7862-eb10-40bd-a4cf-4820b4912466/config

smpboot: CPU0: Intel(R) Xeon(R) CPU @ 2.80GHz (family: 0x6, model: 0x55, stepping: 0x7)
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:kfence_guarded_alloc+0x643/0xc70
Code: 41 c1 e5 18 bf 00 00 00 f5 44 89 ee e8 a6 67 9c ff 45 31 f6 41 81 fd 00 00 00 f5 4c 0f 44 f3 49 8d 7e 08 48 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 05 e8 f1 cb ff ff 4c 8b 6c 24 18 4d 89 6e 08 49
RSP: 0000:ffffc90000047740 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffffea0004d90080 RCX: 0000000000000000
RDX: ffff88801c2e8000 RSI: 00000000ff000000 RDI: 0000000000000008
RBP: ffffc90000047850 R08: ffffffff99b2201b R09: 1ffffffff3364403
R10: dffffc0000000000 R11: fffffbfff3364404 R12: dffffc0000000000
R13: 00000000ff000000 R14: 0000000000000000 R15: ffff88813fec7068
FS:  0000000000000000(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 __kfence_alloc+0x385/0x3b0
 __kmalloc_noprof+0x440/0x4f0
 __alloc_workqueue+0x103/0x1b70
 alloc_workqueue_noprof+0xd4/0x210
 init_mm_internals+0x17/0x140
 kernel_init_freeable+0x307/0x4b0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x3f9/0x770
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:kfence_guarded_alloc+0x643/0xc70
Code: 41 c1 e5 18 bf 00 00 00 f5 44 89 ee e8 a6 67 9c ff 45 31 f6 41 81 fd 00 00 00 f5 4c 0f 44 f3 49 8d 7e 08 48 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 05 e8 f1 cb ff ff 4c 8b 6c 24 18 4d 89 6e 08 49
RSP: 0000:ffffc90000047740 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffffea0004d90080 RCX: 0000000000000000
RDX: ffff88801c2e8000 RSI: 00000000ff000000 RDI: 0000000000000008
RBP: ffffc90000047850 R08: ffffffff99b2201b R09: 1ffffffff3364403
R10: dffffc0000000000 R11: fffffbfff3364404 R12: dffffc0000000000
R13: 00000000ff000000 R14: 0000000000000000 R15: ffff88813fec7068
FS:  0000000000000000(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 0000000000350ef0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

