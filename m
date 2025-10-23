Return-Path: <io-uring+bounces-10159-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5970FC01819
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 15:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 066F83B10C8
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 13:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E33DF314D1E;
	Thu, 23 Oct 2025 13:40:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB2B3148C7;
	Thu, 23 Oct 2025 13:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761226855; cv=none; b=nWZ4TRosJR4Gxbtp4QJa4FCGUF/toFzGLGWydu7RqO409+4iRGDzIyvdnk9SJSw6573XwKO4tUvzBb6cUrKbug3CS9GYszCF8iC9/KU+MdLzBwSlxAgoObMntmVyX7Z3rAHXYneMwnMoVnIs3pVHf4hsLAEcvlPoMaAguM4GDC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761226855; c=relaxed/simple;
	bh=irzMywcerFP2dFccXWPgmJSK9w7EvAi/JpG1EqYmHD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4/4AVZ30esAJURjYvKR8BreO7l8a9ZNo1HXiyn9MMXytRn1RvwkBRgudA6x1Px2mxxfs+SjWQ9z4xY1tTHC+irA6g777Sm+R/XUcTAwO4ToTDUMlLsA+u53Dpleh0GjnxAW+N8zOUhpG5ymWwKlibMJsHgrtz9qyih57me3Gmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9E777227A8E; Thu, 23 Oct 2025 15:40:47 +0200 (CEST)
Date: Thu, 23 Oct 2025 15:40:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Miklos Szeredi <miklos@szeredi.hu>,
	Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] io_uring/uring_cmd: avoid double indirect call in
 task work dispatch
Message-ID: <20251023134047.GA24570@lst.de>
References: <20251022231326.2527838-1-csander@purestorage.com> <20251022231326.2527838-4-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022231326.2527838-4-csander@purestorage.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 22, 2025 at 05:13:26PM -0600, Caleb Sander Mateos wrote:
> io_uring task work dispatch makes an indirect call to struct io_kiocb's
> io_task_work.func field to allow running arbitrary task work functions.
> In the uring_cmd case, this calls io_uring_cmd_work(), which immediately
> makes another indirect call to struct io_uring_cmd's task_work_cb field.
> Introduce a macro DEFINE_IO_URING_CMD_TASK_WORK() to define a
> io_req_tw_func_t function wrapping an io_uring_cmd_tw_t. Convert the
> io_uring_cmd_tw_t function to the io_req_tw_func_t function in
> io_uring_cmd_complete_in_task() and io_uring_cmd_do_in_task_lazy().
> Use DEFINE_IO_URING_CMD_TASK_WORK() to define a io_req_tw_func_t
> function for each existing io_uring_cmd_tw_t function. Now uring_cmd
> task work dispatch makes a single indirect call to the io_req_tw_func_t
> wrapper function, which can inline the io_uring_cmd_tw_t function. This
> also allows removing the task_work_cb field from struct io_uring_cmd,
> freeing up some additional storage space.

Please just open code the logic instead of the symbol-hiding multi-level
macro indirection.  Everyone who will have to touch the code in the
future will thank you.


