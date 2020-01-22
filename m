Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E1F144A62
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 04:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgAVDXC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 22:23:02 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38513 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728900AbgAVDXB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 22:23:01 -0500
Received: by mail-pl1-f195.google.com with SMTP id f20so2305924plj.5
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2020 19:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WzWlqSAwBUYEHp474vY25WNq5cVSn3o2GyR5izuQQ6I=;
        b=WqqDeek7IOETWuK4uyhivNNdGgPsGTJ+LQ4rSmigeF5wvVloRRnW12aj64MLBWr6jj
         /ESnNSbAnL/NKNkcNYKOUoj4VKBb/N2QWdU/ZQIHt89BWLB7lLagV1EMWo00XgtcP+Rm
         0obLYR61L1gI1UB9v0WOJgixa+wrnRME/jorMM3AtfVfL1xLSVWLr5WUv4sbYuHwzKI0
         5WOBxlpUzIWV2u26LJoUn/7WsbyEyY9HMt80MIOfexO/ibceakxxAGnNAoksNRFvmleF
         ndamVdEYFdkDsEoPm26uKMK8EC+AvcwbvKiuI3PfcsgEeHM7dxRWrk7K05HgZ5y18Nn0
         CBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WzWlqSAwBUYEHp474vY25WNq5cVSn3o2GyR5izuQQ6I=;
        b=BCpVb3x384t2rX6KV3GBbn4tAhpmuVR25yNuXEA0IAHZRoGWcD2OqRN/hUGO44dOta
         mKe6sVxaC+H2Dcm2kAt0OlQnF3+iAMt55N3BAzj5BOPAU0geS+ZolFeoHNHIQaTTmBJG
         vuT2JgAE4mEEE+mvEN+CvZuolOMecE0ibb5ucFwK88nxsoDmVe1McrwmxaY2WWyKUcTP
         7IWdb9RCJXxYK9jjNJPC1gBVpFq41Ehx486llBZ5Lp6m6R6FFk95g1lUE/6evuoo2ilm
         u7XdGdfIA0TmVUu0mrNF7ZPRiglxRB1ul1h54ErGjO4GlVJnwUWLLDp9s6jHUPGSDqo5
         8uag==
X-Gm-Message-State: APjAAAWLebshzA185Q7fv/LuYwLcKf2Y7TJ3W/o/EWRVQ3bbhPR3zg/i
        74cuSlgHxiqWiCXzEIf0NxHraw==
X-Google-Smtp-Source: APXvYqx45UJwpaZsGhTx3w8CdAdqEztpeY705Gedj+Y8kUrFvfcZfV4c4AtGUUhl24em2ZBh1jkXUw==
X-Received: by 2002:a17:90b:8b:: with SMTP id bb11mr567939pjb.27.1579663381129;
        Tue, 21 Jan 2020 19:23:01 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id w4sm830441pjt.23.2020.01.21.19.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 19:23:00 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: add splice(2) support
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
References: <cover.1579649589.git.asml.silence@gmail.com>
 <8bfd9a57bf42cfc10ee7195969058d6da277deed.1579649589.git.asml.silence@gmail.com>
 <6d43b9d7-209a-2bbf-e2c2-e125e84b46ab@kernel.dk>
 <14499431-0409-5d57-9b08-aff95b9d2160@gmail.com>
 <b20d33eb-fd88-418c-57b6-32feb84d2373@kernel.dk>
 <578003e9-1af2-4df6-d9e1-cdbbbb701bf7@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <60459de4-3497-0226-127a-e748486852c6@kernel.dk>
