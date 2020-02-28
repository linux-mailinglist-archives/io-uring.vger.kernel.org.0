Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116A717403D
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 20:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgB1T3A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 14:29:00 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42406 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1T3A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 14:29:00 -0500
Received: by mail-pg1-f195.google.com with SMTP id h8so2003141pgs.9
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 11:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LaATqR53L10vg9e7CqVCO27EW8JSFqLY61WZoEOG64E=;
        b=Adsb6UfkZRmFST2RkDcSEfET6MTzFnbhK49I5IH+sZ5CSEj1yNK4w21Wi7J5duMxTe
         DllRlABn4RyXkzwfRTMb3Q7rXBYreU9f9DaHW/Gbo6b+5hPZP11G44J8QqRjVhapY4gl
         UcFM+Lt45PC9e5LYOEjfoV8TiNLRMzlXAbxAUDH6dyNswPnrWk+r9d+reDoZ04Uqbltf
         kQKdIlBCi7uQpnu1KA7Y/wxWGI04PA2AIyLpeDZojz2ap4biP8vyCmFeN6zHQ/PJXo+O
         G9HF2yyrIK2ei/EeNJQXF+PDbRLaebBd7U9A8yBYAIo3PbaJq/yP/USdDrKhr9c5d0co
         ObVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LaATqR53L10vg9e7CqVCO27EW8JSFqLY61WZoEOG64E=;
        b=tV3qULxdx58y4YhUP7DZcKWyZ/x+Q32yEaH6Swxr1yNWCozbe1UwIxSDnnK9FmkaGQ
         X1aiI8d8PjcovEANzVV+NruFEGkhTF3WhCsGsVQk5RGSW0tVeQk4EzAaStomu5Y0PII/
         jnSHD/dKoOMHt+BdvwbulFXapmDBcai1Q0N3Dh/5GUsXEoWXQvjrcZ7AEYusZ4pxEfdC
         TgbOsrLV5NztXmsdC1PjIUCBex0WQ3cKrZsZSF250JYO3fhCRTsZYYsF/ziegoFDIW5d
         7pAamrujgsRRdfgZujx8HbbO5E8sSujYIjT4ObjoQJUK95rG3cSqmt33VE681J2tWFG9
         BB/Q==
X-Gm-Message-State: APjAAAV73CIoopMkNgf0cNp76Egc4hXEERxDSrOk7yStpEvRb1ylnes7
        FXLE/N/9G2DmEXP2hakYN7MsftFgwCk=
X-Google-Smtp-Source: APXvYqzmPT1BVvviJRxxO8Q5MgcJeVVXkir4w4yxFVc8/1ske3o+IdHz3er9nVqGhcPD0rJT3My+gQ==
X-Received: by 2002:a63:b949:: with SMTP id v9mr5867375pgo.336.1582918137115;
        Fri, 28 Feb 2020 11:28:57 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21d6::12c6? ([2620:10d:c090:400::5:410c])
        by smtp.gmail.com with ESMTPSA id e1sm12056223pff.188.2020.02.28.11.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 11:28:56 -0800 (PST)
Subject: Re: [PATCH] task_work_run: don't take ->pi_lock unconditionally
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218145645.GB3466@redhat.com>
 <20200218150756.GC14914@hirez.programming.kicks-ass.net>
 <20200218155017.GD3466@redhat.com>
 <20200220163938.GA18400@hirez.programming.kicks-ass.net>
 <20200220172201.GC27143@redhat.com>
 <20200220174932.GB18400@hirez.programming.kicks-ass.net>
 <20200221145256.GA16646@redhat.com>
 <77349a8d-ecbf-088d-3a48-321f68f1774f@kernel.dk>
 <de55c2ac-bc94-14d8-68b1-b2a9c0cb7428@kernel.dk>
 <20200228192505.GO18400@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4c320163-cb3b-8070-4441-6395c988d55d@kernel.dk>
Date:   Fri, 28 Feb 2020 12:28:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200228192505.GO18400@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/28/20 12:25 PM, Peter Zijlstra wrote:
> On Fri, Feb 28, 2020 at 12:17:58PM -0700, Jens Axboe wrote:
>>>
>>> Peter/Oleg, as you've probably noticed, I'm still hauling Oleg's
>>> original patch around. Is the above going to turn into a separate patch
>>> on top?  If so, feel free to shove it my way as well for some extra
>>> testing.
>>
>> Peter/Oleg, gentle ping on this query. I'd like to queue up the task poll
>> rework on the io_uring side, but I still have this one at the start of
>> the series:
> 
> the generic try_cmpxchg crud I posted earlier is 'wrong' and the sane
> version I cooked up depends on a whole bunch of patches that are in
> limbo because of kcsan (I need to get that resolved one way or the
> other).
> 
> So if you don't mind, I'll shelf this for a while until I got all that
> sorted.

Shelf the one I have queued up, or the suggested changes that you had
for on top of it?

-- 
Jens Axboe

