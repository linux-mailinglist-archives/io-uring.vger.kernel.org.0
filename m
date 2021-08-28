Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6903FA610
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 15:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhH1NoI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 09:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhH1NoI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 09:44:08 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2508FC061756
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 06:43:18 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id u7so10322240ilk.7
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 06:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Blua5mqJv4+uaG9bu3Di+LHHJSgFOYp7dqt9Gdm35q4=;
        b=S7nLDly9hmoMv/IoRJfLdzXaKNPVC1V4kh3iQqD7C3ptWD4Qwk5gVlPAwnaHNtX0rs
         Yqz/ewtzxo/IuXHFC2BwhKa5SPhCJg6z7HF2Mg5CIhGI9FnntIqdS4Us1Txkw4r27Vwc
         LpD6NZXotdHFlQ8lohPPSRf+J08LZPJegbqG+OhYZtEgx0H/V8e9WJeSmKj3hJ78O9C/
         Ki1nfZhLuYohPx76pyC38jcAee05/RYChcorih1H71/0gs0Khm37kXi+QPbob4UigSRg
         s9h+ASfINHJ4r9z9W4wPvckJNNNCiQ3IZc+JqQEAFOQvI6YyckrNVl2ahV5YhkhvQi3I
         Gyxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Blua5mqJv4+uaG9bu3Di+LHHJSgFOYp7dqt9Gdm35q4=;
        b=Yd+k856eNQbMgMtqTaz4rRcg322ZqJIjSXuW3h3YTWJhOHp9s05c8BymziZluDwFW8
         dyA/ec0XGwiEpeRadFtWdNO+BvBbmFVoFpN6vWn/ggr035ibaPThpGNe3+GTU1lXS0WM
         gJQqvbPM6+KLQOvOqy74lcpCXgzsNgFfeaix+EKFhlXKpHAYkUj2kTpqQvwxwH436A0e
         lk7INs8fZiA/kzN5eGGRAVd+UNd83s1P0w8DcxAgCTKT2z1c9c5ZXS9ZFinq4TxfA6gU
         nSBL93b0t1adq5exSsjbgMMr2jHl/Whl63DJzCD/BLb6SHmQqgEM83MCPlnRbXA75b6a
         AAyw==
X-Gm-Message-State: AOAM5310fVHvllu6hVQMazXDZRqVp8aNb7n9CfH0hd3S4Nn560IIca9a
        BqWI7h1kfyOpgp/AqKrIXeiSA9dd0z35pg==
X-Google-Smtp-Source: ABdhPJwboC4J+QelAAhyGDz8i4etLXT/5vGLcsuMtbNfX3XTIGJO/g48gQTZNOp77JODKgqK7ss9jw==
X-Received: by 2002:a92:c64c:: with SMTP id 12mr9898664ill.235.1630158197224;
        Sat, 28 Aug 2021 06:43:17 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s18sm5659817iov.53.2021.08.28.06.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Aug 2021 06:43:16 -0700 (PDT)
Subject: Re: io_uring_prep_timeout_update on linked timeouts
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhHOt1Ni==4Qr6c+qGzQQ2R9SQR4COkG2MXn_SUzEG-cg@mail.gmail.com>
 <CAM1kxwi83=Q1Br46=_3DH46Ep2XoxbRX5hOVwFs7ze87Osx_eg@mail.gmail.com>
 <CAM1kxwiAF3tmF8PxVf6KPV+Qsg_180sFvebxos5ySmU=TqxgmA@mail.gmail.com>
 <1b3865bd-f381-04f3-6e54-779fe6b43946@kernel.dk>
 <04e3c4ab-4e78-805c-bc4f-f9c6d7e85ec1@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b53e6d69-9591-607b-c391-bf5fed23c1af@kernel.dk>
Date:   Sat, 28 Aug 2021 07:43:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <04e3c4ab-4e78-805c-bc4f-f9c6d7e85ec1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/28/21 7:39 AM, Pavel Begunkov wrote:
> On 8/28/21 4:22 AM, Jens Axboe wrote:
>> On 8/26/21 7:40 PM, Victor Stewart wrote:
>>> On Wed, Aug 25, 2021 at 2:27 AM Victor Stewart <v@nametag.social> wrote:
>>>>
>>>> On Tue, Aug 24, 2021 at 11:43 PM Victor Stewart <v@nametag.social> wrote:
>>>>>
>>>>> we're able to update timeouts with io_uring_prep_timeout_update
>>>>> without having to cancel
>>>>> and resubmit, has it ever been considered adding this ability to
>>>>> linked timeouts?
>>>>
>>>> whoops turns out this does work. just tested it.
>>>
>>> doesn't work actually. missed that because of a bit of misdirection.
>>> returns -ENOENT.
>>>
>>> the problem with the current way of cancelling then resubmitting
>>> a new a timeout linked op (let's use poll here) is you have 3 situations:
>>>
>>> 1) the poll triggers and you get some positive value. all good.
>>>
>>> 2) the linked timeout triggers and cancels the poll, so the poll
>>> operation returns -ECANCELED.
>>>
>>> 3) you cancel the existing poll op, and submit a new one with
>>> the updated linked timeout. now the original poll op returns
>>> -ECANCELED.
>>>
>>> so solely from looking at the return value of the poll op in 2) and 3)
>>> there is no way to disambiguate them. of course the linked timeout
>>> operation result will allow you to do so, but you'd have to persist state
>>> across cqe processings. you can also track the cancellations and know
>>> to skip the explicitly cancelled ops' cqes (which is what i chose).
>>>
>>> there's also the problem of efficiency. you can imagine in a QUIC
>>> server where you're constantly updating that poll timeout in response
>>> to idle timeout and ACK scheduling, this extra work mounts.
>>>
>>> so i think the ability to update linked timeouts via
>>> io_uring_prep_timeout_update would be fantastic.
>>
>> Hmm, I'll need to dig a bit, but whether it's a linked timeout or not
>> should not matter. It's a timeout, it's queued and updated the same way.
>> And we even check this in some of the liburing tests.
> 
> We don't keep linked timeouts in ->timeout_list, so it's not
> supported and has never been. Should be doable, but we need
> to be careful synchronising with the link's head.

Yeah shoot you are right, I guess that explains the ENOENT. Would be
nice to add, though. Synchronization should not be that different from
dealing with regular timeouts.

-- 
Jens Axboe

