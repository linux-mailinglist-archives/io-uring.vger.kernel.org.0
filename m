Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520332DF571
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 14:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgLTNE3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 08:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgLTNE2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 08:04:28 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377D3C0613CF
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 05:03:48 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id e25so8050101wme.0
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 05:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jllvv0f2pgtulgoaDqbUfUBdAF1lLcOUCciYWbcwFBE=;
        b=dVnIaxCu4FXxvr5wCqfBhIeql7J6vDdzjjDGNtMJ8LOx99nY7wIB4eAzlLRsD91XyD
         0pVqt0gkBFS4ozDyz8hzGfPG5JeDg6np9Q/63XbuWy6kPOR34DpDAlTe/gKHuJ1edS9F
         u0L1LtFAXOXiZhYZXaW6FcnEO6I6TcfvOOV2uqcres8qtwXeajPD5ARhogLFgiC305f1
         D/iPXM/iGFFZVFdaypBVaDDsJwxZGTcNEEuNo8Q65LoEfg78eowGeEa/gFSEQfOv02Uz
         8hDISZ5214SAzh+8wgiU/5IMspUtSSjvID/p98ZRQSCg6QqY/a0/a7S6kUZd6D/rWarE
         nmlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Jllvv0f2pgtulgoaDqbUfUBdAF1lLcOUCciYWbcwFBE=;
        b=EorjS8UcuhPf0GNgHomsjBcCQq8MjVvHHmCWkHsSKlVgNIlGVf+69IBKfuhCaI3Qzn
         gPEaiFdO5tqVhm/4M9lhmeDVZ3ujdhMitOhFPBv/NYTUQ1qR6T47zi4Z9Hy8ZLxCRQ7r
         GT8D3ADZzFJPg4VhZ1mKSdryujNLotu6LPRiCCe+5DiZdEDgqkUax9/VKXN0Y/1hdx6y
         ZKfTiv0cJw6nOTOTye38FW51DiJ6F4Ozk9BM8pJuC/0+aT5gb6clnBZRG+54tQ6FkEMI
         etcdVGKDO7JaT8rKXeaOwqtEEiaH8Cpywyb2Jirp7J0QderoHUECHJQp947AHRAffNcS
         bvgg==
X-Gm-Message-State: AOAM530IceIXpYPB86eies0CO+Qid2kqZR01QeFAlG5AALjNtWZttPhX
        YC5+SzZ8r4TTyfgHxeKppWzZjgXP9xuwww==
X-Google-Smtp-Source: ABdhPJwQKBSEcVxhifyGj0fVkvMhgzYSB1EcEgxJpwDQhAqMFpW3+SrB39a9h/VhPpPrj6nr1PZ2ow==
X-Received: by 2002:a1c:3902:: with SMTP id g2mr11924611wma.117.1608469426379;
        Sun, 20 Dec 2020 05:03:46 -0800 (PST)
Received: from [192.168.8.137] ([85.255.237.164])
        by smtp.gmail.com with ESMTPSA id n9sm22250720wrq.41.2020.12.20.05.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Dec 2020 05:03:45 -0800 (PST)
To:     Josef <josef.grieb@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com>
 <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk>
 <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com>
 <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <df79018a-0926-093f-b112-3ed3756f6363@gmail.com>
 <CAAss7+peDoeEf8PL_REiU6s_wZ+Z=ZPMcWNdYt0i-C8jUwtc4Q@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
Message-ID: <0fb27d06-af82-2e1b-f8c5-3a6712162178@gmail.com>
Date:   Sun, 20 Dec 2020 13:00:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+peDoeEf8PL_REiU6s_wZ+Z=ZPMcWNdYt0i-C8jUwtc4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/12/2020 07:13, Josef wrote:
>> Guys, do you share rings between processes? Explicitly like sending
>> io_uring fd over a socket, or implicitly e.g. sharing fd tables
>> (threads), or cloning with copying fd tables (and so taking a ref
>> to a ring).
> 
> no in netty we don't share ring between processes
> 
>> In other words, if you kill all your io_uring applications, does it
>> go back to normal?
> 
> no at all, the io-wq worker thread is still running, I literally have
> to restart the vm to go back to normal(as far as I know is not
> possible to kill kernel threads right?)
> 
>> Josef, can you test the patch below instead? Following Jens' idea it
>> cancels more aggressively when a task is killed or exits. It's based
>> on [1] but would probably apply fine to for-next.
> 
> it works, I run several tests with eventfd read op async flag enabled,
> thanks a lot :) you are awesome guys :)

Thanks for testing and confirming! Either we forgot something in
io_ring_ctx_wait_and_kill() and it just can't cancel some requests,
or we have a dependency that prevents release from happening.

BTW, apparently that patch causes hangs for unrelated but known
reasons, so better to not use it, we'll merge something more stable.


-- 
Pavel Begunkov
