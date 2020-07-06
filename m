Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480102159D7
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 16:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgGFOrP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 10:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729250AbgGFOrP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 10:47:15 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7B0C061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 07:47:14 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f2so13289750wrp.7
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 07:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QdW9fBIAmBoVEt85Q0LyD6T7AQys6fCVBX13A8B1GOo=;
        b=pr8rGLPZE31mGyaBT/ZxYWB6RnRUk6eSRy/JsPoXYFNEl4ZmPhTiTaYtDn5s+eSCtY
         jDes9F6FecDFV2zuE1ykSyHxLNYBOAAf32naw5UiLI9HvERCUHCWlbPIrQF6HhsIMgLC
         eghNHzFat7m/mmfl7ZqP+TNmF1SIhuE1sJFdYpGJhBkYK/HnZXaIzV6MYTP1k3MbVpax
         N3e9bdhUHnIZduA+/wRcLAh7Hi82643Gki5ABpb2AZcYYIO+0d9yzpb01Vp9pYG+2I7L
         /cTMt21Xm+OfKptoqVe2E8wlTp/8+3BfHPsMYKB+/oHKqOsB5sXNRp4mJN4GOMsMTgLS
         jmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QdW9fBIAmBoVEt85Q0LyD6T7AQys6fCVBX13A8B1GOo=;
        b=JBiMfZtdWm9plWNzQrM6a8seVzKPyAJLdljoayjCNgchXvLIGUYsF0lRtAqNMWojjx
         137Nto6MvZxZrk7OKXmgm3HweH3TJWvzivZJ8+QqhTpfqf2CHPjVrJexmlL80Eig5WYs
         CkEomZjXDij6hdzQ0LijCO0Xrm4uJA9CBkt2AnhA/pXMylhTeNIydjPPXevGxa+usML7
         qYrQodEb2ezJvo3H6P9Qo3K322j1TyOYwTK0VjXCnfh99p8YuEEUQfv3tdCF4ksfc/ZK
         zYZw50QSa4UWLJAoALKN9UGS035x26GV0ttLvS6tM2qRvEY/0rIa3l+RPFEXHuI38tyn
         DDww==
X-Gm-Message-State: AOAM530U53sW0sOxf22MSw8hzCaY3VUt/tqQp79JjmNJjEfZRtz75aZF
        TU+uLwQVZSYyclyq3kEKp7paCKMI
X-Google-Smtp-Source: ABdhPJybZWJmpMgUjoZ+FmCTDYpHpa8ILkPyLfYpkIwVMGUxUXm5ryv1GjGDhpHk708J6m0mD3CJMw==
X-Received: by 2002:a5d:56d0:: with SMTP id m16mr47329611wrw.194.1594046833407;
        Mon, 06 Jul 2020 07:47:13 -0700 (PDT)
Received: from [192.168.43.52] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id t4sm24956407wmf.4.2020.07.06.07.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 07:47:12 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: briefly loose locks while reaping events
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1594044830.git.asml.silence@gmail.com>
 <da2c8de6c06d9ec301b08d023a962fdb85781796.1594044830.git.asml.silence@gmail.com>
 <e8cfe972-0b28-8c5d-122d-0a724b3424fa@kernel.dk>
 <6a21bbfd-d1b2-09f0-af08-b964b810a449@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <323d7cb4-c88f-9d58-f337-1da61ea54280@gmail.com>
Date:   Mon, 6 Jul 2020 17:45:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6a21bbfd-d1b2-09f0-af08-b964b810a449@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 06/07/2020 17:42, Pavel Begunkov wrote:
> On 06/07/2020 17:31, Jens Axboe wrote:
>> On 7/6/20 8:14 AM, Pavel Begunkov wrote:
>>> It's not nice to hold @uring_lock for too long io_iopoll_reap_events().
>>> For instance, the lock is needed to publish requests to @poll_list, and
>>> that locks out tasks doing that for no good reason. Loose it
>>> occasionally.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>  fs/io_uring.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 020944a193d0..568e25bcadd6 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -2059,11 +2059,14 @@ static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
>>>  
>>>  		io_iopoll_getevents(ctx, &nr_events, 1);
>>>  
>>> +		/* task_work takes the lock to publish a req to @poll_list */
>>> +		mutex_unlock(&ctx->uring_lock);
>>>  		/*
>>>  		 * Ensure we allow local-to-the-cpu processing to take place,
>>>  		 * in this case we need to ensure that we reap all events.
>>>  		 */
>>>  		cond_resched();
>>> +		mutex_lock(&ctx->uring_lock);
>>>  	}
>>>  	mutex_unlock(&ctx->uring_lock);
>>>  }
>>
>> This would be much better written as:
>>
>> if (need_resched()) {
>> 	mutex_unlock(&ctx->uring_lock);
>> 	cond_resched();
>> 	mutex_lock(&ctx->uring_lock);
>> }
>>
>> to avoid shuffling the lock when not needed to. Every cycle counts for
>> polled IO.
> 
> It happens only when io_uring is being killed, can't imagine any sane app
> trying to catch CQEs after doing that. I'll resend

Also, io_iopoll_getevents() already does need_resched(). Hmm, do you wan't
me to resend?

-- 
Pavel Begunkov
