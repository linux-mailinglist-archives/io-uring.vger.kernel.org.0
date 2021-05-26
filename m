Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97232391B16
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 17:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbhEZPF0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 11:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbhEZPF0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 11:05:26 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062E2C061574
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 08:03:55 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id r4so1315623iol.6
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 08:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RdD+yhjskjytoSwzK4K8OvmLSnQI7lnYHP0RF4HRz18=;
        b=d9M53mRNTf9MEFSUU3sHcNzBqivYtIZ03jm8/QqsMwG3qdW01rDLdFra555pEaLeTT
         NwmI77Ja3EuZFxrgCK5RYQqKFoQs18dtyaA9zEY8mvjbPpyJrIM4CGJRTUjWBcz3vKCV
         lBqjPvceLirzROr1OHhx3rnaiJ/M0l6g9fcsAMKZluI3RzVhVK6xwJ1yCfj6NWyt4T4C
         NeTZbB06yJrivQprlFlBYV2+Ri9TUC7JMCJRIy4tpavBSarVVFYMkjSC8L64JyzqTtod
         7sisbs7X1ZvkfCg9SlVZ3MThXwcyXCJBURlKdO0yex7Gi5N4mp0ZQSheT7+noZhxLBWB
         WDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RdD+yhjskjytoSwzK4K8OvmLSnQI7lnYHP0RF4HRz18=;
        b=mQzvdVhlelYQJcyIaFMQX1W8qEYLSlt69ha/IiC9u6WD+Ie5XaPUOHnWmy1XaO+s7z
         paQqVDHonp9MHi1QEeYX9PW77BYbFxKcWKrP7JpQpZNxCykb5O3TJy04Dc6QDCJbqLKB
         NB+YVpdS5O0aJPW+n1E8ivJcAcp3k7ck+5XWjNnUL6CJDHXhK7eWumk9J2NjyOhGImyT
         ipe4FzxpUytpugGrwIhhBVcG5IZtWnz2KMWULdrQJ+y/F3cyZRwQdrw9muVdjllTO7qq
         yfsr0H3rmKxQnw+3fKQ8Kp9WwDqTRTnZKlXs44Yh1dJoeQ1TvQ98FFXOZ2RT77zQ+1sa
         S3Dw==
X-Gm-Message-State: AOAM531H4JSAnETu+gj4kHtg3PsBsI3UVHr9M4KZvfKbRPvB/abgJJ2S
        fGS+Fa1Hpt1X+G8+Q0PA7fr7ydvtmW/T8Ixg
X-Google-Smtp-Source: ABdhPJwyN6Folw/FOM29pcOR6bhWunMGxcrTSy+iolN2NLtGibVdcK8HSlkiGXcKwmvpPs7Gtcjs8A==
X-Received: by 2002:a02:900b:: with SMTP id w11mr3646509jaf.5.1622041434193;
        Wed, 26 May 2021 08:03:54 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c6sm15509870ile.43.2021.05.26.08.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 08:03:53 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring/io-wq: close io-wq full-stop gap
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <abfcf8c54cb9e8f7bfbad7e9a0cc5433cc70bdc2.1621781238.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <25474e3e-c179-34e3-fabf-fff1ea746bfa@kernel.dk>
Date:   Wed, 26 May 2021 09:03:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <abfcf8c54cb9e8f7bfbad7e9a0cc5433cc70bdc2.1621781238.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/23/21 8:48 AM, Pavel Begunkov wrote:
> There is an old problem with io-wq cancellation where requests should be
> killed and are in io-wq but are not discoverable, e.g. in @next_hashed
> or @linked vars of io_worker_handle_work(). It adds some unreliability
> to individual request canellation, but also may potentially get
> __io_uring_cancel() stuck. For instance:
> 
> 1) An __io_uring_cancel()'s cancellation round have not found any
>    request but there are some as desribed.
> 2) __io_uring_cancel() goes to sleep
> 3) Then workers wake up and try to execute those hidden requests
>    that happen to be unbound.
> 
> As we already cancel all requests of io-wq there, set IO_WQ_BIT_EXIT
> in advance, so preventing 3) from executing unbound requests. The
> workers will initially break looping because of getting a signal as they
> are threads of the dying/exec()'ing user task.

Applied, thanks.

-- 
Jens Axboe

