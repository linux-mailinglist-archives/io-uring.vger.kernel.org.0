Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD10621CAC4
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 19:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbgGLRgm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 13:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729289AbgGLRgl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 13:36:41 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B265C061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 10:36:41 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id l12so12112189ejn.10
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 10:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nJeiS2fvbJxrOX6dZR5qEjeMjIfurTPb0Yqen9QjHhw=;
        b=RbdxW4n992Mo9D2bFbeP4N+aGfGjEGstII4MaXEVvR2Ztbvb0K2WUXFai61o787319
         W/NcgRyG9aI18ULxoMgxnRUPsQfmmRp7PEdbP90t+6VQKRQznR+KhWs1yqnZfxfRdSoK
         MJDjKOvLUL4t5SsJ04JJfg4gkU4mjkkAeQzJO59UEVzA78y+BoPdpba7lLI8QA45iaUR
         5VBXFc+0DIMwWI8wLr+cQw6p5TvICnK+IuI6ZN7jDNAQYmUt4JQHu3pR/lRdOjN1QB8S
         AHX7/p4fiVzKnCakR+FvUcYxeMWc6MweqJA7xkwLQA1v/O53uT6h3oLNDJlWvjq2Y83X
         PTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nJeiS2fvbJxrOX6dZR5qEjeMjIfurTPb0Yqen9QjHhw=;
        b=tupYJYJXheySmL2tk8P7k/EtzNc/8HMhCWkOJ+tA7nDkzJhodrm4Cz3BuuVSygQ+yX
         mTYHKOF+zBKGe9yOChs8+A42ZzZ9fI2xY4Ca/OdFIO8xZX4CqVk4mtnuMrt4BvmloRoD
         EmIZsx6sX489FvGQQB4k78eYsOSqxGQTQhEApN8tQkB8Th2OTCy1wLXZIXRd2stM+Oto
         TdWskrVAAMcDjPy/yZ3IhboiVRXJCJoNBLb1Da2jmmLiIQix2bAwpJVta/OHGyEL73fV
         +ZMPjUI6ZtivAlx4/9NWCh1D5dugMIQAnbBO+4bNasPObPbuQKIrBm3R1pvc4MCdL2AZ
         Mv8Q==
X-Gm-Message-State: AOAM530jCZu+v7gj9rmrGr039AsY1SBgw/rpt8MyzopBXuXBcKjimgOD
        k9Iq/TnUoCYd8nYLEc6bGcl9vGkU
X-Google-Smtp-Source: ABdhPJy5MBOaIt18IlEW+W8KzQylTjoRYe+yE4HGOOG7pU29rV3VFNoHDk9feDVcW9gdOrb07WlY1w==
X-Received: by 2002:a17:906:eb93:: with SMTP id mh19mr68446071ejb.552.1594575399606;
        Sun, 12 Jul 2020 10:36:39 -0700 (PDT)
Received: from [192.168.43.17] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id s18sm8224139ejm.16.2020.07.12.10.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 10:36:39 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1594546078.git.asml.silence@gmail.com>
 <edfa9852-695d-d122-91f8-66a888b482c0@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC 0/9] scrap 24 bytes from io_kiocb
Message-ID: <618bc9a5-420c-b176-df86-260734270f56@gmail.com>
Date:   Sun, 12 Jul 2020 20:34:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <edfa9852-695d-d122-91f8-66a888b482c0@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/07/2020 18:59, Jens Axboe wrote:
> On 7/12/20 3:41 AM, Pavel Begunkov wrote:
>> Make io_kiocb slimmer by 24 bytes mainly by revising lists usage. The
>> drawback is adding extra kmalloc in draining path, but that's a slow
>> path, so meh. It also frees some space for the deferred completion path
>> if would be needed in the future, but the main idea here is to shrink it
>> to 3 cachelines in the end.
>>
>> I'm not happy yet with a few details, so that's not final, but it would
>> be lovely to hear some feedback.
> 
> I think it looks pretty good, most of the changes are straight forward.
> Adding a completion entry that shares the submit space is a good idea,
> and really helps bring it together.
> 
> From a quick look, the only part I'm not super crazy about is patch #3.

Thanks!

> I'd probably rather use a generic list name and not unionize the tw
> lists.

I don't care much, but without compiler's help always have troubles
finding and distinguishing something as generic as "list".

BTW, I thought out how to bring it down to 3 cache lines, but that would
require taking io_wq_work out of io_kiocb and kmalloc'ing it on demand.
And there should also be a bunch of nice side effects like improving apoll.

-- 
Pavel Begunkov
