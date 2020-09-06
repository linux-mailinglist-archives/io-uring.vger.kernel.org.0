Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDAC25EEEA
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 17:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgIFPti (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Sep 2020 11:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbgIFPtc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Sep 2020 11:49:32 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F381C061573
        for <io-uring@vger.kernel.org>; Sun,  6 Sep 2020 08:49:30 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w186so6828710pgb.8
        for <io-uring@vger.kernel.org>; Sun, 06 Sep 2020 08:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dScgpaT6CC8/WgbB+0rm/1E5SPfupvG5RY7iu3C0yXM=;
        b=k3TXnKn2X2V2XDoeCR6eB5BYjsUJFSf7HNbDEt/rJbKZVOFfCeIGz1y7z/m5G3iHLp
         0GmVi7LCRvJFSf8w2t+WxXfLu1OKeufw/5fUZ6Ev1ITfn3wWKPAHTAIEcEXOTnNvMv0F
         SSB+yijxLJqK1QX6pVKMJTLFKoT9TCbP+3HPXWhZj+ywLITtsYfXWOH6ypq5NHveK1n6
         bd/PrDYMw9CIm86zMwiGlqRWsHLMxZZfmD9vru1b1COATRtCAMKg6DstjEjDxMSfsiCI
         3jiXSsfNB2g+jXIolw7fUbbeT0xBb3qRYuY5i/FSvapKXxcJnFUKZGYs0VSWWrZjc6hI
         n2EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dScgpaT6CC8/WgbB+0rm/1E5SPfupvG5RY7iu3C0yXM=;
        b=VIhLAkCvncqKrqY8xczpOXJ71XLJCjFFGG7LsXSCsPNB8GFb12KsUzX/mpJNVaLpAb
         F/kKfDov/xZg5gZznbws0lLWsdoU7SxfizcaWx6ZIxSzGHjptMLA7v1Ga4wE1ZYYU+SF
         HDVcabflEMgkYbwBGwiZjokJzyfALQNy3ygavSXyO8Su7SUYkAJ9yhztvXtz63q6d0zi
         tCIL8gODh5416TYuKNnYkHu6mGWPSUuMSkVr2Jm2tLhhwua4U9dmM4Bnvve3MFlloF50
         SNKYT1gGG7pWviCgLA7QvJCzoj+zy8ZILt0ZhXULUO07+LzPNdY8h58GOn0yLLGO01/j
         kZbQ==
X-Gm-Message-State: AOAM532NN1VVHrsvlLqqGRevH3YsAYDStCbhyP72lFvDdvwXmmMMddPk
        mgExwDhBiQrGzwqc1MdSsJ5F98ZiAxgDAWSO
X-Google-Smtp-Source: ABdhPJxrC1IA9x+PwHwEFVuLVVVQAh8/w130ZxFQeiDalk3uxemqI8laRygHgVWO7HpMgPGkputbng==
X-Received: by 2002:a05:6a00:8ca:: with SMTP id s10mr2512781pfu.30.1599407368340;
        Sun, 06 Sep 2020 08:49:28 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s129sm12474898pfb.39.2020.09.06.08.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Sep 2020 08:49:27 -0700 (PDT)
Subject: Re: SQPOLL question
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk>
Date:   Sun, 6 Sep 2020 09:49:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/6/20 9:44 AM, Josef wrote:
> Hi,
> 
> I'm trying to implement SQPOLL in netty at the moment, basically the
> fd are registered by io_uring_register(2), which returns 0, but the
> write event seems to fail with bad file descriptor error(-9) when
> SQPOLL flag is enabled
> 
> 
> small example to reproduce it:
> https://gist.github.com/1Jo1/171790d549134b5b81ee51b23fb15cd0
> 
> what exactly am I doing wrong here? :)

You're using the 'fd' as the file descriptor, for registered files
you want to use the index instead. Since it's the only fd you
registered, the index would be 0 and that's what you should use.

It's worth mentioning that for 5.10 and on, SQPOLL will no longer
require registered files.

-- 
Jens Axboe

