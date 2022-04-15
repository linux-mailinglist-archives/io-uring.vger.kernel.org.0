Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943685030A1
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiDOWGd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 18:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiDOWGc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 18:06:32 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0B139BBA
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 15:04:00 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so9249633pjk.4
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 15:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=i8pcU3w2IP2jVotN0ne+6H3/DkXYkMFqcIOp43CehCw=;
        b=MsDkNtjySCi0YsM5usfOqa0V17Ay+beBZabBci7RdwLWWer4yB8V6PsqciwXaYdWTv
         thRGxUGnbxGL320+pvCEu2XrBKdiOkcfDEy9txMTO4drhpVs7lnW6thYnLkhh2TF1phu
         IecVPp9YWYrRL+5l2uJCVan/s/oHnWLrU0a9EE8+cIkImrMndrQKOFZi/851BNEj9GLb
         +UjrQbVHe9UghcZiOwNS/XEFOcnYcrs6JdQduxt735I6UsbjWxcOJnbn8UaDyd8dHfKO
         jQvlAtp5KczY8UYWbepO9MlIGn2BiyHhjMSfN1GQytn8GK6XgROUGjiXJiA1PubC4G7Q
         A/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i8pcU3w2IP2jVotN0ne+6H3/DkXYkMFqcIOp43CehCw=;
        b=xXmosHCvKrMv6rM62UI0Pz+Tq7pjlU1VqfM4MpG/h/P9d6Y8bWflot3Lz9M7s1UciM
         wDv6zWUDddzIQaW7YYBq5FgSraLQgDEpSBbl1Q6kfuJ68aMOpm+V6vJOT8b/4ztBlrGa
         qCG9Bmkx8kHeetOBxS5HKUEtoEnIxJ4udiDlX2dZo3AJrvLyVWTd7YwSfwYac6BdY3xZ
         S3JZ6jQ6mBw9ivA3R8iJxLd6AsBFtiII/q3YxMxDVJ/MDT8chNLb3YhiN7p61npsglFk
         /DVFarRG6dR6dXxyevCZSZQvfY9ltShFzU0cEWqpKiyISKF4EqiJVsPDJQqe/1l/71eA
         0rdg==
X-Gm-Message-State: AOAM533jOc0FBKabvPDpJ9BYuRGA/V5+PsxYKmSNooAH8swx3/5aKpYV
        tfVkIhwk8gDL5Zq2K1aNUzJJjg==
X-Google-Smtp-Source: ABdhPJzquVEEDN39B4ddjzvVSdHbwbNcWimcdoIe0BELURU1DBMcHDWTxGNg85Ye4BooZzBK2lhumQ==
X-Received: by 2002:a17:902:bd06:b0:158:8973:b16b with SMTP id p6-20020a170902bd0600b001588973b16bmr807807pls.129.1650060239968;
        Fri, 15 Apr 2022 15:03:59 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id c9-20020a056a00248900b005060a6be89esm3851641pfv.201.2022.04.15.15.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 15:03:59 -0700 (PDT)
Message-ID: <aea01fb7-fa4f-c61a-2655-92129d727a74@kernel.dk>
Date:   Fri, 15 Apr 2022 16:03:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/1] io_uring: fix leaks on IOPOLL and CQE_SKIP
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <c19df8bde9a9ab89425abf7339de3564c96fd858.1649780645.git.asml.silence@gmail.com>
 <7a6eef8a-d09b-89b2-f261-506ae6dae413@kernel.dk>
 <760bb119-6147-99b9-7e5a-c9c3566bfbfc@kernel.dk>
 <b837025e-4c18-322b-094c-6f518335c8ca@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b837025e-4c18-322b-094c-6f518335c8ca@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/15/22 3:05 PM, Pavel Begunkov wrote:
> On 4/12/22 17:46, Jens Axboe wrote:
>> On 4/12/22 10:41 AM, Jens Axboe wrote:
>>> On 4/12/22 10:24 AM, Pavel Begunkov wrote:
>>>> If all completed requests in io_do_iopoll() were marked with
>>>> REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
>>>> io_free_batch_list() leaking memory and resources.
>>>>
>>>> Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
>>>> return the value greater than the real one, but iopolling will deal with
>>>> it and the userspace will re-iopoll if needed. In anyway, I don't think
>>>> there are many use cases for REQ_F_CQE_SKIP + IOPOLL.
>>>
>>> Ah good catch - yes probably not much practical concern, as the lack of
>>> ordering for file IO means that CQE_SKIP isn't really useful for that
>>> scenario.
>>
>> One potential snag is with the change we're now doing
>> io_cqring_ev_posted_iopoll() even if didn't post an event. Again
>> probably not a practical concern, but it is theoretically a violation
>> if an eventfd is used.
> Looks this didn't get applied. Are you concerned about eventfd?

Yep, was hoping to get a reply back, so just deferred it for now.

> Is there any good reason why the userspace can't tolerate spurious
> eventfd events? Because I don't think we should care this case

I always forget the details on that, but we've had cases like this in
the past where some applications assume that if they got N eventfd
events, then are are also N events in the ring. Which granted is a bit
odd, but it does also make some sense. Why would you have more eventfd
events posted than events?

So while I don't think it's a huge issue, and particularly because
IOPOLL and eventfd would be a nonsensical combo, it would still be nice
to generally make sure it's the case.

This isn't the only one though, so maybe we just apply this fix and do
a full check down the line. Can't see this one making issues.

-- 
Jens Axboe

