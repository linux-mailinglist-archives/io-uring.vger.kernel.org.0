Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87ADE43E840
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 20:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhJ1SZV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 14:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhJ1SZS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 14:25:18 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2059C061570
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 11:22:51 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h20so7939366ila.4
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 11:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/dQjBtihCGzCzk4sWaJtlIxEMe6bvTILkJmUOOEk/+A=;
        b=qQzgyM9+6/Neq0qzf0bVuG0UN3cPEidy2yx2e9I4UAfTT415rHOjLkEeBU4uxzGJyW
         4lBvp86JQ+Re95L4OjhFw+rwdVa5VffUPZoydRoDMb1YCYKGD/wD1WEc9HwpJLOozU6V
         Nx4Cy+Y9QW5SM6Pkh/MXtnfd5y5/nuqnITavsYamlBjXNixn1cq5wr0ulM++CUxyTjN9
         AHUk2x9z1XNq0rQb4Qo+ZSLvQmU0EuhyqRiaLqjZXQK1PKmLCGtq6ob5y+TN6rKBYQhC
         XkzTwtOMV6R/mc0Vh5qDLSec3zQzr++aP/MbdB+nYC0B4CIpXHVLBCdWZrA9SpXKmN2v
         etQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/dQjBtihCGzCzk4sWaJtlIxEMe6bvTILkJmUOOEk/+A=;
        b=zcU3t4NUWV5aIIJ96FZejPjtzKXNfO522VhkVtmjgBcUyv6ngBaoVRiyi+FYqmy0FS
         JHUZVQxlDjvof9lNr1qzJl3ROU//0aPY27E1PBSsP85yF/uaUDCOI0IUGEcVJhYI0mYa
         2M3Upe42xaC/wKHLYLtx7uzrpY6JgQeL/Q1GkSrSZwC7+SICbPeE9HpgTaUAMd+61FP5
         CcZ9olO+eBRV2A/tFqI5mrX9u6EQT0x6907ZEQyqgHYJZvowOQVY1fsk6bDGDTGYwlvq
         l/Gv2mpXSRUyAH7j1yn2MXk7xNHKgI1F/c2hokb6mR7V2Tpjw8sCGD+lGWxLe9j1S+nY
         2Egg==
X-Gm-Message-State: AOAM533HxFeUvOeJzTJYM6Di7KYj5KJ2WP18e984qUouxlFYy3rQRHNZ
        3blYKLBB1ZJs5BsZwUoFgHMa2A==
X-Google-Smtp-Source: ABdhPJy5ZX9WH7HWNVyq3m+BRT5/jF7ABlJbV1IBddR0A15cliuEljTJ94llIqo/aZkHQr+VIOEZQA==
X-Received: by 2002:a92:8751:: with SMTP id d17mr1755422ilm.104.1635445371144;
        Thu, 28 Oct 2021 11:22:51 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m7sm1890990iov.30.2021.10.28.11.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 11:22:50 -0700 (PDT)
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
To:     Drew DeVault <sir@cmpwn.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20211028080813.15966-1-sir@cmpwn.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cc3d7fac-62e9-fe11-0cf1-3d9528d191a0@kernel.dk>
Date:   Thu, 28 Oct 2021 12:22:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211028080813.15966-1-sir@cmpwn.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/28/21 2:08 AM, Drew DeVault wrote:
> This limit has not been updated since 2008, when it was increased to 64
> KiB at the request of GnuPG. Until recently, the main use-cases for this
> feature were (1) preventing sensitive memory from being swapped, as in
> GnuPG's use-case; and (2) real-time use-cases. In the first case, little
> memory is called for, and in the second case, the user is generally in a
> position to increase it if they need more.
> 
> The introduction of IOURING_REGISTER_BUFFERS adds a third use-case:
> preparing fixed buffers for high-performance I/O. This use-case will
> take as much of this memory as it can get, but is still limited to 64
> KiB by default, which is very little. This increases the limit to 8 MB,
> which was chosen fairly arbitrarily as a more generous, but still
> conservative, default value.
> ---
> It is also possible to raise this limit in userspace. This is easily
> done, for example, in the use-case of a network daemon: systemd, for
> instance, provides for this via LimitMEMLOCK in the service file; OpenRC
> via the rc_ulimit variables. However, there is no established userspace
> facility for configuring this outside of daemons: end-user applications
> do not presently have access to a convenient means of raising their
> limits.
> 
> The buck, as it were, stops with the kernel. It's much easier to address
> it here than it is to bring it to hundreds of distributions, and it can
> only realistically be relied upon to be high-enough by end-user software
> if it is more-or-less ubiquitous. Most distros don't change this
> particular rlimit from the kernel-supplied default value, so a change
> here will easily provide that ubiquity.

Agree with raising this limit, it is ridiculously low and we often get
reports from people that can't even do basic rings with it. Particularly
when bpf is involved as well, as it also dips into this pool.

On the production side at facebook, we do raise this limit as well.

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

