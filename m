Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4523375C8E8
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 16:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjGUOEX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 10:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjGUOEW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 10:04:22 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B81FD
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 07:04:21 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-7748ca56133so19039439f.0
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 07:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689948260; x=1690553060;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hd+3Du2K9dSrzjpH/WaoagexKKiDZ1jhyAjWgONy/SM=;
        b=O+xzZQcfECwCo7dj8d2XQwOmWjwAYSTfqBX+tWLSqF4Fa/OYxDXKfRJAQDEgaMfF8O
         OSy2ja5rQPoz+Eau6M7XMYe9nTODuBWaqhIPi5ZZiLj6ZLdCr4A2XETtBGzNPBdL+OBf
         OhL8E8Ucbu/NPy01gcL7aGM0xNUR6QjIkHfERuY1woRsLu7uipWldr+tWkcWJ7s6fZW3
         ojRfhAQLq4GYd4pOknbZ56CijpaQoUl8f/5GBeXC9M50REQ4hiZg2rY2Tib+92jF/eqX
         qwFjONOwPZdWHs2/X+k3H7yJOGpvl9qL7Fi5f1iGqPKG2qS2mE18J6RXgSHoPo+7qFVm
         n/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689948260; x=1690553060;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hd+3Du2K9dSrzjpH/WaoagexKKiDZ1jhyAjWgONy/SM=;
        b=P3lL9edLawJ0riGSUPXsK07K4SmRpdY/G2LWPyyLRJRe6OfU0F3UyF8T/F38Jf48b0
         JsYLZ1iQLd0Rg6uEtXu02vkUZ1kmDv54tMe5rSj3QiYKOOiO0ROHWHZZktmPd5/8EA0x
         dYZr8Vuoi+XV/9QfbdNcT1tlh7wDyh4EonENkblrXWrQ27SjJ0eA7Fn4o0QUcts0rWrO
         vutIHZMmrRUFkEKmClDnbrZ1ijsYKFwxVdBM1+6dveGIfPtPGam04P7AJoXssQqWQ/yP
         aHOj+i6AFFvmwXFC2+NL1trXXFWdkwDK6lca5gCtPNSldgxWfyvzeJAaQLmYnyxFz2fa
         FsCw==
X-Gm-Message-State: ABy/qLaXAXBhGPqoMrV+Cy6RKivHRpdzHg/bLx+36ObS9rM9ppNQbqFX
        Y+fc8DlM0NtG/nUBXeeLGWMu8j9Rb6T73mIszYQ=
X-Google-Smtp-Source: APBJJlE6jLWBotJ7f2uz+sxTTQ8vydHCa8L0AWolLZQNBVR3bY/PP5K7si0YOiHp+EBcYkga9vPoMQ==
X-Received: by 2002:a05:6602:8c9:b0:787:16ec:2699 with SMTP id h9-20020a05660208c900b0078716ec2699mr1675361ioz.2.1689948260668;
        Fri, 21 Jul 2023 07:04:20 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dp21-20020a0566381c9500b0042b1061c6a8sm1063459jab.84.2023.07.21.07.04.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 07:04:19 -0700 (PDT)
Message-ID: <5b14e30b-1a22-b5fe-1a21-531397b94b16@kernel.dk>
Date:   Fri, 21 Jul 2023 08:04:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/8] iomap: treat a write through cache the same as FUA
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org,
        andres@anarazel.de, david@fromorbit.com
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-4-axboe@kernel.dk> <20230721061554.GC20600@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721061554.GC20600@lst.de>
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

On 7/21/23 12:15?AM, Christoph Hellwig wrote:
> On Thu, Jul 20, 2023 at 12:13:05PM -0600, Jens Axboe wrote:
>> Whether we have a write back cache and are using FUA or don't have
>> a write back cache at all is the same situation. Treat them the same.
>>
>> This makes the IOMAP_DIO_WRITE_FUA name a bit misleading, as we have
>> two cases that provide stable writes:
>>
>> 1) Volatile write cache with FUA writes
>> 2) Normal write without a volatile write cache
>>
>> Rename that flag to IOMAP_DIO_STABLE_WRITE to make that clearer, and
>> update some of the FUA comments as well.
> 
> I would have preferred IOMAP_DIO_WRITE_THROUGH, STABLE_WRITES is a flag
> we use in file systems and the page cache for cases where the page
> can't be touched before writeback has completed, e.g.
> QUEUE_FLAG_STABLE_WRITES and SB_I_STABLE_WRITES.

Good point, it does confuse terminology with stable pages for writes.
I'll change it to WRITE_THROUGH, that is more descriptive for this case.

-- 
Jens Axboe

