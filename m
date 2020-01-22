Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0AA1144A05
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 03:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgAVCrM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 21:47:12 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35247 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbgAVCrL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 21:47:11 -0500
Received: by mail-pg1-f195.google.com with SMTP id l24so2638108pgk.2
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2020 18:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0rxaL4YyIX9dCEw33HQ7YapeN1FRDZHEzq4cOQYjM7I=;
        b=SJZ89xq1sgeyhOMo3emk8g8ZLjVmAvgFjtt0GPntc5dYAXZppjO++bzJT2MA459lA8
         ywv1E/CnuixHWmnls/LvJRASaMrsi0lu3cLpezDDDM3ppYn/AKPQ+f6qcCLH/5mzwVbn
         usNO2PGO7GQtX6+xbr9ZDxwwy/nwOtCY2nvH2PauY7EDg/2d5hdu4/Dxx6vMVHEYZ4cT
         qxgdO7k24MmlVwfGatI7mWBDhB4Ykq/vS5ll5Xba+XoP21qzoWcJGpI01tvnWjvP7swJ
         IIZJ3CkaZTHUHxydPjLyqqUJ0hDjgPvHoCRMSp2uX1r5f6Bs5Qr8tMNDCXiedzV2BtrB
         ujZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0rxaL4YyIX9dCEw33HQ7YapeN1FRDZHEzq4cOQYjM7I=;
        b=bjJsJRR8ZxRxlS6dWGxaNVJIdTfQyuFN0VazFgMwnp4j35XeoBWZu7M9NlD2CLYZ/n
         dlcc6jyc47RsbUihkXNJEvfac7FC/A6CLgYN9wQQ8GiBVnXt9oeXqb2qWpk7kYtPxP8j
         a0MJSWT/FDTLvJvxbH6Tjp93KrvdnMgtDrfd+nfwR3+yOzED5fyxD72w/SqmGh3dRsg8
         L5jX7lWpMfN6V11RMyXYX90CuVMYfwxlJJTBVyAbuaosW2esHIXced6f1Hsr+16byqdR
         N+f7lWGXlnrrmdudCoRNN7Rn7DmEb448tdFh0X/djlqmxHSEsHg2bpLiwFP/bQCCHh5/
         tTNQ==
X-Gm-Message-State: APjAAAVDmf1E+dEw2Dc5QW4PfLxMLvcGrg88Nhl1br9CefLP1LFepja9
        45EA3R5D8OJulor+xxMUXACxfA==
X-Google-Smtp-Source: APXvYqwXh+FO20oQozQ7HN+RGIFxvrwqF1xI/skGG3+/DzqQkmkzYX8gW4vJ5OjtNsJY/ZiYN5auMw==
X-Received: by 2002:a63:a357:: with SMTP id v23mr8856132pgn.223.1579661231077;
        Tue, 21 Jan 2020 18:47:11 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id w3sm41003716pgj.48.2020.01.21.18.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 18:47:10 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: add splice(2) support
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
References: <cover.1579649589.git.asml.silence@gmail.com>
 <8bfd9a57bf42cfc10ee7195969058d6da277deed.1579649589.git.asml.silence@gmail.com>
 <6d43b9d7-209a-2bbf-e2c2-e125e84b46ab@kernel.dk>
 <14499431-0409-5d57-9b08-aff95b9d2160@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b20d33eb-fd88-418c-57b6-32feb84d2373@kernel.dk>
Date:   Tue, 21 Jan 2020 19:47:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <14499431-0409-5d57-9b08-aff95b9d2160@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/21/20 7:40 PM, Pavel Begunkov wrote:
>>> @@ -719,6 +730,11 @@ static const struct io_op_def io_op_defs[] = {
>>>  		.needs_file		= 1,
>>>  		.fd_non_neg		= 1,
>>>  	},
>>> +	[IORING_OP_SPLICE] = {
>>> +		.needs_file		= 1,
>>> +		.hash_reg_file		= 1,
>>> +		.unbound_nonreg_file	= 1,
>>> +	}
>>>  };
>>>  
>>>  static void io_wq_submit_work(struct io_wq_work **workptr);
>>
>> I probably want to queue up a reservation for the EPOLL_CTL that I
>> haven't included yet, but which has been tested. But that's easily
>> manageable, so no biggy on my end.
> 
> I didn't quite get it. Do you mean collision of opcode numbers?

Yeah that's all I meant, sorry wasn't too clear. But you can disregard,
I'll just pop a reservation in front if/when this is ready to go in if
it's before EPOLL_CTL op.

>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 57d05cc5e271..f234b13e7ed3 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -23,8 +23,14 @@ struct io_uring_sqe {
>>>  		__u64	off;	/* offset into file */
>>>  		__u64	addr2;
>>>  	};
>>> -	__u64	addr;		/* pointer to buffer or iovecs */
>>> -	__u32	len;		/* buffer size or number of iovecs */
>>> +	union {
>>> +		__u64	addr;		/* pointer to buffer or iovecs */
>>> +		__u64	off_out;
>>> +	};
>>> +	union {
>>> +		__u32	len;	/* buffer size or number of iovecs */
>>> +		__s32	fd_out;
>>> +	};
>>>  	union {
>>>  		__kernel_rwf_t	rw_flags;
>>>  		__u32		fsync_flags;
>>> @@ -37,10 +43,12 @@ struct io_uring_sqe {
>>>  		__u32		open_flags;
>>>  		__u32		statx_flags;
>>>  		__u32		fadvise_advice;
>>> +		__u32		splice_flags;
>>>  	};
>>>  	__u64	user_data;	/* data to be passed back at completion time */
>>>  	union {
>>>  		__u16	buf_index;	/* index into fixed buffers, if used */
>>> +		__u64	splice_len;
>>>  		__u64	__pad2[3];
>>>  	};
>>>  };
>>
>> Not a huge fan of this, also mean splice can't ever used fixed buffers.
>> Hmm...
> 
> But it's not like splice() ever uses user buffers. Isn't it? vmsplice
> does, but that's another opcode.

I guess that's true, I had vmsplice on my mind for this as well. But
won't be a problem there, since it doesn't take 6 arguments like splice
does.

Another option is to do an indirect for splice, stuff the arguments in a
struct that's passed in as a pointer in ->addr. A bit slower, but
probably not a huge deal.

>>> @@ -67,6 +75,9 @@ enum {
>>>  /* always go async */
>>>  #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
>>>  
>>> +/* op custom flags */
>>> +#define IOSQE_SPLICE_FIXED_OUT	(1U << 16)
>>> +
>>
>> I don't think it's unreasonable to say that if you specify
>> IOSQE_FIXED_FILE, then both are fixed. If not, then none of them are.
>> What do you think?
>>
> 
> It's plausible to register only one end for splicing, e.g. splice from
> short-lived sockets to pre-registered buffers-pipes. And it's clearer
> do it now.

You're probably right, though it's a bit nasty to add an unrelated flag
in the splice flag space... We should probably reserve it in splice
instead, and just not have it available from the regular system call.

-- 
Jens Axboe

