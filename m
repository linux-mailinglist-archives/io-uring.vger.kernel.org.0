Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2C536DAA1
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 17:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239377AbhD1O6e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 10:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238547AbhD1O4j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 10:56:39 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38402C06134E
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:54:33 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id p17so7065666plf.12
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8rfPGm5Gj+Au9D19Y5l9dt5BdKjBQSEh3nVUIQ58G8k=;
        b=LZ4N004/1kJBOJnwxa68gyOrGTtSJ431Hjf8Z3OGWF+gtMmUUBLB7bmcBSodXXNthC
         GlYFq0x+fUnxBRjepfZ2locoBMPDZ5QacoQtr6pthNxUuHNTn9T41KI+G7oBIW62/i+I
         QatdIRWY1GWgMEri0+KuvpLY2mrGE185IvWw0pvxAenHoRGGRx8hL4DVY00kLhyQClEC
         p60/OlGzwe3LMSUoTKGNurVOg2lkvCOplNGSDvTs9tn6rxD+gPlrWI3olHF3AEHDrqIz
         VaMNJ3UiLG6yX6OA9CrpBHnGtXr4buTEbsrtnM6xwM4gqg23TlBWYn4QSTlrbckkdKx9
         NXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8rfPGm5Gj+Au9D19Y5l9dt5BdKjBQSEh3nVUIQ58G8k=;
        b=ejC/EKxECn9MWtv/KnHW3yqJnZmuWDZFqURMSXX3gB1hC76+XE7Jc1Ldu1SO1XcvBD
         RAB+Mpm2RLwRkCjyJNalRjFWsfq9FoM/tAfBvP36+F1kde105fo/bvrSrU4aae4pnNM7
         c6sV6T7Mq0eJwh4hVSrVTF67XwKOTApO4lt+XaYHi66Hbvn6dFe+IMERErDzdBkDSw3u
         yZ69rxmOJe6gAMWCnHOFNEgpn83OzdgVWU/FaS/6punt8/e8KDq6xYAiUABxXpM2rQMB
         9LwbI4YTKYi7jA6HGdpRw+lU/5m+vZaaSBAiYckYOGwunO8hsbBmPioaQyQOnw+rr6dJ
         sTcA==
X-Gm-Message-State: AOAM533KksTSCLXb6MA0UGdiry0a2GCsIBpZph8yoJE1f2MGRn3lICsC
        EBCOjo1vWmJ1GWA1MexIhU6zsw==
X-Google-Smtp-Source: ABdhPJy4uAIKp/smIzQpZx9Tq86rjg18RPf3uAW77fx7SKTF4CtWw9e7grYnDKCHb2dr4TmBcWYHIA==
X-Received: by 2002:a17:90b:3116:: with SMTP id gc22mr20472213pjb.212.1619621672692;
        Wed, 28 Apr 2021 07:54:32 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t15sm40105pgh.33.2021.04.28.07.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:54:32 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
 <2fadf565-beb3-4227-8fe7-3f9e308a14a0@kernel.dk>
 <03eab1ba-3fe6-1996-326a-7d78ace4af34@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f9ab9cff-8b4d-e43a-be92-bbbe2a31e02b@kernel.dk>
Date:   Wed, 28 Apr 2021 08:54:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <03eab1ba-3fe6-1996-326a-7d78ace4af34@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 8:53 AM, Pavel Begunkov wrote:
> On 4/28/21 3:16 PM, Jens Axboe wrote:
>> On 4/28/21 8:07 AM, Pavel Begunkov wrote:
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>> index e1ae46683301..311532ff6ce3 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -98,6 +98,7 @@ enum {
>>>>  #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
>>>>  #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
>>>>  #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
>>>> +#define IORING_SETUP_IDLE_NS	(1U << 7)	/* unit of thread_idle is nano second */
>>>>  
>>>>  enum {
>>>>  	IORING_OP_NOP,
>>>> @@ -259,7 +260,7 @@ struct io_uring_params {
>>>>  	__u32 cq_entries;
>>>>  	__u32 flags;
>>>>  	__u32 sq_thread_cpu;
>>>> -	__u32 sq_thread_idle;
>>>> +	__u64 sq_thread_idle;
>>>
>>> breaks userspace API
>>
>> And I don't think we need to. If you're using IDLE_NS, then the value
>> should by definition be small enough that it'd fit in 32-bits. If you
>> need higher timeouts, don't set it and it's in usec instead.
>>
>> So I'd just leave this one alone.
> 
> Sounds good
> 
> u64 time_ns = p->sq_thread_idle;
> if (!IDLE_NS)
>     time_ns *= NSEC_PER_MSEC;
> idel = ns_to_jiffies(time_ns);

Precisely! With the overlap being there, there's no need to make it bigger.
And having nsec granularity if your idle time is in the msecs doesn't make
a lot of sense.

-- 
Jens Axboe

