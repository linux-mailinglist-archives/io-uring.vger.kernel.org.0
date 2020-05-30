Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BA51E9376
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 21:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgE3TkA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 15:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3TkA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 15:40:00 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C064C03E969
        for <io-uring@vger.kernel.org>; Sat, 30 May 2020 12:40:00 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id n5so7470834wmd.0
        for <io-uring@vger.kernel.org>; Sat, 30 May 2020 12:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v+pXWgxeobg6ZCdmeIuzw2m6sTxUwkImczywxvJOfnw=;
        b=ptp3nEXjYmUmVm43g+aQyA7rrr5R0f5daTWWrUcF7L/2vThNrUPNJJCYrSslUvR1WM
         vJ0lODPmxy9aTBww89BfT21/yfHvmS0yCxo22GjkHXLHV2NQF9qU/QUdV+61UYf8557+
         cW6QVbCl+SOHhRQVEQiZiOzKF+JR0gnXuHlDgqU6y41rQHyGgehMdZw7qW1pJCTSYvnV
         R+OiTqJrlVCI/lpLGoYQpQUJXIDHgzDfyX9iQMztBYHFI0A6o1LJ7f7+//GWWADwidpr
         wfTL1OumIoEcSRU7ges4WGkznMae8ZRdU+cKSe7O4B4sJIPkADkDrF5CCgP8q5gYeRak
         2sQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=v+pXWgxeobg6ZCdmeIuzw2m6sTxUwkImczywxvJOfnw=;
        b=EXcgtzIo38jc6oP5VKSIzb62Ut7MpURRpR4Rcmd77t5l1J4b3R6GPDS56ymO9HZrOx
         l+3NUNb89bnCupRsCWYhFiz62si1o6l2G/YcjQVJIRgMKc3M1XQ4NJtS9llyQTRaUNUV
         GWk8ZYKS/fycdMipZ3n7x5SiJEYUhhGr9Ac2ha+FCeny5i/htz849c2hJwbZRcA6jXfr
         PNQPMSSSa8z71MMXsr+bPKtWPJYTrbWEGhhkzvVTIK5ZRyliA/kJ42h2bzbICT9jNaCz
         mAYMnbIbCtaWJKa/ol2hdfMsRhNtQJ81rR0K9atMoY4xmvhq5qB+RBwVtyOwRpefnozl
         o+jA==
X-Gm-Message-State: AOAM531B2ph7Lq84d6udObTfsNS0eG7WVW6HIaBnVncYFldphwJg/am6
        HYdtl6QAKrXwxEILMGtjXqw59H/3
X-Google-Smtp-Source: ABdhPJznqtvUt0oaBiU3jgwdgaA23QsaZSYw6DZQqmUvUOLvB0wMi/GT2gKA8fhGRb+reHWO81wT1w==
X-Received: by 2002:a1c:a905:: with SMTP id s5mr13968005wme.120.1590867598626;
        Sat, 30 May 2020 12:39:58 -0700 (PDT)
Received: from [192.168.43.60] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id u12sm71289wrq.90.2020.05.30.12.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 12:39:58 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200528091550.3169-1-xiaoguang.wang@linux.alibaba.com>
 <fa5b8034-c911-3de1-cfec-0b3a82ae701a@gmail.com>
 <b472d985-0e34-c53a-e976-3a174211d12b@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
Message-ID: <3f455162-ea38-30b0-feb0-0ee373f1f601@gmail.com>
Date:   Sat, 30 May 2020 22:38:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b472d985-0e34-c53a-e976-3a174211d12b@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/05/2020 16:36, Xiaoguang Wang wrote:
> 
> The risk mainly comes from the union:
> union {
>     /*
>      * Only commands that never go async can use the below fields,
>      * obviously. Right now only IORING_OP_POLL_ADD uses them, and
>      * async armed poll handlers for regular commands. The latter
>      * restore the work, if needed.
>      */
>     struct {
>         struct callback_head    task_work;
>         struct hlist_node    hash_node;
>         struct async_poll    *apoll;
>     };
>     struct io_wq_work    work;
> };
> 
> 1, apoll and creds are in same memory offset, for 'async armed poll handlers' case,
> apoll will be used, that means creds will be overwrited. In patch "io_uring: avoid
> unnecessary io_wq_work copy for fast poll feature", I use REQ_F_WORK_INITIALIZED
> to control whether to do io_wq_work restore, then your below codes will break:

Yes, that's an example, which doesn't even consider the second patch. But great
that you anticipated the error. Unconditional partial copy/init probably would
solve the issue, but let's keep it aside for now.

> 
> static inline void io_req_work_drop_env(struct io_kiocb *req)
> {
>     /* always init'ed, put before REQ_F_WORK_INITIALIZED check */
>     if (req->work.creds) {
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Here req->work.creds will be invalid, or I still need to use some space
> to record original req->work.creds, and do creds restore.
> 
>         put_cred(req->work.creds);
>         req->work.creds = NULL;
>     }
>     if (!(req->flags & REQ_F_WORK_INITIALIZED))
>          return;
> 
> 2, For IORING_OP_POLL_ADD case, current mainline codes will use task_work and
> hash_node,
> 32 bytes, that means io_wq_work's member list, func, files and mm would be
> overwrited,
> but will not touch creds, it's safe now. But if we will add some new member to
> struct {
>     struct callback_head    task_work;
>     struct hlist_node    hash_node;
>     struct async_poll    *apoll;
> };
> say callback_head adds a new member, our check will still break.
> 
> 3. IMO, io_wq_work is just to describe needed running environment for reqs that
> will be
> punted to io-wq, for reqs submitted and completed inline should not touch this
> struct
> from software design view, and current io_kiocb is 240 bytes, and a new pointer

Instead, it stores an entity in 2 different places, adding yet another
thing/state to keep in mind. Arguable. I'd rather say -- neither one is better.
And that's why I like the simplicity of initialising it always.


> will be
> 248 bytes, still 4 cache lines for cache line 64 bytes.
> 
> 

-- 
Pavel Begunkov
