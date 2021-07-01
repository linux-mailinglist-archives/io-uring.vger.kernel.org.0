Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1123B930C
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 16:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhGAOWL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 10:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbhGAOWL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 10:22:11 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C14FC061762
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 07:19:39 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id f14so8098870wrs.6
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 07:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9nhnOO/OXT3Owbn2tkCd5GSivpwPJIsr39p+s8LI34A=;
        b=WEzQqRyOwOMntzDU8+msKDBZuR3WQJZh7bDg3YklQiaw4lcOK54XaxJvDMraeEB7Rg
         Gt/e3QacRNJXvxx5zohVklOe+3u2YBcXZfsHMsZ7TX32vFZ7Zehsl6T3F0afPIaXRtLN
         hi/pzKU/JDALlCb4kYASdfnyrpSKvresp9IYdyx7tchJTjMtIQ4Y/IzbL9tWs1rrlHRG
         Jb4Rsu+SayYaE+VWYDAN6eBA4lcaZzqBRE8Gj838uKKxXzwKNXaElq2o3NbI6/Y7ba+L
         GKn4dAnsFHhioM+C7Kf43sckMvb/kZ4cuIw2PIdZwBz+zosHX5IQ6dYPxAVgNARIf+tV
         XZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9nhnOO/OXT3Owbn2tkCd5GSivpwPJIsr39p+s8LI34A=;
        b=h3dpDqx5iswEV6BpF0p6MP/wviWrNthPyGCU7p+sXKy+khOEOmIRagt/h2OlW2cdli
         KEJyW9tgQqTJDyH2kjEv5vycyXgBxnun0QSJhzUc653Elj3ys2j6T1EoHzi18M0Td3BH
         9hkBxft8AnnrbgOV/rD4HaOPECLxUFMEFBCkRt3uFMCK+x1n/nd1EqkRwBB9Hpru10iR
         xTzC+5FVUNbZvozJ3le+oUGGR+6BwLkLw6qCXoEFEJsvhoqjUZwZnibneY4XcQ1pIBXb
         8nrTTvHHMiVI8VP33IT2wW25tXZ7LghXnoNrVlp3sj9Ygld1MTdhjsQpch1v69Pyd7ns
         LiOg==
X-Gm-Message-State: AOAM532qYSXqrkFKJjFXNlFqZubi8hkIr5MDBIA6xIw9mNmTeMBox0/j
        BPlZcL6Adm3E/sNMlm33r3ucRPJjdEODuTp4
X-Google-Smtp-Source: ABdhPJzRYPRdRK92AjlEDyD43g7SZtCtV8GBoRnFrOl/z37P/c7CJAte2n5QCC/5rYRtNt7dAb4DQA==
X-Received: by 2002:a5d:6cca:: with SMTP id c10mr23540256wrc.166.1625149177935;
        Thu, 01 Jul 2021 07:19:37 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id k15sm9782118wms.21.2021.07.01.07.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 07:19:37 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <060002f19f1fdbd130ba24aef818ea4d3080819b.1625142209.git.asml.silence@gmail.com>
 <c5284516-def2-eb21-e95d-96aeda167c97@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix exiting io_req_task_work_add leaks
Message-ID: <46a98c79-17ef-1041-b4ff-5b178c06f55d@gmail.com>
Date:   Thu, 1 Jul 2021 15:19:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c5284516-def2-eb21-e95d-96aeda167c97@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/1/21 2:45 PM, Jens Axboe wrote:
> On 7/1/21 6:26 AM, Pavel Begunkov wrote:
>> If one entered io_req_task_work_add() not seeing PF_EXITING, it will set
>> a ->task_state bit and try task_work_add(), which may fail by that
>> moment. If that happens the function would try to cancel the request.
>>
>> However, in a meanwhile there might come other io_req_task_work_add()
>> callers, which will see the bit set and leave their requests in the
>> list, which will never be executed.
>>
>> Don't propagate an error, but clear the bit first and then fallback
>> all requests that we can splice from the list. The callback functions
>> have to be able to deal with PF_EXITING, so poll and apoll was modified
>> via changing io_poll_rewait().
>>
>> Reported-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> Jens, can you try if it helps with the leak you meantioned? I can't
>> see it. As with previous, would need to remove the PF_EXITING check,
>> and should be in theory safe to do.
> 
> Probably misunderstanding you here, but you already killed the one that
> patch 3 remove. In any case, I tested this on top of 1+2, and I don't
> see any leaks at that point.

I believe removal of the PF_EXITING check yesterday didn't create
a new bug, but made the one addressed here much more likely to
happen. And so it fixes it, regardless of PF_EXITING.

For the PF_EXITING removal, let's postpone it for-next.

-- 
Pavel Begunkov
