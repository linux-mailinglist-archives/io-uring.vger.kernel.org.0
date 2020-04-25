Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13ACF1B8950
	for <lists+io-uring@lfdr.de>; Sat, 25 Apr 2020 22:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgDYUX5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Apr 2020 16:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgDYUX5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Apr 2020 16:23:57 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E3FC09B04D
        for <io-uring@vger.kernel.org>; Sat, 25 Apr 2020 13:23:55 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id h69so6448106pgc.8
        for <io-uring@vger.kernel.org>; Sat, 25 Apr 2020 13:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=P0DLyWkcVq8MLNPrkQ0Y9SbFMTDPgRHYLN8ZBk94XGc=;
        b=FNg+5x0RVRRPT+dfrP9Kr6sjLhT3SvlUX9F43DkwhaUtVtXvTcxyQESwaZ3yYN69Fb
         HDPt2Vb9gctGjzWSQevaGWaLIaS6aUNWXrUqZjTwVEODRaCmy8LynrG5mzyMJ2zzV40u
         wqVPFhR36v7Kt0wJE1nGNUK9l3v28uXw6OPM6R60cISOSQaxv3r7Lze24O3CCzRgweoa
         rsDzxGiFipDV/cMXG7p1qJ3k8wMujxknD3PHESeTDjAln8qZcIFEuQnjyM5bRTqjTnqa
         qFwErhEY7aeviv52amuWUhmdcNTV3jDd/hfZ4B9pvsgDe78Byev4Gr8n2Ce8sftVwPpR
         GJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P0DLyWkcVq8MLNPrkQ0Y9SbFMTDPgRHYLN8ZBk94XGc=;
        b=TuLFxU9dbZb2hczC5le+ErcnFU3RRo8nUGVHA665aWTw+ypACwfKlx4xDHXB4byyuB
         GLYrBB2MNsDjMFzAVCoXdDoAveVbv+eD5tAdwLNwRhQTJmgSGDR6RYN4t/dxviFvAjVC
         u4pIVZ+zCN71rqYAh+rdHsbEXgy+rzEbD6xeBuMjIN3hVz+EfKmV+zbl0NGPG6/WDhH8
         CkEmpL9L9uJxeu4SvA6uMo+gDZCHEyzvJg3du3vuqHVCDfRRfL/uJgpIv/0gu1akEIHH
         CczHaDLcqRB7j1CpkBQhyjCVQxRdTa7tqAPcovnhotWBbdnNSYGKiTqk8B6i1ioRv1jc
         Rldg==
X-Gm-Message-State: AGi0Pua5kXK2YHixYdxFGP8TgdL3myWCgCXIw4YJTwSZCW/y9xvw/ttC
        lYLJ41LF6QcnKdvHxSY41SmshA==
X-Google-Smtp-Source: APiQypIz/zg3xiG+bQh/Z+EAAjwlX/l9fOvq6xPmcPz7721CPnRP7jiSD1b7SmM7tdc+9aoPVoabfw==
X-Received: by 2002:a63:3301:: with SMTP id z1mr14772668pgz.81.1587846235163;
        Sat, 25 Apr 2020 13:23:55 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id b12sm8503816pfd.165.2020.04.25.13.23.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 13:23:54 -0700 (PDT)
Subject: Re: io_uring, IORING_OP_RECVMSG and ancillary data
To:     Andreas Smas <andreas@lonelycoder.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
        Jann Horn <jannh@google.com>
References: <CAObFT-S27KXFGomqPZdXA8oJDe6QxmoT=T6CBgD9R9UHNmakUQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f75d30ff-53ec-c3a1-19b2-956735d44088@kernel.dk>
Date:   Sat, 25 Apr 2020 14:23:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAObFT-S27KXFGomqPZdXA8oJDe6QxmoT=T6CBgD9R9UHNmakUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/20 11:29 AM, Andreas Smas wrote:
> Hi,
> 
> Tried to use io_uring with OP_RECVMSG with ancillary buffers (for my
> particular use case I'm using SO_TIMESTAMP for incoming UDP packets).
> 
> These submissions fail with EINVAL due to the check in __sys_recvmsg_sock().
> 
> The following hack fixes the problem for me and I get valid timestamps
> back. Not suggesting this is the real fix as I'm not sure what the
> implications of this is.
> 
> Any insight into this would be much appreciated.

It was originally disabled because of a security issue, but I do think
it's safe to enable again.

Adding the io-uring list and Jann as well, leaving patch intact below.

> diff --git a/net/socket.c b/net/socket.c
> index 2dd739fba866..689f41f4156e 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2637,10 +2637,6 @@ long __sys_recvmsg_sock(struct socket *sock,
> struct msghdr *msg,
>                         struct user_msghdr __user *umsg,
>                         struct sockaddr __user *uaddr, unsigned int flags)
>  {
> -       /* disallow ancillary data requests from this path */
> -       if (msg->msg_control || msg->msg_controllen)
> -               return -EINVAL;
> -
>         return ____sys_recvmsg(sock, msg, umsg, uaddr, flags, 0);
>  }
> 


-- 
Jens Axboe

