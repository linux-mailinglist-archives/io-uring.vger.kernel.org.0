Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8683341004C
	for <lists+io-uring@lfdr.de>; Fri, 17 Sep 2021 22:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhIQUa3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Sep 2021 16:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhIQUa0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Sep 2021 16:30:26 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B00C061574
        for <io-uring@vger.kernel.org>; Fri, 17 Sep 2021 13:29:03 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d6so16992781wrc.11
        for <io-uring@vger.kernel.org>; Fri, 17 Sep 2021 13:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u7t4l61YDZzUYy12lcL2C+uTxYUjmBQVk0HnhepGPWs=;
        b=WvBJqb7vDS2yzt8QuRlZh4hrzNsY4+H+rfpKuMuNNVddpqmYB0EPRe1vXzu/t1O6+t
         3h/QZA6W+XxmFxUX/Z2jmUIIHweMMPba0Z/vEpYJEkouKwKJwonTZD7LY1OgN7GCeqgf
         2QZoOR4hkUqvcC6lShLlfGkRyi+gR7/aJd9DnLZEeBJw524UXITsj35FL/0VHaOP85TM
         LyVytIPDtOWWG51YqQM+Qtlxem8fXy8oapoVSlDSpEPfDLZqF9S8jyRk8poHJhLIotU9
         F9QOQJ/r1VvjbHMT5H4nwzHuCBXShDFsEg2wRsihqt7W7PmX7xoWvSpRedaM5EE+rUzN
         zNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u7t4l61YDZzUYy12lcL2C+uTxYUjmBQVk0HnhepGPWs=;
        b=gBYad05PC9ijIbI1WrP5OrTnUWwMDh485dFnZRjccMZbJhJj476tWR3QcTWJgf5ukt
         pWgY+j9WZPJPWsBAkAMt3TJs2eW5YE/sLF5EsavTilG5wRWZppwG1P5zvNd93X1apiWe
         Qz51EWERlRt1s/nSX+TbzA5ZRn8/tMTEMu+NH9T62SvWN051Yi/Vt2lwgNCX40qXQmg9
         esmpVxcYdYXEUyM499t0zxEv+pVqZJ/Y5rGnpl0JuSRohOBeAO4BZl74er4xmhTUT8s+
         A8JWBDSY+grOkYWB8+LXjEcp6U25dewO3ZEGPxHSPQpSmSBP66S787kxD0NL5PO4zha2
         GaEA==
X-Gm-Message-State: AOAM530wetYXx51BhWFTo0uuUlUo7J4jxRwjDuM9qCN/wnSwBrkzEhM0
        JkiS7AGEjw0W4dOm969AMeT7iu6gA/s=
X-Google-Smtp-Source: ABdhPJywHn34GyBs86WILH1+hjLjozLq+3Kgpu86Tl7mXFvGS0fTDqY04pX3D78UflODi53VQHuKMA==
X-Received: by 2002:adf:82a8:: with SMTP id 37mr14422519wrc.409.1631910542160;
        Fri, 17 Sep 2021 13:29:02 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.235.54])
        by smtp.gmail.com with ESMTPSA id z2sm7116967wma.45.2021.09.17.13.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 13:29:01 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210917193820.224671-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC 0/5] leverage completion cache for poll requests
Message-ID: <47a76406-04c2-2140-5703-1305a84dd57e@gmail.com>
Date:   Fri, 17 Sep 2021 21:28:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210917193820.224671-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/17/21 8:38 PM, Hao Xu wrote:
> 1st is a non-related code clean
> 2nd ~ 4th are fixes.

Looks only 3 and 4 are fixes. It's usually a good idea to send
fixes separately or place them first in the series, so can be
picked for-current / for-next. However, 1-2 are very simple,
maybe easier to leave as is.


> 5th is the the main logic, I tested it with an echo-server, both in
> single-shot mode and multishot mode poll, not much difference compared
> to code before with regard to req/s. But that may be resulted from my
> poor network knowledge, feel free to test it and leave comments.
> 
> Hao Xu (5):
>   io_uring: return boolean value for io_alloc_async_data
>   io_uring: code clean for io_poll_complete()
>   io_uring: fix race between poll completion and cancel_hash insertion
>   io_uring: fix lacking of EPOLLONESHOT
>   io_uring: leverage completion cache for poll requests
> 
>  fs/io_uring.c | 70 ++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 53 insertions(+), 17 deletions(-)
> 

-- 
Pavel Begunkov
