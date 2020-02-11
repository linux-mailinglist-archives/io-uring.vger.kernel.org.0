Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B54E9158D2B
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 12:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgBKLFH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 06:05:07 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36700 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbgBKLFG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 06:05:06 -0500
Received: by mail-lj1-f193.google.com with SMTP id r19so11090764ljg.3;
        Tue, 11 Feb 2020 03:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1D2nt+GacM9CEt1jV/UYuxD3rZiAt9wG1MftPzXIiHo=;
        b=Uh4pYGFerV/M/TVkNahm3cZf2CENx0DaXz9sX1H6t4dfvaUp9WBCut2qkMGPw5Ip8n
         8URwmZHlOBmABk51D42K0mskOPkiJLBxuhxbViwgKU5PiRhPLQi2sK3Krz8uHGnjK1Sc
         /0g7Vj+2tv0yymy83NryPYlCGtUg/NIib5TmAskU4LTP+pCVEB1tT3KHhUQ3T5D5+1oC
         jgyIUmIYnCN0n+wyD3atryG1Wt6qDwbfezfFKEg3XLQJh4KHDnFccVZjip/yZmtAm3YK
         aBDz1Ya0CyBe286o9yV8sd4Z67kJr49XFMnKRWZ78bw1BBT6CQuD9jieIG9A3THJxDVK
         lAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1D2nt+GacM9CEt1jV/UYuxD3rZiAt9wG1MftPzXIiHo=;
        b=SclQC6wq3n2SDe+E6rAIdj8NTPD5vcXk2KRlP6PuK2AtukYPTFGZ7cOv2/gzmBycvQ
         dpSuZONbzPkx+VjpOnyuAzmZoLLZXBZnkfY3fg0+cHOgGGe56Arn9fzbx55hc34L+3hG
         o83ggWV//dOQRkw1Vh5OCUgymxw2Oz2E3QNHEIc5yQ/lCv5CtdLurCm9MMaDVrvIq4BS
         iyKGJZbrsi7JR8ULP3ec+n/aKt7nmOgW3NAEinwnp50iSY9rTr2yx+Hn17MZEMH6RqIi
         fHF7QngxOYcQekj1yia3FAGaBCHRg9y1FSoYEjUNI8phzokfrTY+hkghnbRgyz4KlnRE
         bJpg==
X-Gm-Message-State: APjAAAUGs/NkTiXJQ+wapWXTe1myoNUxnrQeIAgRhsle8U5C+vl65+EO
        h+3sVwWRrkx5MfN4PYYFXvCrdCXcO/E=
X-Google-Smtp-Source: APXvYqwVhf0u8O4n5wWgM3M7b8yJSva3e+gawxM/GkDxyXJ58dkm/dvgLjAqvwO6vDKpmEEdNZ0dNw==
X-Received: by 2002:a2e:9a93:: with SMTP id p19mr3956144lji.177.1581419104119;
        Tue, 11 Feb 2020 03:05:04 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id l22sm1907701lje.40.2020.02.11.03.05.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 03:05:03 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix iovec leaks
To:     David Laight <David.Laight@ACULAB.COM>,
        Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <03aa734fcea29805635689cc2f1aa648f23b5cd3.1581102250.git.asml.silence@gmail.com>
 <1255e56851a54c8c805695f1160bec9f@AcuMS.aculab.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <045f6c04-a6d8-146c-75f3-2c0d65e482d6@gmail.com>
Date:   Tue, 11 Feb 2020 14:05:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <1255e56851a54c8c805695f1160bec9f@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/2020 1:07 PM, David Laight wrote:
> From: Pavel Begunkov
>> Sent: 07 February 2020 19:05
>> Allocated iovec is freed only in io_{read,write,send,recv)(), and just
>> leaves it if an error occured. There are plenty of such cases:
>> - cancellation of non-head requests
>> - fail grabbing files in __io_queue_sqe()
>> - set REQ_F_NOWAIT and returning in __io_queue_sqe()
>> - etc.
>>
>> Add REQ_F_NEED_CLEANUP, which will force such requests with custom
>> allocated resourses go through cleanup handlers on put.
> 
> This looks horribly fragile.

Well, not as horrible as it may appear -- set the flag, whenever you
want the corresponding destructor to be called, and clear it when is not
needed anymore.

I'd love to have something better, maybe even something more intrusive
for-next, but that shouldn't hurt the hot path. Any ideas?

> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

-- 
Pavel Begunkov
