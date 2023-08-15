Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D37477D35F
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 21:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbjHOTZ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 15:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239926AbjHOTZo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 15:25:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9FB1FF1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 12:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692127461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5iwNtXyVC59To71ph/ZKdTniHJJAlun4JMzYFhELgT0=;
        b=U3bJZhCfZt9BXQkaED6xb/uQTYN//XkIY+1DWV0m64VOu99MyYQCUUcAsqyW0R78tIvSFQ
        Z/1GabmfCJAQju5OtDoSdrVvLx/T3LSMeNlx2Gz4tSSe2DG1C/jiPi8QMkqprMpKgpWjjG
        untahbQhDyPO2MFQvITNe42hQo3tG4U=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-bvII6brRMXyjddBjOOyuuw-1; Tue, 15 Aug 2023 15:24:19 -0400
X-MC-Unique: bvII6brRMXyjddBjOOyuuw-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3a716f3b5b9so2111455b6e.1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 12:24:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692127459; x=1692732259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iwNtXyVC59To71ph/ZKdTniHJJAlun4JMzYFhELgT0=;
        b=A3sqn2/hmARvj6b/QEltdnvCA5TeZalx0SlyMhNUHNej2xP/8KbKhCszEKIx5IX/WE
         x59KfqY9B3U2fDjLYKm5oAVDzNQ/Pua2DY99rawlK5oU280tRfYju4Cpuw+YyMpSF/nM
         J3tHC0I8nctGO6qgRf/YaqgLSvdckjzKDDz1N9Cuh/l+wXXSKqytXg+xxfWWBOdtmzxM
         Xrsqh5hn0KfIDHnBxzSi/Z+o7piGEAQi4+0mT6ygn0VpDftBDJqBOt/Y6CjLil9DuTZc
         fdyPCOY/e3j66YjbVUQCrf3GRdzhpzS3I54C85YLQbNvpCH/9SNpBnFrMN0U98Lz4h0f
         tyYw==
X-Gm-Message-State: AOJu0YyuRyLljdLLFMACbNzcpf+S/A0wIt3WoHLTwIYUBjHqpFCmxZTr
        XhWk3EIkPce4Bwcm8cX3H91ntU0AhJ2ypXtCxSxPB8N6RGXwPCSl/CylSvO7jOuaUjHuZ37Y9O8
        Mf1bXg7ZC0+spp0BmH+VULQzhcf8=
X-Received: by 2002:a05:6808:6509:b0:39e:ab5c:91db with SMTP id fm9-20020a056808650900b0039eab5c91dbmr11345208oib.2.1692127458936;
        Tue, 15 Aug 2023 12:24:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFjuXoNAblX6khjjlI+bkcGZYW+5MOM2WN4wnXD+J4kH0OodENV23nCGnKZAqUA0vn3/im3g==
X-Received: by 2002:a05:6808:6509:b0:39e:ab5c:91db with SMTP id fm9-20020a056808650900b0039eab5c91dbmr11345197oib.2.1692127458625;
        Tue, 15 Aug 2023 12:24:18 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id op29-20020a05620a535d00b0076c84240467sm3941292qkn.52.2023.08.15.12.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 12:24:18 -0700 (PDT)
Date:   Tue, 15 Aug 2023 15:24:16 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 8/9] mm: Rearrange page flags
Message-ID: <ZNvQ4EbQh/aAwK8L@x1n>
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-9-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230815032645.1393700-9-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 15, 2023 at 04:26:44AM +0100, Matthew Wilcox (Oracle) wrote:
> Move PG_writeback into bottom byte so that it can use PG_waiters in a
> later patch.  Move PG_head into bottom byte as well to match with where
> 'order' is moving next.  PG_active and PG_workingset move into the second
> byte to make room for them.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/page-flags.h | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index aabf50dc71a3..6a0dd94b2460 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -99,13 +99,15 @@
>   */
>  enum pageflags {
>  	PG_locked,		/* Page is locked. Don't touch. */
> +	PG_writeback,		/* Page is under writeback */
>  	PG_referenced,
>  	PG_uptodate,
>  	PG_dirty,
>  	PG_lru,
> +	PG_head,		/* Must be in bit 6 */

Could there be some explanation on "must be in bit 6" here?

Thanks,

-- 
Peter Xu

