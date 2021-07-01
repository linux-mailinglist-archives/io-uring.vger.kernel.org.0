Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0193B936A
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 16:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhGAOhH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 10:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhGAOhG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 10:37:06 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B949C061762
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 07:34:35 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u6so8523962wrs.5
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 07:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XrMdFEIurwJlTTAe5BECHb4Xq03uWO2g6LN6QKIv+7k=;
        b=PtnoObVSmjhPJJp82svvetT90yIEgWxTZ3QQwfME7hhLXBpf1nTqbGfLffqEUw1jKQ
         s6f7PEEJwk2ZcTbHhA0jKDWh2N2dZJN41RHOAywoMCFcU9M7GSDOqEhDXhiZtx1IV8ye
         LZy95HxX18KhVPn6bnF6IWQLB9xOFkU792yqreL+IJqTNyAgdEM6ZxwJuAJktdgREix3
         NEnP6FzZAjQKqsqpXEj8z0UfAj7MBcqCk6NOfGPkSXZ0IbQ1azxVzIZ5uWPoRzD0s9h8
         cXWChf/Y9Hxk34lrIVuSaedsITEjHoJuoDR3zbOEjpqXp0TsbaqhgOG/VqIny0UcJHDt
         1Xmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XrMdFEIurwJlTTAe5BECHb4Xq03uWO2g6LN6QKIv+7k=;
        b=R37iEv61jv6Jng9nTJ6wKbx+IqdSCbVmyJTemiZow8nMkCH+Sz2XdD57y/4S/A1aaI
         63hb0BBxlEFZSDTwVHnipNhhjRFmlyPjKNF+wu7ceXnJd/rN30r+TOxAQzdSYO90egbF
         IAJsPQ+k17THnkx+kl62+l56jCuvYAS7Vw5+MQ6WVoq2nzE3AN3gonl1MnsoGWvFu3u2
         Tm+VdrOaUJM1ROaDrxsux/wU3YdCj8az5swERqdRipww3N8+HF5MPyjgHwiD4xgaQVKR
         tNzd/EnyAVwbWEg4LLM5ns8t+KQilxsyrXvrF4hwN6PLfrjGDR2QsI+Pzp6zP0iYSiof
         PKVA==
X-Gm-Message-State: AOAM532R3EByrj+qsGfH/WwAboLoGnjYCJH+FJNJUKwD4BOPtH/nGj9n
        qW4u34Ct7Q/E730s4lvNPvsq4fKBtn79A1a4
X-Google-Smtp-Source: ABdhPJx1P2LcxqytPPblkoSu6KXuR0oCtC2vSBR+zIROcD4bIEqCnbR8CkQX1/4HEcLFTTB4GGYVrw==
X-Received: by 2002:a05:6000:120e:: with SMTP id e14mr26691771wrx.139.1625150073681;
        Thu, 01 Jul 2021 07:34:33 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id r10sm132869wrq.17.2021.07.01.07.34.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 07:34:33 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix exiting io_req_task_work_add leaks
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <060002f19f1fdbd130ba24aef818ea4d3080819b.1625142209.git.asml.silence@gmail.com>
 <c5284516-def2-eb21-e95d-96aeda167c97@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <8b459433-fd7b-d823-932b-175585f1b73e@gmail.com>
Date:   Thu, 1 Jul 2021 15:34:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c5284516-def2-eb21-e95d-96aeda167c97@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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

fwiw, it doesn't remove that check, just moved it a bit.

> see any leaks at that point.

-- 
Pavel Begunkov
