Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A251796F4
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 18:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgCDRrO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 12:47:14 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:38787 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729471AbgCDRrO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 12:47:14 -0500
Received: by mail-il1-f194.google.com with SMTP id f5so2562793ilq.5
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 09:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SfkBb5qeeptsN+ikqmVQfFVFhEpaHETbdvKL1xWNv0A=;
        b=LJqK/RxnNvzyKuPmMZUuM11EBRSjd9K9bP2O2+fS9Ok97bobYZG+W4h2twHVKGPaES
         d4rLoWmOFPnHVfle3IQcqrtzcePSaTImKuXVEfw4yay6xJ7l0FLWei3BAm/kE2JsaD6q
         TZaOfGqEs6s2N8f9w74ob4vzPhOFYx2JN4/ZPt1sBO74NCkfOQGmdX50MlVx/eciVf+c
         4z+NMe+g4eNKWAaJxhTr1qF2Cq5PP5IZW78pZ4/jG4YVEbqWcdQ+aGbbMlSpMUjxIplv
         hWDUp+tl3aT9tgO0daMrk4z37gVqBklijTtBGSbA+235PYpgLg0F0buGJtIOJ4kYrD1q
         OCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SfkBb5qeeptsN+ikqmVQfFVFhEpaHETbdvKL1xWNv0A=;
        b=WMJJx86Dswy/iApImvPG/vKRc/VO5kM58gg1aVL7HYT+Kw4NGeJ7ZS5ixCDiOoRSp8
         XXhzFnTe5T3TQL9R7AP2/vLtdgTRZOGa+DtWokR6m9uO28wXCMD6NO6ETfwY/ZmaGQha
         PiEEynULB230kh4xsNmFEoJrD80UY0icpAOoKUMSThQ6hYk6P/SN2W7oiI6zTnaiO8u+
         OLy3OLsWBjpv67PgVguYCGlwXzJBTSNbzmU+s9pGVPEljr949CWNHYbjw7azmeKuNTEN
         e1Psu7gLW2jXYQHme2lSxRag+ZS2XBgGtiOwr9xmbftzfshFMhHAabSD9Ckb1jZOF3D8
         cKrg==
X-Gm-Message-State: ANhLgQ3uEfohMPuNp9XfaZ3eWqbaEW6JwCF7SL3Up6dE8N/4AMTJPybR
        bxSVmKnIfplcvzt/JHYznno4LA==
X-Google-Smtp-Source: ADFU+vth8Sg1hIIn3bKfJzTOmIScoxuCbJgCThWc4b+YP3szikYmIDLF3ncM7ysH/n5XjhcsibUugw==
X-Received: by 2002:a92:c7a4:: with SMTP id f4mr3710694ilk.122.1583344033665;
        Wed, 04 Mar 2020 09:47:13 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z25sm6662051iod.50.2020.03.04.09.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 09:47:13 -0800 (PST)
Subject: Re: [PATCH 2/4] io_uring: move CLOSE req->file checking into handler
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     jlayton@kernel.org
References: <20200303235053.16309-1-axboe@kernel.dk>
 <20200303235053.16309-3-axboe@kernel.dk>
 <a90767a7-f930-8e0c-b816-b4eb90452c58@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0cfff308-4e68-d0fd-f427-2c246a936da1@kernel.dk>
Date:   Wed, 4 Mar 2020 10:47:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a90767a7-f930-8e0c-b816-b4eb90452c58@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/20 6:07 AM, Pavel Begunkov wrote:
> On 04/03/2020 02:50, Jens Axboe wrote:
>> In preparation for not needing req->file in on the prep side at all.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 0464efbeba25..9d5e49a39dba 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -3367,10 +3367,6 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  		return -EBADF;
>>  
>>  	req->close.fd = READ_ONCE(sqe->fd);
>> -	if (req->file->f_op == &io_uring_fops ||
>> -	    req->close.fd == req->ctx->ring_fd)
>> -		return -EBADF;
>> -
>>  	return 0;
>>  }
>>  
>> @@ -3400,6 +3396,10 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
>>  {
>>  	int ret;
>>  
>> +	if (req->file->f_op == &io_uring_fops ||
>> +	    req->close.fd == req->ctx->ring_fd)
>> +		return -EBADF;
>> +
> 
> @ring_fd's and @ring_file's lifetimes are bound by call to io_submit_sqes(), and
> they're undefined outside. For the same reason both of them should be used with
> ctx->uring_lock hold.

I've fixed this by splitting the check.


-- 
Jens Axboe

