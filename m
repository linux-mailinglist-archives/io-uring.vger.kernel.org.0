Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16F25466BD
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 14:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348518AbiFJMjH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 08:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348497AbiFJMjG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 08:39:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BB81CBD1D;
        Fri, 10 Jun 2022 05:39:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62F8C621BD;
        Fri, 10 Jun 2022 12:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3157FC3411D;
        Fri, 10 Jun 2022 12:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654864744;
        bh=QquaXn+0DawAtSVlv6/jK0qbZNkIk3eB0anaNNpZSqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CtkmRKen5p6Hxrw4yI4cFpRQ+7VcGe0PH8Mrbn6hagAOMFsK+wI9jdN/0gR80/OHA
         8T94VG9UjGjhQmeZWdxdXPaLBYMT5Nc74qt2BzWzC53nVg0pD8hpi0Vz8f/FX3ztvI
         H6pSvH/gG3c7TDixgAiaAwoPYY6pM5PbfUJjtpn0axf2AqKiX5W4stTxMhjsU8ugS/
         Aj7Nvw/BkNEst6Iy4iB4JQ7GhCBrjN0NbHOP/VSQhfQL8FwvVGB5aP4+j/MyGv7lRa
         v7pwvsKqko7F36++U+vx5RoVXw1BJBZmOhU6xwDNRWfDgo3DZzLcT8IxhimoLgZzNL
         mubNp+jYnGMZw==
Date:   Fri, 10 Jun 2022 14:38:58 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v8 10/14] fs: Add async write file modification handling.
Message-ID: <20220610123858.bohqbxomim7arq6w@wittgenstein>
References: <20220608171741.3875418-1-shr@fb.com>
 <20220608171741.3875418-11-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220608171741.3875418-11-shr@fb.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 08, 2022 at 10:17:37AM -0700, Stefan Roesch wrote:
> This adds a file_modified_async() function to return -EAGAIN if the
> request either requires to remove privileges or needs to update the file
> modification time. This is required for async buffered writes, so the
> request gets handled in the io worker of io-uring.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---

Looks good to me,
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
