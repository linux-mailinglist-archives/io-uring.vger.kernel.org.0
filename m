Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81309293E4A
	for <lists+io-uring@lfdr.de>; Tue, 20 Oct 2020 16:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407854AbgJTOKG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Oct 2020 10:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407877AbgJTOKF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Oct 2020 10:10:05 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47588C061755
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 07:10:04 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u19so3519344ion.3
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 07:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VOY3nv9maEdppenXjMXwTE55pzNwaHFeXy2gA7RprRA=;
        b=z5mkJ7dJJzQebX0KlVllYK+trdzy07MQEfkn7bt2WHlG7dtbPG37eJqRv/0K3maQeT
         4DxtfqAG5uf/Kkg/Muwv4dwmz1A9aC9Sw4555OW3EQ0SumYnObBwa9L6fFu2CdtwD+IO
         v3QNezoyLORWopxGXIlEnuVaOPApn4gJllH8Devcq1EIrhGG6E4IdDbzh3bfk7/BiPul
         QQWnjcL770dShT5kJ3xfDEMSZzTQEUN17gEYa+trdyT3cU0w8NMechfO2EUoNBFFto9m
         gNJso0hXpj1IhUIO1WZiKs1TERNkhR8r8BxADsmTODfVOU4t0Ee8Cc93cTcNSubU8Gxr
         X6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VOY3nv9maEdppenXjMXwTE55pzNwaHFeXy2gA7RprRA=;
        b=bmTmPmoyFxXWK+9H6G5IEajDdmKUZqMOyfJGMOP30KbF+e49nIeOibaqlOZCXq6NpL
         iZjKDAuDHS7Z2ieRgHIIFB8qZrjKcszhq1Vi0sGK5Vg4QIKvJQhYXKYmLsKlihgsvj2/
         ji6260K60QcTtSSY/XgszmpEb9yTPzCrYs5ozvpuNhyLLKDvXE+YEVO/9jnGk5cGIEPL
         s/giOlKIudypxcb5oFTuQ8RHPuf7Vh0v/qwxmRw5qAZcqt/90hMawd4jS4u6yQYTfBDY
         n+zF3jDBTV38L4v0X8t/5sgzYERqTnOhG/AWwGUdOw9Cj0w9csPwv0+vGXz0/aoQqKal
         irfw==
X-Gm-Message-State: AOAM5308OZJ9FYQKWgNl9hYqaDCWSmmqCXUNkdlHmdUevBFUkQNlU72m
        qLtwX6a4fhS/BUdtV8IDhlOuyPZZNwbIQg==
X-Google-Smtp-Source: ABdhPJx3D7D668kHF/D+DX9drylTnCmlh9O+pcVgbe2yYOrT2Ngyo/j7lO34qXRVblF5I+n+2R00xQ==
X-Received: by 2002:a02:c85a:: with SMTP id r26mr2089139jao.99.1603203003445;
        Tue, 20 Oct 2020 07:10:03 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f85sm1991707ilh.68.2020.10.20.07.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 07:10:03 -0700 (PDT)
Subject: Re: [PATCH 5.10] io_uring: fix double poll mask init
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1602878022.git.asml.silence@gmail.com>
 <1c2b730ad1b1d0ec12c818457598cca50f4505af.1602878022.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <218af02e-0d69-150a-a964-3c1fa5608726@kernel.dk>
Date:   Tue, 20 Oct 2020 08:10:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1c2b730ad1b1d0ec12c818457598cca50f4505af.1602878022.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/20 1:55 PM, Pavel Begunkov wrote:
> __io_queue_proc() is used by both, poll reqs and apoll. Don't use
> req->poll.events to copy poll mask because for apoll it aliases with
> private data of the request.

Applied, thanks.


-- 
Jens Axboe

