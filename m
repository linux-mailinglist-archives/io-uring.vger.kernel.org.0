Return-Path: <io-uring+bounces-13355-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IGLuOVgtB2oLsgIAu9opvQ
	(envelope-from <io-uring+bounces-13355-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:27:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B03955169A
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:27:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C126F3074818
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 14:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49A6648BD4E;
	Fri, 15 May 2026 14:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CFuvn7v0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227BD1C861D;
	Fri, 15 May 2026 14:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778854275; cv=none; b=l18+llxMUEk2U7xqBGOGDSROM7fxxeboYaosFbLYIBhIPTgFPAe0bcjVqPybeBvuJacinA9nKzADXiIk7Ov5O7r6xBq1mxWkLLGE8587N3B9eD65DCkWb9QmRKSjbbtnU48VMpcT639AHsH2w4CpEXFz4B9ZJbgaU/4k4ELmSbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778854275; c=relaxed/simple;
	bh=v59ub3zIM85ceK9Xm+l25zDa14dRJ1t2DbhpmYfwjyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qim5lp60HHkXK73MGEM8CuZ9CY/2VtXT+Ps8ZOWFDZRodWTIuGxc3YQi3oZLuxTYA/HuDHqEHU5TCY2LnvJ5i6MxVbvAUqDucXKhLB1DEQX4ar4pDPaPblTJn+w+IdOtI+Si4fkEektcjekWhjVsAPQFDw0C5O/hz1xZPkAThDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CFuvn7v0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3F1C2BCB0;
	Fri, 15 May 2026 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778854275;
	bh=v59ub3zIM85ceK9Xm+l25zDa14dRJ1t2DbhpmYfwjyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CFuvn7v0swDt+59PtYgfGSi593aL2XuMvHcb/bjh+5M9RQ3ExSSuHL7CQSgc4Skv1
	 OrwDYkJPfAoc/lK7y83g0RCQ1sjjSQ6+TYhzvFwkTmUc3LvI1bf/84BlKrbXKOiZsB
	 QmzIdxVjTaR4GzC1ElPzmSUlHy3c7ptzDx+VjSrzspl8F/BK8zScFg68X3mUBGTjhW
	 o2AJ/BwBG3QDAyDYUJ3J2RYOWsGFiKHJxbOlt7qXsJfsYQsEM7zcbzZQbKAY40Tn23
	 F/ME+pQjh4WA9YGliILehGvN1BXoQpjkTUjmIfKlYgH+Bl9uQDftx0tQXgUTm12+nq
	 KU8QEV+BGJBXQ==
Date: Fri, 15 May 2026 10:11:13 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time
 namespace for IORING_ENTER_ABS_TIMER
Message-ID: <agcpgQ9OPLLP7c5Y@laps>
References: <20260511221931.2370053-1-sashal@kernel.org>
 <20260511221931.2370053-13-sashal@kernel.org>
 <e12d01e9-8934-4150-bcb3-09ba147fc842@kernel.dk>
 <96e5ee2d-a64b-408a-ba7f-e9ca25952959@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <96e5ee2d-a64b-408a-ba7f-e9ca25952959@kernel.dk>
X-Rspamd-Queue-Id: 3B03955169A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13355-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,gmail.com,ntu.edu.sg];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Fri, May 15, 2026 at 08:04:57AM -0600, Jens Axboe wrote:
>On 5/12/26 9:47 AM, Jens Axboe wrote:
>> On 5/11/26 4:19 PM, Sasha Levin wrote:
>>> From: Maoyi Xie <maoyixie.tju@gmail.com>
>>>
>>> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
>>
>> If you auto-pick this one, please also do the other one in the
>> series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense
>> to do just one of them.
>
>Hello?

Sorry, yes - I'll pick it up too.

I usually let AUTOSEL reviews soak for a bit before I go over them to catch
follow up fixes or other concerns.

-- 
Thanks,
Sasha

