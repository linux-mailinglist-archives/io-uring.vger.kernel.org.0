Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC92817829C
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 20:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgCCSwv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 13:52:51 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37946 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbgCCSwv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 13:52:51 -0500
Received: by mail-wr1-f68.google.com with SMTP id t11so5767566wrw.5
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 10:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UI6DHbDrNxVDTcpO+uOlzLdvLHGi8v+3+zdA7aHFKRs=;
        b=tJK42jtm9Pb7a9Sp82/iBIU9/kVr/7scL2ahSV8gf+cg60XuV+fW6dXBdlHE6ntMgN
         yUE4B+pcKeISBTvL99gby0juQH7IMEHiluQUqAKb0CaXezcR+uO7DOkwMPv0jmm8FItr
         h/wxLcTTX8fofKleNe2ce6J2aJtxzV0pLw1/zz042ummGsobKTfzRhlQ/lfOYV/sxue5
         U1M8cFtcDP7spIeEEvLrn9IvFZWCtQ6/wRFmItiO7S/Aela/Hl6rQpL2Eoumck+jhpxH
         8PXkOX939fXLNQ2wwddsfJ5Gk3Edpn+cpvshDmyqv5KszCw02SIIXYd+D2iL691XpolZ
         JpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UI6DHbDrNxVDTcpO+uOlzLdvLHGi8v+3+zdA7aHFKRs=;
        b=WePfiR4IsUa3fPozRQbYtZErMJT8uGLY85yxLY1VJ+7w6WD/USsUpk4wlgIUfJxR4I
         zyNB0ZHpwLqaOspo7EzCi0U8r3+oZQZnk8EirJChZIJJS4U1E6jQ7OFsWADx5QmcLAs5
         kDpw7r4IA8BHmbT0FJGkjkB9Bi3QNF9TxVfmQ6r7uauzPkAz7r/hGIXhdWl5TjTfetG/
         xG754xuUc3b5OeUkRBQhkknU5RtpF0I+RlhLLslbYzTDNPEIFifpKoL2xyhF0vjztRTc
         bR2N/SAs/a1fO6Lto0tAJhK7/vfZnKqKnLECM4xWwSJBDICLzJ+8r4TBuCX6sRj97lIZ
         +tcw==
X-Gm-Message-State: ANhLgQ3cbSDNkEGCJ9PGZfCHfor3bDSb/o8aTkXDSvABoaGWUwAXqyJn
        Jl7rMxdBxT3P04XMjiz6Z4ejfAK6
X-Google-Smtp-Source: ADFU+vsGFDClhEWq7hT38HsQJ/DOSc3wFbGyxjXdTKOS36YE7hUb8BlA0UnocRV8Q4kZMb9G4SnmaA==
X-Received: by 2002:adf:fc81:: with SMTP id g1mr7109606wrr.410.1583261568089;
        Tue, 03 Mar 2020 10:52:48 -0800 (PST)
Received: from [192.168.43.50] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id c16sm5663171wrm.24.2020.03.03.10.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 10:52:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1583258348.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 0/3] next work propagation
Message-ID: <90a9fcda-dd44-1b5c-7dc6-28ec3a1dd81a@gmail.com>
Date:   Tue, 3 Mar 2020 21:52:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1583258348.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/03/2020 21:33, Pavel Begunkov wrote:
> The next propagation bits are done similarly as it was before, but
> - nxt stealing is now at top-level, but not hidden in handlers
> - ensure there is no with REQ_F_DONT_STEAL_NEXT

Forgot to update this part, and also add, that there is no
refcount_dec_fetch(), so I did

io_put_req_async_completion() {
        refcount_dec()
        refcount_read()
}

because checks in refcount*() are useful, and I intend to remove
refcount_dec() with the optimisation patches.

> 
> v2:
> - fix race cond in io_put_req_submission()
> - don't REQ_F_DONT_STEAL_NEXT for sync poll_add
> 
> v3: [patch 3/3] only
> - drop DONT_STEAL approach, and just check for refcount==1
> 
> Pavel Begunkov (3):
>   io_uring: make submission ref putting consistent
>   io_uring: remove @nxt from handlers
>   io_uring: get next work with submission ref drop
> 
>  fs/io_uring.c | 307 +++++++++++++++++++++++---------------------------
>  1 file changed, 140 insertions(+), 167 deletions(-)
> 

-- 
Pavel Begunkov
