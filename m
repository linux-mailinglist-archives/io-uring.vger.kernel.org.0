Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4E05372F5
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 01:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiE2Xeh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 May 2022 19:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiE2Xef (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 May 2022 19:34:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5E51EAE5
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 16:34:34 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id w2-20020a17090ac98200b001e0519fe5a8so9134941pjt.4
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 16:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=1wOZwRv1ZPMm+zlhtEWx6a4e/N/BUitocqYkWWE6G7o=;
        b=OxgnKd4AyQx9/PqKPpzEhpYTWJBKJWo4TwQj8QOmbrDuMKsZH0Q84KHZfFnU6T+qlu
         Ewf/DmbQoNPyyK1pRMpm8LH2OkoYhKv7MsXavDEOYzFaZd+B1viwR149vIgbdRukjuZg
         MtoHN+zBw5Dc1FAii1QFjF6f5PiVTZLrNmEj24/JFTVn2HckC3HLP7XiExzYYcjmsa+b
         zE8cY97vDeKHLC7z6UJrPsy/9uAiLAa2ytFOpcnv+Yjz9fs1os7SXnQmWG9QJ0RBvQBE
         XzpiI2YCzVd+NJk0b0TvXnfgedfflDJU7DqF2rYgIxfn3lyywzUsWSAUdrTkiS5kH4t5
         giLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1wOZwRv1ZPMm+zlhtEWx6a4e/N/BUitocqYkWWE6G7o=;
        b=VwcKVI866L4nJ8zPbYdS90WWZ+3JbCWEZxU7rcuTmJGCywJdGfo6btRnJLzyLuft3s
         oa3frXAEVURG6Ik7VAKo/wJXvvLppHFe62Mt4ezr3F8R/AC9gHso91796mOyBifClYgp
         nEN4jURB54f8O2vQdRJTxpHYnkbUqivM2CixUQTGdzN5N9Ve818MIqWLVDVxlY6PIlIx
         YRO1b+4pwZf0PWrEXO0TVF97wJv35HosvWyrhQNv3P+2kL4dpwKPPDZfNLQRl54mKcBz
         8ihr9pfB6FOgPUWwieLmLiJ2u+/HX4WYBOImus3v8Ge+QgDDMkG9GoKOBbp5SJIYWfjO
         DILQ==
X-Gm-Message-State: AOAM531CDIqACI6kNCjfncsPuhmYP08jA/KgnVNeflHVhuKhkHY+lvpC
        yvxeNhemS8fcnrDAq3nqw8Q7uQ==
X-Google-Smtp-Source: ABdhPJxSAmi8ZJkv9kERlc3WEYlkJFDo3kR5+u00HGCQDvKUlT8DZ83e6ocjVyC2zsfn5aqbStzb7g==
X-Received: by 2002:a17:903:2308:b0:163:ad36:900c with SMTP id d8-20020a170903230800b00163ad36900cmr9544317plh.100.1653867273146;
        Sun, 29 May 2022 16:34:33 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ik19-20020a170902ab1300b0015e8d4eb283sm4278614plb.205.2022.05.29.16.34.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 May 2022 16:34:32 -0700 (PDT)
Message-ID: <a939481d-98b5-2c40-4b76-74b89319ddba@kernel.dk>
Date:   Sun, 29 May 2022 17:34:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] io_uring: switch cancel_hash to use per list spinlock
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
References: <20220529162000.32489-1-haoxu.linux@icloud.com>
 <20220529162000.32489-3-haoxu.linux@icloud.com>
 <37c50986-8a47-5eb4-d416-cbbfd54497b0@kernel.dk>
 <2c7bf862-5d94-892c-4026-97e85ba78593@icloud.com>
 <2ed2d510-759b-86fb-8f31-4cb7522c77e6@kernel.dk>
 <d476c344-56ea-db57-052a-876605662362@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d476c344-56ea-db57-052a-876605662362@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/29/22 4:50 PM, Pavel Begunkov wrote:
> On 5/29/22 19:40, Jens Axboe wrote:
>> On 5/29/22 12:07 PM, Hao Xu wrote:
>>> On 5/30/22 00:25, Jens Axboe wrote:
>>>> On 5/29/22 10:20 AM, Hao Xu wrote:
>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>
>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>
>>>>> Use per list lock for cancel_hash, this removes some completion lock
>>>>> invocation and remove contension between different cancel_hash entries
>>>>
>>>> Interesting, do you have any numbers on this?
>>>
>>> Just Theoretically for now, I'll do some tests tomorrow. This is
>>> actually RFC, forgot to change the subject.
>>>
>>>>
>>>> Also, I'd make a hash bucket struct:
>>>>
>>>> struct io_hash_bucket {
>>>>      spinlock_t lock;
>>>>      struct hlist_head list;
>>>> };
>>>>
>>>> rather than two separate structs, that'll have nicer memory locality too
>>>> and should further improve it. Could be done as a prep patch with the
>>>> old locking in place, making the end patch doing the per-bucket lock
>>>> simpler as well.
>>>
>>> Sure, if the test number make sense, I'll send v2. I'll test the
>>> hlist_bl list as well(the comment of it says it is much slower than
>>> normal spin_lock, but we may not care the efficiency of poll
>>> cancellation very much?).
>>
>> I don't think the bit spinlocks are going to be useful, we should
>> stick with a spinlock for this. They are indeed slower and generally not
>> used for that reason. For a use case where you need a ton of locks and
>> saving the 4 bytes for a spinlock would make sense (or maybe not
>> changing some struct?), maybe they have a purpose. But not for this.
> 
> We can put the cancel hashes under uring_lock and completely kill
> the hash spinlocking (2 lock/unlock pairs per single-shot). The code
> below won't even compile and missing cancellation bits, I'll pick it
> up in a week.
> 
> Even better would be to have two hash tables, and auto-magically apply
> the feature to SINGLE_SUBMITTER, SQPOLL (both will have uring_lock held)
> and apoll (need uring_lock after anyway).

My hope was that it'd take us closer to being able to use more granular
locking for hashing in general. I don't care too much about the
cancelation, but the normal hash locking would be useful to do.

However, for cancelations, under uring_lock would indeed be preferable
to doing per-bucket locks there. Guess I'll wait and see what your final
patch looks like, not sure why it'd be a ctx conditional?

What about io_poll_remove_all()?

-- 
Jens Axboe

