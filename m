Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8C15164A3
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 15:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbiEANnF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 09:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbiEANnE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 09:43:04 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C615468E
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 06:39:38 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m2-20020a1ca302000000b003943bc63f98so108787wme.4
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 06:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=/Njd8YQ5vT/AY75AgMY6c0Kq+6nId6ytxrMD5Hi26T4=;
        b=aQM/YAeXJjawdlZaoxlXu0ND7PbvlGpsgW4H3q78b9Upa2aizQg+kQjeqX2xe6pRw0
         ydxjPJxc5bLvMaQ2K2y59wQGYqMfoBJZUla75F4QHznjBajZNcszlYFiZpN7ZJk2mZjQ
         5YE6DaPNWOJe8y9b8Mce3Wr7snwYMLIWxVRet8Oim9Yre9oXCT/URgJ1xfI0yoAFnBIF
         FrkRucen5JxAfCmuXbf/vuq9FvOiOmZdP/Wf/sep38Z5ThorB2RWpI0xuUvZ6OZ6CWof
         2nJEiD/LBXiUr0aJzhfs1BK5PKo/H0ua1RZqkINlqg7537PFN4TwTGVIUbkkQ06ZDC84
         jrlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/Njd8YQ5vT/AY75AgMY6c0Kq+6nId6ytxrMD5Hi26T4=;
        b=lEO03uHDVD8Ck+ozYTo7PCj/PZD+QpUr/4CVlqtYH7XOuHlsQ6mjM1NMeti8DYhUIo
         Rqz+G2x8KfUA4LopVnqXeQvRjp7WAJ7rtE+ywpRih3CPUbkmzcoEOrXa/GHJfQc7WXNs
         2QOV2ZJv7PYvGft2D7UZFtvaiNv4EPiU6n64P5RdUB4XKjLmH5QcayJVY7K6mtGA/VrH
         EKqY3GqeLhp3//QzIoFsog+Acq0y43CkFWHom8MjskWb9bwJNIu68utVSXxqYWkUyuwY
         zk40EgEUMlcK4+jjMpcICMWTIyCRs31Okm3p6bNmszIN9isqUx45aRdsAVUMPpZbQ3zx
         Fzxw==
X-Gm-Message-State: AOAM530QBR9e5U6T5M+o4AqIYeXS81cDP4dytK1rMimZKcNvtJDybxDs
        ykeuDEPATgYxQYsnjfJvndfxk96e8/U=
X-Google-Smtp-Source: ABdhPJxNqUQXQVmBOsW0spJZk+LMpSWGVpL98KLPATaq6VGcw4OKJtrLIL7AThGl6lzj9GrEef6qBw==
X-Received: by 2002:a05:600c:2e08:b0:394:24c:2da4 with SMTP id o8-20020a05600c2e0800b00394024c2da4mr7397317wmf.134.1651412377336;
        Sun, 01 May 2022 06:39:37 -0700 (PDT)
Received: from [192.168.43.77] (82-132-229-198.dab.02.net. [82.132.229.198])
        by smtp.gmail.com with ESMTPSA id w15-20020adfbacf000000b0020c5253d8dbsm4939782wrg.39.2022.05.01.06.39.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 06:39:36 -0700 (PDT)
Message-ID: <170e4200-fb7b-9496-4fcf-48d64212702e@gmail.com>
Date:   Sun, 1 May 2022 14:39:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET v2 RFC 0/11] Add support for ring mapped provided
 buffers
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20220429175635.230192-1-axboe@kernel.dk>
 <69fc3830-8b2e-7b40-ad68-394c7c9fbf60@gmail.com>
 <f7e46c2f-5f38-5d9a-9e29-d04363961a97@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f7e46c2f-5f38-5d9a-9e29-d04363961a97@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/1/22 14:28, Jens Axboe wrote:
> On 5/1/22 7:14 AM, Pavel Begunkov wrote:
>> On 4/29/22 18:56, Jens Axboe wrote:
>>> Hi,
>>>
>>> This series builds to adding support for a different way of doing
>>> provided buffers. The interesting bits here are patch 11, which also has
>>> some performance numbers an an explanation of it.
>>
>> Jens, would be great if you can CC me for large changes, you know
>> how it's with mailing lists nowadays...
> 
> You bet, I can just add you to anything posted. Starting to lose faith
> in email ever becoming reliable again...

thanks


>> 1) reading "io_uring: abstract out provided buffer list selection"
>>
>> Let's move io_ring_submit_unlock() to where the lock call is.
>> In the end, it's only confusing and duplicates unlock in
>> io_ring_buffer_select() and io_provided_buffer_select().
> 
> Sure, I can clean that up.
> 
>> 2) As it's a new API, let's do bucket selection right, I quite
>> don't like io_buffer_get_list(). We can replace "bgid" with
>> indexes into an array and let the userspace to handle indexing.
>> Most likely it knows the index right away or can implement indexes
>> lookup with as many tricks and caching it needs.
> 
> Maybe we can just use xarray here rather than a hashed list? It's really
> just a sparse array. The downside is that xarray locking isn't always
> very convenient, eg using it with your own locking...
> 
> Any other suggestions?

I'd suggest for mapped pbuffers to have an old plain array with
sequential indexing, just how we do it for fixed buffers. Do normal
and mapped pbuffers share something that would prevent it?

-- 
Pavel Begunkov
