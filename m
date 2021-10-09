Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDE6427A4E
	for <lists+io-uring@lfdr.de>; Sat,  9 Oct 2021 14:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhJIMxi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Oct 2021 08:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbhJIMxh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Oct 2021 08:53:37 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8EAC061570
        for <io-uring@vger.kernel.org>; Sat,  9 Oct 2021 05:51:40 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e12so38364621wra.4
        for <io-uring@vger.kernel.org>; Sat, 09 Oct 2021 05:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=r8qryfQDC3YU6JCTF1iR8Bdtl9jhLns8YTgOaYuUE2U=;
        b=JmY9/6ggMRPLblhSbh5Xa/HJncdNT50bJGSIrmNSF1wzmLhRb+l8fwGBdSotBTwWch
         hi3ckkFX7fd3rElP7d+k8XcZGo7BMyX9R8/UE3Pj7PpJsoP0oQ+StFVVEW/Ch0hD5m+/
         WJUATEaYHNkfWXhyqq+NSHQoCo/ccXfVJvgHublRikIpgcVTRcyDp1h8N78osV68vwCm
         RsM6TShGga7XXBAjT8bbC9+mAZYu+hPTpW/bs5++dVUzO65vLv75qG5VrYpoZVHho0hS
         w0yp675wyzaXOL9oWbu1/rqS8U6NDPPSDbNBMOYStRgZ0hvAo0BcpjV5b7NJygkSZhHl
         I/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r8qryfQDC3YU6JCTF1iR8Bdtl9jhLns8YTgOaYuUE2U=;
        b=6aDRkLh95c0oVvwmNZ68TZOdPHQEn5XS0czRE3FaQKlmUTsfqOjqH+eyojXSXumGob
         ntBInyFPks688Eic6g8lSYsVYT+rPMzBnCcoEPx43EiCXH6wDdC6SMTTWXSMsCgRojQi
         xoXvv0KC/kmGG3YEkeK2gKlcBXDzyVRJm4J65GHBXiljc8HmVBMrENNvSlYjVGMe8fU1
         oXn1qdEHlks7Vfh87LCfpQ4osnWNSsbAL9N1KBMfP7EOOQAk1YYbyEnrXyDxo8MJvt43
         ObOww2SWA6bZThFHN0nREbAwTNTTKNHT0LomlCUzEqYpi7E71jmz/ffgFe9x5nsRgFgx
         b7Gw==
X-Gm-Message-State: AOAM530j0ZZCg+Fy3LE5IzfB0m6sINKIy/Gxv+cy4ap6Fm5TRBX6/Myl
        x1gw2Qfhvpnn69Dw7f1XNu/ZzkIfQAE=
X-Google-Smtp-Source: ABdhPJzDExudN5TtfrC49U5F6ltKmBbTvhGfIEF2nPxFyeiRNVZ+YN/JfKrulJ7+FZ5Zr8iCbqzLCg==
X-Received: by 2002:adf:f247:: with SMTP id b7mr10763183wrp.283.1633783899514;
        Sat, 09 Oct 2021 05:51:39 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.155])
        by smtp.gmail.com with ESMTPSA id o12sm2208876wrv.78.2021.10.09.05.51.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 05:51:39 -0700 (PDT)
Message-ID: <57f4b76d-6148-98e2-3550-8fde5a4638f7@gmail.com>
Date:   Sat, 9 Oct 2021 13:51:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH for-5.16 0/2] async hybrid, a new way for pollable
 requests
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211008123642.229338-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211008123642.229338-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/8/21 13:36, Hao Xu wrote:
> this is a new feature for pollable requests, see detail in commit
> message.

It really sounds we should do it as a part of IOSQE_ASYNC, so
what are the cons and compromises?

> Hao Xu (2):
>    io_uring: add IOSQE_ASYNC_HYBRID flag for pollable requests

btw, it doesn't make sense to split it into two patches

>    io_uring: implementation of IOSQE_ASYNC_HYBRID logic
> 
>   fs/io_uring.c                 | 48 +++++++++++++++++++++++++++++++----
>   include/uapi/linux/io_uring.h |  4 ++-
>   2 files changed, 46 insertions(+), 6 deletions(-)
> 

-- 
Pavel Begunkov
