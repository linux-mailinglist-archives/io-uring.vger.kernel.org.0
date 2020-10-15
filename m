Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93ED928F4F8
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgJOOnW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730675AbgJOOnW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:43:22 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AF2C061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 07:43:22 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id m17so4779216ioo.1
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 07:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ie9/ha5W60N8m8YRhYtdsvKY55MzTG5lK18D7sYLmZg=;
        b=ycpzMcDJv99EtYoJWm1mgWNtohMb7/vp/H6DfJ1wMoga6tvYRqqmmTRdw5dwlJ7Um4
         rFS4KaApUEZJvuKf7cYKrLdoYVV4b5boKU6/eCAHPUZvZtkM+l1hQC1y7rBwFBz8P2s3
         3KUcWCyX14RbG+mrwaH8itNzQX9XITnxsGcUsM1GIiceWhbjNa/aIeA+2nGBv6u96i9z
         ddmjrBVEeckAOhxEopGxO963af64vVp8FByMNeTYd0raPsyZtnmYj66Vbr0lq6Xs+Zw6
         Xzpv6qWemMlGy6Jx+bMChQI837lX8uqVZzvhhu/Il1rR+F3rZGjSzKt/HEGD6DATuerr
         vOrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ie9/ha5W60N8m8YRhYtdsvKY55MzTG5lK18D7sYLmZg=;
        b=Hn7ru082u/RAIuwJ1YPK//jlHLHRSJSI/gOLEUMxkh4Bhq7jlcS3UNJCZw3hrDkbRO
         cRp0Qe3E0JQr5kKmrNhmHvMgdnwz1ZglxX5U/UPHgfMmWhImPNic91ZvuEMOr2sWv6Ug
         bWPpmKKYThFqqluXiaNQR8EwYwPErz7xm//8Ko7smRLz/naHxp+UDe+weZ7cVbKL8dQE
         sTeE2cgNwfS8uU3/TSGb4hpLX80dbCjPaw3p04tfDk3Nk/2VL3kv7xbRjv/r2adomCMH
         XviNFR+fend32rOvqnQSIgtN/WeTYmyatAF5EWgZq+vmFHsfmyLPHp3M1hqAAxRNKsVH
         OuoA==
X-Gm-Message-State: AOAM530JqCgnO3Wa6DyAR0uc1FQP+dN131ZMt93magGtByWLvBR++hEo
        2bO9WHR9DvHbQbKITcV7NT0wiA==
X-Google-Smtp-Source: ABdhPJw/UDXrw1xnVIb5gHVbQMACmh88peCTZR7MxwbJLEB8v09xV9AJAfp/Zh+zL+Vqb2TZkZMY9Q==
X-Received: by 2002:a02:cce6:: with SMTP id l6mr3919982jaq.32.1602773001466;
        Thu, 15 Oct 2020 07:43:21 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i29sm2963138ile.45.2020.10.15.07.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 07:43:20 -0700 (PDT)
Subject: Re: [PATCH 3/5] kernel: add support for TIF_NOTIFY_SIGNAL
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-4-axboe@kernel.dk> <20201015143151.GB24156@redhat.com>
 <5d231aa1-b8c7-ae4e-90bb-211f82b57547@kernel.dk>
 <20201015143728.GE24156@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <788b31b7-6acc-cc85-5e91-d0c2538341b7@kernel.dk>
Date:   Thu, 15 Oct 2020 08:43:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201015143728.GE24156@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15/20 8:37 AM, Oleg Nesterov wrote:
> On 10/15, Jens Axboe wrote:
>>
>> On 10/15/20 8:31 AM, Oleg Nesterov wrote:
>>> On 10/15, Jens Axboe wrote:
>>>>
>>>>  static inline int signal_pending(struct task_struct *p)
>>>>  {
>>>> +#if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)
>>>> +	/*
>>>> +	 * TIF_NOTIFY_SIGNAL isn't really a signal, but it requires the same
>>>> +	 * behavior in terms of ensuring that we break out of wait loops
>>>> +	 * so that notify signal callbacks can be processed.
>>>> +	 */
>>>> +	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
>>>> +		return 1;
>>>> +#endif
>>>>  	return task_sigpending(p);
>>>>  }
>>>
>>> I don't understand why does this version requires CONFIG_GENERIC_ENTRY.
>>>
>>> Afaics, it is very easy to change all the non-x86 arches to support
>>> TIF_NOTIFY_SIGNAL, but it is not trivial to change them all to use
>>> kernel/entry/common.c ?
>>
>> I think that Thomas wants to gate TIF_NOTIFY_SIGNAL on conversion to
>> the generic entry code?
> 
> Then I think TIF_NOTIFY_SIGNAL will be never fully supported ;)

That is indeed a worry. From a functionality point of view, with the
major archs supporting it, I'm not too worried about that side. But it
does mean that we'll be stuck with the ifdeffery forever, which isn't
great.

Thomas, are you fine with decoupling this from CONFIG_GENERIC_ENTRY,
based on the above concerns?

-- 
Jens Axboe

