Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E407A6766
	for <lists+io-uring@lfdr.de>; Tue, 19 Sep 2023 16:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbjISO5k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Sep 2023 10:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbjISO5j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Sep 2023 10:57:39 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421C7BE
        for <io-uring@vger.kernel.org>; Tue, 19 Sep 2023 07:57:33 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-34fcb08d1d5so2151285ab.1
        for <io-uring@vger.kernel.org>; Tue, 19 Sep 2023 07:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695135452; x=1695740252; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4CskXmoiXW9hnAcfKU6exBcbR/GVhZTyuXSQTnBlnrc=;
        b=J3Q4UeInizupUUgtJP6kaORNH5+Wpq1ulhd7sFqthUK+svYMNWVG3jOvkUSLtxrk1T
         JRm3TQ+EqNPRQ4Z3CHW2bS2uZrookiwvyLeUCiyhADMWVO0gOJz9EcOHWuMcw5l56J/D
         3ogFwXHlJ1Ns89aHi8ioOHhiPft2tg4Y+lgvVXGzZI8eifecY/WcEcGcjii7Ise2yaYT
         azQhpLNGINHcVzZkulS1luo0T1/I7d5c6JQTs0bh5/5nr7f7FMcnpmV4attb0gX5q/bJ
         HaSUX9e2fDdIdDiBAy7fBBH18rX2UZlz6b93lQXvkbvmrQx/o2GUr/yCWOwHzVjck8xn
         mAZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695135452; x=1695740252;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4CskXmoiXW9hnAcfKU6exBcbR/GVhZTyuXSQTnBlnrc=;
        b=r6m0Esnr3sRS7uEpsR2VjCjT4iAAmTwEhtxFFSlBUQTZVm+jdtMQzhh3tKfZdylDFC
         H06JZiwjo6NaB/cdCvFVNqaKXwccT60DEhmmr3/RN7jkuwG717r/0CjIuHYdkAUxIoRj
         vHDhKkfiWEZzl0QDgqv+18FNT7bDMvD9OUgiwYxIvgWloB0QUD8mqxT7WGYtJ6xFeist
         nEoaxtSwkgby8nCC+WFQuwByzadjF0aVojEvZuufXzOouDIsvmz7zmg9SenXWM7neG2K
         Q2KlNUVDSeGFV4lWZp0LI8Y7/rbDKBgbEk/sOBveAki/pe4/146UxAZl8TyzYpgqsGzP
         l9/Q==
X-Gm-Message-State: AOJu0Yw470s5I5HjJpVDp91qRrgV03rhBVtfduoWLjJdoaPlrdZKvBjy
        euw6Bies553n1evfAuvEMq6nmw==
X-Google-Smtp-Source: AGHT+IFoU1xSrpN8T9NZbbiPFq4PJmz45e4oyk6jf9b76ts6icpFO/GTzkmUAgFmG91OIm+/KYtk9g==
X-Received: by 2002:a92:d5ce:0:b0:34f:b824:5844 with SMTP id d14-20020a92d5ce000000b0034fb8245844mr20914ilq.3.1695135452568;
        Tue, 19 Sep 2023 07:57:32 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o16-20020a92dad0000000b0034ff5fd4ffesm1053313ilq.71.2023.09.19.07.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 07:57:31 -0700 (PDT)
Message-ID: <c20d61f4-0e4f-49a8-804f-d827ff705dcf@kernel.dk>
Date:   Tue, 19 Sep 2023 08:57:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v4 0/5] Add io_uring support for waitid
To:     Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, asml.silence@gmail.com
References: <20230909151124.1229695-1-axboe@kernel.dk>
 <26ddc629-e685-49b9-9786-73c0f89854d8@kernel.dk>
 <20230919-beinen-fernab-dbc587acb08d@brauner>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230919-beinen-fernab-dbc587acb08d@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/19/23 8:45 AM, Christian Brauner wrote:
> On Tue, Sep 12, 2023 at 11:06:39AM -0600, Jens Axboe wrote:
>> On 9/9/23 9:11 AM, Jens Axboe wrote:
>>> Hi,
>>>
>>> This adds support for IORING_OP_WAITID, which is an async variant of
>>> the waitid(2) syscall. Rather than have a parent need to block waiting
>>> on a child task state change, it can now simply get an async notication
>>> when the requested state change has occured.
>>>
>>> Patches 1..4 are purely prep patches, and should not have functional
>>> changes. They split out parts of do_wait() into __do_wait(), so that
>>> the prepare-to-wait and sleep parts are contained within do_wait().
>>>
>>> Patch 5 adds io_uring support.
>>>
>>> I wrote a few basic tests for this, which can be found in the
>>> 'waitid' branch of liburing:
>>>
>>> https://git.kernel.dk/cgit/liburing/log/?h=waitid
>>>
>>> Also spun a custom kernel for someone to test it, and no issues reported
>>> so far.
>>
>> Forget to mention that I also ran all the ltp testcases for any wait*
>> syscall test, and everything still passes just fine.
> 
> I think the struct that this ends up exposing to io_uring is pretty ugly
> and it would warrant a larger cleanup. I wouldn't be surprised if you
> get some people complain about this.
> 
> Other than that I don't have any complaints about the series.

io_uring only really needs child_wait and wo_pid on the wait_opts side,
for waitid_info it needs all of it. I'm assuming your worry is about the
former rather than the latter.

I think we could only make this smaller if we had a separate entry point
for io_uring, which would then make the code reuse a lot smaller. Right
now we just have __do_wait() abstracted out, and if we added a third
struct that has child_wait/wo_pid and exposed just that, we could not
share this infrastructure.

So as far as I can tell, there's no way to make the sharing less than it
is, at least not without adding cost of more code and less reuse.

Shrug?

-- 
Jens Axboe

