Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8076B8E3F
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 10:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjCNJMM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 05:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjCNJMG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 05:12:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D774C99BE5;
        Tue, 14 Mar 2023 02:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F7DEB8188B;
        Tue, 14 Mar 2023 09:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB557C433EF;
        Tue, 14 Mar 2023 09:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678785118;
        bh=07nP2XDWrUtVvRxgSK4C2j9QymqtL60LZvBc4fSBVzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nZVsrFh+S4g4BMN0MU7yyGgvyQ/w+mY3qj56O1XyHVKl6SqNmjOiC5BM60Zijequ3
         m4Ap4kHHJ2/ir3L9KWItACnhkqhj8MQD5Q0zjaj+tQ2mxTvrCqg43AzwBioXlFICyQ
         U6D6y61KnvCzNHH6b4qh907Hf04rqf3D6rE/L9YjZB7rn1MH875X+EDA0F57yWUGud
         5TBuWqyt++JX7D624MIzjj35xONPM9UT9SVjY5mSr1YmZoL4BDGSMvDiaUcBWIt200
         McaWLRSntZ3LUI9k7cekZMpixFpzwk/zok3uAkh98qP3HmEwFqWJ6wDpBfo2aadqXL
         czbv233fmZsTQ==
Date:   Tue, 14 Mar 2023 10:11:54 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] fs: add 'nonblock' parameter to pipe_buf_confirm()
 and fops method
Message-ID: <20230314091154.csjhetcuzuvdjlgh@wittgenstein>
References: <20230308031033.155717-1-axboe@kernel.dk>
 <20230308031033.155717-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230308031033.155717-2-axboe@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 07, 2023 at 08:10:31PM -0700, Jens Axboe wrote:
> In preparation for being able to do a nonblocking confirm attempt of a
> pipe buffer, plumb a parameter through the stack to indicate if this is
> a nonblocking attempt or not.
> 
> Each caller is passing down 'false' right now, but the only confirm
> method in the tree, page_cache_pipe_buf_confirm(), is converted to do a
> trylock_page() if nonblock == true.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---

Looks good,
Reviewed-by: Christian Brauner <brauner@kernel.org>
