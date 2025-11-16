Return-Path: <io-uring+bounces-10646-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2DD4C611B8
	for <lists+io-uring@lfdr.de>; Sun, 16 Nov 2025 09:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6319F3B61FD
	for <lists+io-uring@lfdr.de>; Sun, 16 Nov 2025 08:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443C5285072;
	Sun, 16 Nov 2025 08:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LAFpYxoi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD492248A0
	for <io-uring@vger.kernel.org>; Sun, 16 Nov 2025 08:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763281397; cv=none; b=A257ipd36bm6StNo9M9TJrHwmHALUAHzBKmq/vuZg5GVBRL4b01bpzkecVKFjZCdKCLPdeQxJEc0yTPU5J4Cml2TmHSEB+GQOs1qswPH1xxwW61RTL3p2J3fsde3S7Ex+R8facOkWHWxAly6Dvq0ua56zPFMhm6NxfM6PgDgYoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763281397; c=relaxed/simple;
	bh=C+JcvFRwZHyavGe7kxRswHzD35IQVhdGIfMoOL9ybQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M80tEjPWyAzLDfKD87TY/VrdUrIegBdl9i++rWvH0qkKAwBmalxW6dSl9dzCWU7z+qvSip6iOyb6YVZy27Xn6mSHOvs3lyaIYNhRHaxYF5sZJbYgiUDmdJJU9uZFBYFoUMOVM5yyLAezvtMaCw8U0EbzpjFwsl/B5rUbyN9QmhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LAFpYxoi; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2956d816c10so35204055ad.1
        for <io-uring@vger.kernel.org>; Sun, 16 Nov 2025 00:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1763281395; x=1763886195; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M4MaMBAoduJmljAfpOLsOwZXGopJOVWqjmgthPn26W4=;
        b=LAFpYxoiJGcYCTAW2kOg1UFBq9oMMmEaBg4IvoS0x3oCTo4DCvJt3kTJIKB0DB5SL7
         NJDSdSfhSUy6img3FIkk9DZo93wSfy/IQfxyXAy6nDow269dr8fz2JWVYR2FIsFXjAQ0
         6SHD9N2jFT5ezuoq/DJaH6tv4TwQfB25O47G/5O+HEeM/r7mF4AIebekDNxdrWcmQ39u
         NVZ9AS0QiPWLnpgRmkIicMuRk263e5xdrNFcBbAuXJO5c1Qv8Kr2mRr+4x0u/bfpWq65
         Td07/17O4ZU71mQrPJ/qJtNKqi/9DqB5XVUZhh78859hNaw+PP8r8dqXyw4pnhkA0gvB
         IvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763281395; x=1763886195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M4MaMBAoduJmljAfpOLsOwZXGopJOVWqjmgthPn26W4=;
        b=J7QYrnJZUvf24Sqx/m8q/KBpQTMukjjRPKxssCbfrEATymhCjGaNTserFyGnBj+Giz
         SF8YDrw/8X9HXBW7EX4OAVDwRYR3YkGld1tfph2WTdusabDCR0gNG9rNGsgaMgDpT8Fa
         QjcCggGWC/SOJagwSDNOT5A1fg0q5p9hmqqxx6j6P9Ww0Aubb7xk+Foe8hIwBzaTe3IL
         DeDFGY/VEhicn858UHqU7Hs0stRozwph3TOf/hcFqcbxXrNCCwpzIMcFo/wG7w5RG3Zg
         sGhakGydv1XVNJN23pbZ59sODK7H5IMiI6cSoOv9oVm+rkH8QT7OFlIsUFnv5HLx1rCj
         JYQg==
X-Forwarded-Encrypted: i=1; AJvYcCVOZFZ4ww34rE3jubJjbhc7ytg04A4LrmdUP5RRh1XPsnfhuy0Uien9lhI97nmmLoyoNUJP7H5F2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZDxFJQ/8wqm1KY3T/fWdWWW6dYVvaqR6tj5mUlKCN24t35+Ld
	Z/Snpk+k0aCqNXYO7SX/wnV2SoeBi2y5UfHbdEAnLs0HVLqejP454z26GsWz5ZKnpNk=
X-Gm-Gg: ASbGnctZ3dQND0xFK2uLYWEvw6J6fr8WAEqShAMseEBqssM5hvXBnfYRrIVJ6i/RPcG
	2qPuEPLpwVCapn/Gy4g/7Y2kxdNb0t4yrBrPt86jfGhgl/WTyshCvajj7JNNdz81RuC93tWdCvx
	+OhYpRW96tOl5iug9Gu7wtKeMULYd5fWLowEFcDx3/eu2w/deFMsIRt7xoszZn8OYfp9aodSjCE
	olvAqlXbBK8WFMH9ZtE7tO0BECeqPlTzP04bWFGmXnI7Po4tekKwgj5pbRBzsoPSKNMUogsy/RO
	FYzgyRDdg1lgdc17WHgrzp8nc9N3hqY+MOXtocGYEFTsyXX6+GHDXwtnEaD13eJlES5ozlQ+4Ij
	cUKpABg0DUWo2F/6tBzS3PMaFTmkRzUpA9/fUF0qodBZs6QmsuzpAT4dIsd+hrtGtmPgpIZpiFy
	/LbfbxkeWMOduJXFW+nHPVwYXsb/jNB1IGym9OqgXecW5fKry5AuU6sNMwus+eNw==
X-Google-Smtp-Source: AGHT+IE2kISBEpmbZV/bnZzdrwmOacrEejG6ljtHkn9ZRcGe++TC5tzXGzGVsKaVV/gcvGARY/ZhHw==
X-Received: by 2002:a17:903:41ca:b0:294:ec7d:969c with SMTP id d9443c01a7336-2986a769988mr112616935ad.49.1763281394800;
        Sun, 16 Nov 2025 00:23:14 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29864b00fc9sm79958015ad.40.2025.11.16.00.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 00:23:14 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vKY2R-0000000BUhZ-3a27;
	Sun, 16 Nov 2025 19:23:11 +1100
Date: Sun, 16 Nov 2025 19:23:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	io-uring@vger.kernel.org, devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 14/14] xfs: enable non-blocking timestamp updates
Message-ID: <aRmJ728evgFnBLhn@dread.disaster.area>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114062642.1524837-15-hch@lst.de>

On Fri, Nov 14, 2025 at 07:26:17AM +0100, Christoph Hellwig wrote:
> The lazytime path using generic_update_time can never block in XFS
> because there is no ->dirty_inode method that could block.  Allow
> non-blocking timestamp updates for this case.
> 
> Fixes: 66fa3cedf16a ("fs: Add async write file modification handling.")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iops.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index bd0b7e81f6ab..3d7b89ffacde 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1195,9 +1195,6 @@ xfs_vn_update_time(
>  
>  	trace_xfs_update_time(ip);
>  
> -	if (flags & S_NOWAIT)
> -		return -EAGAIN;
> -
>  	if (inode->i_sb->s_flags & SB_LAZYTIME) {
>  		if (!((flags & S_VERSION) &&
>  		      inode_maybe_inc_iversion(inode, false)))
> @@ -1207,6 +1204,9 @@ xfs_vn_update_time(
>  		log_flags |= XFS_ILOG_CORE;
>  	}
>  
> +	if (flags & S_NOWAIT)
> +		return -EAGAIN;
> +
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
>  	if (error)
>  		return error;

Not sure this is correct - this can now bump iversion and then
return -EAGAIN. That means S_VERSION likely won't be set on the
retry, and we'll go straight through the non-blocking path to
generic_update_time() and skip logging the iversion update....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

