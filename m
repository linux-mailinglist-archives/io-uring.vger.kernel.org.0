Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A96241616D7
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 16:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgBQP7V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Feb 2020 10:59:21 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39265 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbgBQP7V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Feb 2020 10:59:21 -0500
Received: by mail-lj1-f193.google.com with SMTP id o15so19439780ljg.6;
        Mon, 17 Feb 2020 07:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dHYSbY8DgUo7Pn7yVZAxh0Tlo9+8NTFXFAbrlJ6RWIQ=;
        b=hDob0D2gjwaX3LGAPa1TSVo5hjFh8v7DQbNhVIFTY+wdXpd0eOjmyluIW+WOgQvBGG
         12oqLStg+/rJYmKzX3gsY5iYYQrNXqsY7OWZM58VAsB7+bpxL+cUOtwosd7GaPJVxiIR
         BrGuYdfNiIym6+/rRE6q232iRYZMI2l34m8NJlrqKqE5sKtwNftc+YFE0/j+6bxS77CV
         eaaHSFXZTCndtP9wy6GXGKDjL02WoJQxcJt9A2ZZwz+UMjrtH1upJspPqP+7vtgX4BtE
         sSE9sQyhBGWitmnnql4vZOdCNDelLIHxkcyWxo+JOMZKA8BxjuHk//aDk3uUA0/no/V0
         0yAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dHYSbY8DgUo7Pn7yVZAxh0Tlo9+8NTFXFAbrlJ6RWIQ=;
        b=HfoUvhIdphwjtfh3yKIemfbmWApyzUAW/k0+sWIfOxAiGKn2Ar44VIgBB2vlQ6i3gV
         +6ML1UKV8XHPaCdGF8O1JXmouAvBcffx85/R4S5JW69KcwXd9rQYTIYrlbClhM8sQY4P
         ou5cliA/FSS6QWTzndNH450Wjr3LD1j6Ce+V3cNk2kC2MlLDnd8dcS/bwWn4sUYvmRIU
         LlahV/F3njLnJpMJLVY94QZUJeuc2DieMu5UzEYrY8hP83jDaxv+xELi8Y6wPmwErbVs
         GnTj2zhiymc7IpFJ0dOyWXwTs7NYFPTVQVBAvLYRYs6mAu6DmEYAidYdFtDrXHzgKt1p
         vWYg==
X-Gm-Message-State: APjAAAV54SOMgtulUVeFxKkxGDemdRzxELlKNybmHg2abWqVfX9XnBhy
        rVIZ/QN+SW6byRNETOUrIwFNQZZ5TblW9Q==
X-Google-Smtp-Source: APXvYqwSolTctQ5z1XmqXD5luY8WULh18KOaWRBm5mRxsBdKnBkpMa6GBJg8JxyFs/HRWu5DpdfsqQ==
X-Received: by 2002:a2e:3608:: with SMTP id d8mr10324540lja.152.1581955158267;
        Mon, 17 Feb 2020 07:59:18 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id w19sm561554lfl.55.2020.02.17.07.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 07:59:17 -0800 (PST)
Subject: Re: [PATCH v2 3/3] io_uring: add splice(2) support
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1581802973.git.asml.silence@gmail.com>
 <b33d7315f266225237dfd10f483162c51c2ed5bc.1581802973.git.asml.silence@gmail.com>
 <6d803558-ab09-1850-2c38-38848b8ddf27@samba.org>
 <b44a4692-f43c-e625-3eb7-cc4e12041f48@gmail.com>
 <033a6560-df47-39a2-871b-13f2d84bb1ec@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <4d9c4fd2-d319-11bf-dfd2-e02e0f759a8b@gmail.com>
Date:   Mon, 17 Feb 2020 18:59:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <033a6560-df47-39a2-871b-13f2d84bb1ec@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/17/2020 6:54 PM, Stefan Metzmacher wrote:
> Am 17.02.20 um 16:40 schrieb Pavel Begunkov:
>> On 2/17/2020 6:18 PM, Stefan Metzmacher wrote:
>>> Hi Pavel,
>>>
>>>> +static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>> +{
>>>> +	struct io_splice* sp = &req->splice;
>>>> +	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
>>>> +	int ret;
>>>> +
>>>> +	if (req->flags & REQ_F_NEED_CLEANUP)
>>>> +		return 0;
>>>> +
>>>> +	sp->file_in = NULL;
>>>> +	sp->off_in = READ_ONCE(sqe->off_in);
>>>> +	sp->off_out = READ_ONCE(sqe->off);
>>>> +	sp->len = READ_ONCE(sqe->len);
>>>> +	sp->flags = READ_ONCE(sqe->splice_flags);
>>>> +
>>>> +	if (unlikely(READ_ONCE(sqe->ioprio) || (sp->flags & ~valid_flags)))
>>>> +		return -EINVAL;
>>>
>>> Why is ioprio not supported?
>>
>> Because there is no way to set it without changing much of splice code.
>> It may be added later
>>
>> BTW, it seems, only opcodes cares about ioprio are read*/write*.
>> recv*() and send*() don't reject it, but never use.
> 
> I guess it's more like a hint, so should we just ignore it until
> it's passed down? Otherwise applications need to do some logic to
> find out if they can pass a value or not.

Then it probably needs to validate the value, but not just ignore it

> I'm not sure what's better, but I think it needs to be discussed...

meh, let's see what Jens think

-- 
Pavel Begunkov
