Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5688079C4B4
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 06:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjILEXM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Sep 2023 00:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbjILEWy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Sep 2023 00:22:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920556CDC
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 18:54:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7E8741F88C;
        Mon, 11 Sep 2023 23:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694476651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jhU9HKQiPt7pZksHp6Ye7B0tGsjCWU2hWQTQE6oDWT4=;
        b=Y7vvpNEwhLN/WqJB38M/omvNVo48X2GvbO92dTP1yWWc80ft2YAuk8n0yRHwziHXdg1aFs
        /hgU1bu7Y9xjzT0RYAM1fCLObGTnOjirczYb1ARvzrqHOIdx0z1xqvR6SXKF1qpkhqRLyv
        H6XBshCMCY/+AfPA1KOguU67zZ84jKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694476651;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jhU9HKQiPt7pZksHp6Ye7B0tGsjCWU2hWQTQE6oDWT4=;
        b=A9ZfdEChPHcXEg7Hc8PwT+PbtUZ7iJ+uPfcZbE0N23Ddpgpvr7QGQRFbP4r/5bnOZSM3UM
        01YgF2nQElCgSyDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 498B51353E;
        Mon, 11 Sep 2023 23:57:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WuhuDGup/2S/RwAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 11 Sep 2023 23:57:31 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com
Subject: Re: [PATCH 3/3] io_uring/rw: add support for IORING_OP_READ_MULTISHOT
In-Reply-To: <20230911204021.1479172-4-axboe@kernel.dk> (Jens Axboe's message
        of "Mon, 11 Sep 2023 14:40:21 -0600")
References: <20230911204021.1479172-1-axboe@kernel.dk>
        <20230911204021.1479172-4-axboe@kernel.dk>
Date:   Mon, 11 Sep 2023 19:57:30 -0400
Message-ID: <87o7i85klx.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> This behaves like IORING_OP_READ, except:
>
> 1) It only supports pollable files (eg pipes, sockets, etc). Note that
>    for sockets, you probably want to use recv/recvmsg with multishot
>    instead.
>
> 2) It supports multishot mode, meaning it will repeatedly trigger a
>    read and fill a buffer when data is available. This allows similar
>    use to recv/recvmsg but on non-sockets, where a single request will
>    repeatedly post a CQE whenever data is read from it.
>
> 3) Because of #2, it must be used with provided buffers. This is
>    uniformly true across any request type that supports multishot and
>    transfers data, with the reason being that it's obviously not
>    possible to pass in a single buffer for the data, as multiple reads
>    may very well trigger before an application has a chance to process
>    previous CQEs and the data passed from them.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

This is a really cool feature.  Just two comments inline.


> +/*
> + * Multishot read is prepared just like a normal read/write request, only
> + * difference is that we set the MULTISHOT flag.
> + */
> +int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	int ret;
> +
> +	ret = io_prep_rw(req, sqe);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	req->flags |= REQ_F_APOLL_MULTISHOT;
> +	return 0;
> +}
> +
>  void io_readv_writev_cleanup(struct io_kiocb *req)
>  {
>  	struct io_async_rw *io = req->async_data;
> @@ -869,6 +885,56 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
>  	return kiocb_done(req, ret, issue_flags);
>  }
>  
> +int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	unsigned int cflags = 0;
> +	int ret;
> +
> +	/*
> +	 * Multishot MUST be used on a pollable file
> +	 */
> +	if (!file_can_poll(req->file))
> +		return -EBADFD;

io_uring is pollable, so I think you want to also reject when
req->file->f_ops == io_uring_fops to avoid the loop where a ring
monitoring itself will cause a recursive completion? Maybe this can't
happen here for some reason I miss?

> +
> +	ret = __io_read(req, issue_flags);
> +
> +	/*
> +	 * If we get -EAGAIN, recycle our buffer and just let normal poll
> +	 * handling arm it.
> +	 */
> +	if (ret == -EAGAIN) {
> +		io_kbuf_recycle(req, issue_flags);
> +		return -EAGAIN;
> +	}
> +
> +	/*
> +	 * Any error will terminate a multishot request
> +	 */
> +	if (ret <= 0) {
> +finish:
> +		io_req_set_res(req, ret, cflags);
> +		if (issue_flags & IO_URING_F_MULTISHOT)
> +			return IOU_STOP_MULTISHOT;
> +		return IOU_OK;

Just a style detail, but I'd prefer to unfold this on the end of the function
instead of jumping backwards here..

> +	}
> +
> +	/*
> +	 * Put our buffer and post a CQE. If we fail to post a CQE, then
> +	 * jump to the termination path. This request is then done.
> +	 */
> +	cflags = io_put_kbuf(req, issue_flags);
> +
> +	if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
> +				ret, cflags | IORING_CQE_F_MORE)) {
> +		if (issue_flags & IO_URING_F_MULTISHOT)
> +			return IOU_ISSUE_SKIP_COMPLETE;
> +		else
> +			return -EAGAIN;
> +	}
> +
> +	goto finish;
> +}
> +
>  int io_write(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> diff --git a/io_uring/rw.h b/io_uring/rw.h
> index 4b89f9659366..c5aed03d42a4 100644
> --- a/io_uring/rw.h
> +++ b/io_uring/rw.h
> @@ -23,3 +23,5 @@ int io_writev_prep_async(struct io_kiocb *req);
>  void io_readv_writev_cleanup(struct io_kiocb *req);
>  void io_rw_fail(struct io_kiocb *req);
>  void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts);
> +int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
> +int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags);

-- 
Gabriel Krisman Bertazi
