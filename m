Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B731A2819
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 19:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgDHRt1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 13:49:27 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37976 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbgDHRt0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 13:49:26 -0400
Received: by mail-pf1-f193.google.com with SMTP id c21so2744606pfo.5
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 10:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MtxRB3yOfoBkNNevQ+ALjUXqLMurAPiM4R/+p5+53l0=;
        b=m1a1TGGQY4N4aciI0rAcrD9Hq04kjNNoHlHNdbUT8HOakjaXUsDA4Y0/t8H7tu9o9x
         g7EveC8qtNEVhxb0cAWkVMBsBNuhVnd//EweUjC+0vjZvHPsBvHvy5zj7HFEf1t1WohL
         ffyOCjLsE04sB/ThSI3yLq5E1zLgnJj9ctJ/L2RqphWWeLrLitzVodBSFhdIdFRNmlsc
         fSkStsBJTzlst4hgwa8spH8K7HNzu8MFOQUOEYYfH3Uhd9ld+gTac/GD41n9qi7b8n9B
         uTjJn8Syf83qMATt0m4jH33pwYlo2VyXcDHKEbRQ16RsaBHFSKO/D4FruPACfqXVon7h
         xI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MtxRB3yOfoBkNNevQ+ALjUXqLMurAPiM4R/+p5+53l0=;
        b=QgAlruxKdBSdLexqq+VtXXu22LXqQomRmCL0dlWjFZQaa+94+/XJPeg+lHupkIN1KI
         4oMVCx7yXQ2np9hkgVJBgLdN+DQ436s2RN6VeRa+FjnuveDr9D8QNM+sle2dri20myp/
         gYR4BCkrFYIpTseK8UDSMX7rlHi+9rFalh/SdQmWIRWzNvmD1bpeQ/8XrVtb3Dcmy1u8
         YcHZjMdl1izQG+431+U0/Sw2L+WLndlYEtPm6pdm7wQznKRqmkwe34VxwQ6yGNMnPWTi
         +61p4zudEfqbkUgWGVoCrxFnrb3IIrzl0n//1xRSTMpX1eAYJLkzfRa8hRJh3zC+AbxB
         x9ZA==
X-Gm-Message-State: AGi0Pub2wc2LFtFR4FMoGg0Y3ArcJZic4VunNVIp0eHE+rmFqOr+H1Qh
        j/rqr1UIVz/bZrxCm9SbSvRTkGIZn1gaHw==
X-Google-Smtp-Source: APiQypLsFwrcm387LIypvfVVHBMfBo648TeLkTDjxsBnCUV0VxT/PWdodIhvKnAWvJIYv5S5m2dCgw==
X-Received: by 2002:a63:e809:: with SMTP id s9mr7881270pgh.214.1586368165400;
        Wed, 08 Apr 2020 10:49:25 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c8::12dd? ([2620:10d:c090:400::5:607f])
        by smtp.gmail.com with ESMTPSA id c125sm2236140pfa.142.2020.04.08.10.49.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 10:49:24 -0700 (PDT)
Subject: Re: Spurious/undocumented EINTR from io_uring_enter
To:     Joseph Christopher Sible <jcsible@cert.org>,
        "'io-uring@vger.kernel.org'" <io-uring@vger.kernel.org>
References: <43b339d3dc0c4b6ab15652faf12afa30@cert.org>
 <b9ee42f0-cd94-9410-0de1-1bbfd50a6040@kernel.dk>
 <d8a2a9fe86974f999cb41f0b17f9e9a7@cert.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <12cca225-d95c-da61-fdba-f69427a2726f@kernel.dk>
Date:   Wed, 8 Apr 2020 10:49:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d8a2a9fe86974f999cb41f0b17f9e9a7@cert.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/20 9:41 AM, Joseph Christopher Sible wrote:
> On 4/7/20 5:42 PM, Jens Axboe wrote:
>> Lots of system calls return -EINTR if interrupted by a signal, don't
>> think there's anything worth fixing there. For the wait part, the
>> application may want to handle the signal before we can wait again.
>> We can't go to sleep with a pending signal.
> 
> This seems to be an unambiguous bug, at least according to the BUGS
> section of the ptrace man page. The behavior of epoll_wait is explicitly
> called out as being buggy/wrong, and we're emulating its behavior. As
> for the application wanting to handle the signal, in those cases, it
> would choose to install a signal handler, in which case I absolutely
> agree that returning -EINTR is the right thing to do. I'm only talking
> about the case where the application didn't choose to install a signal
> handler (and the signal would have been completely invisible to the
> process had it not been being traced).

So what do you suggest? The only recurse the kernel has is to flush
signals, which would just delete the signal completely. It's a wait
operation, and you cannot wait with signals pending. The only
wait to retry is to return the number of events we already got, or
-EINTR if we got none, and return to userspace. That'll ensure the
signal gets handled, and the app must then call wait again if it
wants to wait for more.

There's no "emulating behavior" here, you make it sound like we're
trying to be bug compatible with some random other system call.
That's not the case at all.

-- 
Jens Axboe

