Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C3336F282
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 00:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhD2WQo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 18:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhD2WQn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 18:16:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B82C06138B
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 15:15:56 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id z6so7139102wrm.4
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 15:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t7i4jzo5nlGFOOTHgEOU7RJEmOo2Z95pW7/rFlv/tMM=;
        b=PtFHBODK7nESZSz9jGHcwQKvhChUmrIY2MtX+RCtBEnhn0zs4OgzrONWBEgwbVJ4JE
         qRs3l5PwqEvq/k1r30p5HjHoLqACDcXze+ob+oy+LP38ZoIslXfvkuYFdSCWcJ8kR7IL
         X3n40FIhjp+8NwjRDLfHZgJEHRCNcnEHqBRxmc7Eli0HCe4iVUqVawMAtioyi6cBaNeg
         SRi5lyADqMn7DVzm7sIYZ3OmEzRgqyA3YoYw2dJ83z/zd7ep/QMT1dF5YZpS8V040s+v
         +5IeODTcRp+giHZpIjNI50P633gin1632wwJRzs360bqXXwkPR8BEJU2JRShsT/lYM0l
         QSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t7i4jzo5nlGFOOTHgEOU7RJEmOo2Z95pW7/rFlv/tMM=;
        b=dbFQb6mmfFiP2XGjJ4L6G+pheUZafwYbteG/t9jmc7ygkM47sxJerG4Af5JXTlRumG
         JvImgWWyf0bWmHslJazHamA/Atk7kAxjBWsZXI3sjr6hJgJzf6CrfOXgJexj5kU6ngRC
         5Or3YPtGmZ7nA/3tVAciMQt0LucQdPH5qksLpACJ9HjBomMnvElHQWohapfi2YwhXLbr
         alqJBIoEcJmLfMu5aMMCD08Ww8pbl1YheQzET6bUvps55B7F8BsPUCfArhNuHYGnN8xX
         5aDq5hyxmDTIpUXtUZUSnoNMsfv9bwXhymP7KjUcgvOAwDNSc6gM92Nd4Cz9cSraOlHL
         k86A==
X-Gm-Message-State: AOAM5309yaIz/2hmhw9MfkCfGy0l3gyjFeMncdrM37YdAzL+8X0XNHN6
        okTLZtmmuNrbbxoBUet+tIg=
X-Google-Smtp-Source: ABdhPJzV7N3nouH/vsMmQv0J08CWO4xL/wwqQRvOdXi760+Ku40vuz9XDvoMB8Xq/fUaVOX+Ylx6qQ==
X-Received: by 2002:adf:ef8f:: with SMTP id d15mr2284798wro.326.1619734555503;
        Thu, 29 Apr 2021 15:15:55 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id d5sm6287159wrv.43.2021.04.29.15.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 15:15:55 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
 <51308ac4-03b7-0f66-7f26-8678807195ca@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <96ef70e8-7abf-d820-3cca-0f8aedc969d8@gmail.com>
Date:   Thu, 29 Apr 2021 23:15:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <51308ac4-03b7-0f66-7f26-8678807195ca@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 4:28 AM, Hao Xu wrote:
> 在 2021/4/28 下午10:07, Pavel Begunkov 写道:
>> On 4/28/21 2:32 PM, Hao Xu wrote:
>>> currently unit of io_sq_thread_idle is millisecond, the smallest value
>>> is 1ms, which means for IOPS > 1000, sqthread will very likely  take
>>> 100% cpu usage. This is not necessary in some cases, like users may
>>> don't care about latency much in low IO pressure
>>> (like 1000 < IOPS < 20000), but cpu resource does matter. So we offer
>>> an option of nanosecond granularity of io_sq_thread_idle. Some test
>>> results by fio below:
>>
>> If numbers justify it, I don't see why not do it in ns, but I'd suggest
>> to get rid of all the mess and simply convert to jiffies during ring
>> creation (i.e. nsecs_to_jiffies64()), and leave io_sq_thread() unchanged.
> 1) here I keep millisecond mode for compatibility
> 2) I saw jiffies is calculated by HZ, and HZ could be large enough
> (like HZ = 1000) to make nsecs_to_jiffies64() = 0:
> 
>  u64 nsecs_to_jiffies64(u64 n)
>  {
>  #if (NSEC_PER_SEC % HZ) == 0
>          /* Common case, HZ = 100, 128, 200, 250, 256, 500, 512, 1000 etc. */
>          return div_u64(n, NSEC_PER_SEC / HZ);
>  #elif (HZ % 512) == 0
>          /* overflow after 292 years if HZ = 1024 */
>          return div_u64(n * HZ / 512, NSEC_PER_SEC / 512);
>  #else
>          /*
>          ¦* Generic case - optimized for cases where HZ is a multiple of 3.
>          ¦* overflow after 64.99 years, exact for HZ = 60, 72, 90, 120 etc.
>          ¦*/
>          return div_u64(n * 9, (9ull * NSEC_PER_SEC + HZ / 2) / HZ);
>  #endif
>  }
> 
> say HZ = 1000, then nsec_to_jiffies64(1us) = 1e3 / (1e9 / 1e3) = 0
> iow, nsec_to_jiffies64() doesn't work for n < (1e9 / HZ).

Agree, apparently jiffies precision fractions of a second, e.g. 0.001s
But I'd much prefer to not duplicate all that. So, jiffies won't do,
ktime() may be ok but a bit heavier that we'd like it to be...

Jens, any chance you remember something in the middle? Like same source
as ktime() but without the heavy correction it does.

-- 
Pavel Begunkov
