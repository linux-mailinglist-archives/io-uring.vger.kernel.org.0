Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0A82E1B01
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 11:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgLWKh6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 05:37:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44618 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728300AbgLWKh5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 05:37:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608719790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JeL+sySS7k8jG+aP6agJGo+mCgZEBSnCjyJhU3/A0Mo=;
        b=jIqjY9FHvy0Y76H++A3RfN0B5W+WxkLGQV40anFafmD0etnYEQSoSRtSpO+0bRvRXHR1Ez
        FuDq6f4a8mnjE+MrWq9bKmCk1Ibb2dC349TrnwRs9nKmrwoBIXu5BMKIK7fFHdn2jAcFUd
        t7byehbnfDhsKjSYbRkShTKs8aoxH2Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-UwvpJwapMgGDixiua29ZMA-1; Wed, 23 Dec 2020 05:36:27 -0500
X-MC-Unique: UwvpJwapMgGDixiua29ZMA-1
Received: by mail-wr1-f72.google.com with SMTP id d2so12166909wrr.5
        for <io-uring@vger.kernel.org>; Wed, 23 Dec 2020 02:36:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JeL+sySS7k8jG+aP6agJGo+mCgZEBSnCjyJhU3/A0Mo=;
        b=Ue1g09yIc6JcR42OXBzsieATVnUz9Opw3ZsuU7r/bHW1kTcL8Ij/E+sWQGK2RuYPIZ
         Ebjp5EnTkR4LLhi7NdgRuEQd2yTnHiE/av+1R0C8vMYXsyfGCyxYcML6idF0vXlQh+/c
         dqoTLwUg6avYj17nXbtH2uUKQwK8y1puBSQa7giM4LHZlZk71RGIEF8RbNsCPMHLuIDb
         cwNGVlEdjtd4Vx7iA7WsfyGV4C9aByxed12mGbsuFR8TOfMpY8As0ZfpEWuC2Pv3/elh
         7k8la0ncA6GKKBuy0s8gH9h0+FrdbdE5wTvQxkPb6bh2JNcriMeQO0zOSYBmktEEX0+F
         GbPA==
X-Gm-Message-State: AOAM532uUE9w3rF6HPp3TpQWHxs5RxJ9ygfBhbe5W7vjfLXTGIEKylFV
        DmGGTHFD/q6XZPkzGFnQBootm579jKZrKdF28xjE5Fkbsc293cMk2vDDLW3ge2EmPPqkH3DTjib
        VCUey2AtceAWJ7OnhLCk=
X-Received: by 2002:a1c:3b02:: with SMTP id i2mr25617264wma.141.1608719786722;
        Wed, 23 Dec 2020 02:36:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyL2/fhip+Yq7EZYOid/GS8AVuma752Njwco2i4gQCp0+G7I5yytGbyOui1hgxxA/suxT+4jQ==
X-Received: by 2002:a1c:3b02:: with SMTP id i2mr25617246wma.141.1608719786512;
        Wed, 23 Dec 2020 02:36:26 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id u3sm39250026wre.54.2020.12.23.02.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 02:36:25 -0800 (PST)
Date:   Wed, 23 Dec 2020 11:36:23 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring: remove io_remove_personalities()
Message-ID: <20201223103623.mxjsmitdmqsx6ftd@steredhat>
References: <1608694025-121050-1-git-send-email-yejune.deng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1608694025-121050-1-git-send-email-yejune.deng@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 23, 2020 at 11:27:05AM +0800, Yejune Deng wrote:
>The function io_remove_personalities() is very similar to
>io_unregister_personality(),but the latter has a more reasonable
>return value.
>
>Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
>---
> fs/io_uring.c | 25 ++++++-------------------
> 1 file changed, 6 insertions(+), 19 deletions(-)

The patch LGTM, maybe as an alternative you can leave 
io_remove_personality() with the interface needed by idr_for_each() and 
implement io_unregister_personality() calling io_remove_personality() 
with the right parameters.

Just an idea, but I'm also fine with this patch, so:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/fs/io_uring.c b/fs/io_uring.c
>index b749578..000ea9a 100644
>--- a/fs/io_uring.c
>+++ b/fs/io_uring.c
>@@ -8608,7 +8608,7 @@ static int io_uring_fasync(int fd, struct file *file, int on)
> 	return fasync_helper(fd, file, on, &ctx->cq_fasync);
> }
>
>-static int io_remove_personalities(int id, void *p, void *data)
>+static int io_unregister_personality(int id, void *p, void *data)
> {
> 	struct io_ring_ctx *ctx = data;
> 	struct io_identity *iod;
>@@ -8618,8 +8618,10 @@ static int io_remove_personalities(int id, void *p, void *data)
> 		put_cred(iod->creds);
> 		if (refcount_dec_and_test(&iod->count))
> 			kfree(iod);
>+		return 0;
> 	}
>-	return 0;
>+
>+	return -EINVAL;
> }
>
> static void io_ring_exit_work(struct work_struct *work)
>@@ -8657,7 +8659,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>
> 	/* if we failed setting up the ctx, we might not have any rings */
> 	io_iopoll_try_reap_events(ctx);
>-	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
>+	idr_for_each(&ctx->personality_idr, io_unregister_personality, ctx);
>
> 	/*
> 	 * Do this upfront, so we won't have a grace period where the ring
>@@ -9679,21 +9681,6 @@ static int io_register_personality(struct io_ring_ctx *ctx)
> 	return ret;
> }
>
>-static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>-{
>-	struct io_identity *iod;
>-
>-	iod = idr_remove(&ctx->personality_idr, id);
>-	if (iod) {
>-		put_cred(iod->creds);
>-		if (refcount_dec_and_test(&iod->count))
>-			kfree(iod);
>-		return 0;
>-	}
>-
>-	return -EINVAL;
>-}
>-
> static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
> 				    unsigned int nr_args)
> {
>@@ -9906,7 +9893,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
> 		ret = -EINVAL;
> 		if (arg)
> 			break;
>-		ret = io_unregister_personality(ctx, nr_args);
>+		ret = io_unregister_personality(nr_args, NULL, ctx);
> 		break;
> 	case IORING_REGISTER_ENABLE_RINGS:
> 		ret = -EINVAL;
>-- 
>1.9.1
>

