Return-Path: <io-uring+bounces-264-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D265880AA10
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 18:08:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39C6A2818B6
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 17:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A19D22308;
	Fri,  8 Dec 2023 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GbZ97XCp"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006521989
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 09:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702055287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=geKb5s/2utc6piCF71zpvMcYTqfKwMoL8K14EkjCTh8=;
	b=GbZ97XCpkekqlIUsMu1enha2MQvl9oxToADOidey3PfGvh66Ld4XsvxTazLrZZCzDATb7/
	/6A+3OgUTCWsYLyqLNrOt6P9CaAxp+dO0i9PwQ5lQVHRl05bWOeIrWPwWm3Gg7tGKYojmK
	N8ZB1zS3wALnDZVqig55N018gyyloPA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-swUAJBaqPsmjIZT__OEkVg-1; Fri, 08 Dec 2023 12:08:02 -0500
X-MC-Unique: swUAJBaqPsmjIZT__OEkVg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C11A58820C5;
	Fri,  8 Dec 2023 17:08:00 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.10.6])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84F388CD0;
	Fri,  8 Dec 2023 17:08:00 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>,  io-uring@vger.kernel.org,  Pavel Begunkov
 <asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/af_unix: disable sending io_uring over
 sockets
References: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
	<170198118655.1944107.5078206606631700639.b4-ty@kernel.dk>
	<x49sf4c91ub.fsf@segfault.usersys.redhat.com>
	<CAG48ez2R0AWjsWMh+cHepvpbYWB5te_n1PFtgCaSFQuX51m0Aw@mail.gmail.com>
	<x49lea48yqm.fsf@segfault.usersys.redhat.com>
	<6d2d5231-4729-4783-bcc8-0d11396e30fb@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Fri, 08 Dec 2023 12:08:00 -0500
In-Reply-To: <6d2d5231-4729-4783-bcc8-0d11396e30fb@kernel.dk> (Jens Axboe's
	message of "Fri, 8 Dec 2023 09:28:35 -0700")
Message-ID: <x49h6ks8vwv.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Jens Axboe <axboe@kernel.dk> writes:

> On 12/8/23 9:06 AM, Jeff Moyer wrote:
>>>> So, this will break existing users, right?
>>>
>>> Do you know of anyone actually sending io_uring FDs over unix domain
>>> sockets?
>> 
>> I do not.  However, it's tough to prove no software is doing this.
>
> This is obviously true, however I think it's very low risk here as it's
> mostly a legacy/historic use case and that really should not what's
> using io_uring. On top of that, the most efficient ways of using
> io_uring will exclude passing and using a ring from a different task
> anyway.
>
>>> That seems to me like a fairly weird thing to do.
>> 
>> I am often surprised by what developers choose to do.  I attribute that
>> to my lack of imagination.
>
> I think you stated that very professionally, in my experience the
> reasonings are rather different :-)

I thought you might like that.  :)

>>> Thinking again about who might possibly do such a thing, the only
>>> usecase I can think of is CRIU; and from what I can tell, CRIU doesn't
>>> yet support io_uring anyway.
>> 
>> I'm not lobbying against turning this off, and I'm sure Pavel had
>> already considered the potential impact before posting.  It would be
>> good to include that information in the commit message, in my opinion.
>
> It's too late for that now, but I can mention it in the pull request at
> least.

Thanks, Jens, much appreciated.

Cheers,
Jeff


