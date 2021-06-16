Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509BB3AA3B8
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 21:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhFPTEZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 15:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhFPTEZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 15:04:25 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08168C061574
        for <io-uring@vger.kernel.org>; Wed, 16 Jun 2021 12:02:19 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id t140so3673867oih.0
        for <io-uring@vger.kernel.org>; Wed, 16 Jun 2021 12:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Oj+qbJv0V3Vr8b46JaC3fTzYS1GiHecn4qb7r6BsRsw=;
        b=yiNEG2VDhnBHrt+D6vu2Hmlt++y3TOg6khHVM76XDPzz0zilldlHPlKO/fSPahOXAO
         AsLtKu2HD8X6VZV3GxZ/Kg/SRTmDN0ETSILMgWNzb/LHmGnaVGM/5fYXsM0OunEUTL4q
         YCsZBI5ZMJXvsfzN5OKy1BqLuMW9/HA6Mj+h5TOfqkMM8o9iAQmForfXYYy+O+sks5IR
         FvUvW8si7W2bIImFa0rQHSuL5NL1adtCmW/U6yh6yMuukcvoE6NFzNV1le+sytyHRWK1
         l9krH8qMrKLCh9mS6NePIHZj5jopNtwzcT++Gh3RMnFKPv1HTjHxlSDyrqB+ngV1J7jy
         r94Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Oj+qbJv0V3Vr8b46JaC3fTzYS1GiHecn4qb7r6BsRsw=;
        b=WMRzt469b03nWjNu7msC/UBK82nJU49gPD3ZCQ0D/i2iHMRnCDPE9g3vm6aWiIZHoY
         7zn81dU+ekm/DmaKyC/FFWrzNCD1egHORdsnYgM3pEqZM/RqODSnHpO8kfWS8HHd4DLQ
         lJJpH3GH4ZYzBFhh22gjZC0BPziq0Y4H8j9Z2/nWgMuNB21wHasAlQEF8fghIc4nmiKJ
         sLGsa5+/gZXBMoSd/fa0IQklPe2134ng8mkoSnuV73g8WiKRia5T6WnCZIXr8YQqJff8
         cgsHm0Ltbb7RTRq2WUIk8g9yk1wyfL8cYI/T1dFC270ASEC1HiEi1XRrpkQcyfmxCc0i
         k6IA==
X-Gm-Message-State: AOAM531rmKEg5WtNrJuIq0BHAo0L9k/Gd83RmtWC5wys2R5f4e6ZZoQ5
        TEg7LywG9cPD3jC/9J7Ze/RTLA==
X-Google-Smtp-Source: ABdhPJx/lE4dGDcqjFgBKvqtQEh4rl75ejCcZX7826J8Zi8GT0YsrCQXSK9DbbpcIk4DeSd9FmQWtA==
X-Received: by 2002:aca:2101:: with SMTP id 1mr706276oiz.35.1623870138369;
        Wed, 16 Jun 2021 12:02:18 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id u42sm596099oiw.50.2021.06.16.12.02.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 12:02:17 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] io_uring: minor clean up in trace events
 definition
To:     Olivier Langlois <olivier@trillion01.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
 <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
 <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
 <20210615193532.6d7916d4@gandalf.local.home>
 <2ba15b09-2228-9a2a-3ac3-c471dd3fc912@kernel.dk>
 <3f5447bf02453a034f4eb71f092dd1d1455ec7ad.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <237f71d5-ee6e-247c-c185-e4e6afbd317c@kernel.dk>
Date:   Wed, 16 Jun 2021 13:02:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3f5447bf02453a034f4eb71f092dd1d1455ec7ad.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/21 1:00 PM, Olivier Langlois wrote:
> On Wed, 2021-06-16 at 06:49 -0600, Jens Axboe wrote:
>>
>> Indeed, that is what is causing the situation, and I do have them
>> here.
>> Olivier, you definitely want to fix your mail setup. It confuses both
>> MUAs, but it also actively prevents using the regular tooling to pull
>> these patches off lore for example.
>>
> Ok, I will... It seems that only my patch emails are having this issue.
> I am pretty sure that I can find instances of non patch emails going
> making it to the lists...

The problem is that even if they do make it to the list, you can't
use eg b4 to pull them off the list.

-- 
Jens Axboe

