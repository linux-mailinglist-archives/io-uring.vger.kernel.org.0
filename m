Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E04C4688B2
	for <lists+io-uring@lfdr.de>; Sun,  5 Dec 2021 01:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhLEA1S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Dec 2021 19:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhLEA1S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Dec 2021 19:27:18 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCBBC061751
        for <io-uring@vger.kernel.org>; Sat,  4 Dec 2021 16:23:51 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id j3so14128928wrp.1
        for <io-uring@vger.kernel.org>; Sat, 04 Dec 2021 16:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=3dCe8/lePouB8qtLosOwwtbctfduPMu9BcXIZ3fPDQw=;
        b=XvqFRhz0mA061/GqkQRa/ceixegjKfe1xA7PswcbQbI+hQ1YG/jf/o/50eavzwUx7U
         3jmFGTlUfGpnPOW9CqBW+sPOQSNk5lgSq70XhNvyHSP2k99zekXCFzQ3imqyrjKUrGsH
         XYrQrCWb7yBvV88HshSn1nUDHz0CUBOuTUbEYDsTeg0RNI+KkhmSgmxp+HPDUfxpzSEU
         aJPXcFknP1EI2q5KHvqfb6lqdzVt3sf46tJcDuFNd3vCNf6xTTQ/dFwOsMClAdlX0I/2
         qPxbDwc6tsBKoSzRqc/mVo6bZYQ7qPpKiD/U43yBX7oF2CgenxjCNDXBpanVrOIYpvlc
         wGig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3dCe8/lePouB8qtLosOwwtbctfduPMu9BcXIZ3fPDQw=;
        b=VASuVVQQjwHpMbE/SCBWc4GtTR2fBFSKt0f/aPYwLuN8k2jFDT00qERhbKIk2L1hNA
         dOerhMM+uzR9iV6zKIrLsucsrMz5TUvgQHnDccOu+RZJgrIdJRcZozRe55nV4yavqwO3
         uBkXAjy2ghhD1YEwDxvGK8BS+yvPt3UCB/uVaab+n0kPLVkHKfOmwgTMmKEqBG5voUNQ
         aMamGEORC5KLYuT/51How36wYPZrL19xlR3o62mp9JnfmhKPPjX0ZYYhwAy+VAuS+pBo
         rpOH3Jn02IV6SmOunOW038PGmrRRhujr8aztOuw5sEXknawVzxlSUh5QyUL3XsWk1Xti
         rzow==
X-Gm-Message-State: AOAM530ZpjXDnM4LD9gfKQVZ6mifHzSfHFNI5amz3e4QF9mpVHeVWQMT
        mdUgDuvYGYtB8ozRrt0cfz6GJqBI/bY=
X-Google-Smtp-Source: ABdhPJxHJ2DRLo8FpOkJdH+E1+cUptxtxetvE2RfHtY7GnxecFUYkPO/eKT9Pq/6vRANL9euejWqJg==
X-Received: by 2002:a5d:404d:: with SMTP id w13mr31274947wrp.293.1638663830343;
        Sat, 04 Dec 2021 16:23:50 -0800 (PST)
Received: from [192.168.8.198] ([148.252.132.146])
        by smtp.gmail.com with ESMTPSA id q8sm6807404wrx.71.2021.12.04.16.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Dec 2021 16:23:49 -0800 (PST)
Message-ID: <78e5aef2-defd-3888-1f90-2ee88128ee02@gmail.com>
Date:   Sun, 5 Dec 2021 00:23:14 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 3/4] io_uring: tweak iopoll return for REQ_F_CQE_SKIP
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1638650836.git.asml.silence@gmail.com>
 <416acc6e18b03bf41009e5ae3765737201e7c87c.1638650836.git.asml.silence@gmail.com>
 <797fbd8a-ea46-091d-0d26-0103026295f2@kernel.dk>
 <0f24615d-2e03-7754-0285-712168474653@gmail.com>
 <d6ac675f-5651-6d85-113a-31a84a11cbcc@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d6ac675f-5651-6d85-113a-31a84a11cbcc@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/4/21 23:20, Jens Axboe wrote:
> On 12/4/21 3:48 PM, Pavel Begunkov wrote:
>> On 12/4/21 22:21, Jens Axboe wrote:
>>> On 12/4/21 1:49 PM, Pavel Begunkov wrote:
>>>> Currently, IOPOLL returns the number of completed requests, but with
>>>> REQ_F_CQE_SKIP there are not the same thing anymore. That may be
>>>> confusing as non-iopoll wait cares only about CQEs, so make io_do_iopoll
>>>> return the number of posted CQEs.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>    fs/io_uring.c | 6 +++---
>>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 64add8260abb..ea7a0daa0b3b 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -2538,10 +2538,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>>>>    		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
>>>>    		if (!smp_load_acquire(&req->iopoll_completed))
>>>>    			break;
>>>> +		if (unlikely(req->flags & REQ_F_CQE_SKIP))
>>>> +			continue;
>>>>    
>>>> -		if (!(req->flags & REQ_F_CQE_SKIP))
>>>> -			__io_fill_cqe(ctx, req->user_data, req->result,
>>>> -				      io_put_kbuf(req));
>>>> +		__io_fill_cqe(ctx, req->user_data, req->result, io_put_kbuf(req));
>>>>    		nr_events++;
>>>>    	}
>>>>    
>>>
>>> Not sure I follow the logic behind this change. Places like
>>> io_iopoll_try_reap_events() just need a "did we find anything" return,
>>> which is independent on whether or not we actually posted CQEs or not.
>>> Other callers either don't care what the return value is or if it's < 0
>>> or not (which this change won't affect).
>>>
>>> I feel like I'm missing something here, or that the commit message
>>> better needs to explain why this change is done.
>>
>> I was wrong on how I described it, but it means that the problem is in
>> a different place.
>>
>> int io_do_iopoll() {
>> 	return nr_events;
>> }
>>
>> int io_iopoll_check() {
>> 	do {
>> 		nr_events += io_do_iopoll();
>> 	while (nr_events < min && ...);
>> }
>>
>> And "events" there better to be CQEs, otherwise the semantics
>> of @min + CQE_SKIP is not very clear and mismatches non-IOPOLL.
> 
> Can you do a v2 of this patch? Rest of them look good to me.

I'll send it tomorrow with clarifications added

-- 
Pavel Begunkov
