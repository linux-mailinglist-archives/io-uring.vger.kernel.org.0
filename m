Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E5D22B955
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 00:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgGWWYT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 18:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgGWWYT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 18:24:19 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C34C0619D3
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 15:24:18 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id a24so3857679pfc.10
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 15:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=skSWS32b9DGs298/tAqjkQilS6cwdTVHkOwCuWNAXZA=;
        b=Vnof6EyMrTvTDrpTzczb4IzSr1DGwghaSkOLMOe/rLcQwPoK/nayLuCHoeP/Avd3Pz
         7Wnuo0Jr7HBmuGvc37I3MmkiSpaXS/9bY8tam2qc/LDk0xpX5v2OdGLR6F5sjbqs/PBd
         XnV+5SrVEc+Cu7Y7JoyxbUYRTyOqEL56OhtxxDipWIa1YXg96gVao3ojVHvEk7ocU0/X
         94RxYDdW1fanEK2jrT48zvjs7ncOqDGpJSXGhI8ChprT8nq5tWhBaf2D7Ukgf5uMe2D3
         XLJvBdihVptajxeBQoUQdjIkRNqSpdO9akC/LAHtG1wUg4iL7GMAeG0YQI4HdsOyy7V4
         2UVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=skSWS32b9DGs298/tAqjkQilS6cwdTVHkOwCuWNAXZA=;
        b=TRdDfMYKywN2+dc6SoOZia2TZ/vnidBrbQT1AjydhFUmlE6ubPaS8BhUJ9JhNSxaW/
         Dssx6V402Q8BZOxceXwg/5/kko1vdUbOQN7aJqN0iVJL7Zj5bgM3U7/Jio/t6tNATHKm
         aaNtGsODbIShwBRKYjFKPLlZjdrRHP25sdgebh6XjhtC/4P8XNzf7Uej6esGKPcZLNdq
         Zyp9oWlItIR7D4yL22JEQ3lWk0MN+djBwK+Fn2LbrtMzb6/vp2hjvrdlD9U8rFlj8otN
         y81BbldNzGsIsAhmRS4w0/Q82OS1qzOv6sSV7vn9xKEotHdvxcdKyjUkbDG2bKNDdHQc
         Cc2Q==
X-Gm-Message-State: AOAM531HJzRiMjJ93DsovoZsVwe93fJqB6Qeav8jHpycqGYSgpP/u2vh
        61uaKxlZb/Oi3wpNRV2MgFoFJ5HV06gAzA==
X-Google-Smtp-Source: ABdhPJyrowabJIt0f8VfuyD70bCxkMpAelPmWHH1cAo9dVHAScf0l4Wdq2XgMFAorjkpiFM5uoHdxA==
X-Received: by 2002:aa7:91cd:: with SMTP id z13mr6346277pfa.133.1595543057861;
        Thu, 23 Jul 2020 15:24:17 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u24sm4003506pfm.211.2020.07.23.15.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 15:24:17 -0700 (PDT)
Subject: Re: [RFC][BUG] io_uring: fix work corruption for poll_add
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <eaa5b0f65c739072b3f0c9165ff4f9110ae399c4.1595527863.git.asml.silence@gmail.com>
 <57971720-992a-593c-dc3e-9f5fe8c76f1f@kernel.dk>
Message-ID: <0c52fec1-48a3-f9fe-0d35-adf6da600c2c@kernel.dk>
Date:   Thu, 23 Jul 2020 16:24:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <57971720-992a-593c-dc3e-9f5fe8c76f1f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/20 4:16 PM, Jens Axboe wrote:
> On 7/23/20 12:12 PM, Pavel Begunkov wrote:
>> poll_add can have req->work initialised, which will be overwritten in
>> __io_arm_poll_handler() because of the union. Luckily, hash_node is
>> zeroed in the end, so the damage is limited to lost put for work.creds,
>> and probably corrupted work.list.
>>
>> That's the easiest and really dirty fix, which rearranges members in the
>> union, arm_poll*() modifies and zeroes only work.files and work.mm,
>> which are never taken for poll add.
>> note: io_kiocb is exactly 4 cachelines now.
> 
> I don't think there's a way around moving task_work out, just like it
> was done on 5.9. The problem is that we could put the environment bits
> before doing task_work_add(), but we might need them if the subsequent
> queue ends up having to go async. So there's really no know when we can
> put them, outside of when the request finishes. Hence, we are kind of
> SOL here.

Actually, if we do go async, then we can just grab the environment
again. We're in the same task at that point. So maybe it'd be better to
work on ensuring that the request is either in the valid work state, or
empty work if using task_work.

Only potential complication with that is doing io_req_work_drop_env()
from the waitqueue handler, at least the ->needs_fs part won't like that
too much.

-- 
Jens Axboe

