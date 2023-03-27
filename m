Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B9F6CA23F
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 13:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbjC0LSP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 07:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjC0LSP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 07:18:15 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AE1423A
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 04:18:10 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id ew6so34466349edb.7
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 04:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679915888;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EmbcAoss3ms3vFE/IhF2YD7FkhilTOgjHyDQ5LJPtXg=;
        b=Ke+G+qBpLlek3T8ADTuYZk99ttqc7WgURQBF/Sy6cmhijr1BhW5Chf9kt/gvF+VXub
         dj5RYSNuqkk6OfJUZN0DDxOL+8sN/9ymgBWQrOCacwQzaPhDGZj1FSuNYvjCgBKr6ZGL
         3y9EnsdTN/Malyzsdy8yiNN8wGXacLOZuC1xSRCxiGUOyvO2nwPaYUZzTuhV+n1Txydd
         LCavtObVIEQ2NFViiBtWKuoSZoIQAR8X+dmg/fD8xeTNoza2jc1pJSwMupO5tEieqwyh
         1fj9KLD0dJ5n7NmwTcOELe05bfNKoTYmR2kpyxdW+eqg4tWilIuNBqNwORKIvpZvPgga
         f7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679915888;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EmbcAoss3ms3vFE/IhF2YD7FkhilTOgjHyDQ5LJPtXg=;
        b=JUH6X8G/vrjfC5DLx8aCKEyHcw0fZOOLQL9pvv/dn5SkrhRb6QwSCQ8KB6PU+znd1f
         b+m3MQp/81Gx2pSAU4xVna+V5Y3wFgfYCG+RgSoKJbspeyy3T+KS0J9t0LBJCeLfceaC
         Aor6/Kr0QYSuETmHeUEuFAoE1zQxJ/3sIwPGKccvXTpyyWEV/PhMpKrzsCg+s2OAkT7a
         eSjGGlZxuX2ogqei4FYseIeGusqrNgJjOowK5zSSRwDr+UdjnW5lNo2sHn1pgh3EC7ye
         QejJNYdeKBDtvhZ5T5z4LNB5sGxxiBOwr4UuypSJngJk7Cr/k0yoHJf8qUKay7kWYww+
         NcnQ==
X-Gm-Message-State: AAQBX9e1eZxB5P5DzjLIFvrhJ5VyXk571AiIkxUIy9cobcUcu45zMGna
        SkzAZs8RVV2EUkKV6J8bll8=
X-Google-Smtp-Source: AKy350b1d8ORC3tvEVSuLTW5L44d5OH+/Exo9UJUV1SrL4whhsVYUnio87Q4SF1cPL34gIw7RPYQBw==
X-Received: by 2002:a17:906:36d7:b0:93d:cffb:80ba with SMTP id b23-20020a17090636d700b0093dcffb80bamr11639952ejc.66.1679915888578;
        Mon, 27 Mar 2023 04:18:08 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:1063])
        by smtp.gmail.com with ESMTPSA id p13-20020a1709066a8d00b00932ab7699ffsm13266445ejr.148.2023.03.27.04.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 04:18:08 -0700 (PDT)
Message-ID: <bf407fd2-afd5-43f8-568e-efda1f09ae42@gmail.com>
Date:   Mon, 27 Mar 2023 12:16:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] io_uring/uring_cmd: push IRQ based completions through
 task_work
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshiiitr@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>
References: <4b4e3526-e6b5-73dd-c6fb-f7ddccf19f33@kernel.dk>
 <CA+1E3rKBNhmT63GMNpe-c+EVDpzvs4voTkL-efkdbJHdNZhZ7w@mail.gmail.com>
 <a3c007ee-f324-df9c-56ae-2356f10d76e6@kernel.dk>
 <b488449b-3acc-35dd-1a44-ef6c8193a08d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b488449b-3acc-35dd-1a44-ef6c8193a08d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/23 20:42, Jens Axboe wrote:
> On 3/20/23 2:03?PM, Jens Axboe wrote:
>> On 3/20/23 9:06?AM, Kanchan Joshi wrote:
>>> On Sun, Mar 19, 2023 at 8:51?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> This is similar to what we do on the non-passthrough read/write side,
>>>> and helps take advantage of the completion batching we can do when we
>>>> post CQEs via task_work. On top of that, this avoids a uring_lock
>>>> grab/drop for every completion.

What we should do is to pass in "bool *locked" that we use for
normal tw. I'll prep a patch converting that locked into a structure.

I'd also argue it's better to use tw from commands directly
without a second callback. That would need a couple of helpers.

-- 
Pavel Begunkov
