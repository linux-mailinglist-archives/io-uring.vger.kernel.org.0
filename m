Return-Path: <io-uring+bounces-2224-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4A39909508
	for <lists+io-uring@lfdr.de>; Sat, 15 Jun 2024 02:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EDC128229A
	for <lists+io-uring@lfdr.de>; Sat, 15 Jun 2024 00:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA702623;
	Sat, 15 Jun 2024 00:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Dc/w2rHL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C593B1361
	for <io-uring@vger.kernel.org>; Sat, 15 Jun 2024 00:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718411258; cv=none; b=CsmGhwsYYgtw4XD/LLHvE1Nh2zaLyMJWMiO1+UQoddd5JUvAbsbfW75nuIO8U2i85MejSFC+GDaYGbm+78m/FRj/8HBXGdI9VWnV7tmf3uHb2/mlK5hIELxeg78v3koGOeaauTmxFvxa07E4cmwYfKATD5+6gk47hyAKmYcEXa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718411258; c=relaxed/simple;
	bh=slNoO3bqgkHEaz9NyBkrJhjsb0AR7lUeC2Smn2xUEnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EN9F80UIQMsnNpLoRHijYRu3l/R+MES3/aX3VOpgMmh3Jg/TSiTxOyhJ/rOLsjFH8MqZSniLahuFNhHKzYZDoOLsO9/J/Dr2YlnKCsfifu4WG9OURr2+B0hj+G1hDa9xkuKGBGXi/ImX4bq2OwPjdlC5IiSrv71zGJR/HNXgQOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Dc/w2rHL; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-254c411d816so373394fac.1
        for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 17:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718411256; x=1719016056; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OacbGWobXxCOaMTOEqE8F+FgVQF2VVAjHlZ9RIbqrF8=;
        b=Dc/w2rHLJUV38HBMb5c+JrrHLD6En/Zde9psXZdUeLXr78eXdsLHEze2pLP93p2I1y
         DSGNzgy17UBUfy+IMDdqVr1PAK0IrMG5wLCMoa0apA1uR7OgurkU3O8EiLj7Gveu2AOn
         OpQuUMIXRTqWxU2lpDgWt4WHtjznuaOLW4EvqRv9VHrrL1ne4xcO3dbJXvn0hhhrMe+9
         EQl0dOGCgH7z7J8I0kd0OT4GCy6CNqcf9zRoqN5A65Mw0N6FACTV+1uCemXowOzDMIQA
         Yvb2A59yCv3URjM3eR99Wp+WbaY/DUzu8CwnAoEHIksMEYtGubPJraYJTc9YdUbzN4CK
         uNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718411256; x=1719016056;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OacbGWobXxCOaMTOEqE8F+FgVQF2VVAjHlZ9RIbqrF8=;
        b=PpEeOLNdq5LnA6NI8gmrQw+yFlG5eHWOGTrGQoAKR58IhV95fXaRpfzSngbeugtQFD
         8KaUxrLZsVSbYeujQTDDLsP5qhoNGCgwxR1txVYVhm/kkxjAtj4rcVt9DGTRF620KbLT
         GteHC9l9cd8KMqR8CZjAaGkXjpcRxGx7UDxA7j65tOd6fj65dAv9Qg5C7kbDFcdYCZhi
         FFcRB8ytl/3xBMyoR548JtEgM8irbjNYTHt+kHreLZ/XM/whynOo0kfTwZM6cRPSAodh
         90k4jb6XHzqQ1+0LPPQlbwdPmWUGxrI/3fxwRMLPsNue46iZv4ueSyhI/81EC5P5NIL6
         /WLg==
X-Gm-Message-State: AOJu0YxcuyQOZgJdCly4L5LxWhUpEy2AyaPDxO0OFPgzbcjuPBgV21KO
	hcu4pFhIfi8yrD644QxqOBY2LH8BZr5+l8B1R8NGO/JbQ59nkwyCvWiZ75DPX5Q=
X-Google-Smtp-Source: AGHT+IFGVcv1B+CD6eFMF8v06Wz14Wuvm1nTAkxtfRpFOmrMJRnU3HKfUTN0aML1i0RXDnHeUQVpsA==
X-Received: by 2002:a05:6358:70a:b0:1a1:c9f1:f72d with SMTP id e5c5f4694b2df-1a1c9f1f74bmr85104455d.3.1718411255783;
        Fri, 14 Jun 2024 17:27:35 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6fedf0bef16sm3201570a12.43.2024.06.14.17.27.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 17:27:35 -0700 (PDT)
Message-ID: <bb0efa49-9987-4374-8764-d26668f606d1@kernel.dk>
Date: Fri, 14 Jun 2024 18:27:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] io_uring: Introduce IORING_OP_BIND
To: Kuniyuki Iwashima <kuniyu@amazon.com>, krisman@suse.de
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20240614163047.31581-3-krisman@suse.de>
 <20240614224643.21456-1-kuniyu@amazon.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240614224643.21456-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/14/24 4:46 PM, Kuniyuki Iwashima wrote:
> From: Gabriel Krisman Bertazi <krisman@suse.de>
> Date: Fri, 14 Jun 2024 12:30:46 -0400
>> IORING_OP_BIND provides the semantic of bind(2) via io_uring.  While
>> this is an essentially synchronous system call, the main point is to
>> enable a network path to execute fully with io_uring registered and
>> descriptorless files.
>>
>> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
>>
>> ---
>> changes since v1:
>> - drop explocit error handling for move_addr_to_kernel (jens)
>> - Remove empty line ahead of return;
>> ---
>>  include/uapi/linux/io_uring.h |  1 +
>>  io_uring/net.c                | 36 +++++++++++++++++++++++++++++++++++
>>  io_uring/net.h                |  3 +++
>>  io_uring/opdef.c              | 13 +++++++++++++
>>  4 files changed, 53 insertions(+)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 994bf7af0efe..4ef153d95c87 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -257,6 +257,7 @@ enum io_uring_op {
>>  	IORING_OP_FUTEX_WAITV,
>>  	IORING_OP_FIXED_FD_INSTALL,
>>  	IORING_OP_FTRUNCATE,
>> +	IORING_OP_BIND,
>>  
>>  	/* this goes last, obviously */
>>  	IORING_OP_LAST,
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 0a48596429d9..8cbc29aff15c 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -51,6 +51,11 @@ struct io_connect {
>>  	bool				seen_econnaborted;
>>  };
>>  
>> +struct io_bind {
>> +	struct file			*file;
>> +	int				addr_len;
>> +};
>> +
>>  struct io_sr_msg {
>>  	struct file			*file;
>>  	union {
>> @@ -1715,6 +1720,37 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
>>  	return IOU_OK;
>>  }
>>  
>> +int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
>> +	struct sockaddr __user *uaddr;
>> +	struct io_async_msghdr *io;
>> +
>> +	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
>> +		return -EINVAL;
>> +
>> +	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +	bind->addr_len =  READ_ONCE(sqe->addr2);
>                         ^^
> nit: double space

Thanks for spotting those, I can just remove those two while applying.
Mostly just a note to Grabriel, no need to re-post for that.

-- 
Jens Axboe


