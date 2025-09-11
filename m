Return-Path: <io-uring+bounces-9751-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7864DB536FF
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 17:11:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25F071BC5F79
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 15:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5F63469E6;
	Thu, 11 Sep 2025 15:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mhihjIy1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC06341641;
	Thu, 11 Sep 2025 15:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757603458; cv=none; b=pCb5311xH3uMj7DUMm9e03K8TDG1llbkT56huK8FXqkWE98IobV9Ne0XHVgGzyk6pJy0jiYP2mMrIzdb6ed410gwANYTrtf2hVOI6dDjV4xS9SlOVu1hMNGmaGVy4o0wP8J8SwZzqg0fecv19LOjFVp3I06fP9yiKOJkk3/hHmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757603458; c=relaxed/simple;
	bh=an46x2I3Dy+TeiuXRphUGx1cYhrJ8qb1xv3Zy+UAglI=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=jM5Y0uywzDr0N56njJ5obpUdhtKiXAVxSkFrJ9M9JUaOl3sexJmmJ70cIUFyaFaXqpJv1C/H0ATdzrlNNGFls//h+wudW14tX8mEoYNLrp2bxAm19Caiwpu/nOT7SR+/nmr3osx/USRqM/BK/7tLrPKp0N28W59qXHbqeN26rJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mhihjIy1; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b4c3d8bd21eso560509a12.2;
        Thu, 11 Sep 2025 08:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757603456; x=1758208256; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nLHs7MNBHjVe6P8ziaUOQKYCFZoAKY21juz77vaW4Lg=;
        b=mhihjIy1TJktGvaR1P/TLCPB4K2oCx0QhyxgIhbA6Xyvv8m2Z04BNq5XzzSsfe02r5
         GbswuMXCkuETBf20+rUlmDtdM35InWOMG2FjL6G8CuceVthuYt9YhcKbPyNr3woepH0L
         bTUmMoVwCmBFt2O8kKubK0fw5TKJMYALiTOMA+gZDrT//UDeetHImEcXp0cb3rcFwIt5
         Jk8Xz3XBWGnFn0lQbnaWSUjAOCT0FINZ4RbE+P+th1EWPObwglqkfAO69JZbG4JCyvM9
         SQQUghb63VtGmkAdsJV96TyMuzfh/sAaR3MD/Q8soDDMK+0nMOoI043BJNKrmKFwbOMI
         h+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757603456; x=1758208256;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nLHs7MNBHjVe6P8ziaUOQKYCFZoAKY21juz77vaW4Lg=;
        b=waRXpEmYCRdkjY60QowXYey/KavKvIpFmVy8cROIIyr8K6fK7YrarNp1mlpWkijR/r
         WqVEJalqwhM86GFCKjF65yPiCMViBpNDmeswe4X1fjF1OeEpghu6/hYjHnTMrQLvUh7u
         wq6Gfsn7U/ZBLRx3Y2QSIKA99R/1LzijAdg/W+SfushAK7ZQSwtzYxVpJ+KhwJMGooqt
         iXW8qDNetJdHGiKNzDyOYVVF3sspwCM+FDVj1yPj6UNUdp9bm/uF6hsX2lMkJaEEn6BN
         Ef8G4/oEa5/3G2XJDeNrZ1Hy74sB45y3AEuACD4xhXKbZSHTYtXUF6QJVn7i710wgA8q
         Jg7A==
X-Forwarded-Encrypted: i=1; AJvYcCUfaSbBBcJUIdqS7BWCikCfV3iovb76VL5C0/fPFJ3Jo/5PRMcorg0acNEgroyyS3i5obpQX+P4ZZjw@vger.kernel.org, AJvYcCXWsNK0/MY2hO23DBf8Sj109dp5zWEQK8li11uEIKBPXYOIYmXU01n66SYxfenTfhRfUZspRWQqWhNF8iqHaQ==@vger.kernel.org, AJvYcCXZc/9dZfJvGlf8ui0R+pACcuswm61yAbukNZMMY1fbsTiNjvVKI9JuG0SLKZwdvqdrWhFpvrye7Q==@vger.kernel.org, AJvYcCXhmwDRfy+ogCbrFYpZzeXgyubfG1fgRFEtsgqT+9aVxhVcogV5Q1qusiaknigwZe5n2azorhgysn16@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6CII9842sQvm1vFFAz52hCMabWh8O24opvJnfX2b+sNYPwxmw
	tioMrcgD6Ey7/6j8iao6TISxPBUwQylA9mTRhYEnD50suTMzFaakp8nj29K9gLQl
