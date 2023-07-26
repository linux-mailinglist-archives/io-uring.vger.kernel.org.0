Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA5E7641EF
	for <lists+io-uring@lfdr.de>; Thu, 27 Jul 2023 00:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjGZWOI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 18:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjGZWOI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 18:14:08 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB53270E
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 15:14:06 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-54290603887so162332a12.1
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 15:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690409646; x=1691014446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zq7D0YmgASd+yk66PM2DkqBp255LSZYKNAGDwApDeaE=;
        b=1Yt3ed99kdm1rUNQXEPBu9c/49PAkrY/r3MlFkTVwdel/ppqvFAofSy+j6WsT0GqTb
         9VVYampjFbICeIqkg3DNufs15HBKfBryfWdJznjF6jiV1m1T1DroLTWv2fbCakYxFYnX
         dvcvN1TXqmKu9A4oCV35tgySm102AA5Ayhy0CEdb0wtFoMteDTTUDVSueS5G/olzNvPf
         JbFco/gnd4IipvS7Au1Kv1RZlvhD5JaxIPmQmCuv+wukp/ZY+y0YOBLTZ1dXiDPd7CjB
         PI8iJbnumnmDOLT6iiy+nHmwCvCrc/J5TuKHfk2fEqqYVPk6rZwcUHVD1iol3OubkeTX
         mr5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690409646; x=1691014446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zq7D0YmgASd+yk66PM2DkqBp255LSZYKNAGDwApDeaE=;
        b=GRHX6qMWoIt2Yqja7rsZjkQbXu9s3C3mYb8eZPVIOvqsy+hSC4aVQ6fXg55JhQOXb3
         PAoZ5bPq9nA6aiVPdGNiTomt7e8hVTV8QKCsvJd/Srwjarb9ahiTs7XuidsRcnv3KwZn
         KfVSNkD8cisuY2e9W+TEwitV0Ey1yHh8WNOAKNnzrdL7leY8+jiKWlWLIqK5EyJtXaZf
         ehXl4f6hXR4qOSFWiJFtTsVApCw0jdK5Bnd2kXk8hv6DoGGoE2xq0ULLw3IySVz5SPk2
         bU3PlN6lGcSERXgg5+jYUkJmHnYeBVuDQ6+jgv2/yOjvUaWrEou9nNcvYAKz18R9BXiS
         oK2Q==
X-Gm-Message-State: ABy/qLaFmLfpDefzSZacnUlklXYxhohQR0CUC4zi029d1cdtKA/ehNff
        S9/Uz5xQleZc+Ub/jyp8K0AsnA==
X-Google-Smtp-Source: APBJJlH9EcpZdUegUuGIRMwJAC6R7S/N7/X+YWF4a6uuuFoI97uqAqVfaJn5N3aStImZzMWfH7IXEQ==
X-Received: by 2002:a17:90a:dc05:b0:268:25b7:1922 with SMTP id i5-20020a17090adc0500b0026825b71922mr2680501pjv.5.1690409645809;
        Wed, 26 Jul 2023 15:14:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id c9-20020a170902d48900b001b7f40a8959sm52079plg.76.2023.07.26.15.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 15:14:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qOmle-00Aubr-2F;
        Thu, 27 Jul 2023 08:14:02 +1000
Date:   Thu, 27 Jul 2023 08:14:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 5/7] add llseek_nowait support for xfs
Message-ID: <ZMGaqsDTe4oDCdAZ@dread.disaster.area>
References: <20230726102603.155522-1-hao.xu@linux.dev>
 <20230726102603.155522-6-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726102603.155522-6-hao.xu@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 26, 2023 at 06:26:01PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add llseek_nowait() operation for xfs, it acts just like llseek(). The
> thing different is it delivers nowait parameter to iomap layer.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>  fs/xfs/xfs_file.c | 29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 73adc0aee2ff..cba82264221d 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1257,10 +1257,11 @@ xfs_file_readdir(
>  }
>  
>  STATIC loff_t
> -xfs_file_llseek(
> +__xfs_file_llseek(
>  	struct file	*file,
>  	loff_t		offset,
> -	int		whence)
> +	int		whence,
> +	bool		nowait)
>  {
>  	struct inode		*inode = file->f_mapping->host;
>  
> @@ -1282,6 +1283,28 @@ xfs_file_llseek(
>  	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
>  }
>  
> +STATIC loff_t
> +xfs_file_llseek(
> +	struct file	*file,
> +	loff_t		offset,
> +	int		whence)
> +{
> +	return __xfs_file_llseek(file, offset, whence, false);
> +}
> +
> +STATIC loff_t
> +xfs_file_llseek_nowait(
> +	struct file	*file,
> +	loff_t		offset,
> +	int		whence,
> +	bool		nowait)
> +{
> +	if (file->f_op == &xfs_file_operations)
> +		return __xfs_file_llseek(file, offset, whence, nowait);
> +	else
> +		return generic_file_llseek(file, offset, whence);
> +}
> +
>  #ifdef CONFIG_FS_DAX
>  static inline vm_fault_t
>  xfs_dax_fault(
> @@ -1442,6 +1465,7 @@ xfs_file_mmap(
>  
>  const struct file_operations xfs_file_operations = {
>  	.llseek		= xfs_file_llseek,
> +	.llseek_nowait	= xfs_file_llseek_nowait,
>  	.read_iter	= xfs_file_read_iter,
>  	.write_iter	= xfs_file_write_iter,
>  	.splice_read	= xfs_file_splice_read,
> @@ -1467,6 +1491,7 @@ const struct file_operations xfs_dir_file_operations = {
>  	.read		= generic_read_dir,
>  	.iterate_shared	= xfs_file_readdir,
>  	.llseek		= generic_file_llseek,
> +	.llseek_nowait	= xfs_file_llseek_nowait,
>  	.unlocked_ioctl	= xfs_file_ioctl,
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl	= xfs_file_compat_ioctl,

This is pretty nasty. It would be far better just to change the
.llseek method than to inflict this on every filesystem for the
forseeable future.

Not that I'm a fan of passing "nowait" booleans all through the file
operations methods - that way lies madness. We use a control
structure for the IO path operations (kiocb) to hold per-call
context information, perhaps we need something similar for these
other methods that people are wanting to hook up to io_uring (e.g.
readdir) so taht we don't have to play whack-a-mole with every new
io_uring method that people want and then end up with a different
nowait solution for every method.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
