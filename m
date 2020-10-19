Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6EF293218
	for <lists+io-uring@lfdr.de>; Tue, 20 Oct 2020 01:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389117AbgJSXnU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Oct 2020 19:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389116AbgJSXnU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Oct 2020 19:43:20 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB0BC0613CE
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 16:43:20 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x7so1610376wrl.3
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 16:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hc4TXcFvExnmmzZkqgdi8TB0tDioUCYGDRXmCxL4/X8=;
        b=XEJMXn6sNGqodieoOymfLHJC2zQMpVTp4M2vJzEol/elD3aFhqzu5wwfyRsuZgnvNW
         AMR8uDwvn8NG99f+hulq1QIdIpXVQdWa/T03cBxrNR86n42kSKmwaSzNTzY+gOwoamjZ
         A8zWtNzqClQSb2FieVgKB3HmjBua440dmERoDmPdtcm6P4pbYOVFtFDk9499MkQTvyyV
         lIw4j3i9zMheQWeM7UTjbVi9zlYAXL4ulYxmRaLQ3aW++tU33rbpI5J4TCGi9Q7TAJCa
         6QfFhKuOtKPtnGQ0iXp8XMKffnxTAK8WEBW+GQdHXfKMTgTrgHd2oP+Z0QozC4Yz9wxl
         GVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hc4TXcFvExnmmzZkqgdi8TB0tDioUCYGDRXmCxL4/X8=;
        b=QxREJVm1ftkhfh07yULEAyHnqUAbV7PPkIT7v+UyzUHa2ItUzq2zB+TWTV73mE8zdh
         ANKCv8OQBXMom/yggkUxXqoaZBi+iCFyTehUWM8X1dtudwuaUIq29yXpfODMQdgnTujD
         hTnMJo51hcrYPiGuoVXh+q1yn5ljlrk6MCvdZmc3A+i0csS62CRgmn2sd1vabpZxCrfE
         NJtqeLJuMUDYuEwQ32sYunpXqHh62LPAhuasnq7VukEYZrnKqEzmNZpBpohde7HIY4Om
         1igmIUsjH92Ra9GonBE1XSuIbgf37895MsBLPpPOFDzrBYMJW92jzI2tnUzKJqvmlIFc
         tjWg==
X-Gm-Message-State: AOAM5322DX/pNJn9TuQuIK9CYAxrdFWmNzSgmv9vjRrGAilqNS5It8RI
        bsUvgpCy2sOPXkGiOoNOF+QUz0eUssZvOw==
X-Google-Smtp-Source: ABdhPJy0y9gqD4rYpD/aszk1jctI5igHhB9CmbghIiHa23dv3RAjAgSCaTwQFJo9tZzuqbthEvlJ+g==
X-Received: by 2002:a5d:494c:: with SMTP id r12mr120244wrs.406.1603150998431;
        Mon, 19 Oct 2020 16:43:18 -0700 (PDT)
Received: from [192.168.1.182] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id q7sm1637426wrr.39.2020.10.19.16.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 16:43:17 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <21aca47e03c82a06e4ea1140b328a86d04d1f422.1603122023.git.asml.silence@gmail.com>
 <ca4c9b80-78de-eae2-55cf-8d7c3f09ca80@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH for-5.10] io_uring: remove req cancel in ->flush()
Message-ID: <1799a7cf-7443-7eff-37b1-b3bf3f352968@gmail.com>
Date:   Tue, 20 Oct 2020 00:40:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ca4c9b80-78de-eae2-55cf-8d7c3f09ca80@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/10/2020 21:08, Jens Axboe wrote:
> On 10/19/20 9:45 AM, Pavel Begunkov wrote:
>> Every close(io_uring) causes cancellation of all inflight requests
>> carrying ->files. That's not nice but was neccessary up until recently.
>> Now task->files removal is handled in the core code, so that part of
>> flush can be removed.
> 
> It does change the behavior, but I'd wager that's safe. One minor
> comment:

Right, but I would think that users are not happy that every close
kills requests without apparent reasons.

> 
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 95d2bb7069c6..6536e24eb44e 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8748,16 +8748,12 @@ void __io_uring_task_cancel(void)
>>  
>>  static int io_uring_flush(struct file *file, void *data)
>>  {
>> -	struct io_ring_ctx *ctx = file->private_data;
>> +	bool exiting = !data;
>>  
>> -	/*
>> -	 * If the task is going away, cancel work it may have pending
>> -	 */
>>  	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
>> -		data = NULL;
>> +		exiting = true;
>>  
>> -	io_uring_cancel_task_requests(ctx, data);
>> -	io_uring_attempt_task_drop(file, !data);
>> +	io_uring_attempt_task_drop(file, exiting);
>>  	return 0;
>>  }
> 
> Why not just keep the !data for task_drop? Would make the diff take
> away just the hunk we're interested in. Even adding a comment would be
> better, imho.

That would look cleaner, but I just left what already was there. TBH,
I don't even entirely understand why exiting=!data. Looking up how
exit_files() works, it passes down non-NULL files to
put_files_struct() -> ... filp_close() -> f_op->flush().

I'm curious how does this filp_close(file, files=NULL) happens?

Moreover, if that's exit_files() which is interesting, then first
it calls io_uring_cancel_task_requests(), which should remove all
struct file from tctx->xa. I haven't tested it though.

-- 
Pavel Begunkov
