Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3610054C632
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347675AbiFOKb2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348165AbiFOKbA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:31:00 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486C050B1B
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:30:31 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n185so6049856wmn.4
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Y2DPerrLzVoq6v5fyqafYomQBfpzqEyD7Vn4JC+BNI8=;
        b=ZTYroKuCmPYJVLkaNmaMH0AWXsSYwMEsLECMyoEFuzxac+sJaSCrpRAR53PrqpA2OS
         t+d8U0QWPlQrJVuSoJkihbhdQl/amL+8Ogw287S9Ji8Otck3FYFbOag8PyrFQZC3zBKl
         nROxA7+GY4Icun/yZ62OWqofXubCRFdlVkA0IurxC+GNNjOlz+2KRZHw8gUSdouCVZIH
         hwnfGZR5DfmQZdU3CcPC7bbuwFrVd846QN3xXrQGEy+uSo9uuHKKDCi9fwDXzM2kS01P
         vlDetZEFHqJM1k8eL67C2zSzMtS3j6YRLwUUCunHF2QtCjCiv74/igrPiM297zFq/4GD
         boag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Y2DPerrLzVoq6v5fyqafYomQBfpzqEyD7Vn4JC+BNI8=;
        b=ThWav/u87Hj0C7zYWQ5N/VDvHQSi1XekB3E8y+Fz9OrBknwKxiixFdUo+AST8uY3+f
         vo6BmRPpHN2c1tt/qS2i1nyqoN1ry3tweaouC8+QyzlOfztxP77KZlH2X1hbqXbNLRMs
         3REvAgeeP61vNChaAR/XK/ewwLf3n8mQW6wEUOipR/6cpVEiLkXkJq5o35nsrchS+F0F
         APwMxGczrZuJwxe+BNjUqKB7moPxD8uoyXfjGEq5UP2TSuPtw4EIjXw+jHOAJVgWxDT2
         pJG3f/YocB6dLvp0DFadAZDTRSccjnQQ4KXGBxMe5ax211MdYp6z5m5TJO5e7+TkjOKJ
         uXZg==
X-Gm-Message-State: AOAM531WtKaUrtmTXpqUKUwANzTg94772dkA1Sc0WpRi9KB8w994BQhQ
        ImrSf+RQCKgNhH5xkhUTEjDifOIozUcQRw==
X-Google-Smtp-Source: ABdhPJz1K6aywluKZbSwXisxCcvFv2UAJe0zwP1NNFNXNnp30VrJKnTDoArDuGiFlqRy4mF1/xwakg==
X-Received: by 2002:a7b:c113:0:b0:39d:86c0:3ebe with SMTP id w19-20020a7bc113000000b0039d86c03ebemr8768635wmi.38.1655289029307;
        Wed, 15 Jun 2022 03:30:29 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id g13-20020adffc8d000000b002102f2fac37sm16593434wrr.51.2022.06.15.03.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 03:30:28 -0700 (PDT)
Message-ID: <a6110e7d-7a42-8070-2dab-7fafc965dbd2@gmail.com>
Date:   Wed, 15 Jun 2022 11:30:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing 1/3] io_uring: update headers with
 IORING_SETUP_SINGLE_ISSUER
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213733.git.asml.silence@gmail.com>
 <b5e78497efd3a50bcc75f5d9aab1992375952c93.1655213733.git.asml.silence@gmail.com>
 <6bf7ce15-f317-3d39-30f1-eb189b7ed1f4@gmail.com>
In-Reply-To: <6bf7ce15-f317-3d39-30f1-eb189b7ed1f4@gmail.com>
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

On 6/15/22 11:28, Pavel Begunkov wrote:
> On 6/15/22 11:05, Pavel Begunkov wrote:
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Something did go wrong here... just ignore it,
> the v2 sent yesterday is up to date.

That goes to the whole series
(missing the cover-letter in the mailbox)

> 
>> ---
>>   src/include/liburing/io_uring.h | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
>> index 15d9fbd..ee6ccc9 100644
>> --- a/src/include/liburing/io_uring.h
>> +++ b/src/include/liburing/io_uring.h
>> @@ -137,9 +137,12 @@ enum {
>>    * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
>>    */
>>   #define IORING_SETUP_TASKRUN_FLAG    (1U << 9)
>> -
>>   #define IORING_SETUP_SQE128        (1U << 10) /* SQEs are 128 byte */
>>   #define IORING_SETUP_CQE32        (1U << 11) /* CQEs are 32 byte */
>> +/*
>> + * Only one task is allowed to submit requests
>> + */
>> +#define IORING_SETUP_SINGLE_ISSUER    (1U << 12)
>>   enum io_uring_op {
>>       IORING_OP_NOP,
> 

-- 
Pavel Begunkov
