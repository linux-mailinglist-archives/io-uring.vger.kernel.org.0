Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BA82EE7FE
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 22:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbhAGVxp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 16:53:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbhAGVxp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 16:53:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610056338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e/5UZ6AQFSYK1yZlQH6NOXZBaNAtgnhFETBa2236qEo=;
        b=YA8tpnP4XU9YyQG75nO/CQjiBAyqQIDUy0BQQxhOziQZt4ytUbsy0AQq1Q0q/KaktmdFer
        6zWFUTDZAhJxnr/6PEJ/Aj242wofy9t52J6Q4epIOLh0qYNu7ZCzUnMMWSsidFmIwLX+B8
        epo0AEEpyKjL7glkCtv9aEWshz5nb+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-YeozKnpqN7mdvu6h9PU5zA-1; Thu, 07 Jan 2021 16:52:17 -0500
X-MC-Unique: YeozKnpqN7mdvu6h9PU5zA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06F128049C1;
        Thu,  7 Jan 2021 21:52:16 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 646AB60CC3;
        Thu,  7 Jan 2021 21:52:11 +0000 (UTC)
Date:   Thu, 7 Jan 2021 16:52:10 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 4/7] block: define blk_qc_t as uintptr_t
Message-ID: <20210107215210.GD21239@redhat.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
 <20201223112624.78955-5-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223112624.78955-5-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 23 2020 at  6:26am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> To support iopoll for bio-based device, the returned cookie is actually
> a pointer to an implementation specific object, e.g. an object
> maintaining all split bios.
> 
> In such case, blk_qc_t should be large enough to contain one pointer,
> for which uintptr_t is used here. Since uintptr_t is actually an integer
> type in essence, there's no need of type casting in the original mq
> path, while type casting is indeed needed in bio-based routine.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  include/linux/types.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/types.h b/include/linux/types.h
> index da5ca7e1bea9..f6301014a459 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -126,7 +126,7 @@ typedef u64 sector_t;
>  typedef u64 blkcnt_t;
>  
>  /* cookie used for IO polling */
> -typedef unsigned int blk_qc_t;
> +typedef uintptr_t blk_qc_t;
>  
>  /*
>   * The type of an index into the pagecache.

I'd just fold this into patch 6.. not seeing benefit to having this be
separate.

Patch 6's header needs a lot more detail anyway so..

