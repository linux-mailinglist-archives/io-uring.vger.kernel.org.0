Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9683EDBDC
	for <lists+io-uring@lfdr.de>; Mon, 16 Aug 2021 18:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhHPQ67 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 12:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhHPQ66 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 12:58:58 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D726C0613C1
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 09:58:27 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id v33-20020a0568300921b0290517cd06302dso8939864ott.13
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 09:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wuza2V4hmTuKfvzbG36627WzQn0qRqdK22vz0YzaOMQ=;
        b=If6INNjQQlstVyNsToExC07skAiVcHNn1VNjezQrDCN8Z2m6/0+cVGuAVAR3wy+2VW
         w/ubqoSi/GpsiVOSI75KrtOouU6weyhVb7O0dD/KCuZ1NECNG/J2Ifglpayt5ChOiUvG
         IgeIBStKnnlGLfqItcF2CA8wTaAdCNfKYSAES6wQ1CaaSfFr2XgUx1Ua5UFAX2QVjFU6
         uFtJoD7bxE24rRtZdLqo6udHx1KRz8jDlEcQ+egDr0EIfmazLD86/sHw4eVTB2SwHLRg
         a28YCqNoejIc+7e9ame7Seb8buL810EgRPvY5m9Ky5f5yi99eOUxqLaFQsnQNU9rS+/P
         Ydgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wuza2V4hmTuKfvzbG36627WzQn0qRqdK22vz0YzaOMQ=;
        b=dcML5wSfwCzH3bNqd6IYD8xdhydkQUyt9tEmogcZ9eWgodZEd7cct5mudE+Lb/3mVx
         FMqHGbxKjA5Ga0B6X2NRXkCDxUekUs+tc06zQPMjsn5wdzg5VqFMb9TE9tvVrwQlNj+n
         BWU8x3tp8qirVXPZeC3R8MDoI/411QeJW5qoxSBxmdaefxRUXUr11BFMxJiBqpk49H+5
         KPcqYvgAwfvJK7u/Rzk/k7DocIR3V2L5y8LWJfAXVcZ0lhNMEp6pDCf8Og1y/huQBvxN
         2ey5KhZtq6ySgiZxORjAMzfCxhFThIB+gksiT2YepwN4NF8knNxdE3vz5FFOsYvC9+Hu
         ulgg==
X-Gm-Message-State: AOAM533/oZerq/aRoFEXBMO/y2b2/mu11C5nQtytBl2FlkCWyOvNuXCf
        IDVBVuOKBfTvV6xPD4GKk1Rb6g==
X-Google-Smtp-Source: ABdhPJzcPjburKbVsGy+q7iTBFfzAaY+sr/TO33j5hSsArUqkyvEgIisQep+9UUJlwriJCuj+g2Uyg==
X-Received: by 2002:a05:6830:19:: with SMTP id c25mr13733466otp.176.1629133106475;
        Mon, 16 Aug 2021 09:58:26 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 31sm2293375oti.63.2021.08.16.09.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 09:58:26 -0700 (PDT)
Subject: Re: [PATCH] io_uring: consider cgroup setting when binding sqpoll cpu
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210815151049.182340-1-haoxu@linux.alibaba.com>
 <9d0a001a-bdab-9399-d8c3-19191785d3c7@kernel.dk>
 <0c3195be-7109-861f-ff05-a4f804380e1c@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ecf0f64c-c303-01de-a7e5-12a162e5302e@kernel.dk>
Date:   Mon, 16 Aug 2021 10:58:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0c3195be-7109-861f-ff05-a4f804380e1c@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/21 12:04 AM, Hao Xu wrote:
> 在 2021/8/15 下午11:19, Jens Axboe 写道:
>> On 8/15/21 9:10 AM, Hao Xu wrote:
>>> Since sqthread is userspace like thread now, it should respect cgroup
>>> setting, thus we should consider current allowed cpuset when doing
>>> cpu binding for sqthread.
>>
>> This seems a bit convoluted for what it needs to do. Surely we can just
>> test sqd->sq_cpu directly in the task_cs()?
> I didn't know task_cs() before, it seems to be a static function, which
> is called by cpuset_cpus_allowed(), and this one is exposed.

But it'd be a much saner to add a helper for this rather than add all
of that boiler plate code to io_uring just to check for whether or not
a CPU is set in a mask.

-- 
Jens Axboe

