Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322A5527416
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 22:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbiENUxg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 16:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiENUxf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 16:53:35 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D49136161
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 13:53:32 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 137so10606766pgb.5
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 13:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=W0IcwkIC62+e9+CLItbBIFdA4NdjJHDiidWSiPECNao=;
        b=1va55SdIra2FARAV9Y0J2GNI9+Qu66opAxRPIfRI0B6n0775TD5FvL5meuOR6xr9O9
         CnYBcZp49a+FEAZLa5B+rnuMeqsHjTtwu4ie+nJYSukx/+hC6G/7x6Xtucl/Ut8rr468
         erzT42mAiP2ThAeHlVH8NoseMzU3uIrtF1R/O3XQrSmzrIi5Py0L9PquD5yG0NpTeXHR
         mb56QbMHeJ2PtHj181iiiWZIPtLABwnFmqI92jpbeWU4/JfY2G+P6UtoWN47+yqOiZnM
         kHAh3rumM9jUulnnJ0XsIWlWu97ZF0dYrLr71LftVjnFfrgUIN7ESZwzU3gSe6mvcTXP
         ObBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W0IcwkIC62+e9+CLItbBIFdA4NdjJHDiidWSiPECNao=;
        b=MVATPq1n3o1UUYE9M42al0sHSebiawOqBeoCPQu1Wo43tnLUdiaX1VNt7mw4aBfTPk
         usi9Vx7Siei8UiOFr6TdDcwqBhKuNpzYfpb1W+vMPZtBA1Mh5jrnkw2YYR/U346fXR0d
         L0jmcWxwWKItX0rP7MKszSfLaWJh8OPvNOGzXYxaiYN5Jt7ODcrIEZ9QB3ED6g91Z6fo
         +MUCHYbrusHW+U4SE+txfyuo3O8hMSAk01yctP4MmUKIzIzbw9hBpHxY0Rs/anrzocNI
         U4NMb8iMpalkRQotCPnsCKBmIi3m5VyKkxcVzhBJJahKysqRpY8MHZxftUQuZsQDotIH
         XgqQ==
X-Gm-Message-State: AOAM532RPjI1WggdiGLA2iUJ4cG2TBo6aJJnzRAaQImElGOcIGpJUHTx
        ca36VMZW+8Ms7bvWs0U0Rei+sA==
X-Google-Smtp-Source: ABdhPJxsykzDH5Tb1oGiwcHZL12XG4lDvhu60M0IyVwG2AnIYe4+BIvZxT+99k7W5ASNWy9D8j/HZg==
X-Received: by 2002:a63:f158:0:b0:3db:8563:e8f5 with SMTP id o24-20020a63f158000000b003db8563e8f5mr9205183pgk.191.1652561611440;
        Sat, 14 May 2022 13:53:31 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z12-20020a17090a540c00b001cd4989feb7sm5699900pjh.3.2022.05.14.13.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 May 2022 13:53:30 -0700 (PDT)
Message-ID: <c4bbbb3c-3a71-a759-7c68-a5dec356e884@kernel.dk>
Date:   Sat, 14 May 2022 14:53:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] sparse: use force attribute for __kernel_rwf_t casts
Content-Language: en-US
To:     Vasily Averin <vvs@openvz.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     kernel@openvz.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org
References: <45e8576e-5fcc-bc52-8805-0b5cc3fc1a84@openvz.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <45e8576e-5fcc-bc52-8805-0b5cc3fc1a84@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/14/22 10:23 AM, Vasily Averin wrote:
> Fixes sparse warnings:
> fs/io_uring.c: note: in included file (through include/trace/perf.h,
> include/trace/define_trace.h, include/trace/events/io_uring.h):
> ./include/trace/events/io_uring.h:488:1: sparse:
>  warning: incorrect type in assignment (different base types)
>     expected unsigned int [usertype] op_flags
>     got restricted __kernel_rwf_t const [usertype] rw_flags
> fs/io_uring.c:3164:23: sparse:
>  warning: incorrect type in assignment (different base types)
>     expected unsigned int [usertype] flags
>     got restricted __kernel_rwf_t
> fs/io_uring.c:3769:48: sparse:
>  warning: incorrect type in argument 2 (different base types)
>     expected restricted __kernel_rwf_t [usertype] flags
>     got unsigned int [usertype] flags

Hand applied for 5.19, didn't apply directly. At some point it'd be nice
to do the poll ones as they are the biggest issue wrt sparse, but
honestly I've never really been very motivated to fix those sparse
warnings as it would just be an unnecessary pain for backporting
patches.

-- 
Jens Axboe

