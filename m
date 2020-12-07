Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B4B2D1464
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 16:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgLGPGB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 10:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgLGPGB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 10:06:01 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAE6C0617B0
        for <io-uring@vger.kernel.org>; Mon,  7 Dec 2020 07:05:14 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id j12so5279648ilk.3
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 07:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=saqhxIp1vSthmWi/XHPJo0WJ5MFvT1+mLeM+8P/zS2I=;
        b=dTRwjAEi/aj5MGjFspoDbg1lAnnwVZyBJNT1baXaklnZcwws58Oy3Hr7233qqJM0fF
         wgx8PZrIQWjG/I5DMMWZbbyT5c7WSJw6s9lvO3rnqc0P/IBpmVhcDIXC2Tt+nA8z5MEE
         rKts2JYcxX/wcOwqz+d2T158vQBQacG0tXk6WxQWdqdSNC9PqBlJq7V2aXzt35o3e58C
         xY7pIKPyscgChoMtAK+5iH9EZn3iQIkstOXtkuC2GpXi+GaBC65dpuIrfdbMLXA6EfRo
         uZpINwQCI4FiUwzE7/TVdep2+MHWxEz8GOE7KuIa22EH2Xw5syN33nupzUooSvLDDC0Y
         o2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=saqhxIp1vSthmWi/XHPJo0WJ5MFvT1+mLeM+8P/zS2I=;
        b=itHLkbao3zF/TQOQ4oQEv/UCkfyENCSC0XNKrQ2XcOfJEbapP7XRsHRfE6xinXdOMq
         omePdHScV0rsofX5B2SCMe7lo00kPj2HQw2Ij6BmBjQ4r673imgs/ugOJtGtK9ypOUhb
         gGZ5P0EbA4b3+pCxwU5Yo4kJKxgp8nOjkUVD6i38nCUPC4gyjbm7gKDAqj2llVAssSL1
         g8/QtclDl4+kMA8aiB1hcFarID1RvUqvou+F/K0xyOCTx5w1jEtw3SX+vw99GpXIZJpw
         j4p9hm2U4cCGdTW1YjfurTsGekdn63AmPAbOSBb67tqMcf9zckVKA/PCfHf4UixSF/bg
         2npA==
X-Gm-Message-State: AOAM531Xo8tolYz9QZPszby3SzldzeU6+xvPrSf60a0pB8SJiciGX+eT
        SxLnywzFS0xT6iiUkdo0Z8RYcw8vofB28g==
X-Google-Smtp-Source: ABdhPJyLQ8DKBxckPYx+mP2htbfex+xYVUc/q4/Oyjgmdqo0DBlzTv/eOvwaS6a31eTJgR0OvFmuOA==
X-Received: by 2002:a92:9f8d:: with SMTP id z13mr21747658ilk.90.1607353513902;
        Mon, 07 Dec 2020 07:05:13 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d1sm6199408ioh.3.2020.12.07.07.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 07:05:13 -0800 (PST)
Subject: Re: [PATCH 5.10 0/5] iopoll fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1607293068.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bb6bd92a-e6be-5683-debc-82c0a2b02a98@kernel.dk>
Date:   Mon, 7 Dec 2020 08:05:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1607293068.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/6/20 3:22 PM, Pavel Begunkov wrote:
> Following up Xiaoguang's patch, which is included in the series, patch
> up when similar bug can happen. There are holes left calling
> io_cqring_events(), but that's for later.
> 
> The last patch is a bit different and fixes the new personality
> grabbing.
> 
> Pavel Begunkov (4):
>   io_uring: fix racy IOPOLL completions
>   io_uring: fix racy IOPOLL flush overflow
>   io_uring: fix io_cqring_events()'s noflush
>   io_uring: fix mis-seting personality's creds
> 
> Xiaoguang Wang (1):
>   io_uring: always let io_iopoll_complete() complete polled io.
> 
>  fs/io_uring.c | 52 ++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 39 insertions(+), 13 deletions(-)

I'm going to apply 5/5 for 5.10, the rest for 5.11. None of these are no
in this series, and we're very late at this point. They are all marked for
stable, so not a huge concern on my front.

-- 
Jens Axboe

