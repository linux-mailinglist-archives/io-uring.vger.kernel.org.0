Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1699D28765B
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 16:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgJHOsF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 10:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbgJHOsB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 10:48:01 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E720CC0613D2
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 07:47:59 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id y20so2258997iod.5
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 07:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/tKoYXpSo4jI4h1iW7MrVJ6+NUWopy9MAx/q+FOQpvg=;
        b=zmj5XX0ypl0NuRBZNxZ+7LEY9XYQ18q0QccW28diI71chf7220mpmk5shGs2SVOGDj
         wWZZlVSjvLSvdu+JjY8UozDARyCgzD23+79n8mJL7hG/AJYjeQPXA0XFr7we5NA4SDNB
         7vA92tm1zvTBJtsp9gdINdeGMYWHXqn6VjkErE97zJgP6DKpD0tI8amVkI5mYllBfOmI
         zINHH/VKxQPsVLgPGv1qt5AVJ9ixcIcgBC9KoVoViZEVm7x9vHUGTU4355GK4N2XazH4
         lqelY5P12hRPQrvgO6+29ITcNKX73CAQUmPFsFaz4nSP4RAtNiofQXcChY/g4xxgv1WE
         szWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/tKoYXpSo4jI4h1iW7MrVJ6+NUWopy9MAx/q+FOQpvg=;
        b=k8reLgmSwoaOzb6/nBjIgl+GfzE7ZiOcKswbWSOylaWIZmXr5IaggEmG6rhIXjmcM4
         ZlRk/bLAzt/+MBYHcHXDqImNC2EecPL9Ms5b3dTg9QCunQg5E59nyjbeOtITo76yFkIO
         ZrCeCJuPywOgqbrweUZlNEQNkYfFsg71yR6QT9uCz61oh0TJmsx8n0gRqsQ2ecML8ey0
         bAVtriPyDCi5Vb9L3rr7x6kDzyJ+AKANUI0h4UVlaNDY1Ti0qq9CzN9HF7IHDQ0U6PVV
         TMlKLKKaQ0fxf8wSccPdeY/CRTLzUWaCoxOsTtIkup8TDiuLlZXPbJDWkwSe3yyZT13J
         FDrg==
X-Gm-Message-State: AOAM532O6wixUiOQqE1j9UaPXU5IwyN1KS8chrwXdaUGJBXZ50SfVIQp
        B7hEeYi3t7dFMlIzFNe/5hAk2A==
X-Google-Smtp-Source: ABdhPJxMTgGs2Ppmc21iguJ++e5P6e92yRpzXVIwde5CjaDJlFdCqlPZ40GIqgf1WV+UXjunrlzUIg==
X-Received: by 2002:a02:c611:: with SMTP id i17mr7429960jan.28.1602168479246;
        Thu, 08 Oct 2020 07:47:59 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t14sm2782045ilj.45.2020.10.08.07.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 07:47:58 -0700 (PDT)
Subject: Re: [PATCH 3/6] kernel: split syscall restart from signal handling
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201005150438.6628-4-axboe@kernel.dk> <20201008142135.GH9995@redhat.com>
 <de00f13d-9ff0-6955-5d37-557f044ce2aa@kernel.dk>
 <20201008144539.GJ9995@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <28abe1ad-f9ef-75e1-a7aa-06543b2cf8ca@kernel.dk>
Date:   Thu, 8 Oct 2020 08:47:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201008144539.GJ9995@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/8/20 8:45 AM, Oleg Nesterov wrote:
> On 10/08, Jens Axboe wrote:
>>
>> On 10/8/20 8:21 AM, Oleg Nesterov wrote:
>>>
>>> Can't we avoid this patch and the and simplify the change in
>>> exit_to_user_mode_loop() from the next patch? Can't the much more simple
>>> patch below work?
>>>
>>> Then later we can even change arch_do_signal() to accept the additional
>>> argument, ti_work, so that it can use ti_work & TIF_NOTIFY_SIGNAL/SIGPENDING
>>> instead of test_thread_flag/task_sigpending.
>>
>> Yeah I guess that would be a bit simpler, maybe I'm too focused on
>> decoupling the two. But if we go this route, and avoid sighand->lock for
>> just having TIF_NOTIFY_SIGNAL set, then that should be functionally
>> equivalent as far as I'm concerned.
> 
> Not sure I understand... I think that the change I propose is functionally
> equivalent or I missed something.

Sorry, maybe my phrasing wasn't good, I'm totally agreeing with you :-)
Was just noting that the task_sigpending() is key for not calling
get_signal(), to avoid hitting the sighand->lock again.

-- 
Jens Axboe

