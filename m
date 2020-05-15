Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748AE1D56CE
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 18:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgEOQxx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 12:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726206AbgEOQxx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 12:53:53 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7C9C061A0C
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 09:53:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d184so1210770pfd.4
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 09:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KoFKGhu83L+7/qN76fkaMH9mlEd9r+N6TZjBWHMy1UM=;
        b=b2p49pWsLqS+4mzr3I7+6e7I7PVvCtUPFUaL+1l3jE8/TtooZ2ARZ3PEPzzCqmUsxj
         7xMhWV2vHH8Q+qsj2SUVIWXWPNDUH1s58cVOEOmm2AquJPAVr58oP7Zvh9NTxVfDsqxj
         zIyMjy9egFQz4OmoL84Au9juviUqffdh5EHwN3w+TWMOeeSpqsybqHLJ67y4Eus/xwcK
         xObEjgcuDzZs8E0WWG/kAlswcVqB3vS8y/nxUMDVovPx8s69tHJhWCe3hIe2QUd59yqU
         0jrETiR41amAqymraKQqVxOfWSHO3fjIwZR011oX1RefYL6ZH2ZaxbSb/zSb1ja8kiR3
         UpWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KoFKGhu83L+7/qN76fkaMH9mlEd9r+N6TZjBWHMy1UM=;
        b=ZeIOCgrN9y7COl5pyr7T0UEigb5AgAspoKU7Zu6+yhXv6XCG13mlx9DWKZUP1ILzFK
         um70mfiQFEuQ+Ba8Ls40ypBttmzS4nAx1cBlIUQTcWcTiVENGgvK2+QfhKmxUTmw5s7F
         O2tUNXms0/jiZRC1F1ZEBHhOZQLjxqmhaU7Qwj8qfNc87KLx95nO/5LcG/IIwyOdXKXI
         i7Mcf15fOYAMg+5vhTwa/fGJbZMxndBcei6O69FJyge1n64EYl+ApFkl5aXiAb5BiyFL
         B+gU74btxTTui7Hq4vL5lGI70IPmmU1JQZE10y7L+baCjPElLZ8B633CY16kLcjW/QEI
         5Gcg==
X-Gm-Message-State: AOAM531AgCJ0DMy+ywZsMggEbWF80cLeRct846NKOTuZXLkbS++I1GOw
        aDevKyf1qos0LpalCJD5fV8Mp0/5UTM=
X-Google-Smtp-Source: ABdhPJxoIPHHVW67XwX2tFsYlhQADXdHWdEge71uYdu9niRGIui9mtD2VaC+2m2ItZV2uKrhfZ3J6g==
X-Received: by 2002:aa7:8425:: with SMTP id q5mr621371pfn.98.1589561632189;
        Fri, 15 May 2020 09:53:52 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:aca2:b1c9:3206:e390? ([2605:e000:100e:8c61:aca2:b1c9:3206:e390])
        by smtp.gmail.com with ESMTPSA id n2sm1678745pfe.161.2020.05.15.09.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 09:53:51 -0700 (PDT)
Subject: Re: [PATCH liburing 3/5] Add helpers to set and get eventfd
 notification status
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200515164331.236868-1-sgarzare@redhat.com>
 <20200515164331.236868-4-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5bee86d5-f8bf-5b61-dd26-5e7d0448a217@kernel.dk>
Date:   Fri, 15 May 2020 10:53:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200515164331.236868-4-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/15/20 10:43 AM, Stefano Garzarella wrote:
> This patch adds the new IORING_CQ_EVENTFD_DISABLED flag. It can be
> used to disable/enable notifications from the kernel when a
> request is completed and queued to the CQ ring.
> 
> We also add two helpers function to check if the notifications are
> enabled and to enable/disable them.
> 
> If the kernel doesn't provide CQ ring flags, the notifications are
> always enabled if an eventfd is registered.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  src/include/liburing.h          | 30 ++++++++++++++++++++++++++++++
>  src/include/liburing/io_uring.h |  7 +++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index ea596f6..fe03547 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -9,7 +9,9 @@ extern "C" {
>  #include <sys/socket.h>
>  #include <sys/uio.h>
>  #include <sys/stat.h>
> +#include <errno.h>
>  #include <signal.h>
> +#include <stdbool.h>
>  #include <inttypes.h>
>  #include <time.h>
>  #include "liburing/compat.h"
> @@ -445,6 +447,34 @@ static inline unsigned io_uring_cq_ready(struct io_uring *ring)
>  	return io_uring_smp_load_acquire(ring->cq.ktail) - *ring->cq.khead;
>  }
>  
> +static inline int io_uring_cq_eventfd_enable(struct io_uring *ring,
> +					     bool enabled)
> +{
> +	uint32_t flags;
> +
> +	if (!ring->cq.kflags)
> +		return -ENOTSUP;
> +
> +	flags = *ring->cq.kflags;
> +
> +	if (enabled)
> +		flags &= ~IORING_CQ_EVENTFD_DISABLED;
> +	else
> +		flags |= IORING_CQ_EVENTFD_DISABLED;
> +
> +	IO_URING_WRITE_ONCE(*ring->cq.kflags, flags);
> +
> +	return 0;
> +}

The -ENOTSUP seems a bit odd, I wonder if we should even flag that as an
error.

The function should probably also be io_uring_cq_eventfd_toggle() or
something like that, as it does both enable and disable.

Either that, or have two functions, and enable and disable.

The bigger question is probably how to handle kernels that don't
have this feature. It'll succeed, but we'll still post events. Maybe
the kernel side should have a feature flag that we can test?


-- 
Jens Axboe

