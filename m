Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F565693200
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 16:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjBKPdQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 10:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBKPdP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 10:33:15 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC322885A
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 07:33:07 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id d13-20020a17090ad3cd00b0023127b2d602so8489223pjw.2
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 07:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676129586;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3C/YASUIoy+dQcEYZ+F2OwnfV9uUu+22o30wDUIMzBE=;
        b=sbVTZ6emU72abJ/43S9dRNx91cA3NySmKA+Mc39t143FMQvGNsFplK+3YIgAKHCnaO
         4qXaLeE/xNBoI3uIwiSDhFKJkQXYTZFzaENlUPdMc3aV6I+8ZVFouQH4mHwPiQruonYw
         tWb4Q7KwVk1FAImU1/dwnKXcTlRWyzAXk7eIOJRCP+MAo6ivePzNK0yBjdmFWlbPTlw8
         trRQR6EbK1LlwLzCNfMtuRtX+QqmUm8Juw/PWZxxc++sIPYwOlxDM8WDxL4+3Su1gYHF
         uoD76qwrhx95BUZyN/Isod0iE6gRTMIF4kEjzD7OS2CR3r8QHrWLYeLKk9yC8x1WPx1G
         Dvhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676129586;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3C/YASUIoy+dQcEYZ+F2OwnfV9uUu+22o30wDUIMzBE=;
        b=bs/DwQ7WUNQ8r3hWK7cmOUBN2h88Y/NzV+xWASd7UqcfRon0BvHJ/gIt5veTdSWnOe
         vCQB6ZTeKRcZ20Lq1NGtuN/uH93d8MwwAgArIC3SWjI6gQP8AIn8UlnBFntcGwIaAFVR
         ZbzhdhrDBvn+IHWRBT8aPPPmtEX9m4apGp9uhNIpGHSj41Qiqfg61NqxKHLFOaTcDwey
         6ndAtmN9plCSO89mFDRcecJCSAUzwCnIp4srCEIPZKvZN1c1s9CoY70cQjkbefWzTSED
         Lyx7VmxgmD995YO/NhwipWF//Oj5dPzBdVWf1GGL9rIqF8AXjqwhq0W64hp7ZC0jW9Qi
         nObw==
X-Gm-Message-State: AO0yUKUnR9lhcbv4kc9AlAogjllxZ+c9dhMJbiougbfH2JiTbFUHYjXP
        yC2X6vshc6YFcYeHGg1GTFYUlg==
X-Google-Smtp-Source: AK7set8Qp1ZJeY9F/hMzd03j0PcrfY61A4xgg3Ab4f7G8S8p7WiH3f0uEwnVqAVhQtBxa7kXTpS9CA==
X-Received: by 2002:a17:90a:5ae2:b0:230:b356:a35b with SMTP id n89-20020a17090a5ae200b00230b356a35bmr15997262pji.4.1676129586562;
        Sat, 11 Feb 2023 07:33:06 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w23-20020a17090a15d700b0022bf0b0e1b7sm2962226pjd.10.2023.02.11.07.33.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 07:33:06 -0800 (PST)
Message-ID: <787c3b62-f5d8-694d-cd2f-24b40848e39f@kernel.dk>
Date:   Sat, 11 Feb 2023 08:33:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: copy on write for splice() from file to pipe?
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
References: <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk>
 <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
 <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk>
 <CALCETrVx4cj7KrhaevtFN19rf=A6kauFTr7UPzQVage0MsBLrg@mail.gmail.com>
 <b44783e6-3da2-85dd-a482-5d9aeb018e9c@kernel.dk>
 <2bb12591-9d24-6b26-178f-05e939bf3251@kernel.dk>
 <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
 <Y+cJDnnMuirSjO3E@T590> <55eaac9e-0d77-1fa2-df27-4d64e123177e@kernel.dk>
 <Y+euv+zR5ltTELqk@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y+euv+zR5ltTELqk@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/23 8:05 AM, Ming Lei wrote:
> On Sat, Feb 11, 2023 at 07:13:44AM -0700, Jens Axboe wrote:
>> On 2/10/23 8:18?PM, Ming Lei wrote:
>>> On Fri, Feb 10, 2023 at 02:08:35PM -0800, Linus Torvalds wrote:
>>>> On Fri, Feb 10, 2023 at 1:51 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> Speaking of splice/io_uring, Ming posted this today:
>>>>>
>>>>> https://lore.kernel.org/io-uring/20230210153212.733006-1-ming.lei@redhat.com/
>>>>
>>>> Ugh. Some of that is really ugly. Both 'ignore_sig' and
>>>> 'ack_page_consuming' just look wrong. Pure random special cases.
>>>>
>>>> And that 'ignore_sig' is particularly ugly, since the only thing that
>>>> sets it also sets SPLICE_F_NONBLOCK.
>>>>
>>>> And the *only* thing that actually then checks that field is
>>>> 'splice_from_pipe_next()', where there are exactly two
>>>> signal_pending() checks that it adds to, and
>>>>
>>>>  (a) the first one is to protect from endless loops
>>>>
>>>>  (b) the second one is irrelevant when  SPLICE_F_NONBLOCK is set
>>>>
>>>> So honestly, just NAK on that series.
>>>>
>>>> I think that instead of 'ignore_sig' (which shouldn't exist), that
>>>> first 'signal_pending()' check in splice_from_pipe_next() should just
>>>> be changed into a 'fatal_signal_pending()'.
>>>
>>> Good point, here the signal is often from task_work_add() called by
>>> io_uring.
>>
>> Usually you'd use task_sigpending() to distinguis the two, but
>> fatal_signal_pending() as Linus suggests would also work. The only
>> concern here is that since you'll be potentially blocking on waiting for
>> the pipe to be readable - if task does indeed have task_work pending and
>> that very task_work is the one that will ensure that the pipe is now
>> readable, then you're waiting condition will never be satisfied.
> 
> The 2nd signal_pending() will break the loop to get task_work handled,
> so it is safe to only change the 1st one to fatal_signal_pending().

OK, but then the ignore_sig change should not be needed at all, just
changing that first bit to fatal_signal_pending() would do the trick?

-- 
Jens Axboe


