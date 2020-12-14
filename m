Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C762DA242
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 22:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503445AbgLNVDx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 16:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503453AbgLNVDp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 16:03:45 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B18C0613D3
        for <io-uring@vger.kernel.org>; Mon, 14 Dec 2020 13:03:05 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id v14so15024607wml.1
        for <io-uring@vger.kernel.org>; Mon, 14 Dec 2020 13:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=daj2jlYHrmNaYvggdrJzGAgVpT70LNvsHUDZAVuQfJ4=;
        b=VaYYYhM7LL1efg1CVPipu5T3RpymrGCmx0R2d5rLsgC5f1PK6dByvbLe91dXDJQpsh
         FjE8s+vkPpYsjrJeb8ALx+tCgue+qMPa+i/RyGeH1IPNLDRRUMpR3KBxXKJ3qHwDJN1/
         W4RkKVSFIwroUJEFMTKhboRqOmML614Nyqvm4962NTE3vN0J0uN9GyQZks6s6Iu6x6Mn
         ON1Jw0iX3136C+FhXThzMlbVCg/zeoK/JuUfADtVsyIvclL27IC6nZoTQ/Hm2pHR4gmD
         /zNsMq0V5lM4XyLT7LiU3lpdFne2bYUPWfHqcvv26WqFXS/lqbWIRwqI/hQ86hIWBEEb
         DQ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=daj2jlYHrmNaYvggdrJzGAgVpT70LNvsHUDZAVuQfJ4=;
        b=G8GQGVxwqCjrH7Co06Xu84BYdKLAH+4bhhofMkmVCqMaQkxHQj1UFfEpQnccJ/+ZPB
         ePRg4VcEsKYlFY9/nSPKDuwLzGWvUZ1ZLRpvuFBnuinxyJh09MWkDTLqc16zIkU+RCGr
         zV8cBnQfcpWteUdJIHl/1Gojn8g9NOVCO/booBAG3x4AJcyip7Kkhng0MkIMYK/0ShMB
         JG/GTxGRFnJxjfCUsEBI85Bn6ntabAtdL3m00+SJbeepcAA4ZR+p0SmYOrqvMlJzX0FU
         +SdURSp8z00alKHeJ9PIVWlBSNIMcLNiFms7YlRIw8yNcAB6py8aYTgX1F33kW3h8Ag5
         5qng==
X-Gm-Message-State: AOAM530Oovz566HZ5whc/G7EJgiAbF9EF7hr4+PrXas9+pcdS8B+9PYG
        ssAt2umvDF9eDNijvXO0G3Fvko9+9HQrkg==
X-Google-Smtp-Source: ABdhPJxt8RVJzlpOw5uKl4XP6j8jxkO3fArzynhfsjJflos+6wX46iGf1b/2V5H2fhu+6skzl23ilA==
X-Received: by 2002:a1c:6056:: with SMTP id u83mr29014468wmb.90.1607979783486;
        Mon, 14 Dec 2020 13:03:03 -0800 (PST)
Received: from [192.168.8.128] ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id l16sm34461452wrx.5.2020.12.14.13.03.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 13:03:03 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <e8afcd4c-37b8-f02e-c648-4cd14f12636a@oracle.com>
 <b9379af3-c7cc-03ca-8510-7803b54ae7e9@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 00/13] io_uring: buffer registration enhancements
Message-ID: <b6736e0e-157b-a5ee-a3fb-e40903343d2b@gmail.com>
Date:   Mon, 14 Dec 2020 20:59:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b9379af3-c7cc-03ca-8510-7803b54ae7e9@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/12/2020 19:29, Jens Axboe wrote:
> On 12/14/20 12:09 PM, Bijan Mottahedeh wrote:
>> Just a ping.  Anything I can do to facilitate the review, please let me 
>> know.
> 
> I'll get to this soon - sorry that this means that it'll miss 5.11, but
> I wanted to make sure that we get this absolutely right. It is
> definitely an interesting and useful feature, but worth spending the
> necessary time on to ensure we don't have any mistakes we'll regret
> later.

I'll take a look as I familiarised myself with it before.
Also, io-wq punting is probably needed to be fixed first.

> For your question, yes I think we could add sqe->update_flags (something
> like that) and union it with the other flags, and add a flag that means
> we're updating buffers instead of files. A bit iffy with the naming of
> the opcode itself, but probably still a useful way to go.

#define OPCODE_UPDATE_RESOURCES OPCODE_UPDATE_FILES

With define + documenting that they're same IMHO should be fine.

> 
> I'd also love to see a bunch of test cases for this that exercise all
> parts of it.
> 

-- 
Pavel Begunkov
