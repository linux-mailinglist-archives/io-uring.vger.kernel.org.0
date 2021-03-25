Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B420B349348
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhCYNsk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhCYNsO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:48:14 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0537BC06174A;
        Thu, 25 Mar 2021 06:48:14 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k128so1208614wmk.4;
        Thu, 25 Mar 2021 06:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n42OHZSkoKN0hfDvj68uG7nqM7UT51S4VycuDKP/8ok=;
        b=tVwu3NkJfj9TsYdxnaEVqdPdbQTVNEWwQ92x81a6ZGt2LOcPJBDbZ7MV3vNwHStGBd
         nXAaNubGKxHdVxylMKLGuVp2k262xKVC0JfqV+BUh1KPyEqsdbXrImVKxAvuuNuXpXwJ
         WHtiY82DHCRY93oh+1B5V88qCpqKKG6lgO5xdrJXK7KyRRxQy1D6hkWF7wn6QD2uuf3E
         OopH5WBSIxTK2o7wjWuqUL/iz7UvDqhmz8fNPFOEv6avNtAGw/MYqp5ssXeY8hvxDe4H
         Mr/QvjKBt9beMGQ9lHlRsw9eh+D1hg9cNgwqFKgz/z6s/e72yJCTrEh9IyOFUIgEhdBf
         KlvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=n42OHZSkoKN0hfDvj68uG7nqM7UT51S4VycuDKP/8ok=;
        b=nVOGq1MVXb9hmtjYL2veU0H+IfyEVIUMcdRNL0FUsvcL8YfzrnDAjA0QzY876bhFpk
         jivTSeqPZkMrh0xxGh8pZWsYfY4npo2z7EPQvPMQ0nghwkoHya/Ucn2I13T/zlVehmMX
         GUHUd11yDm9xECPv9fDg9SzzXiMhnJGxqYro94sfxIDGndITrt+WokbpWcUywPVTHUB4
         H6OJXvlgPlrHtsSuVFtyUBJx25oQeAiwLal+VRyo6OQzT1EFddxfkmE1sNpgbWt3tX16
         lZv5prdMSzE9Q47FGWV3AhpoUmVHVG39RFDGiYJyQ0bu5rMxV8W123ZIDqEuCMrYr9mm
         7Xgw==
X-Gm-Message-State: AOAM533aRoJgfIl7jacfAQkUGo81cquBfs75FIDG1U7ZogTzCgXH3b6R
        Ek9P0ZeEGlqONTgF6eataNHD//pO8Wb9Bw==
X-Google-Smtp-Source: ABdhPJyADRW1sz9ThfZif/C9OYA5Lx7NSZ4xeX/QQKU1yqho60gAgF2KezuKP6CLa9/NsW+SUNSzrA==
X-Received: by 2002:a1c:e18b:: with SMTP id y133mr8147571wmg.22.1616680092514;
        Thu, 25 Mar 2021 06:48:12 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id h14sm8147447wrq.45.2021.03.25.06.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 06:48:12 -0700 (PDT)
Subject: Re: Are CAP_SYS_ADMIN and CAP_SYS_NICE still needed for SQPOLL?
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210325113322.ecnji3xejozqdpwt@steredhat>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <842e6993-8cde-bc00-4de1-7b8689a397a8@gmail.com>
Date:   Thu, 25 Mar 2021 13:44:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210325113322.ecnji3xejozqdpwt@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/03/2021 11:33, Stefano Garzarella wrote:
> Hi Jens, Hi Pavel,
> I was taking a look at the new SQPOLL handling with io_thread instead of kthread. Great job! Really nice feature that maybe can be reused also in other scenarios (e.g. vhost).
> 
> Regarding SQPOLL, IIUC these new threads are much closer to user threads, so is there still a need to require CAP_SYS_ADMIN and CAP_SYS_NICE to enable SQPOLL?

Hmm, good question. If there are under same cgroup (should be in
theory), and if we add more scheduling points (i.e. need_resched()), and
don't see a reason why not. Jens?

Better not right away though. IMHO it's safer to let the change settle
down for some time.

-- 
Pavel Begunkov
