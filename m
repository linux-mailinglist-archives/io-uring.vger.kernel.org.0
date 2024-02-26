Return-Path: <io-uring+bounces-731-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB428676FC
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 14:45:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E816228F95E
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 13:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F521292F6;
	Mon, 26 Feb 2024 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SbwCsTO/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59D612B152
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 13:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708954952; cv=none; b=ef5gIepTgk8DgAWrWwnhqqFnK09zvEtDPZY1Oe8BmgKr5cxTgppHWMRRoFbvZME4DM1UpRZN/hJUMR/+KwhUQ1vnwyHUjwpV0Q89h7wcC/pupdgAGkFuaf+awRJoiD2A+kNVfpcDeWURfdxR26Ykbqj7bTrfCrHhcITwqTdA3yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708954952; c=relaxed/simple;
	bh=CnCt4fo8QtIE3sdyVrMKGKw6NJSAdFNRFiUf7qVP1XM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QKEGJjJ8j8H5xyIqd+ED5n2Jbn/6+35YikbWbGpr3+dKoKrKUWtPI7lWduE9NrmhI1mssSd/HuI2jVhlsRrXmMB/75FlpDiDhejcOfXnc8DTPPmQk0DU4T9yc412SLvZH7SjJqCRKm1nyiu5oH4WUaQ2DYbOnL77RqGfrTO7+Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SbwCsTO/; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e33db9118cso936643b3a.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 05:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708954950; x=1709559750; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ah7JI+xfJ4q53FTLpignVnwH4MoUwX9zhj+x/Hbr1YY=;
        b=SbwCsTO/8mWlDCkp1gqAx50mXVYsxY/CdugaWDBLl9ZDH1Oj3iq/c/TnpruYCRJOcQ
         jFfGfNPBkLmaIqzX0nFYXpA1oS7dbuv3mGp0+Jxj9fnjlRdG+IqDohpATp4wju8unJQC
         kQzDzoeS4+Ub2lxLu81I02XXqNJNTnSFeVPFAxNdiSb7LoruAWoCzSqWmwP8VS+kA+R2
         QfPW8ESmenb4YgIzS1DhbD99rKEB3Aazta3GrD20SjFvvtFZRw3sR3L6cqEbwQKHSkx6
         LYr2Oo43CqCjcqLhiwOcu0AI4q+mBXmEBS5RzjDMCcIYmkMiEGAMj5dAHfCeSYngbyZP
         fTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708954950; x=1709559750;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ah7JI+xfJ4q53FTLpignVnwH4MoUwX9zhj+x/Hbr1YY=;
        b=Xtsndy8Mr3HjOkt1pmnJP+cw7GH2PN3jSHau2Wm86fLwMW0Nx4kWE+Hq0aEwGWHFdD
         1vBMdb3fBmSSexlbftmxAAR0r+3x0ByfgKCEftgRcg2IRwhW/CqqAbdwh7F+FCzZ44Jt
         Ky5Jn/wPUWP55FuPCwojrDIP+FHrqogvnXOVYmWMrdzkH1ldc0rPe12yCRSFUxbtBCte
         KkKi82gkN45WuF/SaMHP1o0H8iVmusxFB/U6+rs+JhhycuQ2iBLkaOkAAawYwUXzHOP/
         lCXHLeJLrYlKrRxmUiVk3wD91O3sJC3mtPFbQ9ETSNkC9mWbioGQLxGDCmBvKlTFcKiB
         c6tw==
X-Gm-Message-State: AOJu0YwcqVJ/HuXIb+gNUgAeCd/PYc/EJAT8ajSnrsBZ4uJXaLMlRtH6
	1/oXvMS6ftalywHL1dcoNJ0vS2Mb08wLgHM0c3U+Q3w1KglGavduO73swoHlw7sKfC6hM8ZdcgW
	/
