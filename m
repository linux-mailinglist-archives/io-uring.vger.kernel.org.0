Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1628011FB85
	for <lists+io-uring@lfdr.de>; Sun, 15 Dec 2019 22:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfLOVdf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Dec 2019 16:33:35 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44435 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfLOVdf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Dec 2019 16:33:35 -0500
Received: by mail-pg1-f194.google.com with SMTP id x7so2484169pgl.11
        for <io-uring@vger.kernel.org>; Sun, 15 Dec 2019 13:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kTJ/7PtigGJNtvEy3SeDXyZtHfW7Mm5hgX7oNRog2kI=;
        b=NAZjoJp/q2hXBMAct65XDGFTHIbNGntvM4aNNUhsXLOG35VC4Gc3NnDYztbjfsBeCK
         CB4Wn5uyPaCIzbb0AjjhZ2Kv6BWAhYYt2JJqbUBaO28HlTSAwZUAUJEI9KjCLVZ3YG2W
         GsK3hb+oavZCoo0e9L2It01N+KxOrGro+CAdVOnWAQv0kXvY6u0mM9/7rhtKgas3obRC
         wPGnCfXbc+F+lbc4Fwz0gay5e2dQvrfZimEITY3Olq9dwou3YSWWrSfpQYBs+kEgX80j
         kUVkePhhS8kBqIggYYBRAncTiiVVXdHkojsPfwhUvrpuU1/EBus1tdtB5pZcvuk/L3Ss
         pS7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kTJ/7PtigGJNtvEy3SeDXyZtHfW7Mm5hgX7oNRog2kI=;
        b=E61tSSkv1WmH7zoi1Z/0VHTzRLzXEpMHeaCTT5RVRikDMbjy/YGPxVhouGv78Pa4I1
         Yvs+oTkzcD5y+1swdlOHs5iwuG0b5wcydvuw72NZgUUzVMKCu5aaVmnQ0ot8QrB4q9Lb
         V3SV1CYrzJyfAulQjqFR7zA4V28/Yme5oFaicj4Jb0sWMFvfuGkLhaFGmttb7TFkjYqy
         DGIB47ZmJ+PXsgc8hV0GspcYL0RBJrKQPgkxgs1W4QNj1wnPVzC3oXNUVdvP+Kf7CNP1
         YVa4tFwltgaRACqKG2CyVBXg7mly8XHrb58skGGrNyowk1q7ypXyUteDMYck8Y8Gh1Es
         5Lmg==
X-Gm-Message-State: APjAAAXo4GkHiUopIbZIZwsmn6TPt4xNYhBIzgQKGJbbmRu8sgyOiC9u
        HvDeBJqG0gz944anltiMtdiXMzzcRpsarA==
X-Google-Smtp-Source: APXvYqzdip90VRg3jiwuwYEbS/hK6r4YY+Tg9kZQviVxN2oQopRJMgCbWsQSonf23ER9FT3pjavzbg==
X-Received: by 2002:a63:f60:: with SMTP id 32mr14162830pgp.206.1576445614391;
        Sun, 15 Dec 2019 13:33:34 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id k16sm19654855pfh.97.2019.12.15.13.33.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Dec 2019 13:33:33 -0800 (PST)
Subject: Re: [PATCH v3] io_uring: don't wait when under-submitting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
 <c6f625bdb27ea3b929d0717ebf2aaa33ad5410da.1576335142.git.asml.silence@gmail.com>
 <a1f0a9ed-085f-dd6f-9038-62d701f4c354@kernel.dk>
 <3a102881-3cc3-ba05-2f86-475145a87566@kernel.dk>
 <900dbb63-ae9e-40e6-94f9-8faa1c14389e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9b422273-cee6-8fdb-0108-dc304e4b5ccb@kernel.dk>
Date:   Sun, 15 Dec 2019 14:33:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <900dbb63-ae9e-40e6-94f9-8faa1c14389e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/15/19 8:48 AM, Pavel Begunkov wrote:
> On 15/12/2019 08:42, Jens Axboe wrote:
>> On 12/14/19 11:43 AM, Jens Axboe wrote:
>>> On 12/14/19 7:53 AM, Pavel Begunkov wrote:
>>>> There is no reliable way to submit and wait in a single syscall, as
>>>> io_submit_sqes() may under-consume sqes (in case of an early error).
>>>> Then it will wait for not-yet-submitted requests, deadlocking the user
>>>> in most cases.
>>>>
>>>> In such cases adjust min_complete, so it won't wait for more than
>>>> what have been submitted in the current call to io_uring_enter(). It
>>>> may be less than totally in-flight including previous submissions,
>>>> but this shouldn't do harm and up to a user.
>>>
>>> Thanks, applied.
>>
>> This causes a behavioral change where if you ask to submit 1 but
>> there's nothing in the SQ ring, then you would get 0 before. Now
>> you get -EAGAIN. This doesn't make a lot of sense, since there's no
>> point in retrying as that won't change anything.
>>
>> Can we please just do something like the one I sent, instead of trying
>> to over-complicate it?
>>
> 
> Ok, when I get to a compiler.

Great, thanks. BTW, I noticed when a regression test failed.

-- 
Jens Axboe

