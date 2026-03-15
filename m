Return-Path: <io-uring+bounces-12683-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GC49LH3Gtmk3IgEAu9opvQ
	(envelope-from <io-uring+bounces-12683-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 15:47:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 12BEC29113B
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 15:47:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4C8BE30177BB
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 14:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EEC736A00F;
	Sun, 15 Mar 2026 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r4SN/CYX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B5C36A005
	for <io-uring@vger.kernel.org>; Sun, 15 Mar 2026 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773586021; cv=none; b=FMYtNPlENtKRjUzVTJBJPGGKLNW/gpEuCJd0myh2HhjVl/2l6x/iVCnbwY3w+eU0zAtSgy/IaZpaglo7Ca4/adquiFzhh3AYAJbEAJZCabLH8DQ9dOkIWxRAxgcp2LKFlz6xwdtoadBcvRl3183GAkmm9CtI1xHmP8TRURAqd1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773586021; c=relaxed/simple;
	bh=9Q5X27hUr+rvAUbwtjj2b03yNkAmZ+eub7+6E8Jw1Xo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hJRLCXcW/GHXpaksFtdVwde6XL+G20qa4+w7CryV8KLiwuRaGuuxW+S7iVicVHniRnHmxLVvOM9I1FkoVCH0mxEOxxmBaQUkPWwspIpd4aixvrei3dW1krhLL0YU6A0SEWRN5+XVEEBn04RTgumornSNBLf/6kKAzgf/oE0CHGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r4SN/CYX; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-67bc8bc0e22so2062315eaf.2
        for <io-uring@vger.kernel.org>; Sun, 15 Mar 2026 07:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773586019; x=1774190819; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5X9MazaJc9zkymesDa8xbVzg1Oe9lFbOSb4cGG4y+m4=;
        b=r4SN/CYXO0gVdZxRCIhW53ZLBoOiELH630DVQloukOkwTrPQO7LG6DO7G9nKVURYAX
         TT+/F4qfTATzwsip0M1zsUAPHmWsBLHGu8JrqLfTL/x4e4o9CC2emibYWlYFV/9CcXgL
         AyFCHItnlvKW4NWvbIXge1GNSGAIbCqIp4GZpi02VzP7Q2V1L/ONtCLJ3WZ2GnEfvrC7
         1yue+hlWInuX104inAoYAuA1LIREiBi1K+AEzEBUr2CsS/v7kERKR5OGEVgLpEwfk1N1
         1xaeFTQ+bqMZ9pRrgADL9X2s31pTIztTBJNvDKVnNgniGlwnFiaLQDauVAPm2IaVYvXK
         xZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773586019; x=1774190819;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5X9MazaJc9zkymesDa8xbVzg1Oe9lFbOSb4cGG4y+m4=;
        b=PnoKf0R0vf5Dd8zvW7zQoXT9Jr40pU+UlqoAt6F6E7NsoEH25LIGU5VFyumQa4dZ7R
         fRlLyxV9KMo5cljg9nxR7KyR9dx8rf/Pl2r7pJD490S8W4Lw/dCZ7ZJYyquvDbI8etNT
         nMeODVAhgja/Fyx7TEJ59jixISpoH0F1qiBLixSPF6mMS0nLaT50hVM5S8r00YeH7K1O
         KEFZKP75DATXJhhwFHxXL6Prp2o6wrZok0JSD9Vxr6+UkcXdJO8pw+RELaj7/30qQ868
         SRnSMt3ddVAILQ8pJfUHiNz3XGPsWXlC7sh2qiIi2KS3EGeyb9XNBeQa+qKYIQjaxbPy
         F+Rg==
X-Gm-Message-State: AOJu0Yy+Qi8W8+88oRrIQOg3rJkDCC7XYI052KSxTHXUBKRIK0L5RV6B
	dHXwhaZDB4DJid1/yhOLGUYFPY+qEqVpZUkg5wv9DWEcqOcr4Ve869uoCOb6KpY2HXCm5m/3f3c
	2KFvAox4=
X-Gm-Gg: ATEYQzwED5aL2efXZhj3X0cEusMDga0xTvdzAjMPYMAXPbw2Q0GBPDIINPvzLnCia73
	aD0Cn72yho8kTgkcVdyMMJjMGRY+oWlIwf2kiuF3uA1OgDKjlJNabKnkDF/+qSR3YfsDKC2krUb
	KnrZw5NdAlsHj5a+2ePQo+bTr4l6+RsdhMr2uHTP/H5x6p0+/1jF6MswKkii56lqP6jma4L4IYh
	yp7J8N5IKdTxvEGcJTvsOe/s/IqGFEkzq8jCk76cGUqM+SEQd2nUVltc3izhVIt+gLyA+4Dx2Ft
	cMP3ELLgjm+b75w4tON9bLW1952SoGnhOBOfbfysvQ9UBJYUEuLHZxPHQ8PxOIzAIZWKzY9K1fT
	2109hbocYZ3yvd+9Hfn8E3gzLsxfqjCeqIaS1pEyEllHPOFF0IyrNCID6ORt+n+dP5t/GFSJPUp
	dy6EgUG968TmVOfINuG6qHEYr6ST17wwJkmjRwXqQVTiVWZzY7oY9jtKYo+W0/SAP2O1dDiniWC
	nEzxwjUZm/VwarcPFfw
X-Received: by 2002:a05:6820:2005:b0:67b:e203:6c8d with SMTP id 006d021491bc7-67be20370c0mr5503440eaf.52.1773586018940;
        Sun, 15 Mar 2026 07:46:58 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bc914b4fcsm8307283eaf.8.2026.03.15.07.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Mar 2026 07:46:58 -0700 (PDT)
Message-ID: <af3311c8-21b0-4641-bce3-d9bc2e2367c5@kernel.dk>
Date: Sun, 15 Mar 2026 08:46:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: switch struct io_ring_ctx internal
 bitfields to flags
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20260314145920.86796-1-axboe@kernel.dk>
 <20260314145920.86796-2-axboe@kernel.dk> <87sea1wzmr.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87sea1wzmr.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12683-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 12BEC29113B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/14/26 9:16 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Bitfields cannot be set and checked atomically, and this makes it more
>> clear that these are indeed in shared storage and must be checked and
>> set in a sane fashion. This is in preparation for annotating a few of
>> the known racy, but harmless, flags checking.
>>
>> No intended functional changes in this patch.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/linux/io_uring_types.h | 32 +++++++------
>>  io_uring/eventfd.c             |  4 +-
>>  io_uring/io_uring.c            | 82 +++++++++++++++++-----------------
>>  io_uring/io_uring.h            |  9 ++--
>>  io_uring/msg_ring.c            |  2 +-
>>  io_uring/register.c            |  8 ++--
>>  io_uring/rsrc.c                |  8 ++--
>>  io_uring/tctx.c                |  2 +-
>>  io_uring/timeout.c             |  4 +-
>>  io_uring/tw.c                  |  2 +-
>>  10 files changed, 80 insertions(+), 73 deletions(-)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index dd1420bfcb73..b84576374c7b 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -268,24 +268,28 @@ struct io_alloc_cache {
>>  	unsigned int		init_clear;
>>  };
>>  
>> +enum {
>> +	IO_RING_F_DRAIN_NEXT		= BIT(0),
>> +	IO_RING_F_OP_RESTRICTED		= BIT(1),
>> +	IO_RING_F_REG_RESTRICTED	= BIT(2),
>> +	IO_RING_F_OFF_TIMEOUT_USED	= BIT(3),
>> +	IO_RING_F_DRAIN_ACTIVE		= BIT(4),
>> +	IO_RING_F_HAS_EVFD		= BIT(5),
>> +	/* all CQEs should be posted only by the submitter task */
>> +	IO_RING_F_TASK_COMPLETE		= BIT(6),
>> +	IO_RING_F_LOCKLESS_CQ		= BIT(7),
>> +	IO_RING_F_SYSCALL_IOPOLL	= BIT(8),
>> +	IO_RING_F_POLL_ACTIVATED	= BIT(9),
>> +	IO_RING_F_DRAIN_DISABLED	= BIT(10),
>> +	IO_RING_F_COMPAT		= BIT(11),
>> +	IO_RING_F_IOWQ_LIMITS_SET	= BIT(12),
>> +};
>> +
>>  struct io_ring_ctx {
>>  	/* const or read-mostly hot data */
>>  	struct {
>>  		unsigned int		flags;
>> -		unsigned int		drain_next: 1;
>> -		unsigned int		op_restricted: 1;
>> -		unsigned int		reg_restricted: 1;
>> -		unsigned int		off_timeout_used: 1;
>> -		unsigned int		drain_active: 1;
>> -		unsigned int		has_evfd: 1;
>> -		/* all CQEs should be posted only by the submitter task */
>> -		unsigned int		task_complete: 1;
>> -		unsigned int		lockless_cq: 1;
>> -		unsigned int		syscall_iopoll: 1;
>> -		unsigned int		poll_activated: 1;
>> -		unsigned int		drain_disabled: 1;
>> -		unsigned int		compat: 1;
>> -		unsigned int		iowq_limits_set : 1;
>> +		unsigned int		int_flags;
> 
> Jens,
> 
> What does the int prefix means in this context?

It's just short for 'internal'.

-- 
Jens Axboe

