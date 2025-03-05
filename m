Return-Path: <io-uring+bounces-6971-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20271A50CE6
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 22:03:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72C351889342
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 21:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 174731547DE;
	Wed,  5 Mar 2025 21:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="odXs3DYe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AF842AAF
	for <io-uring@vger.kernel.org>; Wed,  5 Mar 2025 21:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741208605; cv=none; b=KNdysppKQrK9aeUjpMQ5RCHyrqxNNRN6hlgOKhHUyfk0faU7u8H/FIpYkv20sQs22UsObjCKrJY4F5Kfj8lfZHlnQM53cZUlvC6Gz94e4pgaUCRrBGhZi8vnL0mPIV8lioY1xdBsYHA2JEFWzbGlp7xizqLo8mmhAP9W5A0j+qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741208605; c=relaxed/simple;
	bh=cQv+lyduL43rY08xOji9UZfFXE3NnNlvr+mMnQc8fGk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=lEEkImMfb5plrI3+QzaIq+queL2BgcS5bEXenjbh2Jyl61sdX20u+yo9LTjwFdDE01kwv+MCpIfuRX8h45Fz347ZDxcEtjj46jKstDA5bXMqhHtfdzw29ZBTib5dfEqVDtuuhK29qw4sz/rYDPx/n1RRmrhRE2NFIBQkiPnynCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=odXs3DYe; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-8553e7d9459so196362739f.2
        for <io-uring@vger.kernel.org>; Wed, 05 Mar 2025 13:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741208601; x=1741813401; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XIwiIj98skyy07bH2eLQbYMiaQkekGbv6xFJBSSdfSQ=;
        b=odXs3DYe+hqPtExba26XCH+nvZrYYt/FaXGczsYgmcoLLVrGoA/kxztGJDkNR+Ing3
         Vk5p/ONcNCx0mslfs4GSp8TPp2tm2Gsk9Ct1jywPVrl0QRwYkpbocbzFIQRPZIM7OmAR
         i/m6r27W2SycN1PKjS0sKVPw6hLrK3BxNnQcrLjeAJ4aDXBckhgAGuU78AuwKDSMUghB
         fDaxE8cDNOfSfOoM7fMxzwEH+ZccJDf5WjIbRdkg21HK5F526iiBFfJBF9QAKNKGg8fr
         7sRjtBJmgd2teFRnGmEKyKtKQkOZ94pQustybqExakSG4hNNdBq30LFtrwoVB41TyO3R
         E0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741208601; x=1741813401;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XIwiIj98skyy07bH2eLQbYMiaQkekGbv6xFJBSSdfSQ=;
        b=r3ny2l39xQenx6We38xkoTEecfLoq/tl2o9ai6bqqsboIp1VwmFi7XI62FDo4ieQoS
         bfzrG42lWrok3KL8jQ5lVTIAKNzahTn7bX5bYWZFsKha8JsEOHmB7YKGtX/T7E+bSMkm
         03lMOgEXrHK3UN0PLT/N4kz1IKnVdCV9uzSBFVB+bbZ7wAMNx0Mcj6n91EwO+O2PPk7R
         d/fSRGpmuWhEUjTZRH9w9p9vYbm3L4+/64cIWoXQAEVekfB0MubGeN+56fmVffngRV3R
         ZO/tzGsDqBEYV/bCh3fOfeMzrZuj17KwAIExDMTqIu4yOc50fGjrRFBDmbkxpU8T5xxV
         MdcA==
X-Forwarded-Encrypted: i=1; AJvYcCUfOXbH9oZtDNZJJmW8OpMhxFUnTW4HtPGFYKemU8MxpsXapNz78WID4BMKIV4iO3lIylcjrtB0Xw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUdKBIFFJQ+HNWl+LPKdFHfNtUk7Xgigr+H9qtUyOMscHz1VAL
	At6502hGzeImGvsTp4VrRezP2qFbuEuqfh+ojqdE5lacDAriG9qxO4hw5MwmNx0=
