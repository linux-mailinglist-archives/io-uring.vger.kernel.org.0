Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0061567A5
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 21:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgBHUCT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 15:02:19 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41243 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbgBHUCT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 15:02:19 -0500
Received: by mail-pf1-f196.google.com with SMTP id j9so1554211pfa.8
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 12:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rnYPZByXJHm8L423+hmhH74j6QfEp4e7yxefhgIv5r4=;
        b=Vuqhf3mzhwU56Y3JcikGkDOWPh19ZkqBTV+GNx+pGYC4Su7GehyRT1RvybEHHmWC10
         VSqNZY4kk3pyCaUgfBTa/0Cq0L3EaWerDhu2EACRIWxgO1946k5jUpeqOXyRwWfbQkcI
         YTor26q0b7lqQQ7ZXtviOVtfbqGw4uXHKeEGLAfj/dfDd9AgQJSO16Pg2QnOu3cTTOYS
         eDML08G08vs1PIJhP/Z1cNLaz4iFqJRwRWj0gyyxw9V3kie4er0YyXXqoljrgZpSFAA8
         oygszttG5IRdnDlGmLeHPxo2GD1S7BYeRjLqOMtRUnvI0Csorp/06xVijiyOqVJeTGxZ
         btoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rnYPZByXJHm8L423+hmhH74j6QfEp4e7yxefhgIv5r4=;
        b=n6iSC0h8oNXI8A7xnX/fIqGnnE3VtqD/ZWrgg17YApfbUZBbaCMof//VQXXu2zERYx
         mvOiy34tbb8Q7k9LfFc7b8R6b5tJIu8AlT6ZlywDb2y7TY9Opb8opPbIZrdY+zaAP30Z
         82FB50F/2EaoobQIc/mtgu9BlYI7CF64iVKrKb+F0up1AFNjLhqpXd7TN/hWPcOioBck
         154g+m4iDhaEHlqpY1uH+tgrd4rmxaynsQr2CtbCZIIHjS8lgf0ArYZAED8Soap7p07M
         icocCfJIw6KrSTLv/BwABVEBnLcJ5o3gq530yCKPyCFbTGV0SLLypJh9BCg7BS9UXUmI
         /uiw==
X-Gm-Message-State: APjAAAU95Qe/Yf5KS+dcSPz6jLGBtx0846BvI+GQ87ziKX9bEot8ViUO
        wcdCxMzvrereYzIdPr8voZ6FuCGZYy8=
X-Google-Smtp-Source: APXvYqx2dtcW+Oe7OeV/ZfWIS0Gr0Jgjj/WDmhm5SiPc6HoqGlblBnU6ik6tlu0qGbDiCWJVZX73bw==
X-Received: by 2002:aa7:968c:: with SMTP id f12mr5547400pfk.235.1581192137031;
        Sat, 08 Feb 2020 12:02:17 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id gx18sm6408227pjb.8.2020.02.08.12.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2020 12:02:16 -0800 (PST)
Subject: Re: liburing packaging issues
To:     Guillem Jover <guillem@debian.org>, io-uring@vger.kernel.org
References: <20200208173608.GA1390571@thunder.hadrons.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <67b1f314-31df-acef-b3f9-256bdf951b76@kernel.dk>
Date:   Sat, 8 Feb 2020 13:02:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200208173608.GA1390571@thunder.hadrons.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/8/20 10:36 AM, Guillem Jover wrote:
> Hi!
> 
> Stefan Metzmacher asked whether I could package and upload liburing
> for Debian (and as a side effect Ubuntu). And here are some of the
> things I've noticed that would be nice to get fixed or improved
> before I upload it there.
> 
>   * The README states that the license is LGPL (I assume 2.1+ in
>     contrast to 2.1?) and MIT, but there's at least one header that's
>     GPL-2.0 + Linux-syscall-note, which I assume is due to it coming
>     from the kernel headers. Would be nice to have every file with an
>     explicit license grant, say at least with an SPDX tag, and update
>     the README.

OK, I can clarify that and add SPDX headers.

>   * From the RPM spec file and the debian packaging in the repo, I
>     assume there is no actual release tarball (didn't see on in
>     kernel.dk nor kernel.org)? It would be nice to have one with a
>     detached OpenPGP signature, so that we can include it in the
>     Debian source package, to chain and verify the provenance from
>     upstream.

I do generate release tar balls with a detached signature, see:

https://brick.kernel.dk/snaps/

>   * The test suite fails for me on the following unit tests:
> 
>       read-write accept-link poll-many poll-v-poll short-read send_recv
> 
>     while running on Linux 5.5.0-rc0. I read from the README it is not
>     supposed to work on old kernels, and might even crash them. But it
>     would still be nice if these tests would get SKIPPED, so that I can
>     enable them unconditionally to catch possible regressions and so they
>     do not make the package fail to build from source on the Debian build
>     daemons due to too old kernels, which in most cases will be one from
>     a Debian stable release (Linux 4.19.x or so).

The tests should build fine on any system, they just won't pass on any
system. So I don't think this is a packaging issue, don't run them as
part of building the package.

> There are a couple of issues with the build system, for which I'll be
> sending out a couple of patches later.

Thanks!

-- 
Jens Axboe

