Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF7E36DA48
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 17:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240674AbhD1OzN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 10:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240463AbhD1OyF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 10:54:05 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA256C061574
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:53:20 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 82-20020a1c01550000b0290142562ff7c9so4875484wmb.3
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZCCLC4heMVYs3ScEyNX7BnO/kzlQlMN0utsrrDRjLqA=;
        b=ABK5emo6mKUCiJgFrcmfKwPKCpG8nCIc2vFiTFe2iup5Xi+Ghsqf1aZKE+EuvPk2RG
         q+jYkLz9/h7Z+eNOfVMzYtxWw8qx+hgeiWoB0rCZ+n/S698CSRL2S7uI2fMT5zxwDCAj
         keJR9kiQ7m66h5OlnX3RpVCz5i0288vwl0d35yI0huu9VvPSZFfhVXAevpCj5LFO4Fvr
         A6kbRfsHPTZAFI1bRe7iUzhuym78Fe3v4qCEZJlCV0AWIH88s29LoNUZeeHmvqJxRUXo
         M4A0Vt38WC+Y8f5q8DG3l95DpfX7M6iXxye+Q/ICX/UEXNrFrn08S3U5BPqjIlQNEUvp
         ssZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZCCLC4heMVYs3ScEyNX7BnO/kzlQlMN0utsrrDRjLqA=;
        b=Ovv8sktMQ2rSIuZTp/+cDde02wDQqb0aMbwbG7wTpjg9tkGqbepNRWHctiHm0NOKY8
         2dRCxKF2isGD4Tg+JuKIPdYnkSO/Fp1td83SiPGRBOMpNm7Tlxalemw6lKDwoHQ8inEs
         7su5X3K8hzfdgNhOiP+dWOB7cnSzgGkbiVxs4H4uLvfrb0ED/0xY/cACd2ACFp1k+DqL
         zRMlU3J/Z2dobBcySGK/ZuSbbj90gLDzXa3dKBmhafGqcjFippTscBF83QE9Kgj3cms3
         l+JzGm2cWXWlAtTpTb9+Ps361GmczC41P2uD5Qvrh9dExV/+uXH9aydsr0rAB4WzGRXA
         zAcw==
X-Gm-Message-State: AOAM533i4diIOcZ0d6hkTQ76ugOQQwqGTKxzVV1e19rrXO7vuRHweGbH
        Io91m7WhAwR+6KYacsBhgLlQKahI9HI=
X-Google-Smtp-Source: ABdhPJzXSoFQbzrgWOWufbXtrzwi6D7DhgeSkyj14Cxf/A18oY7yc5j0GMQY303oXXaYJUrdInil2Q==
X-Received: by 2002:a1c:cc0e:: with SMTP id h14mr32340028wmb.4.1619621599436;
        Wed, 28 Apr 2021 07:53:19 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.35])
        by smtp.gmail.com with ESMTPSA id l12sm222903wrm.76.2021.04.28.07.53.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:53:18 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
 <2fadf565-beb3-4227-8fe7-3f9e308a14a0@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <03eab1ba-3fe6-1996-326a-7d78ace4af34@gmail.com>
Date:   Wed, 28 Apr 2021 15:53:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <2fadf565-beb3-4227-8fe7-3f9e308a14a0@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 3:16 PM, Jens Axboe wrote:
> On 4/28/21 8:07 AM, Pavel Begunkov wrote:
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index e1ae46683301..311532ff6ce3 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -98,6 +98,7 @@ enum {
>>>  #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
>>>  #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
>>>  #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
>>> +#define IORING_SETUP_IDLE_NS	(1U << 7)	/* unit of thread_idle is nano second */
>>>  
>>>  enum {
>>>  	IORING_OP_NOP,
>>> @@ -259,7 +260,7 @@ struct io_uring_params {
>>>  	__u32 cq_entries;
>>>  	__u32 flags;
>>>  	__u32 sq_thread_cpu;
>>> -	__u32 sq_thread_idle;
>>> +	__u64 sq_thread_idle;
>>
>> breaks userspace API
> 
> And I don't think we need to. If you're using IDLE_NS, then the value
> should by definition be small enough that it'd fit in 32-bits. If you
> need higher timeouts, don't set it and it's in usec instead.
> 
> So I'd just leave this one alone.

Sounds good

u64 time_ns = p->sq_thread_idle;
if (!IDLE_NS)
    time_ns *= NSEC_PER_MSEC;
idel = ns_to_jiffies(time_ns);

-- 
Pavel Begunkov
