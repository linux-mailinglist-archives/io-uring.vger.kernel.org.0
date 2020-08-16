Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AA9245518
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 02:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgHPAlv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 20:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgHPAlv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 20:41:51 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D81EC061786
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 17:41:51 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mw10so5981076pjb.2
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 17:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6xieWJVHfSDPprLrHsPOEkfOTuU5JMWIg7ACd4YSLUc=;
        b=uD99erp2PdvbFqb0llRw73PvsOTi3fxLVsxdAGgGeMeGC1XkNtdkF3D3rEYLRLESh0
         CAv90lXpcRmxkwsXJhOmnwJkCqC+qxTxj/pg64lkce9frB84GObVxN+h/piUyQ78c1vl
         /Luo7DZkpIjzZ5Fu6qwps1x3EDJu6gK4HgDGImStA5fjg3cwl7fiQ/3BHVA9IfghcBiL
         638KUj8guYMb44asCT9eptLhzG4MWaIP4NdMkzeLwHIkRJ6d0dFOVqPiCvmWB9ak6cm1
         3jFaQ0Kv81ETqGXwBjcdJ+dosn6VgfYJZhj2PZyqtECfNdJ0JQbunsnmcK1S7Ra9MH9K
         wW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6xieWJVHfSDPprLrHsPOEkfOTuU5JMWIg7ACd4YSLUc=;
        b=Qk/KVAW6HT7CuLPVSoJ3c7QexKdI2qM4tGxekoRBX7hu6ii9CYLZFIZ7jqzMkVISLg
         1ANLFXsCQF2XG9FgvpCqwhH88C07wbLYPCfEdoFti1F6aYxmXeijur33oEJH9j14vMlR
         7yjZcXag6JWNgZi2mL1iqmrosJeF/2oosC71KWuGaSwKLZa3598ny/2hqziSEQYY8O/V
         tBUCxmhRQSNu5Vwjjeo2vZEqsKdvjXACj6ysECsr0ZlrxnhnBYq0PdExaZ5C8cMgU7rR
         ABdHcr4siUKr9gTjclVZPo+uj1La/uM4yDJA1SCIrog9WiwaiLpz1Oh9XSOZMBaLbBsU
         Y26w==
X-Gm-Message-State: AOAM531bZY0qSTxCDLs5+psD4CRdq4Prqv1Dpb+KTzR+QZLxEwiGqDb+
        R0lFXFu/l1Iv3ELyCLHw8BDQ3g==
X-Google-Smtp-Source: ABdhPJwESA5lLbk76gUiFkdYoAvkj8d2k5Ejsi/Pzb1qlzbUIkoNj6U1JYQHaKt+Zv0/cop1gql4Ow==
X-Received: by 2002:a17:90a:cc14:: with SMTP id b20mr7158810pju.1.1597538510333;
        Sat, 15 Aug 2020 17:41:50 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:6299:2df1:e468:6351? ([2605:e000:100e:8c61:6299:2df1:e468:6351])
        by smtp.gmail.com with ESMTPSA id 75sm13445054pfx.187.2020.08.15.17.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 17:41:49 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
To:     Josef <josef.grieb@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <390e6d95-040b-404e-58c4-d633d6d0041d@kernel.dk>
Date:   Sat, 15 Aug 2020 17:41:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+r8CZMVmxj0_mHTPUVbp3BzT4LGa2uEUjCK1NpXQnDkdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/20 5:36 PM, Josef wrote:
>> Please try:
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=41d3344604e80db0e466f9deca5262b0914e4827
>>
>> There was a bug with the -EAGAIN doing repeated retries on sockets that
>> are marked non-blocking.
>>
> 
> no it's not working, however I received the read event after
> the second request (instead of the third request before) via Telnet

Are you sure your code is correct? I haven't looked too closely, but it
doesn't look very solid. There's no error checking, and you seem to be
setting up two rings (one overwriting the other). FWIW, I get the same
behavior on 5.7-stable and the above branch, except that the 5.7 hangs
on exit due to the other bug you found and that is fixed in the 5.9
branch.

I'll take a closer look later or tomorrow, but just want to make sure
I'm not spending time debugging your program :)

Hence it'd be helpful if you explain what your expectations are of
the program, and how that differs from how it behaves.

-- 
Jens Axboe

