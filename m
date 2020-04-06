Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B78919F9F2
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2020 18:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgDFQM1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 12:12:27 -0400
Received: from mail-mw2nam12on2076.outbound.protection.outlook.com ([40.107.244.76]:6232
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728863AbgDFQM0 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 6 Apr 2020 12:12:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AsbScyYYOKaD2n5zMFCUYcF8pWTSDF3N2yv0iVizlTft06lZVQIEcp0BWYzgWFVJ40G9vypreLnPQNJywe9Cxg7HT7lvoYg2r1dKTNcog5S17wmq2bWjvm2QbWNgNllS5yNQ86z6TA1ylpac8ung0gnkrug64Uw4ZWrk4motKFqxsSoSJwROfqiyxPvqjzZ0sgDtzuXjGDl3pKVjQtcr49PdmKzqOY6GK1pt0Q8wTEKOFkroj5dSyKdaKldh/cSCd9ZfQS5sobxMqkY3N+0rjD60F2e5hzIvxM+MiMlaXFlU8BsypuDsDdzguS0JQ1zIIjKAte3uCGZ2ajNCqt7KwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/RBY9j/v/uRT01oTDm3Gkx0CuSkvkY86robxKuXud6c=;
 b=AUV1e8THb5E51tLZlGdQZraXEBnQQhDgLYPAuy/lSR/gXevrfQhTdxGUhEjn/a998IXwkoLY0p0OeWTK6BtyB4WCAqIHWPAPETFsRDAeKJAN9QeGHSc6qEybwqXcr5j+pC79nuV1duH/0Y1Ze1Fxxs93hg1gdUqCffdKaeM0FAzDj4rv2toY0vpMB2rFq3wHjnGI/oIJwhOJSjhiElGiLx9+xwaiyeSPO3wBTlThyRb3GPTWyRsC3vmj/jUzxVHzfyHSB8KsKYJSSS0VGoYcXke6QMaDh/iui9/whZwsbzu/dPMIrEqX5ppGEvAAN8CiQyB4+VRkgAy6mMcIvEZbJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/RBY9j/v/uRT01oTDm3Gkx0CuSkvkY86robxKuXud6c=;
 b=4L1HuhWXGg2uRu/p8k3e2cSrUEExagoSFqc+i9eGOHRyIDtIF7LAehSYXP+v5r8qOo0yYdZpdNl6jSRCfqi8qCguQOhoqCy8Rpuf7u3g3gCbhJAwdanSNv8tSHFiJq4zy2xN3R1LXS3KDhvSPJvnHeJgnYZwLB2x1j4cuLZBgs0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Felix.Kuehling@amd.com; 
Received: from SN1PR12MB2414.namprd12.prod.outlook.com (2603:10b6:802:2e::31)
 by SN1PR12MB2575.namprd12.prod.outlook.com (2603:10b6:802:25::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Mon, 6 Apr
 2020 16:10:10 +0000
Received: from SN1PR12MB2414.namprd12.prod.outlook.com
 ([fe80::38ef:1510:9525:f806]) by SN1PR12MB2414.namprd12.prod.outlook.com
 ([fe80::38ef:1510:9525:f806%7]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 16:10:10 +0000
Subject: Re: [PATCH 5/6] kernel: better document the use_mm/unuse_mm API
 contract
To:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Alex Deucher <alexander.deucher@amd.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20200404094101.672954-1-hch@lst.de>
 <20200404094101.672954-6-hch@lst.de>
From:   Felix Kuehling <felix.kuehling@amd.com>
Message-ID: <b081a6f2-15c9-7d88-8f6d-ed154348e09a@amd.com>
Date:   Mon, 6 Apr 2020 12:10:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200404094101.672954-6-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: YQBPR0101CA0043.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::20) To SN1PR12MB2414.namprd12.prod.outlook.com
 (2603:10b6:802:2e::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.100] (142.116.63.128) by YQBPR0101CA0043.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Mon, 6 Apr 2020 16:10:09 +0000
X-Originating-IP: [142.116.63.128]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0a314b22-a5c7-4620-1090-08d7da44fb44
X-MS-TrafficTypeDiagnostic: SN1PR12MB2575:|SN1PR12MB2575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25758A9CA42CFD778856708792C20@SN1PR12MB2575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2414.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(16576012)(54906003)(110136005)(86362001)(31696002)(4326008)(8676002)(52116002)(81156014)(81166006)(8936002)(6486002)(44832011)(2616005)(66476007)(316002)(478600001)(956004)(2906002)(36756003)(66556008)(31686004)(5660300002)(7416002)(186003)(16526019)(26005)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7A3Xk55dvXk6c3URnUVKRYpohIGCp0OagUNKu5mAAZJ34MyO19jO0BML1o80C9mvwlOkEFNdGkGtfJES8TeMu57nMhK7NrbR19YSRdUyMxuHhqNsqkp8o46nnndiCu4JMC4GWsBTqKdwkYS0cAi7rTby/Q/GMKRtIHIwXf+9J97Wdowm19X6TLP438IUkELJ3BxxSDnjGcako2GEMH8F0XZNIbwbdxwPCw9EP8AJFWWNSTNdGZGmPQsZQUyCSPcQf4okmf55xHtLsMIr20pD6PcepsqvkLW1pc5kw8L+PYVkOb8h9x1+2aFmBKPQo8GqiLQZ42GJX2L9prUALwxUkJEFI2WCU+qFd/vvaTloYSpl6klQQO0fGaCPBwI2fhLvPQOEJTTv6QdKLlwt74Bmd33PedWduY7bt1q12I5QC6h6JIXE+F/dzrOhhOHvHX7q
X-MS-Exchange-AntiSpam-MessageData: Cc7MgPE7Z5uEkT4A2b1lOiKwvNaT5cGj7WdDRxBpn6wTpJDjenHUqrbMgIXgpBWEQKL8KCw6npiDK1pNDsZTfCQnZkD+ikZW6/3/NalfK1W1CVw993bpHVCk73l5ssNcL+jiWQIKz17a2OAG1DM6zw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a314b22-a5c7-4620-1090-08d7da44fb44
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 16:10:10.7525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nKCEnEVK5PYqq+ucQcG6vBu7LdwSq/5HCWQxZ450xbW6Uc9qZzH7nQl4EWDZjrcg1hdzbxBn7hwKf3jicEICjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2575
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 2020-04-04 um 5:41 a.m. schrieb Christoph Hellwig:
> Switch the function documentation to kerneldoc comments, and add
> WARN_ON_ONCE asserts that the calling thread is a kernel thread and
> does not have ->mm set (or has ->mm set in the case of unuse_mm).
>
> Also give the functions a kthread_ prefix to better document the
> use case.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>


> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  4 +--
>  drivers/gpu/drm/i915/gvt/kvmgt.c           |  4 +--
>  drivers/usb/gadget/function/f_fs.c         |  4 +--
>  drivers/usb/gadget/legacy/inode.c          |  4 +--
>  drivers/vhost/vhost.c                      |  4 +--
>  fs/io-wq.c                                 |  6 ++--
>  fs/io_uring.c                              |  6 ++--
>  include/linux/kthread.h                    |  4 +--
>  kernel/kthread.c                           | 33 +++++++++++-----------
>  mm/oom_kill.c                              |  6 ++--
>  mm/vmacache.c                              |  4 +--
>  11 files changed, 39 insertions(+), 40 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
> index bce5e93fefc8..63db84e09408 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
> @@ -192,9 +192,9 @@ uint8_t amdgpu_amdkfd_get_xgmi_hops_count(struct kgd_dev *dst, struct kgd_dev *s
>  			if ((mmptr) == current->mm) {			\
>  				valid = !get_user((dst), (wptr));	\
>  			} else if (current->flags & PF_KTHREAD) {	\
> -				use_mm(mmptr);				\
> +				kthread_use_mm(mmptr);			\
>  				valid = !get_user((dst), (wptr));	\
> -				unuse_mm(mmptr);			\
> +				kthread_unuse_mm(mmptr);		\
>  			}						\
>  			pagefault_enable();				\
>  		}							\
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index dee01c371bf5..92e9b340dbc2 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -2048,7 +2048,7 @@ static int kvmgt_rw_gpa(unsigned long handle, unsigned long gpa,
>  	if (kthread) {
>  		if (!mmget_not_zero(kvm->mm))
>  			return -EFAULT;
> -		use_mm(kvm->mm);
> +		kthread_use_mm(kvm->mm);
>  	}
>  
>  	idx = srcu_read_lock(&kvm->srcu);
> @@ -2057,7 +2057,7 @@ static int kvmgt_rw_gpa(unsigned long handle, unsigned long gpa,
>  	srcu_read_unlock(&kvm->srcu, idx);
>  
>  	if (kthread) {
> -		unuse_mm(kvm->mm);
> +		kthread_unuse_mm(kvm->mm);
>  		mmput(kvm->mm);
>  	}
>  
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index c57b1b2507c6..d9e48bd7c692 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -827,9 +827,9 @@ static void ffs_user_copy_worker(struct work_struct *work)
>  		mm_segment_t oldfs = get_fs();
>  
>  		set_fs(USER_DS);
> -		use_mm(io_data->mm);
> +		kthread_use_mm(io_data->mm);
>  		ret = ffs_copy_to_iter(io_data->buf, ret, &io_data->data);
> -		unuse_mm(io_data->mm);
> +		kthread_unuse_mm(io_data->mm);
>  		set_fs(oldfs);
>  	}
>  
> diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
> index 8b5233888bf8..a05552bc2ff8 100644
> --- a/drivers/usb/gadget/legacy/inode.c
> +++ b/drivers/usb/gadget/legacy/inode.c
> @@ -462,9 +462,9 @@ static void ep_user_copy_worker(struct work_struct *work)
>  	struct kiocb *iocb = priv->iocb;
>  	size_t ret;
>  
> -	use_mm(mm);
> +	kthread_use_mm(mm);
>  	ret = copy_to_iter(priv->buf, priv->actual, &priv->to);
> -	unuse_mm(mm);
> +	kthread_unuse_mm(mm);
>  	if (!ret)
>  		ret = -EFAULT;
>  
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 4e9ce54869af..1787d426a956 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -336,7 +336,7 @@ static int vhost_worker(void *data)
>  	mm_segment_t oldfs = get_fs();
>  
>  	set_fs(USER_DS);
> -	use_mm(dev->mm);
> +	kthread_use_mm(dev->mm);
>  
>  	for (;;) {
>  		/* mb paired w/ kthread_stop */
> @@ -364,7 +364,7 @@ static int vhost_worker(void *data)
>  				schedule();
>  		}
>  	}
> -	unuse_mm(dev->mm);
> +	kthread_unuse_mm(dev->mm);
>  	set_fs(oldfs);
>  	return 0;
>  }
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index c49c2bdbafb5..83c2868eff2a 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -169,7 +169,7 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
>  		}
>  		__set_current_state(TASK_RUNNING);
>  		set_fs(KERNEL_DS);
> -		unuse_mm(worker->mm);
> +		kthread_unuse_mm(worker->mm);
>  		mmput(worker->mm);
>  		worker->mm = NULL;
>  	}
> @@ -416,7 +416,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
>  static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
>  {
>  	if (worker->mm) {
> -		unuse_mm(worker->mm);
> +		kthread_unuse_mm(worker->mm);
>  		mmput(worker->mm);
>  		worker->mm = NULL;
>  	}
> @@ -425,7 +425,7 @@ static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
>  		return;
>  	}
>  	if (mmget_not_zero(work->mm)) {
> -		use_mm(work->mm);
> +		kthread_use_mm(work->mm);
>  		if (!worker->mm)
>  			set_fs(USER_DS);
>  		worker->mm = work->mm;
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 27a4ecb724ca..367406381044 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5839,7 +5839,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>  				err = -EFAULT;
>  				goto fail_req;
>  			}
> -			use_mm(ctx->sqo_mm);
> +			kthread_use_mm(ctx->sqo_mm);
>  			*mm = ctx->sqo_mm;
>  		}
>  
> @@ -5911,7 +5911,7 @@ static int io_sq_thread(void *data)
>  			 * may sleep.
>  			 */
>  			if (cur_mm) {
> -				unuse_mm(cur_mm);
> +				kthread_unuse_mm(cur_mm);
>  				mmput(cur_mm);
>  				cur_mm = NULL;
>  			}
> @@ -5987,7 +5987,7 @@ static int io_sq_thread(void *data)
>  
>  	set_fs(old_fs);
>  	if (cur_mm) {
> -		unuse_mm(cur_mm);
> +		kthread_unuse_mm(cur_mm);
>  		mmput(cur_mm);
>  	}
>  	revert_creds(old_cred);
> diff --git a/include/linux/kthread.h b/include/linux/kthread.h
> index c2d40c9672d6..12258ea077cf 100644
> --- a/include/linux/kthread.h
> +++ b/include/linux/kthread.h
> @@ -200,8 +200,8 @@ bool kthread_cancel_delayed_work_sync(struct kthread_delayed_work *work);
>  
>  void kthread_destroy_worker(struct kthread_worker *worker);
>  
> -void use_mm(struct mm_struct *mm);
> -void unuse_mm(struct mm_struct *mm);
> +void kthread_use_mm(struct mm_struct *mm);
> +void kthread_unuse_mm(struct mm_struct *mm);
>  
>  struct cgroup_subsys_state;
>  
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index ce4610316377..316db17f6b4f 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -1208,18 +1208,18 @@ void kthread_destroy_worker(struct kthread_worker *worker)
>  }
>  EXPORT_SYMBOL(kthread_destroy_worker);
>  
> -/*
> - * use_mm
> - *	Makes the calling kernel thread take on the specified
> - *	mm context.
> - *	(Note: this routine is intended to be called only
> - *	from a kernel thread context)
> +/**
> + * kthread_use_mm - make the calling kthread operate on an address space
> + * @mm: address space to operate on
>   */
> -void use_mm(struct mm_struct *mm)
> +void kthread_use_mm(struct mm_struct *mm)
>  {
>  	struct mm_struct *active_mm;
>  	struct task_struct *tsk = current;
>  
> +	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
> +	WARN_ON_ONCE(tsk->mm);
> +
>  	task_lock(tsk);
>  	active_mm = tsk->active_mm;
>  	if (active_mm != mm) {
> @@ -1236,20 +1236,19 @@ void use_mm(struct mm_struct *mm)
>  	if (active_mm != mm)
>  		mmdrop(active_mm);
>  }
> -EXPORT_SYMBOL_GPL(use_mm);
> +EXPORT_SYMBOL_GPL(kthread_use_mm);
>  
> -/*
> - * unuse_mm
> - *	Reverses the effect of use_mm, i.e. releases the
> - *	specified mm context which was earlier taken on
> - *	by the calling kernel thread
> - *	(Note: this routine is intended to be called only
> - *	from a kernel thread context)
> +/**
> + * kthread_use_mm - reverse the effect of kthread_use_mm()
> + * @mm: address space to operate on
>   */
> -void unuse_mm(struct mm_struct *mm)
> +void kthread_unuse_mm(struct mm_struct *mm)
>  {
>  	struct task_struct *tsk = current;
>  
> +	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
> +	WARN_ON_ONCE(!tsk->mm);
> +
>  	task_lock(tsk);
>  	sync_mm_rss(mm);
>  	tsk->mm = NULL;
> @@ -1257,7 +1256,7 @@ void unuse_mm(struct mm_struct *mm)
>  	enter_lazy_tlb(mm, tsk);
>  	task_unlock(tsk);
>  }
> -EXPORT_SYMBOL_GPL(unuse_mm);
> +EXPORT_SYMBOL_GPL(kthread_unuse_mm);
>  
>  #ifdef CONFIG_BLK_CGROUP
>  /**
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index dfc357614e56..958d2972313f 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -126,7 +126,7 @@ static bool oom_cpuset_eligible(struct task_struct *tsk, struct oom_control *oc)
>  
>  /*
>   * The process p may have detached its own ->mm while exiting or through
> - * use_mm(), but one or more of its subthreads may still have a valid
> + * kthread_use_mm(), but one or more of its subthreads may still have a valid
>   * pointer.  Return p, or any of its subthreads with a valid ->mm, with
>   * task_lock() held.
>   */
> @@ -919,8 +919,8 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  			continue;
>  		}
>  		/*
> -		 * No use_mm() user needs to read from the userspace so we are
> -		 * ok to reap it.
> +		 * No kthead_use_mm() user needs to read from the userspace so
> +		 * we are ok to reap it.
>  		 */
>  		if (unlikely(p->flags & PF_KTHREAD))
>  			continue;
> diff --git a/mm/vmacache.c b/mm/vmacache.c
> index cdc32a3b02fa..ceedbab82106 100644
> --- a/mm/vmacache.c
> +++ b/mm/vmacache.c
> @@ -25,8 +25,8 @@
>   * task's vmacache pertains to a different mm (ie, its own).  There is
>   * nothing we can do here.
>   *
> - * Also handle the case where a kernel thread has adopted this mm via use_mm().
> - * That kernel thread's vmacache is not applicable to this mm.
> + * Also handle the case where a kernel thread has adopted this mm via
> + * kthread_use_mm(). That kernel thread's vmacache is not applicable to this mm.
>   */
>  static inline bool vmacache_valid_mm(struct mm_struct *mm)
>  {
