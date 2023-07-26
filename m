Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539737638F5
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 16:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbjGZOXf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 10:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbjGZOXf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 10:23:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779EEE47;
        Wed, 26 Jul 2023 07:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1528661AF5;
        Wed, 26 Jul 2023 14:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3F9C433C7;
        Wed, 26 Jul 2023 14:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690381413;
        bh=FwuUFBpzZ4if38Feouggu7fJKF8cUg9igHPSfAAzvY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i9GETdJ7ifKQeiNzvhkVbd0OMXd8r1GrpwhfYOLHGAUjjJLWBlJBhURx/clgZVovK
         PqWArtV6MGoQLwmRQbH4XdoUrwh8ifO8WLrox1E60r0JRdULrhz0k1ByjkfWvl2hpO
         WrTbbncNoytzabn2/8JkQq+RigDDJop1CK4hLxF5J+avb0hseoiigOUO3RM9ewYlzf
         A8qomx1BgGqSQML8zKYZIToZHgG5C7dgAS6uTz+YjX5ZSjSfkzlv+el5UWrfhe/T7L
         2N+WcTjrmTEGCkZ2L13NL1j9CGWW6V6cdapvULa45WYIV7NUULCfr25Oe6vB+Y8cu0
         xMqGJJoFtUfgA==
Date:   Wed, 26 Jul 2023 16:23:28 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH RFC 5/5] disable fixed file for io_uring getdents for now
Message-ID: <20230726-inhaftiert-hinunter-714e140c957c@brauner>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-6-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230718132112.461218-6-hao.xu@linux.dev>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 18, 2023 at 09:21:12PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Fixed file for io_uring getdents can trigger race problem. Users can
> register a file to be fixed file in io_uring and then remove other
> reference so that there are only fixed file reference of that file.
> And then they can issue concurrent async getdents requests or both
> async and sync getdents requests without holding the f_pos_lock
> since there is a f_count == 1 optimization.

Afaict, that limitation isn't necessary. This version ow works fine with
fixed files.

Based on the commit message there seems to be a misunderstanding.
Your previous version of the patchset copied the f_count optimization
into io_uring's locking which would've caused the race I described
in the other thread.

There regular system call interface was always safe because as long as
the original fd is kept the file count will be greater than 1 and both
the fixed file and regular system call interface will acquire the lock.

So fixed file's not being usable was entirely causes by copying the
f_count optimization into io_uring. Since this patchset now doesn't use
that optimization and unconditionally locks things are fine. (And even
if, the point is now moot anyway since we dropped that optimization from
the regular system call path anyway because of another issue.)
