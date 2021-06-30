Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D1A3B8A1B
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 23:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhF3Vah (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 17:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhF3Vag (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 17:30:36 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A8FC061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:28:06 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id r3so3067775wmq.1
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=67hfy1zhsvk4jGHuE+q2Rmxz/iZlvD4KuJdTlTnJ5yY=;
        b=HANOiQlW9mM8ppwmgxxp2R1s4ZJdzSAV97vBSlgPx+M8hXQj8YI3EK7iEDOx+V9rTC
         EM9ZpdyOngPJT9duYdMIEDltNYJ+SdA+8kbErHMgAJQnYPf6xCTCKOFt2AUtm8DtKmWK
         sDR6BVKIg8UJ/qUG08CwT8FqsISDYMjs58Ms8WtTUITEPxAARgnFcqa+F6IG9kT/IbtY
         J/NBa2MTT1JK3yEfpFz10aReveb8GA3XRUHeVIn/lc2nLKiyfE9werk5oicS4DqhGppz
         CyKjnipB3aJveAroWx1k4uuK3i7rIBYhNMqp6H8OJYTwHeex6O+HSo07paSIu6Dp/dzB
         83Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=67hfy1zhsvk4jGHuE+q2Rmxz/iZlvD4KuJdTlTnJ5yY=;
        b=p2Ctgsb4QeC+aeDy7gH24gw/grDLFfDb2E4YaR5tuCo4pCw49FbAksRATIXRHFBRlt
         B15dVvk5JUuqbrHH4IfuXQIv3GxFjsVf8jgMgTzAUkXfLH2xHKJIfjq33K2vz1eGk1nW
         TnvpEcCPmxCYczeqKLqXT4imo+wVXQB/1hkMDj2f5cCFrET0MRjLI0HjHxlsjRjtnLwk
         QKMyLCxkgMqUmUPF0PUIldgry2GCJMeaP2P+ZOVzDDCUemP2E14BX3TcLX4X1aTEXR+9
         h39CcgFWmDiHnu0WD/mZWL6w4aH6z6rN0bSk0MoxPXLQh4NtIk8LPCugU2/cC2clkye3
         AHag==
X-Gm-Message-State: AOAM530HGS8rX3dT9dEG3vYGjvaA/UXUcYhVQgnr5SrSgN9nPZfh/2UX
        axvu8zr9T9yL0wPJ0ou6aWjzCmpBGh9vxSyv
X-Google-Smtp-Source: ABdhPJwbdBWP28OW2jgdI+rYnRdBapIwys1r0NloTfEEaLfG4+V3C78GgE9iT6e4PE83gJNFVpn6RQ==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr33291111wmk.51.1625088484642;
        Wed, 30 Jun 2021 14:28:04 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id l16sm7877023wmj.47.2021.06.30.14.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 14:28:04 -0700 (PDT)
Subject: Re: [Bug] io_uring_register_files_update broken
To:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwgU2V0RsE+77mRUg+mr6WL5PJpbFKh4FrEGOnfzZ5vZ3A@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <89a4bff4-958b-d1c0-8dc3-01aface97011@gmail.com>
Date:   Wed, 30 Jun 2021 22:27:47 +0100
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

Thanks for letting know, I'll take a look

 
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
