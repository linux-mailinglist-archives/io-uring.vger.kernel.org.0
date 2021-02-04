Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6487630F8C2
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 17:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbhBDQwV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 11:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238034AbhBDQvf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 11:51:35 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85398C0613D6
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 08:50:55 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id s24so3921487iob.6
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 08:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pVTQiofCZ1stYKo41BnrSMSmF1jTtnJ19ouRrfTmYvk=;
        b=teozAPgb+rz5ZeCJhUO/GDUJLt5BiWhYkfEnuq3LAdaS8XJiLSlZ4feqZVTd0Js5bX
         94YjnqG5sGKZeh62s5J97mAdtE+6fB4UKe5o/N76Ay4OWksFs6f/MU7UWKByzap9MO7m
         Iz4MNjIVOC5G6f/ttQBPYvQBJsvHTb8nFp21wAIjXiEeGwhtrthuu5e+h7IAEF37HzEs
         l48ZY4b4w+3eG8lT6gp/6QQsZSsOF6DX+d511QT6A0drzGmFMz43IXpNmIT39zXdY0N1
         4zo224aUd/5zcpWZcKAe6nU+VRfVVGIgXnuNUFO5S7M4wzkQSYf/5ZGcuJrTnrVa8XOh
         sxjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pVTQiofCZ1stYKo41BnrSMSmF1jTtnJ19ouRrfTmYvk=;
        b=nEsCtATsOph8SMFzq0XirYfxNuYCURT09o2tQdAKpHigEQzYvTyc5gG+IOswa0A24A
         PSqA5o7GbypDx721YTwFdmCSxxjH99F9m+NhqfF3be/vE0J+3pC0PhYXUTVtVrY9pfBc
         06VgGyzuFi+bAZWQKPQmTRx5Mz6LVgMWn+OIfUr5fw4ZoNdLD1C43uljgZ68D1mNRRIC
         WnzABSfi0BnXWQ9cGiVRp3nzkQif6umAKOiIsefq7C4Oid3zNfyC49mCE1e6cw+UImB9
         ueQjf93OBE+Kaspn8ioS8S02otlAaIeNQx0ey2hLW+He+JcE24bwPzB/4tbaYijtWZb3
         L3Yw==
X-Gm-Message-State: AOAM531SlUvPwXtd7ytb/T2gr01y3xMkb2/UOwNrQrsnrqyjDhJO+3ci
        OAriioQVTnAsVzubKQfTKTfekYEEnJvHmKip
X-Google-Smtp-Source: ABdhPJw8OY7aitCGP+1dYB68EGqvi32S79aMouwspOO5azToC6L6FyKGZ0DQH521LayrSchKP1iZFg==
X-Received: by 2002:a6b:5110:: with SMTP id f16mr175795iob.89.1612457454585;
        Thu, 04 Feb 2021 08:50:54 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 4sm2908730ilj.22.2021.02.04.08.50.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 08:50:54 -0800 (PST)
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com>
 <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
 <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com>
 <4b44f4e1-c039-a6b6-711f-22952ce1abfb@kernel.dk>
 <CAM1kxwgPW5Up-YqQWdh_cG4jvc5RWsD4UYNWN-jRRbWq5ide5g@mail.gmail.com>
 <06ceae30-7221-80e9-13e3-148cdf5e3c9f@kernel.dk>
 <8d75bf78-7361-0649-e5a3-1288fea1197f@gmail.com>
 <bb75dec2-2700-58ed-065e-a533994d3df7@gmail.com>
 <725fa06a-da7e-9918-49b4-7489672ff0b4@kernel.dk>
 <5c3d084f-88e4-3e86-3560-95d90bb9ffcd@gmail.com>
 <39bc0ff3-db02-8fc7-da5c-b2f5f0fc715e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ab870cb5-513d-420e-6438-b918f9f6c453@kernel.dk>
