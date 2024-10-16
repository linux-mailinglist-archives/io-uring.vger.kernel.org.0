Return-Path: <io-uring+bounces-3717-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4927599FE95
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 03:58:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC5BE1F228F1
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 01:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F0D171A7;
	Wed, 16 Oct 2024 01:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fNzIAYwU"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280ABFC0C
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 01:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729043919; cv=none; b=ejmdwbTBFJoOP8tnYHrVn+hA3Q01N3wimxY+A8VR/dZbVr4vwmtnaH+2ylBjoGtPVH6ilvR27rjTtFDsUpSgix2j+n+NwH4T+D1RMo8Ewbn0gij4U1uXtJKEYurEU8FfS2GlMs1oyZpFECcvVjuBIDtDaupuFd2jhus/DXaTiMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729043919; c=relaxed/simple;
	bh=1v0tbTAVYYnNxm/Fp0nosL2G4P6E1vi34p2ARhbuTtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZQwYQqZm+3rQv7uVeTBVhV3YB7zhJ9H3Uz9nfLvJE16vFQiPub8xtnZJ30jVpvlYA0qUgblFasxIIfL8KzEvv0ONYQSaOBWibIrwBYuhyQ/rj6XcVYsBfSKL93inN39RF0Ax/K7j/REuXnFw3f7vC8Qc92Wd0V6qy5b5NHr0G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fNzIAYwU; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729043917; x=1760579917;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1v0tbTAVYYnNxm/Fp0nosL2G4P6E1vi34p2ARhbuTtY=;
  b=fNzIAYwU6JK003B8v35ZCnksJ8RGh9+JecBSI5mB8DyEMpnkNo+qCktb
   geMkLClG0q6c0bM5Xj8o6Q1uSJS3xXroAW+BjqcYqZlQe94JpbzTCJrkt
   HbLFM5ywGG3NktB6pQ7mFvidMKxe9K8seoHmY/ub69WG5+l4qOwaO+40X
   pP2cedHNZwjDKH2NIQjYwVU+Hs9pXYk+7R0m8cvTJrLlU1rra92huS+ZE
   f/8djHOIkTrlXCUa9ZjlHAwzh3m26dOfkgjLCrqDPRdxGadpDRCjug9tb
   Nh6Vmv+i7nB/tEXTJEHLAp09HHBuoJc9rUHfjES0RKamnUeVCOI4y487E
   A==;
X-CSE-ConnectionGUID: zY7Xnq+bQBGaNejQ8EZuVw==
X-CSE-MsgGUID: 6Wn17JalRYGXaV1NS2slrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="32164747"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="32164747"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 18:58:36 -0700
X-CSE-ConnectionGUID: dgFJ855zRrGaHb1Zn/EBKQ==
X-CSE-MsgGUID: zd9nrSHmTCqpaEZBU61ciQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,206,1725346800"; 
   d="scan'208";a="78915338"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.161.23])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 18:58:35 -0700
Date: Wed, 16 Oct 2024 09:57:37 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, yi1.lai@intel.com
Subject: Re: [PATCH] io_uring: rename "copy buffers" to "clone buffers"
Message-ID: <Zw8dkUzsxQ5LgAJL@ly-workstation>
References: <27e7258c-b6d0-439c-854f-e6441a82148b@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27e7258c-b6d0-439c-854f-e6441a82148b@kernel.dk>

Hi Jens Axboe,

Greetings!

I used Syzkaller and found that there is BUG: unable to handle kernel paging request in io_register_clone_buffers in v6.12-rc2

After bisection and the first bad commit is:
"
636119af94f2 io_uring: rename "copy buffers" to "clone buffers"
"

All detailed into can be found at:
https://github.com/laifryiee/syzkaller_logs/tree/main/241015_200715_io_register_clone_buffers
Syzkaller repro code:
https://github.com/laifryiee/syzkaller_logs/tree/main/241015_200715_io_register_clone_buffers/repro.c
Syzkaller repro syscall steps:
https://github.com/laifryiee/syzkaller_logs/tree/main/241015_200715_io_register_clone_buffers/repro.prog
Syzkaller report:
https://github.com/laifryiee/syzkaller_logs/tree/main/241015_200715_io_register_clone_buffers/repro.report
Kconfig(make olddefconfig):
https://github.com/laifryiee/syzkaller_logs/tree/main/241015_200715_io_register_clone_buffers/kconfig_origin
Bisect info:
https://github.com/laifryiee/syzkaller_logs/tree/main/241015_200715_io_register_clone_buffers/bisect_info.log
bzImage:
https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/main/241015_200715_io_register_clone_buffers/bzImage_8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
Issue dmesg:
https://github.com/laifryiee/syzkaller_logs/blob/main/241015_200715_io_register_clone_buffers/8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b_dmesg.log

