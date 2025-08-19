Return-Path: <io-uring+bounces-9066-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60865B2C75F
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 16:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89D5E1BC62E1
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 14:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8C12AE66;
	Tue, 19 Aug 2025 14:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FKoByIIg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0BE279DAD
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 14:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755614643; cv=none; b=ZYMZkWFWExAhorchlq4WqvPc3vjAWpn44/LAgXxSwMOmGe6b40dHpB8JaI/dJ9ChnSdCp3Wx56XSE0JrVH4pRYvh6lGDXQGp0T2uXLE2NhzFMVmQPUqw0qF2K2Z++AraBEZBpdrJMoDWhcipAtdkBlW4kBPaXbsUCnI1PmQaZWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755614643; c=relaxed/simple;
	bh=Y/IWvrQWJA4v/iTdiazNBY9qwT1kxSJ/xW4FiQxACVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bWVBAmq8tHdAkrzhrocB6kLhkYEFRpcQLhlhHfMr1xTbWX9bMNcX8v4r22ti59eJ692j4EUFTqR+1VT5PDbFt8zlepnzbn1B0BngHiULILnjeC3uqLhrt6u8ZUD3s01z0pIZ1YVlKL8A0q30U/TAC0SG2thL8Iv4nBR4r7MR38g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FKoByIIg; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3e57002bc23so27251085ab.3
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 07:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755614639; x=1756219439; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G/tTUZJcHeIMZJ6EhkI/Q1eGxtR8aUTpatZeMcHNJu8=;
        b=FKoByIIgozA8pLdJCuvO2Gdnrhh5ctuwlCkdgPEupGz66fkttstZzSn43XoK6U5YuN
         wDTHHgB7LQI9P6CpnybeD0+twQl18zKXee3wg7l+OOR+COlsNcy0eZhzioQ5lWzdxMU1
         eCf4UISDQm1e0rKq7gFm/OXGhX3Mmh7Oz/YhbD8vHJ5TtqPTnPDZYNRI9g5e88/2az44
         IJ9VgiVEvRWL/IBuM7tEMkQ+dLXIPJR0GqXReTIouG+66EplHzHAlHwo+C7JK1oKoyMs
         GIsf8LV/57slDK9J3YIu22WrxZXd0jG60jic/+Sr5pDPFUaUOYt8un0eFD/4XJopftPk
         XoJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755614639; x=1756219439;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G/tTUZJcHeIMZJ6EhkI/Q1eGxtR8aUTpatZeMcHNJu8=;
        b=bPPIfepYimLkUR3CvRaY7GuOGkxnUGHmO2aRdDn/vEo+zslBtPSL9bPGKvtW0qZqfF
         CcjiCAgD7NXV+z7hHl3p7MFd39gATL5pGmUV90pvM6fianyrF7xFQ7s/SokqnobM7/z6
         uc7ROjHHmS2sESViZ8/1lj9qWc4HBIXpldG4zUTj6uLRSPwmZT43y8FYjoEz0wzR0fU9
         JbENIVCuqb+gX6zfMLgVCMplfpEnlouSUpUuunUSsW8bSNwusnUFN+gvmsM5QZLptswN
         MJoiXw39KWGc0AE0ZFO7ikLbsho5h+ikMJ9vKAFpUxD3ESJwXRE/JxhssfhCd2btmWHG
         CPRQ==
X-Gm-Message-State: AOJu0YzMAkQP4b4wtagE9M69Llmx8ifSFwt7MN64jvLIh+THE4m4Nfq/
	XAmTlmpQrp7/bZfnMX10j4xuYk2Vpwbf0YgI3Qs3VFxTvKZQhEjwe8KIFZAXGPFe6cNYa1TdfQN
	Gq1M6
X-Gm-Gg: ASbGncvZkMMIIg9HoE+VMclbNuTG69AGBmq+NaX5ecreqr6kHyKbDAh18yyJXMieZO+
	tq1GM4ltAJ5JRQvn1/Fbm/dKqIBwxuG3EYMDorgAsxaofRdKG3gp4rk63qsiC8cl+hIMlSD1y9C
	JI5yOczIEmC9VFZCdlvxu8dQkJaZO75lmD3shxveOrZDcaRainyHiQjizkJ3nD1AyzeEtu86kcj
	x2yzwdCHlaap0MwvhKW0pZpS+VlCLI8qImMmi3hLHbRxM7RHyQaIxNhn37LcXCvSPGbI6+0KijG
	bX4wY7TLihUHNRdc3uOP3fxNSlTOjNE8EZBqQ4/nwR+cWxOcwHPoFICmT9uyZ9RfI/vzSRvg+5c
	bYR4w8LtnGur13cvZaXv7gRLaiqlioA==
