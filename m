Return-Path: <io-uring+bounces-435-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C96A8334F5
	for <lists+io-uring@lfdr.de>; Sat, 20 Jan 2024 15:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D92B228294D
	for <lists+io-uring@lfdr.de>; Sat, 20 Jan 2024 14:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5284AFBF3;
	Sat, 20 Jan 2024 14:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M08P381Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA603D262;
	Sat, 20 Jan 2024 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705759770; cv=none; b=uKKKQIa/XPFceY+4bpUowyGzFmPeYKG9Vzt4BgfQYxCjQmCqWcfqlzeycPWJRtxeiXWrJYBGpisUPoICgCXymaNTftrdL7r5BwJe0mrAbix0//lnIJVmTbRIMJAf3ELx9C5hSCBtHEiiGwgc8xh7SEbi0syZ/FwdxQdCtl/MnYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705759770; c=relaxed/simple;
	bh=CID8wslCSPlIu7z6Sspwr6XnulZg3T/quj323AKPIwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d/N1B78jhgYEj10ues5T8B9xfG/0qhSOomawoKHLuKbjrsieRENX6bVPZlOPerUaLrBVp/LM5IuA4khf98l1LZF1M+XAZmdp+WycFyY+RNKAo4W1MBaMlxWIA6mup5Ra62IOw1vOhaZe9heF4baxsSS5ZWEQOA1BewdH6A/YUGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M08P381Z; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6d9344f30caso1162651b3a.1;
        Sat, 20 Jan 2024 06:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705759768; x=1706364568; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H5wYT7HPbgBxM6i7zSXIWjWAG+fcTAGm1HNEEhELniM=;
        b=M08P381ZaEuJf2F12OQzRhV02Fe690qJeGOyZ+z+9CLHs2gi0BSHuHF3bl1Hx9zaE/
         7HmM7LoPO4u9HZKEyC4uUbISNGrTzu/UpJzIMXyuekKI8Ob9xu+HSuVC99Sny9FHUO/J
         5aSXm2hZNFbjjcQB2K0wUFSxD5bVGCRfuJ5PsymSVVSZg2SeRP7l5k/JbNwBJw/7bm4C
         gUpQ0XNnqTsUVoKczBYzgJkVbF234ANZLt6+kjYL3ktMHllReaBBJfRC3wb6eP1+5qX3
         mdEN4oe76NV8CizwAI8Vpo9IczxgGDeqN3qz+i99Ok36lBRfVRSXeWpPpN/L4RBtvu/K
         ulXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705759768; x=1706364568;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H5wYT7HPbgBxM6i7zSXIWjWAG+fcTAGm1HNEEhELniM=;
        b=Lm0MXLtuYzjinHdxKw8CsNpbIomrbPR/r3YYzYER/l1P9aoixl1aKralVoYX+Muqc7
         3R/VNt67LMze8dEKxtfZybplNw5kWkn7P9VepOPMDSpKQplHUk+3ug5t3QCv1zRLdBk1
         iaRpzfVG5qAlMzs3MKTKqYYpHOhknWAtJ0ItK8jN/jLL5I0dyuutGFLaQYYrxTpQns1R
         VoAUwvDKXlGxpUfHQHWuoxbolXO6rzM8NjcEIJkPSLgQzqCbyo4TauMFWCjoQiHxXyOS
         NhX3vQVeq62jkGLEqGTEBf1P+rsL8DMmh0DpetqIfMn79xaBxCgsYxY5J0L/iNT9jQKp
         gDYg==
X-Gm-Message-State: AOJu0YwJTfKhGEYROkQai5SharSDEcHlRTrnWnDOEM+tEG4EsbLSty7l
	tgWH/Ph4Nm26z93O2sJUULBImAqLyi4oCHaoWSeyD/KcT2AYq5uR
X-Google-Smtp-Source: AGHT+IF3iooWOHj5qeipqQXH1fQ2YSoN02nJYAzupIgGCKmSIjawUndbGtjyG9yUzbrqynVbCBJ7Ng==
X-Received: by 2002:a05:6a00:170c:b0:6d9:a856:eec2 with SMTP id h12-20020a056a00170c00b006d9a856eec2mr1847379pfc.14.1705759768062;
        Sat, 20 Jan 2024 06:09:28 -0800 (PST)
Received: from ?IPV6:2406:7400:94:dd16:106d:864:6ca4:72b7? ([2406:7400:94:dd16:106d:864:6ca4:72b7])
        by smtp.gmail.com with ESMTPSA id m6-20020a62f206000000b006dbd1678512sm991139pfh.162.2024.01.20.06.09.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jan 2024 06:09:27 -0800 (PST)
