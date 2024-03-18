Return-Path: <io-uring+bounces-1083-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CE087E234
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 03:41:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7842B216B5
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 02:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EEE217740;
	Mon, 18 Mar 2024 02:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BOEK/T56"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381D618E01
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 02:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710729666; cv=none; b=ha/BOifxs0uEaOWLCdx8fDtczn5s3dneSWLjlvHAWcexq73rm6IkKRR7qddbRqMbTmhRLwsv3G3orCGe9jDhUHfctG6Y4P31JbiU1SA662j5PNQH+mifBu5roXWIhkWMjIe2lAmbvJ2z/sGrHf3RKifUwEwPKxWyhoX0z8gI8Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710729666; c=relaxed/simple;
	bh=glx8cX95gf5WB+D3BlIjn6LPFqGSeimg0ZbL5/MrBwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JIvpizgd+i0K7I4uuekHcqJW6Ynw/a8kpZMB6BkmnflXeCUf0plAxt3cwq1anXmXgA3Q0ZELoRcILMuteEYndbWA3H9dHDBnaS+LA+KiMcHd01zZvq+2WdTlCY9vXWeuXN/PF7nJiS2ry171SthzvP2RJcn+zr0HRWmXYlSlbxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BOEK/T56; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-29d51cdde7eso1301057a91.0
        for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 19:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710729661; x=1711334461; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YxSM5U36qzjyjarH//99NCDtblwbFYC4sYtdhMkwMLw=;
        b=BOEK/T56cj8N6mkuscL5SukMz6PSb789wpQMVvR337y+iNOyj7aa4ysccXTXReBVIQ
         4SecuQ5GTxpH2BgVzM7i3QElqiifyBPphOckKHFoaQl4ASf4EyfD1Nsye03gmVjdzgxe
         yVmVp6M1BOk7YdcY00IbJSF/CMGdL6N4pXpGw54oyIbJbFtJcb50LhP1U0Uj0/cAvTIQ
         juZbdcNKm62B2xkdsA1uDEKHi8tX67KECao5KayQvbmuvwIYqJOBFkWwxHj7JZawaA9Q
         jhiCfew2ayDxoy6MdTzyweLCPan+Doj2JIz3394nHIV+VpvHVRBSL597n7wHMfY8qj4S
         61nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710729661; x=1711334461;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YxSM5U36qzjyjarH//99NCDtblwbFYC4sYtdhMkwMLw=;
        b=UMqg5ekiWx/pGD1J7ea8iEE4Ltnjyr2H3hj3D/x8ioTK+gQhQgB9JOVZW8mXWhWWgY
         zfLoIV4FdCY6URy3p5z8+v5UCrawo6+feMcLAETxo0iyOxNW4YBdYhlMcUAQ0f73HR1i
         MA8HZmsOuVAHBRpG6ZgRhtLoIuuPwUZyzvEfTR8mfQRsjfQuWKA41Bt0DnxnkpBmh9o8
         hjBiWy6H8rmsq93b9q3g15aa/SEyU7+5kG6PXXKLBCLGXZZw0E3zFpq8cAMIoDT52h+d
         2gaZa/JBFG3qZcY0hzBW/lia/urpg6CTiMFOgqZC5aBuTTg6yL373S+6LregidSS/Nti
         1QVg==
X-Gm-Message-State: AOJu0Yx3DjKjwUethbdZ8Ke7I/CgSexqxQLGhINaKpeiK3uXQAszOSIP
	4B2cntUBMR//mUquUJEQhIZvpXzBLpym5INZ+oDHjZfUVLVPuMPdVJ19IWIAkPY=
X-Google-Smtp-Source: AGHT+IG6qwAyrAEJmXe9AWW7BxscmXkhCwhfbXHUxbnUKvd96U827HIxrfujjLZe6L+UY++mDwq68Q==
X-Received: by 2002:a05:6a00:928e:b0:6e7:2e3f:846f with SMTP id jw14-20020a056a00928e00b006e72e3f846fmr640357pfb.1.1710729661404;
        Sun, 17 Mar 2024 19:41:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id ks11-20020a056a004b8b00b006e647059cccsm6805622pfb.33.2024.03.17.19.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 19:41:00 -0700 (PDT)
