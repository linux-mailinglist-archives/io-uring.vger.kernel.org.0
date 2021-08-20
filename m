Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99B93F363F
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 00:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhHTWGF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 18:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhHTWGE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 18:06:04 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79159C061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:05:26 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id a21so14112762ioq.6
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hx50cK0EEUXJWOuP3KL4xtZRlYo3hdOkHAHuI51CPbI=;
        b=KHqcWZSQwmn66vCRNPPsyg2jYLPh9qchJkN8aiI2+9Q/vn/ubbM/fXAklXybWEOLX1
         zZ61NAF6x2yQ5blj8tqLW9CQUQGD5jGd7yxAzeVHDLeUZufeYsOE3A3V//aLGMEoGIqc
         VChoP4KknJ69pn+7a6f0iwOzauwJxn6rDh3Gv7cNjPSwQT3ZpvAjh/eExBvtSSnqyzTJ
         m/K2jqGFf7QCqRQT7b9+TpmYn+KKlom49zdfIc/feFiPHceudGRT6bC5m8u2rlfP0i4d
         nvlX7UmhCEbQI6MJKFBHIUGTeqZ0iOyw9h3re/aJPndBzyXSTaVM7KnEIxVMj4f64VMt
         +Buw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hx50cK0EEUXJWOuP3KL4xtZRlYo3hdOkHAHuI51CPbI=;
        b=RziNSTR+JIxZn00Cp+QMhb+YfjChwad9/iQg9H0hlWy5uED68Eo/v8PhAFcln2tJ8N
         mJhke51/6E3Vg76ewkG3hg35/ruplE/Lv7Mqt5ObBHTwAVx9MlQT2T0gvgTIPvxdvGl/
         phOkEnQqIv5Z+DMFij9+DrR9NABD09mkCVN+/WeRH92xuBl+L030ZChMxYaUyh5G1bTw
         d+A1qSaqsCOxdJIkcTa12sVccW6n+a9hgcIeQL130wZqxg4unltrDRS9dTrP/TMuPjK5
         U9SxBQ6Z/8aZJS4NRzaDVJpOf7NE6pkNbk9s0TtvWJdjq9B1AKGktL1rJZrGC5RAJwVD
         bprg==
X-Gm-Message-State: AOAM530cI5o+uzSopJ6KsPIZf3XPDfl9Iysxri6L7VrjrZnMTxS99tF6
        wqlk71L6D6eYG7COjY3NZxc3GoGx2OqM7n+o
X-Google-Smtp-Source: ABdhPJzQuucISNOow/VUyuNItiQFGLfbBNNBOQYlTYUocXVgd4xRQNHb7UKXgpO0xPZFB+BtHfvf4Q==
X-Received: by 2002:a02:cf2e:: with SMTP id s14mr20147684jar.74.1629497125384;
        Fri, 20 Aug 2021 15:05:25 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id n4sm4140006ilo.66.2021.08.20.15.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 15:05:24 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix xa_alloc_cycle() error return value check
To:     Matthew Wilcox <willy@infradead.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <5ba45180-8f41-5a1f-dd23-a1fc0c52fd37@kernel.dk>
 <fc798a75-0b80-7fd7-9059-2072896038af@kernel.dk>
 <YSAjeuZ0zqJOkwUm@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9e660f69-0adb-2738-6bb1-79e9d0d4e8a0@kernel.dk>
Date:   Fri, 20 Aug 2021 16:05:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YSAjeuZ0zqJOkwUm@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 3:49 PM, Matthew Wilcox wrote:
> On Fri, Aug 20, 2021 at 03:01:20PM -0600, Jens Axboe wrote:
>>  	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
>>  			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
>> -	if (!ret)
>> -		return id;
>> -	put_cred(creds);
>> -	return ret;
>> +	if (ret < 0) {
>> +		put_cred(creds);
>> +		return ret;
>> +	}
>> +	return id;
>>  }
> 
> Wouldn't you rather:
> 
> 	if (ret >= 0)
> 		return id;
> 	put_cred(creds);
> 	return ret;

Don't really feel that strongly, I tend to like to do the error path
like that unless it's a hot path. But I can go either way, if someone
else feels strongly about it :-)

-- 
Jens Axboe

