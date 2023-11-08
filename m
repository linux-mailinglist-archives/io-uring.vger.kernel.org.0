Return-Path: <io-uring+bounces-76-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E23F27E5B16
	for <lists+io-uring@lfdr.de>; Wed,  8 Nov 2023 17:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84197B20E45
	for <lists+io-uring@lfdr.de>; Wed,  8 Nov 2023 16:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408A830640;
	Wed,  8 Nov 2023 16:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IX/wuGmX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E8JDMLiA"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9229519440
	for <io-uring@vger.kernel.org>; Wed,  8 Nov 2023 16:23:16 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028BDC6;
	Wed,  8 Nov 2023 08:23:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 95C1F2195D;
	Wed,  8 Nov 2023 16:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1699460594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oyBdvJIFS+sJEDku7JICBNFn+CInwPDtLxks2TC62yw=;
	b=IX/wuGmXcpHmD5MnTvA1IsGnFw0EtNztomIAjmzEEgQlb2AuIZR0f8jVwRWD/65TIZsLqv
	oIBwCbNrhkdHljEaVNHkcPxS910sDwQsQtic6fqlPzTApYuplGuxNo8uJPY1kp+QjJd5tm
	n2t5f3TMD0jUwsBQ4QwHRtrV4GA5a8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1699460594;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oyBdvJIFS+sJEDku7JICBNFn+CInwPDtLxks2TC62yw=;
	b=E8JDMLiAao4HEB6C1il3ejH1wiIMUE6M/T1ffRyRpZ+cZd1J8YnE1+H7YRUAwCYJ64UQos
	TL4q6b56maUAE2AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5FF7A133F5;
	Wed,  8 Nov 2023 16:23:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id cfLdEfK1S2VdIAAAMHmgww
	(envelope-from <krisman@suse.de>); Wed, 08 Nov 2023 16:23:14 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: axboe@kernel.dk,  asml.silence@gmail.com,  linux-kernel@vger.kernel.org,
  io-uring@vger.kernel.org,  kun.dou@samsung.com,  peiwei.li@samsung.com,
  joshi.k@samsung.com,  kundan.kumar@samsung.com,  wenwen.chen@samsung.com,
  ruyi.zhang@samsung.com
Subject: Re: [PATCH v2] io_uring: Statistics of the true utilization of sq
 threads.
In-Reply-To: <20231108080732.15587-1-xiaobing.li@samsung.com> (Xiaobing Li's
	message of "Wed, 8 Nov 2023 16:07:32 +0800")
References: <CGME20231108081516epcas5p442a11004e3b4e6339972fd6da4c6692b@epcas5p4.samsung.com>
	<20231108080732.15587-1-xiaobing.li@samsung.com>
Date: Wed, 08 Nov 2023 11:23:13 -0500
Message-ID: <877cmsb4em.fsf@>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Xiaobing Li <xiaobing.li@samsung.com> writes:

> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index f04a43044d91..f0b79c533062 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -213,6 +213,12 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>  
>  	}
>  
> +	if (ctx->sq_data) {
> +		seq_printf(m, "PID:\t%d\n", task_pid_nr(ctx->sq_data->thread));

ctx->sq_data and sq_data->thread can become NULL if the queue is being
setup/going away. You need to hold the uring_lock and the
ctx->sq_data->lock to access this.

But task_pid_nr is already published in this file a bit before this
hunk.  Perhaps drop this line and move the two lines below together with
them.

> +		seq_printf(m, "work:\t%lu\n", ctx->sq_data->work);
> +		seq_printf(m, "total:\t%lu\n", ctx->sq_data->total);
> +	}

-- 
Gabriel Krisman Bertazi

