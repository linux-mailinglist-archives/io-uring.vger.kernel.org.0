Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865F251E111
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 23:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444456AbiEFVdO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 17:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444438AbiEFVdN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 17:33:13 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001066F4A7
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 14:29:28 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 204so4469188pfx.3
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 14:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=N1UhE90kw7eZKOYH701CqkEpipu4X6Khp12ykHwyDEg=;
        b=k00gdPq2HnCTH01gmR2exswNoAGEKizY6tgRHeIKF5Mr2EilFTePHuYedBdp8dLD0E
         a20dNsh8kTTsFTUaCmPp2J3yVng+Atu6hsY33ljETSxP1aWm/LSpPgOyUdYYzI55cXt7
         xI0jf9fSDR6Q9QtvZmr8g+W6w8bQIiDsxFX7XrCoXwiDJnP++/H7tulJnvHVXrRLveFU
         dgt6RYQldSybimwmhUdi3Pk/8tW/lpPBo3FGMWb091Dtcf5LM5OXfStm1okzFRDXaEF1
         y3luTFIufV4bn1PA0vCQskZHMQ85d7fyhX6YCoRM6N7pHjfbBengi2GN72kvr3Co4m3I
         0HDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=N1UhE90kw7eZKOYH701CqkEpipu4X6Khp12ykHwyDEg=;
        b=Iwxfh5a0b+Y4yjgp5VFPyZ6P/UCXYQX6DlxjIuuJdpjS2Itt2n7nzd3Zs2odppYcoO
         4FaXwwiLJrGyuDFgoT5rkazbW3BfiToM4bYu0h/bY5xvYk6xv/HQrRJwYRTr8yb6d5pl
         E9UXVil3GfVqgSTHV6fRwMUq90idmx3Dla1UxumqBe3WzCo6iPz6J1v/4wrY251FhetW
         YDKt5l1RReJ8uLoEBnh0eWN0+PqJB7NdPD1hyqtkdtGHHvMIC9FMqjssBO3T8ghmE45H
         pzZ1FCtiZxVikGUKXSd+I6KplYdW9OZ3u7XKLYsimjVqaPolxDQ43bQFwUILNKdNWqYY
         VLQA==
X-Gm-Message-State: AOAM530C+mDG0c15/UaInGHrB0q3ppsrAy5kNc5eBkvDtMh+doESPA3S
        2ICc/kWpg9oZw5Q04ObY1aO1yQ==
X-Google-Smtp-Source: ABdhPJySrRnB5vcgVacNSmmJabqKLfFQtmtEqtQ6no8yHvK2BoEaOPrdDqhN/RqXAzVDkArKeW2oGA==
X-Received: by 2002:aa7:962e:0:b0:50d:5ed8:aa23 with SMTP id r14-20020aa7962e000000b0050d5ed8aa23mr5421341pfg.43.1651872568458;
        Fri, 06 May 2022 14:29:28 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902a50700b0015e8d4eb206sm2264597plq.80.2022.05.06.14.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 14:29:27 -0700 (PDT)
Message-ID: <8e9bf420-0405-fd71-826d-7924528f2d09@kernel.dk>
Date:   Fri, 6 May 2022 15:29:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5/5] io_uring: implement multishot mode for accept
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-6-haoxu.linux@gmail.com>
 <3b302e60-cb5a-a193-db13-5ca0ef5603cc@kernel.dk>
In-Reply-To: <3b302e60-cb5a-a193-db13-5ca0ef5603cc@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 2:50 PM, Jens Axboe wrote:
> On 5/6/22 1:01 AM, Hao Xu wrote:
>> @@ -5748,8 +5758,12 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>>  		if (!fixed)
>>  			put_unused_fd(fd);
>>  		ret = PTR_ERR(file);
>> -		if (ret == -EAGAIN && force_nonblock)
>> -			return -EAGAIN;
>> +		if (ret == -EAGAIN && force_nonblock) {
>> +			if ((req->flags & REQ_F_APOLL_MULTI_POLLED) ==
>> +			    REQ_F_APOLL_MULTI_POLLED)
>> +				ret = 0;
>> +			return ret;
> 
> FWIW, this
> 
> 	if ((req->flags & REQ_F_APOLL_MULTI_POLLED) == REQ_F_APOLL_MULTI_POLLED)
> 
> is identical to
> 
> 	if (req->flags & REQ_F_APOLL_MULTI_POLLED)
> 
> but I suspect this used to check more flags (??), because as it stands
> it seems a bit nonsensical.

Looking deeper, it is indeed a mask and not a single flag! So the check
looks fine.

-- 
Jens Axboe

