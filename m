Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCC553E604
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 19:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbiFFMDC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 08:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbiFFMDB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 08:03:01 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71BADF2D
        for <io-uring@vger.kernel.org>; Mon,  6 Jun 2022 05:02:57 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u3so19581500wrg.3
        for <io-uring@vger.kernel.org>; Mon, 06 Jun 2022 05:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mc0BlAqo7oQ8JofPW/vXZ+AflRVxHQLVbCUNraNrU9k=;
        b=VIc3tyoPqUCQWUkKrW5hCM83wWelntgvlkCsEbI7A7H/1kdws2iBr1Y4PzC7aLncXM
         XMffqoUirHIow4CqmLYhrzc7dYk9ESKg5cSZwRgT8Pnzh0yNSdYEc1q0sEWio+BryRh8
         T4N/1ZkJWfx4e70w80mU2nTNF9kc+mPCYf2aFry7mLY3AiRmqgZxCa7yPE8ikVl8TvTk
         iAlvhFum+OWhAToOvFUojdFvP3LNsBzYcHckh7pbR2IIQwt51WsHTEvG7lWQhjXV4n8d
         4Opm0ewSvcukplnYklh90dsCIUHGETDD2ZUYTyzaYoWnmLTOnA07HyW4Bryl7u6O18E9
         h1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mc0BlAqo7oQ8JofPW/vXZ+AflRVxHQLVbCUNraNrU9k=;
        b=hFTaeAhs3o8zmj0Q+MXakrpcDjuDNYI6P1JP13/3S8OwJ23O0d4453e12KmKFpwGZm
         WXJVMSsdi5LsxeqTe8G2FBLbEfDT3+/+fnxIKABScYfMcqIiGLdXcCTFS6esQQes4lzQ
         L+hE5GZeLWX/tGlHukyDo2fPM00BxA1G1zY2mDbGeUdReFcZr/jeJErilb0kQSw3lrR5
         gTNODvkQbL7oIlZDlUPoBArkKNRWgVC+hk+5AxbScrYAghtCcC5+kBUdSJH+Ng+wbsEu
         TU2j6crBD/JBznKbhqOOMtOPU/eg7GUYlTJmh2lujkB5WwYNHmm4dR2vWbR0h/ckIFYS
         HksQ==
X-Gm-Message-State: AOAM532dziK9SmXI8JCkRzdBY2quDFAOmsjWKjXdgWX0c5Zyt0QscB3i
        0y8mjLKDFWSf/bmf0pOzzrY=
X-Google-Smtp-Source: ABdhPJxeEctZSWo0hLmaSApqvbZjkTid8TWCWJWwHVQDcadgj2RAJXq4/6nnfaXgQ7n8FzvLbqCSXg==
X-Received: by 2002:adf:eeca:0:b0:217:56ae:c657 with SMTP id a10-20020adfeeca000000b0021756aec657mr7693642wrp.210.1654516976045;
        Mon, 06 Jun 2022 05:02:56 -0700 (PDT)
Received: from [192.168.43.77] (82-132-232-174.dab.02.net. [82.132.232.174])
        by smtp.gmail.com with ESMTPSA id o10-20020a5d474a000000b002184a3a3641sm1033wrs.100.2022.06.06.05.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 05:02:55 -0700 (PDT)
Message-ID: <0316d33e-4d72-7afb-ba9a-127e3427a228@gmail.com>
Date:   Mon, 6 Jun 2022 13:02:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 0/3] cancel_hash per entry lock
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220606065716.270879-1-haoxu.linux@icloud.com>
 <da7624f0-ed08-eb94-621e-ed3e0751dfed@icloud.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <da7624f0-ed08-eb94-621e-ed3e0751dfed@icloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/6/22 08:06, Hao Xu wrote:
> On 6/6/22 14:57, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> Make per entry lock for cancel_hash array, this reduces usage of
>> completion_lock and contension between cancel_hash entries.
>>
>> v1->v2:
>>   - Add per entry lock for poll/apoll task work code which was missed
>>     in v1
>>   - add an member in io_kiocb to track req's indice in cancel_hash
> 
> Tried to test it with many poll_add IOSQQE_ASYNC requests but turned out
> that there is little conpletion_lock contention, so no visible change in
> data. But I still think this may be good for cancel_hash access in some
> real cases where completion lock matters.

Conceptually I don't mind it, but let me ask in what
circumstances you expect it to make a difference? And
what can we do to get favourable numbers? For instance,
how many CPUs io-wq was using?

-- 
Pavel Begunkov
