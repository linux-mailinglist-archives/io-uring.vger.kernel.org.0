Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4849D2DE681
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 16:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgLRP07 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 10:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgLRP07 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 10:26:59 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152F0C0617B0
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 07:26:19 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id j13so1515848pjz.3
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 07:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=b0p60nF8YJWtHh9jlicjnxo1H7nkSGM+YaRE4uyWpzc=;
        b=ulw/NJZ8mvpfQI7X9H+fA+EdDNWNTgAielSdklIGhC585HrRXitMr2EstmNlKjaEPq
         msYdbBNpr3M5Jsqvk4LqAxrTsf1U+t8XZZNB+FxyzKciH7QAf6sSzawF4f1Xvu5Maos6
         NHm/9Wlo8iMEKPqrGAZyMmOL2ITWmUfC212XC+GxfCZFA43L2gV4kEWD8vYl41x/2swf
         KpG5JJ/xizHESH/2v0BkO7G8g/GZ2WQrZcGSNTi4qw7mrznNvcmew0pAuitJBBO4g2X7
         t7r6e3ifBRoHnqprXjWXYp5VrHdNvKgay/2vCXbwGhlyEAW2YkF6LMTls0pBdWCGtLg4
         AYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b0p60nF8YJWtHh9jlicjnxo1H7nkSGM+YaRE4uyWpzc=;
        b=bd4fwSm7KgzRf/926mdtEW5lxWd3c/VeAQfULNI+EbiK/LU+MyjmmXLL3+e1Kexbfr
         4WeoRlG502J6RXawVEGoMXaTWEsyOgI5f+B883/l6zP5DYvpT2wmyyMTO+E7Fgw0IBoJ
         MwSkw5hQIvdUk6md7ZcOgCMRrWSD5iSj5Zs8Gy6jAMgF8bC5DGTDaBsYi0VKOIPuXxLG
         tzJO+c2UDLrYNk4jFgCNfRWTgjNRcm8wnit0Pq26xidtDkLlsW5fuDiZ7ukEKYdNYi0Z
         7nys9zt8CRgrmjlVY/X32no75Uc2YdpV+Yg9nY2aY7PPg7Dxa/OKJhMLzPQpnRf05mGL
         Ly+Q==
X-Gm-Message-State: AOAM531GHyYP7hgy25tk/Y12Qame27OIDk3iPynqHGYZIwr7PpzGS6h4
        JUgSnjQvLBVM//DGe65AoPh+ubMGf4nKSQ==
X-Google-Smtp-Source: ABdhPJzWJogGhNFc0YMgINLwZdI0kNfW7C+tM0mRePoVpHy5Mf4KmMHtxpnuTfv03NXXzc2e29jOYA==
X-Received: by 2002:a17:902:d351:b029:db:d63d:d0e with SMTP id l17-20020a170902d351b02900dbd63d0d0emr4722442plk.75.1608305177938;
        Fri, 18 Dec 2020 07:26:17 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id r67sm9032823pfc.82.2020.12.18.07.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 07:26:17 -0800 (PST)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7d263751-e656-8df7-c9eb-09822799ab14@kernel.dk>
Date:   Fri, 18 Dec 2020 08:26:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/20 1:19 AM, Dmitry Kadashev wrote:
> Hi,
> 
> We've ran into something that looks like a memory accounting problem
> in the kernel / io_uring code. We use multiple rings per process, and
> generally it works fine. Until it does not - new ring creation just
> fails with ENOMEM. And at that point it fails consistently until the
> box is rebooted.
> 
> More details: we use multiple rings per process, typically they are
> initialized on the process start (not necessarily, but that is not
> important here, let's just assume all are initialized on the process
> start). On a freshly booted box everything works fine. But after a
> while - and some process restarts - io_uring_queue_init() starts to
> fail with ENOMEM. Sometimes we see it fail, but then subsequent ones
> succeed (in the same process), but over time it gets worse, and
> eventually no ring can be initialized. And once that happens the only
> way to fix the problem is to restart the box.  Most of the mentioned
> restarts are graceful: a new process is started and then the old one
> is killed, possibly with the KILL signal if it does not shut down in
> time.  Things work fine for some time, but eventually we start getting
> those errors.
> 
> Originally we've used 5.6.6 kernel, but given the fact quite a few
> accounting issues were fixed in io_uring in 5.8, we've tried 5.9.5 as
> well, but the issue is not gone.
> 
> Just in case, everything else seems to be working fine, it just falls
> back to the thread pool instead of io_uring, and then everything
> continues to work just fine.
> 
> I was not able to spot anything suspicious in the /proc/meminfo. We
> have RLIMIT_MEMLOCK set to infinity. And on a box that currently
> experiences the problem /proc/meminfo shows just 24MB as locked.
> 
> Any pointers to how can we debug this?

I've read through this thread, but haven't had time to really debug it
yet. I did try a few test cases, and wasn't able to trigger anything.
The signal part is interesting, as it would cause parallel teardowns
potentially. And I did post a patch for that yesterday, where I did spot
a race in the user mm accounting. I don't think this is related to this
one, but would still be useful if you could test with this applied:

https://lore.kernel.org/io-uring/20201217152105.693264-3-axboe@kernel.dk/T/#u

just in case...

-- 
Jens Axboe

