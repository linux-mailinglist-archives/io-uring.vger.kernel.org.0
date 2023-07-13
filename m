Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B96752530
	for <lists+io-uring@lfdr.de>; Thu, 13 Jul 2023 16:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjGMOdM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jul 2023 10:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjGMOdL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jul 2023 10:33:11 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C376926B8
        for <io-uring@vger.kernel.org>; Thu, 13 Jul 2023 07:33:07 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53b9eb7bda0so410481a12.0
        for <io-uring@vger.kernel.org>; Thu, 13 Jul 2023 07:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689258787; x=1691850787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fr2vYa/Ch6xYV487nmzxcm8iM/FlpnkWVHQ5jynQTbg=;
        b=jacaK9M2p8ae07DYtf3WTwW4sJ88AeR0PMoTM/K8Zom80G9CNsRED8/7OkNACpL4FI
         vSrK+poAQrpW9b9XXAEX3N+/eJqGG0fl2uSilp/V2zhMmynFGmkNp19rQMAPCUIgro+L
         8wZFnIyWuBTpd6inSk0jhwWPq/qOKDhiCmrdy2nICENUOLQPMx4zm5vkc1J+N+jf8F/9
         NWijWeXBKP6nhRWfAZooF9dECtwpwP1B06LROVi+ZRGQWEPDlF+8FcWtS7IpVg38LWBC
         sabPszkfHQCdZSa4qO28HKir4zE3m+cUi5LtAFjCZb9xEKl25slyjVF3CoaXZrvttifT
         RnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689258787; x=1691850787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fr2vYa/Ch6xYV487nmzxcm8iM/FlpnkWVHQ5jynQTbg=;
        b=KDFb5CFjFNTnYJmpeGRBQwRDSsDDT8wKTgZDx3R2fLEzXJ+lv9p+WiDBUxr52RYDTc
         95WXCDcdeXOicOaVBjwW52b9Z0yjw+WbLoLkV/mgUuBNgzO62VLzLggbhhPU66QswZm1
         hUCg9LW+IDv7LNa7gMux0gz+6Tauyz33TqakzxuPoW4YtnWyaWrqOHEmD2lLRAEgjbbQ
         EislXtDtM2dP5LiBdmcdsLKCVcl0nSok/rzQmLm1MOlWeWXDHSLA98KbuJdiCuMTTLDi
         QgA5Y1kVIY61jjbPeB0PsJiLkpNVwzk7lzrEA3wX2iqPpkimmGFaQvmKMlaKFq4GKcYY
         zTng==
X-Gm-Message-State: ABy/qLYrgHdefy8/VHaTUvM7Yk64EGRmsU8hd/dbfdM4e5xQ9qEKlCIZ
        MbVMByCr91gQmBauhFvY8mujiFZzpTc=
X-Google-Smtp-Source: APBJJlFAAhWItEMB5PDxlVd4/XD0kDAeGPn5ZZPTnMU3ojU8FDM9Oji9AhkfLIh7rpZuc1o0H3AhYJQLwhY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b282:b0:1ba:1704:89d1 with SMTP id
 u2-20020a170902b28200b001ba170489d1mr5846plr.10.1689258786828; Thu, 13 Jul
 2023 07:33:06 -0700 (PDT)
Date:   Thu, 13 Jul 2023 07:33:05 -0700
In-Reply-To: <20230713-vfs-eventfd-signal-v1-2-7fda6c5d212b@kernel.org>
Mime-Version: 1.0
References: <20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org> <20230713-vfs-eventfd-signal-v1-2-7fda6c5d212b@kernel.org>
Message-ID: <ZLAK+FA3qgbHW0YK@google.com>
Subject: Re: [PATCH 2/2] eventfd: simplify eventfd_signal_mask()
From:   Sean Christopherson <seanjc@google.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>, Oded Gabbay <ogabbay@kernel.org>,
        Wu Hao <hao.wu@intel.com>, Tom Rix <trix@redhat.com>,
        Moritz Fischer <mdf@kernel.org>, Xu Yilun <yilun.xu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Fei Li <fei1.li@intel.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <muchun.song@linux.dev>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fpga@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-aio@kvack.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 13, 2023, Christian Brauner wrote:
> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index dc9e01053235..077be5da72bd 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -43,9 +43,10 @@ struct eventfd_ctx {
>  	int id;
>  };
>  
> -__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
> +bool eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask)
>  {
>  	unsigned long flags;
> +	__u64 n = 1;
>  
>  	/*
>  	 * Deadlock or stack overflow issues can happen if we recurse here
> @@ -68,7 +69,7 @@ __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
>  	current->in_eventfd = 0;
>  	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
>  
> -	return n;
> +	return n == 1;
>  }

...

> @@ -58,13 +58,12 @@ static inline struct eventfd_ctx *eventfd_ctx_fdget(int fd)
>  	return ERR_PTR(-ENOSYS);
>  }
>  
> -static inline int eventfd_signal(struct eventfd_ctx *ctx)
> +static inline bool eventfd_signal(struct eventfd_ctx *ctx)
>  {
>  	return -ENOSYS;
>  }
>  
> -static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n,
> -				      unsigned mask)
> +static inline bool eventfd_signal_mask(struct eventfd_ctx *ctx, unsigned mask)
>  {
>  	return -ENOSYS;

This will morph to "true" for what should be an error case.  One option would be
to have eventfd_signal_mask() return 0/-errno instead of the count, but looking
at all the callers, nothing ever actually consumes the result.

KVMGT morphs failure into -EFAULT

	if (vgpu->msi_trigger && eventfd_signal(vgpu->msi_trigger, 1) != 1)
		return -EFAULT;

but the only caller of that user ignores the return value.

	if (vgpu_vreg(vgpu, i915_mmio_reg_offset(GEN8_MASTER_IRQ))
			& ~GEN8_MASTER_IRQ_CONTROL)
		inject_virtual_interrupt(vgpu);

The sample driver in samples/vfio-mdev/mtty.c uses a similar pattern: prints an
error but otherwise ignores the result.

So why not return nothing?  That will simplify eventfd_signal_mask() a wee bit
more, and eliminate that bizarre return value confusion for the ugly stubs, e.g.

void eventfd_signal_mask(struct eventfd_ctx *ctx, unsigned mask)
{
	unsigned long flags;

	/*
	 * Deadlock or stack overflow issues can happen if we recurse here
	 * through waitqueue wakeup handlers. If the caller users potentially
	 * nested waitqueues with custom wakeup handlers, then it should
	 * check eventfd_signal_allowed() before calling this function. If
	 * it returns false, the eventfd_signal() call should be deferred to a
	 * safe context.
	 */
	if (WARN_ON_ONCE(current->in_eventfd))
		return;

	spin_lock_irqsave(&ctx->wqh.lock, flags);
	current->in_eventfd = 1;
	if (ctx->count < ULLONG_MAX)
		ctx->count++;
	if (waitqueue_active(&ctx->wqh))
		wake_up_locked_poll(&ctx->wqh, EPOLLIN | mask);
	current->in_eventfd = 0;
	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
}

You could even go further and unify the real and stub versions of eventfd_signal().
