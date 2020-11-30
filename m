Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E741E2C8C73
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 19:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388031AbgK3SQ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 13:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388030AbgK3SQ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 13:16:29 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A004C0613CF
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 10:15:43 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id x15so6939769pll.2
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 10:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fD1rN/XjLOAqcr1j+HBugd0cvfsGB1FFbRM0KeuV8yI=;
        b=XEMAgWIOxF5koHgIjg+jLxl7xFal30ywx/qP+PUa1zg6gkxU0fN8WsGxDEH1SkJSk0
         Ce3X7zsAR12qh6wSEfe6vWTkyXUk6tMHvbppl1S0SBXR0d9V/IEHUCPkGpE7zUSUAw+p
         L/VK4fGkzyK1QS2ykc+0/caXmvHye+znRYAfaMUzFkMQinK/p9Sp9jV/kY2mDGhe3qJt
         KYeMpGFi6JaOo+ZSwOR5zPRMk9sU3ez5FdinvAvpXlA+0L+IxwQHDsiPxvxLVLqDxuG2
         mkRDUtq2Ygw2ZuACKCt/uG3B9BP3mkDjEkepotIiSr9sK67+vKKAykzhI+TxH6Le5+RL
         gs6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fD1rN/XjLOAqcr1j+HBugd0cvfsGB1FFbRM0KeuV8yI=;
        b=uF+p/BL+Xg0eA+ToWsJPzrTr4f3bosqfI1qf5FSYTOp8DWsDvrY28/hGiKUy2DRZQe
         pqHvHx7nGwYaA1QqOb/mUQfpg/ytQcUlaFOdIgLklsdzwv+pgqJSKFdOopUbTGMT1l3w
         Vi8UVGLbfj1qnJDo3KwabGByrFzMeRaZm/iH0SmrGzFN2fXASGRhD6nvhohDx/hU+AHG
         yRCs86YvVP5Xg8bTLICN/UUA4+9dy/ht56Fhu8ks5KyjNM+3iU/AKZ6fRD+Oef6mQoMa
         bz6nibqY2q7FO1bmkwGmQxWscRL/nnkw5nDPpvSOHZ1AiGfceMoUT18n5HKLcCJHowBe
         xK0g==
X-Gm-Message-State: AOAM532aM9p5DSU0zmMLxBoaOaBRqxTGv8Bf+pl+oAMRAbZJYNAPJAQg
        c09WOVbPbPBP+RaOZUIQuERnz7NZLIsE0Q==
X-Google-Smtp-Source: ABdhPJw3weMr+3rGCatNQyJ9ITVwaTzfaU5+AYRYcL17hz7Vd93y9uaTqp/ol+efkjb9LGCe+Ya6bw==
X-Received: by 2002:a17:902:8490:b029:d6:d165:fde with SMTP id c16-20020a1709028490b02900d6d1650fdemr19648136plo.73.1606760142504;
        Mon, 30 Nov 2020 10:15:42 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i11sm17121433pfq.156.2020.11.30.10.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 10:15:41 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: add timeout update
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1606669225.git.asml.silence@gmail.com>
 <eb04a3d3154dce299c91d12a315a2335603c508a.1606669225.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a020eb4a-41a7-cc06-1699-d6ff77e28c76@kernel.dk>
Date:   Mon, 30 Nov 2020 11:15:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <eb04a3d3154dce299c91d12a315a2335603c508a.1606669225.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/29/20 10:12 AM, Pavel Begunkov wrote:
> +	tr->flags = READ_ONCE(sqe->timeout_flags);
> +	if (tr->flags) {
> +		if (!(tr->flags & IORING_TIMEOUT_UPDATE))
> +			return -EINVAL;
> +		if (tr->flags & ~(IORING_TIMEOUT_UPDATE|IORING_TIMEOUT_ABS))
> +			return -EINVAL;

These flag comparisons are a bit obtuse - perhaps warrants a comment?

> +		ret = __io_sq_thread_acquire_mm(req->ctx);
> +		if (ret)
> +			return ret;

Why is this done manually?

> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 6bb8229de892..12a6443ea60d 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -151,6 +151,7 @@ enum {
>   * sqe->timeout_flags
>   */
>  #define IORING_TIMEOUT_ABS	(1U << 0)
> +#define IORING_TIMEOUT_UPDATE	(1U << 31)

Why bit 31?

-- 
Jens Axboe

