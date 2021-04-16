Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2101A3623F7
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 17:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243292AbhDPPbc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 11:31:32 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:35539 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbhDPPbb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 11:31:31 -0400
Received: by mail-pj1-f46.google.com with SMTP id j21-20020a17090ae615b02901505b998b45so1276745pjy.0
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 08:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pj0+qs4YO88VNi4QVkli+Gf0B1YjPzZteZXzBQOEXEc=;
        b=dO6kplHCLuP6BAUq4/cSRODTncv85XXAfC8xPkuldVBdImSWmyYr+qby3CGTWRe6Ot
         A8BG8Vu07xDYDGkK6OL+2FqevdEt8fzfPUoNvte12c/csdqWmQ0qIsuPMEu6dom6ZuYn
         SniQS+dHpf02JPRFtD2VQMQH4W3srqZpt2A+Nmt69aXSnbveYVKS9CpNM0RZ2MBaMTLI
         xCL2Ijd40ag2L33ce6NfABSe/hcfM7bso3KK+D9qjJ1WvjxEljAso/itNBVymqzvHcuW
         /q670MuzchW84AihHDQpa1s2hKnrBefx/2OlPY0xqVqzphCZ+gmgf4nMkTSr4I5JcgMZ
         m6Hg==
X-Gm-Message-State: AOAM530eJlkWAk9w/REfVUeQeZl+WPuPlTqcgAuL4LwwXg0aIWzqd23u
        g9CMwE8lmq69AyidY/h/EDA=
X-Google-Smtp-Source: ABdhPJysvGDHK8PJpS31Y06uczmhxNuFq+etfJ72Um9mYxrLzab3e2JG3360H5NvBqfXKeAioIuu7g==
X-Received: by 2002:a17:902:74ca:b029:ea:e132:9ad5 with SMTP id f10-20020a17090274cab02900eae1329ad5mr9970959plt.22.1618587066576;
        Fri, 16 Apr 2021 08:31:06 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:deb4:c899:3eb6:a154? ([2601:647:4000:d7:deb4:c899:3eb6:a154])
        by smtp.gmail.com with ESMTPSA id i28sm5279427pgi.42.2021.04.16.08.31.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 08:31:05 -0700 (PDT)
Subject: Re: [PATCH 1/2] percpu_ref: add percpu_ref_atomic_count()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Joakim Hassila <joj@mac.com>
References: <cover.1618532491.git.asml.silence@gmail.com>
 <d17d951b120bb2d65870013bfdc7495a92c6fb82.1618532491.git.asml.silence@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a393b2dd-bf2d-236d-8262-e908862789e4@acm.org>
Date:   Fri, 16 Apr 2021 08:31:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <d17d951b120bb2d65870013bfdc7495a92c6fb82.1618532491.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/15/21 5:22 PM, Pavel Begunkov wrote:
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

How about using the name percpu_ref_read() instead of
percpu_ref_atomic_count()?

Thanks,

Bart.
