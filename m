Return-Path: <io-uring+bounces-10104-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA24DBFC6B9
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:14:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86B10625743
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 13:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2F834A77C;
	Wed, 22 Oct 2025 13:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ezxgrQdk"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B8234A776
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 13:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761140981; cv=none; b=oLz2KPiOjEgJ9cFmgw0wzs0OSlZITRPSvaMCZTIzjGc4rHPrPiFg99iw2GubuvrR+c54DQs0K39R4gZBNQwdWtgY7UNNOIk8Q/wP76/GGYhlbmwjaTlFxLqBqNqD1EFzQASfR/KSE+ISo2wEr3K4AXW2iShdClbOsOx78r0CZLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761140981; c=relaxed/simple;
	bh=XCfpv9OFiCU0En3vgVrJf9giCeEmsIj4oLn+T37u2Ss=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=GXzOjOceEHYfTEsxSwUaCBEIYB75hf9HudTYvWQ9Knt+//n9+brZXec28aAuWL9tIE58gWdMf8wJzZNIAU+7Z9azSt7/kHXjBUMZcvwP+soLIUILFcwywi5DjYKs8NbGkPf0wdbAZqhFcyaTNSVF9ollS+RPdC/RDhannN2bC6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ezxgrQdk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761140978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yPww/2csBO5h6LuKup4++TzQCeLFKsCQjw8Z3DdMJok=;
	b=ezxgrQdkJ4BAuDqBKLgyG6Y8CO6PyZVRC7AWfcqk8Wurs4oVFmLxU26OlWOl/6meQ9pWZx
	6uB084f+lEBwPG/iSYybtDj0Y+A1qnrEO9qFmCDdHk7Fo+qOGXXcKowFI1Q6wz3k9dgvAs
	TvDD0YevVNS5BdHDuwhTvr+yaCyiTt8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-1zSSALbmOOGM6SJRxGd3SA-1; Wed,
 22 Oct 2025 09:49:34 -0400
X-MC-Unique: 1zSSALbmOOGM6SJRxGd3SA-1
X-Mimecast-MFC-AGG-ID: 1zSSALbmOOGM6SJRxGd3SA_1761140973
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FBE51956053;
	Wed, 22 Oct 2025 13:49:33 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.89.32])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 009D51800451;
	Wed, 22 Oct 2025 13:49:32 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: check for user passing 0 nr_submit
References: <9f43c61b36bc5976e7629663b4558ce439bccc64.1760609826.git.asml.silence@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 22 Oct 2025 09:49:31 -0400
In-Reply-To: <9f43c61b36bc5976e7629663b4558ce439bccc64.1760609826.git.asml.silence@gmail.com>
	(Pavel Begunkov's message of "Thu, 16 Oct 2025 12:20:31 +0100")
Message-ID: <x49sefbyrkk.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.3 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Pavel Begunkov <asml.silence@gmail.com> writes:

> io_submit_sqes() shouldn't be stepping into its main loop when there is
> nothing to submit, i.e. nr=0. Fix 0 submission queue entries checks,
> which should follow after all user input truncations.

I see two callers of io_submit_sqes, and neither of them will pass 0 for
nr.  What am I missing?

-Jeff

>
> Cc: stable@vger.kernel.org
> Fixes: 6962980947e2b ("io_uring: restructure submit sqes to_submit checks")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>
> v2: split out of the series with extra tags, no functional changes
>
>  io_uring/io_uring.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 820ef0527666..ee04ab9bf968 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2422,10 +2422,11 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>  	unsigned int left;
>  	int ret;
>  
> +	entries = min(nr, entries);
>  	if (unlikely(!entries))
>  		return 0;
> -	/* make sure SQ entry isn't read before tail */
> -	ret = left = min(nr, entries);
> +
> +	ret = left = entries;
>  	io_get_task_refs(left);
>  	io_submit_state_start(&ctx->submit_state, left);


