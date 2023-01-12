Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296E9667D57
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 19:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238814AbjALSDv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 13:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbjALSCg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 13:02:36 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227AF5832D;
        Thu, 12 Jan 2023 09:26:04 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 77A4D5BDE4;
        Thu, 12 Jan 2023 17:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673544363; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=13mFpbAeeYwt0IwkwBLytkgPA4Usq0Z/P4b7FvTHZQM=;
        b=rTKHe3GU6XbeSqAawnhZSLi6p54Kb5E2qYI/xtRYsK4af7OwIUBZU3Gj8oCsNeYjuMGcpO
        hIMc4u6i657AesvbiuLq+9S/ScGHuPth148Obo6ocuqEM9WgOHz7DGjOOIxcrDBvaX8OXQ
        uU8IChx0ofV9TISxH72TT7jyV6bES7E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673544363;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=13mFpbAeeYwt0IwkwBLytkgPA4Usq0Z/P4b7FvTHZQM=;
        b=QzXAGegBDUHxE2R9W2/gozyBw28D8YhcSt59GkK42hm3oSZzSqY+iPnXtJSN4f77WIV1PD
        nqSr7ZMWU25JRDDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EF5D813776;
        Thu, 12 Jan 2023 17:26:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3MOcLKpCwGOAYAAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 12 Jan 2023 17:26:02 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Breno Leitao <leitao@debian.org>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: Re: [PATCH liburing v1 4/4] man/io_uring_prep_splice.3: Explain
 more about io_uring_prep_splice()
References: <20230112155709.303615-1-ammar.faizi@intel.com>
        <20230112155709.303615-5-ammar.faizi@intel.com>
Date:   Thu, 12 Jan 2023 14:26:00 -0300
In-Reply-To: <20230112155709.303615-5-ammar.faizi@intel.com> (Ammar Faizi's
        message of "Thu, 12 Jan 2023 22:57:09 +0700")
Message-ID: <87bkn3ekbb.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ammar Faizi <ammarfaizi2@gnuweeb.org> writes:

> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
> I have found two people confused about the io_uring_prep_splice()
> function, especially on the offset part. The current manpage for
> io_uring_prep_splice() doesn't tell about the rules of the offset
> arguments.
>
> Despite these rules are already noted in "man 2 io_uring_enter",
> people who want to know about this prep function will prefer to read
> "man 3 io_uring_prep_splice".
>
> Let's explain it there!

Hi Ammar,

A few suggestions below:

> --- a/man/io_uring_prep_splice.3
> +++ b/man/io_uring_prep_splice.3
> @@ -52,6 +52,34 @@ and
>  .I fd_in
>  given as a registered file descriptor offset.
>
> +If
> +.I fd_in
> +refers to a pipe,
> +.IR off_in
> +must be -1.

Maybe

"off_in is ignored and must be set to -1."

> +
> +If
> +.I fd_in
> +does not refer to a pipe and
> +.I off_in
> +is -1, then bytes are read from

bytes -> nbytes ?

> +.I fd_in
> +starting from the file offset and it is adjusted appropriately.

What do you think:

starting from the file offset, which is incremented by the number of
bytes read.

> +If
> +.I fd_in
> +does not refer to a pipe and
> +.I off_in
> +is not -1, then the starting offset of
> +.I fd_in
> +will be
> +.IR off_in .
> +
> +The same rules apply to
> +.I fd_out
> +and
> +.IR off_out .
> +
>  This function prepares an async
>  .BR splice (2)
>  request. See that man page for details.
> @@ -78,3 +106,13 @@ field.
>  .BR io_uring_submit (3),
>  .BR io_uring_register (2),
>  .BR splice (2)
> +
> +.SH NOTES
> +Note that even if
> +.I fd_in
> +or
> +.I fd_out
> +refers to a pipe, the splice operation can still failed with

failed -> fail

Thanks,

-- 
Gabriel Krisman Bertazi
