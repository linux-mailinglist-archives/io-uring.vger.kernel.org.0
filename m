Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032292F903B
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 03:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbhAQCop (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 21:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbhAQCom (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 21:44:42 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AFCC061574;
        Sat, 16 Jan 2021 18:44:01 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id w5so13107824wrm.11;
        Sat, 16 Jan 2021 18:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g1QKw7DXIHG+0vLmIynk0BbRd5eLjY9wmjeLShYE7II=;
        b=pgGEZRPwYZPv0OJr0uZF0+rtJk1rArVq87vytL0vDZLdGSwAfe0ibY4R22uA08RjXq
         JqyveLv/b3B+kR67JXhGKpeLfd1124DFNTDeGtz4SO/he4uR+3LiOM4xUnCK4degraDl
         v1/3nT4GKagvUEMmgBa1Du5ckg5u2Hpy5LE9ZE3XXmJMgIu/vgtfIE8RIbtIivP8ujGu
         AdWOKYyBbso/zOVqbYE3AtNhWzJBi4T6t8U4l9Z6ksZOMyicxOa7iPr3mE05YQS8+ai/
         PNM2dh/F4PQnPPMb2xCKnVfQsMnTXFL1m1TJrD/L/Clm4InHfC0eVswIvAsn4MRGPUyj
         vZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=g1QKw7DXIHG+0vLmIynk0BbRd5eLjY9wmjeLShYE7II=;
        b=byBttcdcuCh/5qd4Waz/DkM5F/c5tC9xIKbyW1ZEk7zH6lMmNAeyK6fwX8Z3NkuLBy
         rxOLz+PDtDvm4GnRdpkjaMliec97YquIBF8wbFd2V3QqSxlC7s65PcegQFb2Ffb3/+1E
         EahgSGRVOD92T9U4tZlm3rxyb4NuoXGlaAewNyY0WdCnUgY/eeMg1apCAeShmrJhv3s/
         hXoteqhKrkU6wwuUBJ0UkmVSXrftrS6KndH2Cc1ZZmhQ1nJTHYHJ7lV2qfGYYJBu18Gs
         VAhUEV572owfGr48ajeXCvMVic1jkwd6sQQp6SSiqYNe7fxQn5Pu9jXGNOaRqCiC9dUx
         9G9Q==
X-Gm-Message-State: AOAM533B+Kg+Oc+iIDTnCvLHYFDkobjRDQIZTjwRHxpkayQ0mMtioJ2H
        TIcgSRpvf3uGlZOJ8OvKUJE=
X-Google-Smtp-Source: ABdhPJyU2JuYGPYkfSzm8bsMWgfiK8grR08tfaY+z60lC1tn74hShT9vkS6gnbNeaiEkgO3f6m/elA==
X-Received: by 2002:a5d:5105:: with SMTP id s5mr13919570wrt.252.1610851438997;
        Sat, 16 Jan 2021 18:43:58 -0800 (PST)
Received: from [192.168.8.130] ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id g10sm11716515wmq.3.2021.01.16.18.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 18:43:58 -0800 (PST)
To:     Hillf Danton <hdanton@sina.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        syzbot+a32b546d58dde07875a1@syzkaller.appspotmail.com
References: <cover.1610774936.git.asml.silence@gmail.com>
 <20210117023108.3748-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/2] io_uring: fix uring_flush in exit_files() warning
Message-ID: <4a938355-94f4-4b90-f10e-270df7c2a0d9@gmail.com>
Date:   Sun, 17 Jan 2021 02:40:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210117023108.3748-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/01/2021 02:31, Hillf Danton wrote:
> On Sat, 16 Jan 2021 05:32:30 +0000 Pavel Begunkov wrote:
>>
>> @@ -9126,7 +9126,10 @@ static int io_uring_flush(struct file *file, void *data)
>>  
>>  	if (ctx->flags & IORING_SETUP_SQPOLL) {
>>  		/* there is only one file note, which is owned by sqo_task */
>> -		WARN_ON_ONCE((ctx->sqo_task == current) ==
>> +		WARN_ON_ONCE(ctx->sqo_task != current &&
>> +			     xa_load(&tctx->xa, (unsigned long)file));
>> +		/* sqo_dead check is for when this happens after cancellation */
>> +		WARN_ON_ONCE(ctx->sqo_task == current && !ctx->sqo_dead &&
>>  			     !xa_load(&tctx->xa, (unsigned long)file));
>>  
>>  		io_disable_sqo_submit(ctx);
> 
> The added sqo_dead flag can not only quiesce a warning but save a
> disabling dryrun.

Don't think I get the sentence. Do you see any issue?

sqo_dead has a practical meaning, it prevents SQPOLL task from poking
into the creator task when it's racy. But yes, also in some cases makes
draining and killing rings nicer. 

-- 
Pavel Begunkov
