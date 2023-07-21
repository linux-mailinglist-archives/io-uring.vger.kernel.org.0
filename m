Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B9D75CF6D
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjGUQda (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjGUQcp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:32:45 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FBE3A9D
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:31:18 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7835bbeb6a0so28384639f.0
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689957033; x=1690561833;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wjm57PE4E1b1TImtMyTDq1NuS3TL+nTyXdmvraQvYxM=;
        b=ZY3+MmmmVH3v4ikKA/9bQVpkWL69gk43pAZjG4lnx2VYCjQoMOM3D3NY4OEe0ob9Cp
         tIzYA3+IvbmPEgD+iJBHapX1F6EQJ6+QhIOdriB/YDtoYRPWrEkRy7z64pjuTQAaDi/M
         DYuT1091VWfv+/ZGSc004AUdbeLuvNfzXEcoqUDJDcQeXfMDjV8PRsvu+h2QJLDb/70a
         auR02svZEA2NB6OR4v2+Og5zpBOGkpX7nhcWtRTLBwUGovtCi9OMPZ0laItlZknl+vs/
         rSeY3wmuEaoesg1EwIN+DuZAnEYT66UwRNzITxl52sjZ9+4xL9XATDLhD5yYKdYPgKtH
         0pWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689957033; x=1690561833;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wjm57PE4E1b1TImtMyTDq1NuS3TL+nTyXdmvraQvYxM=;
        b=cxf5Y6FMylmvHIe+JyxRHxFr7eQ1olPgPhb4DTP12W2QT+P9BKOJfjmDGFbMmk3PEe
         zUmu8S/p+vO6XXB2sl3CY7JT1Oa2KnwbBJdRUOsntFaE9DZEHYDu2UCpgw4pNWiiXx3L
         PeJzlcwKAWML+6aRJKLXOw0pIUt1wUj3p5J/q0aUp2EFejyq0ciYgdnPVVRgmPsY89/v
         AtBszjWGJDLpkDB8IhCxVF/FUv34EYjMJyySvXV3UP7Jbxx4TxqqiDn8CKax+uUXx720
         Tx+hL3qWp4wUr6t2tnb7U8L1VGwxk2cnNfaQ58jc+QnLCA+bopGEeT4huioRl9agmRgY
         rqoA==
X-Gm-Message-State: ABy/qLblMZg1gOqT4ZjZkhF1rGS9vOn9FykTR4MMkODX40qJPcuChJWX
        po7Xj7NHZuLFKI1wyb1FBl0zyw==
X-Google-Smtp-Source: APBJJlGANMcKaxVubU+4fTPhtqP/WrBo7DxexMX0V7R6jkHIjRdAbFvjgmGNicYirJezRqPGpDXL1Q==
X-Received: by 2002:a05:6602:480b:b0:780:d6ef:160 with SMTP id ed11-20020a056602480b00b00780d6ef0160mr2577782iob.1.1689957032936;
        Fri, 21 Jul 2023 09:30:32 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q12-20020a02c8cc000000b0041a9022c3dasm1082894jao.118.2023.07.21.09.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 09:30:32 -0700 (PDT)
Message-ID: <610c05b4-4fd2-a307-5633-b8d7761edf6f@kernel.dk>
Date:   Fri, 21 Jul 2023 10:30:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 8/8] iomap: support IOCB_DIO_DEFER
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-9-axboe@kernel.dk>
 <20230721160105.GR11352@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721160105.GR11352@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/23 10:01?AM, Darrick J. Wong wrote:
>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>> index cce9af019705..de86680968a4 100644
>> --- a/fs/iomap/direct-io.c
>> +++ b/fs/iomap/direct-io.c
>> @@ -20,6 +20,7 @@
>>   * Private flags for iomap_dio, must not overlap with the public ones in
>>   * iomap.h:
>>   */
>> +#define IOMAP_DIO_DEFER_COMP	(1 << 26)
> 
> IOMAP_DIO_CALLER_COMP, to go with IOCB_CALLER_COMP?

Yep, already made that change in conjunction with the other rename.

>>  #define IOMAP_DIO_INLINE_COMP	(1 << 27)
>> +	/*
>> +	 * If this dio is flagged with IOMAP_DIO_DEFER_COMP, then schedule
>> +	 * our completion that way to avoid an async punt to a workqueue.
>> +	 */
>> +	if (dio->flags & IOMAP_DIO_DEFER_COMP) {
>> +		/* only polled IO cares about private cleared */
>> +		iocb->private = dio;
>> +		iocb->dio_complete = iomap_dio_deferred_complete;
>> +
>> +		/*
>> +		 * Invoke ->ki_complete() directly. We've assigned out
> 
> "We've assigned our..."

Fixed.

>> @@ -288,12 +319,17 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>>  		 * after IO completion such as unwritten extent conversion) and
>>  		 * the underlying device either supports FUA or doesn't have
>>  		 * a volatile write cache. This allows us to avoid cache flushes
>> -		 * on IO completion.
>> +		 * on IO completion. If we can't use stable writes and need to
> 
> "If we can't use writethrough and need to sync..."

Fixed.

>> @@ -319,6 +355,13 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>>  		pad = pos & (fs_block_size - 1);
>>  		if (pad)
>>  			iomap_dio_zero(iter, dio, pos - pad, pad);
>> +
>> +		/*
>> +		 * If need_zeroout is set, then this is a new or unwritten
>> +		 * extent. These need extra handling at completion time, so
> 
> "...then this is a new or unwritten extent, or dirty file metadata have
> not been persisted to disk."

Fixed.

-- 
Jens Axboe

