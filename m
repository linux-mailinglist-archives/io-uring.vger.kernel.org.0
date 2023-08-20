Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F1F781F3D
	for <lists+io-uring@lfdr.de>; Sun, 20 Aug 2023 20:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbjHTSWS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Aug 2023 14:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjHTSWR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Aug 2023 14:22:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA8A3C00;
        Sun, 20 Aug 2023 11:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uSgZ8XFQYbPRmErFBtSZC+ngAzMBC0yKooNBbIIROsU=; b=jqS035rW5NgiWOsFvi5uTxvZgZ
        F0I4SxnWln/gke8vnWakZmjwIzq4A8fvR6GiObG7eExSw6uU5f2Jo/S6vBu/P1YNT+Saeq9Siet6e
        el61osSHyWrkjThyIvRParzSwax5HLAT0UQBRWvHwfP6uOTV84U0Ew9Vgcvqs9A4ViSUpcB9gA47U
        ieMgx+PqGsLE6TjxUVKGNecVTAbzQUZIaZJyNX/vQJCDiBUWlB49gsEl5LHXHfSk7N6afnub/5RUr
        6ciGuHdW+MtRn1ERM027mSNfNauFP77sjVhbg/B2czmBH32uhSuTJTkDKsZKTvC+UMnuOmk0iL18s
        NpsgMA2Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qXn0t-005WJH-6P; Sun, 20 Aug 2023 18:18:59 +0000
Date:   Sun, 20 Aug 2023 19:18:59 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
Message-ID: <ZOJZE3YvBjYQl000@casper.infradead.org>
References: <2b3d6880-59c7-4483-9e08-3b10ac936d04@gmx.com>
 <d779f1aa-f6ef-43c6-bfcc-35a6870a639a@kernel.dk>
 <e7bcab0b-d894-40e8-b65c-caa846149608@gmx.com>
 <ee0b1a74-67e3-4b71-bccf-8ecc5fa3819a@kernel.dk>
 <34e2030c-5247-4c1f-bd18-a0008a660746@gmx.com>
 <b60cf9c7-b26d-4871-a3c9-08e030b68df4@kernel.dk>
 <1726ad73-fabb-4c93-8e8c-6d2aab9a0bb0@gmx.com>
 <7526b413-6052-4c2d-9e5b-7d0e4abee1b7@gmx.com>
 <8efc73c1-3fdc-4fc3-9906-0129ff386f20@kernel.dk>
 <22e28af8-b11b-4d0f-954b-8f5504f8d9e4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22e28af8-b11b-4d0f-954b-8f5504f8d9e4@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Aug 20, 2023 at 08:11:04AM -0600, Jens Axboe wrote:
> +static int io_get_single_event(struct io_event *event)
> +{
> +	int ret;
> +
> +	do {
> +		/*
> +		 * We can get -EINTR if competing with io_uring using signal
> +		 * based notifications. For that case, just retry the wait.
> +		 */
> +		ret = io_getevents(io_ctx, 1, 1, event, NULL);
> +		if (ret != -EINTR)
> +			break;
> +	} while (1);
> +
> +	return ret;
> +}

Is there a reason to prefer this style over:

	do {
		ret = io_getevents(io_ctx, 1, 1, event, NULL);
	} while (ret == -1 && errno == EINTR);

(we need to check errno, here, right?  Or is io_getevents() special
somehow?)

