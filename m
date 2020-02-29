Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DADD1748C0
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 19:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgB2Spc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 13:45:32 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44918 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbgB2Spc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 13:45:32 -0500
Received: by mail-wr1-f68.google.com with SMTP id m16so7347919wrx.11;
        Sat, 29 Feb 2020 10:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=auQlWCi9XQ9349h8I1xX8KVOY9L64kEM87K/dn2SiSE=;
        b=FwYUEalbD2ammMYRBI1jjiRKyyZCn0Bwr31cquXUNxwYpbzpYgbf7wPRdTDFGMCFHQ
         8JaZV7PAASx+M37lMusq6KFZzxDTGfqW00k4XdEkUwCnOxV0b1RgiVlsraNeaDrX27lM
         tnTLLZMXAl9LMVUFiElaoar3/f1HNsOrzWT1OHrDfUeFU2PL0qaEd2guISHxl5pIhpAd
         36reuZ3/nUro12cN7vA10ZurUnQv92xiygguAefyrqxtxeimTFkmEtEbs3eOw7CAl+NL
         A9X/JTaZp+pSWofhCG/wwOw0KY/DxDoksb+UyekHCH4jZsqUrnd/1a6ctZw0rRDi6SoM
         POBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=auQlWCi9XQ9349h8I1xX8KVOY9L64kEM87K/dn2SiSE=;
        b=aosXBFvXWNyv+g+YFsgHMrf/U8aAHK7pnZYVnFXRIFlxRauTyrZCyCq33X6z23WP0Y
         Yx5z2oWqFUv12sjNI1wOSRYGbkhVysj+RjaKMWVO+l+wWKNqO4cdPu3C+v0ScH8PQimQ
         y5bo94KDndhPgXhstMB011Qgf+9f8TPo6pBioPMMEvZ1z4wTrW+V8vtoyfFJguSbDSgF
         qAsQxaY9/si6wcdgGnUW6GLjeawsrMfPZVrwPQLjLJ861Rt6O0NEg4ZOsD+miQ/HJtbB
         LkcdIctLH8EajRMwfXZ04jQtATDGthu70pWUZiDTi1jgEHY1EVa/JxRWz2Uy9NKnKPrQ
         HbcQ==
X-Gm-Message-State: APjAAAUgZm5VN/lc11OcN0UYBzVOp4E8//gM0wZSVayn7euJt9TMKdYm
        agSKGP9KaFsjEb4QovnsdnjerdBf
X-Google-Smtp-Source: APXvYqy2JcMRDyZXJGuZPNTq89D0R12ds3dmd0hofmfL/ZAhkGeX5ROtzaKVKVYct7ToTnjd3R7KcQ==
X-Received: by 2002:a5d:488c:: with SMTP id g12mr11902208wrq.67.1583001929921;
        Sat, 29 Feb 2020 10:45:29 -0800 (PST)
Received: from [192.168.43.21] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id x12sm7563738wmc.20.2020.02.29.10.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 10:45:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1582932860.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH REBASE v2 0/5] return nxt propagation within io-wq ctx
Message-ID: <fc951f93-9d46-d94d-35af-4c91a2326a0b@gmail.com>
Date:   Sat, 29 Feb 2020 21:44:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1582932860.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 29/02/2020 02:37, Pavel Begunkov wrote:
> After io_put_req_find_next() was patched, handlers no more return
> next work, but enqueue them through io_queue_async_work() (mostly
> by io_put_work() -> io_put_req()). The patchset fixes that.
> 
> Patches 1-2 clean up and removes all futile attempts to get nxt from
> the opcode handlers. The 3rd one moves all this propagation idea into
> work->put_work(). And the rest ones are small clean up on top.

And now I'm hesitant about the approach. It works fine, but I want to remove a
lot of excessive locking from io-wq, and it'll be in the way. Ignore this, I'll
try something else

The question is whether there was a problem with io_req_find_next() in the first
place... It was stealing @nxt, when it already completed a request and were
synchronous to the submission ref holder, thus it should have been fine.

> v2: rebase on top of poll changes
> 
> Pavel Begunkov (5):
>   io_uring: remove @nxt from the handlers
>   io_uring/io-wq: pass *work instead of **workptr
>   io_uring/io-wq: allow put_work return next work
>   io_uring: remove extra nxt check after punt
>   io_uring: remove io_prep_next_work()
> 
>  fs/io-wq.c    |  28 ++---
>  fs/io-wq.h    |   4 +-
>  fs/io_uring.c | 320 ++++++++++++++++++++------------------------------
>  3 files changed, 141 insertions(+), 211 deletions(-)
> 

-- 
Pavel Begunkov
