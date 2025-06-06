Return-Path: <io-uring+bounces-8266-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF376AD0938
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 23:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63D27189D966
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 21:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE591F0E3E;
	Fri,  6 Jun 2025 21:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1l6Muk9R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A886A31
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 21:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749243745; cv=none; b=uKs8HKmilk/zyurEtIj/OwqROR5HbyiIBsDiU5N7jBTOFNf+OnxglHZ3qy19BAcyMB8swIH7tBmLY8+Ro9bZpQX4gEoedHI2/0V0xPiUNtQL+ZNusVsTcGOP8zLJEodeOS523W6p7kbL6fZoceuHufHKzKo46mrL7XiCarnxbNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749243745; c=relaxed/simple;
	bh=0WKFHLvkoziB8fIva/LcIRFLmJCaeeU89YczlpVBBjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tGRwVaAuxJcciOLhUYXa9fs5Xcha1SjDD94mdtM/0LXjKOOZq3BkgvIU8aB3M5pNg5u5FuYCJ+TnWyQqnCF+poPg791UMScRz6sHs4vagZFTx77hcNYuC/AKhmu0F63GlRBWP6N8m3/Ri3SFgpkZdGdBr18UF7Gz7QsfnlAvdqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1l6Muk9R; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3db6ddcef4eso21325365ab.2
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 14:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749243740; x=1749848540; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z0t+t/wnQaiM1A4bRZHHC+7lJU29H/mtn+Tv9hMPEbk=;
        b=1l6Muk9RFFNvvAEF11qKcE4ASOp4mvL6kJsgDoKI3XWglra859Es0+z/WOnSqPqJx0
         Outv1cwfWHrgkCzxhXD+Zts6FFczuM5weWyGJUF72VPPH7YmTNhEg+AydUYpxUVjxvC0
         jfcuUfeDq3ZXJMFtNORkZKoFYYLNXJAZEysmA1HPgV+Sk0oMvcp+pcDKJ43OB2b7t7YG
         tDqhxxbZLFszOBuZlVoxq5Y8X/XNA3Pmq0p02CWsaIpgfxj0G3vWBH9PCt5K+ec7noFN
         8pWDH3Fn8thst1bZHkNPqloSl5W5RBSadbcaXBH+TwApNdLtcDFDd8SPXWNpF+qjKlo/
         wuig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749243740; x=1749848540;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z0t+t/wnQaiM1A4bRZHHC+7lJU29H/mtn+Tv9hMPEbk=;
        b=UUZPieXDCz7fIk1TUes0X3lSMfmoAPmLS4ywri67mXq38XRxgBagtr8eP/UDYiPxKg
         PO2uCzL+N/PwF1v1fxvEbnEpRUZ/X9o+fGDoobypzZYUleiUhq0GG1ZDYtIhaXUg8+/I
         MyuSkVHc7XMOucft8/5nB7lNz4VUrGDC7HEk2Ghy2M3jfqlHWbRqMI6fml0x3uCMuZDH
         jPzKg6eH3cE3G0fv33KuWiC8ef+N7fW504fFSmOSydDd0E0WZesgwjQbc/PfmCPuDGV/
         iS+5gR2cO7TLt50qzlPUFbzt8c1GLtnoyylRz+EKXxqrf4xz7klMUaKzHO5F6QGiButJ
         iEDw==
X-Gm-Message-State: AOJu0Yz911KGxJKHjPybM9g3KgteMySqVPoZ+KihD1R2xn0SQS3Fts2W
	jXSskwy+thaqqLp7akQxqdTyvd2LkZ3+CJX1bZPReXVEPuo2vSvU+3FENVaGJZgFMY9mckQwQwx
	h1HLJ
X-Gm-Gg: ASbGncvhxa9KwsY31f8qfMPp2GPsTJdhoAhpgQ1WpAdmTBgxIlfxF3ovAz+UcxDDUNF
	C9DLyaflmmIXwZr/CxL22bSnXBwokvBnsgUQj/BgbdlafHeoqLaY3Jv3rp0Bl1N4QRh/58O7c0W
	128HicKg8xOqoN6/unozuCoMCkYLEVGrmKpkXwyT6JvuDRpdudTXT5JkGS4Es3u4/HN9L2wYajQ
	ncumz03wrZDGeP3rwZo2DkgRQEm/TIv9F9IoMawvOGz/lvyeiI9LNAshi/anUbegWqaEHzAVy7A
	f+3sFabZUJ65hgKdhTXnqFWSXQ92nezp9HAS40wKpcGMU/1KgwhxrQ7TX/U=
X-Google-Smtp-Source: AGHT+IHGh1izS+LQV6JpsMvsOEaseR36LtynP7UfhZjLMne9ukYAf9LnN3K06txMPcEbo5PVYWGLtQ==
X-Received: by 2002:a05:6e02:2782:b0:3dc:7563:c3d7 with SMTP id e9e14a558f8ab-3ddce423490mr57744815ab.12.1749243740245;
        Fri, 06 Jun 2025 14:02:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf244ba5sm5631955ab.38.2025.06.06.14.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 14:02:19 -0700 (PDT)
Message-ID: <bf8cbc80-9387-4b65-a918-2322c5c44e8c@kernel.dk>
Date: Fri, 6 Jun 2025 15:02:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] io_uring: add IO_URING_F_INLINE issue flag
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <20250605194728.145287-1-axboe@kernel.dk>
 <20250605194728.145287-2-axboe@kernel.dk>
 <CADUfDZpeHidaeQ482gFt8n2gPVXYY0aZKvch6Di=NbZxZm28_A@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZpeHidaeQ482gFt8n2gPVXYY0aZKvch6Di=NbZxZm28_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 11:31 AM, Caleb Sander Mateos wrote:
> On Thu, Jun 5, 2025 at 12:47?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Set when the execution of the request is done inline from the system
>> call itself. Any deferred issue will never have this flag set.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/linux/io_uring_types.h | 2 ++
>>  io_uring/io_uring.c            | 3 ++-
>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 2922635986f5..054c43c02c96 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -26,6 +26,8 @@ enum io_uring_cmd_flags {
>>         IO_URING_F_MULTISHOT            = 4,
>>         /* executed by io-wq */
>>         IO_URING_F_IOWQ                 = 8,
>> +       /* executed inline from syscall */
>> +       IO_URING_F_INLINE               = 16,
>>         /* int's last bit, sign checks are usually faster than a bit test */
>>         IO_URING_F_NONBLOCK             = INT_MIN,
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index cf759c172083..079a95e1bd82 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1962,7 +1962,8 @@ static inline void io_queue_sqe(struct io_kiocb *req)
>>  {
>>         int ret;
>>
>> -       ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
>> +       ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER|
>> +                               IO_URING_F_INLINE);
> 
> Isn't io_queue_sqe() also called from io_req_task_submit(), which is
> an io_req_tw_func_t callback? Task work runs after the SQ slots have
> already been returned to userspace, right? Before the unconditional
> memcpy() was added, we had observed requests in linked chains with
> corrupted SQEs due to the async task work issue.

It's really just a patch ordering issue, as per the other email.

> As is, it looks like IO_URING_F_INLINE is just the inverse of
> IO_URING_F_IOWQ, so it may not be necessary to add a new flag. But I
> can see how core io_uring might add additional async issue cases in
> the future.

I'd greatly prefer a separate flag, it's more robust than tying it
to some other flag.

-- 
Jens Axboe

