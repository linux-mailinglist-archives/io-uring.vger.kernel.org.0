Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B12A77C45E
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 02:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbjHOASw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 20:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbjHOASf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 20:18:35 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D924C1715
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 17:18:33 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6873f64a290so1361995b3a.0
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 17:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692058713; x=1692663513;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g0IcJGdbfJaJ6PM9s40d6FQBJcjIORSRRYBAgrhIwik=;
        b=c1sOCk2uS6tcLgdCvumIY5fsYn7OWU3pQGtCu9xNGoxpyJ/kSUggizZIfFIMultRZG
         2/4liehzWbTkhEMsBkCuam8gD6oBpnI4wObpjCUgw00EXY/uT2zKFcUALP5XaaRAIfSO
         QBl54YOWYiMct9HBzDI5tDxgzN2xmLViKL7LvlOQsK9RpheNYvrJw97atFOkyKncqhNp
         a2aHBQ+MhATDz5H8I1fkNY3u9vz/gZnwFzlvEjVdH14/QWOAmF6eKpgNMRWT320trq8/
         KBUKLiXplTY2RUv460U48cREef0H9+rt2w2fOFnA1dqcIIk6OygbZlV6QZtr9mwbFQ9L
         rx5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692058713; x=1692663513;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g0IcJGdbfJaJ6PM9s40d6FQBJcjIORSRRYBAgrhIwik=;
        b=VPaS6d+VY4nb/NGD+ZsrVe2OgqFCKtZ99kgW18EmVzO4mIBYCsoqJVDQFZc40Htvvk
         ArgTCJR0+QTvYIHy5gNnbPHbBHq5NMZOw1oxAClJON0Bdfyx9xG/w+YnLHuBd+IbHW7u
         h8eqjJagYwIhYWhmGqmZQ5o70330yNBhDz00Siit1I5jmj7nCiaAr65/CJxdZfZG3Um3
         YkrwmrN8QLkP+Tb72hdbnAF1Le3rK1c9wNsc2SIQH6n53B4cU1N+jzOmNKZiO7ezl9yR
         Cp6SQ1IF7ilB8rqiulPmp/+8axrJ3aSvONIGj0JVr6zbr6XtoUx+g/7kmVVoXj48A5O/
         yUbQ==
X-Gm-Message-State: AOJu0Yx31hP1E+IXj5sktmmIpilpxTw4iYxfQFV0C66l4Zkiyv9cU5OM
        0GxkkD5ruVv6aLrhogEk636iQA==
X-Google-Smtp-Source: AGHT+IGs7E1LejgoAOZW0oOQhIflPh1yO9H6JfabD/As6k4k+KObniWa33OX86QWoreY+R0ofJkCnQ==
X-Received: by 2002:a05:6a20:440d:b0:13d:1ebf:5dfc with SMTP id ce13-20020a056a20440d00b0013d1ebf5dfcmr15370952pzb.5.1692058713014;
        Mon, 14 Aug 2023 17:18:33 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l6-20020a62be06000000b0066f37665a63sm8450712pff.73.2023.08.14.17.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 17:18:32 -0700 (PDT)
Message-ID: <bda49491-4d7f-485f-b929-87a4bec6efaa@kernel.dk>
Date:   Mon, 14 Aug 2023 18:18:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v4] Add io_uring futex/futexv support
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de
References: <20230728164235.1318118-1-axboe@kernel.dk> <87jzugnjzy.ffs@tglx>
 <e136823c-b5c9-b6b3-a0e2-7e9cfda2b2d8@kernel.dk> <875y5rmyqi.ffs@tglx>
 <9153c0bf-405b-7c16-d26c-12608a02ee29@kernel.dk> <87y1idgo3j.ffs@tglx>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87y1idgo3j.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/23 6:12 PM, Thomas Gleixner wrote:
> Jens!
> 
> On Mon, Aug 07 2023 at 12:23, Jens Axboe wrote:
>> On 8/6/23 7:23?PM, Thomas Gleixner wrote:
>>> Go and look at the amount of fallout this has caused in the last years.
>>> io-urine is definitely the leader of the pack in my security@kernel.org
>>> inbox.
>>
>> We're now resorting to name calling? Sorry, but I think that's pretty
>> low and not very professional.
> 
> I'm not resorting to that. If you got offended by the meme which
> happened to elapse into my reply, then I can definitely understand
> that. That was not my intention at all. But you might think about why
> that meme exists in the first place.

It's been there since day 1 because a) the spelling is close, and b)
some people are just childish. Same reason kids in the 3rd grade come up
with nicknames for each others. And that's fine, but most people grow
out of that, and it certainly has no place in what is supposedly a
professional setting.

>>> Vs. the problem at hand. I've failed to catch a major issue with futex
>>> patches in the past and I'm not seeing any reason to rush any of this to
>>> repeat the experience just because.
>>
>> I'm not asking anyone to rush anything.
> 
>  "As we're getting ever closer to the merge window, and I have other
>   things sitting on top of the futex series, that's problematic for me."
> 
> That's your words and how should I pretty please interpret them
> correctly?

Do I need to reorder them? And clearly looks like the answer is yes,
which is fine.

-- 
Jens Axboe

