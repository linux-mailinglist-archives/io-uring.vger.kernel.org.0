Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366A9242E63
	for <lists+io-uring@lfdr.de>; Wed, 12 Aug 2020 20:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgHLSFT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Aug 2020 14:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbgHLSFT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Aug 2020 14:05:19 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A9BC061383
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 11:05:19 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f5so1455158plr.9
        for <io-uring@vger.kernel.org>; Wed, 12 Aug 2020 11:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ie+fynij3l4Dd7Vb3kRPOMB58XldTJ8n5PsTopOYwOo=;
        b=lp3TTGuuHqKXmajsmlf6Av3jNJ1rEW5ny69ruDRVvRCoMZmt8KYxcrAAS9RKm6GqW0
         j1wS1TM5E7czG6TMkjdzASwLdtSQFJeM0E9oS04VqwPB7waoCWXL5r5lTTWg8EyaS8O6
         FSINoySjK0ThAp1twRwkH7gzPWT3/k0etojYAtAa5GIm7czES/Vl4MQiKHc4vDzlgisH
         mpvKZvdkuF0kcMmJHNLtJhOhti9gkYdwcisN7bkJt6ws2KjunS5iSdy3tibrPpS5AYCH
         en1pZYZeJfCYT1fW6B4qsN7yqceyzs2OYbBp/ZXgG3/6yJ4/1j2Z90aXj2LTu6PC8tRH
         Xpfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ie+fynij3l4Dd7Vb3kRPOMB58XldTJ8n5PsTopOYwOo=;
        b=QcxZF76mNR+5vjbnu97ge61Cs/UQJUb4nhpXGbKIE0TZDvV96zUBGxlmxzDCg9++OR
         VdjTv2ilOAIG7KoeCm9LOJrXBBtRyPoJpY3p9D32+eyHdB2XyBA2U9FWaueifnRH8rDi
         auZH5yeZASeSMnjFIrR8uccVh3YQ4IPEBeqg4KBaL+5jDu9ejSi/SYh/0IWByPLPgDyc
         e47DOuM2KNlvJ6UA5SsQNt3BBA3vdxerjbJdRl6WYXomUJLAZUzJrf6Zh12bQ+1wfyKT
         9sVcv2GA+u8xrNvZLrCM2cJMzADWyK1QqHsCB9u59BbYAel8fSPQ19F4LqReBidcvf/O
         Xc4Q==
X-Gm-Message-State: AOAM533vJQ6GIOEcXqTypzV66aKtJhj0dcSb8VSb/UMMF7mWoUcuQsSh
        Nu1BQwdfTjzKDcdwl6SxwYXeUXvjMWg=
X-Google-Smtp-Source: ABdhPJzN+ormbwXFK/ibh/J2XaMo8uvP1zHKSoH08wKPiikf13yZjL4SWZXDVVo3eEtvEEGiOrloDw==
X-Received: by 2002:a17:90b:514:: with SMTP id r20mr1299519pjz.82.1597255517598;
        Wed, 12 Aug 2020 11:05:17 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y128sm3063606pfy.74.2020.08.12.11.05.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 11:05:17 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
Date:   Wed, 12 Aug 2020 12:05:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/20 11:58 AM, Josef wrote:
> Hi,
> 
> I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
> doesn't work to kill this process(always state D or D+), literally I
> have to terminate my VM because even the kernel can't kill the process
> and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
> works
> 
> I've attached a file to reproduce it
> or here
> https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c

Thanks, I'll take a look at this. It's stuck in uninterruptible
state, which is why you can't kill it.

-- 
Jens Axboe

