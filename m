Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D052ABF03
	for <lists+io-uring@lfdr.de>; Mon,  9 Nov 2020 15:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731790AbgKIOnH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Nov 2020 09:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731738AbgKIOnG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Nov 2020 09:43:06 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688D8C0613CF
        for <io-uring@vger.kernel.org>; Mon,  9 Nov 2020 06:43:06 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id s24so9959828ioj.13
        for <io-uring@vger.kernel.org>; Mon, 09 Nov 2020 06:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=N+CoGjkDI3xYhjiu3pTmUbVLsubUsHmaOXvpNUwNon4=;
        b=t2kq27v988arjtRpHTzPuKn2j/XAXuyR65/YcWFv2+6h62kNanhnmT3LzhPruSZ/RW
         x5AuW7eIEyfamgMr8Qgt3wSKMYLCH7LUUP9XHYwNEhu+NNDXgzasLElHZF2A0iTuIgo6
         fXU7X3/0RDRdPvhDVnwQ5TcbdXmkwhqE60O7kWMFudaa82itCGWnMKQyW0J1ky3q56ph
         aEhOSbI96tnqsc8QwHDc095jyUyIyT19ngjsQu889C2H/+N32OuaPbmJQGd1+iixV45t
         h5XhqmI3/nzJC3JcTv8OdpAEoHSsYq3DY9DJ8rW4oQ/jxk0XX+bClzK+hqKFZMplYwWO
         v3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N+CoGjkDI3xYhjiu3pTmUbVLsubUsHmaOXvpNUwNon4=;
        b=t5dcf4wh7VstYvqlstoXCwrHAvytxJEGBILNQs/4PJFjstw+tv7g/mKSCid4C0aN1z
         ch8eAnGJ9A4ed9YjWmHYPtbxykMoR6u0DmWkviT1GuzaVIkMDRgtPLLZFfJmhXFgZAA5
         UQZtIPmSlgQJQtOMdiBuduhSCwZz6tSVK6WxtFQ4QSwK8ZsCXYrSfWbOEq92ePnxBJv/
         j3GlKWlxNKQA47oeuRAdeL7IbhpaTSBSnyb+MQNU21BB7k6vLiuijSkKJjVDiuftMkIi
         AYfoBpt9s3u+veG3SZ6qsCPpdTXLMIyqJU1IlhcP3owJSWdxREJ4Y2U1nZDj88+zHDFF
         0pVw==
X-Gm-Message-State: AOAM530ff9lbp3cbfLAisi8Zj0KbDNJgTPWd0feYqoPDA6beZqTlifHm
        f+naGIzLl6Oawe3irI9jO3NEuAVMFxOQ3Q==
X-Google-Smtp-Source: ABdhPJxHZ+7DUAGPI8nRno2eSmDIricV0kMFADeRSzLxBkEtIt7nidFr+5DuhzC93GIKEfo4AkmwBw==
X-Received: by 2002:a6b:6001:: with SMTP id r1mr9869249iog.144.1604932985608;
        Mon, 09 Nov 2020 06:43:05 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c80sm7603711ill.20.2020.11.09.06.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 06:43:05 -0800 (PST)
Subject: Re: [PATCH for-next 0/6] cleanup task/files cancel
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1604667122.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <944ff49c-6066-1184-5901-33dce476e0e6@kernel.dk>
Date:   Mon, 9 Nov 2020 07:43:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1604667122.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/6/20 6:00 AM, Pavel Begunkov wrote:
> That unifies cancellation/matching/etc., so we can kill all that going
> out of hand zoo of functions.
> 
> Jens, [3/6] changes the behaviour, but as last time it's less
> restrictive and doesn't kill what we don't need to kill. Though, it'd
> prefer you to check the assumption in light of the cancel changes you've
> done.
> 
> Based on for-5.11/io_uring + "io_uring: fix link lookup racing with link
> timeout", should apply ok after you merge everything.
> 
> Pavel Begunkov (6):
>   io_uring: simplify io_task_match()
>   io_uring: add a {task,files} pair matching helper
>   io_uring: cancel only requests of current task
>   io_uring: don't iterate io_uring_cancel_files()
>   io_uring: pass files into kill timeouts/poll
>   io_uring: always batch cancel in *cancel_files()
> 
>  fs/io-wq.c    |  10 --
>  fs/io-wq.h    |   1 -
>  fs/io_uring.c | 260 ++++++++++++++------------------------------------
>  3 files changed, 69 insertions(+), 202 deletions(-)

Applied, thanks.

-- 
Jens Axboe