"
[   29.812887] Oops: Oops: 0003 [#1] PREEMPT SMP KASAN NOPTI
[   29.813730] CPU: 1 UID: 0 PID: 731 Comm: repro Not tainted 6.12.0-rc2-8cf0b93919e1 #1
[   29.814907] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   29.816616] RIP: 0010:io_register_clone_buffers+0x45e/0x810
[   29.817524] Code: 3c 08 00 0f 85 3c 03 00 00 48 8b 1b be 04 00 00 00 41 bf 01 00 00 00 48 8d 43 14 48 89 c7 48 89 85 08 ff ff ff e8 82 de f0 fe <f0> 44 0f c1 7b 14 31 ff 44 89 fe e8 e2 02 89 fe 45 85 ff 0f 84 b1
[   29.820286] RSP: 0018:ffff88801469fc50 EFLAGS: 00010246
[   29.821100] RAX: 0000000000000001 RBX: ffffffff85f7ca20 RCX: ffffffff82de91ae
[   29.822165] RDX: fffffbfff0bef947 RSI: 0000000000000004 RDI: ffffffff85f7ca34
[   29.823328] RBP: ffff88801469fd98 R08: 0000000000000001 R09: fffffbfff0bef946
[   29.823868] R10: ffffffff85f7ca37 R11: 0000000000000001 R12: ffff88800ef21560
[   29.824407] R13: 0000000000000000 R14: ffff88801469fd70 R15: 0000000000000001
[   29.824924] FS:  00007feaa461a600(0000) GS:ffff88806c500000(0000) knlGS:0000000000000000
[   29.825512] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.825934] CR2: ffffffff85f7ca34 CR3: 00000000143a4000 CR4: 0000000000750ef0
[   29.826473] PKRU: 55555554
[   29.826683] Call Trace:
[   29.826874]  <TASK>
[   29.827047]  ? show_regs+0x6d/0x80
[   29.827333]  ? __die+0x29/0x70
[   29.827584]  ? page_fault_oops+0x391/0xc50
[   29.827897]  ? __pfx_page_fault_oops+0x10/0x10
[   29.828258]  ? __pfx_is_prefetch.constprop.0+0x10/0x10
[   29.828650]  ? search_module_extables+0x3f/0x110
[   29.829010]  ? io_register_clone_buffers+0x45e/0x810
[   29.829404]  ? search_exception_tables+0x65/0x70
[   29.829756]  ? fixup_exception+0x114/0xb10
[   29.830082]  ? kernelmode_fixup_or_oops.constprop.0+0xcc/0x100
[   29.830543]  ? __bad_area_nosemaphore+0x3b2/0x650
[   29.830911]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
[   29.831327]  ? spurious_kernel_fault_check+0xbf/0x1c0
[   29.831724]  ? bad_area_nosemaphore+0x33/0x40
[   29.832100]  ? do_kern_addr_fault+0x14e/0x180
[   29.832441]  ? exc_page_fault+0x1b0/0x1d0
[   29.832767]  ? asm_exc_page_fault+0x2b/0x30
[   29.833101]  ? io_register_clone_buffers+0x45e/0x810
[   29.833485]  ? io_register_clone_buffers+0x45e/0x810
[   29.833892]  ? __pfx_io_register_clone_buffers+0x10/0x10
[   29.834345]  ? rcu_is_watching+0x19/0xc0
[   29.834663]  ? trace_contention_end+0xe1/0x120
[   29.835018]  ? __mutex_lock+0x258/0x1490
[   29.835340]  ? lock_release+0x441/0x870
[   29.835650]  __io_uring_register+0x61d/0x20f0
[   29.836002]  ? __pfx___io_uring_register+0x10/0x10
[   29.836398]  ? __fget_files+0x23c/0x4b0
[   29.836715]  ? trace_irq_enable+0x111/0x120
[   29.837056]  __x64_sys_io_uring_register+0x172/0x2a0
[   29.837445]  x64_sys_call+0x14bd/0x20d0
[   29.837758]  do_syscall_64+0x6d/0x140
[   29.838050]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   29.838457] RIP: 0033:0x7feaa443ee5d
[   29.838743] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 af 1b 00 f7 d8 64 89 01 48
[   29.840161] RSP: 002b:00007ffdd5c54e98 EFLAGS: 00000217 ORIG_RAX: 00000000000001ab
[   29.840751] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007feaa443ee5d
[   29.841332] RDX: 00000000200002c0 RSI: 000000000000001e RDI: 0000000000000004
[   29.841881] RBP: 00007ffdd5c54eb0 R08: 00007ffdd5c54eb0 R09: 00007ffdd5c54eb0
[   29.842439] R10: 0000000000000001 R11: 0000000000000217 R12: 00007ffdd5c55008
[   29.842985] R13: 00000000004019e5 R14: 0000000000403e08 R15: 00007feaa4661000
[   29.843551]  </TASK>
[   29.843724] Modules linked in:
[   29.843973] CR2: ffffffff85f7ca34
[   29.844247] ---[ end trace 0000000000000000 ]---
[   29.844608] RIP: 0010:io_register_clone_buffers+0x45e/0x810
[   29.845054] Code: 3c 08 00 0f 85 3c 03 00 00 48 8b 1b be 04 00 00 00 41 bf 01 00 00 00 48 8d 43 14 48 89 c7 48 89 85 08 ff ff ff e8 82 de f0 fe <f0> 44 0f c1 7b 14 31 ff 44 89 fe e8 e2 02 89 fe 45 85 ff 0f 84 b1
[   29.846459] RSP: 0018:ffff88801469fc50 EFLAGS: 00010246
[   29.846864] RAX: 0000000000000001 RBX: ffffffff85f7ca20 RCX: ffffffff82de91ae
[   29.847409] RDX: fffffbfff0bef947 RSI: 0000000000000004 RDI: ffffffff85f7ca34
[   29.847945] RBP: ffff88801469fd98 R08: 0000000000000001 R09: fffffbfff0bef946
[   29.848492] R10: ffffffff85f7ca37 R11: 0000000000000001 R12: ffff88800ef21560
[   29.849031] R13: 0000000000000000 R14: ffff88801469fd70 R15: 0000000000000001
[   29.849586] FS:  00007feaa461a600(0000) GS:ffff88806c500000(0000) knlGS:0000000000000000
[   29.850195] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.850631] CR2: ffffffff85f7ca34 CR3: 00000000143a4000 CR4: 0000000000750ef0
[   29.851184] PKRU: 55555554
[   29.851403] note: repro[731] exited with irqs disabled
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

