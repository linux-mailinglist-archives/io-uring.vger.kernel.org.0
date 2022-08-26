Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DDA5A2BF5
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 18:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243678AbiHZQGv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 12:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244475AbiHZQGt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 12:06:49 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAB6D4BFB
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 09:06:45 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b44so2645884edf.9
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 09:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=lNuUoGjB0N0z9P/4qDhLVr0L0/LOnmIFqtKh0E4MdJ0=;
        b=D8OvH8BBNxGtjlVTQaS9vMqeftoZOARDtL9IMcqJuPrCcDQYdNp3jCvd8H1GzBvna2
         nMI0mfnPaVg20+dWyXjHlOExtnsc0Mvf1laTklhgFXQJ6hZg7IThFmBbQpRmshRQZZeE
         eRWwtWCDNXESUCm0Jcn30AevPUhFYA0J1nfaM/2ee+mhydIJrEoT5EgALAIIRHmHC65T
         0dXos+5VORBQAJ/r8+sy/q3s7oOffIJHrZvtrjQmxHJ6z68mPYuqDh4eUV7n1aQdBbmr
         VjLiiJttrAzVPn2v2MFPGH1qTH9VV4abN9+UsMXgN2avqen7NWhDw7gUh3AdxbAmQcj6
         BpdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=lNuUoGjB0N0z9P/4qDhLVr0L0/LOnmIFqtKh0E4MdJ0=;
        b=3XHNTTUQ2SPN3sLaEjmulUHFn9+0fWdns/hmBGif7Qx0B2a9BTTOnF2i2g/rcq79Wx
         HzMGjtY9h9vezdwELogktVlXpc6i0XON+aAvnqjxY7iZ9ghwLcGPm5ciYdv3G87A76IN
         itqmIQC/r3NKccnBzUpmiYvvduQkgGxcujs6Pk+Np43JW2pl6v7t13dqXyjsZ57eFxxY
         PVgyOALdYlx9ZOLFdWygZg6sdr1rnYHzcS13HDVtBuUkOV2BEje/9hj0BzlxGrYaB96X
         BX2yMZ3a58wWH/aX9uMTQB8oMuxhPgkJXM3vfCGrMJRQIqY9NGjFKZFfrZ5pDOfPGm8O
         cAtg==
X-Gm-Message-State: ACgBeo006f/ZmgUEEyAdgt1Lo0nzIjFgZifTWsdyEbxmiolyL1INFMBz
        kRN1z/1YzdNtNkFBW70mRvSLlZCGFFU=
X-Google-Smtp-Source: AA6agR4DdLBPUMOmyDGYVmGhH7hcV5j6f963zQn2voFDld7L2sOQGATWWb+qurFcuiCBuKlLjp408w==
X-Received: by 2002:a05:6402:34c6:b0:43d:8cea:76c0 with SMTP id w6-20020a05640234c600b0043d8cea76c0mr7570623edc.268.1661530003212;
        Fri, 26 Aug 2022 09:06:43 -0700 (PDT)
Received: from [192.168.8.198] (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id v25-20020a056402175900b004462849aa06sm1499896edx.5.2022.08.26.09.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 09:06:42 -0700 (PDT)
Message-ID: <bdb69c4e-83e4-dec8-1885-f15745c997df@gmail.com>
Date:   Fri, 26 Aug 2022 17:05:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-5.20] io_uring/net: fix overexcessive retries
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <7ae9790cdf2f30cd381efda5b159ef95c88cf8eb.1661529830.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7ae9790cdf2f30cd381efda5b159ef95c88cf8eb.1661529830.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/26/22 17:04, Pavel Begunkov wrote:
> Lenght parameter of io_sg_from_iter() can be smaller than the iterator's
> size, as it's with TCP, so when we set from->count at the end of the
> function we truncate the iterator forcing TCP to return preliminary with
> a short send. It affects zerocopy sends with large payload sizes and
> leads to retries and possible request failures.

sent a wrong one, please ignore

-- 
Pavel Begunkov
