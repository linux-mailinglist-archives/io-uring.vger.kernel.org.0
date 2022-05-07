Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145C951E86A
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 18:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240370AbiEGQJn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 12:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386035AbiEGQIo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 12:08:44 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6803F2C113;
        Sat,  7 May 2022 09:04:57 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d17so10165035plg.0;
        Sat, 07 May 2022 09:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=s4K96oJ0ziXnyxhriolWRSu89A5Glyep2GcJ20fGurs=;
        b=XxIGeT9nXoZy7nGhniSiMtmTRPhAq3a0wnXQ6T/G2nOOIi/55rtEVFKT/OChWphIWD
         EyIGWezWhZTbWrH9K0PwctUzQdtpobq3yG+1OyispVkYvXPgSpkhGsmnFeHClpOeZlhz
         PIQs8rKthGSI+mZC7Ff1mXsZBq+DF838oVAwsocHRx4ggEeOZipZFVx0rmN44VTMo5Gv
         WWrvKGNhuLUbnL+5FeCiHFQVsI/oe6tJOFDbF1cpPOPiflOYW28FBhLa8xc4Z+L5Rvna
         YPj9A5tSvTnpTyRQO6eAivtzgEbMBZl6ee/sspUtJim0ImvrHiwheiZCTj7Lld8GG+aS
         G8+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s4K96oJ0ziXnyxhriolWRSu89A5Glyep2GcJ20fGurs=;
        b=RgzQKv8QWxRnjSyFD/9Z2Y0Rw0P+RgGPhlilGued0QzpffV8dfwy6jECeDogmHY4kY
         yqAn3o5sYs+Gr5Givhhsqaid9axaY7/EAzsBR1xJYFcY9B6t6IdEyH9hRx6Qq7zcUVU+
         Ve8gvYtqy08/hJXJnlPXsVozlh7vCjzE0afQAACG3/Ed8QxwBz5Lg3yQCacfKVHzMLpu
         YEve1+aL6v9E5je81uX5NQpPuQwhv4JdpNpiY7OPs8kD4NaDhhOMCTcKG8j5ZDDD8m1m
         dohLuo4rauio20Ov0U2XO+qpvRw7iJUQBBKwGf5kDYB+S+nc5fDqJQdAN6CK/6D+69NP
         WtnQ==
X-Gm-Message-State: AOAM532tAPF2kL2yEb0Eb3QEv9NdPCoihwYHp7bC/3FV2WZAYKRBBDvh
        o0OJQANbU/QK5yDg3+uRsjRU65A2vyYhVrDJj38=
X-Google-Smtp-Source: ABdhPJwpeoH3Y/fdS1SXYkmYDYROPsTSgS3ifXogSmI6gmeh9Prk8v7eQMuRML4aHNZhC/hFrRVhyw==
X-Received: by 2002:a17:903:2406:b0:158:f6f0:6c44 with SMTP id e6-20020a170903240600b00158f6f06c44mr8688426plo.88.1651939496930;
        Sat, 07 May 2022 09:04:56 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id gt9-20020a17090af2c900b001dc1e6db7c2sm9266942pjb.57.2022.05.07.09.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 09:04:56 -0700 (PDT)
Message-ID: <390a7780-b02b-b086-803c-a8540abfd436@gmail.com>
Date:   Sun, 8 May 2022 00:05:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v3 0/4] fast poll multishot mode
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
 <305fd65b-310c-9a9b-cb8c-6cbc3d00dbcb@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <305fd65b-310c-9a9b-cb8c-6cbc3d00dbcb@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/7 下午11:28, Jens Axboe 写道:
> On 5/7/22 8:06 AM, Hao Xu wrote:
>> Let multishot support multishot mode, currently only add accept as its
>> first comsumer.
> 
> consumer
> 
>> theoretical analysis:
>>    1) when connections come in fast
>>      - singleshot:
>>                add accept sqe(userpsace) --> accept inline
> 
> userspace
> 
>>                                ^                 |
>>                                |-----------------|
>>      - multishot:
>>               add accept sqe(userspace) --> accept inline
>>                                                ^     |
>>                                                |--*--|
>>
>>      we do accept repeatedly in * place until get EAGAIN
>>
>>    2) when connections come in at a low pressure
>>      similar thing like 1), we reduce a lot of userspace-kernel context
>>      switch and useless vfs_poll()
> 
> Overall this looks better than v2 for sure, just some minor tweaks
> needed I believe.
> 
> But we still need to consider direct accept with multishot... Should
> probably be an add-on patch as I think it'd get a bit more complicated
> if we need to be able to cheaply find an available free fixed fd slot.
> I'll try and play with that.

I'm tending to use a new mail account to send v4 rather than the gmail
account since the git issue seems to be network related.
I'll also think about the fixed fd problem.

Thanks,
Hao

> 

