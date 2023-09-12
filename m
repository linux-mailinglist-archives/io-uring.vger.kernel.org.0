Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFCD079D8D2
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 20:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjILSj0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Sep 2023 14:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236494AbjILSj0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Sep 2023 14:39:26 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09350189
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 11:39:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 94CA221835;
        Tue, 12 Sep 2023 18:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694543960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AvGYMvL+xmzOwL9uFrgAegwwPLfkgqQKLwDK4R25wXw=;
        b=ck6cN+La3X0NQfmVqkgrQ2A4+9IjwMxD5nG8jeUXrwHhr+37bxDvuqY9jAA7McF4i53voR
        pQYdOhbQzgNwm7ttBD76Li+vWuFPpQavS+BVIHqe8ZV13Ul65hxFi7uOvPCyiCzFejsO5P
        rc7eIrM8s6uz8hxNygxZf2cflXu6C+g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694543960;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AvGYMvL+xmzOwL9uFrgAegwwPLfkgqQKLwDK4R25wXw=;
        b=dUVEg+/FA8Ms62FVyxvJBMU4BPFtlrehHJZbmGgnK155nDkQ3MMBD4kyiLhAHaxsvc9aUY
        uQVz6a5oZ0Y759AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4987F139DB;
        Tue, 12 Sep 2023 18:39:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1vX+CViwAGVcUAAAMHmgww
        (envelope-from <krisman@suse.de>); Tue, 12 Sep 2023 18:39:20 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com
Subject: Re: [PATCHSET v2 0/3] Add support for multishot reads
In-Reply-To: <20230912172458.1646720-1-axboe@kernel.dk> (Jens Axboe's message
        of "Tue, 12 Sep 2023 11:24:55 -0600")
References: <20230912172458.1646720-1-axboe@kernel.dk>
Date:   Tue, 12 Sep 2023 14:39:18 -0400
Message-ID: <871qf3utgp.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> Hi,
>
> We support multishot for other request types, generally in the shape of
> a flag for the request. Doing a flag based approach with reads isn't
> straightforward, as the read/write flags are in the RWF_ space. Instead,
> add a separate opcode for this, IORING_OP_READ_MULTISHOT.
>
> This can only be used provided buffers, like other multishot request
> types that read/receive data.
>
> It can also only be used for pollable file types, like a tun device or
> pipes, for example. File types that are always readable (or seekable),
> like regular files, cannot be used with multishot reads.
>
> This is based on the io_uring-futex branch (which, in turn, is based on
> the io_uring-waitid branch). No dependencies as such between them,
> except the opcode numbering.
>
> Can also be found here:
>
> https://git.kernel.dk/cgit/linux/log/?h=io_uring-mshot-read
>
> and there's a liburing branch with some basic support and some test
> cases here:
>
> https://git.kernel.dk/cgit/liburing/log/?h=read-mshot

Hey Jens,

For the entire series, feel free to take:

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


-- 
Gabriel Krisman Bertazi
