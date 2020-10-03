Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B1A282523
	for <lists+io-uring@lfdr.de>; Sat,  3 Oct 2020 17:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgJCPfc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Oct 2020 11:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgJCPfa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Oct 2020 11:35:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6958FC0613D0
        for <io-uring@vger.kernel.org>; Sat,  3 Oct 2020 08:35:28 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a17so2231793pju.1
        for <io-uring@vger.kernel.org>; Sat, 03 Oct 2020 08:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7QohD13O9ct1icuF7YVXwVcLpdW6HdikDCA8uoBPY/o=;
        b=lc/vLk4vutWFpYoNTo3jQkosR2KdyX8jdmGJWOb2HiSuev1VY9E+NM4c1n2J4YEmvg
         OxGIM7QFdUvCUE4jZ8ISxkfbRJykFvhMVW3vXaQORP2NhIDGawlaHLuoU0v35ClSlQZF
         ekP7GIlJPg2FqavjDQov5aV9gx1oamGmILVSqoWdUPgfWs/EUlhwSx9oCDmGLt37I1At
         0NvXnFOPgsuRyPU1lseJYrAtPKTmoGcOCwx7hXu4mu1CKzevmiRRUYqy6rXGTNJ5O+C2
         4CuCCXlf45qUzS4OAKDytMUKBu70rv4t584LFtuE26xSChipQhAkty28SWaUqMWp2IsT
         hSbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7QohD13O9ct1icuF7YVXwVcLpdW6HdikDCA8uoBPY/o=;
        b=mQ0hejyKo6uQinYD6EtphSrGPJxd1vxGxrIMmibHkMQmI/N2NplaX3BppnYiPTSqS6
         E1VcaBEm+14uo99t+pPdRA4X3Cjvz0AX1VM8ugbChgsnz2efK3IYSEecycZfZmC82Cvf
         mZvlFokdzRGOlpQBSB9NY4ddoVfoG+pRuwV68sgtgWqj6PNdQ6KBgIYZUmIT44JJJTdC
         HsvFI9rtxV/pe1usSa1Z6j3kRf9MMdJOt26DjJw7O+eGdfG8UB+TXu3mRyU7ssFeYr1O
         Dsvl6hhMQssQNa3MZj56MNNOuyvNRgvIapiEhcLeyT1OCLLqz/u1tIM9niSmz7LHkDMR
         PPsw==
X-Gm-Message-State: AOAM531PxHgHDplGg9dXrDjK9GRaJaqdswV+x5EvM7aThjCftEmGcZ4d
        GhNubVkuFffrL3WAfREXdlnN9A==
X-Google-Smtp-Source: ABdhPJy5+BSRDJcFwryYwHMzid8SaCmIVvpP1g6eVyK2X+IlpEDUh6sy272o6rTojAJngDGPJ/NEVg==
X-Received: by 2002:a17:90b:1211:: with SMTP id gl17mr8384471pjb.87.1601739327734;
        Sat, 03 Oct 2020 08:35:27 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s20sm5894519pfu.112.2020.10.03.08.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 08:35:26 -0700 (PDT)
Subject: Re: [PATCH 3/3] task_work: use TIF_TASKWORK if available
To:     Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org
References: <20201001194208.1153522-1-axboe@kernel.dk>
 <20201001194208.1153522-4-axboe@kernel.dk>
 <20201002151415.GA29066@redhat.com> <871rigejb8.fsf@nanos.tec.linutronix.de>
 <20201002153849.GC29066@redhat.com> <87o8lkcc4z.fsf@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9c1a3233-b359-85ee-34cc-6b7bf6244a4d@kernel.dk>
Date:   Sat, 3 Oct 2020 09:35:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87o8lkcc4z.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/20 7:49 PM, Thomas Gleixner wrote:
> On Fri, Oct 02 2020 at 17:38, Oleg Nesterov wrote:
>> On 10/02, Thomas Gleixner wrote:
>>>
>>> I think it's fundamentaly wrong that we have several places and several
>>> flags which handle task_work_run() instead of having exactly one place
>>> and one flag.
>>
>> Damn yes, agreed.
> 
> Actually there are TWO places, but they don't interfere:
> 
>    1) exit to user
> 
>    2) enter guest
> 
> From the kernel POV they are pretty much the same as both are leaving
> the kernel domain. But they have a few subtle different requirements
> what has to be done or not.
> 
> So any change to that logic needs to fixup both places,

Right, I actually did spot that, but didn't include it in the initial
series. I've split up the series a bit more, into functional bits.
Should be easier to reason/discuss:

https://git.kernel.dk/cgit/linux-block/log/?h=tif-task_work

-- 
Jens Axboe

