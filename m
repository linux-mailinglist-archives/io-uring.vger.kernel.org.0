Return-Path: <io-uring+bounces-698-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD4B8626D1
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 19:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C3882823DC
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 18:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 819D4200A0;
	Sat, 24 Feb 2024 18:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j0NZp5qd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D403B13FF6;
	Sat, 24 Feb 2024 18:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708800426; cv=none; b=ZHd8/RCywphZavHoXMF3RqNUNhOUYXz9xR6rigcFMHqdScXwgWqyxl5WGySCNNtGXZcwzDwsJnPF+OKQk3tzZ+UMk7QW9bjAnp7gQzUGRP8SIcNPjfaNJLe0KJURcfZKSGzF2WwSZdwKVwytJ32bVipI/m/cwz6eqsYR3Ei1qbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708800426; c=relaxed/simple;
	bh=8NC1pmW4SNm4uq22usE3M7/xXFJlcGLq8FI/irGyZG8=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=E/SP2VY40N1ZXsNNPOxBE1lOtB9zSnADJjFQWHA3jXoF0ulbB6914lqIzAvnFPjIdi4E2YbtVBRtLuesv1yhfwILvRbBtaM11HuPqm5RP/eZnPDNKLAgs/hFVtnZWmQHLBHWNz/RvpGKf8xsU+QK4G+9xu2fwLg573wqTXF3GsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j0NZp5qd; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e4d869b019so981102b3a.0;
        Sat, 24 Feb 2024 10:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708800424; x=1709405224; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=luI5LH6pYhZC/Cdk0BZ+N4QrEkQKug3aTK3kXTF38gg=;
        b=j0NZp5qdY+gEqPiPLYFzgTUt92dYUHwYgx62WHvPSrsojSFlEfHFzF5xh5/LtrKAYE
         XY0LC/VYtsI9IjAtk+tkmLbudgJkLaOoM7Ix/HkRPxEMBJA3OSrcoW2CuFw5X1pG7ZpR
         GZKwGd7EkTT6YpZ1svwcAhJFQRKNmMetBBQgye9uCRYxRoL0lnVFry2b5QZN7bdCBsNc
         uBqTor1N78mklKJc3AGglhClrt3qphjJcopql5YPIGLx+Oqi9+hcDW3GM0AN6cUzy/td
         Y0qBlYa+J55aMTk9oVULJnDj7Yb5JhUOdhlN2divKgsJbK77ObV2VGtPxi4w6H2GYN4x
         f/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708800424; x=1709405224;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=luI5LH6pYhZC/Cdk0BZ+N4QrEkQKug3aTK3kXTF38gg=;
        b=pccgMtC1U7mRGgfncMQ1Lz6iiaQHTcv5eVLYqXy4tvx3RCmMRAQaiTsERRoIDQNBT3
         OydsuBYo5xd1rvcoQq+gvprJSgD0GO5vBFK8S5LkPc/jphFUdp8SxpdLiNRLDoCQIUl1
         eWQSNUND2RV2pGXopsEalkOWBEoZQ/lZD5z74UEqiee5cWACx1EbsY2vjxWKdZOoNMV/
         J70t6eoDEmpjRH1dRthsydT53Ty2Acxe2JWUhrfMTuR1P73GrlC81RT6tujUYHTPSmvr
         fPcSd9DK3W60Qw98DZV0YWpkPNskYs+qvWJRPahmgBGTyBQaYa0NOOj0emYq6qCoqQc9
         svcw==
X-Forwarded-Encrypted: i=1; AJvYcCUgxlFnaArqMHt5F/MQiSXn10h5rXDDsDgln2+epphZ9O5c3M3JGv5dCPWwrfj+F6jez3rlwvR4rtz5kamNcTRjPFkyMtpIb4CMya/wJlTArM6LQYYnSUs6GjEfCkwD/o/wsC05hf2PHtVqzInCIaoySTMasAaSvSndOBoOoHXWueXRxjHTf8ps0IUS5HkdjH4wLqM27RW5uH6WEQFB1Pj/R694D2fRpGpFdB1x25acjtD1M3Zhbq6dMTxGZOJQ
X-Gm-Message-State: AOJu0Yy8IK6ZF3mL3n3D/MEHl5cazoSgPB31y/Bm6Iez8w5WdaP443Hc
	OlZX6I6o2s4OivK3gdU5l2Y3eMLZuQfV6meZkFeBeHV9Ilkl+3mH
