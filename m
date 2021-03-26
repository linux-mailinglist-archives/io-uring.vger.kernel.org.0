Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D33734AA1F
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 15:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCZOiz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 10:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhCZOi1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 10:38:27 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F492C0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 07:38:27 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id n198so5656256iod.0
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 07:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hKpfpn0Haz5O7Pa2DVMAWbWylPr9Lp1uSORVeezS3tM=;
        b=O1EvnpWCmYLg+UkahvyhEvg/XCqctRasY7lvP3QhIs9ouZ4dTqW6A8i+c6pZpXK0bJ
         KmBG6yL8w5NP6Hd+2r37dS2fU34ka9UqLg/JWq+JP8SHBW9I2UE5zOges1YcqkFIuZw/
         n3+gmKcP5T0gIS5DcC322cm53kjAsdVf+euumRVc53yd5kYmyw/QMAtsmJQvDbI9clxQ
         D4px8Kx67xdEctzDA09EjtpgjKKCKD+DbWBtZDDy0fGAxT4AM+LJw8ifiMgCFGmGNxeU
         p/dwiVLja233OHMhMPQaH4Soi4j6p00PEziHqn8+zUisqTnbv/1sl8I0Ct6+NbDLS7ww
         47Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hKpfpn0Haz5O7Pa2DVMAWbWylPr9Lp1uSORVeezS3tM=;
        b=Bm888Nhde0Kn0l7AQxZUXh4pNYiOidhp8XiKzA//rJNSPA0Euo0huZXGJjdo0O43HY
         eUdvFIwX8aH1Cbg0jgcHDxIlf3De7sGswxRkqHwZ4riL7Yrbhn1dq5N4XAzVgcYaUQS/
         eir2cfJjH3I1bsWXeR4gG5fypjVcLKJEV4I7KKCshz2yv504SccQf+fskWs6DShX+4/w
         Fyx46GIb9A/XWNy59ppzNbHaoWWgSyHWMlcMlkC9hD6YLqfwYAB+z5XPYCtu3C/VoX9J
         0Q8dI9Z4A4SD8b/J/cte4LLT5dh+q7mrOKWQJbJTpxPGMFVnz9NXL9p9bghLLqJi1K81
         1eRw==
X-Gm-Message-State: AOAM531l9PpPYplpQmjME5tty6QbdBZe90uGXNMlzbC/S/fOLQhP7UgC
        0uNkNoRa0bYh8rHZHgNjUEFmdnuBCP8EGQ==
X-Google-Smtp-Source: ABdhPJzTLhZvqhENo7RH31/SlCkSzdj7pgCxwaak1gUmh3t9s4Tr4e50bbCgjqEMdInfIerQ8eW92w==
X-Received: by 2002:a5e:8e41:: with SMTP id r1mr10525118ioo.5.1616769506922;
        Fri, 26 Mar 2021 07:38:26 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o13sm4365167iob.17.2021.03.26.07.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 07:38:26 -0700 (PDT)
Subject: Re: [PATCH 0/6] Allow signals for IO threads
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <0c91d9e7-82cd-bec2-19ae-cc592ec757c6@kernel.dk>
 <bfaae5fd-5de9-bae4-89b6-2d67bbfb86c6@kernel.dk>
Message-ID: <66fa3cfc-4161-76fe-272e-160097f32a53@kernel.dk>
Date:   Fri, 26 Mar 2021 08:38:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bfaae5fd-5de9-bae4-89b6-2d67bbfb86c6@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 7:59 AM, Jens Axboe wrote:
> On 3/26/21 7:54 AM, Jens Axboe wrote:
>>> The KILL after STOP deadlock still exists.
>>
>> In which tree? Sounds like you're still on the old one with that
>> incremental you sent, which wasn't complete.
>>
>>> Does io_wq_manager() exits without cleaning up on SIGKILL?
>>
>> No, it should kill up in all cases. I'll try your stop + kill, I just
>> tested both of them separately and didn't observe anything. I also ran
>> your io_uring-cp example (and found a bug in the example, fixed and
>> pushed), fwiw.
> 
> I can reproduce this one! I'll take a closer look.

OK, that one is actually pretty straight forward - we rely on cleaning
up on exit, but for fatal cases, get_signal() will call do_exit() for us
and never return. So we might need a special case in there to deal with
that, or some other way of ensuring that fatal signal gets processed
correctly for IO threads.

-- 
Jens Axboe

