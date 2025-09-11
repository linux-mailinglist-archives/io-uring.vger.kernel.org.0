Return-Path: <io-uring+bounces-9746-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA245B5328C
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 14:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FA413A58B1
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 12:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7678332252E;
	Thu, 11 Sep 2025 12:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q2AqRJHr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6C931D362;
	Thu, 11 Sep 2025 12:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757594384; cv=none; b=OAdVeOyeQWfOEmqBjEUjtuxnwMw2e1UJVi/ad0teEe7dqePzYEHcl4dAu5LWsw+4WfbGv5WMlz/JYIWAWnNsoUgJ2uSlyfONC8alGeIbRMJIX5ULbSQFvyXTVv/M0IfyTwCIJIP9taYsvQWacn8A4fyF6CR8jX5VaPdIHr9LKhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757594384; c=relaxed/simple;
	bh=6FtPYMUmXS4HX/u+H612CF2FyM2NkLQzePe7zVxOw2c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UuqcTOvY4HjsHMepsPx4cJCxRtlKZZb7Sq/cHU3FnundODLNCIuVBeFJl1LEnIs6j7I9j/7FV79xGjKxugM9tUozXUgtzVVNVD95CsfDvYkxG55MyqgQRdlT2YCmRKSrB5CBJ+rFcpsz8aSRq6eXeuuCvj9+b6Eb+HGSZ3+gibQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q2AqRJHr; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad681so937223a12.0;
        Thu, 11 Sep 2025 05:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757594381; x=1758199181; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bsWzc+/Yzyp5wOv8cyBtS91v14RkQ3sT1U0aSspvdqI=;
        b=Q2AqRJHrSNS8csDf7Q0gNKkLEWmVXHIZUP2gUr03UmEnYUE0RgLhP6X4DQqUYN4yMv
         toF6f93x9aBhD4MDM4HkkIdnXCci0Hb9o7G7qyCm9d+qMJKTrNEamgfrMVzznYxWIMZK
         uqcgPSX8npu9OUbw+QI8pUX/qzqZmpxwPzuxIOrY/6Vkn1BX89ALUriT3AWKT0u/KTDc
         g7EAUhzLGao93PKPkSGyJaNoDFDjvg4ls61eAqoohwVK5oeeLEPvvshglWtE3excpPic
         HRz/FfCZ0gtD12/NtGCY0IZ+vFpEKDzQc/VOi3ql+94eBmshjrLyyIyVvR46ePt7LjQ7
         7xfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757594381; x=1758199181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bsWzc+/Yzyp5wOv8cyBtS91v14RkQ3sT1U0aSspvdqI=;
        b=F0zbWIC90NEqfkFm2sFkil1zwdiqScqjN4SaTnn51tqQiWEw0tMYuCzDIu360zHB9Y
         MT81rp/aCZo0Jq7+81KJsfAWyW108DssHtbP/nVE0XS8NCb5VNY2lJehn68nkneUlihu
         gxGg4EdVTo5IIp+P70fN2MC8njONFPIBHwp2mee3/0F4rKTEyxCXfVHZRQtpXTl//LEG
         3Rsq4A2xQP0R+njwEpXPLOGBlPVktgbqNjEZkpmuemr6EDUok149SpQdSWCMlE8arLzW
         HgF+VNHPn1cCCKI4cmUBtcib1/pCcanL11TnRWcnR4rRH11zyHskZSTyWMa2h//uXz/T
         dgDg==
X-Forwarded-Encrypted: i=1; AJvYcCW29O7cbmuKZ1mXpvgOZFfACHXTzloTXkE3618/Zy8uEU/0x3LngRq/AYkL7E/rbEEnGwK+z6owona/zNqKQQ==@vger.kernel.org, AJvYcCWYoQMRw0/iGKlUcXQfgEA4uINVw8q423tUwN+fb7v9KPmxf0C2KOSXUPxV/cvfKGRaqdQWq9bO6w==@vger.kernel.org, AJvYcCXuIDlXJIO9hSRQE+Jw7oUe79Jf+uqdvgkwcI3zSOcJWs+MakTfEX4voTQfQwRjdQNteZ9/rITW02d9@vger.kernel.org, AJvYcCXxl1EzfNB+iCg+dRQJyfHdECxwd2bTr7PqMo82BwnKldNdJmVYY5pZZGoVsj3CQXFPxfaWYGvtUYac@vger.kernel.org
X-Gm-Message-State: AOJu0YwumPEXCcx/uYYEWDYZ3MWC6gKe0M39WS93//5Tl/IIvLxri3n6
	7XkHbvFIow+cHzLKsmy9926wMo3uCnFYg1ciSxr2r/DOghi3YijpymFC8Urd8S8t4vCzec+J6LT
	lI3Wja6Af/MvPytREnf7AX0lnEn/b/WaeanQ9
X-Gm-Gg: ASbGnctefDygFzUcARQi/D8/Vky6UqYk/qSfys1nkN+O/n1+QWxNAlKIB/msXS96cbQ
	2wgOPgCeRqfhu128BTP9HX3ymzdlHuNAC4MC1e8aV7tOBormfcJ9xx/VZWqThrmIZ8yjflehANz
	6Nt0w1tchQXFupcchYJBgTrmf9QV07vnG20NViTS0O37lBCBvZZlIMbTZgfPk4bRvfE542199lt
	SyV+EA=
X-Google-Smtp-Source: AGHT+IHj8kn3tYK5fFRS22d2FAno9LzWn2/rSyFfcihgDLJyq6rXSXoYRxKkaU3QCaUdE6DFVxlA54fTAAjDBJ4nUcc=
X-Received: by 2002:a17:907:6088:b0:afe:78c2:4d4a with SMTP id
 a640c23a62f3a-b04b1542fbbmr1803288366b.34.1757594380949; Thu, 11 Sep 2025
 05:39:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
 <20250910214927.480316-11-tahbertschinger@gmail.com> <aMLAkwL42TGw0-n6@infradead.org>
In-Reply-To: <aMLAkwL42TGw0-n6@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Sep 2025 14:39:29 +0200
X-Gm-Features: AS18NWAy6IN5toh_htKXiw5tLda19ct1lS2Emo_qxQapODBJEDYZPa0A2cfA5ZM
Message-ID: <CAOQ4uxiKXq-YHfYy_LPt31KBVwWXc62+2CNqepBxhWrHcYxgnQ@mail.gmail.com>
Subject: Re: [PATCH 10/10] xfs: add support for non-blocking fh_to_dentry()
To: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>, io-uring@vger.kernel.org, axboe@kernel.dk, 
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, cem@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 2:29=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Wed, Sep 10, 2025 at 03:49:27PM -0600, Thomas Bertschinger wrote:
> > This is to support using open_by_handle_at(2) via io_uring. It is usefu=
l
> > for io_uring to request that opening a file via handle be completed
> > using only cached data, or fail with -EAGAIN if that is not possible.
> >
> > The signature of xfs_nfs_get_inode() is extended with a new flags
> > argument that allows callers to specify XFS_IGET_INCORE.
> >
> > That flag is set when the VFS passes the FILEID_CACHED flag via the
> > fileid_type argument.
>
> Please post the entire series to all list.  No one has any idea what your
> magic new flag does without seeing all the patches.
>

Might as well re-post your entire v2 patches with v2 subjects and
cc xfs list.

Thanks,
Amir.

