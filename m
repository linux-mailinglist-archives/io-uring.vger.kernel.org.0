Return-Path: <io-uring+bounces-10132-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE5CBBFD9B1
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:35:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54C131A067F9
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2038274B53;
	Wed, 22 Oct 2025 17:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jNqE6TLl"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34370155389
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761154512; cv=none; b=EkZ6p5hTvTQJrnacYZkS6alddxHnpuskhTEcDQ9/tgkFtGq00P9YrN0eq4ta9XVTvlLEW6lN12UbeJiME6tjE9+7BGyiN8tADYjShqBPfOJZNOgyeXjidgcUVEVvA/+5qWwPkCpddKyL/3v+0WDF8O+Epgy5c3fOKUMNKj9g6Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761154512; c=relaxed/simple;
	bh=5cHNuq8GotRfdnaDg5noPrmf7+ui12EeCs1R2nfvRUg=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=SlbZqFwDMwLh9/pl5XoGYf0Sf7qWDX9dCXNsBpgwV7wLYaggzAGAJxbWMsRC/z87WGAekX0PGHMFo//oVPRTq5t9YECLqIIW1/SrUiTs8ZECI6J2If18KaOKFmxx/TszgMy8MoDjacJxdkZpzr7vRBtN7fy4b+QbDUNBUmRVmJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jNqE6TLl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761154510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aP2592wD6pDzloXbQY7q0offaHySOcPIxnRXEJJFI8o=;
	b=jNqE6TLl+uycEV4k9675YCWrvOPwVvIzlYYp1Hfl3uhN0+okbPJItOkoyLiPCbOsEL+PAD
	AX3dz+EdBlezUIgipUlvZ0aLbZTJHk1UJ9J4VIklIoXgZ68cd8zH41Y5ObtBkragXseekw
	g/2A5ltOxfyEtTf0ZSQwe3Lu+kYdufA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-e74ElI3VP1SlWz5lkRDc3g-1; Wed,
 22 Oct 2025 13:35:08 -0400
X-MC-Unique: e74ElI3VP1SlWz5lkRDc3g-1
X-Mimecast-MFC-AGG-ID: e74ElI3VP1SlWz5lkRDc3g_1761154507
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7A2A1800451;
	Wed, 22 Oct 2025 17:35:07 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.89.32])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5C48180044F;
	Wed, 22 Oct 2025 17:35:06 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: check for user passing 0 nr_submit
References: <9f43c61b36bc5976e7629663b4558ce439bccc64.1760609826.git.asml.silence@gmail.com>
	<x49sefbyrkk.fsf@segfault.usersys.redhat.com>
	<355c371d-124d-4414-9af4-fd9247692db3@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 22 Oct 2025 13:35:04 -0400
In-Reply-To: <355c371d-124d-4414-9af4-fd9247692db3@gmail.com> (Pavel
	Begunkov's message of "Wed, 22 Oct 2025 17:53:13 +0100")
Message-ID: <x49cy6ezvp3.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.3 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Pavel Begunkov <asml.silence@gmail.com> writes:

> On 10/22/25 14:49, Jeff Moyer wrote:
>> Pavel Begunkov <asml.silence@gmail.com> writes:
>> 
>>> io_submit_sqes() shouldn't be stepping into its main loop when there is
>>> nothing to submit, i.e. nr=0. Fix 0 submission queue entries checks,
>>> which should follow after all user input truncations.
>> I see two callers of io_submit_sqes, and neither of them will pass 0
>> for
>> nr.  What am I missing?
>
> You're right, we can drop the fixes/stable part. It's still
> good to have as it's handled not in the best way.

Agreed.

Cheers,
Jeff

>
>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 6962980947e2b ("io_uring: restructure submit sqes to_submit checks")
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>
>>> v2: split out of the series with extra tags, no functional changes
>>>
>>>   io_uring/io_uring.c | 5 +++--
>>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 820ef0527666..ee04ab9bf968 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -2422,10 +2422,11 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>>>   	unsigned int left;
>>>   	int ret;
>>>   +	entries = min(nr, entries);
>>>   	if (unlikely(!entries))
>>>   		return 0;
>>> -	/* make sure SQ entry isn't read before tail */
>>> -	ret = left = min(nr, entries);
>>> +
>>> +	ret = left = entries;
>>>   	io_get_task_refs(left);
>>>   	io_submit_state_start(&ctx->submit_state, left);
>> 


