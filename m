Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B44D2E00A3
	for <lists+io-uring@lfdr.de>; Mon, 21 Dec 2020 20:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgLUTDO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 14:03:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbgLUTDO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 14:03:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608577308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NZiUcV7BSK7i0CWlurCWLtNY549184RJIWz+r5r7B5E=;
        b=CLWFTLhh6y635bZCyalJPYjNt7CrcXaQT0xrZIa83OBUtF+Gfydn0CWvZJiI/IEHjkG6xj
        SwsEnFecV4g7F9uw7GbFDvA9e1Dbty2KSrqYRSFSMeIUwBTfxbOAUL0WPTUh0JJqPbv8+9
        CJvxI91upwv+s6Z9fDtowoT3bGvWR1g=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-TV2t3ylJPwi2nzHu-uQdLQ-1; Mon, 21 Dec 2020 14:01:46 -0500
X-MC-Unique: TV2t3ylJPwi2nzHu-uQdLQ-1
Received: by mail-qv1-f70.google.com with SMTP id j5so8714578qvu.22
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 11:01:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NZiUcV7BSK7i0CWlurCWLtNY549184RJIWz+r5r7B5E=;
        b=QufUobylnMfKPw7SxOYl0kfsMsnGJL88yza3faW9OC7JZMRvO0X4HjSIjOT47MMnGF
         CDED/1MqnK96B3KauBPWQoUJOqnsZ0jLRtSd9t3rXMakArsapVhdNDAy7dkqCazOAayx
         UmOmlSWwQyp8xuQlGgFJQCl9nePCdYtx6VkWkOsyR04rQcCf8lvOlc2VrrbSFATseFG9
         pLJxhwyfgv5bRQZbfhG3DPGKAgrqS8Nm6LiMFsW8vMOigJQ5co6og8lsNfxdXw9wBcJb
         p6cdc9LiRhgnjC71AWs61N9TQ74GMxiy+lUHFZju2ORcNmp8WR9Z61L7uSQIO7gj9MwC
         ldtw==
X-Gm-Message-State: AOAM532at2JBpsdBVTxw6O5hmMVLW/VQiayZi+W1TYJ68CBgfPGIqwOO
        LmRHSA77dJnhfUue1nFFg47BN3h9n1ZVye1NEhc+05pIXvX4GCZXhGE/we951BnRbgUj971n9ua
        m0FKTULaCo1hSZIF3/SY=
X-Received: by 2002:a05:622a:110:: with SMTP id u16mr17814128qtw.181.1608577305250;
        Mon, 21 Dec 2020 11:01:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwbUgz+dyrK2CDdLmiez7hlLMcNsr37TcWBJHlCy7Hi/1LYq/N8tyN83npjnd8BPX5EUlRlUg==
X-Received: by 2002:a05:622a:110:: with SMTP id u16mr17814113qtw.181.1608577304992;
        Mon, 21 Dec 2020 11:01:44 -0800 (PST)
Received: from xz-x1 ([142.126.83.202])
        by smtp.gmail.com with ESMTPSA id z20sm11392783qtb.31.2020.12.21.11.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 11:01:44 -0800 (PST)
Date:   Mon, 21 Dec 2020 14:01:42 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, linux-fsdevel@vger.kernel.org,
        Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 01/13] fs/userfaultfd: fix wrong error code on WP &
 !VM_MAYWRITE
Message-ID: <20201221190142.GG6640@xz-x1>
References: <20201129004548.1619714-1-namit@vmware.com>
 <20201129004548.1619714-2-namit@vmware.com>
 <3af643ec-b392-617c-cd4e-77db0cba24bd@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3af643ec-b392-617c-cd4e-77db0cba24bd@oracle.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 01, 2020 at 01:22:32PM -0800, Mike Kravetz wrote:
> On 11/28/20 4:45 PM, Nadav Amit wrote:
> > From: Nadav Amit <namit@vmware.com>
> > 
> > It is possible to get an EINVAL error instead of EPERM if the following
> > test vm_flags have VM_UFFD_WP but do not have VM_MAYWRITE, as "ret" is
> > overwritten since commit cab350afcbc9 ("userfaultfd: hugetlbfs: allow
> > registration of ranges containing huge pages").
> > 
> > Fix it.
> > 
> > Cc: Mike Kravetz <mike.kravetz@oracle.com>
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: io-uring@vger.kernel.org
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
> > Signed-off-by: Nadav Amit <namit@vmware.com>
> > ---
> >  fs/userfaultfd.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > index 000b457ad087..c8ed4320370e 100644
> > --- a/fs/userfaultfd.c
> > +++ b/fs/userfaultfd.c
> > @@ -1364,6 +1364,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
> >  			if (end & (vma_hpagesize - 1))
> >  				goto out_unlock;
> >  		}
> > +		ret = -EPERM;
> >  		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
> >  			goto out_unlock;
> >  
> 
> Thanks!  We should return EPERM in that case.
> 
> However, the check for VM_UFFD_WP && !VM_MAYWRITE went in after commit
> cab350afcbc9.  I think it is more accurate to say that the issue was
> introduced with commit 63b2d4174c4a ("Introduce the new uffd-wp APIs
> for userspace.").  The convention in userfaultfd_register() is that the
> return code is set before testing condition which could cause return.
> Therefore, when 63b2d4174c4a added the VM_UFFD_WP && !VM_MAYWRITE check,
> it should have also added the 'ret = -EPERM;' statement.

Right, if there's a "fixes" then it should be the uffd-wp patch.

Though I really think it won't happen... Firstly because hugetlbfs is not yet
supported for uffd-wp, so the two "if" won't collapse, so no way to trigger it
imho. More importantly we've got one check ahead of it:

		/*
		 * UFFDIO_COPY will fill file holes even without
		 * PROT_WRITE. This check enforces that if this is a
		 * MAP_SHARED, the process has write permission to the backing
		 * file. If VM_MAYWRITE is set it also enforces that on a
		 * MAP_SHARED vma: there is no F_WRITE_SEAL and no further
		 * F_WRITE_SEAL can be taken until the vma is destroyed.
		 */
		ret = -EPERM;
		if (unlikely(!(cur->vm_flags & VM_MAYWRITE)))
			goto out_unlock;

AFAICT it will fail there directly when write perm is missing.

My wild guess is that the 1st version of 63b2d4174c4ad1f (2020) came earlier
than 29ec90660d (2018), however not needed anymore after the 2020 patch.  Hence
it's probably overlooked by me when I rebased.

Summary: IMHO no bug to fix, but we can directly drop the latter check?

Thanks,

-- 
Peter Xu

