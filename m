Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8B21D6CDA
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 22:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgEQUYT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 16:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgEQUYT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 16:24:19 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15EEC061A0C
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 13:24:17 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m7so3318023plt.5
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 13:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Z9zu84Fg5bCdyhLC2wYEH5B7knjB0T5bEY/b5LE6/Yw=;
        b=kBApw+NTnkRSkrRYNyaE6tX07KJrqGu7aeXGzT/9GaxCO9yTYvQMXHSEnOSQpivy8p
         m+UJ/jefgoxQ0LjZBLFhXwsGDwryWSDEcrDZ6hm0gIMHhfSDwttv8FYvzW0QzXJ4HkAG
         ahURqQEKMGeEDg215rIaRWznBfLB0BwP3+pH4k0Qz3F1QxuxKxinmIRP28n1d91lV7Co
         UcwYZRx5UHXKqqxujFs1t49pw4hU1+/waqbghVdsf2jkYpeWpt+PxLrv7aWgFcjiP/50
         jJ/bZHZ45v7NwS2nI/EH5M48xJJSJ5wxIeXi3TsXYlqSbD/JIk120iY7GPh43ru9UZ+x
         edaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z9zu84Fg5bCdyhLC2wYEH5B7knjB0T5bEY/b5LE6/Yw=;
        b=fjiscbG5X8ZLI6lt1MycFnpLiiELVGTg7o/9/wwWb1extBrWD6085GzKII/dRLkRvd
         hRoB//P+8p4HW078BEkF4cGl96cbyUh1rhKS5lFnd+vWf+XuHqsht2DRsttwIM1w6BLR
         E7cxEwgNjwk1QUigmAhxKTCQZNNU68qE9ar8B9VESLU2n4LtJdY6PoAD4LuWUmXbyoMi
         8wAS7dttKFSq04gWvVLLJ2Ln7slf7R6dQ4M10Glg0Pne7TCSoGJAiWzJINT54b8I/a3O
         UqXNZrhoKEb5aQJ+GHwDJHs9ZitOvLvqfwKnf/uoN3IK0HoUy0wIf0uFrM9mXuB0a5Hv
         4WDw==
X-Gm-Message-State: AOAM530Vla0NX6vI/ncCkjesmUlu/yBIV1aAc1NL3zjEvbrMAk1rRDYK
        YMVZE3XwKWURFbKVfcsLF9Xj4Qpoaus=
X-Google-Smtp-Source: ABdhPJzxaQq75XQbJG6K4Vr6kZdGTmhP448nVWVvaN7Xh3pFBtGw11uqgpJuGcQhhZ0VOw1W14F9GQ==
X-Received: by 2002:a17:90a:c393:: with SMTP id h19mr16348964pjt.125.1589747057443;
        Sun, 17 May 2020 13:24:17 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:91d6:39a4:5ac7:f84a? ([2605:e000:100e:8c61:91d6:39a4:5ac7:f84a])
        by smtp.gmail.com with ESMTPSA id x25sm2036627pge.23.2020.05.17.13.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 13:24:17 -0700 (PDT)
Subject: Re: [PATCH liburing 0/4] splice/tee testing
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1589714504.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cb36a039-dcc1-0756-2b85-9f763599d9d2@kernel.dk>
Date:   Sun, 17 May 2020 14:24:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1589714504.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/20 5:23 AM, Pavel Begunkov wrote:
> Add tee and improve splice tests
> 
> Pavel Begunkov (4):
>   splice/test: improve splice tests
>   update io_uring.h with tee()
>   tee/test: add test for tee(2)
>   splice/tee/tests: test len=0 splice/tee
> 
>  src/include/liburing/io_uring.h |   1 +
>  test/splice.c                   | 538 ++++++++++++++++++++++++++------
>  2 files changed, 445 insertions(+), 94 deletions(-)

Applied, thanks.

-- 
Jens Axboe

