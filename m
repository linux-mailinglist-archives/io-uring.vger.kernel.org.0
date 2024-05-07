Return-Path: <io-uring+bounces-1817-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D558BEFDE
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 00:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C22B0286632
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 22:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422727CF30;
	Tue,  7 May 2024 22:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzecXbN5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AAC78C76;
	Tue,  7 May 2024 22:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715121525; cv=none; b=jC/MsOTVt5c3ANjJ31X079GI2iG+7CEQuGjh5qR8no3eYZZe2Qdlyy8vRjOvNZvsvuK793YYkcKXomuWwRlOjpuxXBpjZqY+xp7A7RpE4g282AAceVH/nu1yeTuJFKkvjn1jgxwb3zafpS84JxF8jHsmv3P/qGrWe4+1M0sJEEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715121525; c=relaxed/simple;
	bh=r7nYzwtLtpZilFBSUJuGG5VDQQ6NTdsBK6gY8BnVINo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=mBKquzIABU+vBFMPH12seL93g0uhXTrJsyd+sYakb2vAY/xrQZARHU4mhkHp/6EhFGMkqdoVccutlg2JyrpYlNXSqarwZGvNU4Dvln4UVLLob4ghx9KDFP47wOQ0Tk6HiNGHHRDORLhFJh/gmyRXbvuZHvNgZEicQBhwyAKrJKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzecXbN5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DD7C2BBFC;
	Tue,  7 May 2024 22:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715121524;
	bh=r7nYzwtLtpZilFBSUJuGG5VDQQ6NTdsBK6gY8BnVINo=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=bzecXbN5aDtNAEhSWxdtKdmkSbAAkhjrxUY71lK8wN+gKkGTUDaTwBJWBnjCfKyP1
	 27QgoFtmy3lICA3OJ78VZPqLMwDG9TcBMIMpZ3KwYXNGqLcATLC5gcHlP+VhEcDXbR
	 R/vmBS2hjbP8Fkg5oCZidVqNEOyLIfC/BW5PSWJFTm6FdPKOE8FlZAkAvh7GZHg/o6
	 hlY8qLeJ4Scb24HcdBd8/5fJxvPtgZpFMX9u8mMOPqSXP2Kms/krw8tGWThed7w9yv
	 59s2zhzWlIf7nr2ByWAIQ3DS1UCG+Tat3VgnaLW42WY6ywgYIWe23I1jQzWYd60wvs
	 om1y7k4qausfw==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 08 May 2024 01:38:37 +0300
Message-Id: <D13RU3UPQVOW.3FM4GX4JHGLJJ@kernel.org>
Cc: <Liam.Howlett@oracle.com>, <bp@alien8.de>, <bpf@vger.kernel.org>,
 <broonie@kernel.org>, <christophe.leroy@csgroup.eu>,
 <dan.j.williams@intel.com>, <dave.hansen@linux.intel.com>,
 <debug@rivosinc.com>, <hpa@zytor.com>, <io-uring@vger.kernel.org>,
 <keescook@chromium.org>, <kirill.shutemov@linux.intel.com>,
 <linux-cxl@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-s390@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
 <luto@kernel.org>, <mingo@redhat.com>, <nvdimm@lists.linux.dev>,
 <peterz@infradead.org>, <sparclinux@vger.kernel.org>, <tglx@linutronix.de>,
 <x86@kernel.org>
Subject: Re: [PATCH] mm: Remove mm argument from mm_get_unmapped_area()
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Rick Edgecombe" <rick.p.edgecombe@intel.com>,
 <akpm@linux-foundation.org>
X-Mailer: aerc 0.17.0
References: <20240506160747.1321726-1-rick.p.edgecombe@intel.com>
In-Reply-To: <20240506160747.1321726-1-rick.p.edgecombe@intel.com>

