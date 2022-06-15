Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C3354C586
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbiFOKLc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243446AbiFOKLb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:11:31 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932464A933
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:11:30 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q15so14644658wrc.11
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=p/A9Yi+4rT76UN5t/um7VTqIzwhco7+Wh91X2bc4ouU=;
        b=N73gii88ObA8/HVpJ7/OYayCPsEI24P3aPfPVgw3uSPozp8IxZVUr6vmPaF3zf6LmM
         Ik3TQSxm9iLoonQJ5pNDE4gF5vOS0Ds1qY9nlgrQ/vedpV5b8sWD4zi30U7A10mqIhx2
         5oOoQYATh4gMrObc7xMHdmX4QwYgzDPQhhey3038byZ3UWAnRA8X0kMEZAURYRrM5IFR
         x361JeL/uBIFwyvu726sUq65IsLtkJ9mJloTUdm7GLEAtqeni8gJiTxJVbVaNhbr/O5J
         h94B9uMR3o8BNQMV3n14EYdoNnxrO9wSRfPo0IDp5wsPNzA3lS6yR5sa/5iRPzcwf9Pj
         aGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p/A9Yi+4rT76UN5t/um7VTqIzwhco7+Wh91X2bc4ouU=;
        b=NVbhT89w7/YScMjBnI8NIdjOEejB0f1SCYUKgVaWQ3r121eKnsKn9na+VKppLS94TH
         2GuHO1GNts0KEXgXnscTj91otjJugYid9WrJabg5K1vDFUdBigM+d92O1YT5ZV/LBNlQ
         VYSDgR9wG2Erv+dYOqdGmMmdixYQMNORdvu7w/SldkIyxcQkj2tSj4YckoetbORd1l/D
         2KeL32v16Hi5nRIiLyjQW/j7c5Qt+rSaAYNd4N8Xv365epkdX5dXzzxCVDFFIi3lQbBw
         3F7H4UovXF77bZot5aG4va+RKxdQtBk1e9g2yUuBzZrsRrs9Fl7BuOVsJ9cEuNxk1zk5
         nO5Q==
X-Gm-Message-State: AJIora+qjfYnAMxeGN/yJ7e846pKhTcjt4tE/aKGFXmIfJsJemmfnmAT
        beQ4V0320boWEv6xVib2Egs=
X-Google-Smtp-Source: AGRyM1sd/sBquxSGgUJkuFCeLZPHLbDuT9ixOcpi6YNQoaL+4CpdBHjBySsPkLvH1sxZm6OXGWrZMA==
X-Received: by 2002:adf:f60d:0:b0:210:2cce:1922 with SMTP id t13-20020adff60d000000b002102cce1922mr8949303wrp.616.1655287883429;
        Wed, 15 Jun 2022 03:11:23 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m10-20020a5d56ca000000b0020c5253d8f7sm14373366wrw.67.2022.06.15.03.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 03:11:22 -0700 (PDT)
Message-ID: <5d77c39b-53b3-54e8-4443-1049d6d58cca@gmail.com>
Date:   Wed, 15 Jun 2022 11:11:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next v2 04/25] io_uring: refactor ctx slow data
 placement
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <c600cc3615eeea7c876a7c0edd058b880519e175.1655213915.git.asml.silence@gmail.com>
 <353c4c53-18c3-976c-b964-0bc47c9b2d86@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <353c4c53-18c3-976c-b964-0bc47c9b2d86@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 08:58, Hao Xu wrote:
> On 6/14/22 22:36, Pavel Begunkov wrote:
>> Shove all slow path data at the end of ctx and get rid of extra
>> indention.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/io_uring_types.h | 81 +++++++++++++++++++--------------------
>>   1 file changed, 39 insertions(+), 42 deletions(-)
>>
>> diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
>> index 4f52dcbbda56..ca8e25992ece 100644
>> --- a/io_uring/io_uring_types.h
>> +++ b/io_uring/io_uring_types.h
>> @@ -183,7 +183,6 @@ struct io_ring_ctx {
>>           struct list_head    apoll_cache;
>>           struct xarray        personalities;
>>           u32            pers_next;
>> -        unsigned        sq_thread_idle;
> 
> SQPOLL is seen as a slow path?

SQPOLL is not a slow path, but struct io_ring_ctx::sq_thread_idle
definitely is. Perhaps, you mixed it up with
struct io_sq_data::sq_thread_idle

-- 
Pavel Begunkov
