Return-Path: <io-uring+bounces-3233-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66FE697CBEC
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 18:00:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B61D1C2112F
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 16:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE411A01B4;
	Thu, 19 Sep 2024 16:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MkZZ/0Wl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCA61A01B7
	for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 16:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761610; cv=none; b=Sm6cI46nN5anPnRjlokvKjltbFeutaAZRp7xkprhCXX71vjf0NNkxomI/n5KL4xeveOj2hQHeibHrFt1x8u0UYojKWXfv8woR0ZnspVcZbvtl72ZDac/d/2pnufHM5J732F0grSS6Ubeyt6dfY9r08YR8g/nZFyOQWcy7lV1gKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761610; c=relaxed/simple;
	bh=VHMviGHfB1aO5+if1km5Xu3LMcxUMvUNnwRxbY2+Cn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ATFeEy6YmmTnoz06Ce8ArbWauwHzhTU59Y+H5GTYIW5e0QOfB8nvxrku3+x+ZsVClb2qtEaEC/PhfxnA03N6QmLyLnUTbl8Aq3SuPn3lzyknGPqPkXJ63HM0VDHf99JH/iEPgHsjInmyJDyt8qbMXOC8+siZLGsGB6h7+pA6DFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MkZZ/0Wl; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c260b19f71so1269338a12.1
        for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 09:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726761604; x=1727366404; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=933Sqakbo9cqDmhMWMSfSSmJE/Sme+2CiIdjDJb0FEI=;
        b=MkZZ/0WltCKhj2QOQvDy1HdUoGK6zLxORWnUOf8MaEP32LMlx53D5DmcxOr2se0bDE
         lRw90VOEv7/wzaqsqPIMNeBxWu4xTEev4iE/uXTLWdFnayAeAisIfDndEkTYON1Xps5K
         Y57uW1O7adLyPiLctgkx8BIdb4SCdEHXJfF/KDgtsBgh7Hu8Ah8rJmnUJXZR4seiGH70
         9kX0Ss7MmOaCKm9gccdS/c6dDx3ijSlZ+w5YjHIle6C1HOzCaLTWElmbjMIcYHQzq8sK
         lpr4xEdvKz4nI/H8GvF4vzldwis/+vPq8jC72fQGJ/Gp7rzhc/C0aU+549qIYHxLgAP+
         nnxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726761604; x=1727366404;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=933Sqakbo9cqDmhMWMSfSSmJE/Sme+2CiIdjDJb0FEI=;
        b=UDTb0M8D3GrLV+yoqVe8pvO0+2Q7xu+P7Yqal8J870ZQwQqo+TjjXbAXED3IDlHJk9
         0MtI0X+1f2UrH86KDCD85zFUNZ1mNCsD6gIb3dr9Uz5/QgQldqMaeRbUo/DhhVRtmpcP
         fC/L1iCmie0Y756MECmRtMmmojRJZHFXQhdxCYdPy51u3QheIHIb2YC0gdesGJlu+ogp
         ILV36z32zBU5LOtztoBmWHBt0ReXbkdC8R5IDHqZ/zdgMPxYEn8fNKZhwcbSUqV0IU8W
         ycKlTENUtls9gY+0FBG83gJoDbceobnFC1MOUiydGpXylgHUrt722un922qiEdXKER0t
         ErtA==
X-Forwarded-Encrypted: i=1; AJvYcCV+pUQW1M1kQRH68R+0JuV4Buyii+Q/sDJwqxgZGrUvFstTc4dy4KPQHNjRcGckexK8iwZjMp5SVA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwOets3H0E7FDz8BClfwiEwZR2cY/5ghIMZKmWkyCUiHMV5Ky0h
	AdGywxH8D+aAv32IcJb4Tr8sXl07P8Qj5oY9xSqcjf21PutLrUmKcw34clYFzyLMIvt75BqzEpT
	OD+/Z4Q==
X-Google-Smtp-Source: AGHT+IGhf/WjrPUrqG/Ps0eyPB/a/IDHRTphFpYIfBMBE2WSmS/sTYcEHu6xHlOCRl09tETVzU0qsg==
X-Received: by 2002:a17:907:e651:b0:a8b:6ee7:ba29 with SMTP id a640c23a62f3a-a902962a7d2mr2316106466b.44.1726761603649;
        Thu, 19 Sep 2024 09:00:03 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a906111aa91sm737669266b.97.2024.09.19.09.00.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2024 09:00:03 -0700 (PDT)
Message-ID: <5ac3973b-fbbd-4a49-babb-6d2e3e8333f7@kernel.dk>
Date: Thu, 19 Sep 2024 10:00:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: run normal task_work AFTER local work
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <8e3894e3-2609-4233-83df-1633fba7d4dd@kernel.dk>
 <6e445fe1-9a75-4e50-aa70-514937064e64@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6e445fe1-9a75-4e50-aa70-514937064e64@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/24 4:22 AM, Pavel Begunkov wrote:
> On 9/18/24 19:03, Jens Axboe wrote:
>> io_cqring_wait() doesn't run normal task_work after the local work, and
>> it's the only location to do it in that order. Normally this doesn't
>> matter, except if:
>>
>> 1) The ring is setup with DEFER_TASKRUN
>> 2) The local work item may generate normal task_work
>>
>> For condition 2, this can happen when closing a file and it's the final
>> put of that file, for example. This can cause stalls where a task is
>> waiting to make progress, but there's nothing else that will wake it up.
> 
> TIF_NOTIFY_SIGNAL from normal task_work should prevent the task
> from sleeping until it processes task works, that should make
> the waiting loop make another iteration and get to the task work
> execution again (if it continues to sleep). I don't understand how
> the patch works, but if it's legit sounds we have a bigger problem,
> e.g. what if someone else queue up a work right after that tw
> execution block.

It's not TIF_NOTIFY_SIGNAL, for that case it would've been fine. It
would've just meant another loop around for waiting. As the likelihood
of defer task_work generating normal task_work is infinitely higher than
the other way around, I do think re-ordering makes sense regardless.

The final fput will use TIF_NOTIFY_RESUME, as it should not be something
that interrupts the task. Just needs to get done eventually when it
exits to userspace. But for this case obviously that's a bit more
problematic. We can also do something like the below which should fix it
as well, which may be a better approach. At least, as it currently
stands, TIF_NOTIFY_RESUME and TIF_NOTIFY_SIGNAL are the two signaling
mechanisms for that. Hence checking for pending task_work and ensuring
our task_work run handles both should be saner. I'd still swap the
ordering of the task_work runs, however.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 75f0087183e5..56097627eafc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2472,7 +2472,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		return 1;
 	if (unlikely(!llist_empty(&ctx->work_llist)))
 		return 1;
-	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
+	if (unlikely(task_work_pending(current)))
 		return 1;
 	if (unlikely(task_sigpending(current)))
 		return -EINTR;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9d70b2cf7b1e..2fbf0ea9c171 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -308,15 +308,17 @@ static inline int io_run_task_work(void)
 	 */
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
 		clear_notify_signal();
+
+	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
+		__set_current_state(TASK_RUNNING);
+		resume_user_mode_work(NULL);
+	}
+
 	/*
 	 * PF_IO_WORKER never returns to userspace, so check here if we have
 	 * notify work that needs processing.
 	 */
 	if (current->flags & PF_IO_WORKER) {
-		if (test_thread_flag(TIF_NOTIFY_RESUME)) {
-			__set_current_state(TASK_RUNNING);
-			resume_user_mode_work(NULL);
-		}
 		if (current->io_uring) {
 			unsigned int count = 0;
 

-- 
Jens Axboe

