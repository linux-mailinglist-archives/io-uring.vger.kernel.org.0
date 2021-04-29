Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C220736EF38
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 19:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241020AbhD2R4x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 13:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241007AbhD2R4w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 13:56:52 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E8BC06138C;
        Thu, 29 Apr 2021 10:56:05 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 4-20020a05600c26c4b0290146e1feccd8so226264wmv.1;
        Thu, 29 Apr 2021 10:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=x03N4U2d63n3eKi2aMlVnMhqfVRDG+Wr9njWqMaaWpE=;
        b=jtdhJq7eER/wGoAmMMV79BT+Pgj+kvjuArVHpXctq8kXcSIIxJdgdxZQyRtSQfquld
         wp6OnaFc+wq0yFxTvTA4sDbNnKdwCZuIECr3R1mq32W73Vc3AnB4/uVZsAQAsntlqFeH
         OfOFoWCOthKnFsSUWK9NEYFtM32rjK2bGdCkobqkm5TkOzRhhzfXjtIoyW+YDWprj3JM
         iejkoY6xwm+zhUuiaFGdaGoQY3qzbRJSTpiZs4Ub4nDm8gTwgw1CWIcGa0tXZaNnUV3L
         lvYE7a8npJWRTUjA7h0p7b1HSWmEHHETtTXPyEn+6To/Xy3SloAAEj9xb9L6KJp5wTVq
         e6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x03N4U2d63n3eKi2aMlVnMhqfVRDG+Wr9njWqMaaWpE=;
        b=LnbtqoXALlxhXD0M34PU8ZNM6L04mHby4tyTg+8OLDSjJBy6i2VMhVYJs22nFkKCm1
         7d6e/bcMHDW0xw7vRdAvR33nI7dSiGER8jChgbr/XgTdmoTPy8+pXd9nfhRkQj3VlJHl
         1lpcRd0JHgxYhvm96lMSQkgs+IYCLAXXIeDYknaTIuDJ+7w6SrBgXKKSugb/aNAlpWRI
         WDyAjBt3+tbCm6nHI4D4KMUGh4EyJguM/eJd14GEAjrOZ3Smf80juXtKu/hM+UTmJ+nY
         cwLQ2ojwGUX7AM3cguxx30wyMUffyCSoGdO3Dybp1RJ5nPUjBztkdOhiAouJYD1vn+Zm
         Gjqw==
X-Gm-Message-State: AOAM530huQBedif6giKaQDvBn8bX4kBnZSrAv7oIry8YeZ0m12D0V9a+
        xnKDb1rJhEfj8UwW7gc2d/Q=
X-Google-Smtp-Source: ABdhPJxj1FuYyb3Uyrh4aTzIUcJpgQ6k1FcvqhGdtA7GiQvLNNGUxnxmsmsBNCCaLeaJy9Rn+kOmeA==
X-Received: by 2002:a05:600c:41c2:: with SMTP id t2mr1431647wmh.169.1619718964505;
        Thu, 29 Apr 2021 10:56:04 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id v4sm995021wme.14.2021.04.29.10.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 10:56:04 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_uring_setup (2)
To:     syzbot <syzbot+1eca5b0d7ac82b74d347@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000014ec7c05c12012b1@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <8eec9ad4-3341-f136-0983-52f3c687f9da@gmail.com>
Date:   Thu, 29 Apr 2021 18:55:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000014ec7c05c12012b1@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 6:46 PM, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit eae071c9b4cefbcc3f985c5abf9a6e32c1608ca9
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Sun Apr 25 13:32:24 2021 +0000
> 
>     io_uring: prepare fixed rw for dynanic buffers
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13f639edd00000
> start commit:   d72cd4ad Merge tag 'scsi-misc' of git://git.kernel.org/pub..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=100e39edd00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17f639edd00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=53fdf14defd48c56
> dashboard link: https://syzkaller.appspot.com/bug?extid=1eca5b0d7ac82b74d347
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15aeff43d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1747117dd00000
> 
> Reported-by: syzbot+1eca5b0d7ac82b74d347@syzkaller.appspotmail.com
> Fixes: eae071c9b4ce ("io_uring: prepare fixed rw for dynanic buffers")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz test: git://git.kernel.dk/linux-block io_uring-5.13

-- 
Pavel Begunkov
