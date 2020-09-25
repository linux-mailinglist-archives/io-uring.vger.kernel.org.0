Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8732782C6
	for <lists+io-uring@lfdr.de>; Fri, 25 Sep 2020 10:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgIYIcU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Sep 2020 04:32:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726990AbgIYIcT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Sep 2020 04:32:19 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601022738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TKoL37A5XuAnt9jnwVWFE5yXi8J32yxwwLje6wN+ynI=;
        b=XH8WnoeMK2Gs5uYyVxm0hS1Dy3qjEHxNY6IxpvCFzxSQ1AwtqeYcpzvndG6arENDAe6E2r
        U7ey1TMDskcAzXIdWe/bwV0zPP44KF3fsSBYJ++pnbtY73YqKsyJvPUaKq/5qu4vIIsYOz
        hZNp+SmoGO3HVRm5BE1JaWA3yKHzqzQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-oHTYjr4PPmeMEr9JqKEp2w-1; Fri, 25 Sep 2020 04:32:15 -0400
X-MC-Unique: oHTYjr4PPmeMEr9JqKEp2w-1
Received: by mail-wr1-f71.google.com with SMTP id a10so772481wrw.22
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 01:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TKoL37A5XuAnt9jnwVWFE5yXi8J32yxwwLje6wN+ynI=;
        b=S5660tcCushapukDU2pPV+X099akY/j0Xx9T3TMtAKMevRf3EAeqCKU6xK5YBovMWx
         PmlOIQd1bF19ZM9SgmhfALDQ9HPpZs2PX1uoZhHpyMqU71F411fOFchyt5RCT5Q5Qnkv
         bUFJ9dPZFf/dHwHxmeCshrVo0pQv+/xk7vDBmf5lF404uBrGRluflUzdIJR0vBZ0wqOh
         W5xa4jU/aPjoIQxS1OGWCEY5teBW05onnYcXPA1Uv5NrIV0IpmUa44wgyj6RfWWyAPsl
         X5qCuWHk++PgUFYdQJ0XYgPExpOBYyzDHjpNeuqzxSFE6PTLPAxSSBupKSHQ784x4/04
         gqlg==
X-Gm-Message-State: AOAM530Wj4CwCA8cczyMTEVpFhYrJm9mF8ay9E3zYi0sm8QkEC+j602V
        1Lj2/geMFQJB2vYliShPFu3yXyi1EFNW0Nq2RgfI7s3Fi7K9Aq8zflNl4SqcFok99Oy9KAlyLgC
        kn9AYZ/xcwFC5pRjfKBE=
X-Received: by 2002:a1c:6555:: with SMTP id z82mr1851977wmb.101.1601022734224;
        Fri, 25 Sep 2020 01:32:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR1WX4CEXwaLozrvZMsSgcq/K8L7nTLptigsPxZgytFVVP+DikmreYZ0jKDSqXNdW47a6XWg==
X-Received: by 2002:a1c:6555:: with SMTP id z82mr1851957wmb.101.1601022733956;
        Fri, 25 Sep 2020 01:32:13 -0700 (PDT)
Received: from steredhat (host-80-116-189-193.retail.telecomitalia.it. [80.116.189.193])
        by smtp.gmail.com with ESMTPSA id n10sm2053405wmk.7.2020.09.25.01.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 01:32:13 -0700 (PDT)
Date:   Fri, 25 Sep 2020 10:32:10 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: ensure open/openat2 name is cleaned on
 cancelation
Message-ID: <20200925083210.xwfmssdvg4t6j3ar@steredhat>
References: <ea883f39-0da5-fcd3-a069-43d7f5002380@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea883f39-0da5-fcd3-a069-43d7f5002380@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 24, 2020 at 02:59:33PM -0600, Jens Axboe wrote:
> io_uring: ensure open/openat2 name is cleaned on cancelation
> 
> If we cancel these requests, we'll leak the memory associated with the
> filename. Add them to the table of ops that need cleaning, if
> REQ_F_NEED_CLEANUP is set.
> 

IIUC we inadvertently removed 'putname(req->open.filename)' from the cleanup
function in commit e62753e4e292 ("io_uring: call statx directly").

Should we add the Fixes tag?

    Fixes: e62753e4e292 ("io_uring: call statx directly")

I'm not sure since the code is changed a bit.

Anyway the patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

> Cc: stable@vger.kernel.org # v5.6+
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> --
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e6004b92e553..0ab16df31288 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5671,6 +5671,11 @@ static void __io_clean_op(struct io_kiocb *req)
>  			io_put_file(req, req->splice.file_in,
>  				    (req->splice.flags & SPLICE_F_FD_IN_FIXED));
>  			break;
> +		case IORING_OP_OPENAT:
> +		case IORING_OP_OPENAT2:
> +			if (req->open.filename)
> +				putname(req->open.filename);
> +			break;
>  		}
>  		req->flags &= ~REQ_F_NEED_CLEANUP;
>  	}
> 
> -- 
> Jens Axboe
> 

