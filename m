Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E31303D05
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 13:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390778AbhAZMab (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 07:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404336AbhAZMaZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 07:30:25 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF50AC0611C2;
        Tue, 26 Jan 2021 04:29:44 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id g3so22683225ejb.6;
        Tue, 26 Jan 2021 04:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=59cFXkwJWPJ9ngel/GaPYAwLL/Yt3i4uFuJVUmWJiBU=;
        b=eYKRW0ofXu/TXhGWrYJhDPR0vwCuh/Ctcl75nycp/j5GJkVP+yeVid4f54KD3EGypM
         Q0VXiXk+N0OcigXhej4mxyiKFfXp5M+5q8gWHmVbVqfsd6UgkFSUXnmufGkBSwWqN0gj
         toSL/Ztt1tvXCHOXo2jdwLD4XS5VEKkbapnygfQ/VoEfaxqMKAMUx27/vQt5M5F+INXc
         pt7Dr2fjKt9j5djAe4z6WvbBlYG7vth+Fdhj/UoyqMWsX1kE8eTpDetcIyGVU+w22YD5
         iujVYdwRSA+htC6Z4wC5fAic7Z7w6p1ifHNwfl77KbuhDQcrAz3OVYj4jai0g//YRLY/
         cLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=59cFXkwJWPJ9ngel/GaPYAwLL/Yt3i4uFuJVUmWJiBU=;
        b=iZuNjFSOCMYSMbxTJpaHY0M0mZKN+CukGLj34mVO49gylRfhcVrNnnLqhdCBFOr/W8
         fWIci/r5Kx5mpFS7PYLPuPjh+b0ZmLXxJmVnkhAzuSuJiolEq4Coy9Gw+shYLSxOnD6y
         s0Sdx6caG2TOJ33hgi+vbtKwdy0Hmrh78QAioj96xfI0BejulpgbrDkrU8qEknRRdozj
         yiV9EGQBs8TPDiB2YhMqvL6DLL9HDmBZEpbJjgNXpMkU7ICmWOF4uBFuy6PGduMkvBUo
         cir8D3JAnHvacE8v+oa2zxM3QeOPAQP8nLiKWEbXXswNdI8CKYq7yEodcG/WeHvZNkt/
         EWsg==
X-Gm-Message-State: AOAM533HauaPdwybzd8B4Ux/Tg8bRNL+626wRRgRKNAQqHOX2KQkvBQ8
        sICLxDD6HFrjF0n33t5KIc8Y3o2kPq6dKg==
X-Google-Smtp-Source: ABdhPJytcU2baOqtTSXldY3lyoYk04HfdBN6EqAzpXbNLwdVOLfcj+RII6QyHLNKHxXZUqDA3RE1MQ==
X-Received: by 2002:a17:906:1c42:: with SMTP id l2mr3368734ejg.390.1611664183294;
        Tue, 26 Jan 2021 04:29:43 -0800 (PST)
Received: from [192.168.8.156] ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id ah12sm4387531ejc.70.2021.01.26.04.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 04:29:42 -0800 (PST)
To:     Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     noah <goldstein.n@wustl.edu>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201220065025.116516-1-goldstein.w.n@gmail.com>
 <0cdf2aac-6364-742d-debb-cfd58b4c6f2b@gmail.com>
 <20201222021043.GA139782@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] fs: io_uring.c: Add skip option for __io_sqe_files_update
Message-ID: <32c9ce7e-569d-3f94-535e-00e072de772e@gmail.com>
Date:   Tue, 26 Jan 2021 12:26:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201222021043.GA139782@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 22/12/2020 02:10, Noah Goldstein wrote:
> On Sun, Dec 20, 2020 at 03:18:05PM +0000, Pavel Begunkov wrote:
>> On 20/12/2020 06:50, noah wrote:> From: noah <goldstein.n@wustl.edu>
>>>
>>> This patch makes it so that specify a file descriptor value of -2 will
>>> skip updating the corresponding fixed file index.
>>>
>>> This will allow for users to reduce the number of syscalls necessary
>>> to update a sparse file range when using the fixed file option.
>>
>> Answering the github thread -- it's indeed a simple change, I had it the
>> same day you posted the issue. See below it's a bit cleaner. However, I
>> want to first review "io_uring: buffer registration enhancements", and
>> if it's good, for easier merging/etc I'd rather prefer to let it go
>> first (even if partially).

Noah, want to give it a try? I've just sent a prep patch, with it you
can implement it cleaner with one continue.

>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 941fe9b64fd9..b3ae9d5da17e 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -7847,9 +7847,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>>  	if (IS_ERR(ref_node))
>>  		return PTR_ERR(ref_node);
>>  
>> -	done = 0;
>>  	fds = u64_to_user_ptr(up->fds);
>> -	while (nr_args) {
>> +	for (done = 0; done < nr_args; done++) {
>>  		struct fixed_file_table *table;
>>  		unsigned index;
>>  
>> @@ -7858,7 +7857,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>>  			err = -EFAULT;
>>  			break;
>>  		}
>> -		i = array_index_nospec(up->offset, ctx->nr_user_files);
>> +		if (fd == IORING_REGISTER_FILES_SKIP)
>> +			continue;
>> +
>> +		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
>>  		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
>>  		index = i & IORING_FILE_TABLE_MASK;
>>  		if (table->files[index]) {
>> @@ -7896,9 +7898,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>>  				break;
>>  			}
>>  		}
>> -		nr_args--;
>> -		done++;
>> -		up->offset++;
>>  	}
>>  
>>  	if (needs_switch) {

-- 
Pavel Begunkov
