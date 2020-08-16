Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A984124558A
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 05:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgHPDUT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 23:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgHPDUT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 23:20:19 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA8DC061786
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 20:20:18 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x25so6471059pff.4
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 20:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yB65GsNqzQMj09UNIHRaH0SlLDKnrDmHOaRVJU+Gi7s=;
        b=nm8k8k9CQaKvqxr99t1D3FZ/h84ylVK5n9V+GYzFFAnEVJO7M8wma5RDeLaDr4i+SK
         njak7PrZST/+NZaR/bmUAv9OlWjjTADR2x93j1Dvm0hxcyU/3WXeeYTfR6FwVFKwCqwI
         jlkLowdhrOtWxGvBk0uA7XeQm0BRZSqhZsEaM8ubR9AjsxsdYox4xlz02SjCs7Plq0z8
         /cqUlqTOhgN0MPB4ueLYWPWvmwkiUQGU1qYn6JSsG850YdPQnJbfjNAqk4tzAbX1ELYo
         kxvGtRzRbNXkGJmfQi16ioJkMa0KdBLCoDNvtgH/2lmjEuMXRqjl89YZAXDHsNmxCx9e
         OAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yB65GsNqzQMj09UNIHRaH0SlLDKnrDmHOaRVJU+Gi7s=;
        b=OSPDF4kynK47JwOZDikoW3uRhAjfvrsTbHZJz9nqQ8MkGL/3xIjCXFaiilvwturpEQ
         7bmnp/NZ4JO1g9moHjHvBNDT046/t/IjdllulCKefcKV8eW92NUxnkVgokhnHMztK4wW
         6eotzWaT4+lp9+GiISaehjBTJlF1LPGPZPz8ng4Oova/52p0f+F7tHhpJ72ggDtisCWF
         OXkqwYyjLUtZNJ+jq1ju7o2g8J4/zbiFS4OuGV3uEdjlIV5IiT9NwiV04Brzyc0SVcGv
         +oIwCySw1gwk1JPcNvieDWETttDjNdr6wry8qefwoG8x2/JI9ZvJCIanqGxgFpWD2KYd
         Nojw==
X-Gm-Message-State: AOAM531TttjbyEL3r5l7zVHGbIj/u2fpm0qV5Qlk76qk5P9rqghZEdFM
        s+7p2gS0cGugudM5GKlfPErNzw==
X-Google-Smtp-Source: ABdhPJx/Wx51aPFDsErESnigQHdAbKJt0nbwq5E6ZtKhZ/hVZFig2q4Mkhm0k0xvJLhFufc34J9B7g==
X-Received: by 2002:aa7:9ecd:: with SMTP id r13mr3782697pfq.317.1597548017060;
        Sat, 15 Aug 2020 20:20:17 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:6299:2df1:e468:6351? ([2605:e000:100e:8c61:6299:2df1:e468:6351])
        by smtp.gmail.com with ESMTPSA id g33sm7504742pgg.46.2020.08.15.20.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 20:20:16 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <689aa6e9-bfff-3353-fc09-d8dec49485bd@kernel.dk>
Date:   Sat, 15 Aug 2020 20:20:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+o+py+ui=nbW03V_RADxnTE6Dz9q229rnpn+YeWu5GP=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/20 8:14 PM, Josef wrote:
>>> Hence it'd be helpful if you explain what your expectations are of
>>> the program, and how that differs from how it behaves
> 
> yeah that's true, I'm sorry about that.
> 
>>> Are you sure your code is correct? I haven't looked too closely, but it
>>> doesn't look very solid. There's no error checking, and you seem to be
>>> setting up two rings (one overwriting the other). FWIW, I get the same
>>> behavior on 5.7-stable and the above branch, except that the 5.7 hangs
>>> on exit due to the other bug you found and that is fixed in the 5.9
>>> branch.
>>>
>>
>> Took a closer look, and made a few tweaks. Got rid of the extra links
>> and the nop, and I added a poll+read resubmit when a read completes.
>> Not sure how your program could work without that, if you expect it
>> to continue to echo out what is written on the connection? Also killed
>> that extra ring init.
>>
> 
> sorry my bad.. I will ensure that the code is more self-explanatory
> and better error checking next time. It was supposed to reproduce the
> read event problem in C since I had the same issue in netty, basically
> the idea was just to read the event once to keep it more simple

No worries, it's still better to get something than nothing! And I don't
care about the error handling, but I think providing an explanation of
expectations and reality from the point of view of the reporter is a key
element in a bug report. It just makes sure that the problem description
is as clear as it can be.

>> After that, I made the following tweak to return short reads when
>> the the file is non-blocking. Then it seems to work as expected
>> for me
> 
> yeah I tested and it works in netty & my bad C example, thank you for
> the super fast fix :)

Great, thanks!

-- 
Jens Axboe

