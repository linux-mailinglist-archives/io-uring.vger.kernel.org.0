Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FAE2D3669
	for <lists+io-uring@lfdr.de>; Tue,  8 Dec 2020 23:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgLHWna (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 17:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbgLHWna (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 17:43:30 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F5FC0613CF
        for <io-uring@vger.kernel.org>; Tue,  8 Dec 2020 14:42:44 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id v29so473473pgk.12
        for <io-uring@vger.kernel.org>; Tue, 08 Dec 2020 14:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1JfGLJ6mvOw51UjtiQiEid0QRM4ecB02tmMkfq6nfgs=;
        b=wCFV9J45QvQ6VLBqNfaZFGSVz7aOzY4e/fJvXuH5Qg2eoUq/yaD13S6WVqCtswczcL
         1bTPM9ZSSJO6VxWAFEIwA9Wph9rG8I4wazgpegRm0X3GVDMoMZTDH2VxwgzTmvo8ePlP
         Jkz+W5i/SbrvLg0IgLHt56ze4lmC2nOw4Vn+5nOnpf9NLJGwObaFNuDjS8jQFhXs6HoT
         9fCayLCtsFDl1X1pudqGN4+CYWw4Iz0Q7aqZSm9vx/5GYuPYopkpkPlR47z56m+8n0fW
         EQUlihowsTsnEF/+Or+Hrgp40qOy8AcvdvAeQTXVsxWez19Y+HADVXeFqpWao0lw9JGq
         adTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1JfGLJ6mvOw51UjtiQiEid0QRM4ecB02tmMkfq6nfgs=;
        b=Ner1UawJ8CCC/Ul3+DicmhAkSlKMHKo7E7ER9+SSENAmYEmp2zO7DC1Jy0YIsKUkuK
         b4qcHf0LIdU4Riabc7UfZl1SJB2i3fzZYVnBezZH8I4+L7bqSHSdJsyTbo2UNyQeQM6w
         psLsN3AbeO8Tr0fESl1A1AMOvx8NrOxIrLSL6ErRAOHDmMcqqAi5Prp/ZKCja+qOiPbS
         YXCCx5KfznTqhwibQ76cIwwwanZOHjJe3Dupg95MCTsPO+l2j+tEnXJvmJdSejB8x1k8
         qrvNl8T/eFnVYnSGXlaRJ/16thDVkQeJlFnmDqwfdnBp/OEfygMVXUQXcvEbOpDpchva
         G2gw==
X-Gm-Message-State: AOAM532jnnIvbcZBUd4eHLO+3OrXkoRWkZLO6A76KR9TWzAH6hJtV6yG
        34nZdfhfZICEVlzai2Ey881mevu5joa8Tg==
X-Google-Smtp-Source: ABdhPJycJoQ22ZUHKp4SFC01NBv6COKwNqcwBFSSklb2a+g9mxL/dERv4s0qJgI8iE2CIqgplqeTgQ==
X-Received: by 2002:a63:40e:: with SMTP id 14mr237953pge.420.1607467362861;
        Tue, 08 Dec 2020 14:42:42 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t9sm179036pjq.46.2020.12.08.14.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:42:42 -0800 (PST)
Subject: Re: [PATCH liburing] rem_buf/test: inital testing for
 OP_REMOVE_BUFFERS
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0de486be33eba2da333ac83efb33a7349344551e.1607464425.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <08387f60-d2fe-1396-aa15-ae9b759efa57@kernel.dk>
Date:   Tue, 8 Dec 2020 15:42:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0de486be33eba2da333ac83efb33a7349344551e.1607464425.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/8/20 2:57 PM, Pavel Begunkov wrote:
> Basic testing for IORING_OP_REMOVE_BUFFERS. test_rem_buf(IOSQE_ASYNC)
> should check that it's doing locking right when punted async.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> NOTICE:
> test_rem_buf(IOSQE_ASYNC) hangs with 5.10
> because of double io_ring_submit_lock(). One of the iopoll patches
> for 5.11 fixes that.

Let's get just that into 5.10, and then we can fix up 5.11 around that.

-- 
Jens Axboe

