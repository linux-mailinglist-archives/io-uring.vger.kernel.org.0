Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7D75117DB
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 14:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbiD0MKn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Apr 2022 08:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiD0MKl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Apr 2022 08:10:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A4E1EC7D;
        Wed, 27 Apr 2022 05:07:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CDEC4CE24BB;
        Wed, 27 Apr 2022 12:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51833C385A9;
        Wed, 27 Apr 2022 12:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651061247;
        bh=VfXSpAbry2B4XiKgswh2qeTUbT/mzrWFYlX4Tdrzl6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b2Xc1pJMOg84lf+VdPwO2jdpef2Yn9NTMPROLKoVrRFo6Kk/UV8eOY7I9p3+NS8Tb
         uk+qKrL57LCpm9jwGXODz+78Dw+WUuBBoYo/oZW8gqZ6ZW/bhE8noxkCRargA7v1Rs
         YJCOYz9aWD8OFH+8HEAJnH5GzSRm9aI7tMSn8jmoY2YajiGwjrdBXtygGj7ezXadfX
         PT0YDagK6RUCGgGe2uyXIdbhq20JCuYza/CV1yYGkX0k+qSTN3GXOc3XYhy00vgN72
         DGSdxh+IPYONxQDaGFJooizFy2FZ70uMrcz6VfIEiqC6ZksVy3PC8QNi0AFR2ZQ0AE
         qq6bw9p0zg/ig==
Date:   Wed, 27 Apr 2022 14:07:21 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [RFC PATCH v1 10/18] xfs: Enable async write file modification
 handling.
Message-ID: <20220427120721.55tde42m4wsjgkfl@wittgenstein>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-11-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220426174335.4004987-11-shr@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 26, 2022 at 10:43:27AM -0700, Stefan Roesch wrote:
> This modifies xfs write checks to return -EAGAIN if the request either
> requires to remove privileges or needs to update the file modification
> time. This is required for async buffered writes, so the request gets
> handled in the io worker.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/xfs/xfs_file.c | 39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5bddb1e9e0b3..6f9da1059e8b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -299,6 +299,43 @@ xfs_file_read_iter(
>  	return ret;
>  }
>  
> +static int xfs_file_modified(struct file *file, int flags)

This should probably be in fs/inode.c as:

int file_modified_async(struct file *file, int flags)

and then file_modified() can simply become:

int file_modified(struct file *file)
{
	return file_modified_async(file, 0);
}

or even:

int file_modified_async(struct file *file, bool async)

int file_modified(struct file *file)
{
	return file_modified_async(file, false);
}

to avoid piecing this together specifically in xfs (as Dave mentioned
this is all pretty generic).