X-Gm-Gg: ASbGncu1RvuMUjgtqy86oH/eLezdkNzKRGD6mgPeSh29vGfz2hsyX3VTY7IVZ0PTGPH
	ChYvnetbiQWUqGgReLD1/eF28hOFiMPXOB2lI9QNVZA/5QzipdyvQVOSWCHDoSTsMY/agKvGNGQ
	bMCn/kgGqOSf0ZMQww4d9FdG00PEafNcAFeZIONPVLBlpTlifvd/8bVpTJzJMVj5Pd8wlvztByx
	ioowjX3iHAUZ03KSrjnvEuqYSFD7UtLAkHSVQC0tZegp5s6KviJE0a/pZVdeoJxCQ961J7hxJwQ
	lKQjDCHBmOpramidcX06YnECQ1rrFJp5OQdQ0k6EdjVRK4Jv0zbA316HqCaczIJ3LeuYCJFMnbU
	9HfzgBU+rHjpIACZz8xO+l6IdzXg=
X-Google-Smtp-Source: AGHT+IG78pw1vShDanj3m433gxCpn9B2ciQn61RIIVHFywrrpWIUwRNWTqnxYKqHxS5eypGHtxoOpg==
X-Received: by 2002:a17:903:32c1:b0:25c:b6fb:778 with SMTP id d9443c01a7336-25cb6fb09aamr12630145ad.14.1757603456078;
        Thu, 11 Sep 2025 08:10:56 -0700 (PDT)
Received: from localhost ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3a84a49csm22151345ad.94.2025.09.11.08.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 08:10:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 11 Sep 2025 09:15:56 -0600
Message-Id: <DCQ2J75IZ9GN.29DY2W9SV3JPU@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "Christoph Hellwig"
 <hch@infradead.org>
Cc: "Thomas Bertschinger" <tahbertschinger@gmail.com>,
 <io-uring@vger.kernel.org>, <axboe@kernel.dk>,
 <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
 <brauner@kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <cem@kernel.org>
Subject: Re: [PATCH 10/10] xfs: add support for non-blocking fh_to_dentry()
From: "Thomas Bertschinger" <tahbertschinger@gmail.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
 <20250910214927.480316-11-tahbertschinger@gmail.com>
 <aMLAkwL42TGw0-n6@infradead.org>
 <CAOQ4uxiKXq-YHfYy_LPt31KBVwWXc62+2CNqepBxhWrHcYxgnQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiKXq-YHfYy_LPt31KBVwWXc62+2CNqepBxhWrHcYxgnQ@mail.gmail.com>

On Thu Sep 11, 2025 at 6:39 AM MDT, Amir Goldstein wrote:
> On Thu, Sep 11, 2025 at 2:29=E2=80=AFPM Christoph Hellwig <hch@infradead.=
org> wrote:
>>
>> On Wed, Sep 10, 2025 at 03:49:27PM -0600, Thomas Bertschinger wrote:
>> > This is to support using open_by_handle_at(2) via io_uring. It is usef=
ul
>> > for io_uring to request that opening a file via handle be completed
>> > using only cached data, or fail with -EAGAIN if that is not possible.
>> >
>> > The signature of xfs_nfs_get_inode() is extended with a new flags
>> > argument that allows callers to specify XFS_IGET_INCORE.
>> >
>> > That flag is set when the VFS passes the FILEID_CACHED flag via the
>> > fileid_type argument.
>>
>> Please post the entire series to all list.  No one has any idea what you=
r
>> magic new flag does without seeing all the patches.
>>
>
> Might as well re-post your entire v2 patches with v2 subjects and
> cc xfs list.
>
> Thanks,
> Amir.


Thanks for the advice, sorry for messing up the procedure...

Since there are a few quick fixups I can make, I may go straight to
sending v3 with the correct subject and cc. Any reason for me to not do
that -- is it preferable to resend v2 right away with no changes?

