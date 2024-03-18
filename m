Return-Path: <io-uring+bounces-1110-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8701D87EBBC
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 16:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34FAD281034
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 15:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164D14EB4C;
	Mon, 18 Mar 2024 15:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VMbSpCbz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E02D4EB5C;
	Mon, 18 Mar 2024 15:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710774610; cv=none; b=qG3heVjQvvCSMtP/I9EXRWWVFa2DOSt5+n49k4BLiV2PaMJz0P+uALFxMzbKeCciixuH8bZDkpuH8YwcBHELZ6aVgr0J+ndMyxif2tQ2QOzOnaMYBaB6ob4oKByrE92iA8I2EqZPB7omZtP5l8Wcq2ToelpvL916ElP0NMP4O48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710774610; c=relaxed/simple;
	bh=+6S2lZKqV2fISOtLrOuVJ5MtB9a7tW4vfAO8uj5KcL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ie4wkpNCSdzFlaVXV5EKN7QYShpZgvy5AwPi8efZdATdelePbqxayP2iX0TY1FrVNe+arTnkF3R+sr4xYui8R/GdL7bGwjzZFJ6zZ6D8Y645aB3rRaHtTsmbexPdT6wwg+9F11ISJ5O1i4qcFNVzW3HzRBMeyTeLyIu99FM3+UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VMbSpCbz; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d27184197cso61037821fa.1;
        Mon, 18 Mar 2024 08:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710774606; x=1711379406; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FZWICVWL5+PR5uh9MBU9Y9r1zF3f+xy4dfIaYhbF7II=;
        b=VMbSpCbzEGyRrUMjubIUeJtGyBAuR3hp49FB8YoHKKbfJkEN47Ao+KRrWw/8NR7zTy
         jrZIRHf8FJj5UWqWxOtCTapPdgtaFD3aN9VdusxIfPZAnzFU72n+KAPsktejI7qlC2sw
         6pMERqbicJi1qPxnZNaS+OvpbSvSVWfZyIr3Hn3aVepX8fh5rcTS3H6U12e9EtrpLnZg
         PTu8ljnqp7ScEzK7eI4Uy/WSGk84Nn33wddLNFGJqeknIKzeECCrV+WGgIlOM+uYq+bx
         ghwqlDq47XyRDF+q301WEFkOWEz6JkEVqj72B5u8df+hsXC1qBpRptZ5lTjwgUsWGE4f
         OOYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710774606; x=1711379406;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FZWICVWL5+PR5uh9MBU9Y9r1zF3f+xy4dfIaYhbF7II=;
        b=MhZIO34llFqa2rbPDsGfwrA7PfgB3xGxm4+4NKvo+ih9itjFa91VexipxrRq4PYDkN
         jr5LL4GFMwvTPpC6aegpnpcCNN+NROnfRteeL+pWianlp5PO6YRY2mcYMGrmBdCXynY2
         2fNf9iv4nipOzL6bjnKJxCNNIRdK1S1OxXj5ROcwsl7dw3bSnik4lB2DbbpZ83SJVa5N
         jcEdtyY/0CszDokU94qrI4gJfnyM53qIRNuoXzNaTs6kOALZ6F9PQlA8U7obz57qjCp6
         +GL7UBteCfuzQNSL1FWpRwSY/30YhsrUlre1joQbOZiPKk8eXcd5VP5RDY6a285lVrHH
         gYcg==
X-Forwarded-Encrypted: i=1; AJvYcCUfDSAio76vzdTb8bqo3Anhd5fkSaNzlfqXB4MVYH6YZdkR9s9jgnXMV6+I3RPatsvtjpuO31IPgPkdgnmd8HZMkftBhv0kks34xVQ=
X-Gm-Message-State: AOJu0YwfF4eOFXfksySF+dGsJY86hXs2DCogfEOAzFFhowfBn58fpLDC
	2/f9WjXk0JwXN5rdsfchWLmZyjsdMjc9mIaUsxGocMlWROu17S+3
