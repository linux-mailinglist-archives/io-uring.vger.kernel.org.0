Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA7C28F8C2
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 20:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733078AbgJOSje (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 14:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731154AbgJOSje (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 14:39:34 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE9BC061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 11:39:33 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id l16so5573982ilt.13
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 11:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2eYPjnhMkoKRh274ZnfDYxEkN/cASuQVhfeqtpp/wFo=;
        b=JeKQa4xUyeVsPYFmaCn7c933kxLOMPieHLwq4xeMoEO/okGMXehToHvd+0ig7XaIgP
         fHneyQ60wBUcEpxPUpTELURgj5bQIelk0vJP0TgRDXW95Vd8u5nZkWrMtNgvymK2D3DB
         7wfN4oY2FqabCqGYCmGCUeKOhtK4TzCIlswIXurPRrYIKYwZH7CYwdNoMmCoICJcSgsf
         /meK+N6OQ4aCTmXZRGkygQvKXvUTKx8lVeno6q4vHbW7SAbYuof8VFNhuZloauqDFQWX
         WhveX7ppMApDxhOhALQer1AszJqIBPle/oM35KL+bH/UNuLDQ1qiwNLLPRkowndfDMnt
         9vPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2eYPjnhMkoKRh274ZnfDYxEkN/cASuQVhfeqtpp/wFo=;
        b=f8xAfNhg0/eWFd+IHrs8X4jCOJSeNctcbsfi5RnPmat5Bh9ai0VP4gMu4r86t7f6Iy
         f3epdFIA1F23A4uF8IZ+GSzof43/kjY29hbH4ieHOJDDjrWQiIl+jvNv1DDqWHQuoYZp
         ruOFjITksvzYNEnPQzcymtY1HT7j/t56uo2D2dFgFSjSs6cTbeI22QFey2VgFzze+AcN
         ZWozYW3dslGxaJBIWUgIdq+NbhePEkeCkEBjUgGegR1X3QIUckUOT9PrqUT8zOgOlGaj
         NKdYGS+vObxEI7lBQ42tS0TUEq1AcnDIO8yMoZ2YR/DhMm9tMavorH4POQzWEtHnuPhR
         1ULg==
X-Gm-Message-State: AOAM532yphsQBmqmpfJaxPeI4iWpD1+vq3K2jx0BY1L44JWr0LY1Ybqc
        rWv6qM4oZgRGPTrNYuSTH+inZA==
X-Google-Smtp-Source: ABdhPJybMiCJjWUTEv4UBJhuJh14Xu+AxKMOZureDclwvHKWgahxfC7F1dxi9KPo+YQpk2Hu4SMh7A==
X-Received: by 2002:a92:cd42:: with SMTP id v2mr3868619ilq.65.1602787172427;
        Thu, 15 Oct 2020 11:39:32 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm3391972ila.47.2020.10.15.11.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 11:39:31 -0700 (PDT)
Subject: Re: [PATCH 5/5] task_work: use TIF_NOTIFY_SIGNAL if available
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de,
        Roman Gershman <romger@amazon.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-6-axboe@kernel.dk> <20201015154953.GM24156@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e17cd91e-97b2-1eae-964b-fc90f8f9ef31@kernel.dk>
Date:   Thu, 15 Oct 2020 12:39:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201015154953.GM24156@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15/20 9:49 AM, Oleg Nesterov wrote:
> On 10/15, Jens Axboe wrote:
>>
>> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> 
> Yes, but ...
> 
>> +static void task_work_notify_signal(struct task_struct *task)
>> +{
>> +#if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)
> 
> as long as defined(CONFIG_GENERIC_ENTRY) goes away ;)
> 
> Thomas, I strongly, strongly disagree with you. But even if you are right
> and only CONFIG_GENERIC_ENTRY arches should use TIF_NOTIFY_SIGNAL, why should
> this series check CONFIG_GENERIC_ENTRY ?
> 
> You can simply nack the patch which adds TIF_NOTIFY_SIGNAL to
> arch/xxx/include/asm/thread_info.h.

This seems to be the biggest area of contention right now. Just to
summarize, we have two options:

1) We leave the CONFIG_GENERIC_ENTRY requirement, which means that the
   rest of the cleanups otherwise enabled by this series will not be
   able to move forward until the very last arch is converted to the
   generic entry code.

2) We go back to NOT having the CONFIG_GENERIC_ENTRY requirement, and
   archs can easily opt-in to TIF_NOTIFY_SIGNAL independently of
   switching to the generic entry code.

I understand Thomas's reasoning in wanting to push archs towards the
generic entry code, and I fully support that. However, it does seem like
the road paved by #1 is long and potentially neverending, which would
leave us with never being able to kill the various bits of code that we
otherwise would be able to.

Thomas, I do agree with Oleg on this one, I think we can make quicker
progress on cleanups with option #2. This isn't really going to hinder
any arch conversion to the generic entry code, as arch patches would be
funeled through the arch trees anyway.

Thomas?

-- 
Jens Axboe

