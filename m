Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8292922D9CC
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 22:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgGYUQU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 16:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbgGYUQT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 16:16:19 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C18C08C5C0
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 13:16:19 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id bm28so9407756edb.2
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 13:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t5vJURAxHq7Y8ddCGZrnIeMdu2t257ghwnpLn36Sn8Q=;
        b=pkv0346w2LFBvYPbtdSHNlI4GYt2kkevOCmVhIJ9ZsfDXtSRt0LhujWPPNWcPUj1h1
         cRhhaz7NMc7hdZQdYCJTuVwRqBfmpUv994Us+2CNb3y3j1NFcOCg28u8+v9BVEvSIWgy
         zWYM0kOomWzn8vepSg+zrzlm8TeCeI5FxvMCRo+9UJPoILiXHCcqgAo8kWFMqj8KrFhm
         z0Xh6J9Hy4vdQumjjVujp7snrOyjYL9aoRDVuEmEMiwUSxTOYoGeFOXAQMmLwz6CfmcZ
         HRCP6ejvwh7h5AcEjL+2ez7bkiZw0OACygcgtbn0ksUNBIgiKYI3xAb70I8n20wIdUZt
         qXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t5vJURAxHq7Y8ddCGZrnIeMdu2t257ghwnpLn36Sn8Q=;
        b=lmp/VvaQXjhhJKtoIlG37yYiw98+R94yfjn7EQVwS/DyNMHo4xpMmfE0pPZmDLuGY/
         24MhTT4QYQSSvBikcVY428v0hcg4qaLIzTCWWBZ7KrYmYRKLlw8WAVgA7Ji9upN9aPoC
         9049KL68GrK9f79S+OJ213G7bGiGnDeFvX3pVFViYnt1bA2bEsq8dZhwcigOjTZlnkLT
         t6A7qGR47YmmTbrfMv2UM0UjMYS2ehEtxpu9jkIwIW7wj7XHgzkQ5WCTzLoEjaNRrctj
         RZA/vFq3TU/lzcYkv0lKapIzqQ9U3eNkGrKnyhXAv0ULGSLz12vh1jpJw5Bm2seVgA7c
         X7eA==
X-Gm-Message-State: AOAM530FMIFJjX7yG+dZOqGmEMnQExzb5a7eCeHJh2Ac16rBf31Pk5qp
        bFtFqziZzZrP5vkV6gu0AspTTTmX
X-Google-Smtp-Source: ABdhPJwG9MZEcvnLRgp16QS0DojFzXp7vX6EP/QuMSAzb9utfkCiwMa/4Xz5RvAZb8/oz5yoECoCaQ==
X-Received: by 2002:a05:6402:128c:: with SMTP id w12mr15126807edv.65.1595708177374;
        Sat, 25 Jul 2020 13:16:17 -0700 (PDT)
Received: from [192.168.43.176] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id u60sm3651235edc.59.2020.07.25.13.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2020 13:16:16 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1595664743.git.asml.silence@gmail.com>
 <467e93fb-876d-e2a5-7596-4b9e21317d67@kernel.dk>
 <faf48a78-4327-50e6-083a-f5c762f66e8a@gmail.com>
 <b0ca655f-96ed-a249-6371-bea409b1f065@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC 0/2] 3 cacheline io_kiocb
Message-ID: <8203a1c1-ecf4-1890-d1f0-6cb135cba8cf@gmail.com>
Date:   Sat, 25 Jul 2020 23:14:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b0ca655f-96ed-a249-6371-bea409b1f065@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

 On 25/07/2020 22:40, Jens Axboe wrote:
> On 7/25/20 12:24 PM, Pavel Begunkov wrote:
>> On 25/07/2020 18:45, Jens Axboe wrote:
>>> On 7/25/20 2:31 AM, Pavel Begunkov wrote:
>>>> That's not final for a several reasons, but good enough for discussion.
>>>> That brings io_kiocb down to 192B. I didn't try to benchmark it
>>>> properly, but quick nop test gave +5% throughput increase.
>>>> 7531 vs 7910 KIOPS with fio/t/io_uring
>>>>
>>>> The whole situation is obviously a bunch of tradeoffs. For instance,
>>>> instead of shrinking it, we can inline apoll to speed apoll path.
>>>>
>>>> [2/2] just for a reference, I'm thinking about other ways to shrink it.
>>>> e.g. ->link_list can be a single-linked list with linked tiemouts
>>>> storing a back-reference. This can turn out to be better, because
>>>> that would move ->fixed_file_refs to the 2nd cacheline, so we won't
>>>> ever touch 3rd cacheline in the submission path.
>>>> Any other ideas?
>>>
>>> Nothing noticeable for me, still about the same performance. But
>>> generally speaking, I don't necessarily think we need to go all in on
>>> making this as tiny as possible. It's much more important to chase the
>>> items where we only use 2 cachelines for the hot path, and then we have
>>> the extra space in there already for the semi hot paths like poll driven
>>> retry. Yes, we're still allocating from a pool that has slightly larger
>>> objects, but that doesn't really matter _that_ much. Avoiding an extra
>>> kmalloc+kfree for the semi hot paths are a bigger deal than making
>>> io_kiocb smaller and smaller.
>>>
>>> That said, for no-brainer changes, we absolutely should make it smaller.
>>> I just don't want to jump through convoluted hoops to get there.
>>
>> Agree, but that's not the end goal. The first point is to kill the union,
>> but it already has enough space for that.
> 
> Right
> 
>> The second is to see, whether we can use the space in a better way. From
>> the high level perspective ->apoll and ->work are alike and both serve to
>> provide asynchronous paths, hence the idea to swap them naturally comes to
>> mind.
> 
> Totally agree, which is why the union of those kind of makes sense.
> We're definitely NOT using them at the same time, but the fact that we
> had various mm/creds/whatnot in the work_struct made that a bit iffy.

Thinking of it, if combined with work de-init as you proposed before, it's
probably possible to make a layout similar to the one below

struct io_kiocb {
	...
	struct hlist_node	hash_node;
	struct callback_head	task_work;	
	union {
		struct io_wq_work	work;
		struct async_poll	apoll;
	};
};

Saves ->apoll kmalloc(), and the actual work de-init would be negligibly
rare. Worth to try


> 
>> TBH, I don't think it'd do much, because init of ->io would probably
>> hide any benefit.
> 
> There should be no ->io init/alloc for this test case.

I mean, before getting into io_arm_poll_handler(), it should get -EAGAIN
in io_{read,write}() and initialise ->io in io_setup_async_rw(), at least
for READV, WRITEV.

-- 
Pavel Begunkov
