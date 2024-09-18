Return-Path: <io-uring+bounces-3222-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 698EF97B724
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 05:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD4B91F2416A
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 03:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A788248D;
	Wed, 18 Sep 2024 03:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/ql75D1"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EE627442;
	Wed, 18 Sep 2024 03:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726631866; cv=none; b=IFdUuC0ydlarFfbzV4T69xIoVX6Ah+9IIrowKx7RWFW+8RMiU8lFkIvNf0ee8noDDLY1DltbW4wR9NnGwjO1VG7hkaajQQsrXuAL6ZME+IHq5p/j5be0PyFhoAm8608MMTngGlDm0dZhdi0nU+1NrdnLroNLpT8OBxj1qLUVobg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726631866; c=relaxed/simple;
	bh=frD+K5HzGjuUq0/TH8Nj5H7UMFbyFlSEUpgkRZX7OQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kooUeU1gxR/VOXVHKzAYomd3vEqoGGdcUvvaN2BpjONEtbnHwubg26CBLq6FlwErHA6cy8t0XnCH7o2Vk7UZFbxqwykrZOgr8hTdMOZnJ/0IOmQEPqKcHNZv0cE+zWbRC/GqXyFlkQjXVZ+9N2HV7uXuV6xUzUw1W3p/Kr5tmkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i/ql75D1; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726631863; x=1758167863;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=frD+K5HzGjuUq0/TH8Nj5H7UMFbyFlSEUpgkRZX7OQU=;
  b=i/ql75D1kEiMZnBNJ0tupLx4EFrVgamasnK0EMjBeH8hnCvCzscKGJrs
   VABMSkIsbaOcA3WF6qZ5hHqB4tHIlv38aPwYS7ohFJ4ajmXrUYLwCXvJ1
   vg3nqdg0Rj/vKKdL1Qc0mvngxRPhLohA6G2DleMfzZNVj6A8YD1G5Us3J
   /KCzk5S/0Yt6egxezZrlM2XaAjmPozB5OEImJ+PRpIVRp9hogvCkJtD7p
   zD+4gL3fhY6MrKghhxqMw0hhQRzeSJfMVzKN0zWNygeYQuW667RP51ka9
   w1ZN/TTQrdiHlD2PAx9bGH1TFzciO6koLY7CCcTpqM4Q5jC9LiCWhENR7
   g==;
X-CSE-ConnectionGUID: TLvtrn6fQcuUg0IpV/wEYw==
X-CSE-MsgGUID: fid2O0s6RlKRSnh+58Nyiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11198"; a="25398610"
X-IronPort-AV: E=Sophos;i="6.10,235,1719903600"; 
   d="scan'208";a="25398610"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2024 20:57:43 -0700
X-CSE-ConnectionGUID: 97MOeXxuQZe8qSWGXtTPYQ==
X-CSE-MsgGUID: AeWhu8umTt6Qh9MrwCDOPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,235,1719903600"; 
   d="scan'208";a="73962877"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.161.23])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2024 20:57:39 -0700
Date: Wed, 18 Sep 2024 11:56:31 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, cgroups@vger.kernel.org,
	dqminh@cloudflare.com, longman@redhat.com,
	adriaan.schmidt@siemens.com, florian.bezdeka@siemens.com,
	stable@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	pengfei.xu@intel.com, yi1.lai@intel.com
Subject: Re: [PATCH 1/1] io_uring/sqpoll: do not allow pinning outside of
 cpuset
Message-ID: <ZupPb3OH3tnM2ARj@ly-workstation>
References: <20240909150036.55921-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909150036.55921-1-felix.moessbauer@siemens.com>

Hi Felix Moessbauer,

Greetings!

I used Syzkaller and found that there is KASAN: use-after-free Read in io_sq_offload_create in Linux-next tree - next-20240916.

After bisection and the first bad commit is:
"
f011c9cf04c0 io_uring/sqpoll: do not allow pinning outside of cpuset
"

All detailed into can be found at:
https://github.com/laifryiee/syzkaller_logs/tree/main/240917_135250_io_sq_offload_create
Syzkaller repro code:
https://github.com/laifryiee/syzkaller_logs/blob/main/240917_135250_io_sq_offload_create/repro.c
Syzkaller repro syscall steps:
https://github.com/laifryiee/syzkaller_logs/blob/main/240917_135250_io_sq_offload_create/repro.prog
Syzkaller report:
https://github.com/laifryiee/syzkaller_logs/blob/main/240917_135250_io_sq_offload_create/repro.report
Kconfig(make olddefconfig):
https://github.com/laifryiee/syzkaller_logs/blob/main/240917_135250_io_sq_offload_create/kconfig_origin
Bisect info:
https://github.com/laifryiee/syzkaller_logs/blob/main/240917_135250_io_sq_offload_create/bisect_info.log
bzImage:
https://github.com/laifryiee/syzkaller_logs/raw/main/240917_135250_io_sq_offload_create/bzImage_7083504315d64199a329de322fce989e1e10f4f7
Issue dmesg:
https://github.com/laifryiee/syzkaller_logs/blob/main/240917_135250_io_sq_offload_create/7083504315d64199a329de322fce989e1e10f4f7_dmesg.log

