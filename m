Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7084670F4
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 04:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhLCD6g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Dec 2021 22:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhLCD6f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Dec 2021 22:58:35 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6AAC06174A;
        Thu,  2 Dec 2021 19:55:12 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 137so1311216wma.1;
        Thu, 02 Dec 2021 19:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=1hebGR6Cl+u05IUMKJC6xIrtBc5TTp7uBFStdIMVjpY=;
        b=hOzzmww3mDoKbNS6lCz7ofNTQsW7ZlO1tSz0ffX+1WOTXvaYcXWoqpydhjMF4sIYD+
         fZHmiZ1aIvtJb9iYhBFdRcQxDNzZlFqydyb6zRuv7pC5IcJ7IrRBxxQP5vojsgH0QyOa
         ZLZ8OwWuB0rr3QcFRcFwiUk3eE13qGB+2t8OhbX4lKPiAdTLbLRGiYTvN3pQehf6ewts
         gmRlK353TWZtE1uKOhypuIHuJHti+YwKvrqx8EI0XLKG+occ3id1BgQPCSQ4zAiGdvTW
         PetwTQ3L+6qTT/P6FWG62LVELTg87YCXgQCpRIcxNYjg0/O6dbzt8b1vNRWqQBgHdiNo
         2A4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1hebGR6Cl+u05IUMKJC6xIrtBc5TTp7uBFStdIMVjpY=;
        b=1ucG2P0cSZkwMhDRXaakukSmVTHOK7lnF5I2XdF08omcHhJeIv/Lld1s1xXLyPjFJA
         qko2BwtZ4EZMgDAqAXOWT8ZVzfox/GTWdPnPS5/Y+ReUzWWR7nItazcABp85Q6iyz5s/
         p21cFX7Upn26O6r0tzU6t9U9Q54X7cEAD2gV0tkzua2rTi7BnPq+wiiqRzktmdaZDPMM
         Yq2HICI4uRfRGVDI/xYSkRA6opHNMMDGq9qg4bVeKWjSPVlPBIJq7kdlBXjjP+6FcCwl
         Dc7m2O6dnOcdPzOyg5MeA9ayKi1ISvrk8MDhrnCLCtGq/2ZIJSULs6uOj5JUAPTIe2Au
         kHpw==
X-Gm-Message-State: AOAM5335tJjeCsDvIAeuXFNdgbkhRgGcN8Dmmvh86jDJyINXHK/qGhR+
        kdhl3CtoKzKDn054uIxcgMhe31MCe5o=
X-Google-Smtp-Source: ABdhPJzHpmAft/pgu83IA7iI8miPRBo9VdAYa8SEO/jpW0LEWRRFmKM0ZW1lekOa3xijFQV5SIWwrA==
X-Received: by 2002:a05:600c:1914:: with SMTP id j20mr11767788wmq.26.1638503710633;
        Thu, 02 Dec 2021 19:55:10 -0800 (PST)
Received: from [192.168.8.198] ([148.252.132.146])
        by smtp.gmail.com with ESMTPSA id n1sm1382364wmq.6.2021.12.02.19.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 19:55:10 -0800 (PST)
Message-ID: <ed683410-92bd-fecf-c52a-32c865b13ae4@gmail.com>
Date:   Fri, 3 Dec 2021 03:55:07 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 4/5] io_uring: add fsetxattr and setxattr support
Content-Language: en-US
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com
References: <20211201055144.3141001-1-shr@fb.com>
 <20211201055144.3141001-5-shr@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211201055144.3141001-5-shr@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/1/21 05:51, Stefan Roesch wrote:
> This adds support to io_uring for the fsetxattr and setxattr API.

io_uring part (4/5 and 5/5) look sane, just one comments below

  
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>   fs/io_uring.c                 | 174 ++++++++++++++++++++++++++++++++++
>   include/uapi/linux/io_uring.h |   6 +-
>   2 files changed, 179 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 568729677e25..9d977bf243fd 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
[...]
> +static int io_fsetxattr_prep(struct io_kiocb *req,
> +			const struct io_uring_sqe *sqe)
> +{
> +	if (!req->file)
> +		return -EBADF;

No need, io_init_req() will fail the request if it can't get a file.
Same for fgetxattr.


> +
> +	return __io_setxattr_prep(req, sqe, file_mnt_user_ns(req->file));
> +}
> +

-- 
Pavel Begunkov