X-Google-Smtp-Source: AGHT+IGyK9OAOIUGMBnFfDde1dCd2hLDnkTP1pf/bYWMGExvoPCsOH+RCopgRlYzsP+i3qbDdcvHuw==
X-Received: by 2002:a05:6a00:1824:b0:6e4:f307:f561 with SMTP id y36-20020a056a00182400b006e4f307f561mr8882888pfa.1.1708954950126;
        Mon, 26 Feb 2024 05:42:30 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id ey11-20020a056a0038cb00b006e144ec8eafsm4087284pfb.119.2024.02.26.05.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 05:42:29 -0800 (PST)
Message-ID: <d6d4052c-8461-44c9-a207-ebcf8cff52ab@kernel.dk>
Date: Mon, 26 Feb 2024 06:42:28 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] io_uring/net: set MSG_MORE if we're doing multishot
 send and have more
Content-Language: en-US
To: Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20240225003941.129030-1-axboe@kernel.dk>
 <20240225003941.129030-9-axboe@kernel.dk>
 <CAO_Yeohfx1d1Hdopu=0-b3-dKVM1By=unnhHFQHsqCwH=HJSvA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAO_Yeohfx1d1Hdopu=0-b3-dKVM1By=unnhHFQHsqCwH=HJSvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 3:59 AM, Dylan Yudaken wrote:
> On Sun, Feb 25, 2024 at 12:46?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> If we have more data pending, we know we're going to do one more loop.
>> If that's the case, then set MSG_MORE to inform the networking stack
>> that there's more data coming shortly for this socket.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/net.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 240b8eff1a78..07307dd5a077 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -519,6 +519,10 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>>         if (!io_check_multishot(req, issue_flags))
>>                 return io_setup_async_msg(req, kmsg, issue_flags);
>>
>> +       flags = sr->msg_flags;
>> +       if (issue_flags & IO_URING_F_NONBLOCK)
>> +               flags |= MSG_DONTWAIT;
>> +
>>  retry_multishot:
>>         if (io_do_buffer_select(req)) {
>>                 void __user *buf;
>> @@ -528,12 +532,12 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>>                 if (!buf)
>>                         return -ENOBUFS;
>>
>> +               if ((req->flags & (REQ_F_BL_EMPTY|REQ_F_APOLL_MULTISHOT)) ==
>> +                                  REQ_F_APOLL_MULTISHOT)
>> +                       flags |= MSG_MORE;
>>                 iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_SOURCE, buf, len);
>>         }
> 
> This feels racy. I don't have an exact sequence in mind, but I believe
> there are cases where between
> the two calls to __sys_sendmsg_sock, another submission could be
> issued and drain the buffer list.
> I guess the result would be that the packet is never sent out, but I
> have not followed the codepaths of MSG_MORE.

This is true, but that race always exists depending on how gets to go
first (the adding of the buffer, or the send itself). The way I see it,
when the send is issued we're making the guarantee that we're going to
at least deplete the queue as it looks when entered. If more is added
while it's being processed, we _may_ see it.

Outside of that, we don't want it to potentially run in perpetuity. It
may actually be a good idea to make the rule of "just issue what was
there when first seen/issued" a hard one, though I don't think it's
really worth doing. But making any guarantees on buffers added in
parallel will be impossible. If you do that, then you have to deal with
figuring out what's left in the queue once you get a completion withou
CQE_F_MORE.

> The obvious other way to trigger this codepath is if the user messes
> with the ring by decrementing
> the buffer counter. I do not believe there are any nefarious outcomes
> - but just to point out that
> REQ_F_BL_EMPTY is essentially user controlled.

The user may certainly shoot himself in the foot. As long as that
doesn't lead to a nefarious outcome, then that's not a concern. For this
case, the head is kernel local, user can only write to the tail. So we
could have a case of user fiddling with the tail and when we grab the
next buffer (and the previous one did not have REQ_F_BL_EMPTY set), the
ring will indeed appear to be empty. At that point you get an -ENOBUFS
without CQE_F_MORE set.

-- 
Jens Axboe


