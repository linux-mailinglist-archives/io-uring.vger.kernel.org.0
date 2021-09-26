Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919EC418561
	for <lists+io-uring@lfdr.de>; Sun, 26 Sep 2021 03:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhIZBWc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Sep 2021 21:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhIZBWb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Sep 2021 21:22:31 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8369C061570
        for <io-uring@vger.kernel.org>; Sat, 25 Sep 2021 18:20:55 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id d11so14806505ilc.8
        for <io-uring@vger.kernel.org>; Sat, 25 Sep 2021 18:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h8rwZgo/X8fBt7Y1fQ9qY2zFB6VhIFdRa1FdI6tlUrk=;
        b=7+SCbgnOTiUL9TXsAxtrUkxuwbtL2rwU5E21LOFEyIQ+mQvQn1KR5LsWjEe8nZDexS
         oC5amrwhet1OISsckmJYby9FThJbzGzpaVbiXudE/o19PGFnma7VjcCgQ6GVVBytB5tD
         RbfBkuft9KA6G0caBop4NStrl3Yvq2Ks751xoJoZNI6FlyiFF7XrcGYkfJEfLHCutXSG
         ljLWjcj1GUyrRftRuRmPtUMDqpOAy7OB+XBC+BknY2UuOllgFJhY0aZXBSSZHuRN6fWI
         RNEt38p5Thc4VdnbZIP/4JoiVDObmNw3whnMnVAyhscBF1OsJtbiKdYCTI3I2P9RL1Se
         59OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h8rwZgo/X8fBt7Y1fQ9qY2zFB6VhIFdRa1FdI6tlUrk=;
        b=dN1jCFM4VfiCR77CGc2t+hdBCxtBc70rXwzMgo5g8Pry9JeXlVTzve7SAGaskURnRn
         n/ZQHXx7MOR53GQ6gdgtFVBcqTDSGavGrnTyvilEE+GMUfJ/PjceXJdPsqP0KuCxSU2L
         QcsUSfYAGhW0kSQwPkQ34W+Lz5zVpBfZRZDi2Sl1AIz4XXFJq61U7ImhJa7z1pMA2Brr
         /Okfpk248hHkr3jmMWk4skb0gkPRFT1+nfONKajpzcfd1s4NMtw4s35PyA5iTUmOXwaG
         MGLA9wDs185+JDSDLeC7guIj2lOv5pFS9ZQoeqsY0hLxdfnyjC5eCiALx1Dy8ALcVee+
         cQtw==
X-Gm-Message-State: AOAM533wrO9iR1/txeXQTX6FRbt1WZEkzDQFcQOTXkJ/ncWbWZFq/4T9
        NSnx4B7cuHzpRNrVkKnzZqqa6NWp7yOFJg==
X-Google-Smtp-Source: ABdhPJwqHaUw5YmA24XByUvqlVoS7twFw04iPYBvHBNp6Pjy0VHUISsTbX6q+d8eaeGguTIt3ctl0g==
X-Received: by 2002:a92:c56e:: with SMTP id b14mr3482303ilj.71.1632619254308;
        Sat, 25 Sep 2021 18:20:54 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id z5sm6628868ile.42.2021.09.25.18.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 18:20:53 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring fixes for 5.15-rc3
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
 <CAHk-=whi3UxvY1C1LQNCO9d2xzX5A69qfzNGbBVGpRE_6gv=9Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0eeefd32-f322-1470-9bcf-0f415be517bd@kernel.dk>
Date:   Sat, 25 Sep 2021 19:20:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whi3UxvY1C1LQNCO9d2xzX5A69qfzNGbBVGpRE_6gv=9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/25/21 5:05 PM, Linus Torvalds wrote:
> On Sat, Sep 25, 2021 at 1:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> - io-wq core dump exit fix (me)
> 
> Hmm.
> 
> That one strikes me as odd.
> 
> I get the feeling that if the io_uring thread needs to have that
> signal_group_exit() test, something is wrong in signal-land.
> 
> It's basically a "fatal signal has been sent to another thread", and I
> really get the feeling that "fatal_signal_pending()" should just be
> modified to handle that case too.

It did surprise me as well, which is why that previous change ended up
being broken for the coredump case... You could argue that the io-wq
thread should just exit on signal_pending(), which is what we did
before, but that really ends up sucking for workloads that do use
signals for communication purposes. postgres was the reporter here.

-- 
Jens Axboe

