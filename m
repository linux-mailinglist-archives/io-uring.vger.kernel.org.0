Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD0628D0BE
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 16:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389049AbgJMO5y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 10:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389045AbgJMO5y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 10:57:54 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFFBC0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 07:57:52 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id m17so22936716ioo.1
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 07:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+ndNndLuZj9sJxZg8i2J8RKXB/UcHO3IjTz0YqiyYbc=;
        b=ZmH4hFkixq8BQih9DS+McmP3SlN93sLNXob4DqTvg3OI41EVknqNtDZfJ6YWFXrI0P
         hsa269/ZYZQuh025vh9tzJ4YTiVeMCE68jW4pKusjt0P4IwPV/JyvILxq2tctQl5lDdc
         +MnsMPnHL1rLm36VhQE+t0uL38HvquWm1tUhoklFbgDp22/kc19sgX8vlFJLS6ULahux
         qkkR8cn96LUp8IZ6i5Yqa9b7k6bE4GlXiRkpITtigCxvPUPxC5FYVm/caCTDKrKAUYO9
         O4BpsWF8G0LkKNuV+HEMR9/y9SKu4+WPP2ZtU0L961dZJKbU/Xdw6KY7k/7FpbYgKVZ/
         0Gtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ndNndLuZj9sJxZg8i2J8RKXB/UcHO3IjTz0YqiyYbc=;
        b=QBmORNnYU+GWfdswhAvNzoL4Nn/6TH2EdWR5Q/8UTg0vKMcGPY9BLGsDuG4+ZiaXeI
         d5fVAoDWZmTSfhB+G6ZNyyBOqPD78pTPoIlsvzr6MfKeOiQnqaFR+RTj1rUn/YTRUfOo
         pR0cH+HgGPNKL+hQCyVLwUH6DDp9tt53hfwkvCg79mjPoXKk0vcpWq13OJ7d+RV/iupX
         IlJQ02dGEHMmsPRwHl9Qr2ZDvfH7qHCiotEMbq5j0m0DDHgW321wgUrJThE6uu0UaoKx
         FTnTigbw9Ds0VZqIr66bcUrmii4znKFXw2g3+p0b5ojzxBiCTyTGbXt7LNfCTz78WSlp
         qHVA==
X-Gm-Message-State: AOAM5308ylVEzbYwwmmTAKtzBZojAgC9rDTCvWRmR29gMwEKkmIbPVBr
        gLnQ7nrOdX3dLojJVORTDox4sCloZ2Kzdw==
X-Google-Smtp-Source: ABdhPJz7Bx/6TBnRQK15fd94jRfeBC84Jjh9ptQJYMxGTbz8BvT1ejWaxpBS92Oe4AHqtSE1yUUNFw==
X-Received: by 2002:a02:7112:: with SMTP id n18mr325893jac.34.1602601071984;
        Tue, 13 Oct 2020 07:57:51 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s13sm38065ilq.16.2020.10.13.07.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 07:57:51 -0700 (PDT)
Subject: Re: [PATCH 0/5] fixes for REQ_F_COMP_LOCKED
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1602577875.git.asml.silence@gmail.com>
 <48cf67e4-caf1-c1e2-bf74-b3d487ef08b3@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4914cc0f-4ce7-ea05-8388-6f147d785940@kernel.dk>
Date:   Tue, 13 Oct 2020 08:57:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <48cf67e4-caf1-c1e2-bf74-b3d487ef08b3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/13/20 3:46 AM, Pavel Begunkov wrote:
> On 13/10/2020 09:43, Pavel Begunkov wrote:
>> This removes REQ_F_COMP_LOCKED to fix a couple of problems with it.
>>
>> [5/5] is harsh and some work should be done to ease the aftermath,
>> i.e. io_submit_flush_completions() and maybe fail_links().
>>
>> Another way around would be to replace the flag with an comp_locked
>> argument in put_req(), free_req() and so on, but IMHO in a long run
>> removing it should be better.
>>
>> note: there is a new io_req_task_work_add() call in [5/5]. Jens,
>> could you please verify whether passed @twa_signal_ok=true is ok,
>> because I don't really understand the difference.

It should be fine, the only case that can't use 'true' is when it's
called from within the waitqueue handler as we can recurse on that
lock.

Luckily that'll all go away once the TWA_SIGNAL improvement patches
are ready.

> btw, when I copied task_work_add(TWA_RESUME) from __io_free_req(),
> tasks were hanging sleeping uninterruptibly, and fail_links()
> wasn't waking them. It looks like the deferring branch of
> __io_free_req() is buggy as well and should use
> io_req_task_work_add().

Probably related to exit conditions.

-- 
Jens Axboe

