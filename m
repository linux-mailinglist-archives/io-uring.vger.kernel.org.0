Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF09128D5BC
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 22:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgJMUtF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 16:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgJMUtE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 16:49:04 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E727C061755
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 13:49:03 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id dt13so1651236ejb.12
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 13:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xiPxoG74Sv3PZCFT0jMfs/MU0CDcAERPQ3ZZUCQPVFw=;
        b=AQJ+iYBFWmaDPfkuvMpGEDiHwe4J5C9g9MkmAciYVZp1+jlc0gogF6m/OKFE0fcrLQ
         JZ/ky+phX9BqEZX+OqLJS2FXlfCqSge819tHHqc6CbuCdq3rqV1MLTsremWd8Zv9LZMt
         RVu1Wljjty2feuGUMZAMQLU8NsXTZIiT8b7po=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xiPxoG74Sv3PZCFT0jMfs/MU0CDcAERPQ3ZZUCQPVFw=;
        b=OOExqxvsbmSc2tqSTrQg23ClxZ6DW/wO7nWlMT78W7JJlqMHC0l8DXkEA3qxaD23aQ
         JnpV7s7YkLk4L7hh/MOTvyEdHGPR22Sr6X6oHesBdPEQIZCacgzGds+JVpHBQNJP6d2Z
         fP68H62PO3+zlx8RbxBzfcTY1FgcAci784rgHlw8LPgocVCV/SoksEK9i0+rHfXlcSEr
         aPdDGesDK8O2jwf3OprfYS3vFXKUhnvbljZ0lKzBnyIdPL4podCzdiqoQlLto66zkGVd
         JXvRc8ksfzouJk5v8BMwHJQiSLHNRA8euGvUw+xxKG0hMHfKcVzS20ptosQjjAwdJDfH
         yRng==
X-Gm-Message-State: AOAM531hyT5hCr6z8gcHF2wid8j/A+TpqXx3BNYCUoHZFAQpWPwX4GYB
        Ccl5Nv4IxYJpAiKTV1erdJ/o4oam9PBT2d6jneY=
X-Google-Smtp-Source: ABdhPJxSGFFxMjwcVPUBIGIahnIrzieQHiQn3lEWVT8JuBX1ZawuFjyyOA2ao1ew3NJqYWG6V5iP4g==
X-Received: by 2002:a17:906:3092:: with SMTP id 18mr1664984ejv.43.1602622141915;
        Tue, 13 Oct 2020 13:49:01 -0700 (PDT)
Received: from [192.168.1.149] (5.186.115.188.cgn.fibianet.dk. [5.186.115.188])
        by smtp.gmail.com with ESMTPSA id u18sm497827ejn.122.2020.10.13.13.49.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 13:49:01 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring updates for 5.10-rc1
To:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <36a6706d-73e1-64e7-f1f8-8f5ef246d3ea@kernel.dk>
 <CAHk-=wgUjjxhe2qREhdDm5VYYmLJWG2e_-+rgChf1aBkBqmtHw@mail.gmail.com>
 <a81737e4-44da-cffc-cba0-8aec984df240@kernel.dk>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <3e37f236-c0ce-abb0-fa89-2118dd18d042@rasmusvillemoes.dk>
Date:   Tue, 13 Oct 2020 22:49:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a81737e4-44da-cffc-cba0-8aec984df240@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 13/10/2020 21.49, Jens Axboe wrote:
> On 10/13/20 1:46 PM, Linus Torvalds wrote:
>> On Mon, Oct 12, 2020 at 6:46 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> Here are the io_uring updates for 5.10.
>>
>> Very strange. My clang build gives a warning I've never seen before:
>>
>>    /tmp/io_uring-dd40c4.s:26476: Warning: ignoring changed section
>> attributes for .data..read_mostly
>>
>> and looking at what clang generates for the *.s file, it seems to be
>> the "section" line in:
>>
>>         .type   io_op_defs,@object      # @io_op_defs
>>         .section        .data..read_mostly,"a",@progbits
>>         .p2align        4
>>
>> I think it's the combination of "const" and "__read_mostly".
>>
>> I think the warning is sensible: how can a piece of data be both
>> "const" and "__read_mostly"? If it's "const", then it's not "mostly"
>> read - it had better be _always_ read.
>>
>> I'm letting it go, and I've pulled this (gcc doesn't complain), but
>> please have a look.
> 
> Huh weird, I'll take a look. FWIW, the construct isn't unique across
> the kernel.

Citation needed. There's lots of "pointer to const foo" stuff declared
as __read_mostly, but I can't find any objects that are themselves both
const and __read_mostly. Other than that io_op_defs and io_uring_fops now.

But... there's something a little weird:

$ grep read_most -- fs/io_uring.s
        .section        .data..read_mostly,"a",@progbits
$ readelf --wide -S fs/io_uring.o | grep read_most
  [32] .data..read_mostly PROGBITS        0000000000000000 01b4e0 000188
00  WA  0   0 32

(this is with gcc/gas). So despite that .section directive not saying
"aw", the section got the W flag anyway. There are lots of

        .section "__tracepoints_ptrs", "a"
      .pushsection .smp_locks,"a"

in the .s file, and those sections do end up with just the A bit in the
.o file. Does gas maybe somehow special-case a section name starting
with .data?

Rasmus
