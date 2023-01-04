Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E9E65CB92
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 02:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238928AbjADBip (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Jan 2023 20:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbjADBiQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Jan 2023 20:38:16 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD74418384
        for <io-uring@vger.kernel.org>; Tue,  3 Jan 2023 17:38:08 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id j17so26276417wrr.7
        for <io-uring@vger.kernel.org>; Tue, 03 Jan 2023 17:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qtZeirkD4eEqFr/HnOAx20TKEjwS2LL0U3CO5tzJMo0=;
        b=Dt60eVUBOxt8jpwz5fBta9ISw6bVji4QUEhxV+V8f8JvrqIe7ufC9GpFdXL514MJBV
         Mno4DlZqoIkE7EHVm5Mj10Ijt1631vXy2XZvAtlDQFhzB7OgmB29hVS7umbNRajDWDJo
         006yxSGiZtBcbSABrhrXzYI2AjUPKvMRxQddsxoCg2uGSd6iSVPaXB7r79LE2FxZBN4H
         1Y4hT2kLaIjVYpbmscjQqxj5tcPaVpiRn/2+vXvHGd7bj+ai5W42rlsOTZeald1Gsam9
         ChsN+rN77998faXUN6YJYbtRJdRHC6ebjfj/aJrcCGG8DduySNKmtliv8fxOg8vcU/yK
         cmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qtZeirkD4eEqFr/HnOAx20TKEjwS2LL0U3CO5tzJMo0=;
        b=d5F16oMoGcIH0V2KMCKa++Q/s7uF/PsIxWF+UkQPevf9tGU7sAAjTvjf2/lFwKKv6b
         q6cROBj1aSxswxaIiVoPc+4pSMZLM9MR4zm3/NFWfVA9CvXVVHpI2bmM+WaG+gKQ+j3n
         0hvjTeuWTuFpyS/sjug/5Uu9tUAfhwAwyH1L52JRJm4lctdpcIS3vfmQ4vANzWe7iQm8
         dJ75y0u/qBlF+GDgJ3M5atzI4qtBZnW9ySZajPfrGrbUnhJBV6j+ElJpXp166EiPxfQj
         VVfkpfBDtUI9Gq53qhjhVGC1Rw1To2tc1N2cENBlpywcU+JPlvCi7gjMmE4BE1qhxHw2
         wOig==
X-Gm-Message-State: AFqh2kpsgOnx1hDlKEGYM1bA+XzFLfTEm2jCnR8qdzYfhVf+4r2g7m1i
        dAtMfe/+wNl3JJMpKpV7rBVs0Omlnm4=
X-Google-Smtp-Source: AMrXdXsKkGdCn5ojLtbp5ANtW6FgdFUTZy1vppgA+gv5NX8Nags+jdRTWYIYwUHhXOvurhZYO+Sdkg==
X-Received: by 2002:a5d:46cd:0:b0:27d:2662:9378 with SMTP id g13-20020a5d46cd000000b0027d26629378mr22623055wrs.37.1672796287129;
        Tue, 03 Jan 2023 17:38:07 -0800 (PST)
Received: from [192.168.8.100] (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id r15-20020a0560001b8f00b002709e616fa2sm32475492wru.64.2023.01.03.17.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 17:38:06 -0800 (PST)
Message-ID: <a22cbee4-3aa6-33f8-f7d2-f1d4c615d68c@gmail.com>
Date:   Wed, 4 Jan 2023 01:36:42 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC 1/1] io_uring: pin context while queueing deferred tw
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <1a79362b9c10b8523ef70b061d96523650a23344.1672795998.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1a79362b9c10b8523ef70b061d96523650a23344.1672795998.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/23 01:34, Pavel Begunkov wrote:

Damn, the subj is wrong, it's not an RFC. Same with the other patch

> Unlike normal tw, nothing prevents deferred tw to be executed right
> after an tw item added to ->work_llist in io_req_local_work_add(). For
> instance, the waiting task may get waken up by CQ posting or a normal
> tw. Thus we need to pin the ring for the rest of io_req_local_work_add()
> 
> Cc: stable@vger.kernel.org
> Fixes: c0e0d6ba25f18 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")

-- 
Pavel Begunkov
