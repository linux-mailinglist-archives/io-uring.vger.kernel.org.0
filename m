Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7437578756B
	for <lists+io-uring@lfdr.de>; Thu, 24 Aug 2023 18:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241198AbjHXQcm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 12:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242563AbjHXQc0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 12:32:26 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CEAE6A
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 09:32:24 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-977e0fbd742so881670866b.2
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 09:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692894743; x=1693499543;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kkOY0ARJd8ovr14BjtJ9vmD7tVtvWhlfvv+H6+a+0CA=;
        b=SlnM+dRoRW0SMsoF6qVcfJ1qPAx3+77OytXvdSSTenI3bHUQsB6VZiYEptBhEQ5CaR
         h1WqWSmdSfqsx6icNF4JYKXyaMnVlwd/wT4VWF09CrHhtwihGTHoTfR42XKD0RslV0YQ
         rA0sXkYPfE1PX7k+/6rjR/7uQ3jUKySiH2JrB+GBcqDrNDeBP0k2IRshcvPh0Ac4pfU3
         mod4ryBTxH0c1TddQz9tkDc6ckHMT4crHH3BQv6WnjS15JKz2i7bvb2bR1n7ua1uW0v+
         zTTaD/wU40C9L4XxiJLmw4q/RQMw0R2R6atf5MW+Up000Qz3804erlJ7s13KLI+aIFyD
         c3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692894743; x=1693499543;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kkOY0ARJd8ovr14BjtJ9vmD7tVtvWhlfvv+H6+a+0CA=;
        b=GQqYfn5hFriX3dAAkDZemj6EmtD+/hSJ8L2M4qkxkRZz3Xg0UjJ5cmeltF9Gr6GY2R
         HJK1xzcj13W59hEgby4PA2XG+R3xd9mlop4LLObZIJEke3o+CK6f+7iY75NHwChZbjM2
         kk4U/UeMntSLH4WtUfDo3ehTaEhAX539/0eMH+4vEVWKpiWZ09lUdLvvI98RC5fvXCI+
         eyyzlV0uPTcOuaAkecvh7j9I/Ak1x1MuuubN2HX4EfTTmvKgAM5CVMpoET8DeGr2AXvc
         CC+/xEVD4g/8+dfJEGJo4rDyCt/FU1/dGCSL3wSh+JT3gfbggeZTZUq1WF3OXmfdE68R
         L9DA==
X-Gm-Message-State: AOJu0Yz6UCd3bGnb1VTD9rWt/q3bBViceUbWPTggihXA437NZS1V7B9M
        zKOEJUX+lsuOwNNQeiT2T0M=
X-Google-Smtp-Source: AGHT+IG/RNHmNQat2NhJLn7CJT7n0+MCEGEpfzB/Mp0fMYNmyeYwNuLMOKOyJJa79TAVzofbnwNqjg==
X-Received: by 2002:a17:907:b11:b0:99e:1e9:fea4 with SMTP id h17-20020a1709070b1100b0099e01e9fea4mr12661654ejl.51.1692894743003;
        Thu, 24 Aug 2023 09:32:23 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id bs9-20020a170906d1c900b0099bcd1fa5b0sm11090447ejb.192.2023.08.24.09.32.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 09:32:22 -0700 (PDT)
Message-ID: <a47bdc68-10be-2e27-0f03-73a4b992b2a2@gmail.com>
Date:   Thu, 24 Aug 2023 17:29:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] io_uring: compact SQ/CQ heads/tails
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1692119257.git.asml.silence@gmail.com>
 <5e3fade0f17f0357684536d77bc75e0028f2b62e.1692119257.git.asml.silence@gmail.com>
 <7032cd8d-86ec-4e26-8632-8c3f66ec4db5@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7032cd8d-86ec-4e26-8632-8c3f66ec4db5@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/23 16:05, Jens Axboe wrote:
> On 8/15/23 11:31 AM, Pavel Begunkov wrote:
>> Queues heads and tails cache line aligned. That makes sq, cq taking 4
>> lines or 5 lines if we include the rest of struct io_rings (e.g.
>> sq_flags is frequently accessed).
>>
>> Since modern io_uring is mostly single threaded, it doesn't make much
>> send to sread them as such, it wastes space and puts additional pressure
> 
> "sense to spread". Can fix up while applying. Change itself looks good
> to me.

I'll be resending as we agreed, will fix it up, thanks

-- 
Pavel Begunkov
