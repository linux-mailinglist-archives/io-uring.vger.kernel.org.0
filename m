Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723231616EB
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 17:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgBQQDC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Feb 2020 11:03:02 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33253 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbgBQQDC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Feb 2020 11:03:02 -0500
Received: by mail-lj1-f194.google.com with SMTP id y6so19468399lji.0
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2020 08:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Pxna5Y/jp+pZ9xO5WxdGAg1TDQP79Zlw51RQbeEEaKA=;
        b=k83nK0jb/IhsfgsTGBez28XbV65Rjley80LUhCIi+VNMToIUk8LxZJzfKs+ReTfzX/
         +MrQRQMUquutqXN7sByFpyYiza7kc50Bo10xm9Cy1RmksO2Cr3ZyCfQHU0+WBgbYI5PK
         2JzGSRwXzx9wGJ4zuzPNTSrPGhPDPWaK7quME6k3goeC55GXtYedcxhpqg2L8qkP39bI
         W1o+rE7Z8OgEOzV/ZFmQxv4fm/gNatIaU3CH5da9B+wK4hj+nFLAWxvRO7s7Xxm33/Fm
         AViVJkGNh42fbWT1hwgbmqOhDOxur6YrwXiN8k/G0lCXKpqEDxEqex7yFFQT2sJzKG2w
         qxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pxna5Y/jp+pZ9xO5WxdGAg1TDQP79Zlw51RQbeEEaKA=;
        b=Zh9Pm9+oGFnJG1Bya1sEoaEbA91xCu4gPdZjgfTOO4M3BhXJMX/ZgVpO25RPJcKfFD
         PCWoWX1GVzDemas1ZgM732RAwHk9TeN12PDYGi/MRutURLm7rwiM1ZgD63qTOVvz079Y
         FRtsI6Os7accXy9zhxvcK7w3F5dcKU69zrHKjDG8jX/BA9/O5PhprsMcF+DNlx8fFDko
         vm9vS/5Dj/SzCejd62RmIkUoeUdSE13sz1iisdFTOxfeW2ZYFbrKQP1o9eIxQD9stXsL
         Vqjg2Fs3Rg/T3aXhobu/9A6PzuICbtl5+0KD+UXGWb8ZCojpfUqa4B5yxcrNnDjFIXJ8
         pSUg==
X-Gm-Message-State: APjAAAV04kWk2fs5u6wqzwyfQiTFykvuAjIj1Bw6mw0+7j2hYHLFM+l2
        O+ifaFj6hIGGWMV2kc69stYGSemLBog=
X-Google-Smtp-Source: APXvYqw9Z1sQ2wPkB0TR7qIhKxqH8Q9kC6Su0lYtxh/AJwn9m1VApwpoYbx7JeN5KsysP97ocjxsRA==
X-Received: by 2002:a2e:9284:: with SMTP id d4mr10056538ljh.226.1581955380451;
        Mon, 17 Feb 2020 08:03:00 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id f8sm582458lfc.22.2020.02.17.08.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 08:02:59 -0800 (PST)
Subject: Re: [PATCH v2 1/2] splice: add splice(2) helpers
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1581851604.git.asml.silence@gmail.com>
 <a49db514f8b0b7d509c50ed0185688ece5830363.1581851604.git.asml.silence@gmail.com>
 <c1d203e2-a31a-2e61-fc2f-4b144209e0cc@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <969924a5-2bdb-1228-1ff9-ed3e814cb1e7@gmail.com>
Date:   Mon, 17 Feb 2020 19:02:58 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c1d203e2-a31a-2e61-fc2f-4b144209e0cc@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/17/2020 6:48 PM, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>> diff --git a/src/include/liburing.h b/src/include/liburing.h
>> index 8ca6cd9..9ff2a54 100644
>> --- a/src/include/liburing.h
>> +++ b/src/include/liburing.h
>> @@ -191,6 +191,17 @@ static inline void io_uring_prep_rw(int op, struct io_uring_sqe *sqe, int fd,
>>  	sqe->__pad2[0] = sqe->__pad2[1] = sqe->__pad2[2] = 0;
>>  }
>>  
>> +static inline void io_uring_prep_splice(struct io_uring_sqe *sqe,
>> +					int fd_in, loff_t off_in,
>> +					int fd_out, loff_t off_out,
>> +					unsigned int nbytes, int splice_flags)
>> +{
> 
> The splice() syscall takes 'size_t len' and 'unsigned int flags',

sqe->len is u32, so can't fit size_t there, it was discussed before.

> I think we should at least change this to 'unsigned int splice_flags'.
> 

Good point, for the comments below as well. I'll resend.

>> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
>> index 424fb4b..dc78697 100644
>> --- a/src/include/liburing/io_uring.h
>> +++ b/src/include/liburing/io_uring.h
>> @@ -23,7 +23,10 @@ struct io_uring_sqe {
>>  		__u64	off;	/* offset into file */
>>  		__u64	addr2;
>>  	};
>> -	__u64	addr;		/* pointer to buffer or iovecs */
>> +	union {
>> +		__u64	addr;	/* pointer to buffer or iovecs */
>> +		__u64	off_in;
>> +	};
>>  	__u32	len;		/* buffer size or number of iovecs */
>>  	union {
>>  		__kernel_rwf_t	rw_flags;
>> @@ -37,6 +40,7 @@ struct io_uring_sqe {
>>  		__u32		open_flags;
>>  		__u32		statx_flags;
>>  		__u32		fadvise_advice;
>> +		__u32		splice_flags;
>>  	};
>>  	__u64	user_data;	/* data to be passed back at completion time */
>>  	union {
>> @@ -45,6 +49,7 @@ struct io_uring_sqe {
>>  			__u16	buf_index;
>>  			/* personality to use, if used */
>>  			__u16	personality;
>> +			__u32	splice_fd_in;
> 
> Shouldn't this be __s32 in order to match "__s32 fd"?
> 
>>  		};
> 
> Can you please add BUILD_BUG_SQE_ELEM() checks for the new elements
> in io_uring_init()?
> 
> Thanks!
> metze
> 

-- 
Pavel Begunkov
