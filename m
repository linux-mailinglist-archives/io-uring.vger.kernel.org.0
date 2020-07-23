Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C60022B693
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 21:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgGWTME (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 15:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgGWTME (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 15:12:04 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A46C0619DC
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 12:12:04 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z18so2625654wrm.12
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 12:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AB/hMRLGEmCvwZUm1C0e39Q+MdWsYPE9hn7PuERXKpw=;
        b=tkC3R8/LeA3p0tUzZgOOphnpTu2dQRMHbpQw35tLjnwiiFvxl63030Aq86tnfWsjAi
         CqKJ36/9YihXJyIIAKBgX0t7m+Z/yl3k02YaEAs2ZQ9DeujUhcrkB7vQaGAZ/8SaG0pM
         oIUcoSnRk6s65cjPTz9AnljdmAq6fXQAOGLAl16CeP91nwVVOYvIbve8Mfe1/Ks3/3RW
         O47qS4BuUuTQo4TkepYx+aPhauT3RADPzXH6F/X6muIilFz6RZl8ZCHvKZg2crv88afr
         eYSOVb2UafsXTKqkxErVsOWa/ac4Pc/gGS/V3k33zKFqcwxg1dl1v65CmhaclKZxzeL5
         BX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AB/hMRLGEmCvwZUm1C0e39Q+MdWsYPE9hn7PuERXKpw=;
        b=AE0asOFlIW6Oua1mdE8Awu+gbvCyGYZrW9RXp5oEsCM3TkIhN9y0gEt8/1q3rKxut9
         rItO4bcRMf/PpV1+ySO1Le4myaPIkzn2Ev8zAaYIqyK9mEqDcb+nipGRmzd9FXv5B+NW
         9ns7icXCAjRW9alpqVmtWYZFURN9QMayB2Ehoi0W+GZM6/ogeY8MTsaZkK9z7eNLPbPr
         IuVwFX/kuDiTzwOG7PecaYXrnSCbcQIk0v1vWJPCSPNVuqBNFu60Sj7HHUnXanyJmAD1
         i2t03ttJLCYHkPwP+QIMbDWfUb9MdFUuqSR5utaN/iYNd0duLf/1c6C2l7BAEgLqVagN
         Hv8w==
X-Gm-Message-State: AOAM530TawDTuNqqjrMex/QyITeJjCdAD6k2I348beNdm9Mm+AUeT9Bk
        o5AhSIK4d3AZqzncZkbxbg4Ve6Hu
X-Google-Smtp-Source: ABdhPJzJZieq7mP1P2as+NkTf3CqBQ2fSaaLIUWwl8hnA37UptftzUJGppFrPto0jsMS1LgU3PlfMg==
X-Received: by 2002:a5d:634e:: with SMTP id b14mr5593711wrw.423.1595531522360;
        Thu, 23 Jul 2020 12:12:02 -0700 (PDT)
Received: from [192.168.43.57] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id g145sm6945080wmg.23.2020.07.23.12.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 12:12:01 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <eaa5b0f65c739072b3f0c9165ff4f9110ae399c4.1595527863.git.asml.silence@gmail.com>
 <e42e74bd-6220-c933-fce1-4005c3c7b2dd@gmail.com>
 <ecb56297-ec6d-de6f-a619-6d19549d2272@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC][BUG] io_uring: fix work corruption for poll_add
Message-ID: <8ff4be9e-fada-e471-4a3f-3e8ac5f7ae61@gmail.com>
Date:   Thu, 23 Jul 2020 22:10:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ecb56297-ec6d-de6f-a619-6d19549d2272@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/07/2020 21:19, Jens Axboe wrote:
> On 7/23/20 12:15 PM, Pavel Begunkov wrote:
>> On 23/07/2020 21:12, Pavel Begunkov wrote:
>>> poll_add can have req->work initialised, which will be overwritten in
>>> __io_arm_poll_handler() because of the union. Luckily, hash_node is
>>> zeroed in the end, so the damage is limited to lost put for work.creds,
>>> and probably corrupted work.list.
>>>
>>> That's the easiest and really dirty fix, which rearranges members in the
>>> union, arm_poll*() modifies and zeroes only work.files and work.mm,
>>> which are never taken for poll add.
>>> note: io_kiocb is exactly 4 cachelines now.
>>
>> Please, tell me if anybody has a good lean solution, because I'm a bit
>> too tired at the moment to fix it properly.
>> BTW, that's for 5.8, for-5.9 it should be done differently because of
>> io_kiocb compaction. 
> 
> Do you have a test case that leaks the reference?

link-timeout.c::test_timeout_link_chain2()
- add IOSQE_ASYNC after poll_add_prep() (probably, not even needed)
- close() pipes fds at the end.
- while(1) test_timeout_link_chain2()

That's what I did to test it. Confirmed with printk + it killed the
system in 10-30 minutes. I can get something faster sometime later.

-- 
Pavel Begunkov
