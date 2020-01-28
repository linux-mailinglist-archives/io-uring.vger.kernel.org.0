Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64EFD14AD1C
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 01:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgA1AWF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 19:22:05 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46886 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgA1AWF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 19:22:05 -0500
Received: by mail-pl1-f195.google.com with SMTP id y8so4368303pll.13
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 16:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Rng1ZZuvnh8skbUMKVNeE9hX7pU77/13sjNLkfyNJKs=;
        b=bQZ14tH+SvMsGr4XVN84bRypOLPGFqyhXA5d8ytE4IUggWVBPNg3EQ2kZPF8IsGU0v
         1BIrieFe3LovX4i4CObrM167FaotJXLpvAnwRgUWmqy9EExGcYHyz20aXtgoT9ui0zmB
         HILLhuuYadGPV3GX32cuEv7V3eZWdq3ScpBsfq2aUXFT5s0WAKipkVgClzfXKPFW7ZQ1
         E7IkR4C1vuKD63+JsyTsuFLQ6Wg9VHNBy8cMa9jVZ3Z+JjBegd+R4OEOC8SbjMV8c4g2
         hp9i7x77GdVgj+2oRy6prhMmozEQMWgMkAegVCTpT+WbCBwbkQ0A4h0MYt+naLzMsfmt
         zt+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rng1ZZuvnh8skbUMKVNeE9hX7pU77/13sjNLkfyNJKs=;
        b=WDD1qZp/E5A3XcRCDqOOuNh3yktjOKl4Ze8c2rGBAYR8coPbxkX49LVfa0zHqKZr1Y
         uRVcCIiBuqkB+lzZ57Q+qD6bpLTXTHj5oDAE6aeE+c7w/rt6cUpZvK31I1Hx9v3L/wBo
         abA5dy7/7qHrkViUYNDK/QpjOggUHw8tkQQrZb9QPLjDFSyvOmJkTxbIB7dlO80t7rZ+
         d+1ckXBzKpc4XNi6TrgaJ388P8h6PMbV8MCvCtvgqlgsrG5Dj2MqU6dbNUTWmM56AKIC
         4wcgogDplNHlPvvXbU+MBCiSGARNflsP0rpO1hTcA5OoqsVRvTkyCEVu5yvQc4oLNALl
         hH0A==
X-Gm-Message-State: APjAAAX4necletFbYq8uH4Eg5wiogMVSGVQdwB8vF6cqNcMi7+wMHPMg
        Ma++ihGEvpJZ1VyZbIYbnd2zrw==
X-Google-Smtp-Source: APXvYqygNN/9n/tShBs+tuNBRXauIWs/uvVsnHr+QNjy4aBJsI33lz5qlXFQc+bK57chGHkYtTbq9g==
X-Received: by 2002:a17:902:b587:: with SMTP id a7mr20391881pls.155.1580170924370;
        Mon, 27 Jan 2020 16:22:04 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e2sm16899550pfh.84.2020.01.27.16.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 16:22:03 -0800 (PST)
Subject: Re: [PATCH v2 2/2] io_uring: add io-wq workqueue sharing
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Daurnimator <quae@daurnimator.com>
References: <cover.1580170474.git.asml.silence@gmail.com>
 <c40338a9989a45ec38f36e5937365eca6a089795.1580170474.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <86c5b26b-ae03-01ba-8735-ee37647b3d48@kernel.dk>
Date:   Mon, 27 Jan 2020 17:22:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c40338a9989a45ec38f36e5937365eca6a089795.1580170474.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/20 5:15 PM, Pavel Begunkov wrote:
> @@ -6577,7 +6613,11 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>  
>  	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
>  			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
> -			IORING_SETUP_CLAMP))
> +			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
> +		return -EINVAL;
> +
> +	/* wq_fd isn't valid without ATTACH_WQ being set */
> +	if (!(p.flags & IORING_SETUP_ATTACH_WQ) && p.wq_fd)
>  		return -EINVAL;

Since we're now using file descriptors, this no longer works. Any values
(outside of -1) is fair game.

-- 
Jens Axboe

