Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79D1339EF5
	for <lists+io-uring@lfdr.de>; Sat, 13 Mar 2021 16:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhCMPfO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Mar 2021 10:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhCMPek (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Mar 2021 10:34:40 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE35C061574
        for <io-uring@vger.kernel.org>; Sat, 13 Mar 2021 07:34:40 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id t18so6612034pjs.3
        for <io-uring@vger.kernel.org>; Sat, 13 Mar 2021 07:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CZdg9gC/H2uJe1CP1rVK9iDT6//1potRQ1Miqt1x7yU=;
        b=fNo4OEmz7FzYNsym64ON2OAfaptc7ieYoZdxuC3kW1NJNTSYLzwJ8erdd3xCVqozd9
         9vQ016uOzTCYzKhi42pfaU0dnrrb8eCOVNxayeg4DdDyr7m5q9DpiKBJbrdsz30+egnK
         7Y72WsKpp2VrqjNiosMA3n9nEuQMq0OgZAcbSeuOUFCdkApRKuiXqwYJK5mo4CV8pLFa
         BgoMbvziqIKPOEdwWCXJgu4eBRUzr4bVvW4NV/nKRboCD1EEv6ZfJJ+F6IdvKjvANHFZ
         cetkgFCOlEn1KAbC0bG1YKseqvq1jqwbSTN3FAjW1hLSi+HE0iUI9OEySV957OTaGATj
         FSYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CZdg9gC/H2uJe1CP1rVK9iDT6//1potRQ1Miqt1x7yU=;
        b=FofiR+TygtimSWEGhocGTzTmNRcE2Pc9xtuWTHju0rza8KvedI8HoLgq+8lUFJ/0tj
         DKnQ1QDevgaKfY1IIlVN6CWnYFpYcw6f3HuJwiQjQniY23BsF7/rFamrUkPkHOx3b2yy
         JVhkjvP3L7YVCvGuC9D4Bz+A4mJvMYK1qbrc87Bu6wnTAMT695biqJ5F/L5x504O8vwF
         4oMqPchJr9DQ+2h+zltBsZ595swRHG0d+scZEbeQpC79piJJuZdDM0UiE2VSdqC7MG87
         YWqOmG1xrbajG1B0wCbcbjzjLbyVSN5fRM3MdJgblgRYv/cwR+ZWUq424z3WaYzLobup
         lszA==
X-Gm-Message-State: AOAM533JSi8kNp+TDj1+CvF/Cd+CsrG+AXEzu940lU0I4Cp29ahUn47T
        ZpwvjKq2uUh6kpL2ZXU+AN1H3Q==
X-Google-Smtp-Source: ABdhPJzmZS6xujAUZVQAwDdpzFc35VQqXfdLYCJ13Urv1a2l5V8Skthy8GA+pOa98lyiZAyfBdWc5A==
X-Received: by 2002:a17:902:ecc3:b029:e5:d7cc:2a20 with SMTP id a3-20020a170902ecc3b02900e5d7cc2a20mr3697947plh.11.1615649680019;
        Sat, 13 Mar 2021 07:34:40 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w22sm8449142pfi.133.2021.03.13.07.34.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Mar 2021 07:34:39 -0800 (PST)
Subject: Re: [PATCH 5.12] io_uring: Convert personality_idr to XArray
To:     yangerkun <yangerkun@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>, yi.zhang@huawei.com
References: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
 <803bad80-093a-5fbf-7677-754c9afad530@gmail.com>
 <8b553635-b3d9-cb36-34f0-83777bec94ab@huawei.com>
 <81464ae1-cac4-df4c-cd0e-1d518461d4c3@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7a905382-8598-f351-8a5b-423d7246200a@kernel.dk>
Date:   Sat, 13 Mar 2021 08:34:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <81464ae1-cac4-df4c-cd0e-1d518461d4c3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/13/21 1:02 AM, yangerkun wrote:
> 
> 
> 在 2021/3/9 19:23, yangerkun 写道:
>>
>>
>> 在 2021/3/8 22:22, Pavel Begunkov 写道:
>>> On 08/03/2021 14:16, Pavel Begunkov wrote:
>>>> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>>>
>>>> You can't call idr_remove() from within a idr_for_each() callback,
>>>> but you can call xa_erase() from an xa_for_each() loop, so switch the
>>>> entire personality_idr from the IDR to the XArray.  This manifests as a
>>>> use-after-free as idr_for_each() attempts to walk the rest of the node
>>>> after removing the last entry from it.
>>>
>>> yangerkun, can you test it and similarly take care of buffer idr?
>>
>> Will try it latter :)
> 
> Sorry for the latter reply. The patch pass the testcase.
> 
> Besides, should we apply this patch first to deal with the same UAF for
> io_buffer_idr before convert to XArray?
> 
> https://lore.kernel.org/io-uring/20210308065903.2228332-2-yangerkun@huawei.com/T/#u

Agree, and then defer an xarray conversion to 5.13. I'll take a look at
your patch and get it applied.

-- 
Jens Axboe