Date:   Tue, 21 Jan 2020 20:22:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <578003e9-1af2-4df6-d9e1-cdbbbb701bf7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/21/20 8:16 PM, Pavel Begunkov wrote:
> On 22/01/2020 05:47, Jens Axboe wrote:
>> On 1/21/20 7:40 PM, Pavel Begunkov wrote:
>>>>> @@ -719,6 +730,11 @@ static const struct io_op_def io_op_defs[] = {
>>>>>  		.needs_file		= 1,
>>>>>  		.fd_non_neg		= 1,
>>>>>  	},
>>>>> +	[IORING_OP_SPLICE] = {
>>>>> +		.needs_file		= 1,
>>>>> +		.hash_reg_file		= 1,
>>>>> +		.unbound_nonreg_file	= 1,
>>>>> +	}
>>>>>  };
>>>>>  
>>>>>  static void io_wq_submit_work(struct io_wq_work **workptr);
>>>>
>>>> I probably want to queue up a reservation for the EPOLL_CTL that I
>>>> haven't included yet, but which has been tested. But that's easily
>>>> manageable, so no biggy on my end.
>>>
>>> I didn't quite get it. Do you mean collision of opcode numbers?
>>
>> Yeah that's all I meant, sorry wasn't too clear. But you can disregard,
>> I'll just pop a reservation in front if/when this is ready to go in if
>> it's before EPOLL_CTL op.
>>
>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>> index 57d05cc5e271..f234b13e7ed3 100644
>>>>> --- a/include/uapi/linux/io_uring.h
>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>> @@ -23,8 +23,14 @@ struct io_uring_sqe {
>>>>>  		__u64	off;	/* offset into file */
>>>>>  		__u64	addr2;
>>>>>  	};
>>>>> -	__u64	addr;		/* pointer to buffer or iovecs */
>>>>> -	__u32	len;		/* buffer size or number of iovecs */
>>>>> +	union {
>>>>> +		__u64	addr;		/* pointer to buffer or iovecs */
>>>>> +		__u64	off_out;
>>>>> +	};
>>>>> +	union {
>>>>> +		__u32	len;	/* buffer size or number of iovecs */
>>>>> +		__s32	fd_out;
>>>>> +	};
>>>>>  	union {
>>>>>  		__kernel_rwf_t	rw_flags;
>>>>>  		__u32		fsync_flags;
>>>>> @@ -37,10 +43,12 @@ struct io_uring_sqe {
>>>>>  		__u32		open_flags;
>>>>>  		__u32		statx_flags;
>>>>>  		__u32		fadvise_advice;
>>>>> +		__u32		splice_flags;
>>>>>  	};
>>>>>  	__u64	user_data;	/* data to be passed back at completion time */
>>>>>  	union {
>>>>>  		__u16	buf_index;	/* index into fixed buffers, if used */
>>>>> +		__u64	splice_len;
>>>>>  		__u64	__pad2[3];
>>>>>  	};
>>>>>  };
>>>>
>>>> Not a huge fan of this, also mean splice can't ever used fixed buffers.
>>>> Hmm...
>>>
>>> But it's not like splice() ever uses user buffers. Isn't it? vmsplice
>>> does, but that's another opcode.
>>
>> I guess that's true, I had vmsplice on my mind for this as well. But
>> won't be a problem there, since it doesn't take 6 arguments like splice
>> does.
>>
>> Another option is to do an indirect for splice, stuff the arguments in a
>> struct that's passed in as a pointer in ->addr. A bit slower, but
>> probably not a huge deal.
>>
>>>>> @@ -67,6 +75,9 @@ enum {
>>>>>  /* always go async */
>>>>>  #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
>>>>>  
>>>>> +/* op custom flags */
>>>>> +#define IOSQE_SPLICE_FIXED_OUT	(1U << 16)
>>>>> +
>>>>
>>>> I don't think it's unreasonable to say that if you specify
>>>> IOSQE_FIXED_FILE, then both are fixed. If not, then none of them are.
>>>> What do you think?
>>>>
>>>
>>> It's plausible to register only one end for splicing, e.g. splice from
>>> short-lived sockets to pre-registered buffers-pipes. And it's clearer
>>> do it now.
>>
>> You're probably right, though it's a bit nasty to add an unrelated flag
>> in the splice flag space... We should probably reserve it in splice
>> instead, and just not have it available from the regular system call.
>>
> Agree, it looks bad. I don't want to add it into sqe->splice_flags to
> not clash with splice(2) in the future, but could have a separate
> field in @sqe...  or can leave in in sqe->flags, as it's done in the
> patch, but that's like a portion of bits would be opcode specific and
> we would need to set rules for their use.

It won't clash with splice(2), just make that flag illegal if done
through splice(2) directly. Honestly I think that's (by FAR) the best
way to do it, having a private io_uring flag that acts as a splice flag
is really confusing and prone to breakage. Not that it's a huge issue
with splice as the flags have been stable for years, so don't really see
a high risk of collision. But we should still do it right, which means
adding SPLICE_F_OUT_FIXED or whatever you want to call it. Do that as a
prep patch, make do_splice() into __do_splice(), and have io_uring call
__do_splice(). Currently splice(2) is permissive in terms of flags, so
maybe just mask it in do_splice() to be on the safe side. Then we know
only internal users will set SPLICE_F_OUT_FIXED, and we'll never run
into the risk of having a collision as it's part of the flag space
anyway.

The sqe->flags space is very tight, so adding a splice specific opcode
there would be bad.

-- 
Jens Axboe

