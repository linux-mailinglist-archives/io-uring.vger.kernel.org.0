Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3973E41C361
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 13:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhI2LZ0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 07:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhI2LZ0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 07:25:26 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A398EC06161C
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 04:23:45 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x20so3611636wrg.10
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 04:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WTpRjcVG9uE81gCa4XK7Pzl/UCSFHVFM8ZWJrIK3HM0=;
        b=ETGJA9B0/8qxXvJHiVfj4IQFAQUCzLPFmLYliZgIDykBO8SnI9jp6EZwT01MRoU5Gr
         YdQ44iQzWuhRmVpzNFL/clNa69uGNB7zR0FusK/aJ5sCgrbWy6bry0De77zMUyKuK4IC
         XmcgAyqnTu+mzWsgWwN+hOPCObLM/nN+iCk/sY3W19sqy+aZ1HcW++9iOAz5WGUbgnT3
         OTsCIj2rGjHj8uYSNS6d3ZIRWl5/R/pUU7YnRhzxQoRM/uFCXBaxqnx2A1OOG+UzK54V
         jQso9NkJKfYl++babgf2ONJmzZqoSLgJOF/TQVtu0RxuCWhLMAv+mBeMv6d0rMKoBzUZ
         a32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WTpRjcVG9uE81gCa4XK7Pzl/UCSFHVFM8ZWJrIK3HM0=;
        b=qyK543qMBELGd8HFaGyoPFQsxTW1K31xinY5sR/BJ8dSkUXV2DF1RM7VkEorxd4m/s
         pq6SVry51oSkaSntE4DRF+1bj6uTNeqlJfzFNcxx2/iKuvIUXvY1BYb8YbUju1389VgS
         iiU+TJr1Fuw16aZAQ4TQYmfLF+CgDEDBD9c4hWHioLDEswWxKWrS292zFsY0xMKn7r0U
         bxH4hEQK/qi+mVJfw5WfpTJWUy6vX0NIg1R4XFHh3gcI4jlKAiLXVakSmlpIR1CeGz1k
         wcphkoJF50toy3mqTGo0V7PJOcdD1v1xOQrqLSsLO1/htqndfKagyCNM7Mk85TKAhmrf
         1odA==
X-Gm-Message-State: AOAM5309kooh3aWJHDnhgdeoDkoQvIaYhvit81Hxv+iCJm+LHqIK2aWj
        H6MY9+LpGzTd6QPuX2WzNyY=
X-Google-Smtp-Source: ABdhPJze7dqcCRGHuKbosUOsaVTEG/vhiOMuYmG0Kwiz8D+g1psHVJkMgigHK1pxQtbGTB3W3ULVVA==
X-Received: by 2002:a05:6000:15c4:: with SMTP id y4mr1723800wry.177.1632914624294;
        Wed, 29 Sep 2021 04:23:44 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.229])
        by smtp.gmail.com with ESMTPSA id t126sm1330126wma.4.2021.09.29.04.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 04:23:44 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927061721.180806-1-haoxu@linux.alibaba.com>
 <20210927061721.180806-2-haoxu@linux.alibaba.com>
 <ec45dd61-194b-3611-dcd6-2a5440099575@gmail.com>
 <140f1e02-d400-b6c7-5c78-5eab6ac23f24@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/8] io-wq: code clean for io_wq_add_work_after()
Message-ID: <c36701dd-6982-ee73-ee07-7d71f6c531bc@gmail.com>
Date:   Wed, 29 Sep 2021 12:23:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <140f1e02-d400-b6c7-5c78-5eab6ac23f24@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/29/21 8:36 AM, Hao Xu wrote:
> 在 2021/9/28 下午7:08, Pavel Begunkov 写道:
>> On 9/27/21 7:17 AM, Hao Xu wrote:
>>> Remove a local variable.
>>
>> It's there to help alias analysis, which usually can't do anything
>> with pointer heavy logic. Compare ASMs below, before and after
>> respectively:
>>     testq    %rax, %rax    # next
>>
>> replaced with
>>     cmpq    $0, (%rdi)    #, node_2(D)->next
>>
>> One extra memory dereference and a bigger binary

>> wq_list_add_after:
>> # fs/io-wq.h:48:     node->next = pos->next;
>>     movq    (%rsi), %rax    # pos_3(D)->next, _5
>> # fs/io-wq.h:48:     node->next = pos->next;
>>     movq    %rax, (%rdi)    # _5, node_2(D)->next
>> # fs/io-wq.h:49:     pos->next = node;
>>     movq    %rdi, (%rsi)    # node, pos_3(D)->next
>> # fs/io-wq.h:50:     if (!node->next)
>>     cmpq    $0, (%rdi)    #, node_2(D)->next
> hmm, this is definitely not good, not sure why this is not optimised to
> cmpq $0, %rax (haven't touched assembly for a long time..)

Nothing strange, alias analysis, it can't infer that the pointers
don't point to overlapping memory, and so can do nothing but reload.

__restrict__ C keyword would've helped, but it's not used in
the kernel.

-- 
Pavel Begunkov
