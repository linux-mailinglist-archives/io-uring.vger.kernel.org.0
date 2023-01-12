Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4B86684F7
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 22:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbjALVFC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 16:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240976AbjALVDr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 16:03:47 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC49260A;
        Thu, 12 Jan 2023 12:47:53 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DF10E5C291;
        Thu, 12 Jan 2023 20:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673556471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vNscIbSV7phVtQoqdyMEvf6by77S3/TFLYCqzxKulYw=;
        b=fUlG9tBNKhedXStRTUNkdesz6GYzYqkcQ1EoM5p2Rv87U9yug2H7Z1iOOMODVvkRYqufKp
        ie7mjDa3zZkxS7/a+Jzd3eKeRxPmqwPCYoBsHlrnmLJFFEyOHonyk7uN+kJGvjQLXs+4a7
        rCVeAc1fFclI3ELwHVkffZ5ibq2a/fE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673556471;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vNscIbSV7phVtQoqdyMEvf6by77S3/TFLYCqzxKulYw=;
        b=5b3Ygr1ZgE3xdAEv/TZObYinLR9ASPBoFGOpbUAZdWxxzFh42pSMn62rw6V9BIcBMtI/VN
        1rKr7J8OMAAD2ABw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5FEFE13585;
        Thu, 12 Jan 2023 20:47:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id g20vCvdxwGOpNwAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 12 Jan 2023 20:47:51 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Breno Leitao <leitao@debian.org>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Jiahao XU <Jiahao_XU@outlook.com>
Subject: Re: [PATCH liburing v1] man/io_uring_prep_splice.3: Fix description
 in io_uring_prep_splice() manpage
Organization: SUSE
References: <20230112203452.317648-1-ammar.faizi@intel.com>
Date:   Thu, 12 Jan 2023 17:47:49 -0300
In-Reply-To: <20230112203452.317648-1-ammar.faizi@intel.com> (Ammar Faizi's
        message of "Fri, 13 Jan 2023 03:34:52 +0700")
Message-ID: <87r0vzcwei.fsf@suse.de>
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
> Commit 55bbe5b71c7d missed a review from Gabriel. It was blindly copied
> from liburing.h comment with just a modification to support manpage
> formatting. Fix that.
>
> While in there, also fix the liburing.h from which that mistake comes.
>
> Cc: Jiahao XU <Jiahao_XU@outlook.com>
> Suggested-by: Gabriel Krisman Bertazi <krisman@suse.de>
> Link: https://lore.kernel.org/io-uring/87bkn3ekbb.fsf@suse.de
> Fixes: 55bbe5b71c7d ("man/io_uring_prep_splice.3: Explain more about io_uring_prep_splice()")
> Fixes: d871f482d911 ("Add inline doc in the comments for io_uring_prep_splice")
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

-- 
Gabriel Krisman Bertazi
