Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF5F360B67
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 16:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhDOOFO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 10:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbhDOOFN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 10:05:13 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF058C061574
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 07:04:48 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id t14-20020a05600c198eb029012eeb3edfaeso2337401wmq.2
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 07:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gV6UdWTlJlMPwqveXv8yOazq3oHa6H76SsBwMD6+TuA=;
        b=uQ9cy3gMAhtsikicjF9+Bh1hdVAWcOeRqOFQf15vIennIS+LQ8axzLMPkDFVBnfuj6
         h8F90C6j/jQQ/zbxN5N42m6Y36DNAITNhKW0K9xkg6ctRpaqoRQLlZ/wkx+W+CVIh0iK
         FIjBJT/4YSv/ylioB1l1BEPWv4kWdRcSzxcstYc1hWH6kCk/dyHR7u+ThNN+lCs3D66S
         SuBQxDGire6sRa/keSSOCJuxNBqEUwb+McDM1vSatyKgerwVqp04sWia2LpVBupkWgyp
         t8uW21czbym5DYDS5q3POamp8KIklwV9/KlJRy4RckiB/kxfe+y0hNal0CcQ89dE80E+
         FHeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gV6UdWTlJlMPwqveXv8yOazq3oHa6H76SsBwMD6+TuA=;
        b=CQ0ceRnBx+KLPYiM/C2k1EQKkqNMisA//aEJ+/+PnC/HShB9Y/s0zBMqs2iguerFXZ
         2JmrEDTbOh6iv2sQ0XE5nuFA4tglD/Qos4HBYZuNVd+qGd1b/8qwIEa0sfB01k7TDJ7s
         ckrIcHLg15A6q9ToNvQhiDuH+SUXYc+2A88DtdoQSTN5VCOBqW3EPCrQiX4BCsbRbGJr
         sgmvBCYrVvdyAsRAnH3KhzqhAjAfiFhxkhpGVZHRLseHr0sDyiLtkC0CyNOrRFtHcEMT
         GKIyI9u9xZdnCrjIJ90nip03oKb7x4KADDqi+y8Ufg8b4A9RJKjoQjcmz2XKxNWScMsm
         DoHg==
X-Gm-Message-State: AOAM532hKKM26/s037ZA4hFQKUUpptBzR3eBuy7DeJgOCBKxP9HyLPvo
        h1Tz//N8YU/PcFlFiQD7pH0UfyY6A2HZ+w==
X-Google-Smtp-Source: ABdhPJz23IycMsqQXlkQPK1un3pJlQ37JAl7PdGTHE2cWoi+uCI+yKYn+EXzpXvz32EinFORXLs9pw==
X-Received: by 2002:a1c:b002:: with SMTP id z2mr3358690wme.121.1618495487264;
        Thu, 15 Apr 2021 07:04:47 -0700 (PDT)
Received: from [192.168.8.188] ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id w4sm3262873wrp.58.2021.04.15.07.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 07:04:46 -0700 (PDT)
Subject: Re: [RFC] io_uring: submit even with overflow backlog
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <0933f5027f3b7b7eea8a7ece353db9c516816b1b.1618489868.git.asml.silence@gmail.com>
 <eefa3df5-faa2-8220-8f7c-ac548c76fd84@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <aeb22b82-1172-07ad-9594-8b7c7284d0e7@gmail.com>
Date:   Thu, 15 Apr 2021 15:00:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <eefa3df5-faa2-8220-8f7c-ac548c76fd84@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/04/2021 14:59, Jens Axboe wrote:
> On 4/15/21 6:40 AM, Pavel Begunkov wrote:
>> Not submitting when have requests in overflow backlog looks artificial,
>> and limits users for no clear purpose, especially since requests with
>> resources are now not locked into it but it consists for a small memory
>> area. Remove the restriction.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> Mainly for discussion. It breaks several tests, and so in theory
>> userspace, but can't think this restriction not being just a
>> nuisance to the userspace. IMHO much more convenient to allow it,
>> userspace can take care of it itself if needed, but for those
>> who don't care and use rings in parallel (e.g. different threads
>> for submission and completion), it will be hell of a synchronisation.
> 
> I think we can kill it, with the main change enabling that being the
> cgroup memory accounting. This was kind of a safe guard to avoid having

Yeah, and not keeping requests, its resources and linking requests.

> silly cases just go way overboard, but I do agree that this is really
> up to the application to manage. And it may have an easier time doing
> so without -EBUSY on overflow being set on submit.

Btw, apparently that's the main reason for getting -EBUSY in mshot test,
just another lackmustest that it's not convenient.

-- 
Pavel Begunkov
