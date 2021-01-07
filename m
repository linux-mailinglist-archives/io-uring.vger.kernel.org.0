Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7B92ED72A
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 20:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbhAGTF6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 14:05:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729243AbhAGTF6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 14:05:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610046272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K5vzrkToFEu51YnZZlMXR5lsFFTx+s92dDruyBqosAg=;
        b=EucXfYJrg8TYUUWr75cdBfpOdJ33vbMzHHbh43tAOH1zzq214g7lbrRHROC+nGRryf+eTX
        nEm/xy0i34QvlAqI1XPOT/h7cCGAdTqyoYWR16rGmc2Nu5OWWf60LnT5B2Csm5v4jlLl1b
        EB58gpLJ9T7JD7y2dPnhfvVRkyaxWmM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-AMo8fFAVOw-XAxQewpoJrw-1; Thu, 07 Jan 2021 14:04:30 -0500
X-MC-Unique: AMo8fFAVOw-XAxQewpoJrw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 001E01800D42;
        Thu,  7 Jan 2021 19:04:29 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E5CF26268F;
        Thu,  7 Jan 2021 19:04:25 +0000 (UTC)
Date:   Thu, 7 Jan 2021 14:04:24 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 1/7] block: move definition of blk_qc_t to types.h
Message-ID: <20210107190424.GA21239@redhat.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
 <20201223112624.78955-2-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223112624.78955-2-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 23 2020 at  6:26am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> So that kiocb.ki_cookie can be defined as blk_qc_t, which will enforce
> the encapsulation.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  include/linux/blk_types.h | 2 +-
>  include/linux/fs.h        | 2 +-
>  include/linux/types.h     | 3 +++
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 866f74261b3b..2e05244fc16d 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -532,7 +532,7 @@ static inline int op_stat_group(unsigned int op)
>  	return op_is_write(op);
>  }
>  
> -typedef unsigned int blk_qc_t;
> +/* Macros for blk_qc_t */
>  #define BLK_QC_T_NONE		-1U
>  #define BLK_QC_T_SHIFT		16
>  #define BLK_QC_T_INTERNAL	(1U << 31)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index ad4cf1bae586..58db714c4834 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -330,7 +330,7 @@ struct kiocb {
>  	u16			ki_hint;
>  	u16			ki_ioprio; /* See linux/ioprio.h */
>  	union {
> -		unsigned int		ki_cookie; /* for ->iopoll */
> +		blk_qc_t		ki_cookie; /* for ->iopoll */
>  		struct wait_page_queue	*ki_waitq; /* for async buffered IO */
>  	};
>  
> diff --git a/include/linux/types.h b/include/linux/types.h
> index a147977602b5..da5ca7e1bea9 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -125,6 +125,9 @@ typedef s64			int64_t;
>  typedef u64 sector_t;
>  typedef u64 blkcnt_t;
>  
> +/* cookie used for IO polling */
> +typedef unsigned int blk_qc_t;
> +
>  /*
>   * The type of an index into the pagecache.
>   */
> -- 
> 2.27.0
> 

Unfortunate that you cannot just include blk_types.h in fs.h; but
vma_is_dax() ruins that for us since commit baabda2614245 ("mm: always
enable thp for dax mappings").

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

