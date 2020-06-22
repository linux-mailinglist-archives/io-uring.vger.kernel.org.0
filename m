Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5607E202ECB
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2020 05:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgFVDGk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 23:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgFVDGj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 23:06:39 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96727C061794
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 20:06:39 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b201so7787384pfb.0
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 20:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5j5Fzg7GxTVWT9PLRapASOs1dnsZfkItW3BVr/LUrfs=;
        b=AchsNeAm+Q+D6vEvKdsWiuO1NbkuxYh+5H6mwL6nhtgdmVqN0erWQAc5BwR+SkQmu3
         jP8/ydqZe4Q5bvftnePx+6uKlomrRHnWcG5E+9rJyYw9EmWT0YdoyIjajSIure8Gxanj
         7WY0Ox7u8aIc443Or5uYVSV0YuheTRU0/SoqdRl6Zjf7vd7sD/UQs63XthrWWZY8ltrs
         hC9W6wtyAbmBhpHszC2H0pNKpOPPBv+JfsV6RXeoAkzx/mTX0TaLr9F0rScYvDtXRRsG
         ul3dIUKsDVJCQRQksL4PdTIyjONi1aL5TM7Fn+H7NEY+nZJz32fibj1diIERi5/dPWzf
         5xFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5j5Fzg7GxTVWT9PLRapASOs1dnsZfkItW3BVr/LUrfs=;
        b=SNSQflUamhYaj1r+pTDVbskhs8ApRWuQo0DXskLCZIRAN8mhlAnMquLpj+2vmUYU/9
         D2zoubCWOyP0kQmeZXBPylEQXb+qriXVSkCBOO1MXprOC5sR+fp+ojTlc8h6DDA5L5TR
         KjRqgHDl05Ls+vzdwy6fRI1Oq4aSiSnUGhZbjnhCJ0U6uINRESha6pLWdYjUe7KRMiFD
         iya9BLFncJKt9gWEuWh1ijzDKyPYeEkytgqdEixUM6Dy27utiq/xRCTGG1lIIkonAsw7
         tHvMxBiFijMapUZ5/86FYIk7JykaCaKinJKcpizCy6Aa7tEuiq73aGzWp+sSRYkARzdr
         Y2SQ==
X-Gm-Message-State: AOAM533W1IhGZmRILkhAqI1wv9IXbycoYjkc4S+7kXOvglU+kJduYNji
        B6ylHfr+baUQHjIhewdd+Uck8A==
X-Google-Smtp-Source: ABdhPJx3XN7V3Q+CfNeUG7tETqBmj9eCBfnn5Ypn0AnPvVSgX6Ugs9fW0eooPcqBmkHE6Mo1oaF/ZA==
X-Received: by 2002:a62:7f58:: with SMTP id a85mr18844942pfd.89.1592795199005;
        Sun, 21 Jun 2020 20:06:39 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i20sm12575565pfd.81.2020.06.21.20.06.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2020 20:06:38 -0700 (PDT)
Subject: Re: [PATCH 0/4] small random patches
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1592733956.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <722368b0-11b3-90fa-8c27-8555ff5b3696@kernel.dk>
Date:   Sun, 21 Jun 2020 21:06:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1592733956.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/20 4:09 AM, Pavel Begunkov wrote:
> Nothing interesting, just killing some stuff first.
> Based on top of io_uring-5.8 + 15 async-buf patches.
> 
> Pavel Begunkov (4):
>   io_uring: remove setting REQ_F_MUST_PUNT in rw
>   io_uring: remove REQ_F_MUST_PUNT
>   io_uring: set @poll->file after @poll init
>   io_uring: kill NULL checks for submit state
> 
>  fs/io_uring.c | 38 +++++++++-----------------------------
>  1 file changed, 9 insertions(+), 29 deletions(-)

Thanks, applied.

-- 
Jens Axboe

