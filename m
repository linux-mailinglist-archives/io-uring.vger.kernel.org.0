Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C9757FE60
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 13:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbiGYL2v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 07:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbiGYL2u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 07:28:50 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D349A95BD
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 04:28:49 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id a18-20020a05600c349200b003a30de68697so7569588wmq.0
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 04:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wVt7pReOUwLLuMvx0fA+mcgP/80BKgDK8O0XfZj/YA0=;
        b=ExZsVv+TjbHSSHHyA5+es/DWsXWhbRHqkXgt3T6+2LuFop59rrfYUnMU1ThEvg5Gyv
         HekCmzueMWvr/7c3CcjiYZaap+W0/Au5CTNjuS2HZTk4N6WGLTHuehNIbWeOHzsAmDQf
         lIevIxf8bJuu9+py9FOa85yLa9FCd7NvwgM82rNccbx1I5JqM9CaLJs0V0wwuyTkVk6B
         rkZg9dWlEP6dbGzqLlxgWDyrqXsXDwjAKkDkpBmdKTrDhjrXL9vB5fUhB+GKv3A5+d2E
         gZQ6Egj0NzPi/VI3wkoCcaBzKH9evCOCvUNu2ghdIaFHxpOoTscz2Brgm6GEWmBPJt04
         PlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wVt7pReOUwLLuMvx0fA+mcgP/80BKgDK8O0XfZj/YA0=;
        b=srBHX7mbmKJRagYUGZG9UYsJkarPCcKOQcmXpNyA6mV+7300EM5XGub6rjwkYj/7Ik
         4/m2rKy4ATtyenlX6fb/1hD62QF6rePLkxistUntWrxSeLlGwDXOe8bAqJ4b2l3AxS7S
         77W5Dxl3Bo27M9JYvjgXHXtWqZS1hanihpxSZZwIjBJ0igZ3CvyimGz9mlimu/BfiWId
         RB3tDAXWiuQGu8rcHGM9tPsVMJ7d9heZF1HqeCSnptsgDR04kQwm2qzNrOHAFirdMXoN
         BzbiSRaZSb+30ETuDfTdCuS3fWZHS5EwQpFWytJwa2wIoKxVIJdYv71W3OMjrEVHJ9Q7
         1BRw==
X-Gm-Message-State: AJIora+bjuKZHkUtdm717B64uNBD0u6Sj+stfjncIArAJr5gc9M6aALy
        cxG0IJntriHJmjOtHrVbhexesh3TAbR5AQ==
X-Google-Smtp-Source: AGRyM1s3oICBD0oN0RoOK28RJqF3L29ogE5JmKYu9sccj9axeh+6C0o2Q9nApwZraErDgWShCPf/5g==
X-Received: by 2002:a05:600c:17c7:b0:3a3:f1:148c with SMTP id y7-20020a05600c17c700b003a300f1148cmr21540305wmo.32.1658748528074;
        Mon, 25 Jul 2022 04:28:48 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:f25])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b003a30af0ec83sm15352271wmq.25.2022.07.25.04.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 04:28:47 -0700 (PDT)
Message-ID: <c89d373f-bc0d-dccf-630f-763e8e1a0fe5@gmail.com>
Date:   Mon, 25 Jul 2022 12:28:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 3/4] tests: add tests for zerocopy send and
 notifications
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1658743360.git.asml.silence@gmail.com>
 <92dccd4b172d5511646d72c51205241aa2e62458.1658743360.git.asml.silence@gmail.com>
 <bf034949-b5b3-f155-ca33-781712273881@gnuweeb.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bf034949-b5b3-f155-ca33-781712273881@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/22 11:35, Ammar Faizi wrote:
> On 7/25/22 5:03 PM, Pavel Begunkov wrote:> diff --git a/test/Makefile b/test/Makefile
>> index 8945368..7b6018c 100644
>> --- a/test/Makefile
>> +++ b/test/Makefile
>> @@ -175,6 +175,7 @@ test_srcs := \
>>       xattr.c \
>>       skip-cqe.c \
>>       single-issuer.c \
>> +    send-zcopy.c \
>>       # EOL
> 
> I have been trying to keep this list sorted alphabetically. Can we?

Don't see any reason for that, especially since it's not sorted.


>> +int main(int argc, char *argv[])
>> +{
>> +    struct io_uring ring;
>> +    int i, ret, sp[2];
>> +
>> +    if (argc > 1)
>> +        return 0;
> 
> New test should use the provided exit code protocol. This should have
> been "return T_EXIT_SKIP;"

Oh, I already hate those rules, sounds like they were specifically
honed to make patching harder. By the way, while we're at it,
what is T_EXIT_ERROR? Why it's not used anywhere and how it's
different from T_EXIT_FAIL?


>> +    ret = io_uring_queue_init(32, &ring, 0);
>> +    if (ret) {
>> +        fprintf(stderr, "queue init failed: %d\n", ret);
>> +        return 1;
>> +    }
> 
> This should have been "return T_EXIT_FAIL;".
> 
>> +    ret = register_notifications(&ring);
>> +    if (ret == -EINVAL) {
>> +        printf("sendzc is not supported, skip\n");
>> +        return 0;
>> +    } else if (ret) {
>> +        fprintf(stderr, "register notif failed %i\n", ret);
>> +        return 1;
>> +    }
> [...]
>> +
>> +out:
>> +    io_uring_queue_exit(&ring);
>> +    close(sp[0]);
>> +    close(sp[1]);
>> +    return 0;
>> +}
> 
> and so on...
> 

-- 
Pavel Begunkov