X-Gm-Gg: ASbGncuqPxSB+Byx4M2rHIK7tmMEtrCWacIN2bSwpTLAWjbUBfxJhFMqyOL+g7x59eh
	9KbRqgpstfdJ/aNw6MpY07THZR5TGGOgi8iWsQTkzM/af5KYkT3nKp3GLbEbx7FA+m0vQmD5gbA
	Abmis9M3cGY8QPvRXyVT30+I+G7JRayy0vGSG7MHlAl3ZChLMe0EhpdMWrMaxZ7OjUx3VCq8G+0
	AAceBL6e6aRqd0QwJmpjk3oZ1LJQR3S50RJlvw0/ruUpXxvBhUK7wM4iqS3xCy3zPXwOEArTzs7
	SD9B15GZ8TtOdyZ0FaHplKyyHhgTbDqYIpptEzFR
X-Google-Smtp-Source: AGHT+IG/v2u21EGDnLSGquubBj9oAAhnw+TsxY8TSdXfeyiOJ+baorjX3aSDbwR9HZPEfWd9sSNDig==
X-Received: by 2002:a05:6e02:170c:b0:3d4:2306:6d0 with SMTP id e9e14a558f8ab-3d42b97ba4dmr51865365ab.14.1741208600910;
        Wed, 05 Mar 2025 13:03:20 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d3dee7101dsm37071395ab.39.2025.03.05.13.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 13:03:20 -0800 (PST)
Message-ID: <b972fe33-c671-4ec2-8123-d8d9410b8c3a@kernel.dk>
Date: Wed, 5 Mar 2025 14:03:19 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/rw: handle -EAGAIN retry at IO completion
 time
From: Jens Axboe <axboe@kernel.dk>
To: John Garry <john.g.garry@oracle.com>, io-uring@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20250109181940.552635-1-axboe@kernel.dk>
 <20250109181940.552635-3-axboe@kernel.dk>
 <2b43ccfa-644d-4a09-8f8f-39ad71810f41@oracle.com>
 <c64a86d1-36cd-46b1-82fa-4ac4a4cf9cd2@oracle.com>
 <c5e6b923-69b1-47d8-b313-ba339eac9501@kernel.dk>
Content-Language: en-US
In-Reply-To: <c5e6b923-69b1-47d8-b313-ba339eac9501@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/25 10:03 AM, Jens Axboe wrote:
> On 3/5/25 9:57 AM, John Garry wrote:
>> On 04/03/2025 18:10, John Garry wrote:
>>
>> +
>>
>>> On 09/01/2025 18:15, Jens Axboe wrote:
>>>> Rather than try and have io_read/io_write turn REQ_F_REISSUE into
>>>> -EAGAIN, catch the REQ_F_REISSUE when the request is otherwise
>>>> considered as done. This is saner as we know this isn't happening
>>>> during an actual submission, and it removes the need to randomly
>>>> check REQ_F_REISSUE after read/write submission.
>>>>
>>>> If REQ_F_REISSUE is set, __io_submit_flush_completions() will skip over
>>>> this request in terms of posting a CQE, and the regular request
>>>> cleaning will ensure that it gets reissued via io-wq.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>
>> Further info, I can easily recreate this on latest block/io_uring-6.14 on real NVMe HW:
> 
> Thanks, I'll take a look!

Can you give this a spin?


diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9edc6baebd01..e5528cebcd06 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -560,11 +560,10 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 	if (kiocb->ki_flags & IOCB_WRITE)
 		io_req_end_write(req);
 	if (unlikely(res != req->cqe.res)) {
-		if (res == -EAGAIN && io_rw_should_reissue(req)) {
+		if (res == -EAGAIN && io_rw_should_reissue(req))
 			req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
-			return;
-		}
-		req->cqe.res = res;
+		else
+			req->cqe.res = res;
 	}
 
 	/* order with io_iopoll_complete() checking ->iopoll_completed */

-- 
Jens Axboe

