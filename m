Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4283A1A02
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 17:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbhFIPqu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 11:46:50 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:40631 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbhFIPqu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 11:46:50 -0400
Received: by mail-pf1-f182.google.com with SMTP id q25so18683655pfh.7
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 08:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N/6VGvVBXxa4s7rcfVr0m2vy6b2U+6l6ZChR+9eb5NI=;
        b=NdQ+V9Zu1BEkkcmeA2658fXs3F+DVjEw92yyxNJRP4VCGKVTI+jHSxv+WHekdVyaJf
         z2sK91cSZ5RgGFm6L5sNmqWq+fvT5aydojOzpWKslWmTtLuj4ZCVSj5SGJHgnM0P4YeL
         LRr15Ptl8gjB+OJWjClEzWhemLWCGULT4omlKCfO4AD2DUChuneG6zI7ns9xygjSm5TL
         QxY4OlwWQ4eIpc4hP/m0rJFd151kMxp9xVspSgPGYY4AteZc5pYDsCM90suHcqKikYZg
         /zth7j4JvlC9aiy/rq6wdUhyN/s55zbh+Ks6uEk54oLw3Mdwg33bWMkIiPQg+UMSenU5
         46TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N/6VGvVBXxa4s7rcfVr0m2vy6b2U+6l6ZChR+9eb5NI=;
        b=AF0seeoB2EnEyj95pxI0NSnTHbpWNRg1KG74yd2M/oxYNaQOSUL6+EgB9PhrT7bu7r
         eruU7nDQ9LkId53ZJ2OGWx2Zl6rqBbW8h6211gzVjaAb4eDItieBtJ08pFgquvE9/uzd
         LME1hgr27LIv6N/Y2SGWxcn0jWTz0xzhGHf2LKIE4rKzBLNAb77Q2k7I+CbMP8KRJQn6
         PiyRqsLZRTxX4G05LDGxuVIaAcBe8r33Wco+3nFaDHqnZ4GMDr1vJ/TaRbOFpOD0R8TU
         IDwYkQD1XB0sTu/On6LVmh/WzFY8HrbS7stTTJy7Y7/XkF07LewVG7smMhrKR3U5pCeM
         lUVw==
X-Gm-Message-State: AOAM530bxlqD4NeKDj2BU7C1wSesI6f0mgbM2VMbIammOSXARkm+rFQa
        11ED9CdlqK0JiKKejoypULOG/0KX/UVDjA==
X-Google-Smtp-Source: ABdhPJywyZ2lKJQZxBXaC6/yTViJujCE6fOwfuNl86qTjfW6P74wR8B5RY1+pFg7+7UK4BMAckZvdA==
X-Received: by 2002:a65:550e:: with SMTP id f14mr344756pgr.160.1623253425306;
        Wed, 09 Jun 2021 08:43:45 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n20sm52298pfv.86.2021.06.09.08.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 08:43:44 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix blocking inline submission
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     lonjil@gmail.com
References: <d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com>
 <e3edab99-624d-6f24-a6ba-63589d00eeee@kernel.dk>
 <e6283f40-52ab-ddcc-131c-309e34321613@gmail.com>
 <cb972cf9-c35b-51f3-7216-13437285cda2@kernel.dk>
 <a61a3394-0e18-ec9a-5674-dd4439c6b041@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <05dff9bd-a928-e49b-f1e1-945a1f513c37@kernel.dk>
Date:   Wed, 9 Jun 2021 09:43:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a61a3394-0e18-ec9a-5674-dd4439c6b041@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 9:41 AM, Pavel Begunkov wrote:
> On 6/9/21 4:36 PM, Jens Axboe wrote:
>> On 6/9/21 9:34 AM, Pavel Begunkov wrote:
>>> On 6/9/21 4:07 PM, Jens Axboe wrote:
>>>> On 6/9/21 5:07 AM, Pavel Begunkov wrote:
>>>>> There is a complaint against sys_io_uring_enter() blocking if it submits
>>>>> stdin reads. The problem is in __io_file_supports_async(), which
>>>>> sees that it's a cdev and allows it to be processed inline.
>>>>>
>>>>> Punt char devices using generic rules of io_file_supports_async(),
>>>>> including checking for presence of *_iter() versions of rw callbacks.
>>>>> Apparently, it will affect most of cdevs with some exceptions like
>>>>> null and zero devices.
>>>>
>>>> I don't like this, we really should fix the file types, they are
>>>> broken if they don't honor IOCB_NOWAIT and have ->read_iter() (or
>>>> the write equiv).
>>>>
>>>> For cases where there is no iter variant of the read/write handlers,
>>>> then yes we should not return true from __io_file_supports_async().
>>>
>>> I'm confused. The patch doesn't punt them unconditionally, but make
>>> it go through the generic path of __io_file_supports_async()
>>> including checks for read_iter/write_iter. So if a chrdev has
>>> *_iter() it should continue to work as before.
>>
>> Ah ok, yes then that is indeed fine.
>>
>>> It fixes the symptom that means the change punts it async, and so
>>> I assume tty doesn't have _iter()s for some reason. Will take a
>>> look at the tty driver soon to stop blind guessing.
>>
>> I think they do, but they don't honor IOCB_NOWAIT for example. I'd
>> be curious if the patch actually fixes the reported case, even though
>> it is most likely the right thing to do. If not, then the fops handler
>> need fixing for that driver.
> 
> Yep, weird, but fixes it for me. A simple repro was attached
> to the issue.
> 
> https://github.com/axboe/liburing/issues/354

Ah ok, all good then for now. I have applied the patch, and added
the reported-by as well.

-- 
Jens Axboe

