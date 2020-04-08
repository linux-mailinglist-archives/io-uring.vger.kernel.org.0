Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E471A2648
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 17:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgDHPt6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 11:49:58 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37183 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729589AbgDHPt6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 11:49:58 -0400
Received: by mail-pj1-f68.google.com with SMTP id k3so6407pjj.2
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 08:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U67uHs0AXd95JO+3RMUFOQOR2kwfu5dXES5AP1YkiXs=;
        b=V9qAAUnEEsbMiv2xjtTjuu5N9sZIvMoxjNNsvjosz+8+zdqrpKVIC2Ppj4i/q6PQoK
         9o44+nlqD1pWh9Y7aDHzQtpl0h8wVBR+aGP0Cb54d1nZ1wg8uscINlw+YU0OFxjC6HAk
         OkfU6gdOhBbcd3wt7arM5YGd8crgN+VP8P8efS/dheJ+Oab/Lc8Xat/uzbzsvlLPDtP2
         5DPIqEKM2/GvaTfXANoNqG5rlhsaSzl9V7WJGvlMm2EdLCxLgBfUwIFTg0S5AUDE8tPc
         zih0Kcm9Jvpiu7fKQgrpvQg4cVPsxgDOmeQJz1yr2rfDxkXZ/vjlpHCSLNyawe3RPJqE
         8c+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U67uHs0AXd95JO+3RMUFOQOR2kwfu5dXES5AP1YkiXs=;
        b=f8z3WL/Gnd85DDbKwOYNzIzEBaIKI7ByYr20F1Q65fhvFVvtKhz2glooy9EF3lIUEa
         YSZ7hadZol8Tla2MOAYYVm1o+itPw3ghUqTZ+NpEcdxpk/IUwspGrx7MjS7aegtG4O7i
         a/LGj5EJVBon30It931+0aNAQoHwwTnYB0pZi0W8BO5gYMmMP5c/bOJP1J45gE/ysC6j
         wAEFXuPFC+1iGPwytg4PlBaCpKRl7mpuxj8Q4D0Ms8Gb/RHDKBX2jNZPxBIpk4n3KnzK
         g9t0F7y4FYP1eHLFNl75JCUc26gTT+Nj7tVRCERc5SHnHY0cgjREZ7H8xmHE6EiWbWQj
         nVfA==
X-Gm-Message-State: AGi0PuZJigPB9jisvRWtxWr1gakZL2A6DhNSoK6kSCF5HSi9U6NyUrZb
        2XG/ALD+AGAUHPnPtWOlgWsgzSAX0AqETw==
X-Google-Smtp-Source: APiQypKqaXxbrPAGABw1jEsVEXKaO5AP6M0hBk2hQ3xg/n9cP6Jt2ng2vLtOULGq7byx1iHt7R3PHQ==
X-Received: by 2002:a17:902:9348:: with SMTP id g8mr7769976plp.112.1586360996147;
        Wed, 08 Apr 2020 08:49:56 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4466:6b33:f85b:7770? ([2605:e000:100e:8c61:4466:6b33:f85b:7770])
        by smtp.gmail.com with ESMTPSA id x27sm17095246pfj.74.2020.04.08.08.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 08:49:55 -0700 (PDT)
Subject: Re: io_uring's openat doesn't work with large (2G+) files
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
 <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk>
 <CAOKbgA7Pf2K5o_CkAs2ShcNbV8dx75xZBfM8D1xZcLm5RjmLXA@mail.gmail.com>
 <cc076d44-8cd0-1f19-2e79-45d2f0c5ace3@kernel.dk>
 <CAOKbgA4xX60X+SCMZFL76u86Nyi0Gfe25BGJaqR700+-zw72Xw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <47ce7e4b-42d9-326d-f15e-8273a7edda7a@kernel.dk>
Date:   Wed, 8 Apr 2020 08:49:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOKbgA4xX60X+SCMZFL76u86Nyi0Gfe25BGJaqR700+-zw72Xw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/20 8:41 AM, Dmitry Kadashev wrote:
> On Wed, Apr 8, 2020 at 10:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/8/20 8:30 AM, Dmitry Kadashev wrote:
>>> On Wed, Apr 8, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 4/8/20 7:51 AM, Dmitry Kadashev wrote:
>>>>> Hi,
>>>>>
>>>>> io_uring's openat seems to produce FDs that are incompatible with
>>>>> large files (>2GB). If a file (smaller than 2GB) is opened using
>>>>> io_uring's openat then writes -- both using io_uring and just sync
>>>>> pwrite() -- past that threshold fail with EFBIG. If such a file is
>>>>> opened with sync openat, then both io_uring's writes and sync writes
>>>>> succeed. And if the file is larger than 2GB then io_uring's openat
>>>>> fails right away, while the sync one works.
>>>>>
>>>>> Kernel versions: 5.6.0-rc2, 5.6.0.
>>>>>
>>>>> A couple of reproducers attached, one demos successful open with
>>>>> failed writes afterwards, and another failing open (in comparison with
>>>>> sync  calls).
>>>>>
>>>>> The output of the former one for example:
>>>>>
>>>>> *** sync openat
>>>>> openat succeeded
>>>>> sync write at offset 0
>>>>> write succeeded
>>>>> sync write at offset 4294967296
>>>>> write succeeded
>>>>>
>>>>> *** sync openat
>>>>> openat succeeded
>>>>> io_uring write at offset 0
>>>>> write succeeded
>>>>> io_uring write at offset 4294967296
>>>>> write succeeded
>>>>>
>>>>> *** io_uring openat
>>>>> openat succeeded
>>>>> sync write at offset 0
>>>>> write succeeded
>>>>> sync write at offset 4294967296
>>>>> write failed: File too large
>>>>>
>>>>> *** io_uring openat
>>>>> openat succeeded
>>>>> io_uring write at offset 0
>>>>> write succeeded
>>>>> io_uring write at offset 4294967296
>>>>> write failed: File too large
>>>>
>>>> Can you try with this one? Seems like only openat2 gets it set,
>>>> not openat...
>>>
>>> I've tried specifying O_LARGEFILE explicitly, that did not change the
>>> behavior. Is this good enough? Much faster for me to check this way
>>> that rebuilding the kernel. But if necessary I can do that.
>>
>> Not sure O_LARGEFILE settings is going to do it for x86-64, the patch
>> should fix it though. Might have worked on 32-bit, though.
> 
> OK, will test.

Great, thanks. FWIW, tested here, and it works for me.

Any objection to adding your test cases to the liburing regression
suite?

-- 
Jens Axboe

