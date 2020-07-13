Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3AD21E1FA
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 23:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgGMVUG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 17:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgGMVUG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 17:20:06 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D527C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:20:05 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id n26so19104576ejx.0
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=75N0wnBA3NnLFzRDcTc+m/KdDiB3NS3Tbo8NyxIcMc0=;
        b=gwut00lHj+SppB8nJKSzD7mn5KQhM0sQgJktiymFZ0Ww9R0GlxIs5YvJeNo7nAhPid
         /X8VGz3gCixLbIA6URVhmhE2ncDPY+Md2kE+5ivylPuRlnlMF1raMvIU1JCkbmtIMmK/
         SQNhP6GR1sC0bEnWEJ40QulDqBqb874Q5ms7ZWunUZZWn5R2kJ66lBYQrRqQsyZxLqmf
         hL8s4XHx2dbo0JGbV9OdA+G2e1K34940bG2qKrblfUxcUKvAutLmiRZg457aVMRk1qaQ
         uCbTD3nBsM/vClARdZ/blf/PqZOo61KW0zTg8s+pR8J+M190xVEOfaRWqJvgGCeLBgO5
         PQeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=75N0wnBA3NnLFzRDcTc+m/KdDiB3NS3Tbo8NyxIcMc0=;
        b=PDIOchbRh/Up7j/tOmgH/kobVL419c/6rsdGxwENVmdQEPdKI3LOWGZNCZtjzaY17H
         KqX8S16V0GWa4Ajhvv5i5Nnym+aDSafhGkoAF9Y0yGpsXEaA5/qIjUJkjJq3e3RC7ybX
         BsNsYPacIQ/qdqRsOxAH3K9hJegZiqSr46VQmkHJk2J2iFfu3AJcT+kVVXC31+Y/9TNF
         buFugKOZAC+ogk3wEbPpS+LAm5D/I9BheQn6YqGcoUEJ7W/tPjK9w2L9DUh8j9ptZxO+
         wfCVLP2aJM+FV3nlXIzV0LCllUoC1v80Diev5U3ylRj8EpSaL/iu9pkEObludwogJuXH
         Ifmg==
X-Gm-Message-State: AOAM532wiiHSDpxVJI/zpfjOQCii4m/BJFHC3hTPk6c9rfGG3Q0JXvCJ
        D/NsehNwGHzCiGKhUWqh+rmsvhii
X-Google-Smtp-Source: ABdhPJxcDusNfNER1+fNRlV83O4DqNO67ud4vElAIdf16BQlQu35vgdwNLLOI1TWaXzZYHE76GfHOg==
X-Received: by 2002:a17:906:328d:: with SMTP id 13mr1605272ejw.71.1594675203929;
        Mon, 13 Jul 2020 14:20:03 -0700 (PDT)
Received: from [192.168.43.133] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id m6sm2633660eja.87.2020.07.13.14.20.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 14:20:03 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: follow **iovec idiom in io_import_iovec
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1594669730.git.asml.silence@gmail.com>
 <49c2ae6de356110544826092b5d08cb1927940ce.1594669730.git.asml.silence@gmail.com>
 <e3ac43ac-be8c-2812-1008-6a66542a2592@kernel.dk>
 <d14f8f12-7627-7afa-97f8-37f03a58715b@gmail.com>
 <b96292d5-5d07-fddd-69a8-25dbcc5af7da@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <ea4a93f5-9531-d328-8361-d59d2518a76b@gmail.com>
Date:   Tue, 14 Jul 2020 00:18:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b96292d5-5d07-fddd-69a8-25dbcc5af7da@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/07/2020 00:16, Jens Axboe wrote:
> On 7/13/20 3:12 PM, Pavel Begunkov wrote:
>> On 14/07/2020 00:09, Jens Axboe wrote:
>>> On 7/13/20 1:59 PM, Pavel Begunkov wrote:
>>>> @@ -3040,8 +3040,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>>>>  		}
>>>>  	}
>>>>  out_free:
>>>> -	if (!(req->flags & REQ_F_NEED_CLEANUP))
>>>> -		kfree(iovec);
>>>> +	kfree(iovec);
>>>>  	return ret;
>>>>  }
>>>
>>> Faster to do:
>>>
>>> if (iovec)
>>> 	kfree(iovec)
>>>
>>> to avoid a stupid call. Kind of crazy, but I just verified with this one
>>> as well that it's worth about 1.3% CPU in my stress test.
>>
>> That looks crazy indeed
> 
> I suspect what needs to happen is that kfree should be something ala:
> 
> static inline void kfree(void *ptr)
> {
> 	if (ptr)
> 		__kfree(ptr);
> }
> 
> to avoid silly games like this. Needs to touch all three slab
> allocators, though definitely in the trivial category.

Just thought the same, but not sure it's too common to have kfree(NULL).

The drop is probably because of extra call + cold jumps with unlikely().

void kfree() {
	trace_kfree(_RET_IP_, objp);

	if (unlikely(ZERO_OR_NULL_PTR(objp)))
		return;
}

-- 
Pavel Begunkov
