Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AEE21A1C2
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 16:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgGIOFt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 10:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgGIOFt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 10:05:49 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456A7C08C5CE
        for <io-uring@vger.kernel.org>; Thu,  9 Jul 2020 07:05:49 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t4so2140977iln.1
        for <io-uring@vger.kernel.org>; Thu, 09 Jul 2020 07:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oMnI/eFxxJ+Rr9dk/y2RZbs/7bqRU/Yv7VYpCv09jjQ=;
        b=C5rui48LchhJZsNpOpZKkjblQ0CTY2MPXDSz4bmp81soQ7GL+mRU0qziWXkLkqg+Dy
         lClg6xJDkVIHrL8Byb8utF+/Zz69CsyFMkZixqLUf0DOuUj2n0BQCP4Bk5D2gBsKxhub
         CBPhvXRkP+8oivA89E8UF3wklQjxODE8+urJ2PPzWPWnLX2tv7Xxejg8j4fifP/zXzHx
         mBwYe35MwDctRpH4PI4J7EB6hiRDTkPI1JB7SjlZHlxXzRgPIM5VED8dHafaq/fYNO2O
         4Vqc4dTq6q+GOACFAaLZVj4+gp1Wxs//znqmRO+lqNQcRWZfa/bn2cIi8LnZn7I05H3A
         LesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oMnI/eFxxJ+Rr9dk/y2RZbs/7bqRU/Yv7VYpCv09jjQ=;
        b=N4dqcwNJePAQN5mCYk2Ah+IxWqRoXkYSslbKhtCRHFJY9k3W7ddURtu6YdSlg/Dkat
         cxJ849L3qtEpis2Oug2KMGW2lf5Pf3RJ50GMUR5u2zy0DDLIqdkr22yq8B5uQ8lwVCbZ
         WMcWAe3dslcQbWUP0v+wtDLCqU9aRoJmWazEi+HKyWXx9FO0Vcwcx7Cz8Ir9jIhWVWY4
         SvXU8cWeQOuqAHEgPbBLdzcYtFVA6vc9GCTLiOI62VNq0uXUCnZUodrsYMOUcdgbg+vX
         GQVIfZYCsnAoJXVA7V+O41Uy55v+sCwHVUgmul9hzFU0vz3o/LDPeMeW+Afd5XTyigCI
         /5HQ==
X-Gm-Message-State: AOAM53194Df7Zzkm5iNQdWLht3dcnzGJAI83TnFe0pn/hABzCm+W0e+P
        B9WA0PT9EUbgB0h7Ulahwvr43Q==
X-Google-Smtp-Source: ABdhPJya7WxrYyOKxMjO9jamdVLBDLUrjy8VegR37opYbGRoDIWCNtaSbFAkPSzRltHkfkNagHedyg==
X-Received: by 2002:a92:bb57:: with SMTP id w84mr47025123ili.104.1594303548684;
        Thu, 09 Jul 2020 07:05:48 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h11sm1910739ilh.69.2020.07.09.07.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 07:05:47 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org>
 <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
Date:   Thu, 9 Jul 2020 08:05:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200709140053.GA7528@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/9/20 8:00 AM, Christoph Hellwig wrote:
> On Thu, Jul 09, 2020 at 07:58:04AM -0600, Jens Axboe wrote:
>>> We don't actually need any new field at all.  By the time the write
>>> returned ki_pos contains the offset after the write, and the res
>>> argument to ->ki_complete contains the amount of bytes written, which
>>> allow us to trivially derive the starting position.
>>
>> Then let's just do that instead of jumping through hoops either
>> justifying growing io_rw/io_kiocb or turning kiocb into a global
>> completion thing.
> 
> Unfortunately that is a totally separate issue - the in-kernel offset
> can be trivially calculated.  But we still need to figure out a way to
> pass it on to userspace.  The current patchset does that by abusing
> the flags, which doesn't really work as the flags are way too small.
> So we somewhere need to have an address to do the put_user to.

Right, we're just trading the 'append_offset' for a 'copy_offset_here'
pointer, which are stored in the same spot...

-- 
Jens Axboe

