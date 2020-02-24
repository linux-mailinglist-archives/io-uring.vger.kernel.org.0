Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9F316AA1B
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgBXPaR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:30:17 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:42454 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgBXPaR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:30:17 -0500
Received: by mail-il1-f194.google.com with SMTP id x2so8024436ila.9
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HRUgixvzt7RP++S1z7vruAGh53qXXjYkxLNAH9xgaFE=;
        b=MYD4QCET+wy1ZUmh9CRYg8JDycXfaSkOGWvF1RHf2Esx8EPD1KRjWNQr4bSmg7tqdF
         AfHBEqvQ0rdVPtRk/FAnS9ceSG6a9UudCqLJFNqV11poQU1XFtosu28g3g0G/Lk2Gp9W
         mRMLu7s7KApHqNpSEEBQ3cjABcnWgBY92mnAf+25xXze4+ZIr4vjASY67Q4sd//pHtud
         WB6VuKM+IKUWz4cKDdUHdJfWn1wXN1KsX64QImxdVibpGHe+TTmIolMAYdWoqGhXaQ9U
         Mzbj8+d46BdG29XRxbpH/HE2YmycFATRW5EXXxI+QU3yqHDH1hWf+jiBu1TeGSB0d/eo
         ln0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HRUgixvzt7RP++S1z7vruAGh53qXXjYkxLNAH9xgaFE=;
        b=BVPAhjYib4KifKss2QtW7tu4rWJrj8YARj/tKNHyTu5YyMSRYePYHMhK3KFnVSMvGB
         R2rn6JxcGiEOwx0O6voMk44pOntytRaDUA/8WA7Bc5QsDpY88GSmUFeDQeNrT9FJtzdY
         LrlwjXjv8fMJ6Xc7FjPMEoRuD1sy2BAhXvaxfWUAlYgYqfjX9hG0zv6Z/FXekTbo4G7f
         zF0QO6Ik6ysOIBulZLOYWfLj8xHB9c6G73DOxKIpc02CV2WUFTXLIIUhY5qah26OwAdL
         whAFxkMK3EXhMBxaiqpx2IiejLmIfr3PhGGMUU+wTtJ52mWbXaUuWtRRfONITZ4NsF/6
         +HqA==
X-Gm-Message-State: APjAAAV66XAf7L44y6Pcn3J3ChtoYhhkmIxA1WcTymPF3ouWAL/UCjOI
        2Wjdy4L/ggDv7wz0khcUt7rCA12ap+o=
X-Google-Smtp-Source: APXvYqxVtUYftqlqkSvBrvB/AqHPF3g+JJMJZC+Zp/ceW6bqk7tiUdR++yQbIgqtAopLCyCz5irQWw==
X-Received: by 2002:a92:5d92:: with SMTP id e18mr32783467ilg.75.1582558216104;
        Mon, 24 Feb 2020 07:30:16 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f12sm3083768iog.46.2020.02.24.07.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:30:15 -0800 (PST)
Subject: Re: [PATCH v3 2/3] io_uring: don't do full *prep_worker() from io-wq
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1582530396.git.asml.silence@gmail.com>
 <ca345ead1a45ce9d2c4f916b07a4a2e8eae328e8.1582530396.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8c439182-008b-dfe6-82e7-487c849a2092@kernel.dk>
Date:   Mon, 24 Feb 2020 08:30:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <ca345ead1a45ce9d2c4f916b07a4a2e8eae328e8.1582530396.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 1:30 AM, Pavel Begunkov wrote:
> io_prep_async_worker() called io_wq_assign_next() do many useless checks:
> io_req_work_grab_env() was already called during prep, and @do_hashed
> is not ever used. Add io_prep_next_work() -- simplified version, that
> can be called io-wq.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 819661f49023..3003e767ced3 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -955,6 +955,17 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
>  	}
>  }
>  
> +static inline void io_prep_next_work(struct io_kiocb *req,
> +				     struct io_kiocb **link)
> +{
> +	const struct io_op_def *def = &io_op_defs[req->opcode];
> +
> +	if (!(req->flags & REQ_F_ISREG) && def->unbound_nonreg_file)
> +			req->work.flags |= IO_WQ_WORK_UNBOUND;

Extra tab?

Otherwise looks fine.

-- 
Jens Axboe

