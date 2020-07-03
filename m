Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE9D214017
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 21:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgGCTqG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 15:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgGCTqG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 15:46:06 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A88AC061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 12:46:06 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p1so3704101pls.4
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 12:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tf4uQqUqsC3/KTgqsTqxCQmOy60vm8/jis/4/QcD/uo=;
        b=XNqfvrxJNyoWKjZrmwFmCKntRv3QopgbUWQ8mZHK0CMwbsKALsCUlG/O/0fUfD7Uo+
         9kNTfJzukeagXE1CTMsSw/9vrseb/QBVxySGyFBEpiYLyMDXSGWHQfBczYVNI6NEQJ17
         hKYkfGjnb2iID/TLxSQZ6aXmhddCRLYedEmtMtEUhqxha7qeDsfWx/O8J9/9ISRA7D1E
         htAHL+c+07J5sQ8DSzukV4YmjKGWLMH7zARUQp0sDddo6qBr77SZUrZUEZqJuICfPyaC
         rwVd9tTuL+htizKgqi6vzee1JmUnVL86zlZAd7KfZZ+DNfNz1wvCyhgx65gytVQy2m+J
         YvQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tf4uQqUqsC3/KTgqsTqxCQmOy60vm8/jis/4/QcD/uo=;
        b=WEZzNYdaIDRrb7r0C0JukfDlaxxeQ2xMi+mr3uvVHIsjXeuG3XH5Tv9pF4kSlv7H8Q
         s9pAMad87Hp6O1lCI5mEtWsaus2/7g6SZaQfBQ3rZfqNLxnQg/c4heQersbkz7nYo6a9
         VsrqL8YBz9wIEzYQmh1UI7h7/wfMxbkioBqJ4tPWkrPzb7zt88sW9tYTke9fL7Irzh11
         EmGTGxhk87Xby9wL2MCWKJkUFMB0lHaN3XPjjHwuG6/Wgl6ct4Z7TEc+WpeE5m/3gj+5
         M9uq62mJUS9RxhsDkWNOFeQG/jrObM9PvIE4pEi86TelyTqNgXcrzZjgQIWb6ptoxDZN
         do6w==
X-Gm-Message-State: AOAM531geyfedUYgWDSpMv87Z256Ryjo1zVrBj2H5qe68xCMrvGjLEpu
        O+JxhoR7BBSzebDfg/GMw16dSUw4XoK/UQ==
X-Google-Smtp-Source: ABdhPJyD8DxesLIykQ0FLrn2yrCqFlYAc5qynAs0E+pFiQOphxSgGUdTYK+UzCdybr6WlKjGjRRnAQ==
X-Received: by 2002:a17:902:8301:: with SMTP id bd1mr33127955plb.64.1593805565509;
        Fri, 03 Jul 2020 12:46:05 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ev14sm1465644pjb.0.2020.07.03.12.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 12:46:04 -0700 (PDT)
Subject: Re: [PATCH 0/3] bunch of fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1593803244.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b9153f0b-6858-639c-be0f-e26b329cf4ee@kernel.dk>
Date:   Fri, 3 Jul 2020 13:46:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1593803244.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/3/20 1:15 PM, Pavel Begunkov wrote:
> Just random patches for 5.9. [1,3] are fixes.
> 
> Pavel Begunkov (3):
>   io_uring: fix mis-refcounting linked timeouts
>   io_uring: keep queue_sqe()'s fail path separately
>   io_uring: fix lost cqe->flags
> 
>  fs/io_uring.c | 59 +++++++++++++++++----------------------------------
>  1 file changed, 20 insertions(+), 39 deletions(-)

LGTM, applied, thanks.

-- 
Jens Axboe

