Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0453628D612
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 23:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgJMVA7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 17:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgJMVA6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 17:00:58 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD054C061755
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 14:00:58 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a17so134707pju.1
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 14:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=35KdctzIrSBX2mg6IoDLEL1qwd4y1P4GeBRmVWUjxAk=;
        b=HeWN9uPQx7edJWlSQV4WI0zrWQ/4+cArpAu3sGJzpjcHnYQ0RnSUocrK3ge2ZhP+JZ
         pLdBt+dUNJnbCEL69MledzokOcmLYb/1KxvXSF0vIQVM6auH0A93k8npU/x5A/70Wgdc
         kRz36KHAFHQfQ3LGJQvkx9Kf2CWbZ6Buq6FDeE410jyTdKtKhIxm5DpSI/3nkNqC4Oy9
         RJwWPbTbI568Rnxj0eSOZBz2K3C00UBe8bj41TjbemrjlgZXYj49soVw+vhFPFSBqG7c
         nxbyRNrltQ/AhA9qQuwFJoE5MtmukSIXVwZ38A91olrtAAhztZSxG3QKdUWpMbLKz7qh
         pnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=35KdctzIrSBX2mg6IoDLEL1qwd4y1P4GeBRmVWUjxAk=;
        b=BRfr7CV+Mp/TEDZKznWlf9X0CxKCQzTLBxPeQcA/7v9QO5zRImUeL5GEGSTyA5RGcR
         DovAoqW50FMYpYl+7pM9b07C4vT+I5vvwHkHXfQ+DnGsS80WRFngNh1QZaVijOGUVSQt
         Ltsuh0BXrlmrFDrwDxFlPxZlDmazvDoghWSUXAptIUhTvXRsNSeQu9aIMfpMrCkfRZVm
         2+PeccarjXHYp8geEQeSD5DaCxIT4sZAunuY8pMGBDHaRWdcu5/I5MKpsmRxh0SynY86
         oWKJd5sH4WlwjHV7bx7wZzfbTthcmFjdqZRFYttJLCp7KeidsZjpEhqrX7EB4xb0fF0o
         wf+g==
X-Gm-Message-State: AOAM532f62gwdpov3E+sogPaSu6Ow4d7BIz5CxIVwQt6uACFDeQqshCX
        SnCasmM9RdWOTSyp8fsBx6wKyw==
X-Google-Smtp-Source: ABdhPJzEkiDHxZwinBbb70w4edrvZ5KbQj6DFDmXtrUEZVKUuoLWH+/LYYGiHOx3TfcYkg9gL17jTA==
X-Received: by 2002:a17:902:c313:b029:d4:b6ac:7b5a with SMTP id k19-20020a170902c313b02900d4b6ac7b5amr1523992plx.39.1602622858128;
        Tue, 13 Oct 2020 14:00:58 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l18sm548332pfd.210.2020.10.13.14.00.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 14:00:57 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring updates for 5.10-rc1
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <36a6706d-73e1-64e7-f1f8-8f5ef246d3ea@kernel.dk>
 <CAHk-=wgUjjxhe2qREhdDm5VYYmLJWG2e_-+rgChf1aBkBqmtHw@mail.gmail.com>
 <a81737e4-44da-cffc-cba0-8aec984df240@kernel.dk>
 <3e37f236-c0ce-abb0-fa89-2118dd18d042@rasmusvillemoes.dk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7f2c7699-b8f4-3b50-d1c9-beeb429e32e4@kernel.dk>
Date:   Tue, 13 Oct 2020 15:00:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3e37f236-c0ce-abb0-fa89-2118dd18d042@rasmusvillemoes.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/13/20 2:49 PM, Rasmus Villemoes wrote:
> On 13/10/2020 21.49, Jens Axboe wrote:
>> On 10/13/20 1:46 PM, Linus Torvalds wrote:
>>> On Mon, Oct 12, 2020 at 6:46 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> Here are the io_uring updates for 5.10.
>>>
>>> Very strange. My clang build gives a warning I've never seen before:
>>>
>>>    /tmp/io_uring-dd40c4.s:26476: Warning: ignoring changed section
>>> attributes for .data..read_mostly
>>>
>>> and looking at what clang generates for the *.s file, it seems to be
>>> the "section" line in:
>>>
>>>         .type   io_op_defs,@object      # @io_op_defs
>>>         .section        .data..read_mostly,"a",@progbits
>>>         .p2align        4
>>>
>>> I think it's the combination of "const" and "__read_mostly".
>>>
>>> I think the warning is sensible: how can a piece of data be both
>>> "const" and "__read_mostly"? If it's "const", then it's not "mostly"
>>> read - it had better be _always_ read.
>>>
>>> I'm letting it go, and I've pulled this (gcc doesn't complain), but
>>> please have a look.
>>
>> Huh weird, I'll take a look. FWIW, the construct isn't unique across
>> the kernel.
> 
> Citation needed. There's lots of "pointer to const foo" stuff declared
> as __read_mostly, but I can't find any objects that are themselves both
> const and __read_mostly. Other than that io_op_defs and io_uring_fops now.

You are right, they are all pointers, so not the same. I'll just revert
the patch.

-- 
Jens Axboe