"
[   23.564898] ==================================================================
[   23.565444] BUG: KASAN: use-after-free in io_sq_offload_create+0xcaa/0x11d0
[   23.565971] Read of size 8 at addr ffff888036377898 by task repro/729
[   23.566459] 
[   23.566593] CPU: 0 UID: 0 PID: 729 Comm: repro Not tainted 6.11.0-next-20240916-7083504315d6 #1
[   23.567271] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   23.568066] Call Trace:
[   23.568252]  <TASK>
[   23.568417]  dump_stack_lvl+0xea/0x150
[   23.568718]  print_report+0xce/0x610
[   23.569001]  ? io_sq_offload_create+0xcaa/0x11d0
[   23.569340]  ? kasan_addr_to_slab+0x11/0xb0
[   23.569651]  ? io_sq_offload_create+0xcaa/0x11d0
[   23.569992]  kasan_report+0xcc/0x110
[   23.570277]  ? io_sq_offload_create+0xcaa/0x11d0
[   23.570621]  kasan_check_range+0x3e/0x1c0
[   23.570917]  __kasan_check_read+0x15/0x20
[   23.571212]  io_sq_offload_create+0xcaa/0x11d0
[   23.571540]  ? __pfx_io_sq_offload_create+0x10/0x10
[   23.571893]  ? __pfx___lock_acquire+0x10/0x10
[   23.572228]  ? __this_cpu_preempt_check+0x21/0x30
[   23.572580]  ? lock_acquire.part.0+0x152/0x390
[   23.572910]  ? __this_cpu_preempt_check+0x21/0x30
[   23.573254]  ? lock_release+0x441/0x870
[   23.573541]  ? __pfx_lock_release+0x10/0x10
[   23.573846]  ? trace_lock_acquire+0x139/0x1b0
[   23.574180]  ? debug_smp_processor_id+0x20/0x30
[   23.574524]  ? rcu_is_watching+0x19/0xc0
[   23.574826]  ? __alloc_pages_noprof+0x517/0x710
[   23.575171]  ? __pfx___alloc_pages_noprof+0x10/0x10
[   23.575526]  ? mod_objcg_state+0x42c/0x9c0
[   23.575838]  ? lockdep_hardirqs_on+0x89/0x110
[   23.576159]  ? __sanitizer_cov_trace_switch+0x58/0xa0
[   23.576534]  ? policy_nodemask+0xf9/0x450
[   23.576835]  ? __sanitizer_cov_trace_const_cmp2+0x1c/0x30
[   23.577220]  ? alloc_pages_mpol_noprof+0x35d/0x580
[   23.577575]  ? __pfx_alloc_pages_mpol_noprof+0x10/0x10
[   23.577950]  ? __kmalloc_node_noprof+0x3a3/0x4e0
[   23.578302]  ? __kvmalloc_node_noprof+0x7f/0x240
[   23.578645]  ? alloc_pages_noprof+0xa9/0x180
[   23.578963]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
[   23.579347]  ? io_pages_map+0x244/0x5c0
[   23.579631]  io_uring_setup+0x18df/0x3950
[   23.579936]  ? __pfx_io_uring_setup+0x10/0x10
[   23.580263]  ? __audit_syscall_entry+0x39c/0x500
[   23.580602]  __x64_sys_io_uring_setup+0xa4/0x160
[   23.580939]  x64_sys_call+0x17f5/0x20d0
[   23.581224]  do_syscall_64+0x6d/0x140
[   23.581498]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   23.581872] RIP: 0033:0x7efd9fa3ee5d
[   23.582140] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 af 1b 00 f7 d8 64 89 01 48
[   23.583404] RSP: 002b:00007ffdd4400858 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
[   23.583938] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007efd9fa3ee5d
[   23.584430] RDX: 00007efd9fb3f247 RSI: 0000000020000080 RDI: 0000000000005230
[   23.584927] RBP: 00007ffdd4400860 R08: 00007ffdd44002d0 R09: 00007ffdd4400890
[   23.585419] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffdd44009b8
[   23.585914] R13: 0000000000401730 R14: 0000000000403e08 R15: 00007efd9fcb5000
[   23.586424]  </TASK>
[   23.586589] 
[   23.586709] The buggy address belongs to the physical page:
[   23.587094] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x36377
[   23.587644] flags: 0xfffffc0000000(node=0|zone=1|lastcpupid=0x1fffff)
[   23.588103] raw: 000fffffc0000000 ffffea0000d8ddc8 ffffea0000d8ddc8 0000000000000000
[   23.588636] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[   23.589167] page dumped because: kasan: bad access detected
[   23.589551] 
[   23.589670] Memory state around the buggy address:
[   23.590007]  ffff888036377780: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.590514]  ffff888036377800: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.591011] >ffff888036377880: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.591508]                             ^
[   23.591794]  ffff888036377900: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.592292]  ffff888036377980: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.592789] ==================================================================
[   23.593344] Disabling lock debugging due to kernel taint
"

