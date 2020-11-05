Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63C02A8408
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 17:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgKEQxY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 11:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgKEQxY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 11:53:24 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1EBC0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 08:53:24 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id r9so2483717ioo.7
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 08:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WY/1sgphczcMj28m3+UitF+FV2OOOC/qpp5GYXza1Eg=;
        b=vev+UXkG1BPknA9S6X9+lbSHZXCtw3et7ihjfOtcUOnhDa4FvXDJZCN75yaLCnmIp/
         W2v6cQp4SIzhw+G/dwk2qnVxvB2YXFTvhC7ANp4PleMudkpUaUfRFa5S6xKwxgGSquxF
         LmgpnztTMIqG7TiAtBpdw0CigZhHxL9fViebqkYaD9iywm/+1L2f/nhQmRnoosq5kqMq
         1vjHi1v2WCkEbMa4k2QM7D4gJvnkZzx7ZxK8S1hh/H8W2y/riCEqbswCrH4WvZhqQbj7
         FV7UKYYYX5hGrcGiB7IvqzScszuCc9VKCIEEOT6WTt1OTcguxspIqzKh5JUIg9dhJJ+f
         EVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WY/1sgphczcMj28m3+UitF+FV2OOOC/qpp5GYXza1Eg=;
        b=r8JOjqMhfPz3dC4x5pIArwVUW4069GnTT6yRtAc/ZQuVJScbQoJXhuNCU1wVYnrYD+
         cMtFKj48M9mw8YIqS6GUmERr4vweCx9bGGqIIJgMqAsgOthzZan+CwuTlBZPTNUlgeYv
         e3bEumO+7tQEYtSIHnawDJRyG9jl6haIsvbuTND6t2IH8T6CfFSQ6+8PzpwBdCPZzTMb
         a2+rWp1keikok4kx4puI4FQ8h9l0y2HIUl2Pn5rRtam/Km3FvLh1baAMrH2QroN42ukW
         MhrAfxqAb7dyRI2TE2ARnIp+V9MSNbRko3LHR0rSv0MaNuMqsWIVjBN7+5oV4J2Bfcbo
         Etdw==
X-Gm-Message-State: AOAM530JvfT2YMA8l6TWncNsKl/jlsiVAS8c7waV6YTJ9YImOydZU/cF
        TDJUahLqmNA65VEUqjyPjkVCH97iwP2qpA==
X-Google-Smtp-Source: ABdhPJyyqowik0+Pj18JViYtY6v2j6OAud3ucPLEKakfToZYIvRvV+/BHlvSnp2gZ8d/oHHXf/kRFA==
X-Received: by 2002:a6b:fd0c:: with SMTP id c12mr2247565ioi.107.1604595203325;
        Thu, 05 Nov 2020 08:53:23 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u23sm1338160iog.38.2020.11.05.08.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 08:53:22 -0800 (PST)
Subject: Re: [PATCH 5.10] io_uring: don't forget to task-cancel drained reqs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <d507a3d66353d83b20d8a5e2722e8e437233449a.1604585149.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5816fdb8-8161-6067-0f4a-5b9a23c42fee@kernel.dk>
Date:   Thu, 5 Nov 2020 09:53:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d507a3d66353d83b20d8a5e2722e8e437233449a.1604585149.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/5/20 7:06 AM, Pavel Begunkov wrote:
> If there is a long-standing request of one task locking up execution of
> deferred requests, and the defer list contains requests of another task
> (all files-less), then a potential execution of __io_uring_task_cancel()
> by that another task will sleep until that first long-standing request
> completion, and that may take long.
> 
> E.g.
> tsk1: req1/read(empty_pipe) -> tsk2: req(DRAIN)
> Then __io_uring_task_cancel(tsk2) waits for req1 completion.
> 
> It seems we even can manufacture a complicated case with many tasks
> sharing many rings that can lock them forever.
> 
> Cancel deferred requests for __io_uring_task_cancel() as well.

Thanks, applied.

-- 
Jens Axboe

