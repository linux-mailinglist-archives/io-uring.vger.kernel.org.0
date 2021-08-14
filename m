Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8913EC4C6
	for <lists+io-uring@lfdr.de>; Sat, 14 Aug 2021 21:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbhHNTiz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Aug 2021 15:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhHNTiz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Aug 2021 15:38:55 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D8EC061764
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 12:38:26 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id s184so17858813ios.2
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 12:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iGKbZEaVBt82jZks/ewucAFouuOxp1jSkRFcVlspBws=;
        b=Aw8hIC/QZMuJBhJZ4nNlbGC4ieCbmW7APucljKCKPry8B/5WVNo/NE24MhtmdPNC3H
         aM2U2QSfB+1h1L9LyeVx0cI/R0jbGyV2ntr7WU7mYaM1n6Bf566asuQbWww3iT33FE43
         t6t6k10KySqEK99OGXFVoP9+UFmwkZP1tmeUFbztOmgVuG9XJ4Qdc8XL7tiiKbmJ7C4L
         uDFYKPPvtaPH7u9oRusTsHz8J9GsIO6holGzpi50IRO7ih/BfckT9Z0h+bWzrQms9xW/
         91vHLYMP474hwlgNSfz/N1B/lJald+52Q1enfWtElbFLqz8QLZXo7zEEzPu86QmLC8Ze
         DsbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iGKbZEaVBt82jZks/ewucAFouuOxp1jSkRFcVlspBws=;
        b=QVyeb+dDXhhcu7+Dlp9nm02FkwE9qpRv0AR1z0tIjkzuz6scr0Xz2h3dl6G0wmujLn
         sJplJQ8QyweKGQNsCb24qFsDn+ylFp17EE6ItxUMTtKddrd2F+qlyPDfkNnzoT1odbo5
         9iGrnprdmA3D1+6vHyF/nCAtKv6FATfEzISZyzlLM7LiaFhh4hHNVBf7cXeSMc0rRXeg
         oxg1WQoINGLWdy62a3lNbLQ3YZdOZjJhwQtd4OBWMeIqZfsOzRTRUOGzZISmfLY1upaT
         6dsotsHTHRuMmuyvIfmtbXGTwZA21hvkKrqtLoA10KOQ5I/zMJXo36Y3JKMmmvcAF7xI
         CKRg==
X-Gm-Message-State: AOAM530u3xnib+lXd1tGwveMQzU2LyICwVSHS0Qezz8IY0oaIh60srBQ
        ilRKTBnX4O6zge/4qs1cisMgkSahO2sWM8cD
X-Google-Smtp-Source: ABdhPJz6avy9YvWU01rEYVtz9C/xKSYT+0zzvauMOTW92VUs4HehAzDSUxbFkqM0rNnq4+f/pU/nvw==
X-Received: by 2002:a6b:f007:: with SMTP id w7mr1134039ioc.112.1628969906192;
        Sat, 14 Aug 2021 12:38:26 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m5sm2973997ila.10.2021.08.14.12.38.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 12:38:25 -0700 (PDT)
Subject: Re: [PATCH 1/5] io_uring: optimise iowq refcounting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1628957788.git.asml.silence@gmail.com>
 <3243f06098128ce6587b3fbfdddeb1f63e21f418.1628957788.git.asml.silence@gmail.com>
 <cbd8801a-49b3-f74d-68a7-cb629497aecd@kernel.dk>
 <3cc5ed43-d3ba-a3a9-8bf2-13fb5a81bcf8@gmail.com>
 <a583a8e2-68d0-9baf-c7c2-8a3a06848f4c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fe8d2eea-a2a1-2c30-474a-edaae5cdcd09@kernel.dk>
Date:   Sat, 14 Aug 2021 13:38:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a583a8e2-68d0-9baf-c7c2-8a3a06848f4c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/21 1:36 PM, Pavel Begunkov wrote:
> On 8/14/21 8:31 PM, Pavel Begunkov wrote:
>> On 8/14/21 8:13 PM, Jens Axboe wrote:
>>> On 8/14/21 10:26 AM, Pavel Begunkov wrote:
>>>> If a requests is forwarded into io-wq, there is a good chance it hasn't
>>>> been refcounted yet and we can save one req_ref_get() by setting the
>>>> refcount number to the right value directly.
>>>
>>> Not sure this really matters, but can't hurt either. But...
>>
>> The refcount patches made this one atomic worse, and I just prefer
>> to not regress, even if slightly
>>
>>>> @@ -1115,14 +1115,19 @@ static inline void req_ref_get(struct io_kiocb *req)
>>>>  	atomic_inc(&req->refs);
>>>>  }
>>>>  
>>>> -static inline void io_req_refcount(struct io_kiocb *req)
>>>> +static inline void __io_req_refcount(struct io_kiocb *req, int nr)
>>>>  {
>>>>  	if (!(req->flags & REQ_F_REFCOUNT)) {
>>>>  		req->flags |= REQ_F_REFCOUNT;
>>>> -		atomic_set(&req->refs, 1);
>>>> +		atomic_set(&req->refs, nr);
>>>>  	}
>>>>  }
>>>>  
>>>> +static inline void io_req_refcount(struct io_kiocb *req)
>>>> +{
>>>> +	__io_req_refcount(req, 1);
>>>> +}
>>>> +
>>>
>>> I really think these should be io_req_set_refcount() or something like
>>> that, making it clear that we're actively setting/manipulating the ref
>>> count.
>>
>> Agree. A separate patch, maybe?
> 
> I mean it just would be a bit easier for me, instead of rebasing
> this series and not yet sent patches.

I think it should come before this series at least, or be folded into the
first patch. So probably no way around the rebase, sorry...
-- 
Jens Axboe

