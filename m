Return-Path: <io-uring+bounces-4704-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B1D49C92F6
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 21:11:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FFAE28484E
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 20:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9611AA7A5;
	Thu, 14 Nov 2024 20:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="anx91EaE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4161A9B5D;
	Thu, 14 Nov 2024 20:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731615066; cv=none; b=F9iTyTzchL7SS5g9sMibw3GEJswog/U+fzA2Lf5idKyuFoSz9IxJzm00AGGTMtzXunbKkvjVLEK1Wx/z21XipbQfLUXhNFLdAFi/3e6DQAzVqo72EV6E8RmNYEDdukWfxPQz7Jr7f7YRwYdRMdCevDwNwqO1KwAyJEg4Io8KO3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731615066; c=relaxed/simple;
	bh=ASl8LSAvyQVJiieFrry6JPr3SCOWxU/QgkzXXpnO05k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=drxFhEPbMbjY39Y4iwOyuq2dsavqcNImFcqm1Z5cawbW0a2HX6rG8/C2+5JchZZpkamRHSEc2vgkDYyRtsm1Awpa8lk/YntQKSd437OFfhJVCv8VH85UgpNe0cJZxriR11G90oDEg910qbf1yQ3NQg95ojX9JPjApHuZCkRXnMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=anx91EaE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C035C4CECD;
	Thu, 14 Nov 2024 20:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731615066;
	bh=ASl8LSAvyQVJiieFrry6JPr3SCOWxU/QgkzXXpnO05k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=anx91EaEjJy6ntu/ddhlMwoMHjGZHqXIcwlIbSxu2kcIowwLvk0UMlYby2HoawQBE
	 sbHvq+nARD/fY8HjJLg0VQCU5jOhJpqefyvJJFZ+f+qLvTpgcBp+tjagV8VPGSTX60
	 4kskjjjHURDBovPsnp/VTNUO8ITbMWwx2W2KL+5N2QKDS7IRQ9oAIkEmJm+59XuIOA
	 l1VzSp7HwTt1oIQOTTmYjK82gHnErDFI3wDf+EKeei1n2xKrAKGHUEWdD7uchJoI3V
	 PC5BtRgOOKwMQ0g+7H4HCnJlTN/H4VNZ+dTMPpc4aPLFr+AOKTMj7fybJKs94y7uhH
	 7wMQc3PHz3+RQ==
Date: Thu, 14 Nov 2024 13:11:03 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 4/6] block: add a rq_list type
Message-ID: <20241114201103.GA2036469@thelio-3990X>
References: <20241113152050.157179-1-hch@lst.de>
 <20241113152050.157179-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113152050.157179-5-hch@lst.de>

Hi Christoph,

On Wed, Nov 13, 2024 at 04:20:44PM +0100, Christoph Hellwig wrote:
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 65f37ae70712..ce8b65503ff0 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1006,6 +1006,11 @@ extern void blk_put_queue(struct request_queue *);
>  void blk_mark_disk_dead(struct gendisk *disk);
>  
>  #ifdef CONFIG_BLOCK
> +struct rq_list {
> +	struct request *head;
> +	struct request *tail;
> +};
> +
>  /*
>   * blk_plug permits building a queue of related requests by holding the I/O
>   * fragments for a short period. This allows merging of sequential requests
> @@ -1018,10 +1023,10 @@ void blk_mark_disk_dead(struct gendisk *disk);
>   * blk_flush_plug() is called.
>   */
>  struct blk_plug {
> -	struct request *mq_list; /* blk-mq requests */
> +	struct rq_list mq_list; /* blk-mq requests */
>  
>  	/* if ios_left is > 1, we can batch tag/rq allocations */
> -	struct request *cached_rq;
> +	struct rq_list cached_rqs;
>  	u64 cur_ktime;
>  	unsigned short nr_ios;
>  
> @@ -1683,7 +1688,7 @@ int bdev_thaw(struct block_device *bdev);
>  void bdev_fput(struct file *bdev_file);
>  
>  struct io_comp_batch {
> -	struct request *req_list;
> +	struct rq_list req_list;

This change as commit a3396b99990d ("block: add a rq_list type") in
next-20241114 causes errors when CONFIG_BLOCK is disabled because the
definition of 'struct rq_list' is under CONFIG_BLOCK. Should it be moved
out?

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 00212e96261a..a1fd0ddce5cf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1006,12 +1006,12 @@ extern void blk_put_queue(struct request_queue *);
 
 void blk_mark_disk_dead(struct gendisk *disk);
 
-#ifdef CONFIG_BLOCK
 struct rq_list {
 	struct request *head;
 	struct request *tail;
 };
 
+#ifdef CONFIG_BLOCK
 /*
  * blk_plug permits building a queue of related requests by holding the I/O
  * fragments for a short period. This allows merging of sequential requests

>  	bool need_ts;
>  	void (*complete)(struct io_comp_batch *);
>  };

