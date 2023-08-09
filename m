Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1623C77649C
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 18:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjHIQAD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 12:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbjHIQAC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 12:00:02 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52DF1FFE
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 08:59:54 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3175d5ca8dbso16270f8f.2
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 08:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691596793; x=1692201593;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+q6DaiLJBV30T6DYX+Orbh34q/bnM/nWV0t9bs3z+5E=;
        b=lqZSc8PV5GWBKqDKM9n9f8Z+klEZM6N618pwjhMaK58o8ln+tnku59OccDHkqWg6z0
         ngIGVrhRPtMPdgZfQ19lKDNxUPoAU2HOp14QeOVD61OxTnC+Hi8uRaekujhfvlkreVjY
         Rw8WFUeuqN6pNp2BZpNQrcGyVVMs1GtOWYy2rG0+fWriK9P/sbm3U+3V16+vI3CoUe3W
         AhHxQgPM8gJI1tdNJMaX0Q7j+Wqquf6vI5l/R91e1QMjbVsZuZx4kVsA68695B9vha7F
         a983CkF/E0EjFsOmoxbD6IzHSEsI1ORCS5sn6jZwt2U2K+5+TZt0zus7vlbCPoWQBKz0
         FnLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691596793; x=1692201593;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+q6DaiLJBV30T6DYX+Orbh34q/bnM/nWV0t9bs3z+5E=;
        b=TDP75Dfgkd390zmXsSTz+6bVHGnLnomQcOD4pgHs0hUiEtwEEkwH/oSu3uR6nOBG3H
         nAb2nflg0eByxJpZ/rBuTboGRcH9MZmkubRuHPJSk3F7BCGgl5KGeUcriVhfgA8aPcir
         Zv6sVaDzjHMZJVtbNJ7skAK5kto7+cTgkB+3R33WAn8Da5cK/1lhKK/XfSZvbuVsd+F5
         npywb15jaQ6Z73ew0f57Ji4p7Tmg9tT3rZ8/HQ/I4HR2maA3hHnyM2X48I7tsUOlwPjJ
         NFaArBJ43jAa8DpK4Kae9ML6XCcV1vpe/PRbZs5O7EMBPGmizKYf/LZG/mgqLh04lrGP
         p5nQ==
X-Gm-Message-State: AOJu0YxrfLzjG5QqVgy0I/eZpK/kWpVtGFN4aRmw7bcqQw9HH97pe837
        RvWAnC4a7oH9o7ZZTD6fFwndIfj4+28=
X-Google-Smtp-Source: AGHT+IGf518ysr2P/0T3SqaVdo2NEbOi3LdGNw20/JjfvnHkEUWjwZi0JsTqp6fXcsuXlp6tNVI12g==
X-Received: by 2002:adf:d0c2:0:b0:313:f98a:1fd3 with SMTP id z2-20020adfd0c2000000b00313f98a1fd3mr2435481wrh.27.1691596793100;
        Wed, 09 Aug 2023 08:59:53 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:c27f])
        by smtp.gmail.com with ESMTPSA id a23-20020a1709063e9700b00993150e5325sm8240942ejj.60.2023.08.09.08.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 08:59:52 -0700 (PDT)
Message-ID: <3dd335d1-74a0-3c76-190e-c6bfb24bf317@gmail.com>
Date:   Wed, 9 Aug 2023 16:58:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: break iopolling on signal
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <eeba551e82cad12af30c3220125eb6cb244cc94c.1691594339.git.asml.silence@gmail.com>
 <8d0fcef6-605c-4f67-8fc6-01065eedf725@kernel.dk>
 <b2b63fdc-d683-aaa1-8938-01665f99713a@gmail.com>
 <909349d4-af18-4001-828f-fccfc3f4e0e6@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <909349d4-af18-4001-828f-fccfc3f4e0e6@kernel.dk>
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

On 8/9/23 16:50, Jens Axboe wrote:
> On 8/9/23 9:38 AM, Pavel Begunkov wrote:
>> On 8/9/23 16:30, Jens Axboe wrote:
>>> On 8/9/23 9:20 AM, Pavel Begunkov wrote:
>>>> Don't keep spinning iopoll with a signal set. It'll eventually return
>>>> back, e.g. by virtue of need_resched(), but it's not a nice user
>>>> experience.
>>>
>>> I wonder if we shouldn't clean it up a bit while at it, the ret clearing
>>> is kind of odd and only used in that one loop? Makes the break
>>> conditions easier to read too, and makes it clear that we're returning
>>> 0/-error rather than zero-or-positive/-error as well.
>>
>> We can, but if we're backporting, which I suggest, let's better keep
>> it simple and do all that as a follow up.
> 
> Sure, that's fine too. But can you turn it into a series of 2 then, with
> the cleanup following?

Is there a master plan why it has to be in a patchset? I would prefer to
apply now if there are not concerns and send the second one later with
other cleanups, e.g. with the dummy_ubuf series.

But I can do a series if it has to be this way, I don't really care much.

-- 
Pavel Begunkov
