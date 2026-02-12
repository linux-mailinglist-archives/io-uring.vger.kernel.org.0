Return-Path: <io-uring+bounces-12178-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KKO5KmaxjWmz5wAAu9opvQ
	(envelope-from <io-uring+bounces-12178-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 11:54:30 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD8312CBA5
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 11:54:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C454B304BA7D
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 10:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0D6318BAB;
	Thu, 12 Feb 2026 10:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhfGAhM4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC5D31E10B
	for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 10:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770893553; cv=none; b=Y6YkqnqNbK0/7vSVjh+xScp9QAIh0Jc+EL+nlZOZ22NvHlkUgo6SWsFqViKhqFSpsvtg68zT8KgYmqVypb6ODcA+RTb7FoH+3nZu7s+ylqdbiLgpU1OcWCBj59yNcvCbxQZ32caqyAsCAgcMnrpfuBbNe//TRyH9Ob4KCfYyk/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770893553; c=relaxed/simple;
	bh=vDmlrrh4BLYaRR2l3ElM2gSOc+TGgSPsvhONw2b2DjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HObdl5EXDWafm7Y3B+Nwzp1gg0GomsCKceF0oKffEojyb2SMvoqsHQBX1t+4pBxWK2DslD1nL7YXTXCLOhsf+sUEuNxQswfKe44JRCNqwzCHitlMxFcynim6JNX1MCMuUU+lxRfP3Y6ANXv+UXBxUxt3Z56dKg5kAWAGTJKrf58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fhfGAhM4; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso28081665e9.1
        for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 02:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770893549; x=1771498349; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i7QK3EogTA2awwuFyYLWPGKb9u4Hhfpc0q+gDE6cl74=;
        b=fhfGAhM4OqwHWwaKNJtPn6hovTbFJlEicirI7hVY70vcZX6IAbyu9SOVTNKGxsW02g
         b9ZEO8fT6ljEDJ7+bb/vu1EGOGjIZWI3vJc0wTABTZ/wDp7tLtxVl1Ro9UU8MkLlNYfT
         r6FSzw032GNVVsS+J94iNH8iL5R9nvl2v8qVtRxvs3TlUyiwUapST6F6RYXIM5/7iFux
         MkNr8bhthdICvViw0fdunLrqu/FkVpAF+QVXRr8gGCynVqyrVJIJAkmnm3ifWYmKZ3jg
         dCerdnrM/7BOetdaRDh2Ur3Rmx7QsskMV0iwj1ZQsuKIQKKvBMaM8cpzZ3XKzp00U4Dx
         Q/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770893549; x=1771498349;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i7QK3EogTA2awwuFyYLWPGKb9u4Hhfpc0q+gDE6cl74=;
        b=VhB8LAgNJZA5HKTylL5TBfKaa1A5bbb4HomU14/SymE7+Ygt7R43GHolWJItMeF8Yp
         xCA182a1Ppu4XYxm+cYaHeMakMK3yg/uCyuugS5y4coE9r1/yjlRq5SVSHRMS72F9zq7
         AtcNwZxgJtC6d0uCQO/sj/EYPUXmFWjHzNL14Xjlvz8Ukuess6tM3mIzjQ8UJLwQHAXu
         e6jmRj84tA9UN95/OtcRt+qV5r0Z+47PtOFWOz2LZRAcBnjzoW3mYFD8Caa8psfDzQcI
         sk+67gPCgMO+9ZJCHrz3xc4Gyu/xCSiNMDv/UbxavI63RgnTlH6AXNCHoeZqhU9LF1Ds
         Dtpg==
X-Forwarded-Encrypted: i=1; AJvYcCVpMlfCwUyVfgrU7bCcqHBlR5SEla0XGb0ty4Y3BocOCKH+Y5S9l6ZARyf0ZSEczpMhYVpEipiyKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbnfFBrLCvs+5VyX622clsVxNHXW/ZWdhA4VxQ90AwUxvdV0V2
	q8XcyYOwvhCGHw2UH7OHLB3NY+l5pnk3oRQQ/8ah+hRGR4A5dx9uCxYM
X-Gm-Gg: AZuq6aIIQ09SdvPSBXStuAVnIf0tCuaSS9Zt85cSKnwN9zqOHKHc07cA66BLuoPWJUz
	4AATiKjVPHT41FAnVL+/Jozy+pSvzA5kJurh4ytqFgpI0bZnXOxQRazDQbwG0n6IueqyEsgqXJg
	SLSbuolWONLnk8x1KF9yYuGs48BoVMOroHAMjt9MYDI+hD1hp2zVM35MoRzuuYzdLinQHgK5lb1
	MnJC0SsT9k/UWZks4+9bsSt15N+/eMKsac2mIDzhsJwY/B1oeNhkRL7+hMc2SR/M7aACg36y2lb
	l6hFtWQZ7Fd65zkq9xRRk2aHm5O56sSjaF7T7JsAweJkd2WU+hR7OBa7GzTQRgql3Ipu7QDMlHX
	GgYU5kj/pfyd9qE3vrfdhneGtztYCa6u+LpKWUEAisMVMDR4YBavrgRkT1hXiRnE80cRKYOzGVp
	rxe0kUiAL46hR8LeG5JPPhbU++kRTNOIfxDQABFfc+HpwOMG1933eGrQ2CmUk8bZAHfOekmLQnS
	ZvrXcLt/PQHH893ko52vtzKzB3/ZMJOH2c52rWsUQ2tUa3lwwPwfVlCA0I7VyduonCUoNfNDPYY
	kQ==
X-Received: by 2002:a05:600d:486:10b0:483:6a8d:b2f9 with SMTP id 5b1f17b1804b1-4836a8db4f0mr14923255e9.5.1770893549133;
        Thu, 12 Feb 2026 02:52:29 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4836131d52bsm36821225e9.28.2026.02.12.02.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 02:52:28 -0800 (PST)
Message-ID: <809cd04b-007b-46c6-9418-161e757e0e80@gmail.com>
Date: Thu, 12 Feb 2026 10:52:29 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Christoph Hellwig <hch@infradead.org>,
 Joanne Koong <joannelkoong@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, csander@purestorage.com,
 krisman@suse.de, bernd@bsbernd.com, linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com>
 <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com>
 <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
 <aY2mdLkqPM0KfPMC@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aY2mdLkqPM0KfPMC@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12178-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CDD8312CBA5
X-Rspamd-Action: no action

On 2/12/26 10:07, Christoph Hellwig wrote:
> On Wed, Feb 11, 2026 at 02:06:18PM -0800, Joanne Koong wrote:
>>> I don't think I follow. I'm saying that it might be interesting
>>> to separate rings from how and with what they're populated on the
>>> kernel API level, but the fuse kernel module can do the population
>>
>> Oh okay, from your first message I (and I think christoph too) thought
>> what you were saying is that the user should be responsible for
>> allocating the buffers with complete ownership over them, and then
>> just pass those allocated to the kernel to use. But what you're saying
>> is that just use a different way for getting the kernel to allocate
>> the buffers (eg through the IORING_REGISTER_MEM_REGION interface). Am
>> I reading this correctly?
> 
> I'm arguing exactly against this.  For my use case I need a setup
> where the kernel controls the allocation fully and guarantees user
> processes can only read the memory but never write to it.  I'd love
> to be able to piggy back than onto your work.

IORING_REGISTER_MEM_REGION supports both types of allocations. It can
have a new registration flag for read-only, and then you either make
the bounce avoidance optional or reject binding fuse to unsupported
setups during init. Any arguments against that? I need to go over
Joanne's reply, but I don't see any contradiction in principal with
your use case.

-- 
Pavel Begunkov


