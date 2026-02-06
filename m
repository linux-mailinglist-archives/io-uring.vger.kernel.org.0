Return-Path: <io-uring+bounces-12073-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OOx/EGabhWmUDwQAu9opvQ
	(envelope-from <io-uring+bounces-12073-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 08:42:30 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CC118FB157
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 08:42:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A5134300DD61
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 07:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4610326941;
	Fri,  6 Feb 2026 07:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1l4a5UiE"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C9232571A;
	Fri,  6 Feb 2026 07:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770363745; cv=none; b=bJNLxue7/LWgLjOkQiIzkMQYWr67ArpQKd5uVmikunP1TR15JXYfsPDAL+Xshg+zRvynZH5eA6gB2FzzYRYrXOD/2627hVvdjG9YQV7w1eeKxygrPmL7MGUDWdDzppBN4lhlM4sQ/OTR74YgHoKpLpYlIWTaWpOjMRtlDlOsDhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770363745; c=relaxed/simple;
	bh=WeVmhn33iwZYsaBPkxpYtNiRgSAWxahrvzcjNmwtGhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MvSfqW/9g7H6Hp6SUbVzQ1LemMLiU2RZSnAlMw27m9WRgDLtgA+1NzFPIU9lgog9i7GZfytRijkgU546zVZutgX1W0keIFXZIKxmmSlj+nV5voPREXtWDWDYp8gA4KJJV7AC3yQRg8Kf3zqM30Jq/hCmPWmecFis1S2v/O9iRmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1l4a5UiE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9Zu5Sn8tUPbS51W0jfTqrezTHnrJClgJeJJdhVN8z+Q=; b=1l4a5UiE4ghuKYHlKJdllioTt7
	ACusxxnnbzdcxSjFuLZD7lfcYlOSSKxdH8Ibk+tN9sXuTG9/aKNA5c54WCnlyErJFzRAB+9Zcrjg1
	COit7Ud0+mefdU+6Zht2Gp0p1JHLgw7sdgSWbIFU42RuKrjbR1M3ipyIXrhTIH8rFjRp9hTERSCyJ
	+m2Lc4a5yje6NwZ5RxxvtSh3Sn0b7B98YyCXBFjIhXRFwigTNYlyglxR7zRS/uTBkRgUo+OXPYQ4N
	KogCialo1FJGIitsThI/4xRmot+jwaJX1Y+/1Hr2IMmy3l9U+fYzENmubwkPksfoLzkbhLe9CFgRW
	iAAtSdaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1voGTt-0000000B08t-2jaW;
	Fri, 06 Feb 2026 07:42:21 +0000
Date: Thu, 5 Feb 2026 23:42:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, bschubert@ddn.com,
	csander@purestorage.com, krisman@suse.de, io-uring@vger.kernel.org,
	asml.silence@gmail.com, xiaobing.li@samsung.com,
	safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 00/25] fuse/io-uring: add kernel-managed buffer rings
 and zero-copy
Message-ID: <aYWbXV9pfyLwfy-t@infradead.org>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12073-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,ddn.com,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: CC118FB157
X-Rspamd-Action: no action

On Fri, Jan 16, 2026 at 03:30:19PM -0800, Joanne Koong wrote:
> This series adds buffer ring and zero-copy capabilities to fuse over io-uring.
> This requires adding a new kernel-managed buf (kmbuf) ring type to io-uring
> where the buffers are provided and managed by the kernel instead of by
> userspace.
> 
> On the io-uring side, the kmbuf interface is basically identical to pbufs.
> They differ mostly in how the memory region is set up and whether it is
> userspace or kernel that recycles back the buffer. Internally, the
> IOBL_KERNEL_MANAGED flag is used to mark the buffer ring as kernel-managed. 

Can you split that series out as it also has other applications
and smaller series might be easier to review?


