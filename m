Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7319B23C317
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 03:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgHEBnq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Aug 2020 21:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgHEBnq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Aug 2020 21:43:46 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7B5C06174A
        for <io-uring@vger.kernel.org>; Tue,  4 Aug 2020 18:43:46 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p3so23522779pgh.3
        for <io-uring@vger.kernel.org>; Tue, 04 Aug 2020 18:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TitGAVgx5lqM7eYHk/RXs++xgUktc2D9nD47TTgZTiY=;
        b=YHJukIHKZ0aqhzhzGD/JCs2KnRv3G/fH3+O+R/xmIUxeFvMg1xc5XHBLtwLj0zgYPk
         rec93ygLZ0wvwseEZp7htEeCASqI+v5qqJ80/JTHo/IKlTS7re/a6JrkNjkwOPSc0S41
         LsGPzBCOsdMwslmkc7wlCfua/n3/CAxTxSpAzBu+CcDWzb+FK4rLScznWZJSe7wnp+p4
         28S/Wvz+qPtczXHRgGy+GcXz0t0zoHyUElZtXS6JjRNT37cO2+oJf/x6izhIgwd/t3/8
         A6zzpg3FCM1ct5yS2Ifn4AMa4n7OyuTFoC/pw1d2Z4pmXRz8zKOLt9IydU4BVTwjdKGl
         WWPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TitGAVgx5lqM7eYHk/RXs++xgUktc2D9nD47TTgZTiY=;
        b=TbJ/2Trczk9B43jDFAw5SuXpopYv+RBy7qgla4KCHjEOH+A+Nk5TNXLIpjGgdb1yhm
         kRTSMP+Vl6nFyh85bOZAZfEInOp7g3W8Fg4wsFl/qVpsWAJ9e4vbPtjKRwxArGptay7K
         EUw0VmcZxAKsw5ZEWlgD0K4MgTKlCajKF5jSPtrL2OlGBGfxtmbDeTPBMUW/uQQlrKNU
         UBKbyyt2QLxwrZie0Q8voPbhotqSk98ZQVBF1q+benRKJz2CHJqEfPOTQ5O9UF1GEKlG
         zDDl7Vyp6ctF2ryjuzSFF1Q+/qG8t1TQMjHzS+8Yl6aqWkZW16S7M7jySST3bHU0sUkh
         KVhA==
X-Gm-Message-State: AOAM530fMEozTMOt2bk651TRmncqBFGScmHsfH9Jtz1wHs7xziz2czGv
        SoUSS3IYn4OS4P5x5K1+/sxSNZsqo8w=
X-Google-Smtp-Source: ABdhPJyhC7/41Hlx/uT+r0X8fsoIiFEJvts4X3SFv6GTeMOsVjGFk7BIhvIgV57Uw+A+Y8a4bfU7uw==
X-Received: by 2002:a62:62c5:: with SMTP id w188mr1117321pfb.133.1596591825195;
        Tue, 04 Aug 2020 18:43:45 -0700 (PDT)
Received: from ?IPv6:2600:380:7663:1937:c262:8ace:4489:dc8f? ([2600:380:7663:1937:c262:8ace:4489:dc8f])
        by smtp.gmail.com with ESMTPSA id r28sm561666pfg.158.2020.08.04.18.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 18:43:44 -0700 (PDT)
Subject: Re: [PATCH liburing v2 1/2] io_uring_enter: add timeout support
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Stefan Metzmacher <metze@samba.org>
Cc:     io-uring@vger.kernel.org
References: <1596532913-70757-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1596532913-70757-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <a1c1413b-ede9-acf5-7bfb-7b617897f1d7@samba.org>
 <1072d796-5347-eb4b-b0ad-1e1838c1a100@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f8b90784-669c-7fbc-ad9d-4cc49ac314b8@kernel.dk>
Date:   Tue, 4 Aug 2020 19:43:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1072d796-5347-eb4b-b0ad-1e1838c1a100@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/4/20 7:08 PM, Jiufei Xue wrote:
> 
> 
> On 2020/8/4 下午6:25, Stefan Metzmacher wrote:
>> Am 04.08.20 um 11:21 schrieb Jiufei Xue:
>>> Kernel can handle timeout when feature IORING_FEAT_GETEVENTS_TIMEOUT
>>> supported. Applications should use io_uring_set_cqwait_timeout()
>>> explicitly to asked for the new feature.
>>>
>>> In addition in this commit we add two new members to io_uring and a pad
>>> for future flexibility. So for the next release, applications have to
>>> re-compile against the lib.
>>
>> I don't think this is an option, existing applications need to work.
>>
>> Or they must fail at startup when the runtime dependencies are resolved.
>> Which means the soname of the library has to change.
>>
> 
> Yes, I think the version should bump to 2.0.X with next release.
> 
> Jens, 
> should I bump the version with this patch set? Or you will bump it
> before next release.

It should get bumped with the change, otherwise things will fail before
the next release in case people run the git version.

And while you're at it, add some more pad. Don't want to go through
the same process again the next time we need a bit of space. Just add
4 unsigneds as pad at least, that's enough for a pointer and 2
32-bit entries.

-- 
Jens Axboe

