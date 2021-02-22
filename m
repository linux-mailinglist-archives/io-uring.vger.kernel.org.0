Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9678320EAE
	for <lists+io-uring@lfdr.de>; Mon, 22 Feb 2021 01:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhBVAUI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Feb 2021 19:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhBVAUH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Feb 2021 19:20:07 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62500C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Feb 2021 16:19:26 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id k22so6657991pll.6
        for <io-uring@vger.kernel.org>; Sun, 21 Feb 2021 16:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zWXxlyS3+TBnCda0x+HpYoeR0PooLqY2ejnw3pA6RfE=;
        b=PEtFS9aeP7hB2mVvHDl4yC10jk0A3M+S66f4oLyODYcOwfb5KWTawhbngnR7bJeK1a
         J2xRE4pBtPHfE0TinmWL/WmZDNSclbpUMeU5HhFZ2NQGQtgu/9fzrenXi/J2SdQDtkHy
         oOeQ2ohAcjSwK6Ppl+ZxPuVnUclHY9tUP6la8cJrtVDeDJltCg/N6hMm5d98BBnt2QK0
         PRHF+26EDzG0vfreu4emnUeyOQlfdwj7j5EYQUT/N5kpfCmdq9gW/GFCus8sI2s9syrc
         UjXQqGoZTf4gqQ1KFPKu8MA4YsS+z8hhE9lm+ptPeqtf5hol1oTIj0jMnwae+THyBKYI
         ewVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zWXxlyS3+TBnCda0x+HpYoeR0PooLqY2ejnw3pA6RfE=;
        b=Er+V9fF7bl3KJbUgDoSlSklQaiTvhz4UVOCz9zOi7wn90UTvRm+5C/oLm++OcB9Dap
         0RjrpeGNuJCj81NUa4aMhfkC1ng19KKW5yZS8xiBc7uXVizR2TKFkvPEym0vEvR+CK4E
         tAoMHNx5FjfJGPc56AYGZriSKo8ZRBMHnChvwWYmjWvL5CiUd72uahCG2glye6Ii/M1T
         ADOIv68OO19RI9OUtB/GQez8Vv3vAyHu3DYpE83JKu+N6MZpqkgsHNBNTold0TZ914sx
         SxrekQaxLrn230HQYpAfG2jDwzRi1lMEWEHrZszrXao8TZlOQSlZFHvBTCZ6D8fuHShw
         4geQ==
X-Gm-Message-State: AOAM533svIHnU161SbYIs6UxHYQbJDAPVOH7dVUyTHH4ynHtzfVT3QZm
        ObB3hXPjrZUImLurswrIkqAfjBlYUi8dDg==
X-Google-Smtp-Source: ABdhPJzbHnOe55RvpuuR/JYlw6mbfQZUpCgY5WxiG70BTLNzpyNfE7jgXcznPucrPZIzcvc3ttyX6Q==
X-Received: by 2002:a17:90a:70ce:: with SMTP id a14mr20717271pjm.16.1613953165597;
        Sun, 21 Feb 2021 16:19:25 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x20sm16516634pfi.115.2021.02.21.16.19.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 16:19:25 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: run task_work on io_uring_register()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1613834133.git.asml.silence@gmail.com>
 <0b6e6404ad89752523d3428669ec089cd540327c.1613834133.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e79e62b1-c42f-6f58-5889-0fe545ab4840@kernel.dk>
Date:   Sun, 21 Feb 2021 17:19:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0b6e6404ad89752523d3428669ec089cd540327c.1613834133.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/21 8:17 AM, Pavel Begunkov wrote:
> Do run task_work before io_uring_register(), that might make a first
> quiesce round much nicer.

Applied, thanks. I added a bit more to the commit message, since this
is what we're doing for the other io_uring syscalls as well.

-- 
Jens Axboe

