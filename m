Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BB65EF5C8
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbiI2Mzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbiI2Mzg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:55:36 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280E3124C1B
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:55:34 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id u10so1944890wrq.2
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=KPnDgfpADVS9BHEZfyDfZCA/2hJ84HPa7KQjWk7Hgjo=;
        b=AAzqz+PIuxQKZkck2pQFeDfrNuTjGURpS1Duud3TOYed2G49awypV/U2YErZ3NBc0y
         CvA46ObLNjvzUJ+sn5EUWOvQeco9CaT/m/r3l+0mqhKjPi3rzeV753M/1cc2Ke53lJBF
         CJ6CC+4aD2GJEwCqL8bCHd5wpX8JLBJsAB3wjlDSJULBUu+VE2+YDEHyBLpPJMc1/Dzc
         mH6INGZGs1GS2ag8KbpeblJ1NvUPNutTKjAM9Ny4sVrUG9hnFfzi5gxmOKXncp1j2drW
         RmSo5CCF9QzbbDvWtVOkd2RvnBGy8cFaZkVl2xF2oCa4mLBOm0lfkN2u8LaIUG934Pue
         /Z0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=KPnDgfpADVS9BHEZfyDfZCA/2hJ84HPa7KQjWk7Hgjo=;
        b=56ASzJEdK5omfgsz3KAtkP+bPPT7hJw3rnew6YeLNWFhfdbQks7nigp47Itqt2dn1V
         egmXrJEnAglmBJB+FxVW2JDAGMSH67M5HZghk+EbO90NqJ82Hqxb2CHYB4IsKsOSrBck
         DPMk6Qcb5U1A7HGX+Ob4Rqml05IrCLSrWCKp5tLXt7KsI14Xa7j5dkEqr4GsLTJUyg7K
         QDATH37b6PJse/1AYBgpzjIzNSzvgobeAHPDOn9knOeDH8ooPfW25VWjM4rnKpWLqX4Y
         P/tXvQETBuLtvCFcj6/p0IGZMy1vkRxAtR3ARXNS+RQmx0mO+s8pTMQ1UiZXNy0mBlsR
         tOVg==
X-Gm-Message-State: ACrzQf1Eu7k3pgLXGmGiFNAmqVfvAvSnT8IMW+AybjfskUHMgCgXjbvK
        Udofqiq7KPvHpNriEFcN8KELQbKQAqo=
X-Google-Smtp-Source: AMsMyM479T3ie/qrNU0WUvO6Z4ro/A+A8MuoE61ECK+sJuukQfnhiVO+Ulah5HQtATya9hDyDMNg/w==
X-Received: by 2002:a05:6000:18a5:b0:22c:943d:221 with SMTP id b5-20020a05600018a500b0022c943d0221mr2198887wri.562.1664456132942;
        Thu, 29 Sep 2022 05:55:32 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id 3-20020a05600c230300b003b4727d199asm4270573wmo.15.2022.09.29.05.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 05:55:32 -0700 (PDT)
Message-ID: <2c657801-252f-47b0-44b5-c59a32acd757@gmail.com>
Date:   Thu, 29 Sep 2022 13:54:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH liburing 0/4] add more net tests
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1664409593.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1664409593.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/29/22 01:03, Pavel Begunkov wrote:
> NOT FOR THIS LIBURING RELEASE

I'll resend it with a few improvements later

> 
> We need more testing for send/recv. This series extends zerocopy tests
> to non-zerocopy opcodes to cover 1) non-zc send() with address and
> 2) retrying sendmsg[zc]() with large iovecs to make sure we fixing
> up fast_iov right on short send.
> 
> Pavel Begunkov (4):
>    tests: improve zc cflags handling
>    tests/zc: pass params in a struct
>    tests: add non-zc tests in send-zerocopy.c
>    tests: add tests for retries with long iovec
> 
>   test/send-zerocopy.c | 182 ++++++++++++++++++++++++++++++-------------
>   1 file changed, 127 insertions(+), 55 deletions(-)
> 

-- 
Pavel Begunkov
