Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897996814C2
	for <lists+io-uring@lfdr.de>; Mon, 30 Jan 2023 16:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238134AbjA3PVN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Jan 2023 10:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235703AbjA3PVF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Jan 2023 10:21:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04199C15C
        for <io-uring@vger.kernel.org>; Mon, 30 Jan 2023 07:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675092003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ah3avzpBOJRu+37auLlVBnHx/4BkYm4lFjO5EaAcHnw=;
        b=G1re2WQ+bkjlExN/Br7YLaHiY+9IDDPVczL/Ijo/HVA9s2KDjNSoEF/wLy/E/hmfLUhLJs
        Quq90SpJhOTvihpY6G5IPwlJaNYc4vFJK4aLXNkpXoqqw8ZQrxNnq4nL3VjIzF1rcDonVy
        wJY4p0Y+1Km5pGr94wolo799FN+jdBk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-314-lim6jw87PFidrUhAP1pkkg-1; Mon, 30 Jan 2023 10:20:00 -0500
X-MC-Unique: lim6jw87PFidrUhAP1pkkg-1
Received: by mail-wr1-f71.google.com with SMTP id o9-20020adfa109000000b002bfc062eaa8so2061230wro.20
        for <io-uring@vger.kernel.org>; Mon, 30 Jan 2023 07:20:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ah3avzpBOJRu+37auLlVBnHx/4BkYm4lFjO5EaAcHnw=;
        b=TlETojXau/zrCf+a8kU5l2XGBcOEhBsI+ZcYIvNbbrSwLhMiLhnilFAh67XMNUYFOh
         /LV1r3nxsEO9utTQSDbe5d4debFqEjOKixbwJ/ScO/FdS2qkYqapBim3UBKa0y8UTPQQ
         d4XrOezp6ySE6jKc2WKzvyHWRSrsAsjCCStjbZ7BrAylTNsoQiB8sNQuzklSMmGBiPb5
         WJpSgF5pyKGpvz3plXliOr9gtxSZPRPq0kx6vHyJ9Szsc26Fmb4AZwo2OF/mfvUDcgZb
         7Pjk8XSoxU55P0pr+KSKWLHIgzvQkpvPjlrJHBvgVeMzv+1kPf9Fpss3fV/DXJzzGG4q
         mn6w==
X-Gm-Message-State: AFqh2kpMAtZTclbPxDrHp91tqzE4hH6GD0TBW+fzUayJxrPMBqCqnbkh
        oHXOskHQQBbc9VLOrndveHHaRGtLNYAP2XPbUhOewil32WzkaZANw0GeVlZv38txdbD08XYnLda
        13ZuZEq54Qer3jKHL4/8=
X-Received: by 2002:a05:600c:1e21:b0:3d0:7fee:8a70 with SMTP id ay33-20020a05600c1e2100b003d07fee8a70mr52242952wmb.19.1675091999184;
        Mon, 30 Jan 2023 07:19:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsu1w8+EO1CI/aqnigYPF7jxubbyQ5nAweq8tir4J7qtyJNK1XxMEfGlrHUe8RqvFQGuvEBew==
X-Received: by 2002:a05:600c:1e21:b0:3d0:7fee:8a70 with SMTP id ay33-20020a05600c1e2100b003d07fee8a70mr52242919wmb.19.1675091998974;
        Mon, 30 Jan 2023 07:19:58 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id f9-20020a05600c4e8900b003d990372dd5sm18938810wmq.20.2023.01.30.07.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 07:19:58 -0800 (PST)
Date:   Mon, 30 Jan 2023 10:19:51 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, devel@lists.orangefs.org,
        io-uring@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 22/23] vring: use bvec_set_page to initialize a bvec
Message-ID: <20230130101811-mutt-send-email-mst@kernel.org>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-23-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130092157.1759539-23-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 30, 2023 at 10:21:56AM +0100, Christoph Hellwig wrote:
> Use the bvec_set_page helper to initialize a bvec.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/vhost/vringh.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 33eb941fcf1546..a1e27da544814a 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1126,9 +1126,8 @@ static int iotlb_translate(const struct vringh *vrh,
>  		size = map->size - addr + map->start;
>  		pa = map->addr + addr - map->start;
>  		pfn = pa >> PAGE_SHIFT;
> -		iov[ret].bv_page = pfn_to_page(pfn);
> -		iov[ret].bv_len = min(len - s, size);
> -		iov[ret].bv_offset = pa & (PAGE_SIZE - 1);
> +		bvec_set_page(&iov[ret], pfn_to_page(pfn), min(len - s, size),
> +			      pa & (PAGE_SIZE - 1));
>  		s += size;
>  		addr += size;
>  		++ret;
> -- 
> 2.39.0