Date:   Thu, 4 Feb 2021 09:50:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <39bc0ff3-db02-8fc7-da5c-b2f5f0fc715e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/21 4:49 AM, Pavel Begunkov wrote:
> On 02/02/2021 20:56, Pavel Begunkov wrote:
>> On 02/02/2021 20:48, Jens Axboe wrote:
>>> On 2/2/21 1:34 PM, Pavel Begunkov wrote:
>>>> On 02/02/2021 17:41, Pavel Begunkov wrote:
>>>>> On 02/02/2021 17:24, Jens Axboe wrote:
>>>>>> On 2/2/21 10:10 AM, Victor Stewart wrote:
>>>>>>>> Can you send the updated test app?
>>>>>>>
>>>>>>> https://gist.github.com/victorstewart/98814b65ed702c33480487c05b40eb56
>>>>>>>
>>>>>>> same link i just updated the same gist
>>>>>>
>>>>>> And how are you running it?
>>>>>
>>>>> with SQPOLL    with    FIXED FLAG -> FAILURE: failed with error = ???
>>>>> 	-> io_uring_wait_cqe_timeout() strangely returns -1, (-EPERM??)
>>>>
>>>> Ok, _io_uring_get_cqe() is just screwed twice
>>>>
>>>> TL;DR
>>>> we enter into it with submit=0, do an iteration, which decrements it,
>>>> then a second iteration passes submit=-1, which is returned back by
>>>> the kernel as a result and propagated back from liburing...
>>>
>>> Yep, that's what I came up with too. We really just need a clear way
>>> of knowing when to break out, and when to keep going. Eg if we've
>>> done a loop and don't end up calling the system call, then there's
>>> no point in continuing.
>>
>> We can bodge something up (and forget about it), and do much cleaner
>> for IORING_FEAT_EXT_ARG, because we don't have LIBURING_UDATA_TIMEOUT
>> reqs for it and so can remove peek and so on.
> 
> This version looks reasonably simple, and even passes tests and all
> issues found by Victor's test. Didn't test it yet, but should behave
> similarly in regard of internal timeouts (pre IORING_FEAT_EXT_ARG).
> 
> static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
> 			     struct get_data *data)
> {
> 	struct io_uring_cqe *cqe = NULL;
> 	int ret = 0, err;
> 
> 	do {
> 		unsigned flags = 0;
> 		unsigned nr_available;
> 		bool enter = false;
> 
> 		err = __io_uring_peek_cqe(ring, &cqe, &nr_available);
> 		if (err)
> 			break;
> 
> 		/* IOPOLL won't proceed when there're not reaped CQEs */
> 		if (cqe && (ring->flags & IORING_SETUP_IOPOLL))
> 			data->wait_nr = 0;
> 
> 		if (data->wait_nr > nr_available || cq_ring_needs_flush(ring)) {
> 			flags = IORING_ENTER_GETEVENTS | data->get_flags;
> 			enter = true;
> 		}
> 		if (data->submit) {
> 			sq_ring_needs_enter(ring, &flags);
> 			enter = true;
> 		}
> 		if (!enter)
> 			break;
> 
> 		ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
> 					    data->wait_nr, flags, data->arg,
> 					    data->sz);
> 		if (ret < 0) {
> 			err = -errno;
> 			break;
> 		}
> 		data->submit -= ret;
> 	} while (1);
> 
> 	*cqe_ptr = cqe;
> 	return err;
> }

So here's my take on this - any rewrite of _io_uring_get_cqe() is going
to end up adding special cases, that's unfortunately just the nature of
the game. And since we're going to be doing a new liburing release very
shortly, this isn't a great time to add a rewrite of it. It'll certainly
introduce more bugs than it solves, and hence regressions, no matter how
careful we are.

Hence my suggestion is to just patch this in a trivial kind of fashion,
even if it doesn't really make the function any prettier. But it'll be
safer for a release, and then we can rework the function after.

With that in mind, here's my suggestion. The premise is if we go through
the loop and don't do io_uring_enter(), then there's no point in
continuing. That's the trivial fix.


diff --git a/src/queue.c b/src/queue.c
index 94f791e..4161aa7 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -89,12 +89,13 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 {
 	struct io_uring_cqe *cqe = NULL;
 	const int to_wait = data->wait_nr;
-	int ret = 0, err;
+	int err;
 
 	do {
 		bool cq_overflow_flush = false;
 		unsigned flags = 0;
 		unsigned nr_available;
+		int ret = -2;
 
 		err = __io_uring_peek_cqe(ring, &cqe, &nr_available);
 		if (err)
@@ -117,7 +118,9 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 			ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
 					data->wait_nr, flags, data->arg,
 					data->sz);
-		if (ret < 0) {
+		if (ret == -2) {
+			break;
+		} else if (ret < 0) {
 			err = -errno;
 		} else if (ret == (int)data->submit) {
 			data->submit = 0;

-- 
Jens Axboe

