Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB211C62AB
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2020 23:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgEEVKe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 17:10:34 -0400
Received: from bonobo.elm.relay.mailchannels.net ([23.83.212.22]:6549 "EHLO
        bonobo.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728076AbgEEVKe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 May 2020 17:10:34 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id E4934217C5;
        Tue,  5 May 2020 21:10:32 +0000 (UTC)
Received: from pdx1-sub0-mail-a81.g.dreamhost.com (100-96-14-72.trex.outbound.svc.cluster.local [100.96.14.72])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id D2E4121571;
        Tue,  5 May 2020 21:10:31 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a81.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Tue, 05 May 2020 21:10:32 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Dime-Belong: 0e93ce12409d9a2c_1588713032364_388507154
X-MC-Loop-Signature: 1588713032363:3409722952
X-MC-Ingress-Time: 1588713032363
Received: from pdx1-sub0-mail-a81.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a81.g.dreamhost.com (Postfix) with ESMTP id 772E97F54F;
        Tue,  5 May 2020 14:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=claycon.org; bh=STzotpNkYuoHScArrDXLcdtc0xg=; b=
        GG+21uGOy/pgyKuWGO4rQksDL8rwHBhH9Pc7xd1fHyenhBcRa2Sdq9skbUrz7crV
        JGAIRUyQ0e/sv9xrNWP+r64HR1WQ9soDr8KbgOsZ/nElw5q/ko/DZM4bGEnrLt9v
        KRLwATBTJRYS6gsdqfVIVUYSLmT4qDMvzP0fzw9jG8M=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a81.g.dreamhost.com (Postfix) with ESMTPSA id 8D7E87F0EF;
        Tue,  5 May 2020 14:10:29 -0700 (PDT)
Date:   Tue, 5 May 2020 16:10:29 -0500
X-DH-BACKEND: pdx1-sub0-mail-a81
From:   Clay Harris <bugs@claycon.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-5.7] splice: move f_mode checks to do_{splice,tee}()
Message-ID: <20200505211029.azfj2c4scoh6x2kx@ps29521.dreamhostps.com>
References: <51b4370ef70eebf941f6cef503943d7f7de3ea4d.1588621153.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51b4370ef70eebf941f6cef503943d7f7de3ea4d.1588621153.git.asml.silence@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrjeejgddvvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqeenucggtffrrghtthgvrhhnpefgtdekjeehffefvdfhhedttdehkeejgfegiedtjedthfeuvdfgieevkeekvdfhvdenucfkphepieelrdduieefrddukeeirdejgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehpshdvleehvddurdgurhgvrghmhhhoshhtphhsrdgtohhmpdhinhgvthepieelrdduieefrddukeeirdejgedprhgvthhurhhnqdhprghthhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqpdhmrghilhhfrhhomhepsghughhssegtlhgrhigtohhnrdhorhhgpdhnrhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 04 2020 at 22:39:35 +0300, Pavel Begunkov quoth thus:

> do_splice() is used by io_uring, as will be do_tee(). Move f_mode
> checks from sys_{splice,tee}() to do_{splice,tee}(), so they're
> enforced for io_uring as well.

I'm not seeing any check against splicing a pipe to itself in the
io_uring path, although maybe I just missed it.  As the comment
below says: /* Splicing to self would be fun, but... */ .

> Fixes: 7d67af2c0134 ("io_uring: add splice(2) support")
> Reported-by: Jann Horn <jannh@google.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/splice.c | 45 ++++++++++++++++++---------------------------
>  1 file changed, 18 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/splice.c b/fs/splice.c
> index 4735defc46ee..fd0a1e7e5959 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1118,6 +1118,10 @@ long do_splice(struct file *in, loff_t __user *off_in,
>  	loff_t offset;
>  	long ret;
>  
> +	if (unlikely(!(in->f_mode & FMODE_READ) ||
> +		     !(out->f_mode & FMODE_WRITE)))
> +		return -EBADF;
> +
>  	ipipe = get_pipe_info(in);
>  	opipe = get_pipe_info(out);
>  
> @@ -1125,12 +1129,6 @@ long do_splice(struct file *in, loff_t __user *off_in,
>  		if (off_in || off_out)
>  			return -ESPIPE;
>  
> -		if (!(in->f_mode & FMODE_READ))
> -			return -EBADF;
> -
> -		if (!(out->f_mode & FMODE_WRITE))
> -			return -EBADF;
> -
>  		/* Splicing to self would be fun, but... */
>  		if (ipipe == opipe)
>  			return -EINVAL;
> @@ -1153,9 +1151,6 @@ long do_splice(struct file *in, loff_t __user *off_in,
>  			offset = out->f_pos;
>  		}
>  
> -		if (unlikely(!(out->f_mode & FMODE_WRITE)))
> -			return -EBADF;
> -
>  		if (unlikely(out->f_flags & O_APPEND))
>  			return -EINVAL;
>  
> @@ -1440,15 +1435,11 @@ SYSCALL_DEFINE6(splice, int, fd_in, loff_t __user *, off_in,
>  	error = -EBADF;
>  	in = fdget(fd_in);
>  	if (in.file) {
> -		if (in.file->f_mode & FMODE_READ) {
> -			out = fdget(fd_out);
> -			if (out.file) {
> -				if (out.file->f_mode & FMODE_WRITE)
> -					error = do_splice(in.file, off_in,
> -							  out.file, off_out,
> -							  len, flags);
> -				fdput(out);
> -			}
> +		out = fdget(fd_out);
> +		if (out.file) {
> +			error = do_splice(in.file, off_in, out.file, off_out,
> +					  len, flags);
> +			fdput(out);
>  		}
>  		fdput(in);
>  	}
> @@ -1770,6 +1761,10 @@ static long do_tee(struct file *in, struct file *out, size_t len,
>  	struct pipe_inode_info *opipe = get_pipe_info(out);
>  	int ret = -EINVAL;
>  
> +	if (unlikely(!(in->f_mode & FMODE_READ) ||
> +		     !(out->f_mode & FMODE_WRITE)))
> +		return -EBADF;
> +
>  	/*
>  	 * Duplicate the contents of ipipe to opipe without actually
>  	 * copying the data.
> @@ -1795,7 +1790,7 @@ static long do_tee(struct file *in, struct file *out, size_t len,
>  
>  SYSCALL_DEFINE4(tee, int, fdin, int, fdout, size_t, len, unsigned int, flags)
>  {
> -	struct fd in;
> +	struct fd in, out;
>  	int error;
>  
>  	if (unlikely(flags & ~SPLICE_F_ALL))
> @@ -1807,14 +1802,10 @@ SYSCALL_DEFINE4(tee, int, fdin, int, fdout, size_t, len, unsigned int, flags)
>  	error = -EBADF;
>  	in = fdget(fdin);
>  	if (in.file) {
> -		if (in.file->f_mode & FMODE_READ) {
> -			struct fd out = fdget(fdout);
> -			if (out.file) {
> -				if (out.file->f_mode & FMODE_WRITE)
> -					error = do_tee(in.file, out.file,
> -							len, flags);
> -				fdput(out);
> -			}
> +		out = fdget(fdout);
> +		if (out.file) {
> +			error = do_tee(in.file, out.file, len, flags);
> +			fdput(out);
>  		}
>   		fdput(in);
>   	}
> -- 
> 2.24.0