Message-ID: <6291a6f9-61e0-4e3f-b070-b61e8764fb63@kernel.dk>
Date: Sun, 17 Mar 2024 20:40:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/14] io_uring/cmd: fix tw <-> issue_flags conversion
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <c48a7f3919eecbee0319020fd640e6b3d2e60e5f.1710720150.git.asml.silence@gmail.com>
 <Zfelt6mbVA0moyq6@fedora> <e987d48d-09c9-4b7d-9ddc-1d90f15a1bfe@kernel.dk>
 <e2167849-8034-4649-9d35-3ab266c8d0d5@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e2167849-8034-4649-9d35-3ab266c8d0d5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/17/24 8:32 PM, Pavel Begunkov wrote:
> On 3/18/24 02:25, Jens Axboe wrote:
>> On 3/17/24 8:23 PM, Ming Lei wrote:
>>> On Mon, Mar 18, 2024 at 12:41:47AM +0000, Pavel Begunkov wrote:
>>>> !IO_URING_F_UNLOCKED does not translate to availability of the deferred
>>>> completion infra, IO_URING_F_COMPLETE_DEFER does, that what we should
>>>> pass and look for to use io_req_complete_defer() and other variants.
>>>>
>>>> Luckily, it's not a real problem as two wrongs actually made it right,
>>>> at least as far as io_uring_cmd_work() goes.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> Link: https://lore.kernel.org/r/eb08e72e837106963bc7bc7dccfd93d646cc7f36.1710514702.git.asml.silence@gmail.com
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> oops, I should've removed all the signed-offs
> 
>>>> ---
>>>>   io_uring/uring_cmd.c | 10 ++++++++--
>>>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>> index f197e8c22965..ec38a8d4836d 100644
>>>> --- a/io_uring/uring_cmd.c
>>>> +++ b/io_uring/uring_cmd.c
>>>> @@ -56,7 +56,11 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
>>>>   static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>>>>   {
>>>>       struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>>>> -    unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
>>>> +    unsigned issue_flags = IO_URING_F_UNLOCKED;
>>>> +
>>>> +    /* locked task_work executor checks the deffered list completion */
>>>> +    if (ts->locked)
>>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
>>>>         ioucmd->task_work_cb(ioucmd, issue_flags);
>>>>   }
>>>> @@ -100,7 +104,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
>>>>       if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>>>>           /* order with io_iopoll_req_issued() checking ->iopoll_complete */
>>>>           smp_store_release(&req->iopoll_completed, 1);
>>>> -    } else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
>>>> +    } else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
>>>> +        if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
>>>> +            return;
>>>>           io_req_complete_defer(req);
>>>>       } else {
>>>>           req->io_task_work.func = io_req_task_complete;
>>>
>>> 'git-bisect' shows the reported warning starts from this patch.
> 
> Thanks Ming
> 
>>
>> That does make sense, as probably:
>>
>> +    /* locked task_work executor checks the deffered list completion */
>> +    if (ts->locked)
>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
>>
>> this assumption isn't true, and that would mess with the task management
>> (which is in your oops).
> 
> I'm missing it, how it's not true?
> 
> 
> static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
> {
>     ...
>     if (ts->locked) {
>         io_submit_flush_completions(ctx);
>         ...
>     }
> }
> 
> static __cold void io_fallback_req_func(struct work_struct *work)
> {
>     ...
>     mutex_lock(&ctx->uring_lock);
>     llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
>         req->io_task_work.func(req, &ts);
>     io_submit_flush_completions(ctx);
>     mutex_unlock(&ctx->uring_lock);
>     ...
> }

I took a look too, and don't immediately see it. Those are also the two
only cases I found, and before the patches, looks fine too.

So no immediate answer there... But I can confirm that before this
patch, test passes fine. With the patch, it goes boom pretty quick.
Either directly off putting the task, or an unrelated memory crash
instead.

-- 
Jens Axboe


