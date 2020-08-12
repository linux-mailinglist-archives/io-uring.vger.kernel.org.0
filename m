Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7857C242E7A
	for <lists+io-uring@lfdr.de>; Wed, 12 Aug 2020 20:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHLSYy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Aug 2020 14:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLSYy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Aug 2020 14:24:54 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD35C061383
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 11:24:54 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id 140so1671848lfi.5
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 11:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xjpQ3kGXsSDwFX9VpcVr0zDslf8Q18FnrnUhbwCCQtg=;
        b=nJ3xZl4QtEAobTvw2tdbKyJWi4jXCtfsXe35tLhYTvMM80dzPDZHzBxptm04oEVhW/
         PJBgJd2Y7fUOatkfX4JvEYCDTRjAF4OJDFNR0OiAMdexXJNl3ZIwhHA26jqXq6vdzeks
         wtJUrPTi/CIviyUcVChBjlesRPMpTYZODY9TFROyUVgLIqUmPW/TcNGCiWDB1V5kdY4S
         1Mfslmhn7vqXYTaPWBfOabmky6jCYeqlM5zOb5gyybcz6Bq63aRe3nA7MyJ1RqMRaHdU
         yUt37pvyc597hmEEqsH7asgiX024u5DSbQxds3Ahj19QLbGV9EUbMlj9shxsn70HR4wh
         5jQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xjpQ3kGXsSDwFX9VpcVr0zDslf8Q18FnrnUhbwCCQtg=;
        b=O+ei4Tr6c+GxLMZeGTH26gN2u4yehU87zALzupu3qLHcNAzPZekjI7tRdPwVJsWurX
         QSqw00ZIVLpK8vvOOODwcoNAfpgQdyLqOwZj+hygape/s4p47uPl3AjTz0CwUclNeVK6
         KjZohw7wOEZPO5yXlcEA+fkJxIebV5hJCmxFFml751T5auvetFBuL1ne+vMHHL0i/0s5
         kbTJFsyam7lqiJJIOYnuOiaWPUNHkJArYUxjIUdkdJpnU+fHR2Fs41ZzDS86G8nESN0C
         j4vZajfolJPp4RadQy9Ero4NLjMxEAndVpG5tRIq5zCfXuR1b75AqkCrjLeQiE8l0UOV
         6bpg==
X-Gm-Message-State: AOAM533ue0zuiyHyH/gC96Gk2j69Wou3uBX5cJeUUQHRrJHT3NXxHExC
        9RL9CtZ3Aoveh50bFPl9n6w=
X-Google-Smtp-Source: ABdhPJx1oWS9M95YIyJY7n0qA8GuGBAitDyvFEi/oyejc4QoujLqDgmYArHKrcie0bC6DktiHL26OQ==
X-Received: by 2002:ac2:5550:: with SMTP id l16mr312573lfk.187.1597256692503;
        Wed, 12 Aug 2020 11:24:52 -0700 (PDT)
Received: from [192.168.88.63] ([195.91.224.52])
        by smtp.gmail.com with ESMTPSA id 203sm640846lfk.49.2020.08.12.11.24.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 11:24:52 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
Date:   Wed, 12 Aug 2020 21:22:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/08/2020 21:20, Pavel Begunkov wrote:
> On 12/08/2020 21:05, Jens Axboe wrote:
>> On 8/12/20 11:58 AM, Josef wrote:
>>> Hi,
>>>
>>> I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
>>> doesn't work to kill this process(always state D or D+), literally I
>>> have to terminate my VM because even the kernel can't kill the process
>>> and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
>>> works
>>>
>>> I've attached a file to reproduce it
>>> or here
>>> https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c
>>
>> Thanks, I'll take a look at this. It's stuck in uninterruptible
>> state, which is why you can't kill it.
> 
> It looks like one of the hangs I've been talking about a few days ago,
> an accept is inflight but can't be found by cancel_files() because it's
> in a link.

BTW, I described it a month ago, there were more details.

-- 
Pavel Begunkov
