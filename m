Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF0961A3721
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2020 17:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgDIP3F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Apr 2020 11:29:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33734 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728191AbgDIP3F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Apr 2020 11:29:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id c138so4926586pfc.0
        for <io-uring@vger.kernel.org>; Thu, 09 Apr 2020 08:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M7DeoI2Q2GIdynitUnaIOYBnsjyOJCbYwHbmHV0yCEc=;
        b=zvm4tmTl0bJcFojvMpUyIJhtWvukULenFFzyPrE/toGQ/uDflmupjN3ovERBhGyYSK
         tRv+bMS6mMhZDOzyiDwr7S/icvBQWk7ReDm1STXN7ykIesJiY10ON4eKNQQgEojnzk1J
         5gGhdybgLrE/XX7Aacr1OWPKsM2pFDw0TJu98Z3ypBIQrOMfWvZOPzrqYtAbcUrhsqtD
         2jKMoeG1aALzKAzp/qTQ4q0XptJ0wnfG8UGi9F3epqgQh6Yt6tr1o1xjBpkH7lEURwo1
         0np7E4Z+GjNBHmHzUZYHM2+uLVYDGIXzOVGI0V5BD3Y4Z6IH03z+URJKx0kPsg3MASH5
         DUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M7DeoI2Q2GIdynitUnaIOYBnsjyOJCbYwHbmHV0yCEc=;
        b=oZ5hYSqwGbAt+rJP0Ax9Gye8kSs9HIptGNEgSgkI0v0ct2TzfeiAwUHkvWs+BM+h/Z
         m0HXMDB9rIyVy/Amet+6yYNlc61FVlXAZtmfe4yKS6g9REt9bgdSSSRP19RxRTQfYWQm
         swt9mp8mj4PSZfDn4/pxzQ9dO8ZHKLgT+hFuTyCRmq4W5aADCkZCeloZJIoyKfQdgscn
         Tg0f4aCL7yBXj6M7Stdhz7L+gMHR2ywvAm6PN0QkMBXb3s/VqjsJrAR6T1hEDEX1VmQF
         U48wsR9MTiSrL9iSZ5IGrYrQtYgUTu3T2jnKX+d9jeqe6X1roOfpZg3Scfq16ch4uhqo
         /oSg==
X-Gm-Message-State: AGi0PuZGSgl5BEO2kP0qo2wvYhTRZc0d3uXVrR7vnJlMSkVfxorFnG9P
        mOv4RjaZNIGO6ep+g5WHfK8634ZpYKwSRw==
X-Google-Smtp-Source: APiQypJdyJcI3mTEcDPIdbpwqvf8PhXIJxnhxex1wl81gH+2gRNMKO1abNZqt1u+qxXeFxGiF1D2KQ==
X-Received: by 2002:a63:904a:: with SMTP id a71mr38032pge.68.1586446143798;
        Thu, 09 Apr 2020 08:29:03 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:70f8:a8e1:daca:d677? ([2605:e000:100e:8c61:70f8:a8e1:daca:d677])
        by smtp.gmail.com with ESMTPSA id s22sm20406859pfh.18.2020.04.09.08.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 08:29:03 -0700 (PDT)
Subject: Re: io_uring's openat doesn't work with large (2G+) files
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
 <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk>
 <CAOKbgA7Pf2K5o_CkAs2ShcNbV8dx75xZBfM8D1xZcLm5RjmLXA@mail.gmail.com>
 <cc076d44-8cd0-1f19-2e79-45d2f0c5ace3@kernel.dk>
 <CAOKbgA4xX60X+SCMZFL76u86Nyi0Gfe25BGJaqR700+-zw72Xw@mail.gmail.com>
 <47ce7e4b-42d9-326d-f15e-8273a7edda7a@kernel.dk>
 <CAOKbgA5BKLNMzam+tDCTames0=LwJmSX-_s=dwceAq-kcvwF6g@mail.gmail.com>
 <7e3a9783-c124-4672-aab1-6ae7ce409887@kernel.dk>
 <CAOKbgA7KYWE485vAY2iLOjb4Ve-yLCTsTADqce-77a0CQxnszg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d55af7f3-711b-23b9-2ea3-00d600731453@kernel.dk>
