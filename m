Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B475C7B70C0
	for <lists+io-uring@lfdr.de>; Tue,  3 Oct 2023 20:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjJCSZG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Oct 2023 14:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjJCSZF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Oct 2023 14:25:05 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D3F90
        for <io-uring@vger.kernel.org>; Tue,  3 Oct 2023 11:25:02 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-7748ca56133so12780339f.0
        for <io-uring@vger.kernel.org>; Tue, 03 Oct 2023 11:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696357501; x=1696962301; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9rzpEWrsqKqpDYBN8Dn6/31SDXQB3txD5dO6cAzCexM=;
        b=jQPZw6ALcJgq3tw85OcWMjyc2/okPmH/hebnRttS6ngaPdZ7TGbiANIZiLQ0S6t8/e
         47kOVyUtPGC0B4GKC6zxj1IgCfbTaexuazW//F+He4iaF4ZvuKXYkMNyDTb9ZKYfi/Zb
         wOTWlsdqIosrjIplWQHyIXsRaCoU0rtt3ZCyVTdZhVnh36Tmks9w2/X3q1Usw+qK5Dul
         wkqx7fPdDGbRqSktVdmKu6uCqJsIko8Gg//YhaqFUInd3hdCI9N0ptNSmX01TMPTcAJD
         YRP+GyXthrVRsg0mvasMWBfoLy7A5W5FwurSqC7fCVwH6Sh+9Ws+ingvP7+Wuc598lb8
         u2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696357501; x=1696962301;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9rzpEWrsqKqpDYBN8Dn6/31SDXQB3txD5dO6cAzCexM=;
        b=OSmLoRI/vmAxWOSioqD/0LFdvd03Gzaup/alw4QA1XJScG8pdlShjuYMtWxcLtEW9Z
         Vr+Bly8prhVrq+f2lRVU69vo1B0h1cOlZBVJdxoFTQ1+ddZvUY/fMhVL9suADt0RhBSw
         yYE7qhlWlHwLPyb+NByGpMo8vUq6gvt/9d5OCKxht+UZdshi1WRgt9umHG90y6HvfVoO
         vPq9mQGQ+WhRnKoluCXxIvVzS82WnFb8X3HDRUxzFd+6YeoSw8vPfsctDJZsUHGusGEZ
         oQ5vBGgMMPEMGZoU0gef7iILXyB2rTZaeANOpXbXMnD+ziOADyl+yP5OL3aoQClQx/rq
         dnxQ==
X-Gm-Message-State: AOJu0YxlF/1uCy2HcwfqQ2K1Bp8Cz50G4QedwCg0J+lscJgfoetQzhSu
        +Ek6dkC5olykFlh7xE4A8VVC0MESetA12aQZgBM=
X-Google-Smtp-Source: AGHT+IFIzPUp2EoJzTqN0xAfit0Kv04oZuxAJs70f0uUJDG645VzHPHhD8ZoAEz5FEn7EMbjV+o7zg==
X-Received: by 2002:a05:6602:3a05:b0:792:6be4:3dcb with SMTP id by5-20020a0566023a0500b007926be43dcbmr203242iob.2.1696357501627;
        Tue, 03 Oct 2023 11:25:01 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id fy5-20020a0566381e8500b0043d7ef4de07sm493024jab.5.2023.10.03.11.25.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 11:25:01 -0700 (PDT)
Message-ID: <581df26c-ff4b-4e27-ba06-b7fef966a6bd@kernel.dk>
Date:   Tue, 3 Oct 2023 12:25:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: don't allow IORING_SETUP_NO_MMAP rings on
 highmem pages
Content-Language: en-US
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <4c9eddf5-75d8-44cf-9365-a0dd3d0b4c05@kernel.dk>
 <x49edibpt2t.fsf@segfault.boston.devel.redhat.com>
 <08c0b5de-cf5e-432f-b8d6-a60204308d3a@kernel.dk>
 <x49a5szpns9.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <x49a5szpns9.fsf@segfault.boston.devel.redhat.com>
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

On 10/3/23 12:24 PM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 10/3/23 10:30 AM, Jeff Moyer wrote:
>>> Hi, Jens,
>>>
> [snip]
>>> What do you think about throwing a printk_once in there that explains
>>> the problem?  I'm worried that this will fail somewhat randomly, and it
>>> may not be apparent to the user why.  We should also add documentation,
>>> of course, and encourage developers to add fallbacks for this case.
>>
>> For both cases posted, it's rather more advanced use cases. And 32-bit
>> isn't so prevalent anymore, thankfully. I was going to add to the man
>> pages explaining this failure case. Not sure it's worth adding a printk
>> for though.
> 
> I try not to make decisions based on how prevalent I think a particular
> configuration is (mainly because I'm usually wrong).  Anyway, it's not a
> big deal, I'm glad you gave it some thought.

Me neither, but I think we can all safely agree that 32-bit highmem is
thankfully not on the uptick :-)

>> FWIW, once I got an arm32 vm setup, it fails everytime for me. Not sure
>> how it'd do on 32-bit x86, similarly or more randomly. But yeah it's
>> definitely at the mercy of how things are mapped.
> 
> ...and potentially the load on the system.  Anyway, it's fine with me to
> keep it as is.  We can always add a warning later if it ends up being a
> problem.

Certainly!

-- 
Jens Axboe

