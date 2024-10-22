Return-Path: <io-uring+bounces-3900-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4CC39AA312
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 15:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B1E4B233F2
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 13:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35F619ABD5;
	Tue, 22 Oct 2024 13:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P+Zi/lML"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030933C463
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 13:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729603461; cv=none; b=oNsboKtmHjQ+JIMKi8HbPqKfaUDmzIb82f86sfTtgKiRDR3elQ11KtB2ATIpRX8R2A5Pw4Unj/o7hB6Vf5Yd3OXfaU7nLhWSEzPJ0v4uHLtdBde2BFdJVVNeAg82hZ+5QPUvUEhO6eXfaCrHlrgecDRL65bK1f+fBma5L0BKIiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729603461; c=relaxed/simple;
	bh=qNuOh44ilPZHttqWnT6NUqSTC1C8CB04Esa9IFz/cJg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=tUtkRSmfbj54MOzgiJixcY8Za0yISg5ES+9RRbpp1LMvVz+lYd/RMdsF+oa8zlXBtxtxPnyp5l2q9EQsf4D8VcEWlC2wvGc4nil2SzMD5EwK04Hp0UiNBA8BvmG+csnu5vhP8DeZnAaS7QRbcM+LEqg2O1i4gzUMOc5Aqq5SPjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P+Zi/lML; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-83ac05206e8so148082439f.3
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 06:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729603458; x=1730208258; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y/0fzr8FWMSC1yzpe4eeXXaAB7tFd1k1YojoldJk71c=;
        b=P+Zi/lMLKSPbFHjwFRflvnAH+EbG833fp9Zyfr2fwSqbK4gf9dYlFb70CkAT8lShIT
         6jVtprkJ0bUCnwlqjxyRxMR2tMSMSwXfYc6aEi35hAIqwYxT4VzhnbzdWZymvSjmPOoI
         vc6pAXTEr9xV2GTd0abUud/4lgckW5uOZ5ukQ1crFuHSqgjzirzsgVbBp2teFix8SC4/
         L+ORbqX/pxXSyNISjpDmcYhoJjnUTM7lgJrDZEL3cW0ozvALG5LWA+THcN7K3fz86LBS
         1yqncmtLHlfnw7zkchw1iDQT8jM3fPiooT9Uuybt1OcP0TdEtPZXyOI6HThtrbaFxR0G
         38hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729603458; x=1730208258;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/0fzr8FWMSC1yzpe4eeXXaAB7tFd1k1YojoldJk71c=;
        b=gEPBuvzkgJQljbL5gwCLcQRNXCMlAWOFZ9sfmnNXDpJvbbjFqADBmmOdXGlf4b+t0y
         gtt3gUgv836SYKMoBkG4vMT+t3BYMvOzP0519+fMKWDF0PoUJuwFyl7Lmcls4WKvois7
         vOr/f5NNBBI0P4NBO96UBkA/+YnDMF+CiN20e0G8Yo3y/3Q4fENxtPhnvyTSl8AVYfxq
         Hn5bL7iGr7alFcBeXZj+cGOW38DIX121UUAz3RHYWxk9aFRletAdZE0F0ZfqnzVoVJxI
         HiitgOeK4eKQrUWdFpSM1LixYsTlzIUIC94I6SNNTDc+USRJlKxNrE0ToPp6nHu9QCVf
         c4Sw==
X-Forwarded-Encrypted: i=1; AJvYcCUN7DLElEyRWDqbG0yNJM0jhQHPoAVEVeTz3r3iiQhQeuTWIeFI/9hiz+BjWkUxXmGuqHEb6yenfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFmVF8nbJI1wJtTjuJ4Vsyx23zPl6igwbaNX+EcL090yA8IhsN
	kRV5NMVtEAHIqWfAzgpvjhn3oNNfQVL6cZyOo6me5+b2qtzUco4ql3GRRDjmmvM=
X-Google-Smtp-Source: AGHT+IExg6hdEQq71sdoOQwxlzLGka4tTI3iDntQMCvP5zsmgDUXQ+YfqsyYH5/s2olhKuj7FoyIsA==
X-Received: by 2002:a92:cda4:0:b0:3a3:b4ec:b3f1 with SMTP id e9e14a558f8ab-3a3f40ab54cmr136539625ab.17.1729603457958;
        Tue, 22 Oct 2024 06:24:17 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400aa4657sm17741815ab.32.2024.10.22.06.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 06:24:17 -0700 (PDT)
Message-ID: <52becd2a-7042-4506-a42a-b50d643cdf25@kernel.dk>
Date: Tue, 22 Oct 2024 07:24:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] io_uring/uring_cmd: get rid of using req->imu
From: Jens Axboe <axboe@kernel.dk>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
References: <20241022020426.819298-1-axboe@kernel.dk>
 <20241022020426.819298-2-axboe@kernel.dk> <ZxcRQZzAmwm1XT3K@fedora>
 <f29d4778-b5f5-4f3c-a2e6-463c5432dd65@kernel.dk>
 <CGME20241022084205epcas5p190eb2ba790815a6ac211cb4e3b6a0fe4@epcas5p1.samsung.com>
 <20241022083424.wz2cmebvkrdcgw2g@green245>
 <b7741a2f-a6b6-4a92-aa6e-9eab3f018804@kernel.dk>
Content-Language: en-US
In-Reply-To: <b7741a2f-a6b6-4a92-aa6e-9eab3f018804@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/24 7:18 AM, Jens Axboe wrote:
> On 10/22/24 2:34 AM, Anuj Gupta wrote:
>>>
>>> Gah indeed, in fact it always should be, unless it's forcefully punted
>>> to io-wq. I'll sort that out, thanks. And looks like we have zero tests
>>> for uring_cmd + fixed buffers :-(
>>>
>>
>> We do have tests for uring_cmd + fixed-buffers in liburing [*].
>>
>> [*] https://github.com/axboe/liburing/blob/master/test/io_uring_passthrough.c
> 
> We seem to yes, but its not actually importing a fixed buffer...

The test is buggy, this should fix it:

diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index 345c65b1faa4..f18a1862c524 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -167,6 +167,8 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 			}
 		}
 		sqe->opcode = IORING_OP_URING_CMD;
+		if (do_fixed)
+			sqe->uring_cmd_flags |= IORING_URING_CMD_FIXED;
 		sqe->user_data = ((uint64_t)offset << 32) | i;
 		if (sqthread)
 			sqe->flags |= IOSQE_FIXED_FILE;

-- 
Jens Axboe