X-Google-Smtp-Source: AGHT+IE2zmchSNyxHArKwWkAWiCM6Fohd8BpReCrvkrKeVbpuW6I59xIUvFAqm+1+7Zh24+ke9Ca/A==
X-Received: by 2002:a05:6a00:5d:b0:6e5:6d2:234b with SMTP id i29-20020a056a00005d00b006e506d2234bmr524354pfk.0.1708800424044;
        Sat, 24 Feb 2024 10:47:04 -0800 (PST)
Received: from dw-tp ([171.76.80.106])
        by smtp.gmail.com with ESMTPSA id r7-20020aa78b87000000b006e48b04d8c0sm1386455pfd.64.2024.02.24.10.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 10:47:03 -0800 (PST)
Date: Sun, 25 Feb 2024 00:16:55 +0530
Message-Id: <87o7c51yzk.fsf@doe.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, nilay@linux.ibm.com, Prasad Singamsetty <prasad.singamsetty@oracle.com>, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v4 04/11] fs: Add initial atomic write support info to statx
In-Reply-To: <20240219130109.341523-5-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

John Garry <john.g.garry@oracle.com> writes:

> From: Prasad Singamsetty <prasad.singamsetty@oracle.com>
>
> Extend statx system call to return additional info for atomic write support
> support for a file.
>
> Helper function generic_fill_statx_atomic_writes() can be used by FSes to
> fill in the relevant statx fields.
>
> Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
> #jpg: relocate bdev support to another patch

