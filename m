Return-Path: <io-uring+bounces-10183-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96DE6C0446D
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 05:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EF6B3B7AA4
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 03:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80856275AE3;
	Fri, 24 Oct 2025 03:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MJSsaKaV"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3B2273804
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 03:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761277349; cv=none; b=jOSw0yygiHHRizaTl6LNT+Y6yaLLG2+cFK8yNiZgucLk3WKb5YCCX4+S9OslWTgY+/z93OAWXLN4F1v7InMU+zt/53hlG7m/LUQNQM//zIx/NUgSzmPVVLx5GB8+kvMqJkFT8lSuSLxAiTjNh7ZUVk4kHxsy8SQGptcidn35nl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761277349; c=relaxed/simple;
	bh=yFCyo1TDUR9cEj/6tUcEAuha+q4P2SsbBdgfCj4Nv8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dBnpBQJUY8NTCCTxo2wO3JUL4vfQSJ79UOOTeR+9DcV5S/owGCvruM21qM1JRAtEpBYT9s+8sYgMuwDcv0zDRfa2ny3y0KUqHPklX3pdJFb0HHjMmAQKO1mMycWQir4X5tv+DEmuTON+68Pd9Fhe3hveBygYxa+8O368SZHDszg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MJSsaKaV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761277346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3AdkHWGdY7Rb4p5SryOE9tkFRoKJcY1LS6rAaEq9CZ8=;
	b=MJSsaKaVFNWrAlCmE12qjWoWfNwTC5Q31yt8z2375IvqdjjC+CL7evwaPLZ0BP9rFczlSV
	S+F4ZUNaK3sRSBBiHN3QAh1oMdB1ad4vSlca/VT0TM5fh6UjMErqkaVD14wgzPWOkZjWtZ
	UcqEaOXfNXbA3iTZ0VGNMBe+4z7bQZ0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-179-NCN4550xPhe31AiS85h0cg-1; Thu,
 23 Oct 2025 23:42:20 -0400
X-MC-Unique: NCN4550xPhe31AiS85h0cg-1
X-Mimecast-MFC-AGG-ID: NCN4550xPhe31AiS85h0cg_1761277338
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 243E518002EC;
	Fri, 24 Oct 2025 03:42:18 +0000 (UTC)
Received: from fedora (unknown [10.72.120.13])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 485F830002D7;
	Fri, 24 Oct 2025 03:42:08 +0000 (UTC)
Date: Fri, 24 Oct 2025 11:42:03 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Miklos Szeredi <miklos@szeredi.hu>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] io_uring/uring_cmd: avoid double indirect call in
 task work dispatch
Message-ID: <aPr1i-k0byzYjv8G@fedora>
References: <20251023201830.3109805-1-csander@purestorage.com>
 <20251023201830.3109805-4-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023201830.3109805-4-csander@purestorage.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Oct 23, 2025 at 02:18:30PM -0600, Caleb Sander Mateos wrote:
> io_uring task work dispatch makes an indirect call to struct io_kiocb's
> io_task_work.func field to allow running arbitrary task work functions.
> In the uring_cmd case, this calls io_uring_cmd_work(), which immediately
> makes another indirect call to struct io_uring_cmd's task_work_cb field.
> Define the uring_cmd task work callbacks as functions whose signatures
> match io_req_tw_func_t. Define a IO_URING_CMD_TASK_WORK_ISSUE_FLAGS
> constant in io_uring/cmd.h to avoid manufacturing issue_flags in the
> uring_cmd task work callbacks. Now uring_cmd task work dispatch makes a
> single indirect call to the uring_cmd implementation's callback. This
> also allows removing the task_work_cb field from struct io_uring_cmd,
> freeing up some additional storage space.

The idea looks good.

> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  block/ioctl.c                |  4 +++-
>  drivers/block/ublk_drv.c     | 15 +++++++++------
>  drivers/nvme/host/ioctl.c    |  5 +++--
>  fs/btrfs/ioctl.c             |  4 +++-
>  fs/fuse/dev_uring.c          |  5 +++--
>  include/linux/io_uring/cmd.h | 16 +++++++---------
>  io_uring/uring_cmd.c         | 13 ++-----------
>  7 files changed, 30 insertions(+), 32 deletions(-)
> 
> diff --git a/block/ioctl.c b/block/ioctl.c
> index d7489a56b33c..5c10d48fab27 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -767,13 +767,15 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>  struct blk_iou_cmd {
>  	int res;
>  	bool nowait;
>  };
>  
> -static void blk_cmd_complete(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +static void blk_cmd_complete(struct io_kiocb *req, io_tw_token_t tw)
>  {
> +	struct io_uring_cmd *cmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>  	struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
> +	unsigned int issue_flags = IO_URING_CMD_TASK_WORK_ISSUE_FLAGS;

Now `io_kiocb` is exposed to driver, it could be perfect if 'io_uring_cmd'
is kept in kernel API interface, IMO.

...

> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index b84b97c21b43..3efad93404f9 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -9,18 +9,13 @@
>  /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
>  #define IORING_URING_CMD_CANCELABLE	(1U << 30)
>  /* io_uring_cmd is being issued again */
>  #define IORING_URING_CMD_REISSUE	(1U << 31)
>  
> -typedef void (*io_uring_cmd_tw_t)(struct io_uring_cmd *cmd,
> -				  unsigned issue_flags);
> -
>  struct io_uring_cmd {
>  	struct file	*file;
>  	const struct io_uring_sqe *sqe;
> -	/* callback to defer completions to task context */
> -	io_uring_cmd_tw_t task_work_cb;
>  	u32		cmd_op;
>  	u32		flags;
>  	u8		pdu[32]; /* available inline for free use */

pdu[40]



Thanks,
Ming


