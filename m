Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104F93618FC
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 06:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238233AbhDPEqJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 00:46:09 -0400
Received: from mail-il1-f173.google.com ([209.85.166.173]:42755 "EHLO
        mail-il1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhDPEqI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 00:46:08 -0400
Received: by mail-il1-f173.google.com with SMTP id 6so22071536ilt.9
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 21:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZgNrbPB+QEUq5jEEl+jYLXTOt7AD2GG6F7AnkjqmgoE=;
        b=YNIsdtNmX/onUkENAMepufOBLVJurXMwTwvu49zECKara/sRdqzD5ZVUfvqVZvj9qM
         LZflZbjCUKkBMLS2eOBxwlRLg877R9JCdWwSDvNY+BdyUq107Con40JaYRCfM41+CnsB
         0h91SFI4s9/Da79TbMWtb98tm29FtPU+l5/w1w0Iap+bDSthcFd/JsTp/cVe9nElTN/A
         8GCDUm+bFRqdXCX/k4+nU4R5UjQEtBNxaT0/TSk+raogTrUI8CzLjt7WvLB0NIvOgpZR
         DmGYNtOD/2KBdgkfTGE0+KnlW8LeFihWCHdua3PPla9K0QNxGs/ACiVghmruqWCmrjRb
         j+hA==
X-Gm-Message-State: AOAM533CoxAKyELTM/bKALu2TMLC39FMu2r1vVlsG9RhG7I6WhFJcCk9
        Gl25zpIBi97z0CyC75cJzRw=
X-Google-Smtp-Source: ABdhPJyec/kSV99X/AuXmjwPXSleDoigg37o+MCue4g9FoiLSPxwfa8kQPipi2mvQdOX/Nz/qOHs1w==
X-Received: by 2002:a05:6e02:de6:: with SMTP id m6mr5610984ilj.81.1618548344341;
        Thu, 15 Apr 2021 21:45:44 -0700 (PDT)
Received: from google.com (243.199.238.35.bc.googleusercontent.com. [35.238.199.243])
        by smtp.gmail.com with ESMTPSA id a11sm2241279ilj.22.2021.04.15.21.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 21:45:43 -0700 (PDT)
Date:   Fri, 16 Apr 2021 04:45:42 +0000
From:   Dennis Zhou <dennis@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        Joakim Hassila <joj@mac.com>
Subject: Re: [PATCH 1/2] percpu_ref: add percpu_ref_atomic_count()
Message-ID: <YHkWdgLKBrH51GA7@google.com>
References: <cover.1618532491.git.asml.silence@gmail.com>
 <d17d951b120bb2d65870013bfdc7495a92c6fb82.1618532491.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d17d951b120bb2d65870013bfdc7495a92c6fb82.1618532491.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

On Fri, Apr 16, 2021 at 01:22:51AM +0100, Pavel Begunkov wrote:
> Add percpu_ref_atomic_count(), which returns number of references of a
> percpu_ref switched prior into atomic mode, so the caller is responsible
> to make sure it's in the right mode.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/percpu-refcount.h |  1 +
>  lib/percpu-refcount.c           | 26 ++++++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> index 16c35a728b4c..0ff40e79efa2 100644
> --- a/include/linux/percpu-refcount.h
> +++ b/include/linux/percpu-refcount.h
> @@ -131,6 +131,7 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
>  void percpu_ref_resurrect(struct percpu_ref *ref);
>  void percpu_ref_reinit(struct percpu_ref *ref);
>  bool percpu_ref_is_zero(struct percpu_ref *ref);
> +unsigned long percpu_ref_atomic_count(struct percpu_ref *ref);
>  
>  /**
>   * percpu_ref_kill - drop the initial ref
> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index a1071cdefb5a..56286995e2b8 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -425,6 +425,32 @@ bool percpu_ref_is_zero(struct percpu_ref *ref)
>  }
>  EXPORT_SYMBOL_GPL(percpu_ref_is_zero);
>  
> +/**
> + * percpu_ref_atomic_count - returns number of left references
> + * @ref: percpu_ref to test
> + *
> + * This function is safe to call as long as @ref is switch into atomic mode,
> + * and is between init and exit.
> + */
> +unsigned long percpu_ref_atomic_count(struct percpu_ref *ref)
> +{
> +	unsigned long __percpu *percpu_count;
> +	unsigned long count, flags;
> +
> +	if (WARN_ON_ONCE(__ref_is_percpu(ref, &percpu_count)))
> +		return -1UL;
> +
> +	/* protect us from being destroyed */
> +	spin_lock_irqsave(&percpu_ref_switch_lock, flags);
> +	if (ref->data)
> +		count = atomic_long_read(&ref->data->count);
> +	else
> +		count = ref->percpu_count_ptr >> __PERCPU_REF_FLAG_BITS;

Sorry I missed Jens' patch before and also the update to percpu_ref.
However, I feel like I'm missing something. This isn't entirely related
to your patch, but I'm not following why percpu_count_ptr stores the
excess count of an exited percpu_ref and doesn't warn when it's not
zero. It seems like this should be an error if it's not 0?

Granted we have made some contract with the user to do the right thing,
but say someone does mess up, we don't indicate to them hey this ref is
actually dead and if they're waiting for it to go to 0, it never will.

> +	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
> +
> +	return count;
> +}
> +
>  /**
>   * percpu_ref_reinit - re-initialize a percpu refcount
>   * @ref: perpcu_ref to re-initialize
> -- 
> 2.24.0
> 

Thanks,
Dennis
