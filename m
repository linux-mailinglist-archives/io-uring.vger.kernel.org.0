Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1345131156B
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 23:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhBEWbX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Feb 2021 17:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbhBEORl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Feb 2021 09:17:41 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAF1C061793
        for <io-uring@vger.kernel.org>; Fri,  5 Feb 2021 07:46:00 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id a14so1348194ios.2
        for <io-uring@vger.kernel.org>; Fri, 05 Feb 2021 07:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ImyN6AiOjSZq1lbE5DZF/MCnzlOOH3UL8dJG1QC6YXM=;
        b=CoTuthhLD50HzxMVV64t0YA4zAzodw3z3i7N8UAQf+u27gDTXd588BRIjxtnN22H5R
         zLxmKNeZ/sixGn+HTQcwX24GIyxNZk2OJVAESqepotlGdxd0YMNDWykzHsgryfIfcA29
         0Ezw9L3pKF/sPMXsMdt+nAhXaoLOxb5slOdpGFcfPVlyZgf+lXLt3Uxl0Lkkf4t51yB0
         61rI6oFJLuqvnaLtYQvJAwr9MV3GmDnixR5TqeRiZuDIBbBgBU9+E54L55hxwK9yt5DA
         6EwI7lLVqazKeq59twc7w96H5SJ4JqQk3gJ/kCHcrdODa7+F0ySh5IvfFw15+Fe2V2gF
         61MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ImyN6AiOjSZq1lbE5DZF/MCnzlOOH3UL8dJG1QC6YXM=;
        b=ON51Jw+1kytfKNjm9xb/OgyUP88ZkIq1nf5jJpjJTBKpTwVD4h/G5euebeeZqgU9gK
         hYsn/jp9ZYbSJrwktdSA78lRM8yKHN12vVzfpIy9mRYIwDw8ppOZdQF6yxL0cVjIOwiq
         uSlwa/4sArPltiZmmMIBcnU6QOrXaOeUfaYdx3x83Q1g3BbBf9fGw0oBD9wHKFztRywG
         oQBqBkl4NCKQyNF+GWKLqzd6aud/ZNkPD7wWrAeSKCmPUzMIMhNUNFFfhEC2IQ8Qw3uA
         PE03GevecPW9oXPCf840F++hWTqmfUooZp83ZmE/GXI1SWHpYKN2OUk7rMFnQy/DkyK7
         Wh4Q==
X-Gm-Message-State: AOAM533fNhIlw5MUcXI64+TsW+lN5GSe+sFKEPXId+HoQ5LDDszlj8aH
        qOrJtrcWrq6c2GOht5v9JNoKeL6cOiDrauvv
X-Google-Smtp-Source: ABdhPJyUP9/B1uN/eyz/KjQNW/HNoeGgQg7g6+w9ALjh/jCQMlJEwSpgpRnLGgNLXMCC9jtuyLlTfQ==
X-Received: by 2002:a05:6e02:1bc7:: with SMTP id x7mr4192475ilv.185.1612536413660;
        Fri, 05 Feb 2021 06:46:53 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y16sm4244679ilm.7.2021.02.05.06.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 06:46:53 -0800 (PST)
Subject: Re: [PATCH for-next 0/3] sendmsg/recvmsg cleanup
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612486458.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e69c9cd9-12ac-5440-5ceb-bd69a2ba0cfe@kernel.dk>
Date:   Fri, 5 Feb 2021 07:46:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1612486458.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/4/21 5:57 PM, Pavel Begunkov wrote:
> Reincarnated cleanups of sendmsg/recvmsg managing and copying of iov.
> 
> Pavel Begunkov (3):
>   io_uring: set msg_name on msg fixup
>   io_uring: clean iov usage for recvmsg buf select
>   io_uring: refactor sendmsg/recvmsg iov managing
> 
>  fs/io_uring.c | 68 +++++++++++++++++++++++----------------------------
>  1 file changed, 30 insertions(+), 38 deletions(-)

Applied, thanks.

-- 
Jens Axboe

