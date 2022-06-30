Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E11561E9F
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 17:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbiF3PA2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 11:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235391AbiF3PAA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 11:00:00 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5B91FCF6
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:59:57 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id p9so12271205ilj.7
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=0DSGdZ31Jt4EInbb6U1O9SFgpK9tmFLGASZ9HWsUPr4=;
        b=kcsdea9Rx5peTAeDc2LUdO8uCV9joqV853bvFiL3TApwkegFgVW9+SisxPgvIGMebk
         OXZUhtof/47tAhxj7+qmn2FqADJqhJveQk4a695gQ5Xuo3myKaKwQfNmalYzYmeimw0w
         2iUyPA0/ll1szp3I7kUWp3l3ATGug/wh4o1weMfJOoQixnHAcBNPRa8yQcN8hRR+gGJt
         GDZ9uuLt2ZDAHKJWG5J4HIAK6d0JYjtnMQ22AOSVuUvYWuEt1nA2Hv6hDvzKoG87L/+Y
         A9up5E8XNXil2OPYxmnTlbZSEaZEmOatMMxPOoJ6RrujBzcCvJKsmHJaFXJjSxVa/iyG
         JGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0DSGdZ31Jt4EInbb6U1O9SFgpK9tmFLGASZ9HWsUPr4=;
        b=qPBq00h2voNa3RtVKfuHz7CdujHUA+s4YLGBQSSDMFRSeIiuyTBFRTupWP1Vq4p90G
         eiUNHPA2wJwm3aA+9pdwRtF1GlBoASfwmQ+Wv9vM0SBDGqNTQhM09taqIS4gwU8YSEVO
         EVVjK87x57eHwMLL9bXaXd7GS3CwqPfYL0EZYaIZIXOENw8Ma0Rs8+eYis9a9pYIfele
         pvqMobpoIZSiKCi7Zyxyw0ngmqfrRW4TX12QCoLWRT1+NU6LEJokRp4gMzVdMnMElq08
         9+bMsuK78yahd+AftkRO629wgGPXR4us1zxuq6Po9OpitNV4tIMl8Ukz9GUhEluxjgmE
         Y7wQ==
X-Gm-Message-State: AJIora8ZYuOxs43TwIJVIZ2YSsvnpdt9AClQGvL+NSLfwn/IDIgc+3Pq
        TJrqquuEZAn2zhR72FtpThiUqh7s6IBIBA==
X-Google-Smtp-Source: AGRyM1uQ9Za5oSR4mL94TIkto4Qs43cJP+JoTmBLseHEo91xcPUrLi/Ux/f6SLMfWNhqDSM8EzUONA==
X-Received: by 2002:a92:c909:0:b0:2d9:1e8f:276c with SMTP id t9-20020a92c909000000b002d91e8f276cmr5249772ilp.305.1656601196467;
        Thu, 30 Jun 2022 07:59:56 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t5-20020a025405000000b00339e0bba215sm8646220jaa.96.2022.06.30.07.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 07:59:55 -0700 (PDT)
Message-ID: <1310f52a-f476-defd-55e3-12c303be2d2f@kernel.dk>
Date:   Thu, 30 Jun 2022 08:59:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing v2 0/5] ranged file slot alloc
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1656597976.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1656597976.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/22 8:10 AM, Pavel Begunkov wrote:
> Add helpers and test ranged file slot allocation feature
> 
> Pavel Begunkov (5):
>   update io_uring.h with file slot alloc ranges
>   alloc range helpers
>   file-register: fix return codes
>   tests: print file-register errors to stderr
>   test range file alloc
> 
>  src/include/liburing.h          |   3 +
>  src/include/liburing/io_uring.h |  10 ++
>  src/liburing.map                |   1 +
>  src/register.c                  |  14 ++
>  test/file-register.c            | 235 +++++++++++++++++++++++++++-----
>  5 files changed, 231 insertions(+), 32 deletions(-)

Looks fine to me, but also needs a man page addition... Trying to do
better here going forward so I don't have to spend days before a
release checking what hasn't been documented, and then also write
everything myself.

I can apply this one as-is, but please do send a man page patch as
well.

-- 
Jens Axboe

