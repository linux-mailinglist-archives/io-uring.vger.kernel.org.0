Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B0A6FE198
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 17:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237583AbjEJPc5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 11:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237521AbjEJPc4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 11:32:56 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBE330CD
        for <io-uring@vger.kernel.org>; Wed, 10 May 2023 08:32:55 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-3357fc32a31so886085ab.1
        for <io-uring@vger.kernel.org>; Wed, 10 May 2023 08:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683732775; x=1686324775;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V/WMn8cfCQ3m89e3gG7QAkSL02x/LJuxioYEZNyvj90=;
        b=qagL4xKE41ovWAGNXOs0lFKx2IQn0GbLiqyQlXQjqVqLjWfhZwr/0zEKCHy0F1u5Th
         vX1YMkFlnLXs3Wus2MQRxU/oiwJn0IrFafkQ0ouvvICRjcrmRTnvWuZ/67WLNJZlfVQ8
         uwfxTRe+fDKtTqlXHuHjNJoC6cbSOwqaThVobiGs7UOJ/eI0GhmD+mQNfB0TUaxuj7M+
         Svo9FJa/ZAXvFK1YRXnulJ1mJf3g+wlSzlWp6VDEi6C61f7MQrwCdH8/3z31w5z26DnO
         s3s46YzNfgWDEynwjmDuebifC3WNdg51vzzxW8VUGrM/BoNOphgPb1K2hKbhV5kUw1KE
         p+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683732775; x=1686324775;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V/WMn8cfCQ3m89e3gG7QAkSL02x/LJuxioYEZNyvj90=;
        b=OpDh+cnZBPDDIWp+pBcpOq/l/mZFxVU8jHGrexLC/eDcTgzYHbEP/Zycjv6+pp7sRk
         JkkIj+fP6VZJmEv7CwhCdz1B0ng92GhrUjujqdhjEe2vj0HP7BW//Xhng68tOSrlA1bf
         JC+ynbM5ThRSXyQTBBtOFa6yR6LUXAcr1E9X9Vwmlzr0Akqgc1IG4f1wr9ElxLapHO87
         rjPl2gal7+fmZqUha9++ZsvU+tveCW6k6Bo3AHpvzDw+k/LlDBZKLNLoZpMhJHvAdEXL
         rGSUKblzzVMxI6i93sC1ddmuHBdUpK12vJ0vH4TB4TZR8q25YWdWOch4ukO253sWGdVJ
         P2xA==
X-Gm-Message-State: AC+VfDwq+JCfiCT5Qi+2wuEPzlEUuCqNAu8fEKOlSHq8D2yl35gEGPQy
        ++Zr+dtcQGir3FYzWETOrjqDJP7traC0yHvOL5k=
X-Google-Smtp-Source: ACHHUZ7sU3WhyVt4kIc6cni16GTfAXEM1cYEusRN3oj9l67bolxqQu1gULzWVhgDoJ4A2Njr9vgFkw==
X-Received: by 2002:a05:6e02:1d9b:b0:32b:51df:26a0 with SMTP id h27-20020a056e021d9b00b0032b51df26a0mr10065590ila.2.1683732774746;
        Wed, 10 May 2023 08:32:54 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t12-20020a056e02060c00b00331833da1dasm3813307ils.35.2023.05.10.08.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 08:32:53 -0700 (PDT)
Message-ID: <8d5daf0d-c623-5918-d40e-ab3ad1c508ad@kernel.dk>
Date:   Wed, 10 May 2023 09:32:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/3] block: mark bdev files as FMODE_NOWAIT if underlying
 device supports it
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        linux-block@vger.kernel.org
References: <20230509151910.183637-1-axboe@kernel.dk>
 <20230509151910.183637-3-axboe@kernel.dk> <ZFucWYxUtBvvRJpR@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZFucWYxUtBvvRJpR@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/10/23 7:30 AM, Christoph Hellwig wrote:
> On Tue, May 09, 2023 at 09:19:09AM -0600, Jens Axboe wrote:
>> We set this unconditionally, but it really should be dependent on if
>> the underlying device is nowait compliant.
> 
> Somehow I only see patch 2 of 3 of whatever series this is supposed to
> be in my linux-block mbox, something is broken with your patch sending
> script.
> 
> The change itself looks fine even standalone, though:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks - the 2/3 only is on purpose, 1/3 is a networking ditto and
3/3 is just io_uring now being able to delete some code. So this one
was supposed to be able to stand on its own, should've had the cover
letter for everyone obviously though.

-- 
Jens Axboe


