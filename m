Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A3547B487
	for <lists+io-uring@lfdr.de>; Mon, 20 Dec 2021 21:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhLTUrS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 15:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhLTUrQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 15:47:16 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA36C061574
        for <io-uring@vger.kernel.org>; Mon, 20 Dec 2021 12:47:16 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id 14so14929026ioe.2
        for <io-uring@vger.kernel.org>; Mon, 20 Dec 2021 12:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qNXUg0IfQbj19mJiT1+n91vqkuVNfQmpeeYXgjIoWiA=;
        b=w7rz2QalTZB629dgoN1DCNPMZeaLyDBc70YfmObjXHYrSvSeH02ssDRIZt/9WRraCL
         14JaZDn4ScDIBOa9b7vu1WITbPA9h1BpH70BDscZl8L/zjG7q7EhoebiViFg4SVd/cAo
         yoisOyWyXm05fYAxx6DOBJDOCzJyCMuVX3Km50hFLG6hBVHLrRE9Ru/iMiCLvhorDuDf
         gjYbkl7YyLukCETWpsSfEeSaH3xVcOxpYRKAglP8pNhv2rJAkwUgJe/EgtLC/FlO9foU
         B8GaxwBYu8Iqvls6xCGduF3NWIzeP/7K6D6h2MiZwSjtKcJDncHJFUpExqXsmX3sbadL
         +Gtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qNXUg0IfQbj19mJiT1+n91vqkuVNfQmpeeYXgjIoWiA=;
        b=fqC+gCu1ZxskPSAskowWp7NH6j5N13K0oOM+Ou9nLowJeLVU4gpA6+V33OvSkSDwEh
         SUYGZ1zGMC/PuzAFOeVOZS4VoGi10YYpT11IYADuDA8ZI6BrIjNLWqBqLP/igHCI56dY
         nW+y7WECN5VBCTFck4Vpc/V63swr/MI1c8SD1b1+tqM3PNnl7u9ctA9FJB1v0zwmGjLU
         EyIk2zxkNm/EYe3davomLHpZ4W/+cF4H+Bp15xGjqwVfXgoExx1TVuDvxWKiI4crZp6z
         8wRKmdst6H9LVNSSyfZeVNyeWUBjtkMF8c5lWvGEY2S9JWueX+++pvfsBw4nYemrXmT8
         XWng==
X-Gm-Message-State: AOAM531nL+agc6LO25BiJKiUgjkESskiWPseV4X5gGYDNqpQqsqoWmXb
        rXPYroGwHct7qYR2f1TSMtHQlA==
X-Google-Smtp-Source: ABdhPJyE3gxmyTH3C6HTFpoq34rinqH8Nwm8ha+8iEhXJvQo75/ye4EHGtAFJ0oE5xZZQlTlWGudzw==
X-Received: by 2002:a05:6638:130f:: with SMTP id r15mr4039264jad.184.1640033230746;
        Mon, 20 Dec 2021 12:47:10 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x11sm9679477iop.55.2021.12.20.12.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 12:47:10 -0800 (PST)
Subject: Re: [PATCH 1/4] block: add mq_ops->queue_rqs hook
To:     Keith Busch <kbusch@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-2-axboe@kernel.dk>
 <20211220203649.GA4170598@dhcp-10-100-145-180.wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <61c5c2b7-422a-fad6-cbc0-5d8278759bae@kernel.dk>
Date:   Mon, 20 Dec 2021 13:47:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211220203649.GA4170598@dhcp-10-100-145-180.wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/20/21 1:36 PM, Keith Busch wrote:
> On Wed, Dec 15, 2021 at 09:24:18AM -0700, Jens Axboe wrote:
>> +		/*
>> +		 * Peek first request and see if we have a ->queue_rqs() hook.
>> +		 * If we do, we can dispatch the whole plug list in one go. We
>> +		 * already know at this point that all requests belong to the
>> +		 * same queue, caller must ensure that's the case.
>> +		 *
>> +		 * Since we pass off the full list to the driver at this point,
>> +		 * we do not increment the active request count for the queue.
>> +		 * Bypass shared tags for now because of that.
>> +		 */
>> +		if (q->mq_ops->queue_rqs &&
>> +		    !(rq->mq_hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)) {
>> +			blk_mq_run_dispatch_ops(q,
>> +				q->mq_ops->queue_rqs(&plug->mq_list));
> 
> I think we still need to verify the queue isn't quiesced within
> blk_mq_run_dispatch_ops()'s rcu protected area, prior to calling
> .queue_rqs(). Something like below. Or is this supposed to be the
> low-level drivers responsibility now?

Yes, that seems very reasonable, and I'd much rather do that than punt it
to the driver. Care to send it as a real patch?

-- 
Jens Axboe

