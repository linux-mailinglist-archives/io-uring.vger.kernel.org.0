Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B533B033E
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 13:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFVLwq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 07:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhFVLwq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 07:52:46 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67E7C061574;
        Tue, 22 Jun 2021 04:50:29 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id c7so22287022edn.6;
        Tue, 22 Jun 2021 04:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d+qIXTP3RCqD+Y4qN5uYXWsOonYWybHJLztxL/Htjo4=;
        b=RFbyNWDhHDptHe12W2OJ/q/OKkN1a7kI7M0PCSfKIN/m9pib4Dxt/R1E+rlQN3u8Ys
         SdtFD5ZVYVHp7ZNE92cAvj93loEpu4W8eOd/EdBWSb3SsnqhpV8CxPCNg+Vj3Iq4wQLt
         CFtadGv5FjYaiViTWZYAxu89BDvv2YQjBMjFdrMWix428ZXAqD1usmJdihHdYNzCZpCx
         X3YP0WZ/1tIM8QsMxsolBRj5fHbHFCVxyhCIEtoccdd+WcZjMIBm9rt78YIg13/p3E3X
         kF/YPgA9mTkw3VQxljbtliRavLpZ5Ax8fxtcmWpnqqaL2GY6UBUggbxSx+kd3fLqSFAJ
         9r9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d+qIXTP3RCqD+Y4qN5uYXWsOonYWybHJLztxL/Htjo4=;
        b=ujLfVbjuEpvTUowE0D2pj2SnJKgzp8Ipw4csj1eoRFCzolZhEzBUTPoPL9knlkSJbW
         qH9/delppRdGoMjFYzo9EqlWIGUx104EOLaI4lWyTs4dj3VV1kxlnQLwVz/wxV6G5Tlc
         tZAL7u0VvpuVAKthQtNDExVi2UKFI+6bfjZKcNJ7fe0EjVQZWvJ+rvINFZbjvoK+Iwcy
         iyDMbKLHR023Tip0BisK8Zjf4bwhLwmaQTmbf0gQppc2g4SmI4H1pb0y+IGYpdUYFB+U
         yOENrdpwPxJ1//PwUR2AA6Yp0zM12/gQWuRXRKxiyNvBBnCmh4bW20aEFhUDRJHj8LKw
         MIhw==
X-Gm-Message-State: AOAM530HuHyeU3i8wIj/mdKW4Bw8KWPTIYZMRTuiB6Pi8RVxd7PhT8lP
        0Js8HMnrJFBVTm5MxUs7Xssxcl0Voigq7yL3
X-Google-Smtp-Source: ABdhPJzl51B71tFeQYSyS4DKkQKNJcc39ycQb5Esgy7tMjncgl0tKalQ9L/NUm/vjilmqM6KcGamGA==
X-Received: by 2002:a05:6402:10cc:: with SMTP id p12mr4403126edu.328.1624362628299;
        Tue, 22 Jun 2021 04:50:28 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:c503])
        by smtp.gmail.com with ESMTPSA id n15sm12007111eds.28.2021.06.22.04.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 04:50:27 -0700 (PDT)
Subject: Re: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <20210603051836.2614535-3-dkadashev@gmail.com>
 <c079182e-7118-825e-84e5-13227a3b19b9@gmail.com>
Message-ID: <4c0344d8-6725-84a6-b0a8-271587d7e604@gmail.com>
Date:   Tue, 22 Jun 2021 12:50:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c079182e-7118-825e-84e5-13227a3b19b9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 12:41 PM, Pavel Begunkov wrote:
> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
>> IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
>> and arguments.
>>
>> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
>> ---
>>  fs/io_uring.c                 | 55 +++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/io_uring.h |  1 +
>>  2 files changed, 56 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index a1ca6badff36..8ab4eb559520 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -665,6 +665,13 @@ struct io_unlink {
>>  	struct filename			*filename;
>>  };
>>  
>> +struct io_mkdir {
>> +	struct file			*file;
>> +	int				dfd;
>> +	umode_t				mode;
>> +	struct filename			*filename;
>> +};
>> +
>>  struct io_completion {
>>  	struct file			*file;
>>  	struct list_head		list;
>> @@ -809,6 +816,7 @@ struct io_kiocb {
>>  		struct io_shutdown	shutdown;
>>  		struct io_rename	rename;
>>  		struct io_unlink	unlink;
>> +		struct io_mkdir		mkdir;
>>  		/* use only after cleaning per-op data, see io_clean_op() */
>>  		struct io_completion	compl;
>>  	};
>> @@ -1021,6 +1029,7 @@ static const struct io_op_def io_op_defs[] = {
>>  	},
>>  	[IORING_OP_RENAMEAT] = {},
>>  	[IORING_OP_UNLINKAT] = {},
>> +	[IORING_OP_MKDIRAT] = {},
>>  };
>>  
>>  static bool io_disarm_next(struct io_kiocb *req);
>> @@ -3530,6 +3539,44 @@ static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
>>  	return 0;
>>  }
>>  
>> +static int io_mkdirat_prep(struct io_kiocb *req,
>> +			    const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_mkdir *mkd = &req->mkdir;
>> +	const char __user *fname;
>> +
>> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
>> +		return -EBADF;
>> +
>> +	mkd->dfd = READ_ONCE(sqe->fd);
>> +	mkd->mode = READ_ONCE(sqe->len);
>> +
>> +	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +	mkd->filename = getname(fname);
>> +	if (IS_ERR(mkd->filename))
>> +		return PTR_ERR(mkd->filename);
> 
> We have to check unused fields, e.g. buf_index and off,
> to be able to use them in the future if needed. 
> 
> if (sqe->buf_index || sqe->off)
> 	return -EINVAL;
> 
> Please double check what fields are not used, and
> same goes for all other opcodes.

+ opcode specific flags, e.g.

if (sqe->rw_flags)
	return -EINVAL;

-- 
Pavel Begunkov
