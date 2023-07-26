Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A25376376A
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 15:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbjGZNWN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 09:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbjGZNWL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 09:22:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494BA1FEC;
        Wed, 26 Jul 2023 06:22:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC196613CA;
        Wed, 26 Jul 2023 13:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1C7C433CB;
        Wed, 26 Jul 2023 13:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690377729;
        bh=KWTeyV7DSPb2JSt6yu397zgUB2KJ1PVPqwI+zIQkUUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hub6FWYEiLv7RETY8FZB+4ovR289Ky7YEJFew1gNoTwUJx5d0fvY/MaUcswq9cN55
         eOLKkWA7zCbBr4qm18cto0btKTqHrXlOv4VtOZKpRWyitSLHwJeFLmkbUbGbvGXcmX
         U2Lyci2qJsVnB9FYCPuJVvOHqelPiQ0OxTyM6IrQ2JiPIXdyA8glXCvFIEZiJI8hqd
         z6Kkvn5IzqN7TCGoUmQUe/xfTS1ErAE1cy+njytugbaqPp+v1XOCiUUQjAZ1IQPs1i
         F1MpOw056Uu94n9EOORfYx7WjPG/7iVX5nk9rT83vbpQ3BzEjsIxwOy6TRKvO2CN8J
         3f+2mcb31nQVg==
Date:   Wed, 26 Jul 2023 15:22:03 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [RFC 0/7] io_uring lseek
Message-ID: <20230726-reinreden-packten-e7ab9aff296a@brauner>
References: <20230726102603.155522-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230726102603.155522-1-hao.xu@linux.dev>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 26, 2023 at 06:25:56PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> This series adds lseek for io_uring, the motivation to import this
> syscall is in previous io_uring getdents patchset, we lack a way to
> rewind the file cursor when it goes to the end of file. Another reason
> is lseek is a common syscall, it's good for coding consistency when
> users use io_uring as their main loop.

While I understand this it is a time consuming review to make sure
things work correctly. So before we get this thing going we better get
getdents correct first.

> 
> Patch 1 is code clean for iomap
> Patch 2 adds IOMAP_NOWAIT logic for iomap lseek
> Patch 3 adds a nowait parameter to for IOMAP_NOWAIT control
> Patch 4 adds llseek_nowait() for file_operations so that specific
>         filesystem can implement it for nowait lseek
> Patch 5 adds llseek_nowait() implementation for xfs
> Patch 6 adds a new vfs wrapper for io_uring use
> Patch 7 is the main io_uring lseek implementation
> 
> Note, this series depends on the previous io_uring getdents series.
> 
> This is marked RFC since there is (at least) an issue to be discussed:
> The work in this series is mainly to reslove a problem that the current
> llseek() in struct file_operations doesn't have a place to deliver
> nowait info, and adding an argument to it results in update for llseek
> implementation of all filesystems (35 functions), so here I introduce
> a new llseek_nowait() as a workaround.

My intuition would be to update all filesystems. Adding new inode
operations always starts as a temporary thing and then we live with two
different methods for the next years or possibly forever.

But it'd be good to hear what others think.