X-Google-Smtp-Source: AGHT+IGRcKb00cRrjwWX9CFvrk/wJarn730nW72HT3wJnkHSDaY3v7svbIQLt+2UzmZJd/UD9NN6iQ==
X-Received: by 2002:a2e:b81a:0:b0:2d2:cb43:bc86 with SMTP id u26-20020a2eb81a000000b002d2cb43bc86mr6776639ljo.45.1710774605947;
        Mon, 18 Mar 2024 08:10:05 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2181? ([2620:10d:c092:600::1:429a])
        by smtp.gmail.com with ESMTPSA id p7-20020a056402500700b0056882aa15b9sm4692068eda.95.2024.03.18.08.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 08:10:05 -0700 (PDT)
Message-ID: <5025d814-fad3-41da-a5ea-d5bf58c0d292@gmail.com>
Date: Mon, 18 Mar 2024 15:08:19 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/14] ublk: don't hard code IO_URING_F_UNLOCKED
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <a3928d3de14d2569efc2edd7fb654a4795ae7f86.1710720150.git.asml.silence@gmail.com>
 <Zff4ShMEcL1WKZ1Q@fedora> <61b29658-e6a9-449f-a850-1881af1ecbee@gmail.com>
 <ZfhRDL/3z98bo91y@fedora>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZfhRDL/3z98bo91y@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/24 14:34, Ming Lei wrote:
> On Mon, Mar 18, 2024 at 12:52:33PM +0000, Pavel Begunkov wrote:
>> On 3/18/24 08:16, Ming Lei wrote:
>>> On Mon, Mar 18, 2024 at 12:41:50AM +0000, Pavel Begunkov wrote:
>>>> uring_cmd implementations should not try to guess issue_flags, just use
>>>> a newly added io_uring_cmd_complete(). We're loosing an optimisation in
>>>> the cancellation path in ublk_uring_cmd_cancel_fn(), but the assumption
>>>> is that we don't care that much about it.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> Link: https://lore.kernel.org/r/2f7bc9fbc98b11412d10b8fd88e58e35614e3147.1710514702.git.asml.silence@gmail.com
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>    drivers/block/ublk_drv.c | 18 ++++++++----------
>>>>    1 file changed, 8 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
>>>> index bea3d5cf8a83..97dceecadab2 100644
>>>> --- a/drivers/block/ublk_drv.c
>>>> +++ b/drivers/block/ublk_drv.c
>>>> @@ -1417,8 +1417,7 @@ static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq)
>>>>    	return true;
>>>>    }
>>>> -static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
>>>> -		unsigned int issue_flags)
>>>> +static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io)
>>>>    {
>>>>    	bool done;
>>>> @@ -1432,15 +1431,14 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
>>>>    	spin_unlock(&ubq->cancel_lock);
>>>>    	if (!done)
>>>> -		io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
>>>> +		io_uring_cmd_complete(io->cmd, UBLK_IO_RES_ABORT, 0);
>>>>    }
>>>>    /*
>>>>     * The ublk char device won't be closed when calling cancel fn, so both
>>>>     * ublk device and queue are guaranteed to be live
>>>>     */
>>>> -static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
>>>> -		unsigned int issue_flags)
>>>> +static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd)
>>>>    {
>>>>    	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
>>>>    	struct ublk_queue *ubq = pdu->ubq;
>>>> @@ -1464,7 +1462,7 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
>>>>    	io = &ubq->ios[pdu->tag];
>>>>    	WARN_ON_ONCE(io->cmd != cmd);
>>>> -	ublk_cancel_cmd(ubq, io, issue_flags);
>>>> +	ublk_cancel_cmd(ubq, io);
>>>
>>> .cancel_fn is always called with .uring_lock held, so this 'issue_flags' can't
>>> be removed, otherwise double task run is caused because .cancel_fn
>>> can be called multiple times if the request stays in ctx->cancelable_uring_cmd.
>>
>> I see, that's exactly why I was asking whether it can be deferred
>> to tw. Let me see if I can get by without that patch, but honestly
>> it's a horrible abuse of the ring state. Any ideas how that can be
>> cleaned up?
> 
> Simply deferring io_uring_cmd_done() in ublk_cancel_cmd() to tw still triggers
> warning in  __put_task_struct(), so I'd suggest to add the patch until
> it is root-cause & fixed.

I mean drop the patch[es] changing how ublk passes issue_flags
around, moving cancellation point and all related, and leave it
to later really hoping we'll figure how to do it better.

-- 
Pavel Begunkov

