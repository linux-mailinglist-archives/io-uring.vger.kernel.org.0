Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9973E2FAEE1
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 03:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394507AbhASCmt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jan 2021 21:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394339AbhASCms (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jan 2021 21:42:48 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AF4C061573
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 18:42:01 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id h17so14989950wmq.1
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 18:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+S62MoLSNKGOOQm6aA3EnWQI7EDKMGP7bV6+ZBBCQvs=;
        b=h9/7xtJU7wpqpo9PiTnHFLn9HhpuMOSl8EqUCEwEryuHoL4qkHC7AS9eMXheuXXOhW
         1SJlMQfXITpLSWwRqt5Z56/oQ9agWyjJrnLgg+nPiaOAt2da5ZezcnwICglOJxIAuHXp
         IPmDP6ogyIkAV0OfHZSEpOG0sfraxzu/klyqgIwxrWc2Vu7oTo7JK3TRm5e5yZTAs4cM
         CtcnONxHR+Y2aEGEl/Gdwc4CUk68nXkFgsnALgLhSVs5OCFtnRGifoa21k6NkTBLCgo4
         ntP1YT1ssuAh1Cn0r5g36qJhD2a9d8R4Lm9GAsVTOm8Nxsj19/ZNZJ4lNJhZVhY4jWT2
         LlfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+S62MoLSNKGOOQm6aA3EnWQI7EDKMGP7bV6+ZBBCQvs=;
        b=rlhuNy9/zcvWvsFF+R2ktuWbYuzy5x+YOXwweqAfHhtO/u6zukCVbbB9tHmkcEA4rF
         wwtJct3RwZX7O2uM/8IxOjVSuiQjDUwrk/LYRQyfGrnQRe90I+LZX6EwsmLa9sIGzSEx
         bEDFJWjEk2k5ou0v23m1kw2efVlyS5pwrsWd+cUR+wqhdr8uTm2DLUmfNzhF8OhJto3+
         EeqtBhTs+yk0LZ5XaK0LjB8WyBnIkQP0q+F9NzIwCKf3Y/9Yi16L/w4Rd3xMcidglwil
         ikLE5Bq68yQniuTm9cN7apFQN676hUvj76SuuCxWymzgvE7oQrMdrnalpihrSbpJ6KTu
         IkZA==
X-Gm-Message-State: AOAM533mOk8bbiTuuSj13mYP1hTt+jYl8l0k5J8zB2LzDFwj/hDADyxT
        Y2Iba54kUCnOCbYevfbgtlxV6/o1NiM=
X-Google-Smtp-Source: ABdhPJxvc78NtDZo8bYnH14B7TeTnS6HOgHFE98NJK3JhdbrPmo7agVKcgL5jyG0NQOMl1ovohQgMg==
X-Received: by 2002:a1c:a406:: with SMTP id n6mr1885803wme.53.1611024120726;
        Mon, 18 Jan 2021 18:42:00 -0800 (PST)
Received: from [192.168.8.133] ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id d18sm2031756wmb.30.2021.01.18.18.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 18:42:00 -0800 (PST)
To:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <1610963424-27129-1-git-send-email-joseph.qi@linux.alibaba.com>
 <4f1a8b42-8440-0e9a-ca01-497ccd438b56@gmail.com>
 <ae6fa12a-155b-cf43-7702-b8bb5849a858@gmail.com>
 <58b25063-7047-e656-18df-c1240fab3f8d@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: fix NULL pointer dereference for async cancel
 close
Message-ID: <164dff2a-7f23-4baf-bcb5-975b1f5edf9b@gmail.com>
Date:   Tue, 19 Jan 2021 02:38:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <58b25063-7047-e656-18df-c1240fab3f8d@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/01/2021 01:58, Joseph Qi wrote:
>> Hmm, I hastened, for files we need IO_WQ_WORK_FILES,
>> +IO_WQ_WORK_BLKCG for same reasons. needs_file would make 
>> it to grab a struct file, that is wrong.
>> Probably worked out because it just grabbed fd=0/stdin.
>>
> 
> I think IO_WQ_WORK_FILES can work since it will acquire
> files when initialize async cancel request.

That the one controlling files in the first place, need_file
just happened to grab them submission.

> Don't quite understand why we should have IO_WQ_WORK_BLKCG.

Because it's set for IORING_OP_CLOSE, and similar situation
may happen but with async_cancel from io-wq.

Actually, it's even nastier than that, and neither of io_op_def
flags would work because for io-wq case you can end up doing
close() with different from original files. I'll think how it
can be done tomorrow.

-- 
Pavel Begunkov