^^^ miss maybe?
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  fs/stat.c                 | 34 ++++++++++++++++++++++++++++++++++
>  include/linux/fs.h        |  3 +++
>  include/linux/stat.h      |  3 +++
>  include/uapi/linux/stat.h |  9 ++++++++-
>  4 files changed, 48 insertions(+), 1 deletion(-)
>
> diff --git a/fs/stat.c b/fs/stat.c
> index 77cdc69eb422..522787a4ab6a 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -89,6 +89,37 @@ void generic_fill_statx_attr(struct inode *inode, struct kstat *stat)
>  }
>  EXPORT_SYMBOL(generic_fill_statx_attr);
>  
> +/**
> + * generic_fill_statx_atomic_writes - Fill in the atomic writes statx attributes
> + * @stat:	Where to fill in the attribute flags
> + * @unit_min:	Minimum supported atomic write length
+ * @unit_min:	Minimum supported atomic write length in bytes


> + * @unit_max:	Maximum supported atomic write length
+ * @unit_max:	Maximum supported atomic write length in bytes

mentioning unit of the length might be useful here.

> + *
> + * Fill in the STATX{_ATTR}_WRITE_ATOMIC flags in the kstat structure from
> + * atomic write unit_min and unit_max values.
> + */
> +void generic_fill_statx_atomic_writes(struct kstat *stat,
> +				      unsigned int unit_min,

This (unit_min) can still go above in the same line.

> +				      unsigned int unit_max)
> +{
> +	/* Confirm that the request type is known */
> +	stat->result_mask |= STATX_WRITE_ATOMIC;
> +
> +	/* Confirm that the file attribute type is known */
> +	stat->attributes_mask |= STATX_ATTR_WRITE_ATOMIC;
> +
> +	if (unit_min) {
> +		stat->atomic_write_unit_min = unit_min;
> +		stat->atomic_write_unit_max = unit_max;
> +		/* Initially only allow 1x segment */
> +		stat->atomic_write_segments_max = 1;

Please log info about this in commit message about where this limit came
from? Is it since we only support ubuf (which IIUC, only supports 1
segment)? Later when we will add support for iovec, this limit can be
lifted?

> +
> +		/* Confirm atomic writes are actually supported */
> +		stat->attributes |= STATX_ATTR_WRITE_ATOMIC;
> +	}
> +}
> +EXPORT_SYMBOL(generic_fill_statx_atomic_writes);
> +
>  /**
>   * vfs_getattr_nosec - getattr without security checks
>   * @path: file to get attributes from
> @@ -658,6 +689,9 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
>  	tmp.stx_mnt_id = stat->mnt_id;
>  	tmp.stx_dio_mem_align = stat->dio_mem_align;
>  	tmp.stx_dio_offset_align = stat->dio_offset_align;
> +	tmp.stx_atomic_write_unit_min = stat->atomic_write_unit_min;
> +	tmp.stx_atomic_write_unit_max = stat->atomic_write_unit_max;
> +	tmp.stx_atomic_write_segments_max = stat->atomic_write_segments_max;
>  
>  	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
>  }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7271640fd600..531140a7e27a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3167,6 +3167,9 @@ extern const struct inode_operations page_symlink_inode_operations;
>  extern void kfree_link(void *);
>  void generic_fillattr(struct mnt_idmap *, u32, struct inode *, struct kstat *);
>  void generic_fill_statx_attr(struct inode *inode, struct kstat *stat);
> +void generic_fill_statx_atomic_writes(struct kstat *stat,
> +				      unsigned int unit_min,
> +				      unsigned int unit_max);

We can make 80 col. width even with unit_min in the same first line as of *stat.


>  extern int vfs_getattr_nosec(const struct path *, struct kstat *, u32, unsigned int);
>  extern int vfs_getattr(const struct path *, struct kstat *, u32, unsigned int);
>  void __inode_add_bytes(struct inode *inode, loff_t bytes);
> diff --git a/include/linux/stat.h b/include/linux/stat.h
> index 52150570d37a..2c5e2b8c6559 100644
> --- a/include/linux/stat.h
> +++ b/include/linux/stat.h
> @@ -53,6 +53,9 @@ struct kstat {
>  	u32		dio_mem_align;
>  	u32		dio_offset_align;
>  	u64		change_cookie;
> +	u32		atomic_write_unit_min;
> +	u32		atomic_write_unit_max;
> +	u32		atomic_write_segments_max;
>  };
>  
>  /* These definitions are internal to the kernel for now. Mainly used by nfsd. */
> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
> index 2f2ee82d5517..c0e8e10d1de6 100644
> --- a/include/uapi/linux/stat.h
> +++ b/include/uapi/linux/stat.h
> @@ -127,7 +127,12 @@ struct statx {
>  	__u32	stx_dio_mem_align;	/* Memory buffer alignment for direct I/O */
>  	__u32	stx_dio_offset_align;	/* File offset alignment for direct I/O */
>  	/* 0xa0 */
> -	__u64	__spare3[12];	/* Spare space for future expansion */
> +	__u32	stx_atomic_write_unit_min;
> +	__u32	stx_atomic_write_unit_max;
> +	__u32   stx_atomic_write_segments_max;

Let's add one liner for each of these fields similar to how it was done
for others?

/* Minimum supported atomic write length in bytes */
/* Maximum supported atomic write length in bytes */
/* Maximum no. of segments (iovecs?) supported for atomic write */


> +	__u32   __spare1;
> +	/* 0xb0 */
> +	__u64	__spare3[10];	/* Spare space for future expansion */
>  	/* 0x100 */
>  };
>  
> @@ -155,6 +160,7 @@ struct statx {
>  #define STATX_MNT_ID		0x00001000U	/* Got stx_mnt_id */
>  #define STATX_DIOALIGN		0x00002000U	/* Want/got direct I/O alignment info */
>  #define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
> +#define STATX_WRITE_ATOMIC	0x00008000U	/* Want/got atomic_write_* fields */
>  
>  #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
>  
> @@ -190,6 +196,7 @@ struct statx {
>  #define STATX_ATTR_MOUNT_ROOT		0x00002000 /* Root of a mount */
>  #define STATX_ATTR_VERITY		0x00100000 /* [I] Verity protected file */
>  #define STATX_ATTR_DAX			0x00200000 /* File is currently in DAX state */
> +#define STATX_ATTR_WRITE_ATOMIC		0x00400000 /* File supports atomic write operations */
>  
>  
>  #endif /* _UAPI_LINUX_STAT_H */
> -- 
> 2.31.1

