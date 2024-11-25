Return-Path: <io-uring+bounces-5039-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE759D8892
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 15:57:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD2E9282BE8
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 14:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A1F1B218A;
	Mon, 25 Nov 2024 14:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fXb67NMm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295631B0F30;
	Mon, 25 Nov 2024 14:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732546656; cv=none; b=gyj7zhLR+P9lTsb0yYcpjguvUSn473iUJRi8m9jWvnVLZodxibb5Rvm51D2G9EsbQDM9Z3XvuHnjrTnbgge52500Vbs6qsAMX2UdLwunntygqIXJdlgCIxfBI/RvBg/9YFWWjsWv23xVP/05dLbmUobKv+g0TuGl1bHOLmBpBds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732546656; c=relaxed/simple;
	bh=pKNluBWP/OdjdtjZRI6OsprT85cpi/zCHYe2a9DKN2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BKixeC9OO09I5xL+BCQRDupSu5n1FUpOfNFi45QFxpN320ucnaO/gDN1DOR193o4gKe23GogLwxfFMGpAjHqLx0DMQt3XkGRpgwVcuHE1opK4hnTK1szekQ43RDfcudPHFgr6aXiDeM1pbB1Qx0T3lu3FNc3vDa4bTXacJxXBLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fXb67NMm; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aa545dc7105so242026166b.3;
        Mon, 25 Nov 2024 06:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732546652; x=1733151452; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mwycz/MiAZLiFKmS9hGPG2W/0xImNpvKNhmHBM//itM=;
        b=fXb67NMm8haEGFgVopgyzguNDr8TnnglrBuzDpKocu33i3pGYfIXur55aDOyxBJpwo
         e1NJJoWny4hegrVz2kHBC9svlxjwuSu8f8PdzOFzpjDWM0eeKoxkMj6KCirMeLZwxdK4
         Kj1hRuqoQLyKj0pj0MG4op7SgnHW8meNQpCyQpCpqOtoRW5T0Qjv/bjNLjUtKK01ECHX
         8/6XVxwLHARrU1jhizvg72/FqUDjPRpRYjxnjqCpB90cyB4If2kZZQEbROtc7KQrIG1y
         GuN3yVIboG7tw/kP+yOvXJEQyF/2Wc/0Qr0hx+P28iWjNmQ/SLTmQIhjRXqIewXIebbR
         K7Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732546652; x=1733151452;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mwycz/MiAZLiFKmS9hGPG2W/0xImNpvKNhmHBM//itM=;
        b=Lc7L9ZY7qTEek4eNu3vsfW/NbZgDWqthJyN8TKW9oW0ztG1DkUQG0/MgH2L+9lh4Xe
         Q8EjDY+dboVa6YLA1DyxnW1TJrRpXqeXwiXKLt1tHoTwTHv6gmow6wgovwHDfL2qlszH
         hkedTjG462n2tJ5Z4WvF4s9l3aLZDWRnqXpdnDOV3q8CbVllqmPF3ZdtfIifBVozcY9u
         +IYAmpJA7/h8xqsHrFtxgyHWulxT4LYWCOA0iliEr6FfH/MEEPx1EeCi3YqgX+UwDiVb
         OgwvmMNcuWKmvBKveTv9harbjQLGGOhNIOTTEHROpqdoAUNyjTfWgLxCwvOAtrb83bhe
         MvwA==
X-Forwarded-Encrypted: i=1; AJvYcCVObs41tu51Pc3oDQBsKqnA+tRhVjgtSUa4oWo9y7wK7q38Mcdh0nI/yuBxF5Ce2uJbHnu8KxP4aLLw9A==@vger.kernel.org, AJvYcCWGnb2S1Ranf4jFsuG8arZlD10Sg1er3v+iy/BbBDMCxVVjojTJJaLwqWUyIguL1YKeZhKHwlFnhPfG5DYBPA==@vger.kernel.org, AJvYcCXWgPSmoBUisOy1ggs4K3zs3UWfidRETdF+ihIXT8+pApHHR82G3vAUYscvG5s3OEDvV2UY58sqvy+LgQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzVCUVZ9W2+7aKwK8xQhBGr9PddWSC0yQZ3sRhzXbk6O63huhIP
	8x0XzumwKI0aCm1cIvzyWQcVXLYXTTSsivBUcW7fWjF6x+csWDV1
X-Gm-Gg: ASbGncvWflhKapIN+gf0mM1eVypMUHmu1yLp/LRg+M46HqxGUFf3OgKU4Q9AVTDPjmw
	eIThweOHar0+TE1BwL0utvu+uTvp4qVMhyc6yr7B+v8qA/6eu2ZPJl25kDX6VzwGSci0cxi0oI1
	AKGmYhZBGJOKBr9rC4mFaagXZRHD6UOj3cWXl0mL3c5groiWU6GuqJ3s7xTsoBxJ5mRKY9VyNNs
	z9RRtHAReHKW+/W6Zcz1HO58beOh+a3ppw46K18DbUUxzuB1ovDjrrzUtrmOw==
X-Google-Smtp-Source: AGHT+IEzNyoWXmldDRbK4hugvlNPC35UUFsvEms5CLemQoA8167zZU/Ipeyzrkp+FtvQyJR2Aj95nA==
X-Received: by 2002:a17:906:3194:b0:aa5:28af:f0e with SMTP id a640c23a62f3a-aa528af0f4amr1066397166b.15.1732546651154;
        Mon, 25 Nov 2024 06:57:31 -0800 (PST)
