Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B712028D2CC
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 19:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgJMRFC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 13:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728521AbgJMRFC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 13:05:02 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A99C0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 10:05:01 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id n6so97736wrm.13
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 10:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5aHcr5NHk8llBiD6XKl5zRTI2N3Pfa7E7IgTRqUP+As=;
        b=rzZ5ZqMZlELI0YZdTuUwMLBRYLQBJEO5s2B7RmYF1p64lXyHV6jYgl3n92ci5PZU7e
         JCnwgtBSBfOjNPWiHBsFGj7ajb6qSYy57VoccZfE04/v+fFToJY2T4F65ub/zs1ULOg1
         k3QHH7AynED5EUW5u3P3epNGCLbOHZRQKseqVP9wZ7guWK0UTfSKzZ1hsN4nJBak9YnS
         QO4/d4tO8puW0AQeKFkyzslc6MigGzFnJjJJF4DTt6+DI5QVmMvGhd7MshUjnVZbCSKA
         CxgYhID6mNABOaZBLja+He0/RvxYwNOvqauzt0i+x1S/m7Yzx1UesEDR7QX7rqWf5+4G
         TtjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5aHcr5NHk8llBiD6XKl5zRTI2N3Pfa7E7IgTRqUP+As=;
        b=caU38dPJJ6P4hMcBE7OiSmbKPubHqBE1SMmSoHyzNw7tfUJjfOQP44B15aFbG+/7sG
         RJr10PrYviGcW49Yss45VBlByvN8dXf5M3mg4SQpM9MLxpLtkNWQN4r6FtMRDk79y+kd
         hFVohTzPAXU36HW6unWdi1CHd7wuGu/1Z3I14OB6JuVXj2ewoIBmsWbOw5BBXObS4LsE
         U7oyDD3o8j4ZFpBH/9uIX8DeG7YeINh6rNjJ4UP4pLdcn245DlcNN4hriUOdeushTa3w
         B54YeRgG+9itLID1cwMpOIhKlj/dSV4dni1xiOmFiyYBPTiTvfCCvXxO7aLKX8CF+1G2
         FW1A==
X-Gm-Message-State: AOAM533Pa5pLl+PQWqfkYEHnxnH1osrKhz+8n/si7nDet/il47R8dMQC
        MLx7rlrysFchOZ5R6jPcr07ykukQFLDScw==
X-Google-Smtp-Source: ABdhPJyMt4FSuoKAomW9LQ5vi/+LjHcfrrXEC3n9jHmj6aM2WzRBhmsJi+nEgi8xVrPBNRh4m0+EuA==
X-Received: by 2002:a5d:6a0d:: with SMTP id m13mr662547wru.161.1602608700124;
        Tue, 13 Oct 2020 10:05:00 -0700 (PDT)
Received: from [192.168.1.27] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id s19sm332279wmc.41.2020.10.13.10.04.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 10:04:59 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1602577875.git.asml.silence@gmail.com>
 <48cf67e4-caf1-c1e2-bf74-b3d487ef08b3@gmail.com>
 <4914cc0f-4ce7-ea05-8388-6f147d785940@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/5] fixes for REQ_F_COMP_LOCKED
Message-ID: <3a999167-cdf2-cad2-1ff3-fdc5c8cae72d@gmail.com>
Date:   Tue, 13 Oct 2020 18:02:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <4914cc0f-4ce7-ea05-8388-6f147d785940@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 13/10/2020 15:57, Jens Axboe wrote:
> On 10/13/20 3:46 AM, Pavel Begunkov wrote:
>> On 13/10/2020 09:43, Pavel Begunkov wrote:
>>> This removes REQ_F_COMP_LOCKED to fix a couple of problems with it.
>>>
>>> [5/5] is harsh and some work should be done to ease the aftermath,
>>> i.e. io_submit_flush_completions() and maybe fail_links().
>>>
>>> Another way around would be to replace the flag with an comp_locked
>>> argument in put_req(), free_req() and so on, but IMHO in a long run
>>> removing it should be better.
>>>
>>> note: there is a new io_req_task_work_add() call in [5/5]. Jens,
>>> could you please verify whether passed @twa_signal_ok=true is ok,
>>> because I don't really understand the difference.
> 
> It should be fine, the only case that can't use 'true' is when it's
> called from within the waitqueue handler as we can recurse on that
> lock.

Got it. And thanks for fixing descriptions!

> 
> Luckily that'll all go away once the TWA_SIGNAL improvement patches
> are ready.
> 
>> btw, when I copied task_work_add(TWA_RESUME) from __io_free_req(),
>> tasks were hanging sleeping uninterruptibly, and fail_links()
>> wasn't waking them. It looks like the deferring branch of
>> __io_free_req() is buggy as well and should use
>> io_req_task_work_add().
> 
> Probably related to exit conditions.

Yep, kind of
    close() -> ->flush() -> io_uring_cancel_files() -> schedule()

-- 
Pavel Begunkov
