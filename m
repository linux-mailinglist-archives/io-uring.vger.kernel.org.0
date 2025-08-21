Return-Path: <io-uring+bounces-9174-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27245B30048
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 18:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D78C5E6C3F
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 083962DFA4A;
	Thu, 21 Aug 2025 16:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ToPJhGYD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77061275B06
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 16:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755794253; cv=none; b=s0Wi62MkXXzmvwO5WDw5bbO4MBVeFseIY+cjPWwm9Ln4KJJB5XBJIo6EJWV9y0y6PyaHS1x61sZswxZPcQzkE9Eqorz9vNmwrRpdYQ+I4fJpw8Iz3ld8b5ZFDNRh88U4SfGK+tpi6TaI+lVdq7hp/YQy8UqgxBADKz5z0YLj+EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755794253; c=relaxed/simple;
	bh=+pR72FXTBfKW7m79+5ualUPHXkNkkBi/4qRCbT/29/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m1BeynsiraqdFNikXJAaOcSUKOJ2JBnEVIIsIVxaDsJTz4DSM3A3MgLamac3PjlVVRITyEMAOHvVOkajA4vMn2cYElO2NYXDjKFssHo3/tQXNnPDdNXmYxsK/QHlY3pXYrOEZupn1q1gbGb9l950x2majxBzHwAb7MKLOHCPZzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ToPJhGYD; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3e56fe580b4so5479865ab.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 09:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755794249; x=1756399049; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IKSpUEAhiN9iRLgaa0aB9yCL+GASCAWszoJezAikTFM=;
        b=ToPJhGYDbWFxXJboKXwMQjlRostPStpCdZfqmOT8VEXLwK5FfZHWLa/k60ryPUI/wq
         71pZ7opkjRvDXlxy8l8kb2wtH4oRFa73VEynaQJTyAkUbFQHU6JhL7+DB7hqvAgaaoam
         Z63Mzw4EJTl7jKLkhZyD6Z8OcEhHrtVzwDis6bKZYEg2UjhlsOzHt+DD1N4tTRcedEHC
         5od1kfPI+O/nuRyYbouHZC5sXisLfXB2kHXQgY+qwGFTMeE/NlB4geain7w/yHzgCF2A
         8ASwIj7ScGu2cRH7wTad+6SVeUsCLxC/CDXSWPS5hhyBGy2vXsyXT8T2Hc0MZfiUcpYh
         jV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755794249; x=1756399049;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IKSpUEAhiN9iRLgaa0aB9yCL+GASCAWszoJezAikTFM=;
        b=XbNN2ipqCNUELO27CwH79NmYBFN4HPVYjKHnkFprywrqeiv2u8AajPItx2YyoHIQA4
         VwhVUCQ3/2EG6c+Ga8XV/YLE0EIwQrLevxLs6dXH28a9sZJqBp6xSGvgyoepCUoSYuHf
         ron2nvs49byMsBuDJMoTQ74+r1YY2AH+PyAdBBV96E1Yy5Mn7RExEJGyefdXr4Su104O
         /kIh64zTl9JypQOAzj5BcLN6SJa2KYOcPHBTJKHinBueiDXOXHWgJQ1B7pm1O2Ag6Ewg
         pM1brJLRLGq5/oFqcwclG/HFqNSnVTy/EOL+SGuOAWhUYbZW92OX71iCFywp0RHbtO98
         nQJA==
X-Gm-Message-State: AOJu0YynY91P3AP00keLqwpMgsqQDm6fAt8ULnFYVsQGJjE+XkBWyi9O
	MlWDM5VrnA+yMCmuv423k9jsLV33XxKOI0NTkHX/uAR/IqgJAdwWUrGRSREQHWDwOuM=
