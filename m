Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07792AA843
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 23:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgKGW2r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 17:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKGW2q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 17:28:46 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915DFC0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 14:28:46 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id m26so351933pgd.9
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 14:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VZS9SuUAzxc7YXAu7JnL/YnQqwM3Gjhv14DelcQ2GMc=;
        b=BK7rGh1sVBA4fhjvbphi50dGpOwjlrvv29AlfyjLL/YCdSwQtlT14jfjZsj1TpeaxE
         64rGM7dE41q90bfYtxMA5lwxsZR6oBFGUjr/osTnBBQao8gIgzjUnFr1FYatSkKy5gIR
         4cgD9TTbWWwA6GMrOotPf4mmnhrYQCajq4OpuuQJNJnlvnvJtm8+DNOX95l4ckPS5REg
         F32ncoBmlU5fXjSLK99qKUcqZDG+pxbxhOY0LK1bxaK/LJbHLsu7JxmQwnjUnEy/n+WJ
         JEKWY8Rr2x6uAxaPklQFkJO2/KJQx4pk248MWN4t8Zjq3w3EC53iv4kZ7lvcySp99mnC
         B9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VZS9SuUAzxc7YXAu7JnL/YnQqwM3Gjhv14DelcQ2GMc=;
        b=JTTw/LlvrusLBP35UR7txbBAkoPs2x7fQcUr0IzGG9pQ0gZ1hZS+b8cPqRcuE+UMAQ
         vszBVC9RMQle3lhkqELcyK6faK7sIy/0W79gQid12KZqNjLROl7oJleF3nJeUoaCIZXl
         zw7Qu2mgBYgg/OpcTMqA6140sYRZ6NuOUaVhyHGtrUMzJQf25noSIxnT3p8lH13jyihM
         1+pmi8FbVO12w0PbWKxifvsHp6Q20o5Ti0Zd3rt2aZKcyTSwvPmmW8dg0v13p4Itbc5t
         m5p0uOo5b8IWYEFiciCJ54lQ1zV1KAkniWg9tIlDJLUKm4Y/H+HnjwzbL7AJfWBdpGgL
         fddw==
X-Gm-Message-State: AOAM531wdXxqVrwLZ8Ro0UcY3Xdgpxjy6qI7+PVwNlOuFTjTa5lW2yAM
        bCZoHUjzeD0fxMOnqAIA1S6uOw==
X-Google-Smtp-Source: ABdhPJxvw9qXP1rJyW9+A6sy/kpxAwTrlc/TVWh8WLKiysd5Y/0qrZ1g1oj6mKRInZLucH5E8B8K4w==
X-Received: by 2002:a62:643:0:b029:18a:b225:155 with SMTP id 64-20020a6206430000b029018ab2250155mr7778739pfg.56.1604788125930;
        Sat, 07 Nov 2020 14:28:45 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t9sm3171142pje.1.2020.11.07.14.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 14:28:45 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: NULL files dereference by SQPOLL
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Josef Grieb <josef.grieb@gmail.com>
References: <24446f4e23e80803d3ab1a4d27a6d1a605e37b32.1604783766.git.asml.silence@gmail.com>
 <39db5769-5aef-96f5-305c-2a3250d9ba73@gmail.com>
 <030c3ccb-8777-9c28-1835-5afbbb1c3eb1@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <97fce91e-4ace-f98b-1e7e-d41d9c15cfb8@kernel.dk>
Date:   Sat, 7 Nov 2020 15:28:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <030c3ccb-8777-9c28-1835-5afbbb1c3eb1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/7/20 2:54 PM, Pavel Begunkov wrote:
> On 07/11/2020 21:18, Pavel Begunkov wrote:
>> On 07/11/2020 21:16, Pavel Begunkov wrote:
>>> SQPOLL task may find sqo_task->files == NULL, so
>>> __io_sq_thread_acquire_files() would left it unset and so all the
>>> following fails, e.g. attempts to submit. Fail if sqo_task doesn't have
>>> files.
>>
>> Josef, could you try this one?
> 
> Hmm, as you said it happens often... IIUC there is a drawback with
> SQPOLL -- after the creator process/thread exits most of subsequent
> requests will start failing.
> I'd say from application correctness POV such tasks should exit
> only after their SQPOLL io_urings got killed.

I don't think there's anything wrong with that - if you submit requests
and exit before they have completed, then you by definition are not
caring about the result of them.

-- 
Jens Axboe