Message-ID: <37ed354a-6b69-4e24-9557-5ca62179b76a@gmail.com>
Date: Sat, 20 Jan 2024 19:39:22 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iouring:added boundary value check for io_uring_group
 systl
Content-Language: en-US
To: Jeff Moyer <jmoyer@redhat.com>
Cc: corbet@lwn.net, axboe@kernel.dk, asml.silence@gmail.com,
 ribalda@chromium.org, rostedt@goodmis.org, bhe@redhat.com,
 akpm@linux-foundation.org, matteorizzo@google.com, ardb@kernel.org,
 alexghiti@rivosinc.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20240115124925.1735-1-subramanya.swamy.linux@gmail.com>
 <x49edeh5fyy.fsf@segfault.usersys.redhat.com>
From: Subramanya Swamy <subramanya.swamy.linux@gmail.com>
In-Reply-To: <x49edeh5fyy.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Jeff,

            Thank you for reviewing the patch.

On 16/01/24 23:16, Jeff Moyer wrote:
> Subramanya Swamy <subramanya.swamy.linux@gmail.com> writes:
>
>> /proc/sys/kernel/io_uring_group takes gid as input
>> added boundary value check to accept gid in range of
>> 0<=gid<=4294967294 & Documentation is updated for same
> Thanks for the patch.  You're right, the current code artificially
> limits the maximum group id.
>
>> Signed-off-by: Subramanya Swamy <subramanya.swamy.linux@gmail.com>
>> ---
>>   Documentation/admin-guide/sysctl/kernel.rst | 9 ++++-----
>>   io_uring/io_uring.c                         | 8 ++++++--
>>   2 files changed, 10 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
>> index 6584a1f9bfe3..3f96007aa971 100644
>> --- a/Documentation/admin-guide/sysctl/kernel.rst
>> +++ b/Documentation/admin-guide/sysctl/kernel.rst
>> @@ -469,11 +469,10 @@ shrinks the kernel's attack surface.
>>   io_uring_group
>>   ==============
>>   
>> -When io_uring_disabled is set to 1, a process must either be
>> -privileged (CAP_SYS_ADMIN) or be in the io_uring_group group in order
>> -to create an io_uring instance.  If io_uring_group is set to -1 (the
>> -default), only processes with the CAP_SYS_ADMIN capability may create
>> -io_uring instances.
>> +When io_uring_disabled is set to 1, only processes with the
>> +CAP_SYS_ADMIN may create io_uring instances or process must be in the
>> +io_uring_group group in order to create an io_uring_instance.
>> +io_uring_group is set to 0.This is the default setting.
> You are changing the default from an invalid group to the root group.  I
> guess that's ok, but I'd rather keep it the way it is.  The text is a
> bit repetitive.  Why not just this?
>
> "When io_uring_disabled is set to 1, a process must either be
>   privileged (CAP_SYS_ADMIN) or be in the io_uring_group group in order
>   to create an io_uring instance."

Yes this looks neat , will add in v2

>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 09b6d860deba..0ed91b69643d 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -146,7 +146,9 @@ static void io_queue_sqe(struct io_kiocb *req);
>>   struct kmem_cache *req_cachep;
>>   
>>   static int __read_mostly sysctl_io_uring_disabled;
>> -static int __read_mostly sysctl_io_uring_group = -1;
>> +static unsigned int __read_mostly sysctl_io_uring_group;
>> +static unsigned int min_gid;
>> +static unsigned int max_gid  = 4294967294;  /*4294967294 is the max guid*/
> Right, INVALID_GID is -1.
>
>>   #ifdef CONFIG_SYSCTL
>>   static struct ctl_table kernel_io_uring_disabled_table[] = {
>> @@ -164,7 +166,9 @@ static struct ctl_table kernel_io_uring_disabled_table[] = {
>>   		.data		= &sysctl_io_uring_group,
>>   		.maxlen		= sizeof(gid_t),
>>   		.mode		= 0644,
>> -		.proc_handler	= proc_dointvec,
>> +		.proc_handler	= proc_douintvec_minmax,
>> +		.extra1         = &min_gid,
> This should be SYSCTL_ZERO.

will change this to SYSCTL_ZERO in v2

>> +		.extra2         = &max_gid,
>>   	},
>>   	{},
>>   };
> Thanks!
> Jeff
>
-- 
Best Regards
Subramanya


