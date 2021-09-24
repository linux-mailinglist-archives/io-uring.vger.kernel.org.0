Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C8A417C63
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 22:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346135AbhIXUej (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 16:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343775AbhIXUei (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 16:34:38 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8ED9C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 13:33:04 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id m11so14250955ioo.6
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 13:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BJi11oxy/mS8LpMJIiVF2RRtBr2FigKt0s6KyCbWzpg=;
        b=xkGEs3moBPAUJ7nHFK4miF5bdhmqq/ez8NegLiI0wWxDFnkaCjV8HSjjnD3ZPJodIj
         TgGv1d1bJZID/MLp9JM3NfKNxlmWk7i76aESVIs9KJAuhDSbkZIe8rtUb6ypbRJrgtVN
         LH2bPykHwLKEg/bxnrQA2vcic+w13kXvQSUovyIL5BHxITPXR1ccQWeGJAw1tfUFY88q
         Gy2z3XDAK2jqq7SHgLC0hF5LHwuX05wcZF9D7+fRzLY+a3GRbYve+400Z4npK0KO5fEU
         34M8bqi7jUW1dosTjkAhOUH3Ct8HQdYywp23eDMS/fhliBSE8KrS07wCvAnX5Lr51o4M
         Nueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BJi11oxy/mS8LpMJIiVF2RRtBr2FigKt0s6KyCbWzpg=;
        b=bVE1UK53tMCmih6Sd2CvjgIWa4Tivhxe396k6Zjh1LcWgxEyThF4n9y7ItWoNl/yoQ
         wfnJAa80qTgu5laPErxDLKIx0o2+qBZvMkAGLbNaLVwubGvvMr0y2xQ+IYHMTOyITdx+
         54VMMCKjnbSAXjO3tFSR5IEtDN8W3hZ8BAfv9YBczPkXPi99/slJB+NEm/0ul9/bylQx
         GLdkdW8ebGR6bVs1juqXNdAfkBTqDONkmQIQFjT2hm1Xw+T2xNd1oHlUDVLzVKppc2az
         bOpYNDdqiR8qkIJ2WBuUKAKTdjHVpYmRcPvohJqvrpR/gKjGut8kBTZ4hdrJrq7tjqfW
         mAdg==
X-Gm-Message-State: AOAM532NeH9dcn9hW4xJBctwWuWfQsc6P0YHebsMSKNvuLQE57+/BBE+
        TB/I4QZUD64vAHMok9Cd80F+m4Etu6tBQ8VbiHI=
X-Google-Smtp-Source: ABdhPJyoAaYIfYWxgkT2bZO4uSUa/SmkVEQ6NnUQ0fr8gEizusY/jvQGr9arSZiK09C2FT1YmKkNTg==
X-Received: by 2002:a02:c006:: with SMTP id y6mr11069106jai.125.1632515584054;
        Fri, 24 Sep 2021 13:33:04 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f20sm509125ile.57.2021.09.24.13.33.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 13:33:03 -0700 (PDT)
Subject: Re: [PATCH liburing] tests: test close with fixed file table
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <5e22cfaf9f0f513574a098dba6548cbb4fb5e2d8.1632510387.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2c5da0ef-c7e5-9030-45aa-a50bb4e341cc@kernel.dk>
Date:   Fri, 24 Sep 2021 14:33:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5e22cfaf9f0f513574a098dba6548cbb4fb5e2d8.1632510387.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 1:07 PM, Pavel Begunkov wrote:
> Test IO_CLOSE closing files in the fixed file table.

Applied, thanks.

-- 
Jens Axboe

