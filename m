Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D0E31087E
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 10:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhBEJ4C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Feb 2021 04:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhBEJwn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Feb 2021 04:52:43 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADE1C06121D
        for <io-uring@vger.kernel.org>; Fri,  5 Feb 2021 01:52:02 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c127so5384844wmf.5
        for <io-uring@vger.kernel.org>; Fri, 05 Feb 2021 01:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2eBy9S0GvwS1JKiKvVnPHVgH1JiUWVZCIVHssrRQdJI=;
        b=D2iaK6Oy5VNkIy8yPN+c2/pO5oy9FNGY9fJETKUZk7+sFyE00eAPmG6RMTsfBcswA0
         3qhvkUsW9sxGTtMX6PVhDxH7rACWfWiSyjmNplxiGO3uxJhGXBgYWBCy4SaA/uKAAvam
         JW0SuUr+uZh+AkHg1EOKJboRGzATq2MsGJhxOvtnA09vVliN3WU+VzucxQM0vwCxCIC+
         ideaWd0qRqnfK7YlirQXqsWZUO4p52ebMcYO8XEv3e7F3E+GN1aOOeOnEYdhFI0IOmX0
         eocb0MUP4ZQSnGKmwjKl5Ehe+j5UKjuvIUOyjE2ULgzy560Cyw9AGfKseS3F90abaYI8
         HU+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2eBy9S0GvwS1JKiKvVnPHVgH1JiUWVZCIVHssrRQdJI=;
        b=XTtdc30cU+wc4gPr2QpV+Erqo/2yYzffXF5ww41R6uz2AiAK+00znesYTYWDMJJ93S
         igIpT+xZsMtD36ibPJRal8p5olBjqEMMIu5+yN/cJ374xRoLrmkvR6F5t9RZfemhZUnE
         CN9D818KHb2dyWUk0UKisK2beNkrAx3/ERht6Q86uptJvRmazHiihqGPRCmjCSs4BtGN
         qpypHX8hPuwuXRuORrm3a80z78/GCjMIhxjLCqdo5E2McYZCifFifQlXwpoFmdD0ZyJ1
         28nQIbyXNqLlQdcEK6bHJ5YlKbmnjlva/ScG815DmncQt41DTWefOZgGfAr7DfLSIyDj
         yB9g==
X-Gm-Message-State: AOAM5309o7XXnsiFmmav/vt87cw+5D7pwhadZHbfdVEaJgvH0jdY6CGv
        UA3Em2FY34xQMM0IQAXoL/soeLmJHdgxJA==
X-Google-Smtp-Source: ABdhPJxEfyupef2CC+EcErliK9soKU0eiqdTPyuX2V/VH2ch0fWXyL54CfrVZj940KUOCKqM/E9vng==
X-Received: by 2002:a1c:8002:: with SMTP id b2mr2911656wmd.94.1612518720744;
        Fri, 05 Feb 2021 01:52:00 -0800 (PST)
Received: from [192.168.8.177] ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id m2sm8051298wml.34.2021.02.05.01.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 01:52:00 -0800 (PST)
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1612486458.git.asml.silence@gmail.com>
 <ac7dc756e811000751c9cc8fba5d03cc73da314a.1612486458.git.asml.silence@gmail.com>
 <e8bb9ad9-d4ad-8215-fdef-2fb136ae5a41@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/3] io_uring: refactor sendmsg/recvmsg iov managing
Message-ID: <3aae2e7d-0405-7f5b-9062-5eca9df13e74@gmail.com>
Date:   Fri, 5 Feb 2021 09:48:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e8bb9ad9-d4ad-8215-fdef-2fb136ae5a41@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/02/2021 07:17, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>>  static int io_sendmsg_copy_hdr(struct io_kiocb *req,
>>  			       struct io_async_msghdr *iomsg)
>>  {
>> -	iomsg->iov = iomsg->fast_iov;
>>  	iomsg->msg.msg_name = &iomsg->addr;
>> +	iomsg->free_iov = iomsg->fast_iov;
> 
> Why this? Isn't the idea of this patch that free_iov is never == fast_iov?

That's a part of __import_iovec() and sendmsg_copy_msghdr() API, you pass
fast_iov as such and get back NULL or a newly allocated one in it.

> 
> 
>> @@ -4704,10 +4703,11 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
>>  		if (copy_from_user(iomsg->fast_iov, uiov, sizeof(*uiov)))
>>  			return -EFAULT;
>>  		sr->len = iomsg->fast_iov[0].iov_len;
>> -		iomsg->iov = NULL;
>> +		iomsg->free_iov = NULL;
>>  	} else {
>> +		iomsg->free_iov = iomsg->fast_iov;
> 
> The same here...
> 
>>  		ret = __import_iovec(READ, uiov, iov_len, UIO_FASTIOV,
>> -				     &iomsg->iov, &iomsg->msg.msg_iter,
>> +				     &iomsg->free_iov, &iomsg->msg.msg_iter,
>>  				     false);
>>  		if (ret > 0)
>>  			ret = 0;
>> @@ -4746,10 +4746,11 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
>>  		if (clen < 0)
>>  			return -EINVAL;
>>  		sr->len = clen;
>> -		iomsg->iov = NULL;
>> +		iomsg->free_iov = NULL;
>>  	} else {
>> +		iomsg->free_iov = iomsg->fast_iov;
> 
> And here...
> 
>>  		ret = __import_iovec(READ, (struct iovec __user *)uiov, len,
>> -				   UIO_FASTIOV, &iomsg->iov,
>> +				   UIO_FASTIOV, &iomsg->free_iov,
>>  				   &iomsg->msg.msg_iter, true);
>>  		if (ret < 0)
>>  			return ret;
> 
>> @@ -4872,8 +4867,8 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
>>  
>>  	if (req->flags & REQ_F_BUFFER_SELECTED)
>>  		cflags = io_put_recv_kbuf(req);
>> -	if (kmsg->iov != kmsg->fast_iov)
>> -		kfree(kmsg->iov);
>> +	if (kmsg->free_iov)
>> +		kfree(kmsg->free_iov);
> 
> kfree() handles NULL, or is this a hot path and we want to avoid a function call?

Yes, the hot path here is not having iov allocated, and Jens told before
that he had observed overhead for a similar place in io_[read,write].

-- 
Pavel Begunkov
