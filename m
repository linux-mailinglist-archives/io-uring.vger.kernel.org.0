Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507972F931A
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 15:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbhAQOyI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jan 2021 09:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbhAQOyF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jan 2021 09:54:05 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6F7C061574
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 06:53:25 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id o20so250690pfu.0
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 06:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=a/jBgkSl7+0XaQYfFihllXtioSGJxfHHGxejCyuNnHc=;
        b=E8WaJVJ5XmoX6lRotfyxRL1jZL7QKFuCH5R07NOXQz9W/QAPiLTdL3DlZmYV424dV6
         rIzRZc7RJIIvFMNvc+7mXBoZYNl2uxqOqNPQXQ2XOsTWee3U5GfCdvVKwMgPL7i/+iud
         UXcZ26+DouBp/H4rvGA1WZvGQkqGBHmOYOl8Smy63dAHMrgFvVp8ONiDFHSkHQ5rG2tA
         F64XhzJdiyAxF6mlhcm6KdWykOgOhAE2guKZQhmed55uhQdGNrWTPBp43Yq5BQF6OU2z
         MaPUpr/t3zV5GVyk3SgH0MYjVs2UB1FIJkh54dP1pi4efyB0Q0Y5uT01iQtHijKd+JCD
         +QXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a/jBgkSl7+0XaQYfFihllXtioSGJxfHHGxejCyuNnHc=;
        b=iEkaJ2W2CHwHkRMLfczX9ic8MJoYZOty4oXq4Ww6QiyXktlnJmuNZgzNfuZf/LDhln
         LanPJZNhrH7IJpFrwcFzNHlMJLLYHfBKSQSSVGOL62wl3XBnb0X7bEFAp8Z8YsZkP6py
         Pftk4AwcKgWmjmzipMYCKf3dH/FTNBOAdYyrz6Z6vshDwmTMrwyX9fpA/wcuq4jhrAkf
         3aOP4VoCj4iwvoa/mrVH3yzrml2tnPEk6W7iN5pzHSO2xXFltaMY5LTDIfkneJVBgdXE
         6yE6jp85wmvHBswSagt02DfDkpc1jKiw8T/S+JCd0jDY0oIVTmxjlZhk8ECUW//slhVZ
         h4BA==
X-Gm-Message-State: AOAM533Vr2qqwswerEHs6G+cx9fcajnQhZ4PhQZ5kHDNlruzzZLjh1la
        wDMRqynpU9PKvWhmYrprwWcRzVh23p3FcQ==
X-Google-Smtp-Source: ABdhPJzr4Y6DnVXW42ZZx5u+AYcPY5Jk+ODuRM4eo6s530d5tQhtV0ZcUHyZi7wfM3Ia7QM1MbADsg==
X-Received: by 2002:a63:5d7:: with SMTP id 206mr22489999pgf.384.1610895204680;
        Sun, 17 Jan 2021 06:53:24 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id p15sm13636770pgl.19.2021.01.17.06.53.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 06:53:24 -0800 (PST)
Subject: Re: [PATCH] io_uring: cancel all requests on task exit
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <4d22e80b-0767-3e14-fc13-5eca9b1816fc@kernel.dk>
 <c41079a5-5f5f-ac58-e01d-792e4f007611@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4388f246-617a-c95a-e2d4-b9b34ad20768@kernel.dk>
Date:   Sun, 17 Jan 2021 07:53:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c41079a5-5f5f-ac58-e01d-792e4f007611@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/17/21 3:52 AM, Pavel Begunkov wrote:
> On 17/01/2021 04:04, Jens Axboe wrote:
>> We used to have task exit tied to canceling files_struct ownership, but we
>> really should just simplify this and cancel any request that the task has
>> pending when it exits. Instead of handling files ownership specially, we
>> do the same regardless of request type.
>>
>> This can be further simplified in the next major kernel release, unifying
>> how we cancel across exec and exit.
> 
> Looks good in general. See a comment below, but otherwise
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> btw, I wonder if we can incite syzbot to try to break it.
> 
>>
>> Cc: stable@vger.kernel.org # 5.9+
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 383ff6ed3734..1190296fc95f 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -9029,7 +9029,7 @@ static void io_uring_remove_task_files(struct io_uring_task *tctx)
>>  		io_uring_del_task_file(file);
>>  }
>>  
>> -void __io_uring_files_cancel(struct files_struct *files)
>> +static void __io_uring_files_cancel(void)
>>  {
>>  	struct io_uring_task *tctx = current->io_uring;
>>  	struct file *file;
>> @@ -9038,11 +9038,10 @@ void __io_uring_files_cancel(struct files_struct *files)
>>  	/* make sure overflow events are dropped */
>>  	atomic_inc(&tctx->in_idle);
>>  	xa_for_each(&tctx->xa, index, file)
>> -		io_uring_cancel_task_requests(file->private_data, files);
>> +		io_uring_cancel_task_requests(file->private_data, NULL);
>>  	atomic_dec(&tctx->in_idle);
>>  
>> -	if (files)
>> -		io_uring_remove_task_files(tctx);
>> +	io_uring_remove_task_files(tctx);
> 
> This restricts cancellations to only one iteration. Just delete it,
> __io_uring_task_cancel() calls it already.

Ah indeed, makes it even better. I removed it, thanks.

-- 
Jens Axboe

