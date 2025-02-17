Return-Path: <io-uring+bounces-6490-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD06A38736
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 16:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E755F1883C29
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 15:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE0B148832;
	Mon, 17 Feb 2025 15:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dpWbJzSB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA67520328
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739804815; cv=none; b=Xu9RPcsTCtRhwgHVSGXbUxPVaxArQFIwqONFooLMyPdPy2FRVRv2N9eRk4UJsWCjlTCxUPiHF2Ni5gIeWTGcAxjd3bOVyyTMb6/E0sonKYtdoNVXXiwXmDtzSOfV2kbBbVvzzWxsmJ9RigY+NXaJxYExb9HrYPUOzIe0rOA2Cj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739804815; c=relaxed/simple;
	bh=0/NNnf+2VPCGSrA3XurvxssN1DtKkcSYK05oaF48dN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LYyvb3OqqVEw00RyUl2zsJiw2gXXpkmRk/JqJcOGatzisU/ao704kYzOmw/pWONVynf9emSmA3SJDp8D+QgbFoLXBku8CWXNg0mmKQzkZXqH7neEjdn5zwBmaVhfO0bh+JlM4qVWOEd0QiI0gazM3AUX581V4BU2EjtAQkXomdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dpWbJzSB; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3d285a447a7so6574305ab.0
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 07:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739804812; x=1740409612; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zxO34DGD5qqyjCfkJALCuXhVAShQnKU41Q0Yr+0A/ng=;
        b=dpWbJzSBXTZGzvqJRWo7JqsDkZ4Wab6qO4NRDESkzd8yiWwCeXqwEJJhUhKIYwQsgH
         nmgxFHHNlaGk7U0a1OqXJhFAchUh6h1p4HT3QPbJhqNxgGDdrEfMt4iCRwrDQeNf54Sg
         We92DuyEN3OIdZRubzJ0P3LATpZoMa6iXv2IO8V3bp2mEzkyMJ+5HNlgb/4wfcC+NJCB
         xL8hOjdpi13MtJjFzrEWL8+ukJuONsAwMqSWVXkCCpOeMeljpMKLlgLYa77+oei8nN2n
         ElupoCDOmWPCnVxXyZv+0+gZK6kCRAWir082i5hocV7fgnp8lmODlr14C0VelsJohSJ8
         6KQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739804812; x=1740409612;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zxO34DGD5qqyjCfkJALCuXhVAShQnKU41Q0Yr+0A/ng=;
        b=eiXdIh/eCydAxRRjiS9jNBkFpx9H8GbGj+FPi9vi0aSCvX/GpjIZDKcM7DSf0cRiSb
         qolb9gpjO01n3RXPF/vPX0jap/VlxhTAhy3XMESRL/EMU6xjyEpdD6U86z67B/2MyYWb
         yaWWKNraxkvIJMNDSyuaRsh4IH/aws1Ke4PehBI45gURUYGVfB5sU+PgsFEhG7sOeSlC
         d1wakuobFUoGMrPM4XPiVitJkCUK4FvjKKUUnilM51aV4jdQoOJ0j25OEN0vytUSerP9
         93vppvkjQyu32e6rto+TNtq/RQJZpFTZUolKQTLWdIcmVn/OaUJx8L2S30Ym4ajyIK8A
         7TNA==
X-Forwarded-Encrypted: i=1; AJvYcCXdbmwSTQ/9pjxbgLGwJpdFBVNw6l25GxDpMVPiV2JnVyo01mddcmWaYoL4Vy4EPFSEP/YFibF5lQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywcea2gzLcT7VqUd3SCELTEthlxY2ddqX96u4JI7TjQe/aSleh6
	zALsfVFjvbwRqxTn1apVrSKp9gsIHBSx+TMwKkzcRqnE74KNhP5Zdktt2/wIugM=
X-Gm-Gg: ASbGncvxOBAwjr/RzXbF8PETJ7S4KnBkHLF494S/sZO+dzndsdji5gTz31owwphqCSM
	IYUExpwgW03YxDP+OeXtulG6dttxz/mkG1dgtGWay2Lcu0pgnJv6TZjIBIBWGdkiDPz7rkKHXNJ
	DfBCDARV1oiweWOdTBe+icm+DsxyrrvYiBj0DAmSLffxewD9WG280qm2TlTdRIWSanYkF2ErlqD
	bdp6r6nVfZTWHdKbOx0zIzB2EUHhQaXGKo2yi0eOw7lsIdp25+ZlLcoiKVq1NPALpb4F3PraAW0
	Spr+eHis4tEj
X-Google-Smtp-Source: AGHT+IFtxbyMkec/18yFE45KkDVm0iQC2qClJpKY/g4Vzo1Ov75zIQZpor8l5y1e+rOoKbB24EV/3Q==
X-Received: by 2002:a05:6e02:19c8:b0:3d0:1db8:e824 with SMTP id e9e14a558f8ab-3d2807fd1e2mr80641115ab.10.1739804811912;
        Mon, 17 Feb 2025 07:06:51 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ee867e2dd2sm1126685173.56.2025.02.17.07.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 07:06:51 -0800 (PST)
Message-ID: <b4c65139-b1e4-4a00-a70b-f1e1c3661d83@kernel.dk>
Date: Mon, 17 Feb 2025 08:06:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: forbid multishot async reads
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
 <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
 <b89b5ef0-9db9-44e6-9ae3-aabf39a70759@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b89b5ef0-9db9-44e6-9ae3-aabf39a70759@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/17/25 7:12 AM, Pavel Begunkov wrote:
> On 2/17/25 13:58, Jens Axboe wrote:
>> On 2/17/25 6:37 AM, Pavel Begunkov wrote:
>>> At the moment we can't sanely handle queuing an async request from a
>>> multishot context, so disable them. It shouldn't matter as pollable
>>> files / socekts don't normally do async.
>>
>> Having something pollable that can return -EIOCBQUEUED is odd, but
>> that's just a side comment.
>>
>>
>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>> index 96b42c331267..4bda46c5eb20 100644
>>> --- a/io_uring/rw.c
>>> +++ b/io_uring/rw.c
>>> @@ -878,7 +878,15 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>>>       if (unlikely(ret))
>>>           return ret;
>>>   -    ret = io_iter_do_read(rw, &io->iter);
>>> +    if (unlikely(req->opcode == IORING_OP_READ_MULTISHOT)) {
>>> +        void *cb_copy = rw->kiocb.ki_complete;
>>> +
>>> +        rw->kiocb.ki_complete = NULL;
>>> +        ret = io_iter_do_read(rw, &io->iter);
>>> +        rw->kiocb.ki_complete = cb_copy;
>>> +    } else {
>>> +        ret = io_iter_do_read(rw, &io->iter);
>>> +    }
>>
>> This looks a bit odd. Why can't io_read_mshot() just clear
>> ->ki_complete?
> 
> Forgot about that one, as for restoring it back, io_uring compares
> or calls ->ki_complete in a couple of places, this way the patch
> is more contained. It can definitely be refactored on top.

I'd be tempted to do that for the fix too, the patch as-is is a
bit of an eye sore... Hmm.

-- 
Jens Axboe


