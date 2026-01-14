Return-Path: <io-uring+bounces-11708-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id AFAA8D1FCA2
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 16:35:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 602463023B55
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 15:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92ACD39E6DD;
	Wed, 14 Jan 2026 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f4MHHixy"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE28A39E6E1
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 15:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768404743; cv=none; b=mWdrvIG2Rl+QCpVeMQsY3ZRTEoR8t0H3mV/NmnU3vpsMVSVajJzaLZCHrnqdNMRGmEk9u327B2iBbaEjxpTWsxJPp9q4TYefzwKZSFcr9u0awFoqeoQ81qnLS2gcqhougrinfVeQlGFPTEjqeZHpUlWEeTRfMuuGcp00Z5dVTmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768404743; c=relaxed/simple;
	bh=09XoV6oF5v1olzptLjyy1BXYDj5setejI+60/8cyHQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSwwY7B1fPWq59cqemj9y3rInpKGkJ2xHpGNCf9kgiNYIr5pkfPhGMNBUGfik7PYCd06HRv5Lj8Xc3smOb4RqnIk3Cd59rZQXQ3HC43uWE/7QPlMNo+lx4IQkKgObtstRNn9sxiHipidgQRQq3mYcR0F9nrzfBtBvmaS/lpOaPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f4MHHixy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768404740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MwyvvawJQMIbZ/dQu8tD5nvkMX1eEPI7tUm3rHe2PQU=;
	b=f4MHHixyGkI6wlB4P97CdalhVdVZFXzDJdl++P0zd0OxUIbAoIgMrsdth7ONpzDvMu80aV
	CarwXO30k1CS7oYTPowgmUQ4uJ6KJjUVIHCHQU0+2C+qr67ddSp3qIWRcdVIMiu9qqtW/R
	LElHiGHRlAraFIyG8ja/TnNwUjkpTK4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-C0ynUsY6MrSJ9s7c-bOCVg-1; Wed,
 14 Jan 2026 10:32:19 -0500
X-MC-Unique: C0ynUsY6MrSJ9s7c-bOCVg-1
X-Mimecast-MFC-AGG-ID: C0ynUsY6MrSJ9s7c-bOCVg_1768404738
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58A761956050;
	Wed, 14 Jan 2026 15:32:18 +0000 (UTC)
Received: from fedora (unknown [10.72.116.198])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AEF601801760;
	Wed, 14 Jan 2026 15:32:15 +0000 (UTC)
Date: Wed, 14 Jan 2026 23:32:10 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, Yi Zhang <yi.zhang@redhat.com>
Subject: Re: [PATCH] io_uring: fix IOPOLL with passthrough I/O
Message-ID: <aWe2-iz6eaIyuIZl@fedora>
References: <b60cab06-92ad-467b-b512-1e76ec5e970e@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b60cab06-92ad-467b-b512-1e76ec5e970e@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Jan 14, 2026 at 08:12:15AM -0700, Jens Axboe wrote:
> A previous commit improving IOPOLL made an incorrect assumption that
> task_work isn't used with IOPOLL. This can cause crashes when doing
> passthrough I/O on nvme, where queueing the completion task_work will
> trample on the same memory that holds the completed list of requests.
> 
> Fix it up by shuffling the members around, so we're not sharing any
> parts that end up getting used in this path.
> 
> Fixes: 3c7d76d6128a ("io_uring: IOPOLL polling improvements")
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Link: https://lore.kernel.org/linux-block/CAHj4cs_SLPj9v9w5MgfzHKy+983enPx3ZQY2kMuMJ1202DBefw@mail.gmail.com/
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index e4c804f99c30..211686ad89fd 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -713,13 +713,10 @@ struct io_kiocb {
>  	atomic_t			refs;
>  	bool				cancel_seq_set;
>  
> -	/*
> -	 * IOPOLL doesn't use task_work, so use the ->iopoll_node list
> -	 * entry to manage pending iopoll requests.
> -	 */
>  	union {
>  		struct io_task_work	io_task_work;
> -		struct list_head	iopoll_node;
> +		/* For IOPOLL setup queues, with hybrid polling */
> +		u64                     iopoll_start;
>  	};
>  
>  	union {
> @@ -728,8 +725,8 @@ struct io_kiocb {
>  		 * poll
>  		 */
>  		struct hlist_node	hash_node;
> -		/* For IOPOLL setup queues, with hybrid polling */
> -		u64                     iopoll_start;
> +		/* IOPOLL completion handling */
> +		struct list_head	iopoll_node;
>  		/* for private io_kiocb freeing */
>  		struct rcu_head		rcu_head;

->hash_node is used by uring_cmd in io_uring_cmd_mark_cancelable()/io_uring_cmd_del_cancelable(),
so this way may break uring_cmd if supporting iopoll and cancelable in future.


Thanks,
Ming


