Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE93177B75
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 17:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgCCQDQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 11:03:16 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:35899 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCCQDQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 11:03:16 -0500
Received: by mail-il1-f193.google.com with SMTP id c3so612885ili.3
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 08:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WJ8CT33vCQgmzyyKSord2fPnPar8kkaEbMHV5McznGQ=;
        b=hiGouDg2FaInS+pLRzCFc0dFLEY3+qYi/nKghmXhNLPnCwCQi4EVttrrZlWfJbbU2F
         wairFJDAsRO1GLD2GOqKjysbBffUBkPJBpF6WXD/dMcUrylikBIAyLhShy2IIz+8LpXk
         T89ec3wN5qJWVfhT4+rX03RevMJ2die3Um06r6oa+epzjEXE+a3PdR28tuSC7/VnMP2Z
         72AZ2KCefh3jQNHT/TiU4mEzBlRu+YMSzescXfOQY0u8EvXNf91S6kKmnClvNs0WPpI8
         /l2jT9pOMKTqgcKWup6ZRFMwLhx6q7GxC+qRcOWNGcB/HugafPymk3Ry6MIOjcSNVsJE
         3/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WJ8CT33vCQgmzyyKSord2fPnPar8kkaEbMHV5McznGQ=;
        b=Tf2QWsVyu9BMoLWtqJN29sxPLQBgzltoOeTaUU4KtacyAAcVLL87ZlmPCeZEaZqdnh
         8HCAbD8BE56ZCFiIkA0tWxr1QNoQB0Do0q9q32dheKlfHPVT/dWE2RqBYPZuEDp6DKPC
         buftNhjDH7YoftFactCvFdHVY9YpncTKJ+bhLU/INmrYkflYZTLH5Ms7d7s1Lz8+DaDR
         Y57dFTWENphWjkiYzZKaSRa42NMKLHcVYAwnttOnr774B/m7witLHt7kln6R1wiPQ8v3
         PaSbRzDZKm1lbkrWm071MLw7lbKXPEPz2GhZne6Z8XARcHfoZv267aFHnKyNsiP9Japj
         vKtA==
X-Gm-Message-State: ANhLgQ3O4xxy8MloBAdR8GSV59QwFYiGqqbrK8iMf3E6KtXcnEfUba06
        DesZt1HNJSI9xFxWcApPBUunww==
X-Google-Smtp-Source: ADFU+vsI/dTdh2QHXsAzucz/h3HCFffui/bep2tqN1oMvr4GMjM8imoAagVCMjvooJK/S8JJtpaUkg==
X-Received: by 2002:a92:c041:: with SMTP id o1mr5740753ilf.139.1583251395477;
        Tue, 03 Mar 2020 08:03:15 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s2sm5434633iod.12.2020.03.03.08.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 08:03:14 -0800 (PST)
Subject: Re: [PATCH v2 4/4] io_uring: get next req on subm ref drop
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583181841.git.asml.silence@gmail.com>
 <444aef98f849d947d7f10e88f30244fa0bc82360.1583181841.git.asml.silence@gmail.com>
 <3ab75953-ee39-2c4e-99e2-f8c18ceb6a8d@kernel.dk>
 <52b282f5-50f3-2ee6-a055-6ef0c2c39e93@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <904bfed4-19cc-7c05-8410-05016f9ab578@kernel.dk>
Date:   Tue, 3 Mar 2020 09:03:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <52b282f5-50f3-2ee6-a055-6ef0c2c39e93@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/20 11:54 PM, Pavel Begunkov wrote:
> On 03/03/2020 07:26, Jens Axboe wrote:
>> On 3/2/20 1:45 PM, Pavel Begunkov wrote:
>>> Get next request when dropping the submission reference. However, if
>>> there is an asynchronous counterpart (i.e. read/write, timeout, etc),
>>> that would be dangerous to do, so ignore them using new
>>> REQ_F_DONT_STEAL_NEXT flag.
>>
>> Hmm, not so sure I like this one. It's not quite clear to me where we
>> need REQ_F_DONT_STEAL_NEXT. If we have an async component, then we set
>> REQ_F_DONT_STEAL_NEXT. So this is generally the case where our
>> io_put_req() for submit is not the last drop. And for the other case,
>> the put is generally in the caller anyway. So I don't really see what
>> this extra flag buys us?
> 
> Because io_put_work() holds a reference, no async handler can achive req->refs
> == 0, so it won't return next upon dropping the submission ref (i.e. by
> put_find_nxt()). And I want to have next before io_put_work(), to, instead of as
> currently:
> 
> run_work(work);
> assign_cur_work(NULL); // spinlock + unlock worker->lock
> new_work = put_work(work);
> assign_cur_work(new_work); // the second time
> 
> do:
> 
> new_work = run_work(work);
> assign_cur_work(new_work); // need new_work here
> put_work(work);
> 
> 
> The other way:
> 
> io_wq_submit_work() // for all async handlers
> {
> 	...
> 	// Drop submission reference.
> 	// One extra ref will be put in io_put_work() right
> 	// after return, and it'll be done in the same thread
> 	if (atomic_dec_and_get(req) == 1)
> 		steal_next(req);
> }
> 
> Maybe cleaner, but looks fragile as well. Would you prefer it?

I think I prefer that, since it doesn't need random setting of a
no-steal flag throughout. And it should be pretty solid, since we know
that we hold one and that can only be our reference. Just needs a nice
comment explaining that fact as well.

>>> @@ -3943,7 +3947,10 @@ static int io_poll_add(struct io_kiocb *req)
>>>  	if (mask) {
>>>  		io_cqring_ev_posted(ctx);
>>>  		io_put_req(req);
>>> +	} else {
>>> +		req->flags |= REQ_F_DONT_STEAL_NEXT;
>>>  	}
>>> +
>>>  	return ipt.error;
>>>  }
>>
>> Is this racy? I guess it doesn't matter since we're still holding the
>> completion reference.
> 
> It's done by the same thread, that uses it. There could be a race if
> the async counterpart is going to change req->flags, but we tolerate
> false negative (i.e.  put_req() will handle it).

It's relying on the fact that it's the task itself that'll run the task
work, which can't be done by this time. Just caught my eye as something
to look out for.

-- 
Jens Axboe

