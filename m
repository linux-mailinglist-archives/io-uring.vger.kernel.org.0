Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6CA138488
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2020 03:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731949AbgALCQs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jan 2020 21:16:48 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52973 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731947AbgALCQs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jan 2020 21:16:48 -0500
Received: by mail-pj1-f67.google.com with SMTP id a6so2629036pjh.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jan 2020 18:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vGIDhMkgk6Yxk9hwcJUbeiuGdVTEJQSdVtxa8Ksgq0I=;
        b=VKTp20o6e1570ly+OroArEs2yK8TRc8zTn1AM6UonyvsiELOT9JRoatzH/zDEmSSMm
         cZnrNwagysbC84XUWOWPzvMrktG1nStCemX63kEVM3lp/r+rJBZCGlgHLKcu875h3DiQ
         R7jIoghHxClJEGkWH9X/+Q6ZdWgrqmlo5TzSLZAOzwyU1pOpWeWL8QnXbLCppCyr9Pky
         UK80Lo90j88hbqJs+KdVCEtw0qt1j0GVrybB6Wwf0CfzgrZwOLcgry2h1+6UtgOwZODv
         Kkz7eS0klJasPiUkf2w89ct2lqGatlEw8nLm4Y1lzhB/zTi0hXC47ttMVtI0yVLjwZEu
         xN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vGIDhMkgk6Yxk9hwcJUbeiuGdVTEJQSdVtxa8Ksgq0I=;
        b=OXhqbOMta/LdpfBTVk6qFHrdBWwzDJA5zXSM7YsC/6Zd26dF6MMw6s7AdbRn+q8Nw3
         PA1WqThu4Ax4ko6QWktz5u7ybK6VOLQEpjq/dnrpIWijEnJg2w4kI8Qmx3Q5X/OGnmJx
         2805woeriTaKcXB2eAvbq3Yh8QtoQ2LKxy2UF12e7HkKpdyidl+H1lNYbxNnT3eFhsXF
         DX/fIfBKNzwX7a3Dcwhl1Ekzfiur+mtodRYSL3o6X2MJXrkCJXI0ATkBXn1K9ym4xW/b
         cjP20XNmjuJ/4kU8kAr74NxofFCXY6BsK/UAtmlqvIiJpA7COcN4jdwrtFDFnO2ly67Q
         VcBw==
X-Gm-Message-State: APjAAAXhe2N11CWNbz6Ok0blhjYlO3N1gH70q469cAAjwmoJQJhWn8Mb
        Ikon3SGI9uiIUAqafaNoWBY9oQ==
X-Google-Smtp-Source: APXvYqyv1LeI+xjOOHaKKiHuxN7/X39asnC3k5SnqhpCRcLo0rDk59XFNfJqk0XKBHd6prsa49uoxQ==
X-Received: by 2002:a17:90a:ead3:: with SMTP id ev19mr15035309pjb.80.1578795407788;
        Sat, 11 Jan 2020 18:16:47 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x22sm8389504pgc.2.2020.01.11.18.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 18:16:47 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: add IORING_OP_MADVISE
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <20200110154739.2119-1-axboe@kernel.dk>
 <20200110154739.2119-4-axboe@kernel.dk> <20200111231014.bmpxdg2juw3mxiwr@box>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cea0337c-0ce7-b390-44ab-9f064894ca3d@kernel.dk>
Date:   Sat, 11 Jan 2020 19:16:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111231014.bmpxdg2juw3mxiwr@box>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/11/20 4:10 PM, Kirill A. Shutemov wrote:
> On Fri, Jan 10, 2020 at 08:47:39AM -0700, Jens Axboe wrote:
>> This adds support for doing madvise(2) through io_uring. We assume that
>> any operation can block, and hence punt everything async. This could be
>> improved, but hard to make bullet proof. The async punt ensures it's
>> safe.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> How capability checks work with io_uring?
> 
> MADV_HWPOISON requires CAP_SYS_ADMIN and I just want to make sure it will
> not open a way around.

There are two ways the request can get invoked from io_uring:

1) Inline from the system call, personality is the application (of course)
   in that case.

2) Async helper, personality (creds, mm, etc) are inherited from the ring.

So it should be totally safe, and madvise is no different than the other
system calls supported in that regard.

-- 
Jens Axboe

