Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0331A410718
	for <lists+io-uring@lfdr.de>; Sat, 18 Sep 2021 16:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbhIROm3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Sep 2021 10:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbhIROm3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Sep 2021 10:42:29 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01E8C061574
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 07:41:05 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id b10so15991941ioq.9
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 07:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Trct6BVSwPvbdUizmKPF6E62CRF/gO1cXbkATwPDBb8=;
        b=3pPdYYhnXTdz6wyfRKfW8CPHt5EdUxf4khaI7qEEbXiiE1a6GlXoqJb17yWIx7XfwY
         FFza+LOnTpLTbIlauRX0EqQ/f6FQK1oHPViMpm7/xJSoTppX6zPWRlQRV50Vn2eTJC2Y
         bEl35jUmGzckg1PcZd/bc/lxdHvakNftxoS8LfuZvIQHPDK//yr1wamrl/fd4R+u6tne
         8KMwjvpNJy9JAPcp29W6sADUwW7AzxItMQ69tYiHq7UYSWXgwsvsHbpcGlAj8y49JMiv
         JobfjrcKQCsan0XrK4ESplrC/D+y3LONlLiQdniWTuy4Ny9s6EWIV3f480hr9WHyKmiV
         1azg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Trct6BVSwPvbdUizmKPF6E62CRF/gO1cXbkATwPDBb8=;
        b=cfbkzn41i7+O+T3vPdKOzP3VO8f73O7RIl9zUUP9sqvrDjpOOYi2mh2yLUGERTDBmV
         6WJo7f0FtOOUHiVdT+Iix82fVRp/kdPE6CNzzDUYN6le6k5GbTqdmjeEbI4qnmSMd6vR
         UTAXVpTQqR4F+QNrAnWOpqQajz/sJKRyNkTpl0vq1bwZXVzwjbbuM0ogc2gCpA1SdCDm
         OUBlmGvne1R5QMa9cXLTu7VNdZDaks4aSpLVN36pwli1GRBF58jC7+vtK5NGkW5AbZDB
         1oNkvT1xDd5Hu9oNVh9fihrYHm+DUAAAjAqONFrTaCW1gnK8MXUELFb8siQb0OwsmfwK
         67bA==
X-Gm-Message-State: AOAM530JAlMTBbhgqvbfYR+Z2cU41VM22ksweNOS1kKEnxfCtVB3DAh3
        oLKI8Wvy/HzAYD/U5g1QUPpqkyWDIUXAgw==
X-Google-Smtp-Source: ABdhPJyQv0K739gvLvAyelBD9bH7OwIshXH5xHeKWZNGzMMLReu1onF0PqXP1P5bJH+wbs7AU6E72Q==
X-Received: by 2002:a5d:94c4:: with SMTP id y4mr849404ior.131.1631976064755;
        Sat, 18 Sep 2021 07:41:04 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id n4sm5787844ilo.76.2021.09.18.07.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 07:41:04 -0700 (PDT)
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
To:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk>
Date:   Sat, 18 Sep 2021 08:41:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/18/21 7:41 AM, Victor Stewart wrote:
> just auto updated from 5.13.16 to 5.13.17, and suddenly my fixed
> file registrations fail with EOPNOTSUPP using liburing 2.0.
> 
> static inline struct io_uring ring;
> static inline int *socketfds;
> 
> // ...
> 
> void enableFD(int fd)
> {
>    int result = io_uring_register_files_update(&ring, fd,
>                       &(socketfds[fd] = fd), 1);
>    printf("enableFD, result = %d\n", result);
> }
> 
> maybe this is due to the below and related work that
> occurred at the end of 5.13 and liburing got out of sync?
> 
> https://github.com/torvalds/linux/commit/992da01aa932b432ef8dc3885fa76415b5dbe43f#diff-79ffab63f24ef28eec3badbc8769e2a23e0475ab1fbe390207269ece944a0824
> 
> and can't use liburing 2.1 because of the api changes since 5.13.

That's very strange, the -EOPNOTSUPP should only be possible if you
are not passing in the ring fd for the register syscall. You should
be able to mix and match liburing versions just fine, the only exception
is sometimes between releases (of both liburing and the kernel) where we
have the liberty to change the API of something that was added before
release.

Can you do an strace of it and attach?

-- 
Jens Axboe

