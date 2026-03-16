Return-Path: <io-uring+bounces-12703-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBqTFSt4uGn5dgEAu9opvQ
	(envelope-from <io-uring+bounces-12703-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 22:37:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A783E2A10AE
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 22:37:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2C83930B55FB
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 21:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ACD0218E91;
	Mon, 16 Mar 2026 21:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BFcD8wHk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD6D2D8379
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 21:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773696843; cv=none; b=oQHj4WbxbkQXLPbR/S73171kilE50sDln41jU/fKIY33vW1/tDsjrla0vdCJuMN/QawxY8vc1W9hw7WCKFtePrBIZ7nWRyRR4rIhINqIkUwnxnr9/h+FNdgwocJbMtHdZi0tUjGWk8sBTMwNuRtPmxnTEvastFbHM7D0vscIBkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773696843; c=relaxed/simple;
	bh=CLHYfPjIuQCUJUvdY/ndCCjutDTre6NfTaKBM7gte7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CmIaw2tLtGI1gzEzsfPAY3N7k80GDG06AuYf1ioOz9a3qe3QWzrNgRTg8r7W1K27rO3uqjgvSmIX21dNyDZTfo2QIliPwwKPbKHqqEKSiNFvU6hLRAmYc5u9EUprqVB5T/BQYEIcQO7hso6BxwZe+VaEa1PwlXkFnGoYw9Y9H/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BFcD8wHk; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-40429b1d8baso1997580fac.0
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 14:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773696840; x=1774301640; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5ZCZEjbowMdw7LENNoVPj4UZW8ESneLSR3LaPDEOukU=;
        b=BFcD8wHkGmmOhkojQWapihT/e33RoJBDzg4wOcta0xhfSz9TKbB11XBiNRTUaY5TlC
         3cOJqJB6YWQdzBZrUa2SgvHWCGAs5y9O1uDZlz+qVZGox4ddd1DLjGUNneWPZSXgD248
         z13oPiIDIk5ylJvCdgrqTAqdq5kSBsNF15JIkpZcBdOAqMgsrFjudUqcZg+rq4Ev5Jhr
         g/jHPjrjnDvS2JEkFgC7A1IK5IUNL5fBBJPgcEcxbGGOSOHjEkNF4dnHnA+kJ9Fir4tO
         4Uz9ILp4NGAkedkSyVxFL4TyYdmJ301RrJtbbApPQIMmi2uG83m5qPEf5xCKuAUukDnU
         idXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773696840; x=1774301640;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5ZCZEjbowMdw7LENNoVPj4UZW8ESneLSR3LaPDEOukU=;
        b=Nsw3GbmvMRelepGa+IVJnREWsiezv6uXvvjAqPTvEBMjyCP6IdE9dv22bAitJ8HBf/
         WkUhwvTaNMWJsZL3RYkz4dVOrUbt3owMKpvBGyTkWTKNwUqZru8RyzIsNlzNGXn9Z9qN
         vUrzysMMcmiM+3TXTtX89UT8harO11WktxvOOz9r8KaTSFViIZh8FaTTwnJpmz9ilHNN
         HL9i42EBNjU1SEbOpeCUu21IA4PGsmzkOuX0HIzd2n1Z/pNoJyntclg/hVh57zdVOt5F
         4LUz7cGASgg3UoPYPPwd8B1qErMPu6IFiieDGQWJouSqXm4+8wGWDbhK1h4vUKM6hD59
         8iEQ==
X-Gm-Message-State: AOJu0Yz95icBltE92CPnskxbfpg1onyMgnEZdesStKIyCjEM/eBcRBY4
	EaAkMGMUqXukDGz/rAWceyq14EM3816K7cWEAUgtEFog/F69FB5UiubJbIjE1nNugDc=
X-Gm-Gg: ATEYQzz07Yx1epXQmxsrNh71f/LVFq1GVnFXRsSFTyR7WQ1Qc177kin9G+rxe3wCNZo
	tGhtwprvKvQqLAs7Y+UV7zDgVBF9Ub5jKXn0i2FW35x3Qhs9xgKG0JdlT9l41wChb+2hM9qrO3/
	qHqjHmFM8yOBsHVEcIJvs6vS73VV/UHLmSeRm3kDNQDB3LJ2qJ5yBoaXsCS35ILNznJIpw3/Odt
	c6UhjAPZSIht+vshfP4uYwfPgsVF8mPlqKe04J5KsCf0rrTGQBs6R0oHoM+aRKMWkjZrK6YAni8
	rS5wz/+56v1/u1KO1vcP4i10dX+nIJTB+/saDR6ilUJHBkpGu1DbTHn2LMh8KB3nXq5QqcjAcsl
	wi3Xe/i/gAGPEdBC0KKUKxBWonrIKTtkKQGIagT6Efrabz6m4sHNbRLgAmkpDUfQAZDoeUDMKOr
	5tDuAs9AGe+Z7JPBu3kWz5TIxk/pzss0jySAW9KdYUXobZuKAF1qkQPlT0CiBFJrjV7eHVhFCDM
	x1pe7804w==
X-Received: by 2002:a05:6870:d8d2:b0:417:15a3:929a with SMTP id 586e51a60fabf-417b938c04fmr8293644fac.32.1773696840197;
        Mon, 16 Mar 2026 14:34:00 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e1f9f86sm17403100fac.2.2026.03.16.14.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 14:33:59 -0700 (PDT)
Message-ID: <2909fbc6-1714-4bff-a5c6-6d2c3e33b271@kernel.dk>
Date: Mon, 16 Mar 2026 15:33:59 -0600
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
 <af3311c8-21b0-4641-bce3-d9bc2e2367c5@kernel.dk>
 <87jyvbwm2g.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87jyvbwm2g.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12703-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: A783E2A10AE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 2:34 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 3/14/26 9:16 PM, Gabriel Krisman Bertazi wrote:
>>
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>> Bitfields cannot be set and checked atomically, and this makes it more
>>>> clear that these are indeed in shared storage and must be checked and
>>>> set in a sane fashion. This is in preparation for annotating a few of
>>>> the known racy, but harmless, flags checking.
>>>>
>>>> No intended functional changes in this patch.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>  include/linux/io_uring_types.h | 32 +++++++------
>>>>  io_uring/eventfd.c             |  4 +-
>>>>  io_uring/io_uring.c            | 82 +++++++++++++++++-----------------
>>>>  io_uring/io_uring.h            |  9 ++--
>>>>  io_uring/msg_ring.c            |  2 +-
>>>>  io_uring/register.c            |  8 ++--
>>>>  io_uring/rsrc.c                |  8 ++--
>>>>  io_uring/tctx.c                |  2 +-
>>>>  io_uring/timeout.c             |  4 +-
>>>>  io_uring/tw.c                  |  2 +-
>>>>  10 files changed, 80 insertions(+), 73 deletions(-)
>>>>
>>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>>> index dd1420bfcb73..b84576374c7b 100644
>>>> --- a/include/linux/io_uring_types.h
>>>> +++ b/include/linux/io_uring_types.h
>>>> @@ -268,24 +268,28 @@ struct io_alloc_cache {
>>>>  	unsigned int		init_clear;
>>>>  };
>>>>  
>>>> +enum {
>>>> +	IO_RING_F_DRAIN_NEXT		= BIT(0),
>>>> +	IO_RING_F_OP_RESTRICTED		= BIT(1),
>>>> +	IO_RING_F_REG_RESTRICTED	= BIT(2),
>>>> +	IO_RING_F_OFF_TIMEOUT_USED	= BIT(3),
>>>> +	IO_RING_F_DRAIN_ACTIVE		= BIT(4),
>>>> +	IO_RING_F_HAS_EVFD		= BIT(5),
>>>> +	/* all CQEs should be posted only by the submitter task */
>>>> +	IO_RING_F_TASK_COMPLETE		= BIT(6),
>>>> +	IO_RING_F_LOCKLESS_CQ		= BIT(7),
>>>> +	IO_RING_F_SYSCALL_IOPOLL	= BIT(8),
>>>> +	IO_RING_F_POLL_ACTIVATED	= BIT(9),
>>>> +	IO_RING_F_DRAIN_DISABLED	= BIT(10),
>>>> +	IO_RING_F_COMPAT		= BIT(11),
>>>> +	IO_RING_F_IOWQ_LIMITS_SET	= BIT(12),
>>>> +};
>>>> +
>>>>  struct io_ring_ctx {
>>>>  	/* const or read-mostly hot data */
>>>>  	struct {
>>>>  		unsigned int		flags;
>>>> -		unsigned int		drain_next: 1;
>>>> -		unsigned int		op_restricted: 1;
>>>> -		unsigned int		reg_restricted: 1;
>>>> -		unsigned int		off_timeout_used: 1;
>>>> -		unsigned int		drain_active: 1;
>>>> -		unsigned int		has_evfd: 1;
>>>> -		/* all CQEs should be posted only by the submitter task */
>>>> -		unsigned int		task_complete: 1;
>>>> -		unsigned int		lockless_cq: 1;
>>>> -		unsigned int		syscall_iopoll: 1;
>>>> -		unsigned int		poll_activated: 1;
>>>> -		unsigned int		drain_disabled: 1;
>>>> -		unsigned int		compat: 1;
>>>> -		unsigned int		iowq_limits_set : 1;
>>>> +		unsigned int		int_flags;
>>>
>>> Jens,
>>>
>>> What does the int prefix means in this context?
>>
>> It's just short for 'internal'.
> 
> ack.  Perhaps a comment indicating this is internal would be
> useful. Otherwise,
> 
> Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

Added the comment and your reviewed-by, thanks!

-- 
Jens Axboe

