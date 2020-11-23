Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8652C16CF
	for <lists+io-uring@lfdr.de>; Mon, 23 Nov 2020 21:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgKWUhC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Nov 2020 15:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728798AbgKWUhC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Nov 2020 15:37:02 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78DDC0613CF
        for <io-uring@vger.kernel.org>; Mon, 23 Nov 2020 12:37:01 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id r3so1785310wrt.2
        for <io-uring@vger.kernel.org>; Mon, 23 Nov 2020 12:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C3C3rs8x9y5Cx7cMezRAszwneFA1AdT2RQ/xJmjGBf0=;
        b=obUMvOyzEiz0VPD+s1ksxRXcYqvFi8MC1QCI4tA0uC5fjwwUOMf4xQStQMFBUJbeb/
         izkjipHeg9tPBsnIVKBgkNRe81+/CBWdHZ5xpiOdNLmA/kMcEAjVZna0GBCoBjilGxEa
         tWT+lqBI4DY0msQznqDT0rTNMt326KqMzMaLa0ZHwiRPlmngftArPi8Nhtbbg1oK4BW+
         cn5wznEhFYdQM3tWqMlPMXZnrXUC0B6WkHuQpUbOtqdsRj8Y/YNXXhUQpY4hg3Ba59K0
         kGkyDn5wbspE+PIeYkezGgIRWF0Ysdl7NnWNw8MJgzh1QSkqInWHxsP4ag8AXzBjhZTZ
         7vbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C3C3rs8x9y5Cx7cMezRAszwneFA1AdT2RQ/xJmjGBf0=;
        b=KReBHKu+8wi7LMNe+H0/Eg1M/R+uKI6Xiv4RKGWpUmjiONHB5xX8dl5iteP2XZcv7R
         DtIWoF82jScV5vz0K/1YXTOIU8CvW9STEuVNcQZi/JYylVmXyCTQu7RRJgrq7k2Kdh9q
         xxDMpHwR1gfCQFNnAWVAwrspkz2nGNHs7gnWQ+JPdxdFGNMw3PfDf4z4ZUO8nrK3AWAE
         gjJRhVIwpBRblibzzKXkAN7VtZr3owWFjxl/j8OnDgrSVBrDEHhKE69UJOsf9eJ5hEVK
         UwOC5G88NQ1pYgAcOI5845Mvr1Zy+f6lOa6isIB4FgYTtguSWB0603JGd4/YwuWdrFQM
         T1tw==
X-Gm-Message-State: AOAM531q2L6V6zI+ADA0mOLOnVIgtNhrwFyqyXAKhIZ/zkxVh+GQoNcA
        vjXGYDM+QsLfoZQP9gwjjG0=
X-Google-Smtp-Source: ABdhPJx+x/7prXMHGKAk5EqpcBdga8wrr/dkTaHDb/iMtTA2dqk/D8CU3dBgH+PLB8/FQbz04tHLAA==
X-Received: by 2002:a5d:654c:: with SMTP id z12mr1507046wrv.46.1606163820471;
        Mon, 23 Nov 2020 12:37:00 -0800 (PST)
Received: from [192.168.1.159] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id n123sm741678wmn.38.2020.11.23.12.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 12:36:59 -0800 (PST)
To:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <CAM1kxwjmGd8=992NjY6TjgsbMoxFS5j2_71bgaYUOUT0vG-19A@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC 1/1] whitelisting UDP GSO and GRO cmsgs
Message-ID: <142638c1-8334-e45b-d1d7-b1feb060ff85@gmail.com>
Date:   Mon, 23 Nov 2020 20:33:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwjmGd8=992NjY6TjgsbMoxFS5j2_71bgaYUOUT0vG-19A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/11/2020 15:35, Victor Stewart wrote:
> add __sys_whitelisted_cmsghdrs() and configure __sys_recvmsg_sock and
> __sys_sendmsg_sock to use it.

They haven't been disabled without a reason, and that's not only
because of creds. Did you verify that it's safe to allow those?

> 
> Signed-off by: Victor Stewart <v@nametag.social>
> ---
>  net/socket.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/net/socket.c b/net/socket.c
> index 6e6cccc2104f..44e28bb08bbe 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2416,9 +2416,9 @@ static int ___sys_sendmsg(struct socket *sock,
> struct user_msghdr __user *msg,
>  long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
>                         unsigned int flags)
>  {
> -       /* disallow ancillary data requests from this path */
>         if (msg->msg_control || msg->msg_controllen)
> -               return -EINVAL;
> +               if (!__sys_whitelisted_cmsghdrs(msr))

Its definition below and I don't see a forward declaration anywhere.
Did you even compile this?

> +                       return -EINVAL;
> 
>         return ____sys_sendmsg(sock, msg, flags, NULL, 0);
>  }
> @@ -2620,6 +2620,15 @@ static int ___sys_recvmsg(struct socket *sock,
> struct user_msghdr __user *msg,
>         return err;
>  }
> 
> +static bool __sys_whitelisted_cmsghdrs(struct msghdr *msg)

Don't call it __sys*

> +{
> +       for (struct cmsghdr *cmsg = CMSG_FIRSTHDR(msg); cmsg != NULL;
> cmsg = CMSG_NXTHDR(message, cmsg))

no var declarations in for, run checkpatch.pl first

> +               if (cmsg->cmsg_level != SOL_UDP || (cmsg->cmsg_type !=
> UDP_GRO && cmsg->cmsg_type != UDP_SEGMENT))
> +                       return false;
> +
> +       return true;
> +}
> +
>  /*
>   *     BSD recvmsg interface
>   */
> @@ -2630,7 +2639,7 @@ long __sys_recvmsg_sock(struct socket *sock,
> struct msghdr *msg,
>  {
>         if (msg->msg_control || msg->msg_controllen) {
>                 /* disallow ancillary data reqs unless cmsg is plain data */
> -               if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
> +               if (!( sock->ops->flags & PROTO_CMSG_DATA_ONLY ||

extra space after "("

don't forget about brackets when mixing bitwise and logical and/or

It would look better if you'd get rid of outer brackets and propagate ! 

> __sys_whitelisted_cmsghdrs(msr) ))
>                         return -EINVAL;
>         }
> 

-- 
Pavel Begunkov
