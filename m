Return-Path: <io-uring+bounces-1737-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7BD8BB7D9
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 01:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B1681F226C6
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D8851C2B;
	Fri,  3 May 2024 23:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ZKRWD2ib"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23561EA87;
	Fri,  3 May 2024 23:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714777411; cv=none; b=QhgFCp53+4M4T4pkFQJcgCTi9pVGNtTIfEaKipCUAgW+WGmtM3SMiut3g5L3R8qnulG8jip6tObEVuhdVRDGXX4W6SE3vF5tJ6foofDZR0KVOXWLeWZQFN+VADeIDETa7SDDG+Zr5v/Sk0H57MGg0+q8qbZPsfzsBS87dN3DN9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714777411; c=relaxed/simple;
	bh=KqEp4cDEXyDj5kpZyY+d8mwhPTn8pcxLOt8m2Wid2/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTXFetoakoM5sMyLNE0TvCQHUBiHbRz4sY4DTCHHfpaR9WEnJ2M5m0x9VkNLHaOTnAbDLLIJrLu1qQZKlp2rn3X42P5SUjiYgxtaAdOk9SiBXgHcVkDyOTG7b0FiMUNNvz8WoKUwp1E2Ack48BlY46RNEun1QqDV55BwLc41Q94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ZKRWD2ib; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cSDdKBLN0a5uI9scqsrmM49KsAV9URcP7+bHrbasnBA=; b=ZKRWD2ibo8voqmliDBcVDvN5cn
	/J5M/yDDbeZNdFnxzKaOxhsSkppprX3nENPQ0z3ugjwuDMe8tlOqb2H9u0+kPfmRHjzW0fkG5yIqK
	5oMf9bmXAKEj7jmrC9MBBwV0BQN7ufjs49HUQ5Wy/J9G7EnLMFlsSbDAMOO2TRReS+grtgUOcSqnR
	M6fY72Cud6MedRUa79lH44WMOzNeJnHRW2gs7c2goZq9n8vvF96i89CfhXI5/xAijTEX7PXVxsOZu
	mNJv9YI0vA9p2YJOkwZNX3RMTA7af85jNkMRbId/g0Q7XANJDk1Fv/AEo0Bggo7yTWSDvAtdOh+wY
	kTLCW7YA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1s31vy-00BEDK-1T;
	Fri, 03 May 2024 23:03:18 +0000
Date: Sat, 4 May 2024 00:03:18 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, axboe@kernel.dk,
	brauner@kernel.org, christian.koenig@amd.com,
	dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org,
	jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, minhquangbui99@gmail.com,
	sumit.semwal@linaro.org,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240503230318.GF2118490@ZenIV>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240503214531.GB2118490@ZenIV>
 <CAHk-=wgC+QpveKCJpeqsaORu7htoNNKA8mp+d9mvJEXmSKjhbw@mail.gmail.com>
 <202405031529.2CD1BFED37@keescook>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202405031529.2CD1BFED37@keescook>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Fri, May 03, 2024 at 03:46:25PM -0700, Kees Cook wrote:
> On Fri, May 03, 2024 at 02:52:38PM -0700, Linus Torvalds wrote:
> > That means that the file will be released - and it means that you have
> > violated all the refcounting rules for poll().
> 
> I feel like I've been looking at this too long. I think I see another
> problem here, but with dmabuf even when epoll is fixed:
> 
> dma_buf_poll()
> 	get_file(dmabuf->file)		/* f_count + 1 */
> 	dma_buf_poll_add_cb()
> 		dma_resv_for_each_fence ...
> 			dma_fence_add_callback(fence, ..., dma_buf_poll_cb)
> 
> dma_buf_poll_cb()
> 	...
>         fput(dmabuf->file);		/* f_count - 1 ... for each fence */
> 
> Isn't it possible to call dma_buf_poll_cb() (and therefore fput())
> multiple times if there is more than 1 fence? Perhaps I've missed a
> place where a single struct dma_resv will only ever signal 1 fence? But
> looking through dma_fence_signal_timestamp_locked(), I don't see
> anything about resv nor somehow looking into other fence cb_list
> contents...

At a guess,
                r = dma_fence_add_callback(fence, &dcb->cb, dma_buf_poll_cb);
		if (!r)
			return true;

prevents that - it returns 0 on success and -E... on error;
insertion into the list happens only when it's returning 0,
so...

