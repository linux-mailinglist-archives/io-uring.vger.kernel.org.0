Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D0920D3DC
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 21:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgF2TCo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 15:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730526AbgF2TCn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 15:02:43 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C547C030F20
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:33:42 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o11so17171900wrv.9
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N1/3uP5oO6k7wiceDKBfYjcd0O63NE8mWk3t3UKY06U=;
        b=W32esAoLMsZt1Zdc5nZaPu0gj/Ke19Ttmtf7obpVOWWqs0TDpSvHqEDAqQj7rZ4pHS
         b5AbaHd123bDnbx4sS2PzhsCUEa1gEdLi3+5tk8hsVGIHDW1A5UEpgO6wiPwfy3qPfsI
         tO2IcydWi1rhRjY2vaCAWQECbjIT/4RG65qepk6I2lVwg9yHnqJ9UKeEoqGlTSYTpNPl
         +R6ecv25fopt0hPToxj+EZ21+PmJGZfrfl/hw6tlsmxAY4a4m/qeDcC0eE5ZAuZpJzey
         a0rGH/o6zr64lZMvtPko/hE6wksf1FLFUmrbHs2ynBBHRqznn7QM3fh3ewtLKhbbkpaR
         t5jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N1/3uP5oO6k7wiceDKBfYjcd0O63NE8mWk3t3UKY06U=;
        b=VaOa67F+CYNgSkKqZq9Uqc8qH1LNr9Gpjk4O+ggkWPWTBizUfwqsCrJDI9TowCWR/S
         BtYWbBWWM49QTu5iYXCn3uLBFhDwp1Yr8XAlsqLBaDZ0uNCB3BZFyl9DbW0Wz+yTm5E2
         2BcYTuWCiXPbtcUz4UiNQVddup/uTwXcsh58x5hJALEPJRt6o+8dtZidAoNbkzeUjm6W
         rGO2CtTjFwP/BDtaxNdOdMz2Nyl7dWtNltnzyIzbY7GyujeGnS4OgEOiIV1tCjKg2T2S
         VoIUoCJZSXv0Xzdc6/SuptcaItoDPtNGd7dew7XG3zKkAaXEB+rJb2ykxNByZGJpmjoq
         Dimw==
X-Gm-Message-State: AOAM531qXIijII92Ye+FLaIuQ+PBpJtfOcsSu7v7gDlhg12mHpky4ecu
        a4TpYbpJov9tQWrugSDP93ezIV4B
X-Google-Smtp-Source: ABdhPJx0p+27VzH/OJPK3+LcEKrOC/CQoUpyCMtsnx/JARdAvzRxgkk0WSuyAP1PdpSDM0p01+AAuw==
X-Received: by 2002:adf:9148:: with SMTP id j66mr15716479wrj.311.1593448420708;
        Mon, 29 Jun 2020 09:33:40 -0700 (PDT)
Received: from [192.168.43.125] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id 2sm324597wmo.44.2020.06.29.09.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 09:33:40 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1593253742.git.asml.silence@gmail.com>
 <05084aea-c517-4bcf-1e87-5a26033ba8eb@kernel.dk>
 <328bbfe9-514e-1a50-9268-b52c95f02876@gmail.com>
 <14de7964-8d8d-9c10-7998-c06617ef5800@gmail.com>
 <23051425-13b5-fd2c-94f7-6f28677cfc6c@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/5] "task_work for links" fixes
Message-ID: <258f09ee-9d1a-9c47-47e1-9263c7e4ba99@gmail.com>
Date:   Mon, 29 Jun 2020 19:32:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <23051425-13b5-fd2c-94f7-6f28677cfc6c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 29/06/2020 18:52, Jens Axboe wrote:
> On 6/29/20 4:21 AM, Pavel Begunkov wrote:
>> On 28/06/2020 17:46, Pavel Begunkov wrote:
>>> On 28/06/2020 16:49, Jens Axboe wrote:
>>>> On 6/27/20 5:04 AM, Pavel Begunkov wrote:
>>>>> All but [3/5] are different segfault fixes for
>>>>> c40f63790ec9 ("io_uring: use task_work for links if possible")
>>>>
>>>> Looks reasonable, too bad about the task_work moving out of the
>>>> union, but I agree there's no other nice way to avoid this. BTW,
>>>> fwiw, I've moved that to the head of the series.
>>>
>>> I think I'll move it back, but that would need more work to be
>>> done. I've described the idea in the other thread.
>>
>> BTW, do you know any way to do grab_files() from task_work context?
>> The problem is that nobody sets ctx->ring_{fd,file} there. Using stale
>> values won't do, as ring_fd can be of another process at that point.
> 
> We probably have to have them grabbed up-front. Which should be easy
> enough to do now, since task_work and work are no longer in a union.

Yep, and it's how it's done. Just looking how to handle req.work better.
e.g. if we can grab_files() from task_work, then it's one step from
moving back req.work into union + totally removing memcpy(work, apoll)
from io_arm_poll_handler().

-- 
Pavel Begunkov
