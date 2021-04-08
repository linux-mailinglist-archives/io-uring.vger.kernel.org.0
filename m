Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4791358CC3
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 20:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhDHSh5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 14:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhDHSh4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 14:37:56 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CA6C061760
        for <io-uring@vger.kernel.org>; Thu,  8 Apr 2021 11:37:45 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 12so1677435wmf.5
        for <io-uring@vger.kernel.org>; Thu, 08 Apr 2021 11:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=babhkIUD/OHAMwxgYiD2jXVJyCbkrcbOKjg0Oyu8VN4=;
        b=Qiyw/Wn3Hoi3a3AHLWjKWe6llKQ3+sPdnkFTPD9PXZotriSMjzxLzuM+YhnD+u8Qq7
         6eS9ieGzrDDZrlbmZYVPd57Jtva/S80VVJL90ZWAM3mTtZQMJmqVfbvvR409+xtG7I4t
         Y3tEMzJausk0AVnCG5gWWZ/xqT9JYBmEMYlRfrckzODstVbCsuPwonDIbjG+5YQayGBp
         loXkgZAtiu2Q69OJh4DDAK3e38rQpeini86eXgsqUHjBJBfdWLn0xbW5FJlWyWVmtvA7
         9ifaz5/eNh0TmBw8N4kaQqKhjG4KBVegYHCfkrITpp+acax/gBVu2YE+KcMnOzUpTHvM
         hD+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=babhkIUD/OHAMwxgYiD2jXVJyCbkrcbOKjg0Oyu8VN4=;
        b=GFbplS3Vi1oFRSVSQM2eqU7HKOhmFWoxIAjR0UQ586A350TCIAG1KjL2Aih13Hycbx
         SgV3ElzNxyKPrzaSPCiM1FhCFcKhM3O0zaTRr0R5mE+cNBJdWTh1O7odXN/VyQ7pnB9q
         1j2xuRvsKiAODXMuWAqBhSv+aKo1VIjSm1c6inQFtcoyIs7itQK0xqpYjKY4oWlfe1/a
         K05mQGUcDYmvu/wsp4kK3ddlc2hfInJcb+0O9MgJsXVnlv7f/g/IG9ksZX82IP9nagzt
         DARkvvIfNRmKqyNEp9VtHyxRXE5ehZA14gXeskiWUpgtXQw5YGDGXNeLlU93aDnq58Ky
         j/4Q==
X-Gm-Message-State: AOAM530Zyg6IrmiXOHFm60tJiyvg+jINI5RYrCLc03Y6mLMafZ9CJ8JV
        slduq7ZtpDFbAsXWDBgKfqKSgOLd2O1xCQ==
X-Google-Smtp-Source: ABdhPJzNRp+vB+NDKptsRB/TYyCEBkHXf/gcJ0/koEZ33fSOjtELJaCH2s4EbQfBcVnoDO1k0vMWFg==
X-Received: by 2002:a05:600c:4f13:: with SMTP id l19mr9850445wmq.89.1617907063703;
        Thu, 08 Apr 2021 11:37:43 -0700 (PDT)
Received: from [192.168.8.160] ([148.252.128.224])
        by smtp.gmail.com with ESMTPSA id c16sm174650wrx.46.2021.04.08.11.37.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 11:37:43 -0700 (PDT)
Subject: Re: [PATCH 5.12 v3] io_uring: fix rw req completion
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <01f81563aacb51972dacff4f2080087c321e424a.1617906241.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <506e070e-a0bf-a9a4-ccf0-b16c80e9b65f@gmail.com>
Date:   Thu, 8 Apr 2021 19:33:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <01f81563aacb51972dacff4f2080087c321e424a.1617906241.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/04/2021 19:28, Pavel Begunkov wrote:
> WARNING: at fs/io_uring.c:8578 io_ring_exit_work.cold+0x0/0x18
> 
> As reissuing is now passed back by REQ_F_REISSUE and kiocb_done()
> internally uses __io_complete_rw(), it may stop after setting the flag
> so leaving a dangling request.

Jens, this one is instead of taken v1, it handles io_rw_reissue() errors.
The handling code is partially hand coded __io_complete_rw(). Obviously,
needs cleaning in the nearest future.

> 
> There are tricky edge cases, e.g. reading beyound file, boundary, so
> the easiest way is to hand code reissue in kiocb_done() as
> __io_complete_rw() was doing for us before.
> 
> Fixes: 230d50d448ac ("io_uring: move reissue into regular IO path")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Link: https://lore.kernel.org/r/f602250d292f8a84cca9a01d747744d1e797be26.1617842918.git.asml.silence@gmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
> 
> 
> v2: io_rw_reissue() may fail, check return code
> v3: adjust commit message
> 
>  fs/io_uring.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f1881ac0744b..f2df0569a60a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2762,6 +2762,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
>  {
>  	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
>  	struct io_async_rw *io = req->async_data;
> +	bool check_reissue = (kiocb->ki_complete == io_complete_rw);
>  
>  	/* add previously done IO, if any */
>  	if (io && io->bytes_done > 0) {
> @@ -2777,6 +2778,18 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
>  		__io_complete_rw(req, ret, 0, issue_flags);
>  	else
>  		io_rw_done(kiocb, ret);
> +
> +	if (check_reissue && req->flags & REQ_F_REISSUE) {
> +		req->flags &= ~REQ_F_REISSUE;
> +		if (!io_rw_reissue(req)) {
> +			int cflags = 0;
> +
> +			req_set_fail_links(req);
> +			if (req->flags & REQ_F_BUFFER_SELECTED)
> +				cflags = io_put_rw_kbuf(req);
> +			__io_req_complete(req, issue_flags, ret, cflags);
> +		}
> +	}
>  }
>  
>  static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
> 

-- 
Pavel Begunkov
