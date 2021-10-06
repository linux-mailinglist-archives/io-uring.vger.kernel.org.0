Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1450424641
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 20:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhJFStq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 14:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhJFStq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 14:49:46 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5C4C061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 11:47:53 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id i11so2841725ila.12
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 11:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CygA8fkyX9qUapamDo8kLl6SKnvu3s33vyLyCbGv8J4=;
        b=LFtwHc1ca3xqkUNhW6HD1oORCNYrEqZBbWpd7eixO8ShNxvUjn2k4MjHn/wK/8WXDM
         PCaxrZPMFdjkUvRlVD0XcW85t07GqCQobFk8QEivMnWVZHAeohAZYc9VsWT//aJbN1+Y
         635lkIQnZRQ9GBIYNAhzWmJNDEWE263rssTvB257r9QzdHpICGqgxghVAHoJiSM8OnE8
         RcIhytWGRUi+LCx7quqBJKAGp1r7dD4he0BV/ph3pa2SkISfAlFMnzFA7Nd/bueasnbU
         mMcCp1cgqUjQ7bF3HJLSB7f611EeC1lpBa9KY4WOgF6UcGfHRgyssu6TyiWpyNzGjsOv
         hlcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CygA8fkyX9qUapamDo8kLl6SKnvu3s33vyLyCbGv8J4=;
        b=ryr5H8dVR/F7EoI8JstfKX9xbu4Zx9D16e/QcGvsH6wBvbrn9Ws4BXJ/CR0A91fqTI
         S+RJhLabJCzVUlZYvNSbPJ4Fb68Ocu67Z9H43cG0bChgNmd1kIuDCtqEwvu2nkv4cuLX
         1H9uH7YjSV8toorDn+cKU2NlvzfmdOPztAdr/shoAWEo5pEYvmjzf5mszo7cOOcB0QTe
         WwFqyEcaUh4qS2W5hGuLHIKbucyzuHp1zAzohheuCk0EjEGgg5lu+VuLJUGW23yVlz9Z
         3b1vG51CMi9HMtcZ9T4pFTCgL8FckjTe5IJXPSTrZ4aCMRh66dl+Dijp+0bIdvDFWbm0
         vUTQ==
X-Gm-Message-State: AOAM531p8G/P0Poux4rV78uyMGV7blFzrumcKltg9OXBsuT3HSQ3KFQg
        R4qVaUJJvMGhGMovopF/Vb6jcA==
X-Google-Smtp-Source: ABdhPJxYX0Wnj33KA4Bo182/UkINaCnurYfV5W/fY+++mF5pg1f9B2uIzV5MHRsEBsHxaBkk5hHihg==
X-Received: by 2002:a05:6e02:1a0e:: with SMTP id s14mr8975338ild.197.1633546073221;
        Wed, 06 Oct 2021 11:47:53 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s11sm11822284ilv.69.2021.10.06.11.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 11:47:52 -0700 (PDT)
Subject: Re: [PATCHSET v1 RFC liburing 0/6] Add no libc support for x86-64
 arch
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <efeb2d62-e963-6373-79ae-f8aa2d3bae1c@kernel.dk>
Date:   Wed, 6 Oct 2021 12:47:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/6/21 8:49 AM, Ammar Faizi wrote:
> Hi everyone,
> 
> This is the v1 of RFC to support build liburing without libc.
> 
> In this RFC, I introduce no libc support for x86-64 arch. Hopefully,
> one day we can get support for other architectures as well.
> 
> Motivation:
> Currently liburing depends on libc. We want to make liburing can be
> built without libc.
> 
> This idea firstly posted as an issue on the liburing GitHub
> repository here: https://github.com/axboe/liburing/issues/443
> 
> The subject of the issue is: "An option to use liburing without libc?".

This series seems to be somewhat upside down. You should fix up tests
first, then add support for x86-64 nolibc, then enable it. You seem to
be doing the opposite?

-- 
Jens Axboe

