Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372E651DCBD
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443304AbiEFQFh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 12:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245722AbiEFQFh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 12:05:37 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABD04FC76;
        Fri,  6 May 2022 09:01:53 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d5so10620121wrb.6;
        Fri, 06 May 2022 09:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AwSYpzjiuqhVZgVPF7sxtuhyEtMKkN0i872NpkdZC/o=;
        b=K4ZCXudwqosKXBiPTFH14TBwZpj5m6O78LEVT7YneZpZBQiBG19Qbwn/jB0RIQHD5V
         bCi1BEccpXG0iBXo+uYUcTbcDyXZmgBM/G1XPXH01W4KzzfMKtG/sd1hU5cg7xIdwstC
         tg9pfsTRDvhwMViw4CnA1TukBbBilgJUq4T2nrBHiNhqGU1asEXvV2yyQhFCQl4huUTv
         Hi4zlJagsH3CD3gbwcKbjIuLufD+UlF9rE/xS81VH8zJz49qrg2nMw3A5NwIrG3IQQZ0
         2Ei3TU1eI5thG0LYe6hP+m/gAWzvZ7IqdpbZq6N9wNfUSDm6U1iGjERhywvMsM4S1zqJ
         gbWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AwSYpzjiuqhVZgVPF7sxtuhyEtMKkN0i872NpkdZC/o=;
        b=HVXbf2QFfHRDNxIXcSnZyrvMgxOFc6s76McXMsPIa7tdYDYiIOQGsY178MNPv8TAQ+
         LkyOCp81TEiVnImXOQdt8W8qneYwEH8iqYtKEYf5uq1mbCTI3Gt2/AeeElkS479Erti5
         RBu8SIIGfWKIhEr+HSEfIOuZ0yRT6fzpfP87hrN2Jof+Aly1THdYyqLL4uKG8e/hM9H0
         Ws0lgpiB9IJDLoppdfQT5HhMVSdB6rILg2tispx5nIoF1OXcyCyuRvkbb76lpO54tWsE
         UG/pCJHTTpee5Sg+dlj/DjbbMU9nisEZish29I/Qs2QlEIf31J7A9qG8+meMi2n3hxLI
         O1wQ==
X-Gm-Message-State: AOAM530Kr4PuHW/SaW4HxxO7Kdpz+TN1b5BsFYzc14bYS+IWfO/u5uDJ
        cT3KmOpQhUtLT9vchE1/mSI=
X-Google-Smtp-Source: ABdhPJzL7lS0966E7B6W4dvbvOQeEUGgPCOuIk2MX/tVqezgIyS8z33FYy1vbahu5shC4On0eo14eA==
X-Received: by 2002:adf:d1ec:0:b0:20c:61ef:93b6 with SMTP id g12-20020adfd1ec000000b0020c61ef93b6mr3263663wrd.694.1651852912296;
        Fri, 06 May 2022 09:01:52 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.237.75])
        by smtp.gmail.com with ESMTPSA id x18-20020adfdd92000000b0020c5253d915sm3907343wrl.97.2022.05.06.09.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 09:01:51 -0700 (PDT)
Message-ID: <3f940dad-73ce-4ea6-dc76-f877c64dbb9a@gmail.com>
Date:   Fri, 6 May 2022 17:01:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 0/5] fast poll multishot mode
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu.linux@gmail.com>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <b4d23f42-36f4-353a-1f44-c12178f0a2b3@gmail.com>
 <5ce3d6c7-42f9-28c3-0800-4da399adaaea@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5ce3d6c7-42f9-28c3-0800-4da399adaaea@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 15:18, Jens Axboe wrote:
> On 5/6/22 1:36 AM, Hao Xu wrote:
>> Hi All,
>> I actually had a question about the current poll code, from the code it
>> seems when we cancel a poll-like request, it will ignore the existing
>> events and just raise a -ECANCELED cqe though I haven't tested it. Is
>> this by design or am I missing something?
> 
> That's by design, but honestly I don't think anyone considered the case
> where it's being canceled but has events already. For that case, I think
> we should follow the usual logic of only returning an error (canceled)
> if we don't have events, if we have events just return them. For
> multi-shot, obviously also terminate, but same logic there.

Why would we care? It's inherently racy in any case and any
user not handling this is already screwed.

-- 
Pavel Begunkov
