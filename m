Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA20622C596
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 14:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgGXMyb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 08:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbgGXMya (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 08:54:30 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495C8C0619D3
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 05:54:30 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id w9so9851652ejc.8
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 05:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/iKCn7y4gSKtJLyQYo52Pcik+KPjDZ7sDnZpCF/hJQ4=;
        b=jahYr4hgaxHReXK5U5ATBJ73j5lUyIKgyv783dV1RXGd3p/z+n2u2OUdtrMuzmmA0C
         MyeW2Wfttfb+9bWExw62O1lU0xiZ+N3mdGdDbhYVSSIedJ2wuN43kOGn87AUcDv9FHeY
         okduuHAXpSvHpmODorZOF1kG60hoNM3roluohjv6J2R8UIVJ1S1vsMklh0pTqYVlmjcy
         J6KqzVITz36xleT5/tUJsTAoDKgE6Np0pa9zXiCZDI7Vdq8CTSPETh+H6ZZbLyjb+dfZ
         ftN3hg2pXebftWhkkj29Hr29sCVWDhCi0bzyc5xnfpdYiClYgCmA5pIR7x0qO/03GwCt
         iI/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/iKCn7y4gSKtJLyQYo52Pcik+KPjDZ7sDnZpCF/hJQ4=;
        b=iilWjdODZIwqVlYehuyx3c0699tffKYKwPGpsfd6PGlBQ5v/i9y4Yr1ggMcDUbGVUu
         g5IlBbpnS4mGgdEeq8ieKsvisOR8xeHYTDMJsbqrqDSBF0tdBXhE4El49CZuLy4QZmFX
         xJ1iqv+Tan/xJ1V6z8It9MBUAUZAgr05WCVE9R+B9Xa0/vc4jqaps8YkqRWemi4IrS4/
         LD5EYNrC5TTGg9s5Vg3tKN9xkYBCFepMJMraw/4ENTgtFIGjKdQS5Bavr7nKJk/T6Ftn
         Mq2obgYlFkmznINz+SY/9GkKZNADuP88KZn1zJIW6whbtemqDWnf5WraFHI5dtRSsBBp
         104w==
X-Gm-Message-State: AOAM530LvTL/KpIMxFcT6kLZuGLLUSnv8ErpNVNarD2K+by6nKy8DvJG
        Yohr4Sa2buMujyTGIt3euUbMnSIs
X-Google-Smtp-Source: ABdhPJy5RwEWf9i1XnWY+k6KNRUtqTmQP+gAt5ZOK7Ffc11DOODCYiePlmMScyqlmS61BDF7bW/sYw==
X-Received: by 2002:a17:906:1187:: with SMTP id n7mr8690987eja.161.1595595268762;
        Fri, 24 Jul 2020 05:54:28 -0700 (PDT)
Received: from [192.168.43.57] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id f10sm598281ejx.95.2020.07.24.05.54.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 05:54:28 -0700 (PDT)
Subject: Re: [RFC][BUG] io_uring: fix work corruption for poll_add
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <eaa5b0f65c739072b3f0c9165ff4f9110ae399c4.1595527863.git.asml.silence@gmail.com>
 <57971720-992a-593c-dc3e-9f5fe8c76f1f@kernel.dk>
 <0c52fec1-48a3-f9fe-0d35-adf6da600c2c@kernel.dk>
 <ae6eca27-c0e2-384f-df89-2cd8b46bd6e6@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <209efa89-fb7f-3be3-4be1-f67477b220f1@gmail.com>
Date:   Fri, 24 Jul 2020 15:52:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ae6eca27-c0e2-384f-df89-2cd8b46bd6e6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/07/2020 15:46, Pavel Begunkov wrote:
> On 24/07/2020 01:24, Jens Axboe wrote:
>> On 7/23/20 4:16 PM, Jens Axboe wrote:
>>> On 7/23/20 12:12 PM, Pavel Begunkov wrote:
>>>> poll_add can have req->work initialised, which will be overwritten in
>>>> __io_arm_poll_handler() because of the union. Luckily, hash_node is
>>>> zeroed in the end, so the damage is limited to lost put for work.creds,
>>>> and probably corrupted work.list.
>>>>
>>>> That's the easiest and really dirty fix, which rearranges members in the
>>>> union, arm_poll*() modifies and zeroes only work.files and work.mm,
>>>> which are never taken for poll add.
>>>> note: io_kiocb is exactly 4 cachelines now.
>>>
>>> I don't think there's a way around moving task_work out, just like it
> 
> +hash_node. I was thinking to do apoll alloc+memcpy as for rw, but this
> one is ugly.
> 
>>> was done on 5.9. The problem is that we could put the environment bits
>>> before doing task_work_add(), but we might need them if the subsequent
>>> queue ends up having to go async. So there's really no know when we can
>>> put them, outside of when the request finishes. Hence, we are kind of
>>> SOL here.
>>
>> Actually, if we do go async, then we can just grab the environment
>> again. We're in the same task at that point. So maybe it'd be better to
>> work on ensuring that the request is either in the valid work state, or
>> empty work if using task_work.
>>
>> Only potential complication with that is doing io_req_work_drop_env()
>> from the waitqueue handler, at least the ->needs_fs part won't like that
>> too much.
> 
> Considering that work->list is removed before executing io_wq_work, it
> should work. And if done only for poll_add, which needs nothing and ends up
> with creds, there shouldn't be any problems. I'll try this out

Except for custom ->creds assigned at the beginning with the personality
feature. Does poll ever use it?

-- 
Pavel Begunkov
