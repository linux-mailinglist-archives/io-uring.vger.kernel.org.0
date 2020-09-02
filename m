Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEEF25B1BB
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 18:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgIBQcS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 12:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBQcR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 12:32:17 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E151AC061244
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 09:32:16 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t16so124413ilf.13
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 09:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GWdR0aYz+z8aFkum9BlggaA64WDq0D5xoiDTmi/KLuI=;
        b=bLFybFOGbsrCt7TT3HvdkJLfCxM0Jto9825xF+5QfDLVxXcwjIoGmgmpMflZpPW2la
         bcJNT8FCC/ggwmGsl5Dqp2E0F+j5vSdO6L4S7uu/nJFKfLNBa5jrB/ys/dVJu7xa8PTR
         tiANJI/JECUCnqJlTY8Zsy/hJIvVZ4GajIuBUefBvyxj3Bxb7KSTprruYImQTt9fGBhf
         0hqzqd0Dp/bNfs8GnP2ljp81iold5fT4SxWEuIwxQ2znmtO3wpdeQmePb6nRD3GHv4cW
         P1hLrW63HPjpyFBgZ/SgcrXQ0DV8b3+jSbMuP5Rwr3VKglb/2BOjq6+sTf+nO9raMlRP
         IV7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GWdR0aYz+z8aFkum9BlggaA64WDq0D5xoiDTmi/KLuI=;
        b=Q6fd7zJYGKjPMEni3i7Ap92hY18XN4cCa2hKG+jKbBG8GYpm0Zf0yJ/rycBhLhSWBB
         nOVGrU8S85LdX9csEv7bdFP9ohaEtaoxVadMyqWyPOFmgM6tM8KrNAdelsyro2zYAJek
         lVyMTYcZYhFtI6lG9rrJmBKZmlPPrD6LwpHoFbM3HXroxPqf6J4KT9EJlQGsSDsOfoV9
         DNgdjYhoILbSUtxZuJtOR2RVD2TWE3BoonH61RC7Cpv2VwZjp4X01DiH5J35mekkkNAh
         UcaHlzK7CM8qTCL7Ci+Xa8bdvIJv8ra5Fhh4CS2QWmO+YYP60nVMl/NPU+jjpmomzXQS
         Rsjw==
X-Gm-Message-State: AOAM5320u/eHe71vDZ0uzXMUxDHk5BdvL6NbeGm+yjZQix7EITKa7sQX
        IdEB4qOSRaUxk40dMVWkeGR/iQ==
X-Google-Smtp-Source: ABdhPJyJHPIMlzxUAVHSfApjEmFZ2ILhFBjBQ1HGgBU8ROu1logmDvDUbv1Btkdj1/Scc2niPcaEdw==
X-Received: by 2002:a92:4f:: with SMTP id 76mr4207502ila.11.1599064336115;
        Wed, 02 Sep 2020 09:32:16 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u25sm21312iot.35.2020.09.02.09.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 09:32:15 -0700 (PDT)
Subject: Re: [PATCH] io_uring: no read-retry on -EAGAIN error and O_NONBLOCK
 marked file
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Norman Maurer <norman.maurer@googlemail.com>
References: <5d91a8ea-5748-803a-d2dc-ef21fe27e39e@kernel.dk>
 <cdc949ce-059b-2f4f-bb16-f4e9554eb975@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a749b272-aea3-e030-1aa6-afaf6dde33fb@kernel.dk>
Date:   Wed, 2 Sep 2020 10:32:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cdc949ce-059b-2f4f-bb16-f4e9554eb975@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/20 10:09 AM, Pavel Begunkov wrote:
> On 02/09/2020 19:00, Jens Axboe wrote:
>>     Actually two things that need fixing up here:
>>     
>>     - The io_rw_reissue() -EAGAIN retry is explicit to block devices and
>>       regular files, so don't ever attempt to do that on other types of
>>       files.
>>     
>>     - If we hit -EAGAIN on a nonblock marked file, don't arm poll handler for
>>       it. It should just complete with -EAGAIN.
>>     
>>     Cc: stable@vger.kernel.org
>>     Reported-by: Norman Maurer <norman.maurer@googlemail.com>
>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index b1ccd7072d93..65656102bbeb 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2300,8 +2300,11 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
>>  static bool io_rw_reissue(struct io_kiocb *req, long res)
>>  {
>>  #ifdef CONFIG_BLOCK
>> +	umode_t mode = file_inode(req->file)->i_mode;
>>  	int ret;
>>  
>> +	if (!S_ISBLK(mode) && !S_ISREG(mode))
>> +		return false;
>>  	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
>>  		return false;
>>  
>> @@ -3146,6 +3149,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>>  		/* IOPOLL retry should happen for io-wq threads */
>>  		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
>>  			goto done;
>> +		/* no retry on NONBLOCK marked file */
>> +		if (req->file->f_flags & O_NONBLOCK)
>> +			goto done;
> 
> Looks like it works with open(O_NONBLOCK) but not with IOCB_NOWAIT in the
> request's flags. Is that so?

The IOCB_NOWAIT case should already be fine, it's just the O_NONBLOCK that
isn't covered. IOCB_NOWAIT on a socket unhelpfully fails anyway, since
FMODE_NOWAIT isn't available. Arguably something that should be fixed
separately.

-- 
Jens Axboe

