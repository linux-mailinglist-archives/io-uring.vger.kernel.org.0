Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83426B5EB8
	for <lists+io-uring@lfdr.de>; Sat, 11 Mar 2023 18:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCKRYb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Mar 2023 12:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCKRYb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Mar 2023 12:24:31 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA0C116
        for <io-uring@vger.kernel.org>; Sat, 11 Mar 2023 09:24:29 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id a2so8786093plm.4
        for <io-uring@vger.kernel.org>; Sat, 11 Mar 2023 09:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678555469;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b6FwHGSQEANaeCWfH/KBmQNj8C6YpMAIejp0LKFAolI=;
        b=mUmLasf0RmqZjsruP0d+yQMq08cI7p6QDDWCnp9x968wtntHBhMMf4wUkeJYEq2udP
         ienaKw/hcuRbcgg8uCh+SC+uMtI83x6Rf0Fd2ZpojbesuRI6aeBbLA0qJrZZJRumZ/oc
         z5Lrb4DvR+4t1Dh9vlKjceAkhG2QMH2DHW0tB9WMUrgvqseQlhycVEYIeLRe0cPTHh0H
         s/x9vieC1UE2zdUY7xn5XTdEdgjcB+2Loj0MqqDUFB0oXCm+PjciJayniMjcXCsknb3/
         t+lZhI4WKiVSusT/shj9lGeSSpV6l6uJHwMfoZd5xExiK/W9Cmyt9WkzOPBpbRNlbLPB
         +NBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678555469;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b6FwHGSQEANaeCWfH/KBmQNj8C6YpMAIejp0LKFAolI=;
        b=AOcfdS1VpNbcqw4/6zbgDXDClBxpx4QsRZdPdx9iYEgBdXFKSG79aDLDLW8oUrBr3j
         5xI2NVNiDRdrfKBGuv49PfQSTlklkjgbPQXzPED32sa4VawEydwoLyoO1Wp2kAjoiQ4i
         h/hnDA7pij7i/qHKJCo1G2phoffiq8ZG4ilhVUhMnP/UguBcEGlm6hft4gkNp6DYj1rl
         AWXqe5f5UcrvS4lfe/LI4d7lEz6YYPU/EP1LcwBflSTmZaHUWL9SHNFtfeiklGNW0ksS
         XTlyTFk/SV380aw42AJpqfZehYF3KM7oRnSqm+9vMbD7WnsIuA5+bWrRdO6zYRXHRVuk
         NrFg==
X-Gm-Message-State: AO0yUKUKBZqgML/re6erj4e/PPx4Rl5XXyozFIckCm3RaOqas8ele6Y3
        FgFe6Aj7gN0SPWSyck/jNsYUyc4vlOV6JgZK/km99w==
X-Google-Smtp-Source: AK7set9HSeT39Yrw1SF2hUonBtgvQmfrvv9eTpVya+N0eoUS1w6+c7OtLfQz/cLudQ5o3ayhDQdmTA==
X-Received: by 2002:a17:903:6c3:b0:19a:9269:7d1 with SMTP id kj3-20020a17090306c300b0019a926907d1mr5983558plb.4.1678555468870;
        Sat, 11 Mar 2023 09:24:28 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id kc3-20020a17090333c300b0019a7bb18f98sm1837751plb.48.2023.03.11.09.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 09:24:28 -0800 (PST)
Message-ID: <9250606d-4998-96f6-aeaf-a5904d7027e3@kernel.dk>
Date:   Sat, 11 Mar 2023 10:24:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1678474375.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1678474375.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/10/23 12:04?PM, Pavel Begunkov wrote:
> io_uring extensively uses task_work, but when a task is waiting
> for multiple CQEs it causes lots of rescheduling. This series
> is an attempt to optimise it and be a base for future improvements.
> 
> For some zc network tests eventually waiting for a portion of 
> buffers I've got 10x descrease in the number of context switches,
> which reduced the CPU consumption more than twice (17% -> 8%).
> It also helps storage cases, while running fio/t/io_uring against
> a low performant drive it got 2x descrease of the number of context
> switches for QD8 and ~4 times for QD32.
> 
> Not for inclusion yet, I want to add an optimisation for when
> waiting for 1 CQE.

Ran this on the usual peak benchmark, using IRQ. IOPS is around ~70M for
that, and I see context rates of around 8.1-8.3M/sec with the current
kernel.

Applied the two patches, but didn't see much of a change? Performance is
about the same, and cx rate ditto. Confused... As you probably know,
this test waits for 32 ios at the time.

Didn't take a closer look just yet, but I grok the concept. One
immediate thing I'd want to change is the FACILE part of it. Let's call
it something a bit more straightforward, perhaps LIGHT? Or LIGHTWEIGHT?
I can see this mostly being used for filling a CQE, so it could also be
named something like that. But could also be used for light work in the
same vein, so might not be a good idea to base the naming on that.

-- 
Jens Axboe

