Return-Path: <io-uring+bounces-9099-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 224A7B2DD73
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 15:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 480455C4F80
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 13:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75F531A05B;
	Wed, 20 Aug 2025 13:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mHPyHmcv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20FE2BEC5C
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 13:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755695519; cv=none; b=NCUs7g18h4Pf40OC9aSE6YHJbBLK23cDGuywXgnIslJJsLJ6xONeaU2u3EMGgjFc4eO3CqBagav4IihmHtKMmcZnrZG4ssYeUSAT46C+rQkDgXWQveeiMgU1/hvG148q6nNL2yPRKY19pA2qZPfIzzU21+JhoifizAg9YUXgRPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755695519; c=relaxed/simple;
	bh=I+jEAjzB57TGjDqL8pTXsSELSYWcZMLy1UOW8P9FAeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=riQXFxewacO2aQq9l9+hu0DPd8Y0JYfW3Qy7pyTTPszuKKXOk3HHsYBElziTViaEWfAUleqdTTq4iN2UV4WROz9BODncAwuXLNUmM86CUDCtJgONJoKWlrEmR4Wr0vVSjaX/yCTmBGBKIHUrCTVNuOz/I0x9DW4TvZAcwc7BrEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mHPyHmcv; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-435de820cd3so4009282b6e.3
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 06:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755695514; x=1756300314; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3xw/il1hYPcFJoO4WOdVukdiFy9qUME33435e0+SzPo=;
        b=mHPyHmcvolasUVCW0mOgTg8S+iDoHDFDEV1ysyO0DBQvrwNRpXDnZNXcOpWhiLSI67
         bItH04xRwQlqAXUE1w7xBMGurWiqRGlhOXNbU32krUGWqKWjZjnq5OUz5ArB3/HPOP9U
         pCPlRzEtzzB9RX7Xc0IGkjaxwDKBuEpb0Ma/xHoGVvdkGJR9+P87Y7ux2ifDdRvdal31
         zEEHqAQDxzsP2g03BxdlOvlX2soc2t0f4QhgRHWjPs39A1EMyT8z46nHWUXcjiNjE4QA
         VYcXiMNmB+X/TtRa3eexurSZu17poBf69F7DCYAkIioN15247GDC/Pumxwv2K27AYGp/
         pkjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755695514; x=1756300314;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3xw/il1hYPcFJoO4WOdVukdiFy9qUME33435e0+SzPo=;
        b=taJYCON52/PQHr41IRD20Ygyg0DGAh2p0/T92Nfht5jSThJzI6KJAM3K0phjtVWuyE
         NYggIqCDZQYDm9wVZIFzSW2yVvmiCgL3F08GQCXOauoZxjQuN+PPtjPpm/Xl8tSMqHJR
         aHUJJNcazoXofRU4aHTtqTI7P8zSwFOraC5cjfG76AefMUKgql+a1aTMobWNNrWPRb/r
         jwdlgLetouY1iMlO9rHS/rC0mEI/vs5+gaPumzELwSosm9SEjUw1xRqoF2m2m/Iz/d2V
         QviEy915FDiFHmMs8jMuKddDPd7SwCjJDXd2A8+OaPWnSzK6w8Cn30bBl1Dko5vzT128
         GStg==
X-Gm-Message-State: AOJu0Yzhv9vpQHZs0EaLDMt8stoAEsnBlSDma8SCS1DgKyn39Ln0N6uk
	01ihH2IM9xpq6DCts5LX0lVxg8n87O1UThbho544+qHoBVxGHHa/QCfFWQE8ieNcV+Y=
X-Gm-Gg: ASbGncsWTZ4uOzgQB1/FC02cUvE1ykyyxzVcH6PQDaGZUf5/VtHTjrG/xi1nyH4UtWx
	CZPd5iTn7/pzW5AjwxvagUWTLoU74MOgxYXfJuvqWxlpdZq9wcm606+uXVzZb2rl7qvHtzYPoJz
	N0CotlcKb/los/6FZE/WpNtRpoUOOPgEy4CWZO8d2yKCRKt2quOdZPZ2HjshkzMRH6jxc4hry43
	xJLRXdKdAhYmFULWbB5oz3r99ILI32LB4ZECoJOT8GpwOP/xNHM6sgfsiJ/3zhZ61Jtn7wwQ4Jf
	pzxeC72G+kYgqdUDLogCG9pQZB/dxA2JdHNywsQccLId6jX1T55lA5heA7nMIGQY2B/3sxjqWq9
	ddkRei1hbAWzE/wbmXsoUXtWNlH+2gK3aQV8W8VNY