On Mon May 6, 2024 at 7:07 PM EEST, Rick Edgecombe wrote:
> Recently the get_unmapped_area() pointer on mm_struct was removed in
> favor of direct callable function that can determines which of two
> handlers to call based on an mm flag. This function,
> mm_get_unmapped_area(), checks the flag of the mm passed as an argument.
>
> Dan Williams pointed out (see link) that all callers pass curret->mm, so
> the mm argument is unneeded. It could be conceivable for a caller to want
> to pass a different mm in the future, but in this case a new helper could
> easily be added.
>
> So remove the mm argument, and rename the function
> current_get_unmapped_area().
>
> Fixes: 529ce23a764f ("mm: switch mm->get_unmapped_area() to a flag")
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Link: https://lore.kernel.org/lkml/6603bed6662a_4a98a2949e@dwillia2-mobl3=
.amr.corp.intel.com.notmuch/
> ---
> Based on linux-next.
> ---
>  arch/sparc/kernel/sys_sparc_64.c |  9 +++++----
>  arch/x86/kernel/cpu/sgx/driver.c |  2 +-
>  drivers/char/mem.c               |  2 +-
>  drivers/dax/device.c             |  6 +++---
>  fs/proc/inode.c                  |  2 +-
>  fs/ramfs/file-mmu.c              |  2 +-
>  include/linux/sched/mm.h         |  6 +++---
>  io_uring/memmap.c                |  2 +-
>  kernel/bpf/arena.c               |  2 +-
>  kernel/bpf/syscall.c             |  2 +-
>  mm/mmap.c                        | 11 +++++------
>  mm/shmem.c                       |  9 ++++-----
>  12 files changed, 27 insertions(+), 28 deletions(-)
>
> diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_spa=
rc_64.c
> index d9c3b34ca744..cf0b4ace5bf9 100644
> --- a/arch/sparc/kernel/sys_sparc_64.c
> +++ b/arch/sparc/kernel/sys_sparc_64.c
> @@ -220,7 +220,7 @@ unsigned long get_fb_unmapped_area(struct file *filp,=
 unsigned long orig_addr, u
> =20
>  	if (flags & MAP_FIXED) {
>  		/* Ok, don't mess with it. */
> -		return mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff, =
flags);
> +		return current_get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
>  	}
>  	flags &=3D ~MAP_SHARED;
> =20
> @@ -233,8 +233,9 @@ unsigned long get_fb_unmapped_area(struct file *filp,=
 unsigned long orig_addr, u
>  		align_goal =3D (64UL * 1024);
> =20
>  	do {
> -		addr =3D mm_get_unmapped_area(current->mm, NULL, orig_addr,
> -					    len + (align_goal - PAGE_SIZE), pgoff, flags);
> +		addr =3D current_get_unmapped_area(NULL, orig_addr,
> +						 len + (align_goal - PAGE_SIZE),
> +						 pgoff, flags);
>  		if (!(addr & ~PAGE_MASK)) {
>  			addr =3D (addr + (align_goal - 1UL)) & ~(align_goal - 1UL);
>  			break;
> @@ -252,7 +253,7 @@ unsigned long get_fb_unmapped_area(struct file *filp,=
 unsigned long orig_addr, u
>  	 * be obtained.
>  	 */
>  	if (addr & ~PAGE_MASK)
> -		addr =3D mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff=
, flags);
> +		addr =3D current_get_unmapped_area(NULL, orig_addr, len, pgoff, flags)=
;
> =20
>  	return addr;
>  }
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/d=
river.c
> index 22b65a5f5ec6..5f7bfd9035f7 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -113,7 +113,7 @@ static unsigned long sgx_get_unmapped_area(struct fil=
e *file,
>  	if (flags & MAP_FIXED)
>  		return addr;
> =20
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags)=
;
> +	return current_get_unmapped_area(file, addr, len, pgoff, flags);
>  }
> =20
>  #ifdef CONFIG_COMPAT
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 7c359cc406d5..a29c4bd506d5 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -546,7 +546,7 @@ static unsigned long get_unmapped_area_zero(struct fi=
le *file,
>  	}
> =20
>  	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath it */
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags)=
;
> +	return current_get_unmapped_area(file, addr, len, pgoff, flags);
>  #else
>  	return -ENOSYS;
>  #endif
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index eb61598247a9..c379902307b7 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -329,14 +329,14 @@ static unsigned long dax_get_unmapped_area(struct f=
ile *filp,
>  	if ((off + len_align) < off)
>  		goto out;
> =20
> -	addr_align =3D mm_get_unmapped_area(current->mm, filp, addr, len_align,
> -					  pgoff, flags);
> +	addr_align =3D current_get_unmapped_area(filp, addr, len_align,
> +					       pgoff, flags);
>  	if (!IS_ERR_VALUE(addr_align)) {
>  		addr_align +=3D (off - addr_align) & (align - 1);
>  		return addr_align;
>  	}
>   out:
> -	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags)=
;
> +	return current_get_unmapped_area(filp, addr, len, pgoff, flags);
>  }
> =20
>  static const struct address_space_operations dev_dax_aops =3D {
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index d19434e2a58e..24a6aeac3de5 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -455,7 +455,7 @@ pde_get_unmapped_area(struct proc_dir_entry *pde, str=
uct file *file, unsigned lo
>  		return pde->proc_ops->proc_get_unmapped_area(file, orig_addr, len, pgo=
ff, flags);
> =20
>  #ifdef CONFIG_MMU
> -	return mm_get_unmapped_area(current->mm, file, orig_addr, len, pgoff, f=
lags);
> +	return current_get_unmapped_area(file, orig_addr, len, pgoff, flags);
>  #endif
> =20
>  	return orig_addr;
> diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
> index b45c7edc3225..85f57de31102 100644
> --- a/fs/ramfs/file-mmu.c
> +++ b/fs/ramfs/file-mmu.c
> @@ -35,7 +35,7 @@ static unsigned long ramfs_mmu_get_unmapped_area(struct=
 file *file,
>  		unsigned long addr, unsigned long len, unsigned long pgoff,
>  		unsigned long flags)
>  {
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags)=
;
> +	return current_get_unmapped_area(file, addr, len, pgoff, flags);
>  }
> =20
>  const struct file_operations ramfs_file_operations =3D {
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 91546493c43d..c67c7de05c7a 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -187,9 +187,9 @@ arch_get_unmapped_area_topdown(struct file *filp, uns=
igned long addr,
>  			  unsigned long len, unsigned long pgoff,
>  			  unsigned long flags);
> =20
> -unsigned long mm_get_unmapped_area(struct mm_struct *mm, struct file *fi=
lp,
> -				   unsigned long addr, unsigned long len,
> -				   unsigned long pgoff, unsigned long flags);
> +unsigned long current_get_unmapped_area(struct file *filp, unsigned long=
 addr,
> +					unsigned long len, unsigned long pgoff,
> +					unsigned long flags);
> =20
>  unsigned long
>  arch_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index 4785d6af5fee..1aaea32c797c 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -305,7 +305,7 @@ unsigned long io_uring_get_unmapped_area(struct file =
*filp, unsigned long addr,
>  #else
>  	addr =3D 0UL;
>  #endif
> -	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags)=
;
> +	return current_get_unmapped_area(filp, addr, len, pgoff, flags);
>  }
> =20
>  #else /* !CONFIG_MMU */
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 4a1be699bb82..054486f7c453 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -314,7 +314,7 @@ static unsigned long arena_get_unmapped_area(struct f=
ile *filp, unsigned long ad
>  			return -EINVAL;
>  	}
> =20
> -	ret =3D mm_get_unmapped_area(current->mm, filp, addr, len * 2, 0, flags=
);
> +	ret =3D current_get_unmapped_area(filp, addr, len * 2, 0, flags);
>  	if (IS_ERR_VALUE(ret))
>  		return ret;
>  	if ((ret >> 32) =3D=3D ((ret + len - 1) >> 32))
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 2222c3ff88e7..d9ff2843f6ef 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -992,7 +992,7 @@ static unsigned long bpf_get_unmapped_area(struct fil=
e *filp, unsigned long addr
>  	if (map->ops->map_get_unmapped_area)
>  		return map->ops->map_get_unmapped_area(filp, addr, len, pgoff, flags);
>  #ifdef CONFIG_MMU
> -	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags)=
;
> +	return current_get_unmapped_area(filp, addr, len, pgoff, flags);
>  #else
>  	return addr;
>  #endif
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 83b4682ec85c..4e98a907c53d 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1901,16 +1901,15 @@ __get_unmapped_area(struct file *file, unsigned l=
ong addr, unsigned long len,
>  	return error ? error : addr;
>  }
> =20
> -unsigned long
> -mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
> -		     unsigned long addr, unsigned long len,
> -		     unsigned long pgoff, unsigned long flags)
> +unsigned long current_get_unmapped_area(struct file *file, unsigned long=
 addr,
> +					unsigned long len, unsigned long pgoff,
> +					unsigned long flags)
>  {
> -	if (test_bit(MMF_TOPDOWN, &mm->flags))
> +	if (test_bit(MMF_TOPDOWN, &current->mm->flags))
>  		return arch_get_unmapped_area_topdown(file, addr, len, pgoff, flags);
>  	return arch_get_unmapped_area(file, addr, len, pgoff, flags);
>  }
> -EXPORT_SYMBOL(mm_get_unmapped_area);
> +EXPORT_SYMBOL(current_get_unmapped_area);
> =20
>  /**
>   * find_vma_intersection() - Look up the first VMA which intersects the =
interval
> diff --git a/mm/shmem.c b/mm/shmem.c
> index f5d60436b604..c0acd7db93c8 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2276,8 +2276,7 @@ unsigned long shmem_get_unmapped_area(struct file *=
file,
>  	if (len > TASK_SIZE)
>  		return -ENOMEM;
> =20
> -	addr =3D mm_get_unmapped_area(current->mm, file, uaddr, len, pgoff,
> -				    flags);
> +	addr =3D current_get_unmapped_area(file, uaddr, len, pgoff, flags);
> =20
>  	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>  		return addr;
> @@ -2334,8 +2333,8 @@ unsigned long shmem_get_unmapped_area(struct file *=
file,
>  	if (inflated_len < len)
>  		return addr;
> =20
> -	inflated_addr =3D mm_get_unmapped_area(current->mm, NULL, uaddr,
> -					     inflated_len, 0, flags);
> +	inflated_addr =3D current_get_unmapped_area(NULL, uaddr,
> +						  inflated_len, 0, flags);
>  	if (IS_ERR_VALUE(inflated_addr))
>  		return addr;
>  	if (inflated_addr & ~PAGE_MASK)
> @@ -4799,7 +4798,7 @@ unsigned long shmem_get_unmapped_area(struct file *=
file,
>  				      unsigned long addr, unsigned long len,
>  				      unsigned long pgoff, unsigned long flags)
>  {
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags)=
;
> +	return current_get_unmapped_area(file, addr, len, pgoff, flags);
>  }
>  #endif
> =20
>
> base-commit: 9221b2819b8a4196eecf5476d66201be60fbcf29

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko

