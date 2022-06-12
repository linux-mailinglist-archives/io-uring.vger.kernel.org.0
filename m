Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36EED547B4B
	for <lists+io-uring@lfdr.de>; Sun, 12 Jun 2022 19:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbiFLRsD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jun 2022 13:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbiFLRrz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jun 2022 13:47:55 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F6E60DC
        for <io-uring@vger.kernel.org>; Sun, 12 Jun 2022 10:47:54 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id m39-20020a05600c3b2700b0039c511ebbacso3453372wms.3
        for <io-uring@vger.kernel.org>; Sun, 12 Jun 2022 10:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bE84FrMnW+hyV1USyuRyEtSlydQzTYDsXMrYBcERqdg=;
        b=ZOdWuYspNRsBeWuegS7Nn7vKQ1mAyhVDMRK3M88Uqt6XepV3SiNtIR/Mw0fwo6spKP
         ue4JSNACWftce8uOGDOATYFDn9YetNNflDuB+GjO7gwJxbo22FY3hJ7ge9DfVhU0hbU8
         ru8QoPByKEocLKD8VtY+ornCVeMLFXMKwsMgS/GE57WPpLJp4QYqN4CHYY0ObqQwwVF5
         Gbj6uEIKqAu5dWbxhqje3zN/P5/QlVfYGeCWexW1tUUZzzXmh+hA6FtWNsahX3yD38mJ
         y4cynNsd+31RIpLdxhsrD361jVxJq/nOtUv85t52nw+legDpF6nJN2Vi/MWSfmCTQXE7
         L+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bE84FrMnW+hyV1USyuRyEtSlydQzTYDsXMrYBcERqdg=;
        b=51uC8trWfLYvz4eXsVUE2srHo8Is3AxF99VVleGBSnZLyDPf/4+8gdetVx63J4MSsD
         YxCugUWZef7YG8hBFCrlzwxTAR/knuukaQWnwoYSfY9iCfLX04uZA38ZObGutp8lS24G
         +VBc6g0IQ6IIXG6gXXhVIHJh3X1t6fOeMcffr5yAX+rxkIJARABbKNJ8AfIi2RHmEiaM
         qX6GDGtz+yz1IijyDl+ildBW8SyQROoYsddM9i85ClkgQcubjnDPRZJ7jMwayc3DnZkq
         oof0L2/ldvYzHVe3bLvTeRIyGCkNStKenPzrMQcEB2ou7rBQqHHQCsOJgrQfFFiAFu+r
         sBkQ==
X-Gm-Message-State: AOAM532Ckkd9dWhJxWOnkSBOPkTh84NrjM3ORVvqurW2x19Wk0ak+xRP
        V+XXlZDhAC6QCIJdqbdnrMk=
X-Google-Smtp-Source: ABdhPJzp5OsUxR8Vmr2DyLEDKdko6QrPbwLw21dlCrfVu6QIuNznDcDetCX/PtntVcSQFo/DFOQ/sw==
X-Received: by 2002:a7b:ce08:0:b0:39c:8f58:2414 with SMTP id m8-20020a7bce08000000b0039c8f582414mr3629753wmc.74.1655056072644;
        Sun, 12 Jun 2022 10:47:52 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id y3-20020adfd083000000b002103cfd2fbasm6060677wrh.65.2022.06.12.10.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jun 2022 10:47:52 -0700 (PDT)
Message-ID: <4808da68-0835-07ef-4b59-7fa0c09684ce@gmail.com>
Date:   Sun, 12 Jun 2022 18:47:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.19 2/6] io_uring: openclose: fix bug of closing wrong
 fixed file
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220611122224.941800-1-hao.xu@linux.dev>
 <20220611122224.941800-2-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220611122224.941800-2-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/11/22 13:22, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Don't update ret until fixed file is closed, otherwise the file slot
> becomes the error code.

I rebased and queued this and 6/6, will send them out together
later, thanks

https://github.com/isilence/linux/tree/io_uring/io_uring-5.19

> 
> Fixes: a7c41b4687f5 ("io_uring: let IORING_OP_FILES_UPDATE support choosing fixed file slots")
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   io_uring/rsrc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index d78e7f2ea91f..cf8c85d1fb59 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -705,8 +705,8 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
>   		if (ret < 0)
>   			break;
>   		if (copy_to_user(&fds[done], &ret, sizeof(ret))) {
> -			ret = -EFAULT;
>   			__io_close_fixed(req, issue_flags, ret);
> +			ret = -EFAULT;
>   			break;
>   		}
>   	}

-- 
Pavel Begunkov
