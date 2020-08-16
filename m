Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F4D2458CF
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 19:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgHPRaN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Aug 2020 13:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgHPRaM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Aug 2020 13:30:12 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037EBC061786
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 10:30:12 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 189so6316653pgg.13
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 10:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H+oqfjIold60myOL8GEmLDENSo7NlBhIn6Su2HtZ6vE=;
        b=MAHOg7z4/Ysm8krWHk3MLQO2L7CACfMZdndetcRB6AJWI88zOtKPb9UYKjw1I8dbCM
         GxT450rD0nz8M/KBK9Q7JNHmNdZPDI0MtYfXEDYMDdiEHm7n7ulbXsr0sOeVNQ6xqJYi
         TkqMWTXJMqRjd+tDT0ZShzcZMJ6IrDOSlMIJfvSXEL0TaCpD52/ML0T6EB16EbgJHySI
         ggg1Qfs5JUw7j3sbGGqykpCFqR+U9zJJBIi0vCpm5BySZYy1AmpM3ykMaj2i4JpsdBKV
         ZuckSbqlDogid36gKQuzxxqQpa6GcJP/FYrx/xQMunoVLJXVRd8XhrV27ZwtXGHKzWFV
         k+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H+oqfjIold60myOL8GEmLDENSo7NlBhIn6Su2HtZ6vE=;
        b=cLRv1r3nF34VEXIGMvcphvxNGk+WOSwpHCZlqt+z5fq3mMb8HAsdFwA95mhSMqXYm3
         c3XUJczHCCTAO/sIgQAd61hlbUsYcW2XmH1g2a5hf7iseTkO1ed7u3Xcv6IyvYjBJNSA
         R5IdtrDQf5156Kr5aVtkU6lsJppVij0Wql+d6YuSb1qE9KpVXXRQ1QXYpsePJOesi+Zr
         PyZVgm/8n/r9sQ5s+mmifTYkHoMvRbO8Gwe94Pr6aAv2yFaE+wk0xBYg/zzeD1f3HX0y
         g634iXxFQwelWi0iMP3z7xIanabt3cYgGWH/w9+WSHIyTXMibK4PbSp7wP5R3V5eS2bY
         1MVw==
X-Gm-Message-State: AOAM532TclUpz2e2ULr/kZhWR4fFJCuK0hLhdnlH1FajmD4RlDmp3tqV
        iL2PfTH9EmM1Q/0EobxGnyXAUQ==
X-Google-Smtp-Source: ABdhPJxu+TKa8GYzHckDc4UZknOsXs2E2JGXVzIxFPb1opTAaX+QF8GUY2+UbsEImOZ4vZzrN6b2eg==
X-Received: by 2002:aa7:8ec4:: with SMTP id b4mr8352317pfr.227.1597599010503;
        Sun, 16 Aug 2020 10:30:10 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:80d9:87c:7a0f:8256? ([2605:e000:100e:8c61:80d9:87c:7a0f:8256])
        by smtp.gmail.com with ESMTPSA id y72sm16640966pfg.58.2020.08.16.10.30.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 10:30:09 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
From:   Jens Axboe <axboe@kernel.dk>
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
 <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
 <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
 <CAAss7+qGqCpp8dWpDR2rVJERwtV7r=9vEajOMqbhkSQ8Y-yteQ@mail.gmail.com>
 <fa0c9555-d6bc-33a3-b6d1-6a95a744c69f@kernel.dk>
 <904b4d74-09ec-0bd3-030a-59b09fb1a7da@kernel.dk>
 <CAAss7+r8CZMVmxj0_mHTPUVbp3BzT4LGa2uEUjCK1NpXQnDkdw@mail.gmail.com>
 <390e6d95-040b-404e-58c4-d633d6d0041d@kernel.dk>
 <63b47134-ad9c-4305-3a19-8c5deb7da686@kernel.dk>
 <CAAss7+o+py+ui=nbW03V_RADxnTE6Dz9q229rnpn+YeWu5GP=w@mail.gmail.com>
 <689aa6e9-bfff-3353-fc09-d8dec49485bd@kernel.dk>
Message-ID: <b35ac93e-cf5f-ee98-404d-358674d51075@kernel.dk>
Date:   Sun, 16 Aug 2020 10:30:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <689aa6e9-bfff-3353-fc09-d8dec49485bd@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/20 8:20 PM, Jens Axboe wrote:
> On 8/15/20 8:14 PM, Josef wrote:
>>>> Hence it'd be helpful if you explain what your expectations are of
>>>> the program, and how that differs from how it behaves
>>
>> yeah that's true, I'm sorry about that.
>>
>>>> Are you sure your code is correct? I haven't looked too closely, but it
>>>> doesn't look very solid. There's no error checking, and you seem to be
>>>> setting up two rings (one overwriting the other). FWIW, I get the same
>>>> behavior on 5.7-stable and the above branch, except that the 5.7 hangs
>>>> on exit due to the other bug you found and that is fixed in the 5.9
>>>> branch.
>>>>
>>>
>>> Took a closer look, and made a few tweaks. Got rid of the extra links
>>> and the nop, and I added a poll+read resubmit when a read completes.
>>> Not sure how your program could work without that, if you expect it
>>> to continue to echo out what is written on the connection? Also killed
>>> that extra ring init.

BTW, something I think you're aware of, but wanted to bring up
explicitly - if IORING_FEAT_FAST_POLL is available in the ring features,
then you generally don't want/need to link potentially blocking requests
on pollable files with a poll in front. io_uring will do this
internally, and save you an sqe and completion event for each of these
types of requests.

Your test case is a perfect example of that, neither the accept nor the
socket read would need a poll linked in front of them, as they are both
pollable file types and will not trigger use of an async thread to wait
for the event. Instead an internal poll is armed which will trigger the
issue of that request, when the socket is ready.

-- 
Jens Axboe