X-Google-Smtp-Source: AGHT+IH2FtSB4mvYtsfVJOcSTVVsYrxKacmsoDYUe20NUlgsX1YjdCktRxIsAcxWyqTCBIP66W4gQA==
X-Received: by 2002:a05:6e02:1748:b0:3e5:469e:b105 with SMTP id e9e14a558f8ab-3e676639ceamr50831665ab.18.1755614639183;
        Tue, 19 Aug 2025 07:43:59 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c94998c07sm3489939173.49.2025.08.19.07.43.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 07:43:58 -0700 (PDT)
Message-ID: <06bd405d-c5dd-4f20-af90-775278686f5c@kernel.dk>
Date: Tue, 19 Aug 2025 08:43:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: uring_cmd: add multishot support without poll
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
References: <20250810025024.1659190-1-ming.lei@redhat.com>
 <393638fa-566a-4210-9f7e-79061de43bb4@kernel.dk> <aKRd05_pzVwhPfxI@fedora>
 <91bc3fdf-880d-4b71-94b3-ac72ca0f3640@kernel.dk> <aKSJ8yg7GRh6UzTr@fedora>
 <628449dc-45e7-4cdf-ad65-7c97e6b2bb6b@kernel.dk> <aKSM6uz72puzoqlO@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aKSM6uz72puzoqlO@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/25 8:40 AM, Ming Lei wrote:
> On Tue, Aug 19, 2025 at 08:31:32AM -0600, Jens Axboe wrote:
>> On 8/19/25 8:28 AM, Ming Lei wrote:
>>> On Tue, Aug 19, 2025 at 08:01:18AM -0600, Jens Axboe wrote:
>>>> On 8/19/25 5:19 AM, Ming Lei wrote:
>>>>>>> @@ -251,6 +264,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>>  	}
>>>>>>>  
>>>>>>>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>>>>>>> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
>>>>>>> +		if (ret >= 0)
>>>>>>> +			return IOU_ISSUE_SKIP_COMPLETE;
>>>>>>> +		io_kbuf_recycle(req, issue_flags);
>>>>>>> +	}
>>>>>>>  	if (ret == -EAGAIN) {
>>>>>>>  		ioucmd->flags |= IORING_URING_CMD_REISSUE;
>>>>>>>  		return ret;
>>>>>>
>>>>>> Missing recycle for -EAGAIN?
>>>>>
>>>>> io_kbuf_recycle() is done above if `ret < 0`
>>>>
>>>> Inside the multishot case. I don't see anywhere where it's forbidden to
>>>> use IOSQE_BUFFER_SELECT without having multishot set? Either that needs
>>>
>>> REQ_F_BUFFER_SELECT is supposed to be allowed for IORING_URING_CMD_MULTISHOT
>>> only, and it is checked in io_uring_cmd_prep().
>>>
>>>> to be explicit for now, or the recycling should happen generically.
>>>> Probably the former I would suspect.
>>>
>>> Yes, the former is exactly what the patch is doing.
>>
>> Is it? Because looking at v2, you check if IORING_URING_CMD_FIXED is
>> set, and you fail for that case if REQ_F_BUFFER_SELECT is set. Then you
>> have a IORING_URING_CMD_MULTISHOT where the opposite is true, which
>> obviously makes sense.
>>
>> But no checks if neither is set?
> 
> Indeed, thanks for the catch, and the REQ_F_BUFFER_SELECT check in IORING_URING_CMD_FIXED
> branch can be moved to the branch of !IORING_URING_CMD_MULTISHOT.
> 
>>
>> You could add that in io_uring_cmd_select_buffer(), eg fail if
>> IORING_URING_CMD_MULTISHOT isn't set. Which if done, then the prep side
>> checking could probably just go away.
> 
> Looks this way is good too.

Want to spin a v3 for this?

-- 
Jens Axboe

