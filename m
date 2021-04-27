Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F214336C71D
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 15:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237983AbhD0Nik (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 09:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbhD0Nij (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 09:38:39 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E13C061760
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 06:37:56 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id k25so16579811iob.6
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 06:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AnOz18OxWT4XUVdfhkzmW8JPI+/UqwkBcIHUk95028k=;
        b=uKM9tI1609MLSf8/zz52XsfRUdSx4VRN6ttEaxgDhsKIxunOFHAU3DGeC48Hl1OPYQ
         aRPRJk67WKnJF5jghGQHsJNBAB1EGfTbyYTlGASVJcDY5RJF1tepyGQNyVVMMhwx8puZ
         ktLasznrF3oggQa2CGAfSAQNzMvSZaxMxgyRVO3VstoctnQko3rpWAdeUgPYTUuJv+27
         Fm3vuxXXBqLj8Niy885Jn6uZeR+NA6e3io7v4f/zmlulcCsH4m2/lDI8yxQ0pwBYj9mk
         dYLdSc7KwXQ4p9/V/qrkXNqF6N+qJ4k6pt5mu7WEK6pdIv5m9395kisskRuBycIEp/WA
         75rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AnOz18OxWT4XUVdfhkzmW8JPI+/UqwkBcIHUk95028k=;
        b=DyEgfXJn/9tgUXVjP+89hciACudxhOJMMzUMbxFL71g8/4cL6B2q1KUpvVmy5X/Cio
         vNpLIRmtiQCpqwBn+dazFhDekuRwtWWO98Zl1mBnRq1cpiVyjNj20yA/JzQkc5m4nS66
         9CnuoR3A/hTd7quq2Jgs8JuFGkgWC2EEQChNjVGqhJF4FbB7u+efSNrgfCEHYmj9IUSU
         ZbZAHp1jKk5ysFso1b89vJ8R4mM/3+SCkqZ/vEGTynEVWEzV0mP5Tc3ETJ8v+brULTww
         +Bg+0FyhA184xXakK8NTbjlG5VYqMGvHOqo0ZWLmJ/HLkEQLk28HRvXMewW/8EXSgMro
         wnzg==
X-Gm-Message-State: AOAM5327xb2H7rRi1FEfZR0x8kb9GIdjnT1/UUU57aZ/B0xNedR/CzHN
        JGINNj4cbm/JHnvc9cU9RdGytw==
X-Google-Smtp-Source: ABdhPJyakhyueEY60LYB8Yhdfg21cGXSyiSkw0899JiBSMGVnQjWInAQSpNfYazkZMdhTMp3GeXQAA==
X-Received: by 2002:a05:6602:3305:: with SMTP id b5mr20167742ioz.83.1619530675494;
        Tue, 27 Apr 2021 06:37:55 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j1sm8954177ioa.19.2021.04.27.06.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 06:37:55 -0700 (PDT)
Subject: Re: [PATCH 5.13] io_uring: Check current->io_uring in
 io_uring_cancel_sqpoll
To:     Palash Oswal <hello@oswalpalash.com>, asml.silence@gmail.com
Cc:     dvyukov@google.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, oswalpalash@gmail.com,
        syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, stable@vger.kernel.org
References: <e67b2f55-dd0a-1e1f-e34b-87e8613cd701@gmail.com>
 <20210427125148.21816-1-hello@oswalpalash.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <decd444f-701d-6960-0648-b145b6fcccfb@kernel.dk>
Date:   Tue, 27 Apr 2021 07:37:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210427125148.21816-1-hello@oswalpalash.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/21 6:51 AM, Palash Oswal wrote:
> syzkaller identified KASAN: null-ptr-deref Write in
> io_uring_cancel_sqpoll on v5.12
> 
> io_uring_cancel_sqpoll is called by io_sq_thread before calling
> io_uring_alloc_task_context. This leads to current->io_uring being
> NULL. io_uring_cancel_sqpoll should not have to deal with threads
> where current->io_uring is NULL.
> 
> In order to cast a wider safety net, perform input sanitisation
> directly in io_uring_cancel_sqpoll and return for NULL value of
> current->io_uring.

Thanks applied - I augmented the commit message a bit.

-- 
Jens Axboe

