Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBEB3520BE9
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 05:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbiEJDYx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 23:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbiEJDYc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 23:24:32 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A3D153533
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 20:20:35 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so1010608pjq.2
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 20:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mQHHt5lg56fSxzdBMZd4geLX/vK//784qitg+aFgaAY=;
        b=wUSbuyJXbZgbIc+ca51P9kYQvnBCc3dbZdRNHgU/7LvQmGLKH5mcamGBN6EbZuas8V
         M9o9NI2d4v+LQ64NwreZ0RPMjqkKucN0J4OIITWzVGq1JZ76y0PjDR1zQBvqIh35xq8r
         W9TF5T7wKZhrida+fVOWKvCYCiQUq4dm+a5Kz6QyZHw+TvRxz0J8NO9tjiWN+n8rWxro
         /q2/BIeZsAOazqWpLWIY6WrWnRweXr+JYp3D9l93sqMMfQbzw4XLvmyMd8aht8j/XPH1
         e4L0HG2TvWMwHvObXMnuEI4SsvRvM819/UI+DZgHnsNaoqBeH1e2ly3aV5/v8Qh76gxr
         QChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mQHHt5lg56fSxzdBMZd4geLX/vK//784qitg+aFgaAY=;
        b=69HynfqSqhUX2ufSQPImKVPI920+BVuU+1V2YNku1YM3C3zCvwsnxeFkyNy79R9+mS
         wvaYb8/MXriEyQGD0ItnfN23lN0XVJKn0nVbQ8WMTlqu1eUxmrCS0P/lrsxCXgW1qB1y
         xBm3dBpEhMt9dR6ceTi1n3+GIa9O2Kuwh2wsE/Q7gZpzpjK0ks3n1iahz0IlMRU/QC6S
         lemeplJfHA4GELcvYIqxHr5oRbyqHH9PY1gMaOjegKmqeymeBT/l2yyZnj9OuEizOARd
         OVibxikz69nMnu+x5AEvzXdqim9ujUCg2t+VtLTaTMlqRzlCiCJhYY/MoLRHGI44LtfB
         gonA==
X-Gm-Message-State: AOAM5310keHLMKFwsNFjDtLAONqtpmXMqfHQM5I7/J+TkzNQuT7+sM4E
        VF55yZDG0qoote/j+mBmdV+HOQ==
X-Google-Smtp-Source: ABdhPJxYdrXvHbWQn06mzqssrz4HtsTnOZBCzGM+0sMCKTF5maRGxOSE9C39fK9hWf/JgCBp/Km3Tg==
X-Received: by 2002:a17:903:1111:b0:15f:7f0:bbf3 with SMTP id n17-20020a170903111100b0015f07f0bbf3mr10185858plh.12.1652152835260;
        Mon, 09 May 2022 20:20:35 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v9-20020a1709029a0900b0015e8d4eb24esm661286plp.152.2022.05.09.20.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 20:20:34 -0700 (PDT)
Message-ID: <ebcb3dc9-4241-0cc9-e24e-677ae8db71a7@kernel.dk>
Date:   Mon, 9 May 2022 21:20:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/4] io_uring: let fast poll support multishot
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220508153203.5544-1-haoxu.linux@gmail.com>
 <SG2PR01MB24118EC72D64732E308F6061FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <SG2PR01MB24118EC72D64732E308F6061FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/8/22 9:32 AM, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> For operations like accept, multishot is a useful feature, since we can
> reduce a number of accept sqe. Let's integrate it to fast poll, it may
> be good for other operations in the future.

This, and 1-2 look good to me now.

-- 
Jens Axboe

