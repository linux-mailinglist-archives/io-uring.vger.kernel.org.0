Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C3636D961
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 16:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhD1OQy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 10:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhD1OQy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 10:16:54 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23282C061573
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:16:08 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id m11so659481pfc.11
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=njJeo+QWCetH05FubtHIDzHT+yUwcctdaHFlUajawSY=;
        b=LARKlIW2GTEtwfyZIQBbx7YjteZc9fZXZDYkxwMOLLyGB67UNp4BDkW7OTtChrpJkj
         XFaQfHZ9Vrz4/pzGJvS8pfgAT8FbGfxdo2ILfmL5L03NrUHhuFyZUuLozqUEBj0TKxvX
         jovaz5nWA99xQBSkpcY5rgddohImERVrOWdNarTJ8U4YOjHUg+/GtxGLGV4Eb0JOsO/8
         3b9sbT8k7lXEWb7jbWxZ7p+bAVxIXRfuLC8dy+PSwnCxoCAr2BlzQNBrxlve0vChH7Yi
         wl9v8/W8TxAf4dvD/Bf2QjwPYYDA9K9zK8jww9m43o9PqTCV/7nHnEL0yLE4s7RcMnQl
         B0cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=njJeo+QWCetH05FubtHIDzHT+yUwcctdaHFlUajawSY=;
        b=ac/JgI7Lohlph4BlOObfPZF56ylqy9NYoWTvr/GCXG5d15iwAou/hYkrsI9dUm8/Op
         19fVPzVd9ic1Fh5O4Hb3BrjdgEMeplC3OGdWfkIesHQ1mPHsZmeqIvuxlEM3ey47DBqq
         KWLiPuXao5ZdmreedQ43nUUhcbPEBqLOVSt829LljKLOPH3m6nHvUH2+yhu3/Mmei9vo
         IUPTA/TzRjmeQkSIQnznZBIleQKnAEbN65//LuTZKdMQ7tKVBYi/qHY/zr6aQGzuS/ft
         1u8pX+jF+Z0m9ZDP6A04QjmZf4BYTqO8Q81a1CTPtwbHSRROnvaBCVymN4daoPZEOkCm
         s/fQ==
X-Gm-Message-State: AOAM532xelftYbdwa+JYhueu9yRKKJ56HwOsciUx69dBu699POhyxkes
        omV3V5ZwCUmPNX16DgQMnxUSEg==
X-Google-Smtp-Source: ABdhPJzDL7sv6OFEegGzp0kwla7JjN3++cUo7qj5XL1tZvM3Gb07O+XBfMEiEQSWcmCMccd1fmUXHw==
X-Received: by 2002:a63:4413:: with SMTP id r19mr26886881pga.75.1619619367575;
        Wed, 28 Apr 2021 07:16:07 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b21sm96184pji.39.2021.04.28.07.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:16:07 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2fadf565-beb3-4227-8fe7-3f9e308a14a0@kernel.dk>
Date:   Wed, 28 Apr 2021 08:16:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 8:07 AM, Pavel Begunkov wrote:
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index e1ae46683301..311532ff6ce3 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -98,6 +98,7 @@ enum {
>>  #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
>>  #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
>>  #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
>> +#define IORING_SETUP_IDLE_NS	(1U << 7)	/* unit of thread_idle is nano second */
>>  
>>  enum {
>>  	IORING_OP_NOP,
>> @@ -259,7 +260,7 @@ struct io_uring_params {
>>  	__u32 cq_entries;
>>  	__u32 flags;
>>  	__u32 sq_thread_cpu;
>> -	__u32 sq_thread_idle;
>> +	__u64 sq_thread_idle;
> 
> breaks userspace API

And I don't think we need to. If you're using IDLE_NS, then the value
should by definition be small enough that it'd fit in 32-bits. If you
need higher timeouts, don't set it and it's in usec instead.

So I'd just leave this one alone.

-- 
Jens Axboe

