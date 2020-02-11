Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A382159A35
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgBKUGD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:06:03 -0500
Received: from mail-io1-f54.google.com ([209.85.166.54]:44197 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbgBKUGD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:06:03 -0500
Received: by mail-io1-f54.google.com with SMTP id z16so13205665iod.11
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 12:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FpfPq3R5BrbBpww0mfOuGDw22fVDFzP/524w9CLu6mQ=;
        b=KRHyrqNSDxIMsZdwtDfUcrGNHZX8fO5+AMBBp77tQ3BImF8myvb9Tlg5pGaGwQXaMe
         7Z6QAGZrkxn1EAvFgKDrRNiPPsQAvD2kS8VGHyeJJSsSRgg47fnXny2Sys72PdKn8DyM
         F8nMer356fLFhGFu9PEStq5NEQYBGvOBpNF3ntireRy+DKjyBRvvznmnRAJmoVsZzlwD
         e8JjeznJrSf0G7TgKKZ/16espGwF4ngs4rvBicb2gIGlJp7RWp6Lggse4BUkBVFq1pel
         x70gbS/2wUZ8Pmq8HMkwf8Wu6BjpKnHwoGgDhF4fSjebREYgvuGUC7UF0bdyxeYxgjDS
         lvwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FpfPq3R5BrbBpww0mfOuGDw22fVDFzP/524w9CLu6mQ=;
        b=Z2xYvCg22eO8XeldLK+3jrZFf7vUxiHTNOcOuRLvAyyv1RCC0xNFczBdrEGVUy2Eqh
         xZvF/JXC7Tu7m9oSMiZ/XER4fwkiTvnzebzgdD+92fKXmzMzq4dxxTZFNnaJhUj7Xs4T
         WnitC2/2Pkhd19EypUqEOHIA2jPREUfHd344jhcuk42753zcmaxV+N7ND2dXyBe/qbJK
         JEjS8DRiC4wIxDEjkQ/2sh+KoBz/x2DA91SZ/E91rUR8PJ5XLMWqpPy7aKp3Z5vo0XkA
         nj3e5aZ0O0L89U/5jZqXSSz6mJf97C7bdzZbzNJUlO2Lm8oMEQ6wqpy93SZAIIrb0W5B
         +gIg==
X-Gm-Message-State: APjAAAWLy7z0V+F/RfmsLTGq6K0pVbjfc09R1+p9K/i6rBDGqGGoBb8z
        rgZMbGrMT/T8Yy6l+xD8fcYjqlwFelU=
X-Google-Smtp-Source: APXvYqxVxu/yxM3wBRIjOc54AlbRq5Iqa4VCNcxvPsMIP8KrZ84ouSrPOHT529K1Ogdp83RpAOPeQw==
X-Received: by 2002:a6b:e601:: with SMTP id g1mr14593759ioh.55.1581451562546;
        Tue, 11 Feb 2020 12:06:02 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a21sm1289717ioh.29.2020.02.11.12.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 12:06:02 -0800 (PST)
Subject: Re: [PATCHSET 0/3] io_uring: make POLL_ADD support multiple waitqs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20200210205650.14361-1-axboe@kernel.dk>
 <c3fd3aa0-4358-6148-7486-ea52b410a5a6@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <692a561c-9176-63fa-3c48-7f37a8214057@kernel.dk>
Date:   Tue, 11 Feb 2020 13:06:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c3fd3aa0-4358-6148-7486-ea52b410a5a6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/20 1:01 PM, Pavel Begunkov wrote:
> On 10/02/2020 23:56, Jens Axboe wrote:
>> As mentioned in the previous email, here are the three patches that add
>> support for multiple waitqueues for polling with io_uring.
>>
>> Patches 1-2 are just basic prep patches, and should not have any
>> functional changes in them. Patch 3 adds support for allocating a new
>> io_poll_iocb unit if we get multiple additions through our queue proc
>> for the wait queues. This new 'poll' addition is queued up as well, and
>> it grabs a reference to the original poll request.
>>
>> Please do review, would love to get this (long standing) issue fixed as
>> it's a real problem for various folks.
>>
> 
> I need to dig a bit deeper into poll to understand some moments, but there is a
> question: don't we won't to support arbitrary number of waitqueues then?

In theory, probably. But in practice, don't think anything exists with > 2
waitqueues. As mentioned, even the 2 waitqueue case is limited to less than
a handful of users.

But the patch should for sure check this, and -EINVAL if we get a third
entry attempted.

-- 
Jens Axboe

