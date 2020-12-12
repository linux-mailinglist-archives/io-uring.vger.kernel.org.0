Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882132D888C
	for <lists+io-uring@lfdr.de>; Sat, 12 Dec 2020 18:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392701AbgLLRIC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Dec 2020 12:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392633AbgLLRIA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Dec 2020 12:08:00 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E17BC0613D6
        for <io-uring@vger.kernel.org>; Sat, 12 Dec 2020 09:07:20 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id lj6so2521610pjb.0
        for <io-uring@vger.kernel.org>; Sat, 12 Dec 2020 09:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oD6RgErCgYJ2h0cdTISprgrCuOrDVNN3f4stHhNzj3c=;
        b=03oeuu8jK6rsZfslhOVi87b7yyH2Z6oxvU9OfD/gPLHHNQUwyUxrFqmIa1+kbvMDpo
         iNtKj8UgIQCrQ5bYb/bzEhk5N0sEQfdLwXna1yae14QGSpFZShJ3Qj3ZGbHoE+U2VIjR
         WBwNlp4wOYt/U8+lMtpkmpL0XpXW2ImY0TFLIPkTvTos4YaQBTTvqpJyaVhN4HHeW3dL
         saty5lBT2GfxlQU2bZ5STTdMfndN9czjvWxBokKmCdkpUkHvvLvcFQ7x9ApYwBQe/AA1
         boOs+LyTvwBGP0NtrCz2Khpzh1arVMHQbcp6dE2WdGecSazpby8hd4ffJd+ocT2dzULs
         8MvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oD6RgErCgYJ2h0cdTISprgrCuOrDVNN3f4stHhNzj3c=;
        b=BtwXqZlFnTyntr6l056Co0Gq2T6jvqZNwoPv1q7Fv23SXHe41zjJLLB0eCNHCIL6Ko
         b+LPKc/U0Ifwi9BMsBYwv2guoFO1aU1YJfZxWtuGZZ0Zih2o0bRcKTjJWLqDNabRl7HS
         e4DEcpoydvW03JHEjn7SMUNAKpvmgh+kq6VN/i+wzXA18bTvNvSkaPPw91BcevtTXL9c
         /WtiJqyAI6DQJ1gMGGWgTX8DQFDCRWgxe/crk54xs9Ex0LAKU+YSgbO30zXb+YrLJoZy
         LDQ3SfoMIZMHD6H5dDnAbQIKTWy5EGJgARElcQpY8hSjyOwZAzPwzVJzjmLKiMWaBTLH
         JQIA==
X-Gm-Message-State: AOAM533OwGK8zTcv8UopESGH353MGQ03UzrisGjQ0n6MF6S98YjJbjng
        JuCTa4nyqKXI0EAwlLGZehCR8A==
X-Google-Smtp-Source: ABdhPJz9ZfgXRlU9CqdxAvuxfY1UxOhMJsB4hnJkspcTVN9/W9W70yvdvSD8QzKS7PYWt7hVsjqOGw==
X-Received: by 2002:a17:902:ed44:b029:da:91e5:e09 with SMTP id y4-20020a170902ed44b02900da91e50e09mr15738598plb.24.1607792839159;
        Sat, 12 Dec 2020 09:07:19 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e76sm2735879pfh.157.2020.12.12.09.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 09:07:18 -0800 (PST)
Subject: Re: [PATCH 0/3] PROTO_CMSG_DATA_ONLY for Datagram (UDP)
To:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
References: <CAM1kxwgjCJwSvOtESxWwTC_qcXZEjbOSreXUQrG+bOOrPWdbqA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <750bc4e7-c2ce-e33d-dc98-483af96ff330@kernel.dk>
Date:   Sat, 12 Dec 2020 10:07:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwgjCJwSvOtESxWwTC_qcXZEjbOSreXUQrG+bOOrPWdbqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/12/20 8:31 AM, Victor Stewart wrote:
> RE our conversation on the "[RFC 0/1] whitelisting UDP GSO and GRO
> cmsgs" thread...
> 
> https://lore.kernel.org/io-uring/CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com/
> 
> here are the patches we discussed.
> 
> Victor Stewart (3):
>    net/socket.c: add PROTO_CMSG_DATA_ONLY to __sys_sendmsg_sock
>    net/ipv4/af_inet.c: add PROTO_CMSG_DATA_ONLY to inet_dgram_ops
>    net/ipv6/af_inet6.c: add PROTO_CMSG_DATA_ONLY to inet6_dgram_ops
> 
>    net/ipv4/af_inet.c
>      |   1 +
>    net/ipv6/af_inet6.c
>     |   1 +
>    net/socket.c
>        |   8 +-
>    3 files changed, 7 insertions(+), 3 deletions(-)

Changes look fine to me, but a few comments:

- I'd order 1/3 as 3/3, that ordering makes more sense as at that point it
  could actually be used.

- For adding it to af_inet/af_inet6, you should write a better commit message
  on the reasoning for the change. Right now it just describes what the
  patch does (which is obvious from the change), not WHY it's done. Really
  goes for current 1/3 as well, commit messages need to be better in
  general.

I'd also CC Jann Horn on the series, he's the one that found an issue there
in the past and also acked the previous change on doing PROTO_CMSG_DATA_ONLY.

-- 
Jens Axboe

