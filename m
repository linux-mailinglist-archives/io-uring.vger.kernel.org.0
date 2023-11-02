Return-Path: <io-uring+bounces-20-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 932EE7DFAB6
	for <lists+io-uring@lfdr.de>; Thu,  2 Nov 2023 20:14:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D229281BE9
	for <lists+io-uring@lfdr.de>; Thu,  2 Nov 2023 19:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26927200D4;
	Thu,  2 Nov 2023 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cskQ3FXo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="z+H1Z4uG"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404C61CFB6
	for <io-uring@vger.kernel.org>; Thu,  2 Nov 2023 19:14:02 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20A712D
	for <io-uring@vger.kernel.org>; Thu,  2 Nov 2023 12:13:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 01800218E5;
	Thu,  2 Nov 2023 19:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1698952436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uauie0nHv06BBJrWnNqo42Fgux7o4eyYsJjHQY6WXcY=;
	b=cskQ3FXoBD2TXgw8Nz1lJykLRGpTxVTszroQbYuAbjyt/7B8ZRh6kO6P5hgxna2WyZ6j6a
	t0UfBK/UEDoOMuDO5F8/8ag355gDq/OOHWcMI5cLap2VitPJtX8fHTNY5dmk8N9u9tcQm8
	cdXYYy5YswTDNwPp8PZkEZRT2CT0hMk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1698952436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uauie0nHv06BBJrWnNqo42Fgux7o4eyYsJjHQY6WXcY=;
	b=z+H1Z4uGl3s86UMFsmajEtVFPap24+R3DeONbmpgyicak4Dr7mO0LY4P37jO9yB1DcM+pg
	k3ZcvdQgj12492BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BF2D6138EC;
	Thu,  2 Nov 2023 19:13:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id +qnxKPP0Q2UzGgAAMHmgww
	(envelope-from <krisman@suse.de>); Thu, 02 Nov 2023 19:13:55 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Ferry Meng <mengferry@linux.alibaba.com>
Cc: io-uring@vger.kernel.org,  axboe@kernel.dk,  joseph.qi@linux.alibaba.com
Subject: Re: Problem about sq->khead update and ring full judgement
In-Reply-To: <7feaba7c-b93c-a136-6438-1de365b5a02a@linux.alibaba.com> (Ferry
	Meng's message of "Fri, 3 Nov 2023 02:43:49 +0800")
References: <7feaba7c-b93c-a136-6438-1de365b5a02a@linux.alibaba.com>
Date: Thu, 02 Nov 2023 15:13:54 -0400
Message-ID: <87bkccc6j1.fsf@>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Ferry Meng <mengferry@linux.alibaba.com> writes:

> Hi all:
> =C2=A0=C2=A0=C2=A0 I'm using io_uring in a program, with SQPOLL feature e=
nabled. The
> userspace program will actively count the queue status of urings, the
> programming model is similar to:
> =C2=A0=C2=A0=C2=A0 {
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 sqe =3D io_uring_get_sqe();
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if(sqe){
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 /* prepare next =
request */
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 queue_count++;
> =C2=A0=C2=A0=C2=A0 }
>
>
> =C2=A0=C2=A0=C2=A0 {
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 cqe =3D io_uring_peek_cqe();
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if(cqe){
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 queue_count--;
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0 }
>
> =C2=A0=C2=A0=C2=A0 In this way, maybe we can assume that " sq_ring_size -=
 queue_count =3D
> sqe_left_we_can_alloc "?


> =C2=A0=C2=A0=C2=A0 Now I'm currently coming into a situation where=C2=A0 =
I/O is very high =E2=80=94=E2=80=94
> Userspace program submit lots of sqes (around 2000) at the same time,
> meanwhile=C2=A0 sq_ring_size is 4096. In kernel,
> __io_sq_thread->io_submit_sqes(), I see that nr(to_submit) is also over
> 2000.=C2=A0=C2=A0 At a point, a strange point comes out: Userspace progra=
m find
> sq_ring is not full, but Kernel(in fact liburing::io_uring_get_sqe)
> think sq_ring is full.
>
> =C2=A0=C2=A0=C2=A0 After analyzing, I find the reason is: kernel update "=
sq->khead"
> after submitting "all" sqes. The running of my program is : Before
> kernel update khead, userspace program has received many cqes, causing
> queue_count-- . After decreasing queue_count, user-program thinks
> sq_ring is not full, and try to start new IO requeust. As sq->head is
> not updated, io_uring_get_sqe() returns NULL.
>
> =C2=A0=C2=A0=C2=A0 My questions are:
>
> =C2=A0=C2=A0=C2=A0 1. Is userspace 'queue_count' judgement reasonable? Fr=
om
> 'traditional' point of view, if we want to find sq_ring full or not, we
> can just use io_uring_get_sqe() to check

Not really. IIUC, you cannot rely on the number of CQEs to account for
submission queue space.  The SQE is consumed and the SQ pointer advanced
before the request is completed, so you can have more inflight than SQ
entry space.  Maybe what you want is io_uring_sq_space_left(3)?

--=20
Gabriel Krisman Bertazi