X-Google-Smtp-Source: AGHT+IFN4rYOdljWDvbYLK5bSa4Asam9l4mTJgttXr5luPRCpIo6iaYqg7riuBCA7YijvE3srJlUBg==
X-Received: by 2002:a05:6808:1b06:b0:435:72d8:5e8f with SMTP id 5614622812f47-43771f2139dmr1467504b6e.0.1755695513839;
        Wed, 20 Aug 2025 06:11:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947d4976sm4231155173.36.2025.08.20.06.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 06:11:53 -0700 (PDT)
Message-ID: <8150569b-146e-4d16-86b9-5d53fa6b7e92@kernel.dk>
Date: Wed, 20 Aug 2025 07:11:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] io_uring: uring_cmd: add multishot support
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
References: <20250819150040.980875-1-ming.lei@redhat.com>
 <1155b8b0-d5d0-4634-984b-71d246932af7@kernel.dk> <aKWssZvQT-Wb-AJA@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aKWssZvQT-Wb-AJA@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/25 5:08 AM, Ming Lei wrote:
> On Tue, Aug 19, 2025 at 10:00:36AM -0600, Jens Axboe wrote:
>> On 8/19/25 9:00 AM, Ming Lei wrote:
>>> @@ -251,6 +265,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>  	}
>>>  
>>>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>>> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
>>> +		if (ret >= 0)
>>> +			return IOU_ISSUE_SKIP_COMPLETE;
>>> +		io_kbuf_recycle(req, issue_flags);
>>> +	}
>>>  	if (ret == -EAGAIN) {
>>>  		ioucmd->flags |= IORING_URING_CMD_REISSUE;
>>>  		return ret;
>>
>> Final comment on this part... uring_cmd is unique in the sense that it'd
>> be the first potentially pollable file type that supports buffer
>> selection AND can return -EIOCBQUEUED. For non-pollable, the buffer
>> would get committed upfront. For pollable, we'd either finish and put it
>> within this same execution context, or we'd drop it entirely when
>> returning -EAGAIN.
>>
>> So what happens if we get -EIOCBQUEUED with a selected buffer from
>> provided buffer ring, and someome malicious unregisters and frees the
>> buffer ring before that request completes?
> 
> Looks one real trouble for IORING_URING_CMD_MULTISHOT.
> 
> For pollable multishot, ->issue() is run in submitter tw context, and done
> in `sync` style, so ctx->uring_lock protects the buffer list, and
> unregister can't happen. That should be one reason why polled multishot
> can't be run in io-wq context.
> 
> But now -EIOCBQUEUED is returned from ->issue(), we lose ->uring_lock's
> protection for req->buf_list, one idea could be adding referenced buffer
> list for failing unregister in case of any active consumer.
> 
> Do you have suggestions for this problem?

Just commit the buffer upfront, rather than grab it at issue time and
commit when you get the completion callback? Yes that will pin the
buffer for the duration of the IO, but that should not be an issue,
nobody else can use it anyway. Avoiding the pin for pollable files with
potentially infinite IO times (eg pipe that never gets written to, or
socket that never gets data) is a key concept for those kinds of
workloads, but for finite completion times or single use cases like
yours here, that doesn't really matter.

I've got a bit of a side project making the provided buffer selection a
bit more foolproof in the sense that it makes it explicit that the scope
of it is the issue context, but across executions. One current problem
is req->buf_list, which for provided buffer rings really is local scope,
yet it's in the io_kiocb. I'll be moving that somewhere else and out of
io_kiocb. Just a side note, because it's currently easy to get this
wrong even if you know what you are doing, as per your patch.

-- 
Jens Axboe

