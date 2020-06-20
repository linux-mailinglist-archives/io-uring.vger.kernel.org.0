Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED0A202315
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2020 12:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgFTKA6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Jun 2020 06:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgFTKAz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Jun 2020 06:00:55 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C63C06174E
        for <io-uring@vger.kernel.org>; Sat, 20 Jun 2020 03:00:54 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id k8so9720682edq.4
        for <io-uring@vger.kernel.org>; Sat, 20 Jun 2020 03:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F0HdPqrMdF3Gok7sQbbI3fnLtHBZRXQmLuLHl7eHfQI=;
        b=ZF3J5gqXtSpsTojQfft/z7M4JHwB2TlAumAR5IXV+KHAy+HasGTZPxt8DIBf9geJhs
         D75IHxMg/Q1FgXusTRXlXfDTKQbTHHF9argmflK1P5xfKtT8ILsDaEwuJBnkuQrxRxhf
         1g0smtdKQzFJFaFKJ95I6c2m3REMdLzwgxHxuH2AamHdj8rm5TUlWAgm6LG2N5gAAMZP
         75n6brtiuHsDYyuZajS/L0FdmmKZZR/or7+RC/ZJ2GmcahW8yw/lV+hxM/oxJaavCV+0
         SmdJpujSHb5Ep2i1GI81RfUugA1GT2xst8ABLktplh10ouaKQaYzaX0+YgTYwvlvyiCf
         2pnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=F0HdPqrMdF3Gok7sQbbI3fnLtHBZRXQmLuLHl7eHfQI=;
        b=LpSTK+YP6STo599XTYG74WwGsSd0TdWAPLqwy63O9DCexTv8qtNA99Z7TjO3qej3p4
         FHdRTXNCPZqZ1O8eG7dVbfVYVjbP7WehmFER6WH9kn7kjtkf+icxfAtY4eNiv230si7q
         +vAb8qiczCK1J/bLwdl86qhD2o6H7IUU4SRT5ATb1YV7J/7rI1XxDIDRb2j3knznsJii
         07SPbNCRj+v3ByEOT4ZieERe8E4v1iRJpwUUagvpTyJsMXdFcCOY7KTFd9nRkVaC3D14
         AVDj5VXUUMPa08ykf2Z/EZpUxl9zqrIPsfN4OUrE248aNsrhWd301TFOYfGcsoE+/Quc
         HA2w==
X-Gm-Message-State: AOAM531ith2oJeHpBtSIEUrOiGziFRNIVVsf+BtnQnHjsn/yOPh7Slrc
        7R7W4Y7vlAXQWxkjXg7Y2idLEbO6
X-Google-Smtp-Source: ABdhPJzwe5JdIUupHAZHao42oDo/wLXgk8lRWFY1XfAizJRZefSMrivAb2aboM63K2OFu0+xy+fFgg==
X-Received: by 2002:aa7:db47:: with SMTP id n7mr7365212edt.223.1592647252493;
        Sat, 20 Jun 2020 03:00:52 -0700 (PDT)
Received: from [192.168.43.243] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id l6sm6927769edn.42.2020.06.20.03.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 03:00:52 -0700 (PDT)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1592611064-35370-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1592611064-35370-2-git-send-email-bijan.mottahedeh@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC 1/1] io_uring: use valid mm in io_req_work_grab_env() in
 SQPOLL mode
Message-ID: <a812d57b-7d95-8844-4c50-9155aca0884d@gmail.com>
Date:   Sat, 20 Jun 2020 12:59:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1592611064-35370-2-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/06/2020 02:57, Bijan Mottahedeh wrote:
> If current->mm is not set in SQPOLL mode, then use ctx->sqo_mm;
> otherwise fail thre request.

io_sq_thread_acquire_mm() called from io_async_buf_retry() should've
guaranteed presence of current->mm. Though, the problem could be in
"io_op_defs[req->opcode].needs_mm" check there, which is done only
for the first request in a link.

> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
>  fs/io_uring.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index cb696ab..fd53ea6 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1062,8 +1062,18 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
>  					const struct io_op_def *def)
>  {
>  	if (!req->work.mm && def->needs_mm) {
> -		mmgrab(current->mm);
> -		req->work.mm = current->mm;
> +		struct mm_struct *mm = current->mm;
> +
> +		if (!mm) {
> +			if (req->ctx && req->ctx->sqo_thread)
> +				mm = req->ctx->sqo_mm;
> +			else
> +				req->work.flags |= IO_WQ_WORK_CANCEL;
> +		}
> +		if (mm) {
> +			mmgrab(mm);
> +			req->work.mm = mm;
> +		}
>  	}
>  	if (!req->work.creds)
>  		req->work.creds = get_current_cred();
> 

-- 
Pavel Begunkov
