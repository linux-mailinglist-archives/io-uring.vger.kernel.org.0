Return-Path: <io-uring+bounces-1617-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4B8F8AE8F6
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 16:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE65A1C22220
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 14:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F602136E2F;
	Tue, 23 Apr 2024 14:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JqMi1mje"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60081136E16
	for <io-uring@vger.kernel.org>; Tue, 23 Apr 2024 14:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713880829; cv=none; b=jtol5Vu6VIXHa2L599o3cRnJrY1PH/uvKLkp6uYVBPiIKnxxidaqLMYknQA2S/Yw7bXZkaZGDIA+y3G1qggs8aV4XbrSE0d9runhIWRFJ8tS85GVjwJ93vIfy0aZ1aSOMZQQBvGumqo2+sw/FqiU5Yy8tRMUgPxncwy/8dsFsIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713880829; c=relaxed/simple;
	bh=fdG0lUycG4+G0NJGzuHGQBcXFgunv41aUBJuRHuolF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u5pV5LyITbKStcDZGrOFNSfJ4ViwjCtk56wrtcIUnWwEzzctz9pFGftpe7IEBpmhm5Th1WOeJZZ+lPWgYlyOB8s0t+/5Mfjh2IwzEi1cevOuIHRrqlRYkQaIu3XRi8Guou7oyjymVzbWEJqw2iPAJ68NasJnqFU2tMwMQSn8h6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JqMi1mje; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a58872c07d8so37890166b.0
        for <io-uring@vger.kernel.org>; Tue, 23 Apr 2024 07:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713880826; x=1714485626; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vyhe52+b5Mb9L3zncfxvKgt3H9MsSKPyrO4DPzjlvhI=;
        b=JqMi1mjewuJ3eYFhA3/4J0Mh749cgIXMIDnvB+YZjuxPdKEBdSB7Zuq87RkQv/9mS7
         5mL/ZZP0JRUj+eSNUcb6mRxmTI5ctTG4boiJyziStOx2twxH6XTN/UiMpVdKaux7XjB9
         /cmxucAjSWc61DF4jLsbPeNbF+po5xRwV9I9KELEf3aZ7OUimIfzVFAhIuM9JhZnS6yQ
         9GTRohiCouyxuXGvGcw9eY+9wuQloIolO9P3tcs8UTKIpIe8wbYn3OQ8MsSWl3ymSaus
         KEw/AyiPurLyFWvIn8G+vDqRnGEMKe357Ijn9JDYi+QAyoHBviTtw8OaR9i00+ChnFAv
         Oldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713880826; x=1714485626;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vyhe52+b5Mb9L3zncfxvKgt3H9MsSKPyrO4DPzjlvhI=;
        b=GT4AnvUY0giCxezFr8UDgofkxCJFPpy1Q6GZXN/QdBrprRB/M3VfMgeBrSZ+g9oG7M
         8KBoeokEY3qt/qx2qq7rAxOONLQq4P2tEEJqNI3GWnzh6TSeeE+4UoMQXBxVneEI6A+f
         RRPRo8fTxUf6gthVZiEFJve38jYacUhshyRqZubZrkV3uQa02lfcUHewSCaiIJwYE+ZI
         ooQdbH2XyqgVSJ4Lbx3Zo+evxpRS3OuxQgMlJIVjGLMA3os8UkY95CQHeLQRrFIkSRBm
         aFqY/4cj3buBNoaMR9WCArIhBLVIYU4x3NjChvtWAuwo92H8zsBi8UENp4Nvdyu3l+dQ
         J3Gg==
X-Gm-Message-State: AOJu0YwKn8NTLmNVkN9QovexDCigZGX0a6LxRHANZSCKEENFY5yCCPvm
	QVQRRS7dBUtniQ54rwyFP73XZk+/aRZ1MfLLsn91PgQiCpnXU6nYZYIOlg==
X-Google-Smtp-Source: AGHT+IH4P+HW8Jfa1UY8DrC7HE9ogH/1EgeJllSn0xSVtpyLDsK4t8xrxRsnYNxOyGYoTjFEBDlIaQ==
X-Received: by 2002:a17:906:c248:b0:a58:7bc5:26c0 with SMTP id bl8-20020a170906c24800b00a587bc526c0mr2203059ejb.30.1713880825345;
        Tue, 23 Apr 2024 07:00:25 -0700 (PDT)
Received: from [192.168.42.88] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id jp4-20020a170906f74400b00a4734125fd2sm7106659ejb.31.2024.04.23.07.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Apr 2024 07:00:25 -0700 (PDT)
Message-ID: <be81e7b5-06b4-463e-85cf-acee80c452d4@gmail.com>
Date: Tue, 23 Apr 2024 15:00:29 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rw: ensure retry isn't lost for write
To: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, anuj1072538@gmail.com
References: <CGME20240422134215epcas5p4b5dcd1a5cd0308be5e43f691d7f92947@epcas5p4.samsung.com>
 <20240422133517.2588-1-anuj20.g@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240422133517.2588-1-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/22/24 14:35, Anuj Gupta wrote:
> In case of write, the iov_iter gets updated before retry kicks in.
> Restore the iov_iter before retrying. It can be reproduced by issuing
> a write greater than device limit.
> 
> Fixes: df604d2ad480 (io_uring/rw: ensure retry condition isn't lost)
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>   io_uring/rw.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 4fed829fe97c..9fadb29ec34f 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -1035,8 +1035,10 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>   	else
>   		ret2 = -EINVAL;
>   
> -	if (req->flags & REQ_F_REISSUE)
> +	if (req->flags & REQ_F_REISSUE) {
> +		iov_iter_restore(&io->iter, &io->iter_state);
>   		return IOU_ISSUE_SKIP_COMPLETE;

That's races with resubmission of the request, if it can happen from
io-wq that'd corrupt the iter. Nor I believe that the fix that this
patch fixes is correct, see

https://lore.kernel.org/linux-block/Zh505790%2FoufXqMn@fedora/T/#mb24d3dca84eb2d83878ea218cb0efaae34c9f026

Jens, I'd suggest to revert "io_uring/rw: ensure retry condition
isn't lost". I don't think we can sanely reissue from the callback
unless there are better ownership rules over kiocb and iter, e.g.
never touch the iter after calling the kiocb's callback.

> +	}
>   
>   	/*
>   	 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just

-- 
Pavel Begunkov

