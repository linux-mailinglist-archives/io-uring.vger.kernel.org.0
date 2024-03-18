Return-Path: <io-uring+bounces-1080-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 331D387E21D
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 03:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A884E1F221F3
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 02:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889611DFC1;
	Mon, 18 Mar 2024 02:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DfTbtSUw"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6CD17547
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 02:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710728651; cv=none; b=axAwS9eH3Yck1ibz27dGQE2Ejr12+8Ut9UCKx+4LUwrYZYm43tVNENZk8fc3L/8Sy7c0gm/RM3W/Chjxc42o1RHfQTNe2bRGDXyK70UtHFJ/LjKueOLEYaFVxf/MYUQA2MpNoSOVTSHytPZtJudXHASrH+MCM4DPv56sxFunK38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710728651; c=relaxed/simple;
	bh=jKjP2bqDPmdsFrqGmc4MTPFGukfFKXRch6I00JIiiwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qsQdikkWP62onXu7m8OU+FtugcLusp4oSHTepDP5K9QzdztyLB/Kymz8T03UFVdriRxO+6AFsoDHdlEtq3dkbcGUp/35R7QcjB1ZQfu0tcxyxt4zqxXTX3KPeQ63cPpVKnHtzKm7xFRrIXJh5ZsU7WG5MWeHrLVGi4bbpFrJz/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DfTbtSUw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710728647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9gjdsxvTZUD6Hghn9xLz17EHLsKM0MoxD1cbu4FIL2E=;
	b=DfTbtSUw7uuD+qU5Az5+M3GLD7MeD2M5HWqothfi/efUkw4fmuBXHTRclDYPhnglVbRnko
	JrEQreKIHSwuBrE7ZqxFDUSpzqdyrS0LPjQbR4tDz0wSFaE3fYIAjS8ZkYCTeuMgvl6vFb
	W9RmQCTQwYmbNF91P+n1XdEMPdPVVRo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-rDaiI7ufOWOIAfCjx8fnQA-1; Sun, 17 Mar 2024 22:24:04 -0400
X-MC-Unique: rDaiI7ufOWOIAfCjx8fnQA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6312800264;
	Mon, 18 Mar 2024 02:24:03 +0000 (UTC)
Received: from fedora (unknown [10.72.116.15])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 951A22166B33;
	Mon, 18 Mar 2024 02:24:00 +0000 (UTC)
Date: Mon, 18 Mar 2024 10:23:51 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v2 02/14] io_uring/cmd: fix tw <-> issue_flags conversion
Message-ID: <Zfelt6mbVA0moyq6@fedora>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <c48a7f3919eecbee0319020fd640e6b3d2e60e5f.1710720150.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c48a7f3919eecbee0319020fd640e6b3d2e60e5f.1710720150.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Mon, Mar 18, 2024 at 12:41:47AM +0000, Pavel Begunkov wrote:
> !IO_URING_F_UNLOCKED does not translate to availability of the deferred
> completion infra, IO_URING_F_COMPLETE_DEFER does, that what we should
> pass and look for to use io_req_complete_defer() and other variants.
> 
> Luckily, it's not a real problem as two wrongs actually made it right,
> at least as far as io_uring_cmd_work() goes.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Link: https://lore.kernel.org/r/eb08e72e837106963bc7bc7dccfd93d646cc7f36.1710514702.git.asml.silence@gmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/uring_cmd.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index f197e8c22965..ec38a8d4836d 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -56,7 +56,11 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
>  static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>  {
>  	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> -	unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
> +	unsigned issue_flags = IO_URING_F_UNLOCKED;
> +
> +	/* locked task_work executor checks the deffered list completion */
> +	if (ts->locked)
> +		issue_flags = IO_URING_F_COMPLETE_DEFER;
>  
>  	ioucmd->task_work_cb(ioucmd, issue_flags);
>  }
> @@ -100,7 +104,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
>  	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>  		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
>  		smp_store_release(&req->iopoll_completed, 1);
> -	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
> +	} else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
> +		if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
> +			return;
>  		io_req_complete_defer(req);
>  	} else {
>  		req->io_task_work.func = io_req_task_complete;

'git-bisect' shows the reported warning starts from this patch.

Thanks,
Ming


