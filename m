Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4ECC30F7AF
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 17:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237577AbhBDQYj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 11:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbhBDPGK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 10:06:10 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D59C0613D6
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 07:05:30 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id e7so2829840ile.7
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 07:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zOEQZJF3BJyfAO2CPf1OESFlh8gCHMospiBHuhW+nPo=;
        b=XNawOCpPhrUhyK8W4gp6n/ljKPB15Vd21fBL04WRzWMoQYojKMbcJkJO3Ub7zbrU5R
         lK0wtkWkkbmtx6qCEbWn61uDX+ch/z21NI33AjTaTxaAdGpjubxuq+AQfkrVlzoZhfid
         ljzqXIb3ePbMrkKa0u8eG4zXbY6KATba7hQQusEnrxdFKMaKr9zznoD+X65U1aXeo/qv
         tqs1VNUHHLn0M0FzYMhvIeYmkzq/VVjemRRMKSJ6mvDCyCMqZA1ZPydwM/5R8df7pW5K
         MsmWTS+fRqXRo6z11MObH6bLQLbFsvgZv7BOw7T6gyz9lwhjw8Gz7slPzH38nF1oM8KL
         8Fuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zOEQZJF3BJyfAO2CPf1OESFlh8gCHMospiBHuhW+nPo=;
        b=lnyDLwh0RpxJv7bvZbOKDYSxpWGR4PInLZOY3QTBdXWfzdqT0fkzWSqXxEoMGqNAfA
         p0u1RfwoKLbRiQoDrzo8iZMgWE9ekMSZguA2HMYNvMOnZQXn82I3uynxLyx8k1/AcoYJ
         9JOYi8haHeQYQPne4BJGWUfKi1T/qzReOWaJ94I3Hej+f8/GDrBjpHqRdPQPbx0OUyMg
         2J97/x89FAhvSNoOkXk4Nb/t+Lu7Qf4JjCY0z6hvSD9jJ2/aqnscZajycCpCzWowt6UU
         0ZuF4QaEJPlqjMPwJSqy7oBqnCd7r0p+qA2UK5Nd4P0/GX/M1IgMZZRVBlfaEAmr1ClU
         sP1A==
X-Gm-Message-State: AOAM530WGFggfAEP7A6ll/MMLioLhbFCzG2JWEzJT6iENy2tEHhYksMb
        w35ufCgePNBh8sgatZA22HXDIFb5TBqCGwCQ
X-Google-Smtp-Source: ABdhPJw+NVc6xcwNjXkTJoBa6/bvlkc8xItinYOUuzcK/29M88zJUSS5C8onwjKWY3mhvRxS8LWcZw==
X-Received: by 2002:a92:dc8d:: with SMTP id c13mr7313042iln.284.1612451129753;
        Thu, 04 Feb 2021 07:05:29 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k11sm2625775ilo.8.2021.02.04.07.05.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 07:05:29 -0800 (PST)
Subject: Re: [PATCH v2 13/13] io_uring/io-wq: return 2-step work swap scheme
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612446019.git.asml.silence@gmail.com>
 <014eff28b71c8e5da5edaa4ad9d142916317c839.1612446019.git.asml.silence@gmail.com>
 <8acbd513-531c-0a12-ea3f-ecf0cd94c9e2@kernel.dk>
 <cdce2630-ddc8-a912-4937-147395a6ff54@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5e765c87-f676-82cf-232c-a54e05dfe6e8@kernel.dk>
Date:   Thu, 4 Feb 2021 08:05:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cdce2630-ddc8-a912-4937-147395a6ff54@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/4/21 7:56 AM, Pavel Begunkov wrote:
> On 04/02/2021 14:52, Jens Axboe wrote:
>> On 2/4/21 6:52 AM, Pavel Begunkov wrote:
>>> Saving one lock/unlock for io-wq is not super important, but adds some
>>> ugliness in the code. More important, atomic decs not turning it to zero
>>> for some archs won't give the right ordering/barriers so the
>>> io_steal_work() may pretty easily get subtly and completely broken.
>>>
>>> Return back 2-step io-wq work exchange and clean it up.
>>
>> IIRC, this wasn't done to skip the lock/unlock exchange, which I agree
>> doesn't matter, but to ensure that a link would not need another io-wq
>> punt. And that is a big deal, it's much faster to run it from that
>> same thread, rather than needing a new async queue and new thread grab
>> to get there.
> 
> Right, we just refer to different patches and moments. This one is fine
> in that regard, it just moves returning link from ->do_work() to
> ->free_work().

Got it, looks good then.

-- 
Jens Axboe

