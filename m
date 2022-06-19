Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDD7550B3C
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 16:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbiFSOwj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 10:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbiFSOwj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 10:52:39 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4153CBE34
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 07:52:38 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id n20so9920628ejz.10
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 07:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=g65YO1DxQXTCdhwazI+h8JdKROtcP8dj1gcTNPBcudE=;
        b=qfJ8ZIIjaYwmTP2QGgeFLTb2Pk0T6FY7srZG65GweY4UtO9n+4/PVYQL1flE8SZ3eQ
         8EZAJT/FUdTXhKfNJdohURnnSTdZeUUW/9iP/DpPFf06Z2HkcVSO3s2YzI6akN92PjyD
         XLnoXM717VsWDqrpwiD2B2fUhi2MGxzjU9VaKpNAtnstVCp6hZqbolRtgKYf2NSw+aAB
         +vJUtPKlnb/GTpCXM2o4ro0iph3bHasKIZ0i4KyIWGOfhcVe5wxWfS6K1aLgQ4XuKPwf
         Wqf1dMqgA31GHPMSP/ahs6G+c9Vap/BQGUTwWrDviiFjgxl3bMs+3DHr0yy2iEkV5emz
         5cfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g65YO1DxQXTCdhwazI+h8JdKROtcP8dj1gcTNPBcudE=;
        b=N0FvnunxOg8NjCj60Et+ZLp1BjS63X6A41W+8jXcvFOx1ZGjPiEikJJDAB+CIBMlzF
         EgNUxHt1yhTJ/DFXZhJM6NW+rKLQcg+4JW++aHO5iqkln+a69eR/z4bbzwwkgJpuO2Ut
         52g4eL8HvYb+njFYD0gblZ5f2JpT8s0hX3Vn8Swhmf96SLc2raoGrqknJ7ZVHNdrmglc
         tgLusPIUxGioSYgPK/9zVJsBTr0fXaM+1u5co3YdMfSRm9HL2ntqmW2alkirLl4opROd
         jANlNjAj14a6UjyyXxUI1gHaSJOtlwMBOCajuPJyg8qvVTthoNN5orEDqEI9yqcnNYEJ
         P+UQ==
X-Gm-Message-State: AJIora9XqVVrsDOBLLUE1unsr0FkEtEXicaGhsCF97sNP/WO0j5c7hqH
        F5ZOQzDyjrGrFN1t+MU5M23YtTyAciG+rg==
X-Google-Smtp-Source: AGRyM1tss0YPFZZRot4j+Zhcctivw+kiuDkTSoUT+EzHqBiwusUDyXsN2XGYrKbmbjR7G4HICJDP8A==
X-Received: by 2002:a17:906:7a19:b0:711:f5c8:2287 with SMTP id d25-20020a1709067a1900b00711f5c82287mr17693339ejo.286.1655650356705;
        Sun, 19 Jun 2022 07:52:36 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id y3-20020a056402358300b0042dc25fdf5bsm8137858edc.29.2022.06.19.07.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 07:52:36 -0700 (PDT)
Message-ID: <f42c7b8d-b144-434e-64a0-842209bdf31a@gmail.com>
Date:   Sun, 19 Jun 2022 15:52:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 5/7] io_uring: remove ->flush_cqes optimisation
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1655637157.git.asml.silence@gmail.com>
 <692e81eeddccc096f449a7960365fa7b4a18f8e6.1655637157.git.asml.silence@gmail.com>
 <1f573b6b-916a-124c-efa1-55f7274d0044@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1f573b6b-916a-124c-efa1-55f7274d0044@kernel.dk>
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

On 6/19/22 14:31, Jens Axboe wrote:
> On 6/19/22 5:26 AM, Pavel Begunkov wrote:
>> It's not clear how widely used IOSQE_CQE_SKIP_SUCCESS is, and how often
>> ->flush_cqes flag prevents from completion being flushed. Sometimes it's
>> high level of concurrency that enables it at least for one CQE, but
>> sometimes it doesn't save much because nobody waiting on the CQ.
>>
>> Remove ->flush_cqes flag and the optimisation, it should benefit the
>> normal use case. Note, that there is no spurious eventfd problem with
>> that as checks for spuriousness were incorporated into
>> io_eventfd_signal().
> 
> Would be note to quantify, which should be pretty easy. Eg run a nop
> workload, then run the same but with CQE_SKIP_SUCCESS set. That'd take
> it to the extreme, and I do think it'd be nice to have an understanding
> of how big the gap could potentially be.
> 
> With luck, it doesn't really matter. Always nice to kill stuff like
> this, if it isn't that impactful.

Trying without this patch nops32 (submit 32 nops, complete all, repeat).

1) all CQE_SKIP:
	~51 Mreqs/s
2) all CQE_SKIP but last, so it triggers locking + *ev_posted()
	~49 Mreq/s
3) same as 2) but another task waits on CQ (so we call wake_up_all)
	~36 Mreq/s

And that's more or less expected. What is more interesting for me
is how often for those using CQE_SKIP it helps to avoid this
ev_posted()/etc. They obviously can't just mark all requests
with it, and most probably helping only some quite niche cases.

-- 
Pavel Begunkov
