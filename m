Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70EB19F9D4
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2020 18:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgDFQLH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 12:11:07 -0400
Received: from mail-eopbgr680050.outbound.protection.outlook.com ([40.107.68.50]:7030
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728707AbgDFQLG (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 6 Apr 2020 12:11:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auCv+cIZq6k3EkxYOTKDWafLqE9a+qKb9YNt99mZsYhYTiRuv9Lr86kmWc3nnTaKaBrhDcwkZPrfC1olf8ECIZyun1WsOVM3RDmrn+XhMINp+g4Duontqc21aAfzJ9UYmYo7t/YEEyfMyHW9+LynqfGQnCtTtVfmC8PRtMW2377Q36UPCMB2ae0ZAguedFQxEAilVzO1acoznJ9wdIRLNgPm5wqY9r9acn5e3jw+nlEMIOmqocdcJf/1Od2o5wAkkABxPEAbe1AZxb2aW0WT+b8M43pw7pI21MUO5f/h5D/Wsjcf0ibSt3cyEtBgEntbpDLU14zty7infk9DsYcIpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARHG6MhaYb6uzELiwv1wy5e8PYJfBq2f2KwOW2yWW2Y=;
 b=bx5dpx7MmMtPrwMbXQboh3zG7gSwkPf+uf+WZ8wVGnvQCCuJjuUoF2rdq6oX+ZmdSGOjOD8nLx5e8l/3k7n18yOtuJ2DZy55XhrGUP7e2HxfbXCEX8ghWlpbF771vTIV0Y3joIXTJo1Rt6dwXDeaUzcxcqD2Y00AlGizYOqmNh+fYx1rVctNunBhXOZRY9NGpyvUKQaejFFH/lNutIpRhyn4ROyvUkO7jUwfR4tN4RDqXlsVaJqZ54FTM/LyqjCeAZrzyIroE3C6DYNd6cxEgeiQDOpdDHJ5SBQZE1UPmDKaqVT6RfQLPYuj/PToxn1iBWmu6vZBv3IEh7W7x7IxsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARHG6MhaYb6uzELiwv1wy5e8PYJfBq2f2KwOW2yWW2Y=;
 b=rtf2VHYxUH8bE+1cAfqpZ7naj1xRGejDy+Ds4WNnZaSVwqpXtZMdtGqwQDJ/u9kfjoMTt7Mml0yE7l+AV2s6kObIZPDhcOsGjvx4DUMyNrT+kHqzw+aOxi8TZEzWIu9RlpHZF1pywXL5xSlNE8SPh6HP0R1OHFffma7ifbwdRq8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Felix.Kuehling@amd.com; 
Received: from SN1PR12MB2414.namprd12.prod.outlook.com (2603:10b6:802:2e::31)
 by SN1PR12MB2575.namprd12.prod.outlook.com (2603:10b6:802:25::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Mon, 6 Apr
 2020 16:09:26 +0000
Received: from SN1PR12MB2414.namprd12.prod.outlook.com
 ([fe80::38ef:1510:9525:f806]) by SN1PR12MB2414.namprd12.prod.outlook.com
 ([fe80::38ef:1510:9525:f806%7]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 16:09:26 +0000
Subject: Re: [PATCH 4/6] kernel: move use_mm/unuse_mm to kthread.c
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
 <20200404094101.672954-5-hch@lst.de>
From:   Felix Kuehling <felix.kuehling@amd.com>
Message-ID: <86ab9f2f-4081-ebd6-790d-9b334db998c1@amd.com>
Date:   Mon, 6 Apr 2020 12:09:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200404094101.672954-5-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: YQBPR0101CA0043.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::20) To SN1PR12MB2414.namprd12.prod.outlook.com
 (2603:10b6:802:2e::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.100] (142.116.63.128) by YQBPR0101CA0043.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Mon, 6 Apr 2020 16:09:24 +0000
X-Originating-IP: [142.116.63.128]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5fb951dd-8f84-4d1a-87f8-08d7da44e0a5
X-MS-TrafficTypeDiagnostic: SN1PR12MB2575:|SN1PR12MB2575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2575845BB857C9C4DBD9377392C20@SN1PR12MB2575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2414.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(16576012)(54906003)(110136005)(86362001)(31696002)(4326008)(8676002)(52116002)(81156014)(30864003)(81166006)(8936002)(6486002)(44832011)(2616005)(66476007)(316002)(478600001)(956004)(2906002)(36756003)(66556008)(31686004)(5660300002)(7416002)(186003)(16526019)(26005)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L2x+HwF0/Us/K1rnBuIZqefqX2sfAhTTJFHnx6Rs0ABtNhc0vKwmf+EpwRuctRF1NaNYBWZdJjl/Vnqk5mLcTRY7/gWgaxOGUoR/zvUAIeJjMsQbUeM+yJa5+lbz+IJ9O3xIEISrf5OSwrLjrPLFC19pNika9SqbZ+o0xt27UxlRld7X6hl68CHFptb1pMDBKtPWJVfUjovEOjW+4Tjoo6OsSciRWtF58+P0FEYCFZiGLpL33uFCydaQK6PPY8mLwz+xAc/Hpq+ySDWtYpO9BKZabmFqN6ycj0BzNvj39BC431nEkHBgXZyBuEaGCZyczeublZtwqayx0WQokW2ItEpy8bogAStYAjuq6bt+iqTGJfy4KJ5s4fsi0K7C2Pi72tWwTfZO5WaERAJNk+xD3JoTvisBd+kTp/nsUkd3NAZlDtvvnLW3UQgRJp6vMAvW
X-MS-Exchange-AntiSpam-MessageData: 2Wzqkgs4CauDpddiQPvt7h7UU1WILTmT61mxeDGEDNK1DCfOnNMjo/4+NoC9MO+ICIFgfnpavRHsDIuDawqyITxcjTqXElRXcs7Ur9NTh2lSGuaHR2zjCX9bLkr8Ekav/DHrJBFmSDNZOvna/T3anQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb951dd-8f84-4d1a-87f8-08d7da44e0a5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 16:09:26.0428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GjScqc1PJNAKsTkMraH8OqxF1ZWhCMngdr6OmZKilOV2JHlM15NzxGZ0Ll4+3akfOvnpuk38ycGtitf8QUM/SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2575
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 2020-04-04 um 5:40 a.m. schrieb Christoph Hellwig:
> These helpers are only for use with kernel threads, and I will tie them
> more into the kthread infrastructure going forward.  Also move the
> prototypes to kthread.h - mmu_context.h was a little weird to start with
> as it otherwise contains very low-level MM bits.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>

Thanks for cleaning up the unnecessary includes in amdgpu.

Regards,
  Felix


> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  1 +
>  .../drm/amd/amdgpu/amdgpu_amdkfd_arcturus.c   |  1 -
>  .../drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c    |  1 -
>  .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c |  2 -
>  .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c |  2 -
>  .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c |  2 -
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  2 +-
>  drivers/usb/gadget/function/f_fs.c            |  2 +-
>  drivers/usb/gadget/legacy/inode.c             |  2 +-
>  drivers/vhost/vhost.c                         |  1 -
>  fs/aio.c                                      |  1 -
>  fs/io-wq.c                                    |  1 -
>  fs/io_uring.c                                 |  1 -
>  include/linux/kthread.h                       |  5 ++
>  include/linux/mmu_context.h                   |  5 --
>  kernel/kthread.c                              | 56 ++++++++++++++++
>  mm/Makefile                                   |  2 +-
>  mm/mmu_context.c                              | 64 -------------------
>  18 files changed, 66 insertions(+), 85 deletions(-)
>  delete mode 100644 mm/mmu_context.c
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
> index 4db143c19dcc..bce5e93fefc8 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
> @@ -27,6 +27,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/mm.h>
> +#include <linux/kthread.h>
>  #include <linux/workqueue.h>
>  #include <kgd_kfd_interface.h>
>  #include <drm/ttm/ttm_execbuf_util.h>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_arcturus.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_arcturus.c
> index 6529caca88fe..35d4a5ab0228 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_arcturus.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_arcturus.c
> @@ -22,7 +22,6 @@
>  #include <linux/module.h>
>  #include <linux/fdtable.h>
>  #include <linux/uaccess.h>
> -#include <linux/mmu_context.h>
>  #include <linux/firmware.h>
>  #include "amdgpu.h"
>  #include "amdgpu_amdkfd.h"
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c
> index 4ec6d0c03201..b1655054b919 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c
> @@ -19,7 +19,6 @@
>   * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>   * OTHER DEALINGS IN THE SOFTWARE.
>   */
> -#include <linux/mmu_context.h>
>  #include "amdgpu.h"
>  #include "amdgpu_amdkfd.h"
>  #include "gc/gc_10_1_0_offset.h"
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c
> index 0b7e78748540..7d01420c0c85 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c
> @@ -20,8 +20,6 @@
>   * OTHER DEALINGS IN THE SOFTWARE.
>   */
>  
> -#include <linux/mmu_context.h>
> -
>  #include "amdgpu.h"
>  #include "amdgpu_amdkfd.h"
>  #include "cikd.h"
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c
> index ccd635b812b5..635cd1a26bed 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c
> @@ -20,8 +20,6 @@
>   * OTHER DEALINGS IN THE SOFTWARE.
>   */
>  
> -#include <linux/mmu_context.h>
> -
>  #include "amdgpu.h"
>  #include "amdgpu_amdkfd.h"
>  #include "gfx_v8_0.h"
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
> index df841c2ac5e7..c7fd0c47b254 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
> @@ -19,8 +19,6 @@
>   * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>   * OTHER DEALINGS IN THE SOFTWARE.
>   */
> -#include <linux/mmu_context.h>
> -
>  #include "amdgpu.h"
>  #include "amdgpu_amdkfd.h"
>  #include "gc/gc_9_0_offset.h"
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 5848400620b4..dee01c371bf5 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -31,7 +31,7 @@
>  #include <linux/init.h>
>  #include <linux/device.h>
>  #include <linux/mm.h>
> -#include <linux/mmu_context.h>
> +#include <linux/kthread.h>
>  #include <linux/sched/mm.h>
>  #include <linux/types.h>
>  #include <linux/list.h>
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index c81023b195c3..c57b1b2507c6 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -32,7 +32,7 @@
>  #include <linux/usb/functionfs.h>
>  
>  #include <linux/aio.h>
> -#include <linux/mmu_context.h>
> +#include <linux/kthread.h>
>  #include <linux/poll.h>
>  #include <linux/eventfd.h>
>  
> diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
> index aa0de9e35afa..8b5233888bf8 100644
> --- a/drivers/usb/gadget/legacy/inode.c
> +++ b/drivers/usb/gadget/legacy/inode.c
> @@ -21,7 +21,7 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/poll.h>
> -#include <linux/mmu_context.h>
> +#include <linux/kthread.h>
>  #include <linux/aio.h>
>  #include <linux/uio.h>
>  #include <linux/refcount.h>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index f44340b41494..4e9ce54869af 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -14,7 +14,6 @@
>  #include <linux/vhost.h>
>  #include <linux/uio.h>
>  #include <linux/mm.h>
> -#include <linux/mmu_context.h>
>  #include <linux/miscdevice.h>
>  #include <linux/mutex.h>
>  #include <linux/poll.h>
> diff --git a/fs/aio.c b/fs/aio.c
> index 5f3d3d814928..328829f0343b 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -27,7 +27,6 @@
>  #include <linux/file.h>
>  #include <linux/mm.h>
>  #include <linux/mman.h>
> -#include <linux/mmu_context.h>
>  #include <linux/percpu.h>
>  #include <linux/slab.h>
>  #include <linux/timer.h>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index cc5cf2209fb0..c49c2bdbafb5 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -10,7 +10,6 @@
>  #include <linux/errno.h>
>  #include <linux/sched/signal.h>
>  #include <linux/mm.h>
> -#include <linux/mmu_context.h>
>  #include <linux/sched/mm.h>
>  #include <linux/percpu.h>
>  #include <linux/slab.h>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 358f97be9c7b..27a4ecb724ca 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -55,7 +55,6 @@
>  #include <linux/fdtable.h>
>  #include <linux/mm.h>
>  #include <linux/mman.h>
> -#include <linux/mmu_context.h>
>  #include <linux/percpu.h>
>  #include <linux/slab.h>
>  #include <linux/kthread.h>
> diff --git a/include/linux/kthread.h b/include/linux/kthread.h
> index 8bbcaad7ef0f..c2d40c9672d6 100644
> --- a/include/linux/kthread.h
> +++ b/include/linux/kthread.h
> @@ -5,6 +5,8 @@
>  #include <linux/err.h>
>  #include <linux/sched.h>
>  
> +struct mm_struct;
> +
>  __printf(4, 5)
>  struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
>  					   void *data,
> @@ -198,6 +200,9 @@ bool kthread_cancel_delayed_work_sync(struct kthread_delayed_work *work);
>  
>  void kthread_destroy_worker(struct kthread_worker *worker);
>  
> +void use_mm(struct mm_struct *mm);
> +void unuse_mm(struct mm_struct *mm);
> +
>  struct cgroup_subsys_state;
>  
>  #ifdef CONFIG_BLK_CGROUP
> diff --git a/include/linux/mmu_context.h b/include/linux/mmu_context.h
> index d9a543a9e1cc..c51a84132d7c 100644
> --- a/include/linux/mmu_context.h
> +++ b/include/linux/mmu_context.h
> @@ -4,11 +4,6 @@
>  
>  #include <asm/mmu_context.h>
>  
> -struct mm_struct;
> -
> -void use_mm(struct mm_struct *mm);
> -void unuse_mm(struct mm_struct *mm);
> -
>  /* Architectures that care about IRQ state in switch_mm can override this. */
>  #ifndef switch_mm_irqs_off
>  # define switch_mm_irqs_off switch_mm
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index bfbfa481be3a..ce4610316377 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -1,13 +1,17 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /* Kernel thread helper functions.
>   *   Copyright (C) 2004 IBM Corporation, Rusty Russell.
> + *   Copyright (C) 2009 Red Hat, Inc.
>   *
>   * Creation is done via kthreadd, so that we get a clean environment
>   * even if we're invoked from userspace (think modprobe, hotplug cpu,
>   * etc.).
>   */
>  #include <uapi/linux/sched/types.h>
> +#include <linux/mm.h>
> +#include <linux/mmu_context.h>
>  #include <linux/sched.h>
> +#include <linux/sched/mm.h>
>  #include <linux/sched/task.h>
>  #include <linux/kthread.h>
>  #include <linux/completion.h>
> @@ -25,6 +29,7 @@
>  #include <linux/numa.h>
>  #include <trace/events/sched.h>
>  
> +
>  static DEFINE_SPINLOCK(kthread_create_lock);
>  static LIST_HEAD(kthread_create_list);
>  struct task_struct *kthreadd_task;
> @@ -1203,6 +1208,57 @@ void kthread_destroy_worker(struct kthread_worker *worker)
>  }
>  EXPORT_SYMBOL(kthread_destroy_worker);
>  
> +/*
> + * use_mm
> + *	Makes the calling kernel thread take on the specified
> + *	mm context.
> + *	(Note: this routine is intended to be called only
> + *	from a kernel thread context)
> + */
> +void use_mm(struct mm_struct *mm)
> +{
> +	struct mm_struct *active_mm;
> +	struct task_struct *tsk = current;
> +
> +	task_lock(tsk);
> +	active_mm = tsk->active_mm;
> +	if (active_mm != mm) {
> +		mmgrab(mm);
> +		tsk->active_mm = mm;
> +	}
> +	tsk->mm = mm;
> +	switch_mm(active_mm, mm, tsk);
> +	task_unlock(tsk);
> +#ifdef finish_arch_post_lock_switch
> +	finish_arch_post_lock_switch();
> +#endif
> +
> +	if (active_mm != mm)
> +		mmdrop(active_mm);
> +}
> +EXPORT_SYMBOL_GPL(use_mm);
> +
> +/*
> + * unuse_mm
> + *	Reverses the effect of use_mm, i.e. releases the
> + *	specified mm context which was earlier taken on
> + *	by the calling kernel thread
> + *	(Note: this routine is intended to be called only
> + *	from a kernel thread context)
> + */
> +void unuse_mm(struct mm_struct *mm)
> +{
> +	struct task_struct *tsk = current;
> +
> +	task_lock(tsk);
> +	sync_mm_rss(mm);
> +	tsk->mm = NULL;
> +	/* active_mm is still 'mm' */
> +	enter_lazy_tlb(mm, tsk);
> +	task_unlock(tsk);
> +}
> +EXPORT_SYMBOL_GPL(unuse_mm);
> +
>  #ifdef CONFIG_BLK_CGROUP
>  /**
>   * kthread_associate_blkcg - associate blkcg to current kthread
> diff --git a/mm/Makefile b/mm/Makefile
> index dbc8346d16ca..0af4ee81aed2 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -41,7 +41,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
>  			   maccess.o page-writeback.o \
>  			   readahead.o swap.o truncate.o vmscan.o shmem.o \
>  			   util.o mmzone.o vmstat.o backing-dev.o \
> -			   mm_init.o mmu_context.o percpu.o slab_common.o \
> +			   mm_init.o percpu.o slab_common.o \
>  			   compaction.o vmacache.o \
>  			   interval_tree.o list_lru.o workingset.o \
>  			   debug.o gup.o $(mmu-y)
> diff --git a/mm/mmu_context.c b/mm/mmu_context.c
> deleted file mode 100644
> index 3e612ae748e9..000000000000
> --- a/mm/mmu_context.c
> +++ /dev/null
> @@ -1,64 +0,0 @@
> -/* Copyright (C) 2009 Red Hat, Inc.
> - *
> - * See ../COPYING for licensing terms.
> - */
> -
> -#include <linux/mm.h>
> -#include <linux/sched.h>
> -#include <linux/sched/mm.h>
> -#include <linux/sched/task.h>
> -#include <linux/mmu_context.h>
> -#include <linux/export.h>
> -
> -#include <asm/mmu_context.h>
> -
> -/*
> - * use_mm
> - *	Makes the calling kernel thread take on the specified
> - *	mm context.
> - *	(Note: this routine is intended to be called only
> - *	from a kernel thread context)
> - */
> -void use_mm(struct mm_struct *mm)
> -{
> -	struct mm_struct *active_mm;
> -	struct task_struct *tsk = current;
> -
> -	task_lock(tsk);
> -	active_mm = tsk->active_mm;
> -	if (active_mm != mm) {
> -		mmgrab(mm);
> -		tsk->active_mm = mm;
> -	}
> -	tsk->mm = mm;
> -	switch_mm(active_mm, mm, tsk);
> -	task_unlock(tsk);
> -#ifdef finish_arch_post_lock_switch
> -	finish_arch_post_lock_switch();
> -#endif
> -
> -	if (active_mm != mm)
> -		mmdrop(active_mm);
> -}
> -EXPORT_SYMBOL_GPL(use_mm);
> -
> -/*
> - * unuse_mm
> - *	Reverses the effect of use_mm, i.e. releases the
> - *	specified mm context which was earlier taken on
> - *	by the calling kernel thread
> - *	(Note: this routine is intended to be called only
> - *	from a kernel thread context)
> - */
> -void unuse_mm(struct mm_struct *mm)
> -{
> -	struct task_struct *tsk = current;
> -
> -	task_lock(tsk);
> -	sync_mm_rss(mm);
> -	tsk->mm = NULL;
> -	/* active_mm is still 'mm' */
> -	enter_lazy_tlb(mm, tsk);
> -	task_unlock(tsk);
> -}
> -EXPORT_SYMBOL_GPL(unuse_mm);
