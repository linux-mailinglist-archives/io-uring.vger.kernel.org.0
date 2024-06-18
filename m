Return-Path: <io-uring+bounces-2249-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA67990DA8B
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 19:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D5F9282582
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 17:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 382B213DB8D;
	Tue, 18 Jun 2024 17:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/glrhDY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEC92139DD;
	Tue, 18 Jun 2024 17:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718731534; cv=none; b=LFZLaEpcbdOynF2a4T2bY7xrgAwdXy/yQtXph5bWT2VwhlVeuAQn/5cOVcB2v/EE39RixHlav5lr/gDxi1CFUxu55kcnHbnh2Pqlcyekzxt3UaHAeRs8q0M9a6VyseLpEpz9L4AFuQZnq02H72IuO/MM1aaWHa4UO3F7zDC2vSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718731534; c=relaxed/simple;
	bh=9WtmB9Bn0bftxKxvR8395pd356hshFubR0WI4s7a7NQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dbTxXiAhiy1mt+13cWbSEofpHoU1BTJi4zMLCiPJWBS/SzDNAJPPjxUMCsRn45iFYacSKU2IE99ehUjfO3AeVTMrXA/hBEy7HAOVPX+uFj9HfGXaGqHbkccLVFVVPoiidh0lxGwkw2eJN911DfySQzd0oUOGxIkRBn/WC+q0Ylk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L/glrhDY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC4AC3277B;
	Tue, 18 Jun 2024 17:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718731533;
	bh=9WtmB9Bn0bftxKxvR8395pd356hshFubR0WI4s7a7NQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L/glrhDYm4sY+aW6Z7pWsticv8PewU9RhtaYYM2XXCXyQ7dJn+bapDjh1iVAIjRrm
	 piW4D1gKTzDt5/l4zvkKQZd0ituyOTiYFBFUrZj3cl3kj9qCzTOuKdBYTrjdfDqvHf
	 nw2tYUPmW/v+qurual1veLYcOf4R5ngMB1OFAzv5aGGzHXY83G9L75JQT5CeaVBtod
	 2vadkoi5t1N78i5jAUnEDEN/yOnXJn4a4rZtBDP63+dfj4QXWar7NBEGVqaB3yJ/I/
	 UbiWMjl6sosNLYMm1qGpqwcWgkWXMfAe7m8B6h7YzteDo5W9fG1kRjVrdUPgtl0jbw
	 nYq5nfgtQA4zA==
Date: Tue, 18 Jun 2024 11:25:29 -0600
From: Keith Busch <kbusch@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, djwong@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	hare@suse.de, Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v8 05/10] block: Add core atomic write support
Message-ID: <ZnHDCYiRA9EvuLTc@kbusch-mbp.dhcp.thefacebook.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
 <20240610104329.3555488-6-john.g.garry@oracle.com>
 <ZnCGwYomCC9kKIBY@kbusch-mbp.dhcp.thefacebook.com>
 <20240618065112.GB29009@lst.de>
 <91e9bbe3-75cf-4874-9d64-0785f7ea21d9@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91e9bbe3-75cf-4874-9d64-0785f7ea21d9@oracle.com>

On Tue, Jun 18, 2024 at 08:46:31AM +0100, John Garry wrote:
> 
> About NVMe, the spec says that NABSN and NOIOB may not be related to one
> another (command set spec 1.0d 5.8.2.1), but I am wondering if people really
> build HW which would have different NABSN/NABSPF and NOIOB. I don't know.

The history of NOIOB is from an nvme drive that had two back-end
controllers with their own isolated storage, and then striped together
on the front end for the host to see. A command crossing the stripe
boundary takes a slow path to split it for each backend controller's
portion and merge the results. Subsequent implementations may have
different reasons for advertising this boundary, but that was the
original.

Anyway, there was an idea that the stripe size could be user
configurable, though that never shipped as far as I know. If it had,
then the optimal NOIOB could be made larger, but the atomic write size
doesn't change.

