Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F8875CF48
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjGUQag (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbjGUQaQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:30:16 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D644C3D
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:28:17 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-78706966220so21095139f.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956838; x=1690561638;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ahIwLnlD7cr1aBwhJXa2haUworAGpZ2mINQou78VDu0=;
        b=kBchZozexoXJ18KlGDkAVrvIjopBR6UbqhqhmZBCWTlfv+s9mxQSa6rsA1ygC+JnqP
         gFllWoUzcqOZOkrVu4APmgIXh29nyu2VfvHnXYEpy1qH9SfMZVF+rlEkBQQ81MBV9yug
         Tw7B7uBn1+7rK/kyMGpJq11vEQPoC/QxbiK47MoLWrzt1MhP2tEV1bsosv7minWeuZ/h
         xLqMVp+VXPQSX5Tws9SSN0x4ZlJSNRjFk8eedx001nQKDh5e+V3CFO8NdWzum77xcYvk
         mWBQbMAvT3izkyGhmF6Yn62dSpQuCrmGQfOm1dPkY8Pr8JnpTkD1RFNQFLwmWW1b+avm
         jyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956838; x=1690561638;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ahIwLnlD7cr1aBwhJXa2haUworAGpZ2mINQou78VDu0=;
        b=E7ZBUmFJNj3Q/suiMvQj9sG/ALFMzTs3t2/guAXjdBNNTL1BNd7fbCYFpfm+dsWj9B
         I+O1dq7bkyp/XKKbVs/Gy9Zyi4GAyt3qIOrj4gd1+witwwrFgb5XapiCeQ/+RUUJjcy3
         XsOcfkqa1AFP2AMS7vz9H3YDAEh5HCJg4Lk4n+0Xf9pcE2TY5Z4t58K9gh9QWbbHxOMa
         C5acGyP5tSs53AUDaNgeE823P0Cj14DezLdwklc7EOPsQmV5qCKpCIgtt/Ed3CosN9qL
         SGkk94plcBMqXiOu8hiLA+yo7LudXyloI8lbjwtpo1Q31FTvcLaryr/wIJUONK1oO5dU
         5REg==
X-Gm-Message-State: ABy/qLaikNPca3o/GZ+NADj3VslD+Am40JBhykdqB7sfhcJ66hll8IAT
        4AiDKztfW7s8ho5LI7MnYBrtl3x21C8Gdjzf+xE=
X-Google-Smtp-Source: APBJJlHyDmJ6heC6rQgvSlxNOq/BYAOkCm+9EuNUvAih72hZqnStNzY3DW2e7C3MZSglmBhNYdWLXg==
X-Received: by 2002:a05:6602:4809:b0:77a:ee79:652 with SMTP id ed9-20020a056602480900b0077aee790652mr2393302iob.1.1689956838086;
        Fri, 21 Jul 2023 09:27:18 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a20-20020a029f94000000b0042b34d4d07fsm1098840jam.156.2023.07.21.09.27.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 09:27:17 -0700 (PDT)
Message-ID: <4fcc44be-f2da-9a7c-03ca-f7e38ac147cb@kernel.dk>
Date:   Fri, 21 Jul 2023 10:27:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/9] iomap: treat a write through cache the same as FUA
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
References: <20230721161650.319414-1-axboe@kernel.dk>
 <20230721161650.319414-4-axboe@kernel.dk>
 <20230721162553.GS11352@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721162553.GS11352@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/23 10:25?AM, Darrick J. Wong wrote:
>> @@ -560,12 +562,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>>  
>>  		       /*
>>  			* For datasync only writes, we optimistically try
>> -			* using FUA for this IO.  Any non-FUA write that
>> -			* occurs will clear this flag, hence we know before
>> -			* completion whether a cache flush is necessary.
>> +			* using WRITE_THROUGH for this IO. Stable writes are
> 
> "...using WRITE_THROUGH for this IO.  This flag requires either FUA
> writes through the device's write cache, or a normal write..."
> 
>> @@ -627,10 +632,10 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>>  		iomap_dio_set_error(dio, ret);
>>  
>>  	/*
>> -	 * If all the writes we issued were FUA, we don't need to flush the
>> +	 * If all the writes we issued were stable, we don't need to flush the
> 
> "If all the writes we issued were already written through to the media,
> we don't need to flush..."
> 
> With those fixes,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

If you're queueing up this series, could you just make those two edits
while applying? I don't want to spam resend with just a comment change,
at least if I can avoid it...

-- 
Jens Axboe

