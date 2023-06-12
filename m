Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B9672C6A5
	for <lists+io-uring@lfdr.de>; Mon, 12 Jun 2023 15:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbjFLN4Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jun 2023 09:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237198AbjFLNzx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jun 2023 09:55:53 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A7C1709
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 06:55:26 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-33bcc8f0d21so2628315ab.1
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 06:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686578126; x=1689170126;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9io9darqmbRHo/P6FExDlp/8V30dLZsxSAomt60Wi7I=;
        b=mG76mbdhc8rP1C83xkDvxyNsd31zL2j0OU+qQLmYOpzl+Qf6TABD7kdjQt28sqZrMf
         +CXBLHqt6nbjZy8mC66aAKCzDg2pJ9ikF3rFlW0GEKzioSCZUwqLeXBWZEJn+/8hN54T
         8uklUPE8u+snYwIynMflK4G9k/4jSZD1SfhRtt9WtCrfyj8UGGqNP5dFwfxVyxW1/c2R
         XTh/waNy1Nfexd5qzgQaFmbYC/58/TI6KaP0ovJswlVdc9OGDeZmxEPop5G3ObH9+aQS
         McWM48lYsU+Kvry41rvHTJ1uq7kGy1o73coz4sKUCHnKOsQwpLGxS13AOhg8FEJmUpmC
         zSDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686578126; x=1689170126;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9io9darqmbRHo/P6FExDlp/8V30dLZsxSAomt60Wi7I=;
        b=ABo8+l2k87DLX8CYwnOd40GecigELklgYAqOg0aCo6YooApNeMv4HWIMODGsegVVec
         /EAQ4h91rAtXlVVCYXvYPBxT4LO9RHHdegaTPBp+a8mpSOch43gfInKJ76pWSm0Fl98g
         cS+TMYqWUgpRihm8TD+pugTwHu325SK2kXaITJ5TfF/TcpxXmi3/iaVXXRsLLhXAKUpY
         5cjDY8GlJyvbui8QSCwCdhPqlivyZKbFlYKr0HqgKEjmCzX0xZfvd3ROsYAQOXHekgcq
         nG62bbLF2s1Aj2ExGO5MOK/0vxtB2jznSJVd8emLQg+EJ4MbpoXqCsB3d0VKNXtiavmg
         xXmw==
X-Gm-Message-State: AC+VfDxtvVFTwUyvLacuti6OiyfRhFWR9Q4EbNjNuewi1POR3Bbux0Yh
        dBphWDYXcolNscOo3lC6B4QJn4IxO7rDlCAB6/I=
X-Google-Smtp-Source: ACHHUZ62UQ8Z08W7pcgi3qm95i27ceAcosanqbXr8aMJU/jFnnpIt3UaiX3aahxNmQNK0d3HtXhFYA==
X-Received: by 2002:a6b:8d4b:0:b0:777:b6a9:64ba with SMTP id p72-20020a6b8d4b000000b00777b6a964bamr6134971iod.2.1686578125886;
        Mon, 12 Jun 2023 06:55:25 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k24-20020a02c658000000b0041f4bd6f285sm2686753jan.37.2023.06.12.06.55.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 06:55:25 -0700 (PDT)
Message-ID: <13375640-fe67-24f4-d0b2-e46725d0ef4f@kernel.dk>
Date:   Mon, 12 Jun 2023 07:55:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: Callbacks in io_uring submission queue
Content-Language: en-US
To:     Thomas Marsh <tmarsh.dyan@gmail.com>, io-uring@vger.kernel.org
References: <CAL66sUjTkm5fTaLwupGe1F2br+LjYgzBqh+uYu0qA=j2rLmABQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAL66sUjTkm5fTaLwupGe1F2br+LjYgzBqh+uYu0qA=j2rLmABQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/11/23 9:43?PM, Thomas Marsh wrote:
> Hello. Recently I was busy making a coroutine executor. It was going
> smoothly until the point where I needed to read from stdin. It turns
> out that the default way to do it blocks the thread that executes the
> read. This is not an acceptable situation for the worker thread which
> should execute as many pieces of work as possible. I tried to find how
> to do asynchronous io in Linux, but among the variety of things I came
> across on the web, the io_uring appeared as an appropriate solution at
> first sight. Sadly, soon after going deeper into the io_uring's
> interface, I discovered that the only way to know about the completion
> of submitted work is through polling. This appeared quite counter to
> the premise of asynchronous io, which is to eliminate waiting on
> things.

Not sure how you came to that last completion? You can certainly poll on
the ring fd itself to get notified when there are completions, but you
can also just check the completion ring. That's the common approach.

> Dissatisfied with my findings I tried to see if any other os provided
> a better interface, and I found one conceptually interesting
> approach... in Apple's Metal. In that graphics framework, it is
> possible to ask the system for a command buffer and then put in it a
> user-provided callback, which the system will execute when it
> processes that buffer.
> 
> Is it possible to put a callback in io_uring which the system will
> execute without polling the thing?

io_uring is a kernel side implementation, having callbacks there into
userspace would not make sense. You could of course wrap your completion
reaping in something that processes them via calling a callback, eg
->user_data could be set to a struct that has a data and callback
element and that's how you'd process them.

But it sound to me like you're mixing things up a bit. And there's some
confusion on polling being a requirement as well, which is not the case
at all.

-- 
Jens Axboe

