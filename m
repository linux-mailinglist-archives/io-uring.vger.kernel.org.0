Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC3516F118
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 22:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgBYVZg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 16:25:36 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39968 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgBYVZg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 16:25:36 -0500
Received: by mail-wr1-f68.google.com with SMTP id t3so410150wru.7
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 13:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4e3BsT+STGgSvWn+HOY2Og2BiNvDzra9XSPwiLyLfP0=;
        b=LanP9BpfPb8+i1zlYO1fcmE4+e/VtDLycwOoIRKuMCgs63jsPbgLKj8rvHdrpgQSav
         fprBAcXuEAOzLG4nOLdLE1DctBp47pDTuwIZVkzgjXsb7zyUMT9mBn6ibMSCntVMLS/b
         Ic/UezD4rrnpVIVSHlN6q8VLoSUs0EHfTcN9y56IhRi80eZTmbyixMKv16aZS40EzpOL
         utPTcLOIKgCXJsGynpFv4AuiBMIhz8cRsa6X3FdA7+8Mkayi/K+x+gTzZRFpddr5S56s
         FzU7a/EAnWFkD+bn4cWG985Uy3aIIV5He7NZffmtgcxJEABQU7Lc0uOTGtcns2G9xBIK
         b9yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4e3BsT+STGgSvWn+HOY2Og2BiNvDzra9XSPwiLyLfP0=;
        b=A/BsR5qZKM2rEMqxAh+tg5nJSYZ5wQ5rwnpiBa5Nt5KbPkQl7w6AfkfHnnEhAkQgUE
         +vyzF1ciHWSIKysCCz6mVY9MSQdwK4vwqLVTOGKYHUQKDlPyl/pgqdMlohS7BWw4f8uM
         nK/ACbYLtoD4evcftrk2MCXv+dSekNHLO0vosawpWTibxiqABz502gKLfl3YyJ9f4U81
         aOs05lQWoDG08K7UUAWKHkLOAoaNqsmhSRAXePECzs0OQ1E2cos7LNsbFzZAyPBDOQUw
         /j5Do4KPd8old5PRwkysSCa2AQ3vRm++IHLoOLlH/mK+ho153DDRdph2iY80FLEMQjV6
         lxog==
X-Gm-Message-State: APjAAAXqnAel3p+V/D+LYjFt5gXx4xZwa4+gKmDUzEDYZ+tetMBeMOb1
        oEQZuJaI0rYEqhrBTF8VdEYcRpNk/z7HFg==
X-Google-Smtp-Source: APXvYqwGL8nPwVTR1XTtmI8bOTakGaHWugVi/LlalwHmNYsA5dX57bw9FlVhH+XwKSVC9C5rM658Cg==
X-Received: by 2002:adf:e542:: with SMTP id z2mr1157861wrm.150.1582665934503;
        Tue, 25 Feb 2020 13:25:34 -0800 (PST)
Received: from ?IPv6:2620:10d:c0c1:1130::10fb? ([2620:10d:c092:180::1:4380])
        by smtp.gmail.com with ESMTPSA id o2sm5793377wmh.46.2020.02.25.13.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 13:25:33 -0800 (PST)
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
 <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
Date:   Tue, 25 Feb 2020 14:25:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/25/20 2:22 PM, Pavel Begunkov wrote:
> On 25/02/2020 23:27, Jens Axboe wrote:
>> If work completes inline, then we should pick up a dependent link item
>> in __io_queue_sqe() as well. If we don't do so, we're forced to go async
>> with that item, which is suboptimal.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index ffd9bfa84d86..160cf1b0f478 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4531,8 +4531,15 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
>>  		} while (1);
>>  	}
>>  
>> -	/* drop submission reference */
>> -	io_put_req(req);
>> +	/*
>> +	 * Drop submission reference. In case the handler already dropped the
>> +	 * completion reference, then it didn't pick up any potential link
>> +	 * work. If 'nxt' isn't set, try and do that here.
>> +	 */
>> +	if (nxt)
> 
> It can't even get here, because of the submission ref, isn't it? would the
> following do?
> 
> -	io_put_req(req);
> +	io_put_req_find_next(req, &nxt);

I don't think it can, let me make that change. And test.

> BTW, as I mentioned before, it appears to me, we don't even need completion ref
> as it always pinned by the submission ref. I'll resurrect the patches doing
> that, but after your poll work will land.

We absolutely do need two references, unfortunately. Otherwise we could complete
the io_kiocb deep down the stack through the callback.

-- 
Jens Axboe

