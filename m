Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A8F75CF6C
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjGUQd3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbjGUQdC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:33:02 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F063149CD
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:31:33 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-785d3a53ed6so26056539f.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689957043; x=1690561843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/3PPnWxSXLUKJr/pWYeXGOhnZ5zJ6/eb/WfDH+K4vMA=;
        b=KA9UdNZniqXAYYo0aSjtwCzBJVOxrUNdnx3PHCHHuAli55rLsUAH0EHw0y+vIV9ub6
         44ifXmGm9VKQ2qm8t6MWZlRZAldTMmn2RgTBQVU5dUrlsKAmlQeHpO2WNbbMnx0b23mG
         Nrp9TjcKXXGspe/WlaQgO8FZcBblRnMYk6XU2z/qmq4JYcPNo9h597fo7hvS0MldZJh7
         s5U+cwKZnbTq3wZ6MyVGS9E3V6XtmsUKHBDr89YGQrvYMwR3gfOA1ZI/1XYvuf+BY//V
         0CXP217VUOHwH2yO544aE42L4rdlNS6tejYs9AWxhQQWTezJMpGtIQSrqJrTEBYTBWvJ
         PAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689957043; x=1690561843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/3PPnWxSXLUKJr/pWYeXGOhnZ5zJ6/eb/WfDH+K4vMA=;
        b=C1XtovtmNijH7f3cui3LnjZBHaLeKuKClPmmtHHR7XvyeOuGuC0Tw616M5SWwYJuxt
         aj20Av+4SArz4D3VVD17a50dlvyEGPj9CUzjbgJucSbUwYiLXZVwXrzatPBQgaxoiBcg
         N0ntGuZEJiHigrclbPSp+50pLflB86ybDU+0qufEDm1bMUUCvfcz0XDT4W6vuAdIZlWd
         RlpQEFteee5cEmvFYo7I6hJ0Fgbu5pOAR3YvIXZGGaTmklE7vEwvg8GA+FrpNy47kgMU
         FibxpvvJEsVgqILQjfJvlf3DB6fBDL52WsEVnW/QkGtwIR+rr5a21NIPYikkm5LsfYWQ
         B8ag==
X-Gm-Message-State: ABy/qLZkQdf/cs7h80MNPk51aCjIP+htr1+DFcEBJT30CXF9Wp0ADobr
        YdS/MexayTQPx+u0Tb5VsregNA==
X-Google-Smtp-Source: APBJJlE0NI6v2MOBejaP9xJp07OdgLOLKrRdl0OF0hI785dWwoxwrKnivhuZgV4zfd+DSBKV/pd73Q==
X-Received: by 2002:a6b:6903:0:b0:780:d65c:d78f with SMTP id e3-20020a6b6903000000b00780d65cd78fmr2037096ioc.2.1689957042891;
        Fri, 21 Jul 2023 09:30:42 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f19-20020a5d8793000000b00786f50d6bf5sm1148948ion.19.2023.07.21.09.30.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 09:30:42 -0700 (PDT)
Message-ID: <3829033a-40fb-5de1-853b-a9b367681d51@kernel.dk>
Date:   Fri, 21 Jul 2023 10:30:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6/9] fs: add IOCB flags related to passing back dio
 completions
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
References: <20230721161650.319414-1-axboe@kernel.dk>
 <20230721161650.319414-7-axboe@kernel.dk>
 <20230721162807.GT11352@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721162807.GT11352@frogsfrogsfrogs>
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

On 7/21/23 10:28?AM, Darrick J. Wong wrote:
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 6867512907d6..60e2b4ecfc4d 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -338,6 +338,20 @@ enum rw_hint {
>>  #define IOCB_NOIO		(1 << 20)
>>  /* can use bio alloc cache */
>>  #define IOCB_ALLOC_CACHE	(1 << 21)
>> +/*
>> + * IOCB_DIO_CALLER_COMP can be set by the iocb owner, to indicate that the
>> + * iocb completion can be passed back to the owner for execution from a safe
>> + * context rather than needing to be punted through a workqueue.If this If this
> 
> "...through a workqueue.  If this flag is set..."
> 
> Need a space after the period, and delete one of the "If this".
> 
> With that fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks - same ask on the edit. Or let me know if:

a) you're fine with staging this in a separate branch for 6.6, or
b) you want a v5a/v6 edition posted

Either way is no trouble for me, just wary of spamming...

-- 
Jens Axboe