I hope you find it useful.

Regards,
Yi Lai

---

If you don't need the following environment to reproduce the problem or if you
already have one reproduced environment, please ignore the following information.

How to reproduce:
git clone https://gitlab.com/xupengfe/repro_vm_env.git
cd repro_vm_env
tar -xvf repro_vm_env.tar.gz
cd repro_vm_env; ./start3.sh  // it needs qemu-system-x86_64 and I used v7.1.0
  // start3.sh will load bzImage_2241ab53cbb5cdb08a6b2d4688feb13971058f65 v6.2-rc5 kernel
  // You could change the bzImage_xxx as you want
  // Maybe you need to remove line "-drive if=pflash,format=raw,readonly=on,file=./OVMF_CODE.fd \" for different qemu version
You could use below command to log in, there is no password for root.
ssh -p 10023 root@localhost

After login vm(virtual machine) successfully, you could transfer reproduced
binary to the vm by below way, and reproduce the problem in vm:
gcc -pthread -o repro repro.c
scp -P 10023 repro root@localhost:/root/

Get the bzImage for target kernel:
Please use target kconfig and copy it to kernel_src/.config
make olddefconfig
make -jx bzImage           //x should equal or less than cpu num your pc has

Fill the bzImage file into above start3.sh to load the target kernel in vm.

Tips:
If you already have qemu-system-x86_64, please ignore below info.
If you want to install qemu v7.1.0 version:
git clone https://github.com/qemu/qemu.git
cd qemu
git checkout -f v7.1.0
mkdir build
cd build
yum install -y ninja-build.x86_64
yum -y install libslirp-devel.x86_64
../configure --target-list=x86_64-softmmu --enable-kvm --enable-vnc --enable-gtk --enable-sdl --enable-usb-redir --enable-slirp
make
make install 

On Mon, Sep 09, 2024 at 05:00:36PM +0200, Felix Moessbauer wrote:
> The submit queue polling threads are userland threads that just never
> exit to the userland. When creating the thread with IORING_SETUP_SQ_AFF,
> the affinity of the poller thread is set to the cpu specified in
> sq_thread_cpu. However, this CPU can be outside of the cpuset defined
> by the cgroup cpuset controller. This violates the rules defined by the
> cpuset controller and is a potential issue for realtime applications.
> 
> In b7ed6d8ffd6 we fixed the default affinity of the poller thread, in
> case no explicit pinning is required by inheriting the one of the
> creating task. In case of explicit pinning, the check is more
> complicated, as also a cpu outside of the parent cpumask is allowed.
> We implemented this by using cpuset_cpus_allowed (that has support for
> cgroup cpusets) and testing if the requested cpu is in the set.
> 
> Fixes: 37d1e2e3642e ("io_uring: move SQPOLL thread io-wq forked worker")
> Cc: stable@vger.kernel.org # 6.1+
> Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
> ---
> Hi,
> 
> that's hopefully the last fix of cpu pinnings of the sq poller threads.
> However, there is more to come on the io-wq side. E.g the syscalls for
> IORING_REGISTER_IOWQ_AFF that can be used to change the affinites are
> not yet protected. I'm currently just lacking good reproducers for that.
> I also have to admit that I don't feel too comfortable making changes to
> the wq part, given that I don't have good tests.
> 
> While fixing this, I'm wondering if it makes sense to add tests for the
> combination of pinning and cpuset. If yes, where should these tests be
> added?
> 
> Best regards,
> Felix Moessbauer
> Siemens AG
> 
>  io_uring/sqpoll.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 713be7c29388..b8ec8fec99b8 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -10,6 +10,7 @@
>  #include <linux/slab.h>
>  #include <linux/audit.h>
>  #include <linux/security.h>
> +#include <linux/cpuset.h>
>  #include <linux/io_uring.h>
>  
>  #include <uapi/linux/io_uring.h>
> @@ -459,10 +460,12 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
>  			return 0;
>  
>  		if (p->flags & IORING_SETUP_SQ_AFF) {
> +			struct cpumask allowed_mask;
>  			int cpu = p->sq_thread_cpu;
>  
>  			ret = -EINVAL;
> -			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
> +			cpuset_cpus_allowed(current, &allowed_mask);
> +			if (!cpumask_test_cpu(cpu, &allowed_mask))
>  				goto err_sqpoll;
>  			sqd->sq_cpu = cpu;
>  		} else {
> -- 
> 2.39.2
> 

