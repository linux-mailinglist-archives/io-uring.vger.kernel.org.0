Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEFD74EDDD
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 14:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjGKMQB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 08:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjGKMQA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 08:16:00 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F9FE49;
        Tue, 11 Jul 2023 05:15:59 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id BDB06C021; Tue, 11 Jul 2023 14:15:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1689077757; bh=k5IrJpC7AJwyZnqsuHTFXVm/Uxq8EIbx+adGlhfNRrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WGPhNSaNoZj09Q4t+4aLjQ2lQZAJ60IYHsPQ3UaJwlENG4cEfglKUgR/IhbjyXZLE
         hYPi+Jm0VuYnPT5PZCkvsKm2s46Q3nbYzEmVUJAI0ld6M1b9sxLDwb5siK69wwli99
         fv+g3knrf6JhhIeEvilreQG6mKSgPor8zdZQt2W+RiVwqyl+7QBmBduMnIoEoUmlne
         H4+MH+P4U4tWFf3aQRyEQT+9tUq9aU4zzfUkucfcxMZAulLDln9f458TWPWzaMnV7u
         Kv3bBxPz3vN/uWC+cDX6u0Nob0CVa0GU2k8RMhm/NfDjblTsJKAZCJXsEeLTrI0nw9
         McKi+wvEiQ/Zw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 5F938C009;
        Tue, 11 Jul 2023 14:15:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1689077756; bh=k5IrJpC7AJwyZnqsuHTFXVm/Uxq8EIbx+adGlhfNRrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Ta6m3rAzN2recoaSTDB4HjUbWZ8fWFEQuzTvbv8y624EE+fYNZub28P0B75l60q5
         sp/hLkbKHmdfb/D6gfZeziCv4taFbWFFqOjH4e+28hRsk5hQWTPRuuxDu9VbuJv1d9
         ViV7mmTRPWh/BqNB005mQmQpUIlgmHO505Kqh4VBKlk7PrEaXf4JhmzgY0tiOWJmDj
         LCAIm6cNTlc+9UURCAtiw75Jh1kWVjKTlho2jbokvsjUDhE13FgRYgCpKMoK9aoajG
         IqPwVzsmfu2R/badNLFqxVbLWcYDi8PzDSvPrfNwfDqGsB6vAvY3skl/44fEaXzEHV
         nV7ByuT6qUIBQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 3941fd91;
        Tue, 11 Jul 2023 12:15:50 +0000 (UTC)
Date:   Tue, 11 Jul 2023 21:15:35 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 3/3] io_uring: add support for getdents
Message-ID: <ZK1H568bvIzcsB6J@codewreck.org>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-4-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230711114027.59945-4-hao.xu@linux.dev>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hao Xu wrote on Tue, Jul 11, 2023 at 07:40:27PM +0800:
> diff --git a/io_uring/fs.c b/io_uring/fs.c
> index f6a69a549fd4..77f00577e09c 100644
> --- a/io_uring/fs.c
> +++ b/io_uring/fs.c
> @@ -291,3 +298,56 @@ void io_link_cleanup(struct io_kiocb *req)
>  	putname(sl->oldpath);
>  	putname(sl->newpath);
>  }
> +
> +int io_getdents_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
> +
> +	if (READ_ONCE(sqe->off) != 0)
> +		return -EINVAL;
> +
> +	gd->dirent = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	gd->count = READ_ONCE(sqe->len);
> +
> +	return 0;
> +}
> +
> +int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
> +	struct file *file;
> +	unsigned long getdents_flags = 0;
> +	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> +	bool should_lock = false;
> +	int ret;
> +
> +	if (force_nonblock) {
> +		if (!(req->file->f_mode & FMODE_NOWAIT))
> +			return -EAGAIN;
> +
> +		getdents_flags = DIR_CONTEXT_F_NOWAIT;
> +	}
> +
> +	file = req->file;
> +	if (file && (file->f_mode & FMODE_ATOMIC_POS)) {

If file is NULL here things will just blow up in vfs_getdents anyway,
let's remove the useless check

> +		if (file_count(file) > 1)

I was curious about this so I found it's basically what __fdget_pos does
before deciding it should take the f_pos_lock, and as such this is
probably correct... But if someone can chime in here: what guarantees
someone else won't __fdget_pos (or equivalent through this) the file
again between this and the vfs_getdents call?
That second get would make file_count > 1 and it would lock, but lock
hadn't been taken here so the other call could get the lock without
waiting and both would process getdents or seek or whatever in
parallel.


That aside I don't see any obvious problem with this.

-- 
Dominique Martinet | Asmadeus
