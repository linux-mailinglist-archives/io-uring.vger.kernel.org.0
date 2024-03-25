Return-Path: <io-uring+bounces-1211-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD0AC88A9C7
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 17:42:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0517C1C377AD
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 16:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE58013D8AF;
	Mon, 25 Mar 2024 14:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XhqVKG4K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11071157A6E
	for <io-uring@vger.kernel.org>; Mon, 25 Mar 2024 14:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711378545; cv=none; b=beDUkVwDOTjYVDVF/9trmZJ4amNs1CO82TEoRcB26ZanBovKpH9fmGbJZSPMYm66Iwbsvaqf5hMX2mBIMyuubsXg/v23XlQZpixzqcf/wBWjZYx+SxVX3XLx6IUvVEwvAOjO+Mnf/YEl4i3EUStADdfopBS0PXq791KM0f/nWOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711378545; c=relaxed/simple;
	bh=kuOCr+GzmBuustbs/2WqMP6sPU8fgGEqKLmy0cBeU20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DsNpIZfjuWhhIB/RtrtvBIgEZTqTUoEmmIXcK75kow5sLBuiTj9CecfGmRBjGgTHIQi6IKtAacDSUWYTX6ZwgryNNyBmTji79FBGEZ9ILJj9VCcFa0FvVnnEI7Nao8mgNGhRk2Mmh9+KXMBzfXcCqRVbSKcfnElGLCG1Yx8oMLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XhqVKG4K; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-366b8b0717cso6626915ab.1
        for <io-uring@vger.kernel.org>; Mon, 25 Mar 2024 07:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711378542; x=1711983342; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YIkd7rWXShjJrE5O52rmKt1XvrbpBNDt5P03Ysl34PA=;
        b=XhqVKG4KgfiLMATM0YLdQyJbXBVh3WXDYONIlgtbzzuSdUBgIX4Sr8jHJ5gmeu2p44
         Jx7CSlybA/OCXmkwDvuwE2lMMsI4ie0I1gzCVhtyzVB99jl/cdvgiDCzgpGm2DsZF4yE
         ASBqQ99azPkzKxo7fSmr8WCyc7KSs9uUh5WRvuXX2g/ai4R2dQs10CyiX8RPG5BUJh1S
         ujkd9BvG5oVRecWhp7A0O0jJEsNHpMCo0lX/5XCrfI4MOLFf++P+yg1bOWldrQwC0Sji
         wVkCmoEuC1ddpy9cjRIF9/38Qt4nQ4oy9THu+mM1ODNMP5SsxnErepo/Jef++jShDArn
         qRXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711378542; x=1711983342;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YIkd7rWXShjJrE5O52rmKt1XvrbpBNDt5P03Ysl34PA=;
        b=SqtBMnaCBrFB99x/8v3q/6W1No2Pxv05QUnlGYrChCr+67vVenMhzqz6QCLoxVo5S5
         rZBTtgb2BXw32nLVKctlECUKfCJ7dEmTfGQc7xzJdj8LIxAQLTdRJRwkgS8GnPRlm7xi
         qQ1SAij13QSAVbQhzR+ZFskl4Vp11yz57fW+byjQLmZzsbbJ4tbsQ2fky1zV/p+s8ZPJ
         kbLnb9L8A3myHG57JDq8/SUmwPakkYXMIASqZrxLet/4F/1scs1jWmi1sL1KsG03vjTT
         alGG2R7h0tqdQLM04Xr6dBGiJmJFwBU5TTtWnFtFDv3sR9eLTCrqshOKSeZ7wEyd1wPX
         JPnw==
X-Gm-Message-State: AOJu0YzcIELVVzwP9gp0rEnipLKfJaRKoXLfbx1tQnf4yjVVNxe3vZ0/
	Y/v37P6jDvx361RXZS19T/es1gRXO1xeOZ9CWNWL0e9SZpFb+02/Zzpijfu6lnhZL2qvhYdHI7r
	s
