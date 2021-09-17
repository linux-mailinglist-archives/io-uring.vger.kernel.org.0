Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31BA410054
	for <lists+io-uring@lfdr.de>; Fri, 17 Sep 2021 22:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhIQUlB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Sep 2021 16:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhIQUlA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Sep 2021 16:41:00 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6822AC061574
        for <io-uring@vger.kernel.org>; Fri, 17 Sep 2021 13:39:37 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id t8so10093695wri.1
        for <io-uring@vger.kernel.org>; Fri, 17 Sep 2021 13:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OA44ozdCQtCe8e3KM8FJZhTpiav36okgw5ezlYQQ/A8=;
        b=o0mzxt/Pcov9gQKaUoQOpYWRLLcdtQzUi4KcJPEPvAL8xGSGSCLl/uSiK9/fjDVVKf
         mZj+6B5n9ayABGAJYVCdWazP2FxKXftTBFOm3ir0ouAEBE3dOW4QkeRbQqnruUsnklLx
         xHBqgF55g/IHqU8K82wHrHJx0hHzsZaX12XO8gDK6hCgvo9NZN1j71eV3vkBoLMAnAVT
         ZGCRYiK/w2W+FwCKUR3YFrg0VboPQwkOcH+e6gdZ5U8xPw+mNP8ulXepNcVthERmp69s
         OKaxFont00n4kPqy3/mN0imHoEDK+sDaG2xOtCngjpwWKEQAbj+xFadSro3ExFvEAPfu
         VdpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OA44ozdCQtCe8e3KM8FJZhTpiav36okgw5ezlYQQ/A8=;
        b=7xHPAyoZHOuCH/41nMpPl+8KXIB8nmICf8QFJ7pb2V/9ejTNum19fQOJ8bgsHdaGw7
         fK7L0WtqZHqNZREGgCLgyS8SXOD79qPw0LLKRblUNhIdwS6xiJS8zN7KF8oigbFP+UGR
         JZle+gBrn1BPF56MrTEXljBxzTW5nxJd/dGhfOrzXLzecMhiPaAjXgT9fLDgm5s7kh81
         PNhl89voN/lNva4K1mnDf4qohZiNKhDKc8B+SDOY97k9rrBNZuxmven+KmzzK8apKK+7
         SysP/UAlZQZNAEJ+TJpq4LkxNISYyGBL+U8hFELPBkWTYYew1dn93lkRNsKdCztiJsmG
         2ROg==
X-Gm-Message-State: AOAM533Y3E+oCQHGJKVxfUj8DLFrAIbPJuSnuKcWtUMxdenrfF//7bAf
        RgOnyFswFM5QBO1aCtfpcsI=
X-Google-Smtp-Source: ABdhPJyxBNcZYhPN/5PGqqFGgEeKvW+SOVh4d+TmwIFMUIFRRjvMIzZnxLeVQozVEVrcz+Jtieq13w==
X-Received: by 2002:adf:f24a:: with SMTP id b10mr14689854wrp.281.1631911176000;
        Fri, 17 Sep 2021 13:39:36 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.235.54])
        by smtp.gmail.com with ESMTPSA id p6sm7540087wrq.47.2021.09.17.13.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 13:39:35 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210917193820.224671-1-haoxu@linux.alibaba.com>
 <20210917193820.224671-6-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 5/5] io_uring: leverage completion cache for poll requests
Message-ID: <fe379c0c-0eeb-6412-ffd7-69be2746745f@gmail.com>
Date:   Fri, 17 Sep 2021 21:39:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210917193820.224671-6-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/17/21 8:38 PM, Hao Xu wrote:
> Leverage completion cache to handle completions of poll requests in a
> batch.
> Good thing is we save compl_nr - 1 completion_lock and
> io_cqring_ev_posted.
> Bad thing is compl_nr extra ifs in flush_completion.

It does something really wrong breaking all abstractions, we can't go
with this. Can we have one of those below?
- __io_req_complete(issue_flags), forwarding issue_flags from above
- or maybe io_req_task_complete(), if we're in tw

In any case, I'd recommend sending it separately from fixes.

-- 
Pavel Begunkov
