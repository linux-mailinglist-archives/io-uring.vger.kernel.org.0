Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3863AF698
	for <lists+io-uring@lfdr.de>; Mon, 21 Jun 2021 22:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhFUUHm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Jun 2021 16:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbhFUUHl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Jun 2021 16:07:41 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58889C061574
        for <io-uring@vger.kernel.org>; Mon, 21 Jun 2021 13:05:26 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id b5so4464100ilc.12
        for <io-uring@vger.kernel.org>; Mon, 21 Jun 2021 13:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WAHZ8Vz2CwykfGGX5mNg7moax8bM1FVKxI9y5zaUxRo=;
        b=fSYB3k2zxiTixDG0FzieNm8sxSEpgbEwcSqrWdWmeo4e2ZYkP3R12nr4DUd+rYyGLY
         mr7xDQX5qqemxxLys3J1GD5+k5nLoz9pxQiBT/9IW6BlQ/FGhlbmEzCmK4lAUFr6Haew
         DWwNr0CgbiBqKVmhqCWxxQe6COqP7+ChDh45GLVmZZeRo0RunBqR9HusT7JgMLj6prJy
         C55RXku4p35elny+VDSZUelcmNB/roqzqA3LWKP73TnhT2NzQEIL/Vv/0GYslqF8zB6x
         9NzMifprzG7RIfsbwDrNUrpusE1GnyfQ8Cm5gWJ+yKPOC2LEU06ufqYChfkupTbM7/CE
         hyOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WAHZ8Vz2CwykfGGX5mNg7moax8bM1FVKxI9y5zaUxRo=;
        b=P3mo9uF6NPS2/fqKnvLvoIZGsPQbh1JjE0qLv/Jt+BB+qEeAoPlhZc0foYyQwGzVNm
         DD1xd7DwBOzg05Qet39QGkPkf8Ge7z1FllC2yYnkcXSIbpyco1P9BQZG4W7fOfV9PtmP
         q3BhA+gaJfNNxo4XtqLfJRcNpdDb5KUFlJSs5lXxLRthfVI2h/x20P9cYiHHFRDaeN55
         GaKoSCdWGm/Dk393Wob+B5vl3k4XSSgbg9gXgGmsxvMnQcasM6dMo/wrmYQ0oI801/CF
         q2QQQe88S5lvyRTtzx940IkqDJyIwAeH81/nQsAykw3Yfj82YwUWnCdFEOtHc8U8676o
         +2Hw==
X-Gm-Message-State: AOAM530RqMwCtUZc23c69tjyXeOH2wBMx4zMO60IYirZbB1SyONE/iJa
        EDQU4ycOzbKcz2938yJONdtQcQ==
X-Google-Smtp-Source: ABdhPJwMq0IDYFERSTpcx/JHQfuyCQUwIVcQDzUz0AwidBKGfmBDEQHkaeEheqvAmPNFAF7SiQ5wAA==
X-Received: by 2002:a92:cda2:: with SMTP id g2mr1181691ild.3.1624305925736;
        Mon, 21 Jun 2021 13:05:25 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id m13sm6854247ila.80.2021.06.21.13.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 13:05:25 -0700 (PDT)
Subject: Re: [PATCH v3] io_uring: reduce latency by reissueing the operation
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4deda7761d61c189f4e2581828f852c8a1acb723.1624303174.git.olivier@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <82b94c49-b18d-94b2-cb8d-43cf54e402f3@kernel.dk>
Date:   Mon, 21 Jun 2021 14:05:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4deda7761d61c189f4e2581828f852c8a1acb723.1624303174.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/21 1:22 PM, Olivier Langlois wrote:
> It is quite frequent that when an operation fails and returns EAGAIN,
> the data becomes available between that failure and the call to
> vfs_poll() done by io_arm_poll_handler().
> 
> Detecting the situation and reissuing the operation is much faster
> than going ahead and push the operation to the io-wq.

This now looks pretty good to me. I know you had some data associated
with this, would be great to include it in the commit message.

-- 
Jens Axboe

