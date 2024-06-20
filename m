Return-Path: <io-uring+bounces-2301-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 251A4911232
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 21:34:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CEFA11F22347
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 19:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A1F1B5838;
	Thu, 20 Jun 2024 19:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PRKfXkgc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CF81AC765;
	Thu, 20 Jun 2024 19:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718912089; cv=none; b=A+ITdyj80xtcejEzQ+53vxmBNE8hrvVKutcKrcmcZdClA4ryfUCHZg8GfSC5HCah5PymcR1XPds26fD0cjRFbqLoqn3tsIM8K3n1YxYUZIQd0YskdPC0DKW/XkGl7lH6h7vXPTiQgzwvWVRrJrjbmTyjZ3tnQXshU60N2h7Qe5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718912089; c=relaxed/simple;
	bh=1EGjSaAkB1YQJOO1prnZTUFPyCHdfm5b919dIp24FJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkBC4OhJNp8L5EhRUXWClVG6wJIhqr/vnK4VnJQj1gRNnObpSWsZE36gSH+mtL/1DbxZbNv/MpcWD6/TTf8w4Iq1TVR93YIHbkeg/YEylmkKqJ7erTvnrpNkAGuNHudcVmBQ2QhlDzazGZLIway/Iz14bnZ5MpmZBy4Dhi/QAaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PRKfXkgc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A067CC2BD10;
	Thu, 20 Jun 2024 19:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718912088;
	bh=1EGjSaAkB1YQJOO1prnZTUFPyCHdfm5b919dIp24FJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PRKfXkgc9QX7uPw61LGjpNWTKFSnEvisLeeJ/jTuz3AlgVK5rZj+f416vTlxlfL4R
	 8ZSA11NPqYTmf9X3HqhH6dY0k0UxNjhydixn/yvQwm4+aMmjIjJQ4KXiSe/4HY9irT
	 b1ZiQexo81F8+3U2t+EFK3YFI0lIJkCeLxowhtsozJTc04q7pOeft0I4MtfmZb6uWF
	 B2iv5exJ7Su7K4Q4Irly6yi7k8d8oap8EScPr7QKh59iZnxxgG+sFjpgmidsuvxvhn
	 94jqdu7GWPELvtUwzkEr1NeeES/MNOCbtLW5CX1dNx0PtrRd9ea7rmP8n/MqZaPGYM
	 iK0FJ/Nhozd4g==
Date: Thu, 20 Jun 2024 13:34:44 -0600
From: Keith Busch <kbusch@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
	djwong@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	hare@suse.de, Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [Patch v9 05/10] block: Add core atomic write support
Message-ID: <ZnSEVDIvcf-T-VhF@kbusch-mbp.dhcp.thefacebook.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-6-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620125359.2684798-6-john.g.garry@oracle.com>

On Thu, Jun 20, 2024 at 12:53:54PM +0000, John Garry wrote:
> Add atomic write support, as follows:
> - add helper functions to get request_queue atomic write limits
> - report request_queue atomic write support limits to sysfs and update Doc
> - support to safely merge atomic writes
> - deal with splitting atomic writes
> - misc helper functions
> - add a per-request atomic write flag

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

