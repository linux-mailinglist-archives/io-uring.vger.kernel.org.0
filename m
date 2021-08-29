Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039833FA840
	for <lists+io-uring@lfdr.de>; Sun, 29 Aug 2021 04:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbhH2ClE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 22:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhH2ClD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 22:41:03 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF84C061756
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 19:40:12 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id b200so14656243iof.13
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 19:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VVQ58wWCFWo+ENnSsbpVVZbqE1o12xtzPrRpid8JViA=;
        b=VhjjouVnGgRmCJ4LOwUCgTiMeTrdSBB45Q9aZXgLHOvGg4n/jm0PX706Aq+dfxEg15
         9zgX3QU+WKrxoPUfP+Q4AP7mp3mY1P7YSAhyKUK5gIgmPTRpbM4P5ByFdcnm+NF05X8/
         8zlA5Amk8sXubEOjODfFRB+cU8OEpYGtAjiPff9wi8xrQ2gUFmDWdphB7qw7uOWt/bso
         JBqvsbD4Bzg6jYCEUWJqFu6SdY8XRtimdUj5FxP98KKU831avjAX7DEm8Ya8yfIzpf1y
         /YzBCXJFEQuRLTOo36aWVaZkrUXILUqMnhbgCRED+YwjzRbN2Wqjxs2gVWbenYyJu9lH
         7zaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VVQ58wWCFWo+ENnSsbpVVZbqE1o12xtzPrRpid8JViA=;
        b=jifhUnmQhLA3acURKxwqLw+UiZppfRfEKe2i6kQthwAICSjF3EBLERQtTeEgOn+gIP
         YBN9++Es+ErzwoZeyvNipNY+AT0EQGFi7l3qxXasH4fpc/Kc334dR5Tw4W5CuXogCyvh
         Kyfxo6gkp1tqHDNQe1nIBAam6EVp7dsKwhcCzZpVHf2yDVyvNAB9qQzIcJcYH4Z76EQW
         YE6BWKizLI16BChfHWb3mQFrMpYAJ2DvRtYJ82grHbVNNk0hVlCxLzqQE0dI4MSUCDir
         kh5LRoD8INNi+Yvig/Fj65hzITOisc1W+HQukJfbAvc9EXOm8h4vODhoet45Qqe3kIxb
         PBRg==
X-Gm-Message-State: AOAM532rTDlC2chIqixsGzvHqCbn5N1ItsYpKLoKBPzi4IXQdrlkivQL
        VygJjrhn2Pfguc41NmRLiNqdSZIkLM/xvg==
X-Google-Smtp-Source: ABdhPJxSX/yu0Okk5XB7WHgn4EMFcRUY3MY7KL0ND/zDridrtw857zRTKQ29+Hzqigl9Tbz+zHAY+A==
X-Received: by 2002:a02:664e:: with SMTP id l14mr14721244jaf.56.1630204811437;
        Sat, 28 Aug 2021 19:40:11 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id g8sm5930103ild.31.2021.08.28.19.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Aug 2021 19:40:11 -0700 (PDT)
Subject: Re: io_uring_prep_timeout_update on linked timeouts
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhHOt1Ni==4Qr6c+qGzQQ2R9SQR4COkG2MXn_SUzEG-cg@mail.gmail.com>
 <CAM1kxwi83=Q1Br46=_3DH46Ep2XoxbRX5hOVwFs7ze87Osx_eg@mail.gmail.com>
 <CAM1kxwiAF3tmF8PxVf6KPV+Qsg_180sFvebxos5ySmU=TqxgmA@mail.gmail.com>
 <1b3865bd-f381-04f3-6e54-779fe6b43946@kernel.dk>
 <04e3c4ab-4e78-805c-bc4f-f9c6d7e85ec1@gmail.com>
 <b53e6d69-9591-607b-c391-bf5fed23c1af@kernel.dk>
 <ebf4753c-dbe4-f6b5-e79c-39cc9a608beb@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <66bf3640-a396-28cf-0b0d-8f3a9622ce2b@kernel.dk>
Date:   Sat, 28 Aug 2021 20:40:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ebf4753c-dbe4-f6b5-e79c-39cc9a608beb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/28/21 3:38 PM, Pavel Begunkov wrote:
> On 8/28/21 2:43 PM, Jens Axboe wrote:
>> On 8/28/21 7:39 AM, Pavel Begunkov wrote:
>>> On 8/28/21 4:22 AM, Jens Axboe wrote:
>>>> On 8/26/21 7:40 PM, Victor Stewart wrote:
>>>>> On Wed, Aug 25, 2021 at 2:27 AM Victor Stewart <v@nametag.social> wrote:
>>>>>>
>>>>>> On Tue, Aug 24, 2021 at 11:43 PM Victor Stewart <v@nametag.social> wrote:
>>>>>>>
>>>>>>> we're able to update timeouts with io_uring_prep_timeout_update
>>>>>>> without having to cancel
>>>>>>> and resubmit, has it ever been considered adding this ability to
>>>>>>> linked timeouts?
>>>>>>
>>>>>> whoops turns out this does work. just tested it.
>>>>>
>>>>> doesn't work actually. missed that because of a bit of misdirection.
>>>>> returns -ENOENT.
>>>>>
>>>>> the problem with the current way of cancelling then resubmitting
>>>>> a new a timeout linked op (let's use poll here) is you have 3 situations:
>>>>>
>>>>> 1) the poll triggers and you get some positive value. all good.
>>>>>
>>>>> 2) the linked timeout triggers and cancels the poll, so the poll
>>>>> operation returns -ECANCELED.
>>>>>
>>>>> 3) you cancel the existing poll op, and submit a new one with
>>>>> the updated linked timeout. now the original poll op returns
>>>>> -ECANCELED.
>>>>>
>>>>> so solely from looking at the return value of the poll op in 2) and 3)
>>>>> there is no way to disambiguate them. of course the linked timeout
>>>>> operation result will allow you to do so, but you'd have to persist state
>>>>> across cqe processings. you can also track the cancellations and know
>>>>> to skip the explicitly cancelled ops' cqes (which is what i chose).
>>>>>
>>>>> there's also the problem of efficiency. you can imagine in a QUIC
>>>>> server where you're constantly updating that poll timeout in response
>>>>> to idle timeout and ACK scheduling, this extra work mounts.
>>>>>
>>>>> so i think the ability to update linked timeouts via
>>>>> io_uring_prep_timeout_update would be fantastic.
>>>>
>>>> Hmm, I'll need to dig a bit, but whether it's a linked timeout or not
>>>> should not matter. It's a timeout, it's queued and updated the same way.
>>>> And we even check this in some of the liburing tests.
>>>
>>> We don't keep linked timeouts in ->timeout_list, so it's not
>>> supported and has never been. Should be doable, but we need
>>> to be careful synchronising with the link's head.
>>
>> Yeah shoot you are right, I guess that explains the ENOENT. Would be
>> nice to add, though. Synchronization should not be that different from
>> dealing with regular timeouts.
> 
> _Not tested_, but something like below should do. will get it
> done properly later, but even better if we already have a test
> case. Victor?

FWIW, I wrote a simple test case for it, and it seemed to work fine.
Nothing fancy, just a piped read that would never finish with a linked
timeout (1s), submit, then submit a ltimeout update that changes it to
2s instead. Test runs and update completes first with res == 0 as
expected, and 2s later the ltimeout completes with -EALREADY (because
the piped read went async) and the piped read gets canceled.

That seems to be as expected, and didn't trigger anything odd.

-- 
Jens Axboe

