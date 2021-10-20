Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707A5434F41
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 17:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhJTPs5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 11:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhJTPs4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 11:48:56 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2643C06161C
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 08:46:41 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id a25so27475635edx.8
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 08:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QCuUBg9ajEn6TVZE7ZlTP/TIAek3i3vodlUBgligMwo=;
        b=B5wc8N7G1Jh7MBw0hg47jTEY0ZhGTFPTSLoayq2cw0qm/OFPxoGV0A/CvDhO10FXKS
         QbLvTMrJfOqP4GfdQsHpwLs+ghUAc7jEIK+JqvYl7mz8WUPw/zP7S95vin8Kcf5Xdwrj
         iIJwRYbcDG0GtVHEEkdKbKauk7wtduzQWLf1uw7QZ8jcAUosUll3F+bLJ5CBOZg47dlF
         R6//IosmrGUBeTPuIBlPY+6eApXFCzeegyVe7Nf0bkMfGcJaB8e7//5+DDezuzIHgvzB
         +72DSTDKKyrSgG2ngQ3oMeiK1j8esOAfnFFXqnYc+byjfqIG4+JIsWDgq/4RURs5YwRO
         EuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QCuUBg9ajEn6TVZE7ZlTP/TIAek3i3vodlUBgligMwo=;
        b=8G4uzFUHv8Kvc0btn19Pop2V8PYOhqQIXMpGpqYbegVk+3pie6O3+3vYHaQHMvFpqx
         nESAwTju24gL3BMN6hUzTbiZA/c++n4c91Qwxxs2oU4+AEvfgFd/3VVLwAN6CBvisDnY
         kRl+C5ULEU0Vo2NE6yc4YF/3e3ijRvozr3iyY+3UfqTvciy8giMDnz4/Ln7cfQ6SAOha
         WVKZqcxiKPgQPcJVA8ba0GDS9rooLAZvVsW5cMUwGnkzTzppo8g17K507tXmzrM7GnPv
         MSRfCdTds7WmcxQwAO7paDc2cwsD46xY2FnP0+qJSOBJ+ytkjk5hLzI0FZO6sUJob9QN
         WJiw==
X-Gm-Message-State: AOAM533IEZRidL5pz4b5hi9BYPK9jYLKBYJGjPiQjMtO++AEpmAbd2Mt
        cYwwfc6YpZgBQ4aQREtRaHg=
X-Google-Smtp-Source: ABdhPJzedWSXc2wVblTfqW1ubuyGAYLYHpih5S+Ttf21/1Ic6AE22jWzG8mAYbuXL/XoTrTT2wuj/Q==
X-Received: by 2002:a05:6402:438f:: with SMTP id o15mr232144edc.301.1634744762577;
        Wed, 20 Oct 2021 08:46:02 -0700 (PDT)
Received: from [192.168.43.77] (82-132-229-137.dab.02.net. [82.132.229.137])
        by smtp.gmail.com with ESMTPSA id g7sm1355160edu.48.2021.10.20.08.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 08:46:02 -0700 (PDT)
Message-ID: <7739475f-e07c-3708-4ebc-d22223585e2c@gmail.com>
Date:   Wed, 20 Oct 2021 16:45:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 1/1] io_uring: fix ltimeout unprep
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Beld Zhang <beldzhang@gmail.com>
References: <51b8e2bfc4bea8ee625cf2ba62b2a350cc9be031.1634719585.git.asml.silence@gmail.com>
 <163473846179.730482.6681458910857538254.b4-ty@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <163473846179.730482.6681458910857538254.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/21 15:01, Jens Axboe wrote:
> On Wed, 20 Oct 2021 09:53:02 +0100, Pavel Begunkov wrote:
>> io_unprep_linked_timeout() is broken, first it needs to return back
>> REQ_F_ARM_LTIMEOUT, so the linked timeout is enqueued and disarmed. But
>> now we refcounted it, and linked timeouts may get not executed at all,
>> leaking a request.
>>
>> Just kill the unprep optimisation.

Jens, if the patches are not too deep, would also be lovely to
add reported-by to this and the other one.


Link: https://github.com/axboe/liburing/issues/460
Reported-by: Beld Zhang <beldzhang@gmail.com>

-- 
Pavel Begunkov
