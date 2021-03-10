Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1708333F84
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 14:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhCJNpB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 08:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbhCJNok (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 08:44:40 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86251C061760;
        Wed, 10 Mar 2021 05:44:40 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id l22so7145010wme.1;
        Wed, 10 Mar 2021 05:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bYhucekadID1g/a4KLYLqYLvV/dEfsIiCdEyMPatBvw=;
        b=T0J2EuhV1+3WK81FSfTZEK56lOy1MCwSuQyz68apcyVprLbaFSaAHUsaHZfxPsYVhc
         0njTaJ/nZtWkZT7R8oT0UhnVl4Bw8cNIk+3lZxJaA3BRsZYidHLSuvQdoPQe+hxBMc0B
         njhg2MEMQwSF8q73wnrAoLPMb2YnipYtesm7S/nGv9+XOEDyl1T0LCHSM2J3YPscNzPN
         ybjrzLOOiaQaqW0GlppPokgIcMjX3MulIHunB8GTiVh3PmYPc7Cou6GaVzxGlPeTdiOD
         HkkGLHyBFrPoJMO+VBuQbVJ297JXfQhRsS4VEJni26Tl5mAhkAEDkp+MITuE/Ziupqg+
         l1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bYhucekadID1g/a4KLYLqYLvV/dEfsIiCdEyMPatBvw=;
        b=GvUiSwpVcJP0i1YNlxLyWuZ6QwWqayR9IwqXJ5WPm0plXP9bkyzmJ1nq+KwDKLUzcV
         3c3nJz1LUmRE9a5hKFaSiJ5o04vzmI2iQtygArhc53og8dhcTcdSU/6vF9mz+m62Djja
         ZiS6QsUAplGj/z6ZjaNVp+w/17wYrHpQsYJ/RJ1YmYRW6jQT7Q1hvXnf8y42UQRiKK8X
         SRJKMWk4xM7+ganUkT0opZuurJy669f2SF+PnQAsyPVyjNXKantDqMUYT9zgkrjvaboI
         gkw3rmqVUIQ7Luhe65PpyKR9IvNnMB9R9vyoseJdv1VGn1U1y73RpvJm9lMz3EnZLm3F
         l43g==
X-Gm-Message-State: AOAM530vIDOAsUIBkgQF4zCYiWXKh8NnhUZkSEjRzpmLmgqYPIdhzjht
        VmY56RbZ/vAOvbqGRidFPHE=
X-Google-Smtp-Source: ABdhPJxiYwdKwJe4gjQtc3Jh2gVBcI8nFMASLYCBcAP74eGxejh9swL7efa9i58/wRiHKEO9S2MrJQ==
X-Received: by 2002:a1c:7901:: with SMTP id l1mr3538339wme.114.1615383879361;
        Wed, 10 Mar 2021 05:44:39 -0800 (PST)
Received: from [192.168.8.126] ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id r26sm9352590wmn.28.2021.03.10.05.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 05:44:38 -0800 (PST)
Subject: Re: [syzbot] possible deadlock in io_sq_thread_finish
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <5112d102-d849-c640-868f-ee820163d02e@kernel.dk>
 <20210310041025.2438-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <b8e8a0f8-12fa-5dc4-6bcc-a274a8b2adec@gmail.com>
Date:   Wed, 10 Mar 2021 13:40:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210310041025.2438-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/03/2021 04:10, Hillf Danton wrote:> 
> Fix 05ff6c4a0e07 ("io_uring: SQPOLL parking fixes") in the current tree
> by removing the extra set of IO_SQ_THREAD_SHOULD_STOP in response to
> the arrival of urgent signal because it misleads io_sq_thread_stop(),
> though a followup cleanup should go there.

That's actually reasonable, just like
8bff1bf8abeda ("io_uring: fix io_sq_offload_create error handling")

Are you going to send a patch?

> 
> --- x/fs/io_uring.c
> +++ y/fs/io_uring.c
> @@ -6689,10 +6689,8 @@ static int io_sq_thread(void *data)
>  			io_sqd_init_new(sqd);
>  			timeout = jiffies + sqd->sq_thread_idle;
>  		}
> -		if (fatal_signal_pending(current)) {
> -			set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
> +		if (fatal_signal_pending(current))
>  			break;
> -		}
>  		sqt_spin = false;
>  		cap_entries = !list_is_singular(&sqd->ctx_list);
>  		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> 

-- 
Pavel Begunkov
