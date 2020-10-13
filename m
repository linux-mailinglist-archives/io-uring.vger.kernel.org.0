Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A69F28D0B4
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 16:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgJMOyO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 10:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgJMOyO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 10:54:14 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DE3C0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 07:54:12 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id l16so24994ilj.9
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 07:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aEM+DQgIP9xjX2uWYnX4NfT9JoK1ZQgw7DpN3I7DuYA=;
        b=qyYsuwhmwI+z3TLs6CSxbw2TXiU3aOx03thl3xVMy7/kak9ileXyLS7uo95lotUvYc
         fLEjUTnqg001NRaChPz/IEJ2nZUnTY/VXur0nsAuGveipEaH0sfP532URnK/bN6REY4T
         o8vKBBfjLlYOxlDn13RSh7EPjbI/CGsgmFac1gKIPhhMwYaiEgKdkpnbUG/6tJm9V9O5
         XwHyvcZ6x4hNY8D+pwybeqDfNMzC9MuhNCgTZXQG4fyXDCkqiG+hqKqR8iDtctjfec27
         JMP7v/WBjfq9kyFNQdlA8CYCaVNIHfgPMPTwrhNtnErZdC1vq9KkhRIQnJQPJub/a5vh
         9vQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aEM+DQgIP9xjX2uWYnX4NfT9JoK1ZQgw7DpN3I7DuYA=;
        b=KKQK6u/ZTq2/skv02OJ+T9CZ8Jl/+G4mmfnzBT2asCsLQW8l0MS67UJ40U6tcf7z7N
         RgjdFacpr+1qu1q/9DnDV+jEAQBVZNu79b7xU2MGNyAQexNKMmd4BNcNdFB1KvzAsfM7
         UDN+Ry0vXrqE/lzHuq8/zKC19ByCrWxmQVR/VNRkGXhHuzO6Xg9E3RnMkMZdmmTlN6/G
         KeGFjGO84r0Xyt67KYV6+6AN1ePtHiAjHWQ7s51jPaYwimQnmvAcrhqqjk9xwMGaKqpX
         Ad1teeBkmBJuoBXJpBHrcQ0s7qm+9AIdRAcHCnNLLI56UNBbfk9lAnakskNzs0/bJ+T+
         y7Qw==
X-Gm-Message-State: AOAM532NLJ0XyMgAUxF6nMMZtHgYZfwYR91amLHTCKhjRP7tbOODH2Zu
        jFZB2qSGfoLbpFFmBIhGKKtotZQxjuZSsA==
X-Google-Smtp-Source: ABdhPJyr56N7j1cVd1yN6s//GZ07z58dC2AFJ/iWaRzQqqj5EFKIlpkLLaE/vAR3TOIIzkSmxqLsXA==
X-Received: by 2002:a05:6e02:e4f:: with SMTP id l15mr289475ilk.142.1602600851310;
        Tue, 13 Oct 2020 07:54:11 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e11sm42347ilp.7.2020.10.13.07.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 07:54:10 -0700 (PDT)
Subject: Re: [PATCH 3/5] io_uring: don't put a poll req under spinlock
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1602577875.git.asml.silence@gmail.com>
 <a723ec3fb07e906f28631d3a67b4d125b513b9ee.1602577875.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <04f2d94c-0e75-b251-e244-b7ac95863862@kernel.dk>
Date:   Tue, 13 Oct 2020 08:54:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a723ec3fb07e906f28631d3a67b4d125b513b9ee.1602577875.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/13/20 2:43 AM, Pavel Begunkov wrote:
> Move io_put_req() in io_poll_task_handler() from under spinlock. That's
> a good rule to minimise time within spinlock sections, and
> performance-wise it should affect only rare cases/slow-path.

It's actually more important not to bounce on the lock, especially
when the extra path isn't that long. You'll end up with the same hold
time, just split, but the downside is that you'll dirty that lock twice
instead of one.

So while I think the patch is fine as it avoids REQ_F_COMP_LOCKED,
I don't think the commit message really reflects reality. I'll
adjust it a bit.

-- 
Jens Axboe