Received: from [192.168.42.132] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b52fd20sm473799366b.111.2024.11.25.06.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 06:57:30 -0800 (PST)
Message-ID: <a28b46a0-9eb5-45db-80ec-93fdc0eec35e@gmail.com>
Date: Mon, 25 Nov 2024 14:58:19 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/10] io_uring: introduce attributes for read/write
 and PI support
To: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de,
 kbusch@kernel.org, martin.petersen@oracle.com, anuj1072538@gmail.com,
 brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, gost.dev@samsung.com,
 linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241125070633.8042-1-anuj20.g@samsung.com>
 <CGME20241125071502epcas5p46c373574219a958b565f20732797893f@epcas5p4.samsung.com>
 <20241125070633.8042-7-anuj20.g@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241125070633.8042-7-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/24 07:06, Anuj Gupta wrote:
> Add the ability to pass additional attributes along with read/write.
> Application can populate attribute type and attibute specific information
> in 'struct io_uring_attr' and pass its address using the SQE field:
> 	__u64	attr_ptr;
> 
> Along with setting a mask indicating attributes being passed:
> 	__u64	attr_type_mask;
> 
> Overall 64 attributes are allowed and currently one attribute
> 'ATTR_TYPE_PI' is supported.
> 
> With PI attribute, userspace can pass following information:
> - flags: integrity check flags IO_INTEGRITY_CHK_{GUARD/APPTAG/REFTAG}
> - len: length of PI/metadata buffer
> - addr: address of metadata buffer
> - seed: seed value for reftag remapping
> - app_tag: application defined 16b value

The API and io_uring parts look good, I'll ask to address the
ATTR_TYPE comment below, the rest are nits, which that can be
ignored and/or delayed.

> Process this information to prepare uio_meta_descriptor and pass it down
> using kiocb->private.

I'm not sure using ->private is a good thing, but I assume it
was discussed, so I'll leave it to Jens and other folks.


> PI attribute is supported only for direct IO.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>   include/uapi/linux/io_uring.h | 31 +++++++++++++
>   io_uring/io_uring.c           |  2 +
>   io_uring/rw.c                 | 82 ++++++++++++++++++++++++++++++++++-
>   io_uring/rw.h                 | 14 +++++-
>   4 files changed, 126 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index aac9a4f8fa9a..bf28d49583ad 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -98,6 +98,10 @@ struct io_uring_sqe {
>   			__u64	addr3;
>   			__u64	__pad2[1];
>   		};
> +		struct {
> +			__u64	attr_ptr; /* pointer to attribute information */
> +			__u64	attr_type_mask; /* bit mask of attributes */
> +		};
>   		__u64	optval;
>   		/*
>   		 * If the ring is initialized with IORING_SETUP_SQE128, then
> @@ -107,6 +111,33 @@ struct io_uring_sqe {
>   	};
>   };
>   
> +
> +/* Attributes to be passed with read/write */
> +enum io_uring_attr_type {
> +	ATTR_TYPE_PI,
> +	/* max supported attributes */
> +	ATTR_TYPE_LAST = 64,

ATTR_TYPE sounds too generic, too easy to get a symbol collision
including with user space code.

Some options: IORING_ATTR_TYPE_PI, IORING_RW_ATTR_TYPE_PI.
If it's not supposed to be io_uring specific can be
IO_RW_ATTR_TYPE_PI

> +};
> +
> +/* sqe->attr_type_mask flags */
> +#define ATTR_FLAG_PI	(1U << ATTR_TYPE_PI)
> +/* PI attribute information */
> +struct io_uring_attr_pi {
> +		__u16	flags;
> +		__u16	app_tag;
> +		__u32	len;
> +		__u64	addr;
> +		__u64	seed;
> +		__u64	rsvd;
> +};
> +
> +/* attribute information along with type */
> +struct io_uring_attr {
> +	enum io_uring_attr_type	attr_type;

I'm not against it, but adding a type field to each attribute is not
strictly needed, you can already derive where each attr placed purely
from the mask. Are there some upsides? But again I'm not against it.

> +	/* type specific struct here */
> +	struct io_uring_attr_pi	pi;
> +};
> +
>   /*
>    * If sqe->file_index is set to this for opcodes that instantiate a new
>    * direct descriptor (like openat/openat2/accept), then io_uring will allocate
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index c3a7d0197636..02291ea679fb 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3889,6 +3889,8 @@ static int __init io_uring_init(void)
>   	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
>   	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
>   	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
> +	BUILD_BUG_SQE_ELEM(48, __u64, attr_ptr);
> +	BUILD_BUG_SQE_ELEM(56, __u64, attr_type_mask);
>   	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
>   
>   	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 0bcb83e4ce3c..71bfb74fef96 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -257,11 +257,54 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
>   	return 0;
>   }
...
> @@ -902,6 +976,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>   	 * manually if we need to.
>   	 */
>   	iov_iter_restore(&io->iter, &io->iter_state);
> +	if (kiocb->ki_flags & IOCB_HAS_METADATA)
> +		io_meta_restore(io);

That can be turned into a helper, but that can be done as a follow up.

I'd also add a IOCB_HAS_METADATA into or around of
io_rw_should_retry(). You're relying on O_DIRECT checks, but that
sounds a bit fragile in the long run.

-- 
Pavel Begunkov

