Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C21D21A177B
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 23:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgDGVlo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 17:41:44 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:37445 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgDGVln (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 17:41:43 -0400
Received: by mail-pj1-f50.google.com with SMTP id k3so306768pjj.2
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 14:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tS+TlVOd7aIy1vUa5jDzKH6KdKlFSnYfAmgGmCwg0MQ=;
        b=sd4MktDhQuFjZKn/dt63EgD+Gt0T6W9fSKxGFDq1gG9Czbqn2gO1+uXxK0+ErMxrHJ
         m/C8XhLRZdkZk0DAtQirwT090+NhqDWHlhGqgekUVbUFdSAldD6u6UNfDwdLgMh9v65C
         BvKw3mvy7iKcTz/YL6YIlBbqRUal0hN6S6l4QlPwRP4Rl6yDHDNuonvvCt0OfTy3YqYB
         4aVcFAsDW/eR4jLG87vwWj9EmGwZ1m1MfXkHmLd7pjy5FbKTHXMw8m9F2m9q9M89P+gf
         FyB6BQnOuMs18SpW3F+4CmNokJuByiwmJNMCauplJFuuX7+XrvmCTXACisnFNgCVE+TW
         R3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tS+TlVOd7aIy1vUa5jDzKH6KdKlFSnYfAmgGmCwg0MQ=;
        b=Qpy2USKTygAnTAjgGW03Jy7OgViet3MQRF8v/YKNVuDHxAWWrQM0wTF8Z6ccPFJ4wn
         6x6ZrTrxyjTgzZPqKEyIr460uM4CIUQUc7P6Msa+XY1ShdR13LhWdmBsP+Htc1wDu9S3
         U1nusaiFfrwi0Q31BpLaN/k2tkHWIdkUEAgE0Jb5rT7tKFxuI8YvywVmkqTJV2HhU9ta
         D0JaH70S8wcM6MiJMNyHcfy2xqNGWmNtNfF+G2Un2bnZB4bmc91OGv69i80SoOFL+FuY
         j1kyyxJjhRgOYxCpsBhzO4Y7bShFfAdJ6BoOeVFNSLOks7fu/hLZ2WB/AxxUxFIYctBZ
         7Fyg==
X-Gm-Message-State: AGi0Pube778+fDtI0Meg4UXFF4Iw0cyoSXR0a7VkM9n6BAumGuO+mSkj
        0USgO8U1T/lhovcgs9HJmhans0imUuvRUg==
X-Google-Smtp-Source: APiQypIK+Z87HSv2+rtYgLoRPKRC7k5ClaVBM4KlGxiDYDKusejKG4bT6iDnKGats4CEChHGck44Ug==
X-Received: by 2002:a17:90a:350d:: with SMTP id q13mr1381142pjb.171.1586295700952;
        Tue, 07 Apr 2020 14:41:40 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab? ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id u3sm223416pjy.9.2020.04.07.14.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 14:41:40 -0700 (PDT)
Subject: Re: Spurious/undocumented EINTR from io_uring_enter
To:     Joseph Christopher Sible <jcsible@cert.org>,
        "'io-uring@vger.kernel.org'" <io-uring@vger.kernel.org>
References: <43b339d3dc0c4b6ab15652faf12afa30@cert.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b9ee42f0-cd94-9410-0de1-1bbfd50a6040@kernel.dk>
Date:   Tue, 7 Apr 2020 14:41:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <43b339d3dc0c4b6ab15652faf12afa30@cert.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/7/20 1:36 PM, Joseph Christopher Sible wrote:
> When a process is blocking in io_uring_enter, and a signal stops it for
> any reason, it returns -EINTR to userspace. Two comments about this:
> 
> 1. https://github.com/axboe/liburing/blob/master/man/io_uring_enter.2
>    doesn't mention EINTR as a possible error that it can return.

I'll add it to the man page.

> 2. When there's no signal handler, and a signal stopped the syscall for
>    some other reason (e.g., SIGSTOP, SIGTSTP, or any signal when the
>    process is being traced), other syscalls (e.g., read) will be
>    restarted transparently, but this one will return to userspace
>    with -EINTR just as if there were a signal handler.
> 
> Point 1 seems like a no-brainer. I'm not sure if point 2 is possible
> to fix, though, especially since some other syscalls (e.g., epoll_wait)
> have the same problem as this one.

Lots of system calls return -EINTR if interrupted by a signal, don't
think there's anything worth fixing there. For the wait part, the
application may want to handle the signal before we can wait again.
We can't go to sleep with a pending signal.

-- 
Jens Axboe

