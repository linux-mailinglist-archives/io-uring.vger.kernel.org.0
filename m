Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E272817A4
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 18:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387917AbgJBQSR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 12:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387807AbgJBQSR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 12:18:17 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD7EC0613D0
        for <io-uring@vger.kernel.org>; Fri,  2 Oct 2020 09:18:17 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id j13so1757995ilc.4
        for <io-uring@vger.kernel.org>; Fri, 02 Oct 2020 09:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eyG5D3V3TaPLgQB2Q8WgTq5oOe5Zz/FFFkte/PznoVM=;
        b=ht42Mv1xJeYy5NIkco+QvVZEaZmsJjsSCNAuILdVWjsstOU4FQ9kG7/sMx1tA1f4Yu
         1lhXMZYO0muMBX1XV52IOKY5FEmBlMm7T7TKlfOvW6B70PKYTWtYf78OiU9gu1LaPW/r
         dV3Hbckrjh27CNH4AszoG5JyKREritHFpYoSN80Hlr/fVSuXdqLZgvWRr6fyNVROaGhK
         mKiHKrbaVUXsU470+d54XLQVMwPbOMk8D85UkILFGHjk29ZdxkoaGlC1uVp6UkMT1OhP
         CyvJ5x/usi+8MLG6dD+lGUjI5DaIzmKS/sspzAJKC3WZVcJ0Q5y/EWtXE8BG6UJqsZYJ
         kplg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eyG5D3V3TaPLgQB2Q8WgTq5oOe5Zz/FFFkte/PznoVM=;
        b=bXkVaQm+8rs4od+xBUxKF+ZrBxIS3yZIS5/G8yEJzIfJzMUD8a7UNe9DEKWZ40kHH5
         qsKtBzhyNt1NIhEakNwCAh7BiYSSB3NgXFMVBsaeboo+KeBuW6OSh2gyrEd2Bu5IXHjO
         /IqsHi7L8GgSqMckiEcRgouLfXtgBryX4OfjZNasTcu5yb0QCpFcay8fMSYwNDxyOnSC
         FdD2MgGtMjGP27y2PjqSYE6jXjwHWDAR5KgCPx1NQyDyFcYkfvun9Q50nrrlrw2HAsbW
         A1ar3Y7Y2Ab2UiJpQVwVsqb6rY1CgkAMWlYDsJJBBcKBcZLG4WusttYbNO5unCCXTZn1
         tMFQ==
X-Gm-Message-State: AOAM532+/9iqciH9BS4i2R8id4NsqDmAN6iV8vzd0Z+7+zS6IV6fglv9
        i4fsuH8//ydqFbKtg6srsdIDlw==
X-Google-Smtp-Source: ABdhPJxD5jsh4jHft20v0ciBnF9lral7z7r2u/FOLHN2GM2hh2A4Wb2HG+1XRHE4xPfEHuh6z6ke5Q==
X-Received: by 2002:a92:1bd6:: with SMTP id f83mr625441ill.274.1601655496359;
        Fri, 02 Oct 2020 09:18:16 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t4sm877765iob.48.2020.10.02.09.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 09:18:15 -0700 (PDT)
Subject: Re: [PATCH 3/3] task_work: use TIF_TASKWORK if available
To:     Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org
References: <20201001194208.1153522-1-axboe@kernel.dk>
 <20201001194208.1153522-4-axboe@kernel.dk>
 <20201002151415.GA29066@redhat.com> <871rigejb8.fsf@nanos.tec.linutronix.de>
 <20201002153849.GC29066@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <19d2f8cc-320f-a4d1-79e3-fbdef3b44540@kernel.dk>
Date:   Fri, 2 Oct 2020 10:18:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201002153849.GC29066@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/20 9:38 AM, Oleg Nesterov wrote:
> On 10/02, Thomas Gleixner wrote:
>>
>> I think it's fundamentaly wrong that we have several places and several
>> flags which handle task_work_run() instead of having exactly one place
>> and one flag.
> 
> Damn yes, agreed.

As mentioned in the other reply, this is actually a nice step towards
NOT having that be the case. Right now we have TWA_RESUME, which uses
TIF_NOTIFY_RESUME. Once all archs support TIF_NOTIFY_SIGNAL, then we can
totally drop TWA_NOTIFY resume, and use use TWA_SIGNAL as the default
for notify == true task_work users. And we can drop task_work noticing
and running in the signal handling as well, leaving us with only having
tracehook_notify_signal() running the task_work.

-- 
Jens Axboe

