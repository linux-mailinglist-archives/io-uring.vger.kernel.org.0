Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF21B1548C4
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 17:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgBFQET (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 11:04:19 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:32933 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbgBFQET (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 11:04:19 -0500
Received: by mail-il1-f195.google.com with SMTP id s18so5537217iln.0
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 08:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1rEpTbyL4DEh2dBSsE63MjHWfGT32ahW/Qn11tnAHX0=;
        b=eWL5kpR8x/CNFsvHxUEKMhn/SPRgpVFfDkPzb4xGQRw40Jvlf5zfZt0vjUxBuEtt30
         LX21mRfE5Tah/sSvWZxCdJ3jsbgUDUSMIFP51Ps248NkPzIlOC5snc0kiKFyj77B51wy
         AmljAorgnRFxkRferxW758QTnOsplUexCwCrPzFTpnzdRE0c5u0iO1kOY43GjRONj9dj
         7sfy4RUhaUZLYo2wdy2Djy9R11LP7+vKZzFuboAzmbvcdkrqqnwmt6K0Q1YGme1rrtro
         l1nr8VQghg4b+mPW7IupYkW95aq0YuuSMqsd1HfXtZ9Goq4caAnJa7LrLCCtgg0TRHDC
         Eprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1rEpTbyL4DEh2dBSsE63MjHWfGT32ahW/Qn11tnAHX0=;
        b=q2cvhN+J1GISzE2V3xjjqBFUB9HJ7jYxBCSA7V3/zOLx35oslekVcRET4TR/1IHTIR
         kgYOCDnbrp3H1I8KlEXRq1XeVYMvyzdPNVkfSXnfCf69ONTMjeKhDk6848dPhmB3nBgU
         5S88FAGpC2JTTbnwB8AfuaNVzTKkOIhKQKTm0SB9x6hO7n8/UghqK9HCnspSvga0uw5e
         IbDrRb0T6DtSHsBrm+A6Ruu1Ir6DVsvNhwB5o8znt6kE4faIfJuBX7Yydpm/DcuD1wur
         q1/nyLeLFIM/cOUhovGy8M8QG3iGzXDycUL6bzTpo/tB7xCvzuDuHG+Z1vAJZKsM3nPk
         AUMQ==
X-Gm-Message-State: APjAAAVIxtAaVAAKB811wl1irIUeWk0Dvp7K+LW8doIM45ZZv6ceezgq
        +qyUdT3pgcrsLHSaUykyVlH7EfUlA50=
X-Google-Smtp-Source: APXvYqwexKqKPnXd9UsTySQTvANKeDRqfcdMIsBGRRNvUUwdDUn07bEyONBOdCbuc9bUb7Bceek1eg==
X-Received: by 2002:a92:51:: with SMTP id 78mr4595616ila.121.1581005056423;
        Thu, 06 Feb 2020 08:04:16 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p19sm10848ilc.69.2020.02.06.08.04.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 08:04:16 -0800 (PST)
Subject: Re: [PATCH v1] io_uring_cqe_get_data() only requires a const struct
 io_uring_cqe *cqe
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20200206160209.14432-1-metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <94d5b40d-a5d8-706f-ab5c-3a8bd512d831@kernel.dk>
Date:   Thu, 6 Feb 2020 09:04:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200206160209.14432-1-metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/20 9:02 AM, Stefan Metzmacher wrote:
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  src/include/liburing.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index faed2e7..44f18fd 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -179,7 +179,7 @@ static inline void io_uring_sqe_set_data(struct io_uring_sqe *sqe, void *data)
>  	sqe->user_data = (unsigned long) data;
>  }
>  
> -static inline void *io_uring_cqe_get_data(struct io_uring_cqe *cqe)
> +static inline void *io_uring_cqe_get_data(const struct io_uring_cqe *cqe)
>  {
>  	return (void *) (uintptr_t) cqe->user_data;
>  }

Applied, thanks.

Unrelated to this patch, but I'd like to release a 0.4 sooner rather
than later. Let me know if you see any immediate work that needs doing
before that happens.

-- 
Jens Axboe

