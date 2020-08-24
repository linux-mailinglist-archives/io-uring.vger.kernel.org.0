Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF26250A32
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 22:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgHXUmf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 16:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHXUme (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 16:42:34 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C17C061574
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 13:42:33 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id w2so9286265edv.7
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 13:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SyQHy3BN8rGNILHxzGZ3m83Xev9DSlA/nLw6EUPKiDE=;
        b=Jl5keV63rDk/Mu2j5vgVLvtOXlgAKKr6QeWynOzoSFYktrVylYfMFPBH/YdeAkCzGA
         jZ0Gi+Ls95VrXtjgx9PQ9kziKbPWccEvuf/7CimBjQZWS9WoWCyn8QozCHutcZqi4J6u
         JLdPKUtLq2Ffs0MAub9/XqTf58Xl+J7lAVoKhau4TLPhhLf7PjQpvSto4AulN6lCa+hy
         NZHAjtyXyS4peCGGXDAx+vsB/Yd6sS93WsQGEBV0whFmNC5GvIDk85YNMlGhqU3Wm1sT
         aGQTRApFQ6ymj6pRQZKnPXerzwErlqhhqHok5H9ENqWG51YaC5VI4Vii17z0py8aQzE2
         9rKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SyQHy3BN8rGNILHxzGZ3m83Xev9DSlA/nLw6EUPKiDE=;
        b=R5yQtNRJkdCa7lsEtjagqBE/wiErMexf682VXyQBYECm41Vj/TnKCaIZh6CfanRF0M
         jQIlOKxss0TB3fIbdJ6bUk4hwgcAc64KzGM6+Q0I6sBgSsVepOoAB+CLfUcfprNtYVZg
         XEZRYXr1FTz4gx9c9OtmAv6WXbVb51apiudw54gjkFYb5EEim8VVMzJeUgS/RzdrwxPi
         izC0RLdNjFgi3DtTpKW7q8iwah+i/9Mm0yCENsgag2nE7xUbj1FaZRjJUJ6o5ts3ilGW
         ZmnhX09qy5XC8dLwHhCGYwmZ6EDDsIbZM0/ooH2kz5+I/mADy3aU5vSNrjYR8AOwMr36
         Q5EQ==
X-Gm-Message-State: AOAM5318uHaUNm3qPefatWCtoWuzRf7DmHFOd9oUmVFIbdi8adtantZn
        yjEnMC0jfMoBgI85ckgXHqyz1AlXQmk=
X-Google-Smtp-Source: ABdhPJxon5BVlQEuxH4wcHB/i3xf2tde9xqZRKIefd7N+lAsO62LwvxWiyF0ho1s/ARLNqHmuVEBqw==
X-Received: by 2002:a50:ee92:: with SMTP id f18mr6854866edr.191.1598301752343;
        Mon, 24 Aug 2020 13:42:32 -0700 (PDT)
Received: from [192.168.43.209] ([5.100.192.234])
        by smtp.gmail.com with ESMTPSA id v7sm11653099edd.48.2020.08.24.13.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 13:42:31 -0700 (PDT)
Subject: Re: [PATCH 5.8] io_uring: fix missing ->mm on exit
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <25db35fc25aa7111f67a6747b1281c5151432f8f.1598300802.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <392dc86b-52ac-1ca4-d942-51261d1f7a9f@gmail.com>
Date:   Mon, 24 Aug 2020 23:40:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <25db35fc25aa7111f67a6747b1281c5151432f8f.1598300802.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/08/2020 23:35, Pavel Begunkov wrote:
> do_exit() first drops current->mm and then runs task_work, from where
> io_sq_thread_acquire_mm() would try to set mm for a user dying process.

This is a backport of [1] + [2] for 5.8. Let's wait to see if
Roman Gershman can test it.

[1] 8eb06d7e8dd85 ("io_uring: fix missing ->mm on exit")
[2] cbcf72148da4a ("io_uring: return locked and pinned page accounting")


> 
> [  208.004249] WARNING: CPU: 2 PID: 1854 at
> 	kernel/kthread.c:1238 kthread_use_mm+0x244/0x270
> [  208.004287]  kthread_use_mm+0x244/0x270
> [  208.004288]  io_sq_thread_acquire_mm.part.0+0x54/0x80
> [  208.004290]  io_async_task_func+0x258/0x2ac
> [  208.004291]  task_work_run+0xc8/0x210
> [  208.004294]  do_exit+0x1b8/0x430
> [  208.004295]  do_group_exit+0x44/0xac
> [  208.004296]  get_signal+0x164/0x69c
> [  208.004298]  do_signal+0x94/0x1d0
> [  208.004299]  do_notify_resume+0x18c/0x340
> [  208.004300]  work_pending+0x8/0x3d4
> 
> Reported-by: Roman Gershman <>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 493e5047e67c..a8b3a608c553 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4313,7 +4313,8 @@ static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
>  				   struct io_kiocb *req)
>  {
>  	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
> -		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
> +		if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL) ||
> +			     !mmget_not_zero(ctx->sqo_mm)))
>  			return -EFAULT;
>  		kthread_use_mm(ctx->sqo_mm);
>  	}
> 

-- 
Pavel Begunkov
