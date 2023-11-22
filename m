Return-Path: <io-uring+bounces-134-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0D7B7F49C4
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 16:06:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A602816CA
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 15:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C95A4F202;
	Wed, 22 Nov 2023 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZcrRoEFw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LyVeT+mO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6EFA3;
	Wed, 22 Nov 2023 07:05:40 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6C86A1F8D9;
	Wed, 22 Nov 2023 15:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1700665539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mhP7e+31Z9+nB58srBCpzmS+Md5+Kp/dzX7wM4wK75A=;
	b=ZcrRoEFwpxJc4wiCEvI5Z6vwSDJRa19aPELohVHLwMcw/gKwapwnuXIaHRJa9vJ+tGL1AJ
	Ls/CVRotqPlYPG1beOQ8VFeXwe0gt0ftJwH4JcQAtaS9xH9WKxGamyRLuJd3y322CCYv9r
	qS0Bj5Pp3oItCpC7oV5QKyBTiYqDYO0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1700665539;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mhP7e+31Z9+nB58srBCpzmS+Md5+Kp/dzX7wM4wK75A=;
	b=LyVeT+mOky5Yb8PakQHBxFNY5YlaGwagm+iIpbHOizt4yAof2fpPH820159ugYTF4DZisp
	oyqigpl/uBuPcDAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5F6AE13461;
	Wed, 22 Nov 2023 15:05:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 1XhFF8MYXmVqGgAAMHmgww
	(envelope-from <jack@suse.cz>); Wed, 22 Nov 2023 15:05:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F216FA07DC; Wed, 22 Nov 2023 16:05:38 +0100 (CET)
Date: Wed, 22 Nov 2023 16:05:38 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>, Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
	Oded Gabbay <ogabbay@kernel.org>, Wu Hao <hao.wu@intel.com>,
	Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Xu Yilun <yilun.xu@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhi Wang <zhi.a.wang@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Frederic Barrat <fbarrat@linux.ibm.com>,
	Andrew Donnellan <ajd@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Eric Farman <farman@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Diana Craciun <diana.craciun@oss.nxp.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>, Fei Li <fei1.li@intel.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-fpga@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	linux-usb@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-aio@kvack.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 3/4] eventfd: simplify eventfd_signal_mask()
Message-ID: <20231122150538.6zwikm3tymnkcdxf@quack3>
References: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
 <20231122-vfs-eventfd-signal-v2-3-bd549b14ce0c@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231122-vfs-eventfd-signal-v2-3-bd549b14ce0c@kernel.org>
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -6.30
X-Spamd-Result: default: False [-6.30 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 RCVD_TLS_ALL(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 R_RATELIMIT(0.00)[to_ip_from(RLmoeddzf3hfwy788do41yajib)];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_GT_50(0.00)[78];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_COUNT_TWO(0.00)[2];
	 FREEMAIL_CC(0.00)[vger.kernel.org,lst.de,suse.cz,redhat.com,google.com,linutronix.de,alien8.de,linux.intel.com,kernel.org,infradead.org,xen.org,intel.com,gmail.com,ffwll.ch,ziepe.ca,linux.ibm.com,arndb.de,linuxfoundation.org,linux.alibaba.com,oss.nxp.com,kvack.org,cmpxchg.org,linux.dev,nvidia.com,lists.freedesktop.org,lists.ozlabs.org,lists.linux-foundation.org,kernel.dk];
	 SUSPICIOUS_RECIPS(1.50)[]

On Wed 22-11-23 13:48:24, Christian Brauner wrote:
> The eventfd_signal_mask() helper was introduced for io_uring and similar
> to eventfd_signal() it always passed 1 for @n. So don't bother with that
> argument at all.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Nice. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/eventfd.c            | 7 ++++---
>  include/linux/eventfd.h | 5 ++---
>  io_uring/io_uring.c     | 4 ++--
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index dc9e01053235..a9a6de920fb4 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -43,9 +43,10 @@ struct eventfd_ctx {
>  	int id;
>  };
>  
> -__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
> +__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask)
>  {
>  	unsigned long flags;
> +	__u64 n = 1;
>  
>  	/*
>  	 * Deadlock or stack overflow issues can happen if we recurse here
> @@ -68,7 +69,7 @@ __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
>  	current->in_eventfd = 0;
>  	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
>  
> -	return n;
> +	return n == 1;
>  }
>  
>  /**
> @@ -84,7 +85,7 @@ __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
>   */
>  __u64 eventfd_signal(struct eventfd_ctx *ctx)
>  {
> -	return eventfd_signal_mask(ctx, 1, 0);
> +	return eventfd_signal_mask(ctx, 0);
>  }
>  EXPORT_SYMBOL_GPL(eventfd_signal);
>  
> diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
> index 562089431551..4f8aac7eb62a 100644
> --- a/include/linux/eventfd.h
> +++ b/include/linux/eventfd.h
> @@ -36,7 +36,7 @@ struct file *eventfd_fget(int fd);
>  struct eventfd_ctx *eventfd_ctx_fdget(int fd);
>  struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
>  __u64 eventfd_signal(struct eventfd_ctx *ctx);
> -__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask);
> +__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask);
>  int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
>  				  __u64 *cnt);
>  void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
> @@ -63,8 +63,7 @@ static inline int eventfd_signal(struct eventfd_ctx *ctx)
>  	return -ENOSYS;
>  }
>  
> -static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n,
> -				      unsigned mask)
> +static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, unsigned mask)
>  {
>  	return -ENOSYS;
>  }
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ed254076c723..70170a41eac4 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -558,7 +558,7 @@ static void io_eventfd_ops(struct rcu_head *rcu)
>  	int ops = atomic_xchg(&ev_fd->ops, 0);
>  
>  	if (ops & BIT(IO_EVENTFD_OP_SIGNAL_BIT))
> -		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
> +		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
>  
>  	/* IO_EVENTFD_OP_FREE_BIT may not be set here depending on callback
>  	 * ordering in a race but if references are 0 we know we have to free
> @@ -594,7 +594,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
>  		goto out;
>  
>  	if (likely(eventfd_signal_allowed())) {
> -		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
> +		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
>  	} else {
>  		atomic_inc(&ev_fd->refs);
>  		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops))
> 
> -- 
> 2.42.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

