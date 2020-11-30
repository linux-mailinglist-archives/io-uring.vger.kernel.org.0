Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFD62C8D07
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 19:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgK3SlI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 13:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbgK3SlH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 13:41:07 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CECC0613CF
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 10:40:27 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id r2so6985247pls.3
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 10:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vAB+7ydIuelz1VMBTsuwWIm5PuF2637hVMDXFVn+D74=;
        b=iFqaMWLcxFECqRjq2bWxev0eIFZ8ykWZU26kZ0DoiMxjJEDPV8cptS9jWg8xykizt7
         IUHK94KlEj3pPFNXd4prl+sWVnMAtB3XJqqCQAiQ2/CA9Bq2mTchtChis765CMLPaXVn
         IBzy933oHT58n3JkLd8AA2PoIva8LCA9X3kbPOPvNIdZRinEqga0oD6Wo50dLHs/MWJF
         Nar+IZ0r08yQZJddICew04BBvi6ib5jczuISYiLt0g5XZJ+1DCCaBiH2fyeI1z4g/Q/X
         fiU8FE7MBzp6Fxs+U2UwGfHahVqI073b+V8L4a+lv/KFpedCOkmiM4e8HbYgi5pGuWBL
         u6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vAB+7ydIuelz1VMBTsuwWIm5PuF2637hVMDXFVn+D74=;
        b=lYcod7PiJAtM8CA3lyAqfBOz/j2JSCYNJUTObZ/+5K4LndGP2S8Jo4J0S1NaGcMqfE
         mbV/vco7lzI21KVO30zkizbjBwn/l4Q6vel+6EaXSemPv3nhrJTcCs+gkFEVKgqYCwWR
         ndEGIY3FbcZjWg31ZEsZV7ekK1sLpn7saRdOIzHavqAgJUEdDUrdgBZQqTpLGMMbaF2S
         K84UqX6rS3oJfnIXBNhZOFYreClmHiZnfIWQr0JuJGWrm52+O/UwSPlFUzySc0KAJMuG
         Oj7FAUVEMtMPVEiRV/98Y5HINeLCcdCo8+ZmoXKFRryNDSElrubwJ6jfL+oJhfUr63G5
         IZkg==
X-Gm-Message-State: AOAM530ar4V3dr/qGlDbRnUiGBcar2QER66c0jE5nHstKz8TZaXpSi2o
        MqrakAHWkk+NNA3pCbh+G4kwiz7+wjOURQ==
X-Google-Smtp-Source: ABdhPJyjedZMDfJ6Z+wrYS8ADt2TqPl/bDe5LpdSeJFJrxRcWXixJ1KUTVvrn43V1yfdglSIjUrmDw==
X-Received: by 2002:a17:90a:e018:: with SMTP id u24mr134519pjy.189.1606761626777;
        Mon, 30 Nov 2020 10:40:26 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v22sm17192276pff.48.2020.11.30.10.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 10:40:26 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: add timeout update
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1606669225.git.asml.silence@gmail.com>
 <eb04a3d3154dce299c91d12a315a2335603c508a.1606669225.git.asml.silence@gmail.com>
 <a020eb4a-41a7-cc06-1699-d6ff77e28c76@kernel.dk>
 <8d440a65-ba71-d835-9e49-653f1aa30232@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <425962df-4371-ad7b-bf0e-1966063cbfae@kernel.dk>
Date:   Mon, 30 Nov 2020 11:40:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8d440a65-ba71-d835-9e49-653f1aa30232@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/30/20 11:27 AM, Pavel Begunkov wrote:
> On 30/11/2020 18:15, Jens Axboe wrote:
>> On 11/29/20 10:12 AM, Pavel Begunkov wrote:
>>> +	tr->flags = READ_ONCE(sqe->timeout_flags);
>>> +	if (tr->flags) {
>>> +		if (!(tr->flags & IORING_TIMEOUT_UPDATE))
>>> +			return -EINVAL;
>>> +		if (tr->flags & ~(IORING_TIMEOUT_UPDATE|IORING_TIMEOUT_ABS))
>>> +			return -EINVAL;
>>
>> These flag comparisons are a bit obtuse - perhaps warrants a comment?
> 
> Ok, the one below should be more readable.
> 
> if (tr->flags & IORING_TIMEOUT_UPDATE) {
> 	if (flags & ~ALLOWED_UPDATE_FLAGS)
> 		return -EINVAL;
> 	...
> } else if (tr->flags) {
> 	/* timeout removal doesn't support flags */
> 	return -EINVAL;
> }

Yeah, that's actually readable.

>>> +		ret = __io_sq_thread_acquire_mm(req->ctx);
>>> +		if (ret)
>>> +			return ret;
>>
>> Why is this done manually?
> 
> mm is only needed in *prep(), so don't want IO_WQ_WORK_MM to put it
> into req->work since it also affects timeout remove reqs.

Don't think it's worth it, I'd just mark it needing it uncondtionally
instead. Reason being the obvious of not having stuff like this buried
deep in an op hander, but also that for non SQPOLL, we'll do these
inline always and it's a no-op. For SQPOLL we'd need to grab it, but
I'd rather pay that cost than have this in there.

>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 6bb8229de892..12a6443ea60d 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -151,6 +151,7 @@ enum {
>>>   * sqe->timeout_flags
>>>   */
>>>  #define IORING_TIMEOUT_ABS	(1U << 0)
>>> +#define IORING_TIMEOUT_UPDATE	(1U << 31)
>>
>> Why bit 31?
> 
> Left bits for other potential timeout modes, don't know which though.
> Can return it to bit 1.

Let's just use 1, there's no clear separation in there anyway.

-- 
Jens Axboe