Date:   Thu, 9 Apr 2020 08:29:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOKbgA7KYWE485vAY2iLOjb4Ve-yLCTsTADqce-77a0CQxnszg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/20 8:50 PM, Dmitry Kadashev wrote:
> On Wed, Apr 8, 2020 at 11:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/8/20 9:12 AM, Dmitry Kadashev wrote:
>>> On Wed, Apr 8, 2020 at 10:49 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 4/8/20 8:41 AM, Dmitry Kadashev wrote:
>>>>> On Wed, Apr 8, 2020 at 10:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> On 4/8/20 8:30 AM, Dmitry Kadashev wrote:
>>>>>>> On Wed, Apr 8, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>
>>>>>>>> On 4/8/20 7:51 AM, Dmitry Kadashev wrote:
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> io_uring's openat seems to produce FDs that are incompatible with
>>>>>>>>> large files (>2GB). If a file (smaller than 2GB) is opened using
>>>>>>>>> io_uring's openat then writes -- both using io_uring and just sync
>>>>>>>>> pwrite() -- past that threshold fail with EFBIG. If such a file is
>>>>>>>>> opened with sync openat, then both io_uring's writes and sync writes
>>>>>>>>> succeed. And if the file is larger than 2GB then io_uring's openat
>>>>>>>>> fails right away, while the sync one works.
>>>>>>>>>
>>>>>>>>> Kernel versions: 5.6.0-rc2, 5.6.0.
>>>>>>>>>
>>>>>>>>> A couple of reproducers attached, one demos successful open with
>>>>>>>>> failed writes afterwards, and another failing open (in comparison with
>>>>>>>>> sync  calls).
>>>>>>>>>
>>>>>>>>> The output of the former one for example:
>>>>>>>>>
>>>>>>>>> *** sync openat
>>>>>>>>> openat succeeded
>>>>>>>>> sync write at offset 0
>>>>>>>>> write succeeded
>>>>>>>>> sync write at offset 4294967296
>>>>>>>>> write succeeded
>>>>>>>>>
>>>>>>>>> *** sync openat
>>>>>>>>> openat succeeded
>>>>>>>>> io_uring write at offset 0
>>>>>>>>> write succeeded
>>>>>>>>> io_uring write at offset 4294967296
>>>>>>>>> write succeeded
>>>>>>>>>
>>>>>>>>> *** io_uring openat
>>>>>>>>> openat succeeded
>>>>>>>>> sync write at offset 0
>>>>>>>>> write succeeded
>>>>>>>>> sync write at offset 4294967296
>>>>>>>>> write failed: File too large
>>>>>>>>>
>>>>>>>>> *** io_uring openat
>>>>>>>>> openat succeeded
>>>>>>>>> io_uring write at offset 0
>>>>>>>>> write succeeded
>>>>>>>>> io_uring write at offset 4294967296
>>>>>>>>> write failed: File too large
>>>>>>>>
>>>>>>>> Can you try with this one? Seems like only openat2 gets it set,
>>>>>>>> not openat...
>>>>>>>
>>>>>>> I've tried specifying O_LARGEFILE explicitly, that did not change the
>>>>>>> behavior. Is this good enough? Much faster for me to check this way
>>>>>>> that rebuilding the kernel. But if necessary I can do that.
>>>>>>
>>>>>> Not sure O_LARGEFILE settings is going to do it for x86-64, the patch
>>>>>> should fix it though. Might have worked on 32-bit, though.
>>>>>
>>>>> OK, will test.
>>>>
>>>> Great, thanks. FWIW, tested here, and it works for me.
>>>
>>> Great, will post results tomorrow.
>>
>> Thanks!
> 
> With the patch applied it works perfectly, thanks.

Thanks for testing!

-- 
Jens Axboe

