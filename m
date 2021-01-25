Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3706304A38
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 21:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbhAZFK1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 00:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbhAYQBV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 11:01:21 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819EFC061786
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 08:00:39 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id q20so8615063pfu.8
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 08:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cQSZGF9GtbPNzLiBjYDeS50p+XebIjyKYhk6QYbErts=;
        b=u2rn3zoahQCY/nN7EyyIG/aSkq6v1KZOE4XVgX07pIOUJ3K5nHWFmpCewJ2jVx0d8t
         J4qfXY18ST1AOoNuXGemPidWHWLIu5Wti9kpFrSM0MDa+FhBh0rpJoaBMaQdEo+IwFdR
         ksqbPiLaUgwSs5VorAS8Lpe1aJg1eKcQLdaRydch1R9rekEA7VVaPJaQvbTWp0L/XcFo
         VhSZui0iiVHbScts9FakPeX3n3u0b971WDCc0yvAJllkHVFoY3mHH/x7HVH007Zb6JmU
         BzaYXRMaUZaLZkwrWAdtKEtq4zXA6zZ22XiN+0pPysxd7NST3DiTjBOE4vNnrZ32Rkww
         2+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cQSZGF9GtbPNzLiBjYDeS50p+XebIjyKYhk6QYbErts=;
        b=UdcDh23fLkXgRK1byVGEsxhNZiTJszUeAAFWPJ1aOQw/WLtkjRYU0sdCXXnEHHVMAJ
         1WfcVIKvw23Xt8jASeaFe8K75dMmHzNrFZEHO2oWmhFDkfwqqAOOM3Kz6ic+gfYo0W3y
         ijX1EZgqBcgDVjgerJ550KZvMqDQzVCKw7K43N7aLS2E7MuBRiPw8jeARHD3HvMn1V10
         Ehyh1i54OX2In1bqApvbaq6zkfyUmvMGSLO02QRBl8IlfF3XWsElLFsRxwqMbegWpUVd
         rqMroYTgc5D679MYocRjdePtF06enFAzUr78ldrmKbeXYaOPsnU/8b/KnZiiTHSXtskY
         YTzg==
X-Gm-Message-State: AOAM5301Z40KqAy+N+Lm+E8bXpvyEBROCcyLy3e+ZJBM/4z08+80OD8q
        Hg6qaCutfGqh0xAbwookSuChza+jHBCQ1g==
X-Google-Smtp-Source: ABdhPJx3RyTOCXNuwtPZEROBJ/q/WIf07BCmq8SNRVlAay/r99Y6aLUfM49Tn6ueOwfSDBoG0ON0wA==
X-Received: by 2002:a05:6a00:2385:b029:1b6:1603:4ea3 with SMTP id f5-20020a056a002385b02901b616034ea3mr1170872pfc.40.1611590438694;
        Mon, 25 Jan 2021 08:00:38 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id y11sm13696181pfn.85.2021.01.25.08.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 08:00:37 -0800 (PST)
Subject: Re: [PATCH 3/8] io_uring: don't keep submit_state on stack
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1611573970.git.asml.silence@gmail.com>
 <dc52b7b5761ad78f0883ec7ca433c0a8d7089285.1611573970.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d802eb6f-f491-d35c-f556-c7d0285c6974@kernel.dk>
Date:   Mon, 25 Jan 2021 09:00:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dc52b7b5761ad78f0883ec7ca433c0a8d7089285.1611573970.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/25/21 4:42 AM, Pavel Begunkov wrote:
> struct io_submit_state is quite big (168 bytes) and going to grow. It's
> better to not keep it on stack as it is now. Move it to context, it's
> always protected by uring_lock, so it's fine to have only one instance
> of it.

I don't like this one. Unless you have plans to make it much bigger,
I think it should stay on the stack. On the stack, the ownership is
clear.

-- 
Jens Axboe

