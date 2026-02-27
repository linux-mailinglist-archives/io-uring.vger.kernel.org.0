Return-Path: <io-uring+bounces-12467-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MPU+AGLzoWkwxgQAu9opvQ
	(envelope-from <io-uring+bounces-12467-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 20:41:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B09A1BCF5C
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 20:41:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 141633006B33
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 19:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C7944DB7F;
	Fri, 27 Feb 2026 19:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0THwxTk0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFC53A1A57
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 19:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772221146; cv=none; b=G0IkYja6emiSWVJMgxKwsZPo6spSAjhgM/uqY9MDUYBXnXEGnW8XxM+JlEnAJee6pyyTs9jgp5sH3dJAZLSdXjKcv83gXlfgjEe3IWcF9ZX2Z97z3hFrKB07Q8ZELBtbd/Nsv/vclShVOqEuet652s4oPr60jSZl5sZO89H5wCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772221146; c=relaxed/simple;
	bh=qrROW3ZIZHYv7YRBhgN4Fn522B5r4R3sZnC6sxqMsZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hs4FFthaIgg0jnkiL4zAmhdUTtDrVE+BQR9w+2Di+hE5TZUcYJdD3sAg+CGTX2bNm2elM/6Bomi3nCK23vCtbs+YOIKb/OF64BEclMg4mrUaHA+vqgqaaiR7ERVq4UO7YuMljbOuRiuB56ctFcwBCPo8GfiPShEwTMPbp54WIoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0THwxTk0; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-676815e147dso1115804eaf.3
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 11:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772221142; x=1772825942; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JxDXNFxOZFFsk09gXdLuJwGR4P6dZ+u77gssMaAYqFE=;
        b=0THwxTk0bFbv7AsRlTN63X6YCT7Mn3jo6DVhu2lydIi0lJFogZn8D5rsCb9acStXFf
         7IS5HOxuJg51Lw3PXzH4qQVtiHhUlVbwCIgf5SFUVWy5Z3ouq9AFUXjz6jaRM3GbzGYd
         X6u66zicB8wgeapxx07RXXWG8Bwe8Ggkl/IoYvmOyNdzBNeG3d9xLm0EVX6lJKdi2JB2
         qcq7Kn/eHBqe7XfVCUG5eJNZlHrFxQPm/+1yqXIDro6XSPwDmHrZRSILWv4xKAOa1ihn
         VrSjC0L7a2lk1WIaKCsBQklw0cbekkml+JIqpN2cBLqLRIM3Frlsm2nJmGHPY+mUYDNC
         r93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772221142; x=1772825942;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JxDXNFxOZFFsk09gXdLuJwGR4P6dZ+u77gssMaAYqFE=;
        b=Wk/sHIOPTSzeBOTe5RJMx10dcyjdsb9HygieY9ZE+t1c4narzy/FImfupKzn5sIvDj
         GhFSpXsvnRx8G1p9vJaJ1nio/sW88pljCVRLObroosAu1Sis9WwWH7zJ+0p4Aw+0A/xr
         6bj+VYZrwccUqOqVeCvlLCXEXJ2xi+fhcNmDxOFMZf0feXJ6R6sOeNMIO/uk5/h9MYsu
         xMz3hH1fgiKbXkWYOFZ2O84SvZhDVLJTdyVy+VzNTeQYJJrrIRQjqQ8CDHM+iwLWFQQu
         XkyULZldrGpO21jA1aafdBnDnzb/yy4nDd1sdkjtqK4Tchs4dwc0Up6CT3EKxOMDJ9N5
         uljA==
X-Forwarded-Encrypted: i=1; AJvYcCW85Ksi9gwRAjQJFPBm6ZJq1lMfXBIP7xjhbXggOEeGttluNMxZUilOcV1uSZiWRFc6FOG/sK5VtA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgEuUuWIKIJFB4k5YAOJ3QcU5rVDI++1C3Zc7oBPKLFOdBxjfa
	8Cc9M4uhJrZYtB1LPaI8LD6aQ0pDRRL3XFP9hE0zYP78p+54ymE7ENNhHIkCXW9GnXM=
X-Gm-Gg: ATEYQzztXdLZDpZfSt1e9M9Hta37VdhwjbkDEdbisroixpy+7jARYS2+BokjJ1AxnEv
	PzvXlpbXbOlL4aS1GYU+fh4BSMjIFJdlBr8c0+BFX4KAM4u3gxDXSl47Sa27689jr9BRO9GS3vF
	dwbof0VkuFVq/vfLA2OVqoHKwUcvW1HxKsGAtkvbk9HJzjF/egxVjWEcK0q3F6v9aWB0/cI4E4E
	GKzZBV/50gLCKTOWLqf25Terw8LUOUyUfejJeIbYbs34tGi53ySwhrJJVKOB+gZ6uj+fxdKvbUi
	20WUmGbU9+jakN9TNb7I0RWEA7ysMLrUNAh2LyVjhJHnbkZVNA+V3Z0+PO65MaIZywzOcoV7L2I
	0k5X2LdDbHPQGBabMu2pLqcFWE/olhKFoiiDrjFkiIotJLiMqxQcOFVPYVOTiRj4V/m/dIT7AWd
	lDd3/mHVmm9XNWi+l11J5+3+ZGPgRk0FELwgd++KRwmVGXsOT+GU6Tw9Kp+6G+RQZP2SOdN/q8f
	Ek56nmiqw==
X-Received: by 2002:a05:6820:440e:b0:672:5a31:70a6 with SMTP id 006d021491bc7-679faef9821mr1817895eaf.40.1772221142383;
        Fri, 27 Feb 2026 11:39:02 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2bcbf22sm4116159eaf.2.2026.02.27.11.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 11:39:01 -0800 (PST)
Message-ID: <1cd9a071-dc93-48d1-81c9-24b65e65e8bf@kernel.dk>
Date: Fri, 27 Feb 2026 12:39:01 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Pavel Begunkov <asml.silence@gmail.com>,
 Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
 <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
 <a6cbceb5-2065-42ff-bcca-bdb1c2443b96@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a6cbceb5-2065-42ff-bcca-bdb1c2443b96@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12467-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,samba.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 6B09A1BCF5C
X-Rspamd-Action: no action

On 2/27/26 12:08 PM, Pavel Begunkov wrote:
> On 2/27/26 14:08, Stefan Metzmacher wrote:
>> Hi Pavel,
>>
>>>       if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>>>           return -EINVAL;
>>> @@ -460,10 +461,20 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>               return -EINVAL;
>>>           if (tr->flags & IORING_LINK_TIMEOUT_UPDATE)
>>>               tr->ltimeout = true;
>>> -        if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
>>> +        if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK |
>>> +                  IORING_TIMEOUT_ABS |
>>> +                  IORING_TIMEOUT_IMMEDIATE_ARG))
>>>               return -EINVAL;
>>> -        if (get_timespec64(&tr->ts, u64_to_user_ptr(READ_ONCE(sqe->addr2))))
>>> +
>>> +        arg = READ_ONCE(sqe->addr2);
>>> +        if (tr->flags & IORING_TIMEOUT_IMMEDIATE_ARG) {
>>> +            if (tr->flags & IORING_TIMEOUT_ABS)
>>> +                return -EINVAL;
>>> +            tr->ts = ns_to_timespec64(arg);
>>
>> I'm wondering if there is enough free space in a small sqe to hold a full timespec?
>> So that there is no restriction for IORING_TIMEOUT_ABS...
> 
> Well, u64 gives ~500 years in ns, it should be fine to just
> allow the abs mode. We just need to make sure to zero check
> the unused fields in case it'd need to be extended.

I don't think it's about length of it - if you can avoid the div by
doing ns_to_timespec64(), that might be very useful? Would make
userspace simpler too potentially, and basically make the immediate mode
_exactly_ the same as the non-immediate mode, it just delivers the
__kernel_timespec in a different way.

-- 
Jens Axboe

