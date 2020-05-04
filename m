Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74B51C396B
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 14:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEDMcS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 08:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726404AbgEDMcS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 08:32:18 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7D0C061A0E;
        Mon,  4 May 2020 05:32:16 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id l18so9955034wrn.6;
        Mon, 04 May 2020 05:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QVC2xakrrMBC8EDf5R4Ul+eLAcbGj53/Olbv1eot1/E=;
        b=ayJAbnSImppx9vqgk6OKRFf6v9D/fF5orOQUXIRDHpExPx2AA6n/aY4hOpZHnubKsO
         wCd2fHQVzG7PMeYcsQbykP/URjP/F3HCBZGSJu6GEkgbFGEgvvjrDPQ1qD8MRscjYiRW
         /toJZ+914qTKOCokuZvGM0FkVlTtfB1U+Fwgyez73q7JEktn9cce8yVLjbuXwUCZd+w2
         Vg/WwE8EsmmND1wP7tTTYXUmmNAqIeczK5Ap22zeJEINFSqGQreTdVCRsJaMv3ZUZe/B
         elRQP40QwR9tAoNxFUL5qUxYYi0Blb3uOtsO1qzbZhT8OrKHgtvVr+SJrJGQWyLXHCBu
         7ovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QVC2xakrrMBC8EDf5R4Ul+eLAcbGj53/Olbv1eot1/E=;
        b=dGHNbtPFXOBs0vJ79ul0RM7XN2e913XcWN0p/PvKlpfmgR1KXtjUZI7rDzh9FsDkgJ
         uGW30+QWvgbL8xOqhVu6Xv6l26O4aDBwKRAkySkNvZJJTDu3w7ODpUIAVs67z32G7NL3
         hkmBPBAz4Blj9wjwgVtPqO1R7dCFV+sI4dnYWJEe5IrXN9yMAtiQnaY4L3FBpX7lZf5S
         eq3E9evm/dnnk6jbj/v/AjyAaM/TAg2pQFgBklZYNoto2EjqfM/G1kSnYc/8lTZiQEPU
         Ink+CV/qcfVjhK49DfZ7orgP8ql2DjTlXK7v2XXFwpXuQ8q14lq3CEgWSDS2sfYI1QVU
         V8Bw==
X-Gm-Message-State: AGi0PuYeNw2Q1LKuexmwjRqQkxS68l5o2esm/PntJJGHI5EPvLWkzdPa
        QqvnR0ozXg0lGQfyasg3MbUupg+p
X-Google-Smtp-Source: APiQypI78/3VWHOmtuQzPA/AhD7CefSzvdLtLRshLWQqriqcqC8xg2l0rQV9FLvFjUvcQsv7nXbiSQ==
X-Received: by 2002:adf:9564:: with SMTP id 91mr19577703wrs.246.1588595535231;
        Mon, 04 May 2020 05:32:15 -0700 (PDT)
Received: from [192.168.43.158] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id d143sm13273347wmd.16.2020.05.04.05.32.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 05:32:14 -0700 (PDT)
To:     Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Clay Harris <bugs@claycon.org>
References: <cover.1588421219.git.asml.silence@gmail.com>
 <56e9c3c84e5dbf0be8272b520a7f26b039724175.1588421219.git.asml.silence@gmail.com>
 <CAG48ez0h6950sPrwfirF2rJ7S0GZhHcBM=+Pm+T2ky=-iFyOKg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/2] splice: export do_tee()
Message-ID: <387c1e30-cdb0-532b-032e-6b334b9a69fa@gmail.com>
Date:   Mon, 4 May 2020 15:31:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez0h6950sPrwfirF2rJ7S0GZhHcBM=+Pm+T2ky=-iFyOKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/05/2020 14:09, Jann Horn wrote:
> On Sat, May 2, 2020 at 2:10 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> export do_tee() for use in io_uring
> [...]
>> diff --git a/fs/splice.c b/fs/splice.c
> [...]
>>   * The 'flags' used are the SPLICE_F_* variants, currently the only
>>   * applicable one is SPLICE_F_NONBLOCK.
>>   */
>> -static long do_tee(struct file *in, struct file *out, size_t len,
>> -                  unsigned int flags)
>> +long do_tee(struct file *in, struct file *out, size_t len, unsigned int flags)
>>  {
>>         struct pipe_inode_info *ipipe = get_pipe_info(in);
>>         struct pipe_inode_info *opipe = get_pipe_info(out);
> 
> AFAICS do_tee() in its current form is not something you should be
> making available to anything else, because the file mode checks are
> performed in sys_tee() instead of in do_tee(). (And I don't see any
> check for file modes in your uring patch, but maybe I missed it?) If
> you want to make do_tee() available elsewhere, please refactor the
> file mode checks over into do_tee().

Overlooked it indeed. Glad you found it

> 
> The same thing seems to be true for the splice support, which luckily
> hasn't landed in a kernel release yet... while do_splice() does a
> random assortment of checks, the checks that actually consistently
> enforce the rules happen in sys_splice(). From a quick look,
> do_splice() doesn't seem to check:
> 
>  - when splicing from a pipe to a non-pipe: whether read access to the
> input pipe exists
>  - when splicing from a non-pipe to a pipe: whether write access to
> the output pipe exists
> 
> ... which AFAICS means that io_uring probably lets you get full R/W
> access to any pipe to which you're supposed to have either read or
> write access. (Although admittedly it is rare in practice that you get
> one end of a pipe and can't access the other one.)
> 
> When you expose previously internal helpers to io_uring, please have a
> look at their callers and see whether they perform any checks that
> look relevant.
> 

-- 
Pavel Begunkov
