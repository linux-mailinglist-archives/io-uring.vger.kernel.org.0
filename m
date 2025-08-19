Return-Path: <io-uring+bounces-9073-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E16B2C8F8
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 18:02:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C56281C270B7
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 16:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06BFB2877E0;
	Tue, 19 Aug 2025 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oqJZVywg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96D0272E53
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755619292; cv=none; b=pePhq29doxS69Lfal9hRuKrPoycTOCS0yTdM65RMKD+Ejqa0sN9/QCPpB48WgHqALnHxMWM4oPBHJcYeUIEmWxaRRynaSJ/eGfzp2RlHl+7m114FLOt5yz95traKGL+52vL+XtD0PE02qwb/3v3T+nQMXN4IKlLTZgiI5ZPgI9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755619292; c=relaxed/simple;
	bh=BWHO75rKb4Nd01A9R5fNgKizUEVAisnse7e8JQ4I6cs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j55u/SD/g2Br6z4qSRlb0H+17JYHDDiWDooNiT3luoDuyiHfRkysjtA/yY8C4pg3OuQlGh/aDyDfbE9vJT/uglo1YQpirF+b1ZHIDyTx2/5M1KuVcpsMCupRTKaS4TE8HdSXCe16AYi+kJ6qlvWGoxgrBLEymKeHeaqmhfymxcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oqJZVywg; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-88432e60eebso130583139f.3
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 09:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755619289; x=1756224089; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lBlnHqvDfU/S3akXHiZmVpsev6B39n06NIjEh6UUG04=;
        b=oqJZVywgetiOkEQ3Uy634IthGJQGuQrYRHgSW4Fxvle4E9Sebr8+xj7kx5OOF1QIJn
         R/N6Y7fRwoINf2ztw3lMWmD91MmlmIsRwaA42V5wUcrB7GkoTGVy84r0N0PEAiA3vjsH
         sFdNfENzAVVIFpU5S8kmhmGDI+uVCRruWfUqTpkpFfttOvUUViJuwnV+NYHnyrBfu8/f
         kBU+7/mci4BPzNrcJj2pLsfQqj087QwkFjGgjUMxw0jrhLdUEflm9zW4mB59tJjwBA+t
         7y3QUzmxFxLRb0xLcJoy1tFr8J7PDxgNiUXs79wkWW0D5ssqYVKzdlWAYv4sLtWBf93y
         Q4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755619289; x=1756224089;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lBlnHqvDfU/S3akXHiZmVpsev6B39n06NIjEh6UUG04=;
        b=XqfSw3WwpIp4PSp1KS/pqZjj3KiIT7XkYjCrqSfa8OXqYw2bemGy5S79kAVo7Vy2JY
         uqQJSG/vapHFoOGy8WsKIt0DnaYT5wnR5I3uoOJU2HySX8b/+imHUt3lt8TReEjwuCAO
         FJ00K8+5fOaHNHGjM4qcHhmbcvGUQPTnhYoWkdkQg0lEiUsz1IPbc4pq0+4gwI6XEzvH
         SunwLnNABH5lrCrut522Ppud71OjtupoEv0tlq9d8WtWMeJHOiVSZcg5H1gPrczO53G2
         CNntMPvyGeSxCgHV1AAp9Gq5RCV3cq5z2veB9KvNPnFqCkOiOuTDZUtKCcMkL/LjXZgZ
         I+Cg==
X-Forwarded-Encrypted: i=1; AJvYcCUHVI+t7YhfUvqiOPU08aV7wGGj6v1kEkZAEc8ntSz380J9K3ASWyQbEE2204XQwlWMgA/aPVFncQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YykrwTqvIdTkG4uu8fVlSMh09ZBNKbBvG3Vu7AzUzNJujyTS/Nc
	mdYZMvs8i6rEIbDeIYlepImPUfzZsMr86pfhrrsBO/3i/mLKinm30vdE6YgBsDAZ+Tw=
X-Gm-Gg: ASbGncsUv/Y0j86MGkAGzOs3GK//y1vwfMkPoMZ5Gy4Y7ctLWDlFc/DhyWrHR7xh1f+
	mhrinKw/FzMKLWwqYIikc3YAzdMIY2mELsnthcljZoQrCCFVNXktk1rfOc5GYbUZk8RXSk1s2TC
	1vGPtf2GZuXav1DMqIoRUbVQSm3KNWb5Mf7cJHenGTMyFjL/MYPDrgtLIapqGsH9fk1paAOR5s9
	mvWwNfowQ/dxGBRXPn161LgBjgynvqb/pu6g3eF1Y7/oMBUbcLW8MmswND0haOSvJQyZAtHhJ5K
	Tu+DlNNr6F3O4P4fIyyNc0srk0CvJJqQ2kAG8jjBomg0v/qyT3L2V2X/OfFRxIChJk/NrOB1+wv
	Ls/fwF4okI11JtEZpsvQ=
X-Google-Smtp-Source: AGHT+IHS09Vdho9DHVMhl+oXih++NqACHheH2PbkFLEcGXgatwSeqIIs9RzReFtwlKIVhfgc7G/lSw==
X-Received: by 2002:a05:6602:6d18:b0:86d:d6:5687 with SMTP id ca18e2360f4ac-88467ec0597mr544881839f.6.1755619237800;
        Tue, 19 Aug 2025 09:00:37 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8843f89b611sm428791839f.15.2025.08.19.09.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 09:00:36 -0700 (PDT)
Message-ID: <1155b8b0-d5d0-4634-984b-71d246932af7@kernel.dk>
Date: Tue, 19 Aug 2025 10:00:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] io_uring: uring_cmd: add multishot support
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <20250819150040.980875-1-ming.lei@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250819150040.980875-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/25 9:00 AM, Ming Lei wrote:
> @@ -251,6 +265,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>  	}
>  
>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> +		if (ret >= 0)
> +			return IOU_ISSUE_SKIP_COMPLETE;
> +		io_kbuf_recycle(req, issue_flags);
> +	}
>  	if (ret == -EAGAIN) {
>  		ioucmd->flags |= IORING_URING_CMD_REISSUE;
>  		return ret;

Final comment on this part... uring_cmd is unique in the sense that it'd
be the first potentially pollable file type that supports buffer
selection AND can return -EIOCBQUEUED. For non-pollable, the buffer
would get committed upfront. For pollable, we'd either finish and put it
within this same execution context, or we'd drop it entirely when
returning -EAGAIN.

So what happens if we get -EIOCBQUEUED with a selected buffer from
provided buffer ring, and someome malicious unregisters and frees the
buffer ring before that request completes?

-- 
Jens Axboe

