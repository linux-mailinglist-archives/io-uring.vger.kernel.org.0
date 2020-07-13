Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B6321E1F5
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 23:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgGMVQa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 17:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgGMVQa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 17:16:30 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F8AC061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:16:30 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c16so15077227ioi.9
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dUsnd/2sRWevXEgRyu75RID8Gs44KZgsgpsX5fOZp5w=;
        b=YuW+TuJIwxAXFa9cvNRRCyX4M6vVfw1/gOArQj8s/GaqTEWKhpktV2Q3huMdkiTkfB
         PlZBihClIdbGNeSbou7zX38ZEPIyAIei02o558X9EMrkmLwipuNM8OIzjGkzapeHXvjF
         JOiWVkG+fzeOysLxvPmpw/5t8cqLnBcDS7rSnaIzs/mKTjTDjydNBw8z58RHYeiaWj8J
         QpB56dz9xKLMkcczG0zAsFFl8tXZOxUA9uzm+plKhSPkufMeyDatosp5NFqXYDsVKOUI
         4k093aVPfWoXQG2YNxpxZYT8EDhy23kBf9aHNC05UiDLUa3LMfCmcmV94zm0cPUedKap
         9r8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dUsnd/2sRWevXEgRyu75RID8Gs44KZgsgpsX5fOZp5w=;
        b=kX6NQ/4tn0PWjWKJntwm+c/vyYD8f6zZdulqQAInoEY8wAOTOEAMeH2RojzWt6ces7
         rPXBRK6QKeVZqCLr0GiRSIrofykurzPEVeBxW/FUMk6G4KZy1sBq3pLcmYY4wUH06mJv
         NRZaVfpT+XWYwb/aWyrz0ROAQzNCsv/tFrkobj2EikT7x4Fjb08BpCrTDkXS4pxnMwBu
         Ja55SMe4JIBNska0uwFgWLdXKSPIZhNHUxo5zMGPuIGfju13x3O5Yl3R/dWrPLeP/a3p
         SB8pJU/G6wBu7i1OUITuYPPQ6NhnppGRxhjm869tlbEAT7zG8mU64KzXnVyADgJzKczc
         2awA==
X-Gm-Message-State: AOAM531lXVRTSWVGPld1iheNssBJqVBmtO16MFglveHikagt7qhcRLed
        H2ATb+99Yu355+Dib89AsNGGYsQpvhUXOQ==
X-Google-Smtp-Source: ABdhPJxqIovOaqfneGussZ3OUYjyNGf6CPBNAdIjfF9li1FSNyb8um/IyAXHZwq6gcn7wiM3BtoKSQ==
X-Received: by 2002:a6b:661a:: with SMTP id a26mr1680328ioc.197.1594674989459;
        Mon, 13 Jul 2020 14:16:29 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v3sm9227793ili.12.2020.07.13.14.16.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 14:16:29 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: follow **iovec idiom in io_import_iovec
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594669730.git.asml.silence@gmail.com>
 <49c2ae6de356110544826092b5d08cb1927940ce.1594669730.git.asml.silence@gmail.com>
 <e3ac43ac-be8c-2812-1008-6a66542a2592@kernel.dk>
 <d14f8f12-7627-7afa-97f8-37f03a58715b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b96292d5-5d07-fddd-69a8-25dbcc5af7da@kernel.dk>
Date:   Mon, 13 Jul 2020 15:16:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d14f8f12-7627-7afa-97f8-37f03a58715b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/20 3:12 PM, Pavel Begunkov wrote:
> On 14/07/2020 00:09, Jens Axboe wrote:
>> On 7/13/20 1:59 PM, Pavel Begunkov wrote:
>>> @@ -3040,8 +3040,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>>>  		}
>>>  	}
>>>  out_free:
>>> -	if (!(req->flags & REQ_F_NEED_CLEANUP))
>>> -		kfree(iovec);
>>> +	kfree(iovec);
>>>  	return ret;
>>>  }
>>
>> Faster to do:
>>
>> if (iovec)
>> 	kfree(iovec)
>>
>> to avoid a stupid call. Kind of crazy, but I just verified with this one
>> as well that it's worth about 1.3% CPU in my stress test.
> 
> That looks crazy indeed

I suspect what needs to happen is that kfree should be something ala:

static inline void kfree(void *ptr)
{
	if (ptr)
		__kfree(ptr);
}

to avoid silly games like this. Needs to touch all three slab
allocators, though definitely in the trivial category.

-- 
Jens Axboe

