Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B783B9392
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 16:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhGAOxs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 10:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbhGAOxr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 10:53:47 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDC5C061762
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 07:51:16 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id q18-20020a1ce9120000b02901f259f3a250so4281814wmc.2
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 07:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ItFhC24hLDvLHiPenRlNV6xonWQ1SMJB9u0EsLSiMbE=;
        b=PVGNPjSWtPd6a8WieFgcy0HiqytsWLwfkJMFXhQdeDXNPnyeGIEMQmquKrqea30SzM
         5TUIu/dqdvJDQRcecZ7YRUi36LJh45qgi1P3QfivOQaJCG97Q/J/dgkUtyxsZCfqPiQj
         yIJ0Yw+5dBMLSzNyHVo5AkZqNGcL9oFp3tPFTMersmqPB6RU4kfz94TsJbiHImyE8kdb
         SA19AciXPHlaNlO6nivX/b4x3rNqXHsxOiAum5nD9vMBKzLgzaZhwP65/5gDbe3wTwhW
         wtfba3a10n1SA9X3nn3VuQjWyUVasJzfLGTk45qGXtFqUAP+dguo12rrg3HCgCAIUZN7
         qAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ItFhC24hLDvLHiPenRlNV6xonWQ1SMJB9u0EsLSiMbE=;
        b=QtqFHUKXBmvf7dUuEXW2dS39kfNqF/j0DKAcVZBpcCLBHta6ocFtVQi6xrvjdCPn0S
         kw41htdZbaDOgn49bVlxpb8HgYut7eyM9ldC2eOH82ptmfSojOmycMIdJK2Mq1bQ4NEF
         L4aUdT/cLpaDZVsKLBb9pxcB3UCXMenHnyVKaEudzezzoY33DPy3rvkGX8psI4J0rfYF
         OG/fUWLILdjJMqpJSfr5ThppsplQ2UYTM6FpvGNQ86+Igmo+RUgH5IDtk5XTYIDvJSKd
         rpX/mVBdYQQ1GEFJwcEHDY5IPRGXaozEV6JkYRcE5On6OQ7XndpBWfyl4PXj0EY3vHaw
         y8ag==
X-Gm-Message-State: AOAM531Hxf53/ALy+EdVx25fKdYeUn0Ptb4XFh0pJZfWNvoeGfY2upXq
        2D80hraKpObsYz7iyNgTx6PBTX4TXc3E72zC
X-Google-Smtp-Source: ABdhPJw0LEWNVbgzDohg7MuS28G10FN81DT6NEZfbDOC98yN3h6WbX8fHrfwPncNfhDyKYAW02kiIQ==
X-Received: by 2002:a7b:c8c1:: with SMTP id f1mr77434wml.135.1625151074735;
        Thu, 01 Jul 2021 07:51:14 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id n20sm209187wmk.12.2021.07.01.07.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 07:51:14 -0700 (PDT)
Subject: Re: [Bug] io_uring_register_files_update broken
To:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwgU2V0RsE+77mRUg+mr6WL5PJpbFKh4FrEGOnfzZ5vZ3A@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <5201d747-121d-4e5e-d2a6-9442a5e4c534@gmail.com>
Date:   Thu, 1 Jul 2021 15:50:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwgU2V0RsE+77mRUg+mr6WL5PJpbFKh4FrEGOnfzZ5vZ3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 10:14 PM, Victor Stewart wrote:
> i'm fairly confident there is something broken with
> io_uring_register_files_update,
> especially the offset parameter.
> 
> when trying to update a single fd, and getting a successful result of
> 1, proceeding
> operations with IOSQE_FIXED_FILE fail with -9. but if i update all of
> the fds with
> then my recv operations succeed, but close still fails with -9.
> 
> on Clear LInux 5.12.13-1050.native
> 
> here's a diff for liburing send_recv test, to demonstrate this.
> 
> diff --git a/test/send_recv.c b/test/send_recv.c
> index 19adbdd..492b591 100644
> --- a/test/send_recv.c
> +++ b/test/send_recv.c
> @@ -27,6 +27,8 @@ static char str[] = "This is a test of send and recv
> over io_uring!";
>  #      define io_uring_prep_recv io_uring_prep_read
>  #endif
> 
> +static int *fds;
> +
>  static int recv_prep(struct io_uring *ring, struct iovec *iov, int *sock,
>                      int registerfiles)
>  {
> @@ -54,17 +56,28 @@ static int recv_prep(struct io_uring *ring, struct
> iovec *iov, int *sock,
>                 goto err;
>         }
> 
> +       fds = malloc(100 * sizeof(int));
> +       memset(fds, 0xff, sizeof(int) * 100);
> +
>         if (registerfiles) {
> -               ret = io_uring_register_files(ring, &sockfd, 1);
> +               ret = io_uring_register_files(ring, fds, 100);
>                 if (ret) {
>                         fprintf(stderr, "file reg failed\n");
>                         goto err;
>                 }
> -               use_fd = 0;
> -       } else {
> -               use_fd = sockfd;
> +
> +               fds[sockfd] = sockfd;
> +               int result = io_uring_register_files_update(ring,
> sockfd, fds, 1);

s/fds/&fds[sockfd]/

Does it help? io_uring_register_files_update() doesn't
apply offset parameter to the array, it's used only as
an internal index. 

> +
> +               if (result != 1)
> +               {
> +                       fprintf(stderr, "file update failed\n");
> +                       goto err;
> +               }
>         }
> 
> +       use_fd = sockfd;
> +
>         sqe = io_uring_get_sqe(ring);
>         io_uring_prep_recv(sqe, use_fd, iov->iov_base, iov->iov_len, 0);
>         if (registerfiles)
> 

-- 
Pavel Begunkov