X-Google-Smtp-Source: AGHT+IHKJ0UqSZNbGLY+9Tq4aQiafT1InS+RuxpdvFNTU/QhZX6DBU+A6Aw38Q7FWGoPalg8VUkmog==
X-Received: by 2002:a05:6e02:1d84:b0:367:841f:4ea with SMTP id h4-20020a056e021d8400b00367841f04eamr8014438ila.3.1711378541956;
        Mon, 25 Mar 2024 07:55:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u8-20020a056e02080800b00366c4a8990asm2386978ilm.27.2024.03.25.07.55.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 07:55:41 -0700 (PDT)
Message-ID: <a02da1c0-e6ca-493d-97cf-d1190a511417@kernel.dk>
Date: Mon, 25 Mar 2024 08:55:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/17] io_uring/uring_cmd: defer SQE copying until we need
 it
Content-Language: en-US
To: Anuj gupta <anuj1072538@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20240320225750.1769647-1-axboe@kernel.dk>
 <20240320225750.1769647-16-axboe@kernel.dk>
 <CACzX3AukJ8hZhmxuGWC_hqMVv52s=A3u8nFSrhhgPA6arMLacg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACzX3AukJ8hZhmxuGWC_hqMVv52s=A3u8nFSrhhgPA6arMLacg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 6:41 AM, Anuj gupta wrote:
> On Thu, Mar 21, 2024 at 4:28?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> The previous commit turned on async data for uring_cmd, and did the
>> basic conversion of setting everything up on the prep side. However, for
>> a lot of use cases, we'll get -EIOCBQUEUED on issue, which means we do
>> not need a persistent big SQE copied.
>>
>> Unless we're going async immediately, defer copying the double SQE until
>> we know we have to.
>>
>> This greatly reduces the overhead of such commands, as evidenced by
>> a perf diff from before and after this change:
>>
>>     10.60%     -8.58%  [kernel.vmlinux]  [k] io_uring_cmd_prep
>>
>> where the prep side drops from 10.60% to ~2%, which is more expected.
>> Performance also rises from ~113M IOPS to ~122M IOPS, bringing us back
>> to where it was before the async command prep.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ~# Last command done (1 command done):
>> ---
>>  io_uring/uring_cmd.c | 25 +++++++++++++++++++------
>>  1 file changed, 19 insertions(+), 6 deletions(-)
>>
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index 9bd0ba87553f..92346b5d9f5b 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -182,12 +182,18 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
>>         struct uring_cache *cache;
>>
>>         cache = io_uring_async_get(req);
>> -       if (cache) {
>> -               memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
>> -               ioucmd->sqe = req->async_data;
>> +       if (unlikely(!cache))
>> +               return -ENOMEM;
>> +
>> +       if (!(req->flags & REQ_F_FORCE_ASYNC)) {
>> +               /* defer memcpy until we need it */
>> +               ioucmd->sqe = sqe;
>>                 return 0;
>>         }
>> -       return -ENOMEM;
>> +
>> +       memcpy(req->async_data, sqe, uring_sqe_size(req->ctx));
>> +       ioucmd->sqe = req->async_data;
>> +       return 0;
>>  }
>>
>>  int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>> @@ -245,8 +251,15 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>         }
>>
>>         ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>> -       if (ret == -EAGAIN || ret == -EIOCBQUEUED)
>> -               return ret;
>> +       if (ret == -EAGAIN) {
>> +               struct uring_cache *cache = req->async_data;
>> +
>> +               if (ioucmd->sqe != (void *) cache)
>> +                       memcpy(cache, ioucmd->sqe, uring_sqe_size(req->ctx));
>> +               return -EAGAIN;
>> +       } else if (ret == -EIOCBQUEUED) {
>> +               return -EIOCBQUEUED;
>> +       }
>>
>>         if (ret < 0)
>>                 req_set_fail(req);
>> --
>> 2.43.0
>>
>>
> 
> The io_uring_cmd plumbing part of this series looks good to me.
> I tested it with io_uring nvme-passthrough on my setup with two
> optanes and there is no drop in performance as well [1].
> For this and the previous patch,
> 
> Tested-by: Anuj Gupta <anuj20.g@samsung.com>
> Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

Thanks for reviewing and testing, will add.

-- 
Jens Axboe


