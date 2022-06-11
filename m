Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D005474CC
	for <lists+io-uring@lfdr.de>; Sat, 11 Jun 2022 15:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiFKNSy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jun 2022 09:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbiFKNSx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jun 2022 09:18:53 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3646D963
        for <io-uring@vger.kernel.org>; Sat, 11 Jun 2022 06:18:52 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id a10so742986wmj.5
        for <io-uring@vger.kernel.org>; Sat, 11 Jun 2022 06:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9tmgAWIHJo7Vor14/uNVzdz8kiJ2EFpRTjfMGU1rPIM=;
        b=HNzXqcGKOyVYAliKkUaMkBPzwPLBXCDd/lq7pF0BQL0ke/z//+BrWnJiPL/79SaAu9
         QirhU6uHKjHib6EDCNoY7wKZ2e1P6Y6rGr4shXrLKUdZWhmZeJ4uJnL0nKt+og8OHVhL
         2n4bhJlOcn2iFcI1MqfzDrKj/aVFXsX7sicKBY6A7Deoo6eqeqaW2rjvd7r7lPeAptHm
         uJxtIEx2/CVTbGoQ+BRSzqxxHWf3UNt1Fo05ooARX1F52ivhjp9LMaXmyui0tnCYuhwx
         4nBQ835O+xzZH4cvOkyJux+ubrMkGYteZFv4UzxoAQXBvG2spyiE3SoySldvL/OVsSXv
         9Q6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9tmgAWIHJo7Vor14/uNVzdz8kiJ2EFpRTjfMGU1rPIM=;
        b=mwDWwJ4U5sbVnqs8rIImk238xCOV7zrWIy63Ca6Hab6MXc52PLsNdiUIis9IE2dyug
         vu93r+ET5K8hDZBrAW8MY+1fNSOeNC3lxp+UIhnQSxi7uKD2hqN4gGlSBBK+d3z27kg2
         vDIrhZMJbERUsZNJxDlhTp4awwSY+FTUf+xyjSQmSkWHKSESmolB115cRLbKYTnfGQSt
         H1taIkxwny4HQsr5HYpmTY2O/h66CchhQ2U/JIU7rH0VtyZdxDmP5Dblao2FIUbKOKf2
         Ns2rDv2/GMur5visdwbUS7yctfjrlCpno6CVpbrQSZjSyZ4l7u6XJVG1qYNXeYmIMfF4
         cKYg==
X-Gm-Message-State: AOAM533W89S4Iwja96HEE0fr8rDyvVrwBvz4BjDzN+UZ5YBVqj/6ZvIe
        BcsjzCjWZiuWp2vspgiXbl03aJ7j/N4K2A==
X-Google-Smtp-Source: ABdhPJwLrj8YNJWV2CV9uRbyxJUuposiQE43GxEuzjPGomdQN+goruftU9xyNXtP93CFtzeciqcepg==
X-Received: by 2002:a05:600c:3847:b0:39c:6a85:d20c with SMTP id s7-20020a05600c384700b0039c6a85d20cmr4755882wmr.129.1654953531030;
        Sat, 11 Jun 2022 06:18:51 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id p21-20020a1c5455000000b0039c2e2d0502sm6577357wmi.4.2022.06.11.06.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jun 2022 06:18:50 -0700 (PDT)
Message-ID: <5c3e1323-46ab-27d5-5f9d-d6683a19f9c8@gmail.com>
Date:   Sat, 11 Jun 2022 14:18:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3] io_uring: switch cancel_hash to use per entry spinlock
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220608111259.659536-1-hao.xu@linux.dev>
 <37d73555-197b-29e1-d2cc-b7313501a394@gmail.com>
 <8d60fad9-6445-8a6b-d051-947f8ea04582@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8d60fad9-6445-8a6b-d051-947f8ea04582@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/11/22 05:34, Hao Xu wrote:
> On 6/10/22 18:21, Pavel Begunkov wrote:
>> On 6/8/22 12:12, Hao Xu wrote:
>>> From: Hao Xu <howeyxu@tencent.com>
>>>
>>> Add a new io_hash_bucket structure so that each bucket in cancel_hash
>>> has separate spinlock. Use per entry lock for cancel_hash, this removes
>>> some completion lock invocation and remove contension between different
>>> cancel_hash entries.
>>>
>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>> ---
>>>
>>> v1->v2:
>>>   - Add per entry lock for poll/apoll task work code which was missed
>>>     in v1
>>>   - add an member in io_kiocb to track req's indice in cancel_hash
>>>
>>> v2->v3:
>>>   - make struct io_hash_bucket align with cacheline to avoid cacheline
>>>     false sharing.
>>>   - re-calculate hash value when deleting an entry from cancel_hash.
>>>     (cannot leverage struct io_poll to store the indice since it's
>>>      already 64 Bytes)
>>>
>>>   io_uring/cancel.c         | 14 +++++++--
>>>   io_uring/cancel.h         |  6 ++++
>>>   io_uring/fdinfo.c         |  9 ++++--
>>>   io_uring/io_uring.c       |  8 +++--
>>>   io_uring/io_uring_types.h |  2 +-
>>>   io_uring/poll.c           | 64 +++++++++++++++++++++------------------
>>>   6 files changed, 65 insertions(+), 38 deletions(-)
>>>
>>> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
>>> index 83cceb52d82d..bced5d6b9294 100644
>>> --- a/io_uring/cancel.c
>>> +++ b/io_uring/cancel.c
>>> @@ -93,14 +93,14 @@ int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
>>>       if (!ret)
>>>           return 0;
>>> -    spin_lock(&ctx->completion_lock);
>>>       ret = io_poll_cancel(ctx, cd);
>>>       if (ret != -ENOENT)
>>>           goto out;
>>> +    spin_lock(&ctx->completion_lock);
>>>       if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
>>>           ret = io_timeout_cancel(ctx, cd);
>>> -out:
>>>       spin_unlock(&ctx->completion_lock);
>>> +out:
>>>       return ret;
>>>   }
>>> @@ -192,3 +192,13 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
>>>       io_req_set_res(req, ret, 0);
>>>       return IOU_OK;
>>>   }
>>> +
>>> +inline void init_hash_table(struct io_hash_bucket *hash_table, unsigned size)
>>
>> Not inline, it can break builds
>>
> 
> What do you mean? It's compiled well.

I might be wrong, but IIRC there could be linking issues. Anyway,
it's used only from another obj and the function is cold, so no reason
to have it inline.

-- 
Pavel Begunkov