On Sun, Sep 15, 2024 at 09:21:48AM -0600, Jens Axboe wrote:
> A recent commit added support for copying registered buffers from one
> ring to another. But that term is a bit confusing, as no copying of
> buffer data is done here. What is being done is simply cloning the
> buffer registrations from one ring to another.
> 
> Rename it while we still can, so that it's more descriptive. No
> functional changes in this patch.
> 
> Fixes: 7cc2a6eadcd7 ("io_uring: add IORING_REGISTER_COPY_BUFFERS method")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 9dc5bb428c8a..1fe79e750470 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -609,8 +609,8 @@ enum io_uring_register_op {
>  
>  	IORING_REGISTER_CLOCK			= 29,
>  
> -	/* copy registered buffers from source ring to current ring */
> -	IORING_REGISTER_COPY_BUFFERS		= 30,
> +	/* clone registered buffers from source ring to current ring */
> +	IORING_REGISTER_CLONE_BUFFERS		= 30,
>  
>  	/* this goes last */
>  	IORING_REGISTER_LAST,
> @@ -701,7 +701,7 @@ enum {
>  	IORING_REGISTER_SRC_REGISTERED = 1,
>  };
>  
> -struct io_uring_copy_buffers {
> +struct io_uring_clone_buffers {
>  	__u32	src_fd;
>  	__u32	flags;
>  	__u32	pad[6];
> diff --git a/io_uring/register.c b/io_uring/register.c
> index dab0f8024ddf..b8a48a6a89ee 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -542,11 +542,11 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>  			break;
>  		ret = io_register_clock(ctx, arg);
>  		break;
> -	case IORING_REGISTER_COPY_BUFFERS:
> +	case IORING_REGISTER_CLONE_BUFFERS:
>  		ret = -EINVAL;
>  		if (!arg || nr_args != 1)
>  			break;
> -		ret = io_register_copy_buffers(ctx, arg);
> +		ret = io_register_clone_buffers(ctx, arg);
>  		break;
>  	default:
>  		ret = -EINVAL;
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 40696a395f0a..9264e555ae59 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1139,7 +1139,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
>  	return 0;
>  }
>  
> -static int io_copy_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
> +static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
>  {
>  	struct io_mapped_ubuf **user_bufs;
>  	struct io_rsrc_data *data;
> @@ -1203,9 +1203,9 @@ static int io_copy_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
>   *
>   * Since the memory is already accounted once, don't account it again.
>   */
> -int io_register_copy_buffers(struct io_ring_ctx *ctx, void __user *arg)
> +int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
>  {
> -	struct io_uring_copy_buffers buf;
> +	struct io_uring_clone_buffers buf;
>  	bool registered_src;
>  	struct file *file;
>  	int ret;
> @@ -1223,7 +1223,7 @@ int io_register_copy_buffers(struct io_ring_ctx *ctx, void __user *arg)
>  	file = io_uring_register_get_file(buf.src_fd, registered_src);
>  	if (IS_ERR(file))
>  		return PTR_ERR(file);
> -	ret = io_copy_buffers(ctx, file->private_data);
> +	ret = io_clone_buffers(ctx, file->private_data);
>  	if (!registered_src)
>  		fput(file);
>  	return ret;
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 93546ab337a6..eb4803e473b0 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -68,7 +68,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
>  			   struct io_mapped_ubuf *imu,
>  			   u64 buf_addr, size_t len);
>  
> -int io_register_copy_buffers(struct io_ring_ctx *ctx, void __user *arg);
> +int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
>  void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
>  int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
>  int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
> 
> -- 
> Jens Axboe
> 

