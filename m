Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB9225E93D
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 19:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgIERNT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 13:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgIERNP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 13:13:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A78C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 10:13:13 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id m15so1458902pls.8
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 10:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fr02xtaW5vQFTSyUSAkIKOs1nojRj657NMpf/PMNgYA=;
        b=Zsg0WLqa5+5E4A4pywba7SprCUyrIM6w13PxhT+Cmo6CMEr5eiPqVU8Qvi2hjrbk9n
         KGX2BS+A9k2isx+2o3orZ08izD2P1I9GmrSYbWxSGslXx+cQgf6/LcZFJ6I5vlNT+uKX
         df09Pncfyr0lkd0ZkhaftV3sQQJF0Vx3lCJ8Tu4eBMWgK/OSpBY5sAFE88TLFD6DgcQT
         1btrTDAfL3vcMmGJwV4/KQAjkQOlFkOuHsRLkV2zc2pZxTJkJjxQPHQPw2v64ZA9Y58t
         baxvrNRjSvOEJq0jaeTHZPAal+6dWMgWsPxEu3m8KLNI5YYR3ShfZjhQpvLyzQg9BUZA
         fBPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fr02xtaW5vQFTSyUSAkIKOs1nojRj657NMpf/PMNgYA=;
        b=O1URGbzcSs8LFBAnw27wgEmlejZuzTEjBiS5ow8pVqpmA9PLl7QPZqMlrbQpB3bzR4
         2Hy620LlNP01KmyiwfquJgNtOR0V75AM3GyVO2Y5sW66twmq8wP5UpE+ee8JFEQs67La
         J7ENEJa24kxqy1E6EdWw30jA0wGgRXVsW1PBQ+HgvunhjXZBV1/egZv7YZ9Tf82qWoMv
         FV9dMR4GX//aLXz710PRZxLMUfSmQKqL2QvDox2CeB9DnQ/OQ4UKVXpdCd9ftBr7jXE6
         imvIs1LQOXgS7LHLX/WmtPxPDAYlJ9cVJoKGMacJwpNIfl8PDTGp+VKZ3qVebIT4PdKy
         sr2Q==
X-Gm-Message-State: AOAM530URNFj4+zploA79hAIdtqxeCiHs/345LpYUue7D3xXhK8ulBKV
        H/suwUyilatF10rforgggosSDWwo0bp7Poof
X-Google-Smtp-Source: ABdhPJz63cf7K2G6+/SZYdbTbIQl84/NgeItZvoW3tSG3CCCgDyZcUKFk82IhUDAehBJJOoDhPnxDw==
X-Received: by 2002:a17:90a:8a04:: with SMTP id w4mr13109422pjn.72.1599325986084;
        Sat, 05 Sep 2020 10:13:06 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u63sm10400126pfu.34.2020.09.05.10.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 10:13:05 -0700 (PDT)
Subject: Re: Support for shutdown
To:     Norman Maurer <norman.maurer@googlemail.com>
Cc:     io-uring@vger.kernel.org
References: <0b53b115-cb97-bb84-6419-9e6e6b5f251d@kernel.dk>
 <C500A9A0-F9E1-427F-BCEC-04CB8D9F252E@googlemail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bed96154-382a-0910-3012-9fb0f149f3b2@kernel.dk>
Date:   Sat, 5 Sep 2020 11:13:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <C500A9A0-F9E1-427F-BCEC-04CB8D9F252E@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/20 11:12 AM, Norman Maurer wrote:
> Yes in 5.8 branch would be the easiest...

Alright, let me do that.

> You rock!

Aim to please :-)

-- 
Jens Axboe

