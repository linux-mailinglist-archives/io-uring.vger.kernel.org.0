Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6B44204D7
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 04:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhJDCCw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 22:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbhJDCCw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 22:02:52 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEBDC0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 19:01:04 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id b78so18527245iof.2
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 19:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vh3w/o8D1iVMQuPcbgAaawOwrUUJMxMAm9qMznhOqbI=;
        b=xpTaYOZqQqVsdPHGAxaIScr9Ve7gek9ujfjL2e8O8UMAqBqO7dXcubsD0l5ZCW3T8X
         xO1B+t9JiIoyftRIgy9zhS+PvCj3qZImbPGnY1SKab2O8sAYd1BvykcwRl+7a0cKZuX6
         hVNLjX3eSkcWZinJp2c45+sETlYPQrZ/+GYn/PRbcNQF/NltwCUGeJ3vO3XHW4YxzzId
         /M2HcXMQkAquGreKvyGLpj6C+k0+z47CH/yorKsDIolSVAEpp/LRkWwKuVoKRSq1f//X
         TGd0qBJKBMWLoMHNYRbYXAcKhRz2G8U1stnXNqXZy8Dwv5swwtsEbJjAAwBiaUYwVng+
         IVGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vh3w/o8D1iVMQuPcbgAaawOwrUUJMxMAm9qMznhOqbI=;
        b=hN4M68Bw4xwB6mw6Qb6owsSD16tgUO42nnz6jPxJkTMHFTBJR4/l/OdkKxS0lFJft6
         EGfv4gwH+P/Jz19J0CHTmQVUiPyFa/DRJxh3AMpQBqrkBFhUnrryXQvldIGV7b4FQHYY
         Qai/xTqezt0bWL1WNTBQrJdSh72GH5gxulnwjwUGRWa2vCQg4f4M/OREEN/oqAnOSZuG
         ObqQBd2dOJWgnJInKA/S+lyGWTDrucdQXUQbekJQukJ8QQFhEAk0XJcFSWewvVGjKvPJ
         afBDaN0HChNIPZUlZ9tuxmuIDpTXxoZGdvL2zWIGm6p53swS7WLPgX6nMXnepec7H4M5
         +0yg==
X-Gm-Message-State: AOAM533k7Aswgpf751L1tYNy5aNh7f04ngVwt5JJaSZDip2acf6Bv4Ox
        mdkUTsiCFPn1xZDt4kAhNN5vF/SyF+VzuA==
X-Google-Smtp-Source: ABdhPJzM66UMaoVGVgM8zWt5tHYTn2gjnIX9D3T+mafvXvKRatUdJZwlTv9v1gGNIICrb28YurpNhA==
X-Received: by 2002:a05:6638:1606:: with SMTP id x6mr9120552jas.59.1633312863344;
        Sun, 03 Oct 2021 19:01:03 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id e10sm8016469iov.10.2021.10.03.19.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 19:01:02 -0700 (PDT)
Subject: Re: [PATCH liburing] src/syscall: Add `close` syscall wrapper
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>
References: <20211004013510.428077-1-ammar.faizi@students.amikom.ac.id>
 <e2d18015-510b-1570-3b23-eae2c6e45d1d@kernel.dk>
 <CAGzmLMXxtr58qHtoHXhgoOJG763L=FEAJ5QMD21kFgwZbuFQfw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2abab0b5-dbf6-8fe3-bc0e-81f5a3dc03ea@kernel.dk>
Date:   Sun, 3 Oct 2021 20:01:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGzmLMXxtr58qHtoHXhgoOJG763L=FEAJ5QMD21kFgwZbuFQfw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/3/21 7:51 PM, Ammar Faizi wrote:
> On Mon, Oct 4, 2021 at 8:37 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 10/3/21 7:35 PM, Ammar Faizi wrote:
>>> In commit 0c210dbae26a80ee82dbc7430828ab6fd7012548 ("Wrap all syscalls
>>> in a kernel style return value"), we forgot to add a syscall wrapper
>>> for `close()`. Add it.
>>
>> Applied, thanks.
>>
>> --
>> Jens Axboe
>>
> 
> Oops, sorry Jens, I copied the wrong commit hash.
> 0c210dbae26a80ee82dbc7430828ab6fd7012548 is wrong (it's in my own tree).
> 
> The correct one is cccf0fa1762aac3f14323fbfc5cef2c99a03efe4.
> Can you amend that?

It's already pushed out. It's not a huge deal, as the fixes line has
the right sha.

-- 
Jens Axboe

