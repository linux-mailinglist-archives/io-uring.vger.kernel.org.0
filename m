Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3360B380C4D
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 16:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbhENOxt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 10:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbhENOxs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 May 2021 10:53:48 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14243C061574
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 07:52:37 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id z1so50193ils.0
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 07:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ScYSBynyJcOeHytBqOTo3glym+IANf5jR/kKPfoCee8=;
        b=VF3EOzNxZGq868p41q6j0CXiTKnND/HGgB6hdL17AwZPZNOifC3uS4tLJCm5hX0FPD
         pdC05itpQnmQGaj4FdHVii9f/P6+Ykw0YvaSNadpebelHAYpY3YQgnTsK0+TCFlJW2fs
         SSPYqjgMf14odY+g/rxdhd6xRIpUcfufTHy8HWFZSBsMiyJu6R8ZiINmgCvopuW1lUk5
         jejR5iTkxGWjDgnDip4GQiELuYqMkoTXBwqT4jx7f7tyq3Q4dbdP6wVjSZ4yBv4BgPI2
         zT4nt9NqqLldTMLLZqITZ9aM5M6cd42s25b4M19qDxt69lRKhlOPo2gAbtOJkd6FV1zC
         j80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ScYSBynyJcOeHytBqOTo3glym+IANf5jR/kKPfoCee8=;
        b=L0y5vCWIM8glFw2vzQ8A6uujmvSKIPCwOZb2DMRxrX5i3T+gkPAfZR6loQDE9fg0z5
         yfFz9StrqS90lUOYM1nLVMn5Nag+/6b6WRbbUSK4Lf1LWFc89AoeMmPvPwDobIX/pU8x
         KJdmhZCwt1CEbFzJjFxY9mLMEL1xA8lHHCKI3ZTR0kLKowVsnlw6Gp/GBgTSjxuqGuYS
         FkYv911fJsiVZ2z9rVJSYY8uVlh7Qo4JMhJu0c3sIdI+dxPqVDCTFDc7bk0fyLUXbRsn
         /zs8gMcJttnRNd3VNSm7W6JlhldDf+rghyF0DvcH6eMynzoQYNAvMs2iUsHpf+fHjgWY
         XmIQ==
X-Gm-Message-State: AOAM532ZiMllUq9KCV4vzHBXPxtmNGPSVoZq8LMfheZxfpv3M7512mnp
        UC9iwoRxhHup8bdsbFbSEIYHPo1tl+O2fA==
X-Google-Smtp-Source: ABdhPJz9yfLYOjRQPrvDMoelEhxwMfVA+SzQ5MIsJZNZSxJv0NZJ3OB2uA7BqCwZ1dlKgFPFTBU4Gw==
X-Received: by 2002:a92:130a:: with SMTP id 10mr40476038ilt.159.1621003956426;
        Fri, 14 May 2021 07:52:36 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s17sm3129697ilt.77.2021.05.14.07.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 07:52:36 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: further remove sqpoll limits on opcodes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <909b52d70c45636d8d7897582474ea5aab5eed34.1620990306.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <74952d45-e5c7-4486-5e4d-2576f75762ee@kernel.dk>
Date:   Fri, 14 May 2021 08:52:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <909b52d70c45636d8d7897582474ea5aab5eed34.1620990306.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/14/21 5:05 AM, Pavel Begunkov wrote:
> There are three types of requests that left disabled for sqpoll, namely
> epoll ctx, statx, and resources update. Since SQPOLL task is now closely
> mimics a userspace thread, remove the restrictions.

This is nice, now SQPOLL is 100% like non sqpoll, which it should be with
the io threads. Applied, thanks.

-- 
Jens Axboe

