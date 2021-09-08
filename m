Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB41403A57
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 15:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhIHNJk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 09:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhIHNJk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 09:09:40 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20761C061575;
        Wed,  8 Sep 2021 06:08:32 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id g16so3240900wrb.3;
        Wed, 08 Sep 2021 06:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3uYnuOkkfJU/vk1srrupoxrNfOGEY71iLIHcsDVDOOU=;
        b=KWZh3Jf8taY5em2Vt6nTI/zEj9a6U/n38hQc+QnnNWbmMdrprQ+OnHmw4hW4bGMLOd
         ptCugFIu+mFhIxMpyWEeluXFjL5pyrh/SUaPwvglsZwTLD6C5t/R8hId1RiGsZ0eO2s9
         7Zf6uZGCYodq2cAWAWnE8wwomTkFX1sZYDwBCjq8AonClRm39ca5qSPqhW3WSv+LidFn
         XeSjl/XP0+zyOKuS3Tc+xY5YfU3OGqsftFZgw+NX9Yv/Oc9jGhfuohW71IxiAthywtO2
         ekVD69b6iSWY2YBDRpYcaF8+M4hgG7i1PfllqlgYdTiAvBZeq2vG1eqscC/vtHGnHDPB
         NAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3uYnuOkkfJU/vk1srrupoxrNfOGEY71iLIHcsDVDOOU=;
        b=rDE3VAkf8PKimyekBCAwgNRSpwo1RANTj9FDsGVotZ8Koh1vSSyvTeEAgj7Ma6CbYH
         YTCSRjTY2hlS/C/iu/GBk1t5o8cYrV3jUwKLuPcgikBG/ZoQ93G4q4qOD/pNL21o8IJ/
         236pSeG/llyer8ocGdOvaDnFigOewrUXBcpQTd4o6RG3SegW9IFEARHVJOxpmUWpR6+3
         H38lhoaGMntTMg0+wT/Zjlm3idFKBjUD3VYwjtmlkGDVc39fXeLL8/kRucPvLaQCH3R3
         RspGtegrjCUYymb3kqOt6h198tmJ5S2uYWaFwKRMOKeLDRQ6/3XkZ7mUlrJ7gIgetIsW
         a1WA==
X-Gm-Message-State: AOAM530smhysjRIYJCrfJgRbZAUnahF3WedRnE15ap3h9y6uE9XLr4hB
        V60CykP9st+JDiDOf4iyPzAiC2pLPOo=
X-Google-Smtp-Source: ABdhPJz01hfQCjqMW4sPZxOh4/lc/yfpA0UeXNhBjw/F/0xv7MxzFxUfSCfpkJGt/pyK9raBBRyH2w==
X-Received: by 2002:adf:f101:: with SMTP id r1mr3875490wro.355.1631106510486;
        Wed, 08 Sep 2021 06:08:30 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id h15sm2104778wrc.19.2021.09.08.06.08.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 06:08:30 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     io-uring@vger.kernel.org
References: <16c78d25f507b571df7eb852a571141a0fdc73fd.1631095567.git.asml.silence@gmail.com>
 <ed21a6b0-be32-e00a-98c3-f25759a44071@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] /dev/mem: nowait zero/null ops
Message-ID: <654d5c75-72fa-bfab-dc14-fa923a2a815a@gmail.com>
Date:   Wed, 8 Sep 2021 14:07:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ed21a6b0-be32-e00a-98c3-f25759a44071@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 1:57 PM, Jens Axboe wrote:
> On 9/8/21 4:06 AM, Pavel Begunkov wrote:
>> Make read_iter_zero() to honor IOCB_NOWAIT, so /dev/zero can be
>> advertised as FMODE_NOWAIT. This helps subsystems like io_uring to use
>> it more effectively. Set FMODE_NOWAIT for /dev/null as well, it never
>> waits and therefore trivially meets the criteria.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  drivers/char/mem.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
>> index 1c596b5cdb27..531f144d7132 100644
>> --- a/drivers/char/mem.c
>> +++ b/drivers/char/mem.c
>> @@ -495,6 +495,8 @@ static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
>>  		written += n;
>>  		if (signal_pending(current))
>>  			return written ? written : -ERESTARTSYS;
>> +		if (iocb->ki_flags & IOCB_NOWAIT)
>> +			return written ? written : -EAGAIN;
>>  		cond_resched();
>>  	}
> 
> I don't think this part is needed.

It can be clearing gigabytes in one go. Won't it be too much of a
delay when nowait is expected?
 
>>  	return written;
>> @@ -696,11 +698,11 @@ static const struct memdev {
>>  #ifdef CONFIG_DEVMEM
>>  	 [DEVMEM_MINOR] = { "mem", 0, &mem_fops, FMODE_UNSIGNED_OFFSET },
>>  #endif
>> -	 [3] = { "null", 0666, &null_fops, 0 },
>> +	 [3] = { "null", 0666, &null_fops, FMODE_NOWAIT },
>>  #ifdef CONFIG_DEVPORT
>>  	 [4] = { "port", 0, &port_fops, 0 },
>>  #endif
>> -	 [5] = { "zero", 0666, &zero_fops, 0 },
>> +	 [5] = { "zero", 0666, &zero_fops, FMODE_NOWAIT },
>>  	 [7] = { "full", 0666, &full_fops, 0 },
>>  	 [8] = { "random", 0666, &random_fops, 0 },
>>  	 [9] = { "urandom", 0666, &urandom_fops, 0 },
>>
> 
> This looks fine.
> 

-- 
Pavel Begunkov
