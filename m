Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397C2428D77
	for <lists+io-uring@lfdr.de>; Mon, 11 Oct 2021 15:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbhJKNCT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Oct 2021 09:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbhJKNCS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Oct 2021 09:02:18 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1034C061570
        for <io-uring@vger.kernel.org>; Mon, 11 Oct 2021 06:00:18 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id d125so3738103iof.5
        for <io-uring@vger.kernel.org>; Mon, 11 Oct 2021 06:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xt9MYELSWvEpJ0wW/+yrbE4Zqn0G14G0+UMfOsbM+5o=;
        b=Lkete0sc59vLMBlceq8C7j5hiytmx1aJFQSnkUqhsPcSrP71KNUYEa+yL8mNL2Z/M2
         XEB5lkaaNqCuply7BNRombhKrsHBQ5/3yEKNTrPMlQsiCoScJScWx/+qIVXF9bbNE2rn
         tcG8L1WTyAr5IAhHzXKKyBI6al3WQtDdartiYcPKWIa8++Qjv82lMGeI6YIkxUQ9N6sf
         gIxQiHvEUNA2tF2+HZ5c8199UlG6+oJIe6mShjAikd3GrfuRnLsgbTWDiIg2zHi4WR6L
         cYJ/V6d2A+EBHXQOuhPtl0K1IlfdZ+wv7gxQyLx+NL4bidxEAFifdic7bCctnpUWBH2Z
         boxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xt9MYELSWvEpJ0wW/+yrbE4Zqn0G14G0+UMfOsbM+5o=;
        b=5ii7ANo6za9QA+RXIZzCLTcimlej2GDPBAC1G5F07CcPPg7BJoKuMUCB2CPXE90djX
         mmN3FZQQL6N0EQp46HkV6kQkI5aoaHD1UfVm+MqOH1jC1EBWVWDVXU1Ss4aEj2kRi9za
         GP6ZeoKcKZOonaf47N4BWKTgpZ0kwv6Efrukfi9UNJkShmRv3i66cxg1ehwfJ8QkaKaJ
         sG5hMC3vjLxd1hkp8dA1A2nPWKJKuuXrE+OCSJ9eJarrUzmdp+XOsUV17Eeh3AM5/ET7
         T8I1GYe5emGMLG1fI3TDNZfCzds+GQmE2VgxoGaRIu231gKgdiZykGyzK8g7LCHDTtfa
         3/Ow==
X-Gm-Message-State: AOAM5310xzeZRePLfzCdkyXNmZKhonQxjc6fJf4cFFiNsuBTYJSs5uoG
        D9cD4iilG/7815fi81srPefc0AEeEFDyAw==
X-Google-Smtp-Source: ABdhPJyI2EOSdr9EOLyBAw0nwfJ9g5aSE0aFP1dgE0gfY69Rhz+gTY4kxcmuKkc75NvpAZ/pXcoX0w==
X-Received: by 2002:a05:6602:2e8f:: with SMTP id m15mr11476540iow.21.1633957218323;
        Mon, 11 Oct 2021 06:00:18 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id i64sm3577985iof.7.2021.10.11.06.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 06:00:17 -0700 (PDT)
Subject: Re: [PATCH liburing] src/nolibc: Fix `malloc()` alignment
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <ae6aa009-765a-82b0-022c-d6696c6d3ee2@kernel.dk>
 <20211011125608.487082-1-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <61055d89-2f4a-2238-e25c-3fb7478b8301@kernel.dk>
Date:   Mon, 11 Oct 2021 07:00:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211011125608.487082-1-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/11/21 6:56 AM, Ammar Faizi wrote:
> On Mon, Oct 11, 2021 at 7:13 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/11/21 12:49 AM, Ammar Faizi wrote:
>>> Add `__attribute__((__aligned__))` to the `user_p` to guarantee
>>> pointer returned by the `malloc()` is properly aligned for user.
>>>
>>> This attribute asks the compiler to align a type to the maximum
>>> useful alignment for the target machine we are compiling for,
>>> which is often, but by no means always, 8 or 16 bytes [1].
>>>
>>> Link: https://gcc.gnu.org/onlinedocs/gcc-11.2.0/gcc/Common-Variable-Attributes.html#Common-Variable-Attributes [1]
>>> Fixes: https://github.com/axboe/liburing/issues/454
>>> Reported-by: Louvian Lyndal <louvianlyndal@gmail.com>
>>> Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
>>> ---
>>>  src/nolibc.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/src/nolibc.c b/src/nolibc.c
>>> index 5582ca0..251780b 100644
>>> --- a/src/nolibc.c
>>> +++ b/src/nolibc.c
>>> @@ -20,7 +20,7 @@ void *memset(void *s, int c, size_t n)
>>>
>>>  struct uring_heap {
>>>       size_t          len;
>>> -     char            user_p[];
>>> +     char            user_p[] __attribute__((__aligned__));
>>>  };
>>
>> This seems to over-align for me, at 16 bytes where 8 bytes would be fine.
>> What guarantees does malloc() give?
>>
> 
> Section 7.20.3 of C99 states this about `malloc()`:
> __The pointer returned if the allocation succeeds is suitably aligned
> so that it may be assigned to a pointer to any type of object.__
> 
> I have just browsed the glibc source code, malloc does give us 16 bytes
> alignment guarantee on x86-64. 
> 
> https://code.woboq.org/userspace/glibc/sysdeps/generic/malloc-alignment.h.html#_M/MALLOC_ALIGNMENT
> 
> Lookie here on Linux x86-64...
> 
> ```
> ammarfaizi2@integral:/tmp$ cat > test.c
> #include <stdio.h>
> int main(void)
> {
> 	printf("alignof = %zu\n", __alignof__(long double));
> 	return 0;
> }
> ammarfaizi2@integral:/tmp$ gcc -o test test.c
> ammarfaizi2@integral:/tmp$ ./test
> alignof = 16
> ammarfaizi2@integral:/tmp$ 
> ```
> 
> We have `long double` which requires 16 byte alignment. So `malloc()`
> should cover this. Although we don't use floating point in liburing,
> it's probably better to have this guarantee as well?

Ah yes, good point. FWIW, I did apply your patch previously, for
alignment it's always better to error on the side of caution.

-- 
Jens Axboe

