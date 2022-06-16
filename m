Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF7854E288
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 15:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiFPNyD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 09:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376717AbiFPNyB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 09:54:01 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E39B344DD
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 06:54:00 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id es26so608033edb.4
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 06:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uJCsK+/psPa45x0EnIo8MsONDVwNJGtkUg9BHF5CAEA=;
        b=LZ+Lp8p9Xd+L+T6Atxr/P0xIlQhlRitG/O2o+3X5BAWWMy1COZFLb/oKyCvzJ6xKLa
         rWWPZBlavK+d7A6omaCx0HLnRcSxJf+JckDvzTGrN92p7x3IO1QSSk7K/Ey9e3cPOYey
         stzgTxl0aJ3dhHGJf7ksX6A2jyZ4bs6iNEJVIQMsuIZ7FOhBpK4b3wuiJWxuWJLvrqs0
         OuIfpjE+1jwK+b4t4Ex301QT6yi2reGuE9SjHkD+1sY8cvaO5fdVN020FNOuJAwwkELF
         TZ+Tj78uTx0IMFWW2IaZKE+VAJ97+ABvYFG/BRknIMNq39FcGf4os2o1Inp0BmAdfogW
         XOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uJCsK+/psPa45x0EnIo8MsONDVwNJGtkUg9BHF5CAEA=;
        b=Ydsz6+kRVe7tg1ly7in0fPq1DMAfw2y1ZFzK5D2E5IE0w6V4khgXcL3U+jvGcMhkSn
         WyEqHMOWdrqyc3FdKgH7TJqczUuVJdIh3urrmKH3BDmEB8uGecNuyXEP80S535GZQSUt
         DmJhaSaGmQ+t7CDDMGKV+052xXzbRO2mvsrMnKz2E3qwW6o/IfUwq5ajAXYxPGF9X24a
         IbHkQTWXaa2cXMuzsJsqLMk+/yNtttpdRocvFqUE4G2sRAbAYbYqYDyZb6z8G3I+NHaA
         53FI0eWpQDW8uDTchmops9kQ52pzKwslaki6tsV6NvgYdDqVToymEZHyHlqH7Vpqi4/w
         yRtA==
X-Gm-Message-State: AJIora/2GEt6PBWWv6RkWbb6CW9SbCUSTcQCgkq3d5jB9JW9xTbaLo+c
        iw4psG0Yk+25MiIzMLH1zxo=
X-Google-Smtp-Source: AGRyM1uKUuufsRD7eZA01+HzrVCdRziE3fqQO6XoQ/0CNwrnsAOs/Ud/dxfWUjiVNRjvXD9teofgGQ==
X-Received: by 2002:a05:6402:84a:b0:423:fe99:8c53 with SMTP id b10-20020a056402084a00b00423fe998c53mr6436643edz.195.1655387638687;
        Thu, 16 Jun 2022 06:53:58 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c093:600::1:87fa])
        by smtp.gmail.com with ESMTPSA id x13-20020aa7d6cd000000b004333e3e3199sm1790360edr.63.2022.06.16.06.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 06:53:58 -0700 (PDT)
Message-ID: <13435ca1-a659-730a-029d-3afe3eb23f68@gmail.com>
Date:   Thu, 16 Jun 2022 14:53:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.19] io_uring: do not use prio task_work_add in uring_cmd
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220616135011.441980-1-dylany@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220616135011.441980-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/22 14:50, Dylan Yudaken wrote:
> io_req_task_prio_work_add has a strict assumption that it will only be
> used with io_req_task_complete. There is a codepath that assumes this is
> the case and will not even call the completion function if it is hit.
> 
> For uring_cmd with an arbitrary completion function change the call to the
> correct non-priority version.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>



> Fixes: ee692a21e9bf8 ("fs,io_uring: add infrastructure for uring-cmd")
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
>   fs/io_uring.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 3aab4182fd89..a7ac2d3bce76 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5079,7 +5079,7 @@ void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>   
>   	req->uring_cmd.task_work_cb = task_work_cb;
>   	req->io_task_work.func = io_uring_cmd_work;
> -	io_req_task_prio_work_add(req);
> +	io_req_task_work_add(req);
>   }
>   EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
>   
> 
> base-commit: b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3

-- 
Pavel Begunkov
