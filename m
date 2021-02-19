Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C7131F937
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 13:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBSMOj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 07:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhBSMOe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 07:14:34 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AC7C061574;
        Fri, 19 Feb 2021 04:13:53 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id u14so8146167wri.3;
        Fri, 19 Feb 2021 04:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lC/6S83UE9attWdnqa03ItP217AkvthfimlIDH5xWFs=;
        b=brJlnn3xF6MW/eG0I+HvUdhngEosoUpud/ndzmgrqq8oJxhRolwfYO7aFlWMlbHOZV
         LoRs7m7ARL0l7Ol5Pvs37drZZ2L+H7droL5DjqKQsa22Di0ALYUmymkx7N9yiJiXwxYI
         RuOCt1iw6NgTh8SVYOZlWFlFlNMcQQIpvWLEtmZ1+nk6bDeG4zKRRrl9doT7Uf7xtFLh
         cR0ad3NSnMtsURwk+Y8JPVlYp3PLAc/mcGU810Vh95BGt3iI2qML2eUHx7Tyx3UDHgsh
         GeUDZ2eHLRG/nAyJ2vLarmW2KxfrHhNK2NOAaEM0jNgJ9uvOM//UvvCrfr1P3y9DCrhK
         SBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lC/6S83UE9attWdnqa03ItP217AkvthfimlIDH5xWFs=;
        b=ZXbEFzC+XOtrMEqvW4p8eieOHT5O7RjxSRGbz3zBQibHZqFTp5g+e20bAksR15ybm6
         UoylO+js+nZFLwS41oBXXw9g4uZb0nflAFT3gvWqNQz+xqQQ30cF7itS8XY/taCRkKAV
         KP660ucayea9bhRuFN7NbylkusVkKe9Zv+550XE0fCeIpgLO9LdEN39GffQgwQ/t88mv
         4FY+ucx7gHk1dn7yazlzUnR1QXtxJWAhoM1zRgiysYBv6dFUaSgbcJJxxXXB4ZN/gJSi
         dCm3PBJtrgZc6oPD9ZOh5tNwAXblpyHuOjwExchdrBLRjaSNI9KgpXEbT8Y1kezKr4qD
         25uw==
X-Gm-Message-State: AOAM533QH/JLk5CrWK+Jz7ErWrVymionZUzYPet+y0vO74hJhYq91HiJ
        UqH4oGrI9kmJ33qT+PCVamSE62LzvagkQQ==
X-Google-Smtp-Source: ABdhPJwmsf4IxChnW/5o1gUo1cm9flbMjcJC3Z8KarywzK08wJtwzMaCYaygzvAKG8q16oYYzqyVAA==
X-Received: by 2002:adf:d229:: with SMTP id k9mr2662390wrh.112.1613736832368;
        Fri, 19 Feb 2021 04:13:52 -0800 (PST)
Received: from [192.168.8.137] ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id o13sm16033673wrs.45.2021.02.19.04.13.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 04:13:52 -0800 (PST)
Subject: Re: [PATCH v3 2/2] io_uring: add support for IORING_OP_GETDENTS
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     David Laight <David.Laight@aculab.com>,
        Matthew Wilcox <willy@infradead.org>
References: <20210218122640.GA334506@wantstofly.org>
 <20210218122755.GC334506@wantstofly.org>
 <9a6fb59b-be85-c36b-3c83-26cff37bcb87@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <8b675c3d-3d25-aaca-7796-e02bba2da01a@gmail.com>
Date:   Fri, 19 Feb 2021 12:10:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <9a6fb59b-be85-c36b-3c83-26cff37bcb87@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/02/2021 12:05, Pavel Begunkov wrote:
> On 18/02/2021 12:27, Lennert Buytenhek wrote:
>> IORING_OP_GETDENTS behaves much like getdents64(2) and takes the same
>> arguments, but with a small twist: it takes an additional offset
>> argument, and reading from the specified directory starts at the given
>> offset.
>>
>> For the first IORING_OP_GETDENTS call on a directory, the offset
>> parameter can be set to zero, and for subsequent calls, it can be
>> set to the ->d_off field of the last struct linux_dirent64 returned
>> by the previous IORING_OP_GETDENTS call.
>>
>> Internally, if necessary, IORING_OP_GETDENTS will vfs_llseek() to
>> the right directory position before calling vfs_getdents().
>>
>> IORING_OP_GETDENTS may or may not update the specified directory's
>> file offset, and the file offset should not be relied upon having
>> any particular value during or after an IORING_OP_GETDENTS call.
>>
>> Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
>> ---
>>  fs/io_uring.c                 | 73 +++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/io_uring.h |  1 +
>>  2 files changed, 74 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 056bd4c90ade..6853bf48369a 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -635,6 +635,13 @@ struct io_mkdir {
>>  	struct filename			*filename;
>>  };
>>  
> [...]
>> +static int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_getdents *getdents = &req->getdents;
>> +	bool pos_unlock = false;
>> +	int ret = 0;
>> +
>> +	/* getdents always requires a blocking context */
>> +	if (issue_flags & IO_URING_F_NONBLOCK)
>> +		return -EAGAIN;
>> +
>> +	/* for vfs_llseek and to serialize ->iterate_shared() on this file */
>> +	if (file_count(req->file) > 1) {
> 
> Looks racy, is it safe? E.g. can be concurrently dupped and used, or just
> several similar IORING_OP_GETDENTS requests.
> 
>> +		pos_unlock = true;
>> +		mutex_lock(&req->file->f_pos_lock);
>> +	}
>> +
>> +	if (req->file->f_pos != getdents->pos) {
>> +		loff_t res = vfs_llseek(req->file, getdents->pos, SEEK_SET);
> 
> I may be missing the previous discussions, but can this ever become
> stateless, like passing an offset? Including readdir.c and beyond. 

I mean without those seeks. An emulation would look like rewinding
pos back after vfs_getdents, though might be awful on performance. 

> 
>> +		if (res < 0)
>> +			ret = res;
>> +	}
>> +
>> +	if (ret == 0) {
>> +		ret = vfs_getdents(req->file, getdents->dirent,
>> +				   getdents->count);
>> +	}
>> +
>> +	if (pos_unlock)
>> +		mutex_unlock(&req->file->f_pos_lock);
>> +
>> +	if (ret < 0) {
>> +		if (ret == -ERESTARTSYS)
>> +			ret = -EINTR;
>> +		req_set_fail_links(req);
>> +	}
>> +	io_req_complete(req, ret);
>> +	return 0;
>> +}
> [...]
> 

-- 
Pavel Begunkov
