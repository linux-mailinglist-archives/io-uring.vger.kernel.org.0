Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9823635E304
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 17:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhDMPii (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Apr 2021 11:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhDMPih (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Apr 2021 11:38:37 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95743C061574
        for <io-uring@vger.kernel.org>; Tue, 13 Apr 2021 08:38:17 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id k25so17418850oic.4
        for <io-uring@vger.kernel.org>; Tue, 13 Apr 2021 08:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7/5RGeZ1nTL6ccENWkv1pA2LHYMxN6cPxYi5wTou2Hg=;
        b=mDLmi244wmcVrIwZEPYK8nNUtow1dBA+8m/xrbvveiEy0Ptj3wnQJLSrMCygjXMGaK
         dSs4GcaeTEol0z2wO1TgNcVw14H4nxfrTTxVzjzR2frP/BXqcqWIKilBqd10ZZfeyYjL
         mbJbW4rTCVlWdBk2OpEc+ATK123sMeUi9f41CVMY0F06I+/4EUT083CtEFC2DSad9+/e
         exfw63CxQgwZnOCdh6GpThztkCJgZx8s18U8ZRVabhbtGBsejOdfANb1XZo2zK1x6nY5
         rTnGIj6ElDA6KaH8XQrbrI9+y75CJFgodalmKCMMmIcv+65R8RXVzs4i0TznjpiGJ+1I
         e3ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7/5RGeZ1nTL6ccENWkv1pA2LHYMxN6cPxYi5wTou2Hg=;
        b=QyeEFBVWTUyJGiDniDGoXz7i4j+2o/oHPf42UkqugABLBNW04FO3BKz57S0xESkRB1
         0esTccopsM7wGlRnrfdqKhf5fMGDByo9YzmQ704R5oHolQhHh8o/UiIFSofsutuRa6Vf
         WpC4io45H4InQXDqYlmxLfPIZHBfp/xhPaNYq1Os1iiZTZO8KGwMVXvLxjNBEvG9KBbW
         aaSPTqi6yVGgzRvKCrWNbjvONa4MBUzuc9u8m5QQBmOc6nQD8VQgY4Gac/THjyMoIbVW
         skBIvxUdvfEU9LDDQ+ZQ90OjZOFv6/2CFx6xG9JkFpmJMUk0XpMPtHAohbpwygiRjfNV
         GHfA==
X-Gm-Message-State: AOAM532jyXJSG1sOyvEXlVqTLcMwJNqqDdCWD4hdgkq9xE5VoKS+h3n9
        4BGg2SlU/u1VOvmttzXhKF2ewOgtD6ISyw==
X-Google-Smtp-Source: ABdhPJy4nVic7zbJQ9efgzmaEuXNunO6HtbW9gVB6MojbGPnu4qbvH8v2yO/17L2eFmZ/637b2kAzA==
X-Received: by 2002:aca:6545:: with SMTP id j5mr427113oiw.31.1618328296155;
        Tue, 13 Apr 2021 08:38:16 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id m14sm3590663otn.69.2021.04.13.08.38.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 08:38:15 -0700 (PDT)
Subject: Re: [PATCH 5.13 0/9] another 5.13 pack
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1618278933.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a82e7352-ed1c-a2b7-82af-41cd7990ff78@kernel.dk>
Date:   Tue, 13 Apr 2021 09:38:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1618278933.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/21 7:58 PM, Pavel Begunkov wrote:
> 1-2 are fixes
> 
> 7/9 is about nicer overflow handling while someones exits
> 
> 8-9 changes how we do iopoll with iopoll_list empty, saves from burning
> CPU for nothing.
> 
> Pavel Begunkov (9):
>   io_uring: fix leaking reg files on exit
>   io_uring: fix uninit old data for poll event upd
>   io_uring: split poll and poll update structures
>   io_uring: add timeout completion_lock annotation
>   io_uring: refactor hrtimer_try_to_cancel uses
>   io_uring: clean up io_poll_remove_waitqs()
>   io_uring: don't fail overflow on in_idle
>   io_uring: skip futile iopoll iterations
>   io_uring: inline io_iopoll_getevents()
> 
>  fs/io_uring.c | 236 ++++++++++++++++++++++----------------------------
>  1 file changed, 104 insertions(+), 132 deletions(-)

Applied, thanks.

-- 
Jens Axboe