X-Gm-Gg: ASbGncsZl+p0IysmSLLH4Ni84cIgogQPk3hRLXJhK1akqS097Q6gcul/IDLSR2uLDHQ
	yfkzVb0xaEC/x2i6iENflOSSwV8Si6IYQ+zr/l+qw6yD8lxkaBhWNE8x7bdVrxMcmS87kIm32Zy
	KWa1Hb2IQKSiJSiDLgTHi1jrKG+6nRezT9ruB7opqrxRRUJ5ctbd5feZ/nLuweMq3BydNcgLKRl
	7WbBWdzjF1pUSQUQfxrf28fBsRFd4yHLfqGTOiU0Mr0sKe1LC8ALQKLbaG8umUbHlU0Sz06qfNl
	eZRe+fz9SPCWosquvlt1wVy/qcxzRzBILG7aSPKIQOpF16szvO8U0obmpWn4h2SMaTbjcWnJS9k
	QXxac6L8rSmW+84px7LHBCzb7WGtV6w==
X-Google-Smtp-Source: AGHT+IFIzL2EY86sD4iaqnzlG3Yq1fLzktoykHvFCPoH9WMo08vc8oc0nsoplH0lxYgJ7IAQvkXMJw==
X-Received: by 2002:a05:6e02:198f:b0:3e5:4154:40fd with SMTP id e9e14a558f8ab-3e9203ea350mr541635ab.1.1755794249376;
        Thu, 21 Aug 2025 09:37:29 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e6790easm73173285ab.34.2025.08.21.09.37.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 09:37:28 -0700 (PDT)
Message-ID: <5c51412b-9031-462e-b651-eaf72bf773c4@kernel.dk>
Date: Thu, 21 Aug 2025 10:37:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 2/2] io_uring: uring_cmd: add multishot support
To: Caleb Sander Mateos <csander@purestorage.com>,
 Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
References: <20250821040210.1152145-1-ming.lei@redhat.com>
 <20250821040210.1152145-3-ming.lei@redhat.com>
 <CADUfDZruvf+RTVRdH16X0xfUO-FmgLZAx6zvwHN3s0LoCcUAQA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZruvf+RTVRdH16X0xfUO-FmgLZAx6zvwHN3s0LoCcUAQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/21/25 10:23 AM, Caleb Sander Mateos wrote:
>> @@ -333,3 +351,54 @@ bool io_uring_cmd_post_mshot_cqe32(struct io_uring_cmd *cmd,
>>                 return false;
>>         return io_req_post_cqe32(req, cqe);
>>  }
>> +
>> +/*
>> + * Work with io_uring_mshot_cmd_post_cqe() together for committing the
>> + * provided buffer upfront
>> + */
>> +struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
>> +                                           unsigned buf_group, size_t *len,
>> +                                           unsigned int issue_flags)
>> +{
>> +       struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>> +
>> +       if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
>> +               return (struct io_br_sel) { .val = -EINVAL };
> 
> Would this condition make more sense as a WARN_ON()? When would this
> be called for a non-IORING_URING_CMD_MULTISHOT io_uring_cmd?
>
>> +
>> +       if (WARN_ON_ONCE(!io_do_buffer_select(req)))
>> +               return (struct io_br_sel) { .val = -EINVAL };
>> +
>> +       return io_buffer_select(req, len, buf_group, issue_flags);
>> +}
>> +EXPORT_SYMBOL_GPL(io_uring_cmd_buffer_select);
>> +
>> +/*
>> + * Return true if this multishot uring_cmd needs to be completed, otherwise
>> + * the event CQE is posted successfully.
>> + *
>> + * This function must use `struct io_br_sel` returned from
>> + * io_uring_cmd_buffer_select() for committing the buffer in the same
>> + * uring_cmd submission context.
>> + */
>> +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
>> +                                struct io_br_sel *sel, unsigned int issue_flags)
>> +{
>> +       struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>> +       unsigned int cflags = 0;
>> +
>> +       if (!(ioucmd->flags & IORING_URING_CMD_MULTISHOT))
>> +               return true;
> 
> Same here, a WARN_ON() seems like it would make more sense.

Honestly, I think the existing WARN_ON_ONCE() needs to go rather. I
guess the point is that it's an internal misuse, eg it should not
happen. But I think just passing the error should be enough, you'd know
something is wrong anyway. The reasoning for getting rid of them is that
if these end up being somehow triggerable, then a WARN_ON() is a
potential DOS issue.

IOW, anything WARN_*() should probably just go on that side...

-- 
Jens Axboe

