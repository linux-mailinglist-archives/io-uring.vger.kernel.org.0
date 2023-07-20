Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC8D75B400
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 18:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjGTQUC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 12:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjGTQUB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 12:20:01 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB8F123
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 09:20:00 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-760dff4b701so11455639f.0
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 09:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689870000; x=1690474800;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zbktv+AcrhSt5ZA/e5vt5rGLNk7lodMzYoNkWfI3dk4=;
        b=uP/C40uvhVHqxeXmV5oo48jHf6f32k2S7tgxHE75lXjVhOA9SDWgE1i7StyLOEhuFI
         w3gl6nnahny3Ir6Myw9duM0RXIAsPONKRjeyob2eSKtSWlJiHpIjTuAQZKesmxmPyktI
         aTSdgg11auPe3XlVddMa3Imr+0uH1x3LiMDu42kaKo6Ld4ToKZFDiCYkL9X1VN/5ebEr
         dvc5SmuN8xqpBRgJ0GW5KTP9eiQcRorKw+QMH/DfrM5GEDdMWzWRItjsWI0kGL5yJUg0
         QR+JR9MLbfs389w2z9LocQ/PhPC4Y/ITVtkFa9zMnQbPXvpgSX+qS2PFa/fJAvAqSSE3
         pAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689870000; x=1690474800;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zbktv+AcrhSt5ZA/e5vt5rGLNk7lodMzYoNkWfI3dk4=;
        b=KLl18152yEaGHTZdaO4B/URzHpQy+HpU6t2/LU8aXblQ9uPbKNQAE78iytO39XlpRP
         MWLzrDjnx7t8ODGOYQ418E7aY5rhsVRs++5a8pc7oiCJODDhItibf0W/ErSQrLbDIjv7
         mYznqBzguV0Mk2y/lwTlBBW3Kr+bM6HVp87pLpGakxF+54awAwz6v+AiJCszwWYtPTda
         UPsSDIZbaajwZ9onJ3cyg9GqiByZDmqbFCFHyNSxLF/eb6CAZzSGDGzZPwKxBlphHw1e
         /kjMSyE2Vkximn74LNPj/Rl3FvOSUGJ1OjgkcJ3t0+RWq4KtNA7xSvwEYStB+lweuATO
         3+hA==
X-Gm-Message-State: ABy/qLb8obn1IihZ4KhNXoDedaBl5uGvkeZuouDCR0NQhkLfZJlaBHv/
        18KpKtcd+psoYPRKHEJ9hCsgBA==
X-Google-Smtp-Source: APBJJlGGWjVasqge1R1KE0IAxSMPypqeG/qvzVytHUL1dNFJLlptu65S/tZDRYxQMK9TDxC/smL+2A==
X-Received: by 2002:a05:6602:491:b0:783:63e8:3bfc with SMTP id y17-20020a056602049100b0078363e83bfcmr4408077iov.0.1689870000294;
        Thu, 20 Jul 2023 09:20:00 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b10-20020a5ea70a000000b0078337cd3b3csm409512iod.54.2023.07.20.09.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 09:19:59 -0700 (PDT)
Message-ID: <a0f84540-d091-3072-48de-31aca00c00b2@kernel.dk>
Date:   Thu, 20 Jul 2023 10:19:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 2/6] iomap: add IOMAP_DIO_INLINE_COMP
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org,
        andres@anarazel.de, david@fromorbit.com
References: <20230719195417.1704513-1-axboe@kernel.dk>
 <20230719195417.1704513-3-axboe@kernel.dk> <20230720045150.GB1811@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230720045150.GB1811@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/19/23 10:51?PM, Christoph Hellwig wrote:
>> -	if (dio->flags & IOMAP_DIO_WRITE) {
>> -		struct inode *inode = file_inode(iocb->ki_filp);
>> -
>> -		WRITE_ONCE(iocb->private, NULL);
>> -		INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
>> -		queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
>> -	} else {
>> +	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
>>  		WRITE_ONCE(iocb->private, NULL);
>>  		iomap_dio_complete_work(&dio->aio.work);
>> +		goto release_bio;
>>  	}
> 
> I would have properly just structured the code to match this in the
> lat path with a
> 
> 	if (!(dio->flags & IOMAP_DIO_WRITE)) {
> 
> so that this becomes trivial.  But that's just nitpicking and the
> result looks good to me.

Ends up being done that way anyway with the rework of patch 1 to put the
non-write side first, so that's what it looks like now in v3.

-- 
Jens Axboe

