Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188AC14EFE5
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 16:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgAaPlv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 10:41:51 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:32946 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbgAaPlv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 10:41:51 -0500
Received: by mail-il1-f196.google.com with SMTP id s18so6530197iln.0
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 07:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bt/QheAZ930twwioViVJw8WXYDgWI7UHXp6ZgLfEFvU=;
        b=A6Y2AxBNtVwdIYHMVc3HVU8q/VzulMbzj/3/CIXAT1NEl9g+rtYxLOZL0iajhtIH2h
         MiLriuEA35OxvITi1H1wcLnMy7zEM42kjWp+nV44p6Hs6yBhBUfYF+CthIJYAayJ+nuX
         KCQQixMqG90XFFpLWL+nGFGJg9T506YOP0lJW6PDhMwqcDTVKct76WRd6XFLaMwx9Bkn
         uEPZ5feqGTRx9pGjZYNwqYBDDal5sa/0x7x1nfjPOy+8A/wZoVtP/FpcAUGoMrx6NeH8
         OxL2xDbd8/HQGw316yFtDyGmr6CYXUjoHNSbCIXsqxQx0jR0aDHoNuccm35OKtmQ3Fpg
         eIYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bt/QheAZ930twwioViVJw8WXYDgWI7UHXp6ZgLfEFvU=;
        b=RxbHk/CFgvicNQIBqxy1dpqNFF/m8kwJfA2xLoKO62r338zMYW0TEvP5SoIw/Df2Ob
         wC2ls60REbLGD4xRlJDamAtCAcXez4ouU7iMwu05Ef7f8EcJMtBLVMPXSRYc5O69hV7x
         2yqO/J1yw641PDZZgSkZZlbe4eMiGRimXcRgNjtQ/F2GA0L2GIjLoNajrDJzhXqmvCF2
         obqDQkhn4wvOc17MwhPo9Oj8XHK24s5ctt+x34O15wOZFrHJ/w8gtq1Awe1EsLcjE4vi
         X00aZC4WocTt7GTt3juMyBWQuUHwP6Glwc2/uTIYvOuFfXLR43VOxr19wJEwmemqy8zu
         2zuw==
X-Gm-Message-State: APjAAAVnIYe9fnhdbLDqv10FTXMjn9U8pYSq25EJHdZJMVEhbQrQTLI8
        Z5BwWI6/jR3oLAJqztZs8hrJPpmJphg=
X-Google-Smtp-Source: APXvYqzmFO+FwGR8L2EL82Fy4qUmOkX9hKN8xdZIQNl3E/nj/xI2hVeg29FnzUN/wjKuFPY47A0oeQ==
X-Received: by 2002:a05:6e02:4cc:: with SMTP id f12mr3138757ils.90.1580485310666;
        Fri, 31 Jan 2020 07:41:50 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s88sm3276032ilk.79.2020.01.31.07.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 07:41:50 -0800 (PST)
Subject: Re: [PATCH liburing v2 1/1] test: add epoll test case
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20200131142943.120459-1-sgarzare@redhat.com>
 <20200131142943.120459-2-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <00610b2b-2110-36c2-d6ce-85599e46013f@kernel.dk>
Date:   Fri, 31 Jan 2020 08:41:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200131142943.120459-2-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/31/20 7:29 AM, Stefano Garzarella wrote:
> This patch add the epoll test case that has four sub-tests:
> - test_epoll
> - test_epoll_sqpoll
> - test_epoll_nodrop
> - test_epoll_sqpoll_nodrop

Since we have EPOLL_CTL now, any chance you could also include
a test case that uses that instead of epoll_ctl()?

-- 
Jens Axboe

