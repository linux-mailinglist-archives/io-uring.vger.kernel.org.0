Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F49769CFBD
	for <lists+io-uring@lfdr.de>; Mon, 20 Feb 2023 15:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjBTOxF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 09:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjBTOxF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 09:53:05 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8A71A969
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:53:04 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E266920481;
        Mon, 20 Feb 2023 14:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676904782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iRwZ+Q7idUD/tX+jfcDJHuzy8ye/NT0rgdbBOh7tQ3Y=;
        b=aR3nHzCakxp4JUX3R/LyTKPl7jaqwQludx9ELNLAZZbJoV4owMJAJ6aJZubAQVybo5qTsA
        BhErTxGo2/qRyvMPzkCr9oimfYmFtEoAqyexVLrw+LTV4N+BoIUpOZhljm/zxK/OgW8uUf
        4amSSfBIl8kvrp27toN60v2Lhp6JwBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676904782;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iRwZ+Q7idUD/tX+jfcDJHuzy8ye/NT0rgdbBOh7tQ3Y=;
        b=4pYh9cS7Ysii9maPRP+mtAAtSOsQhF2nbczft5NCO0nbnUhW5etMawV2Fxf5jgj476nb9Y
        iSZch/Tsa3Ldb+Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 730C5134BA;
        Mon, 20 Feb 2023 14:53:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tqhCD06J82NCQQAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 20 Feb 2023 14:53:02 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-next v2 1/1] io_uring/rsrc: disallow multi-source
 reg buffers
References: <6d973a629a321aa73c286f2d64d5375327d5c02a.1676902832.git.asml.silence@gmail.com>
Date:   Mon, 20 Feb 2023 11:53:00 -0300
In-Reply-To: <6d973a629a321aa73c286f2d64d5375327d5c02a.1676902832.git.asml.silence@gmail.com>
        (Pavel Begunkov's message of "Mon, 20 Feb 2023 14:20:57 +0000")
Message-ID: <87y1oscrsj.fsf@suse.de>
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

Pavel Begunkov <asml.silence@gmail.com> writes:

> If two or more mappings go back to back to each other they can be passed
> into io_uring to be registered as a single registered buffer. That would
> even work if mappings came from different sources, e.g. it's possible to
> mix in this way anon pages and pages from shmem or hugetlb. That is not
> a problem but it'd rather be less prone if we forbid such mixing.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/rsrc.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index a59fc02de598..70d7f94670f9 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1162,18 +1162,19 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
>  	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
>  			      pages, vmas);
>  	if (pret == nr_pages) {
> +		struct file *file = vmas[0]->vm_file;
> +
>  		/* don't support file backed memory */
>  		for (i = 0; i < nr_pages; i++) {
> -			struct vm_area_struct *vma = vmas[i];
> -
> -			if (vma_is_shmem(vma))
> +			if (vmas[i]->vm_file != file)
> +				break;

Perhaps, return -EINVAL instead of -EOPNOTSUPP

> +			if (!file)
>  				continue;
> -			if (vma->vm_file &&
> -			    !is_file_hugepages(vma->vm_file)) {
> -				ret = -EOPNOTSUPP;
> +			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file))
>  				break;
> -			}
>  		}
> +		if (i != nr_pages)
> +			ret = -EOPNOTSUPP;
>  		*npages = nr_pages;
>  	} else {
>  		ret = pret < 0 ? pret : -EFAULT;

-- 
Gabriel Krisman Bertazi
