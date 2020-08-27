Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792A625467B
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 16:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgH0OKM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 10:10:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728048AbgH0OJC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 10:09:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598537287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CvdhiPhYSGUOeaIN0B943JFU94tDWV4/UOsJxiz1v3Q=;
        b=VLU/EdIIUF3TolhlPrwmiZP747TI/B2Ku9ggaDjMmAhFnO8LdifPtgVdu30bAKi6+7tZsj
        kQmU+kHq8lBRzoCurGQQ3vrjmfTEvsG3iaW3aNgsDEc9K8r5vmnxUpkJtE0dFZsRvkJPnb
        6ciVJMnw5i7lM9y8xfXXDz9RYv/iWxM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-vnjPsEA1Pk6dk3RV-bLtsw-1; Thu, 27 Aug 2020 10:08:05 -0400
X-MC-Unique: vnjPsEA1Pk6dk3RV-bLtsw-1
Received: by mail-wm1-f69.google.com with SMTP id z1so2187730wmk.1
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 07:08:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CvdhiPhYSGUOeaIN0B943JFU94tDWV4/UOsJxiz1v3Q=;
        b=sQesNbhFr52FCITvj6glFAdqgcPCbY3oJIJifkNiAVPTBHQ51pbfwjiDzF4Jx7DtKd
         gV5Vd6vrcnfImsBZjKJg8JZFuXzqykrqvOPtdL8CrmcX0d1LB0A17/ZbQM4VYU89t5w+
         dHYmnH+/pCopKWFFLl3WZWDvibwXEGcMSAeaFHdOTVaVlUTN+yixV0hU/cTz0Nvat2Gb
         YgtmYM/63tDhbUfpk2KmRSD2girT0nXGPxbtxwm9NQQEhcFV8LS/KOgIXv7/H0k+dqCG
         ssNGmTKAogBsDf8TFQzaPXL+HuehOlYTBsjiOByzTtjtLHdNQAbbW5Z/ta4xtUzYFHdW
         bFSg==
X-Gm-Message-State: AOAM533V1TbGKlR4Fn+5k3f9e1A5lo4k7SXkg/ITc8M5n1kQJh7YfgFw
        PTIS6BPmLfhr3ZpX0xsRHwGJgOfmiSkQv/J57pp8k2RLVRGVySDdyBqeSGCK7vsRwTLxU3uLsmp
        VhXwBJc/cASWAmZXUimk=
X-Received: by 2002:a5d:66c1:: with SMTP id k1mr19971172wrw.8.1598537283953;
        Thu, 27 Aug 2020 07:08:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWw4gY+gfT3ioYFr28ZoapW9vPXQZrcRf4b8LhwoAGjeKf6Sd713KoEGCbzoU3U0KCeejqiw==
X-Received: by 2002:a5d:66c1:: with SMTP id k1mr19971132wrw.8.1598537283631;
        Thu, 27 Aug 2020 07:08:03 -0700 (PDT)
Received: from steredhat.lan ([5.171.209.212])
        by smtp.gmail.com with ESMTPSA id t14sm7282780wrg.38.2020.08.27.07.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 07:08:03 -0700 (PDT)
Date:   Thu, 27 Aug 2020 16:07:58 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Aleksa Sarai <asarai@suse.de>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Message-ID: <20200827140758.mboc7z2us2yqp356@steredhat.lan>
References: <20200827134044.82821-1-sgarzare@redhat.com>
 <20200827134044.82821-3-sgarzare@redhat.com>
 <206a32b6-ba20-fc91-1906-e6bf377798ae@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <206a32b6-ba20-fc91-1906-e6bf377798ae@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 27, 2020 at 07:49:45AM -0600, Jens Axboe wrote:
> On 8/27/20 7:40 AM, Stefano Garzarella wrote:
> > @@ -6414,6 +6425,19 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
> >  	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
> >  		return -EINVAL;
> >  
> > +	if (unlikely(ctx->restricted)) {
> > +		if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
> > +			return -EACCES;
> > +
> > +		if ((sqe_flags & ctx->restrictions.sqe_flags_required) !=
> > +		    ctx->restrictions.sqe_flags_required)
> > +			return -EACCES;
> > +
> > +		if (sqe_flags & ~(ctx->restrictions.sqe_flags_allowed |
> > +				  ctx->restrictions.sqe_flags_required))
> > +			return -EACCES;
> > +	}
> > +
> 
> This should be a separate function, ala:
> 
> if (unlikely(ctx->restricted)) {
> 	ret = io_check_restriction(ctx, req);
> 	if (ret)
> 		return ret;
> }
> 
> to move it totally out of the (very) hot path.

I'll fix.

> 
> >  	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
> >  	    !io_op_defs[req->opcode].buffer_select)
> >  		return -EOPNOTSUPP;
> > @@ -8714,6 +8738,71 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
> >  	return -EINVAL;
> >  }
> >  
> > +static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
> > +				    unsigned int nr_args)
> > +{
> > +	struct io_uring_restriction *res;
> > +	size_t size;
> > +	int i, ret;
> > +
> > +	/* We allow only a single restrictions registration */
> > +	if (ctx->restricted)
> > +		return -EBUSY;
> > +
> > +	if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
> > +		return -EINVAL;
> > +
> > +	size = array_size(nr_args, sizeof(*res));
> > +	if (size == SIZE_MAX)
> > +		return -EOVERFLOW;
> > +
> > +	res = memdup_user(arg, size);
> > +	if (IS_ERR(res))
> > +		return PTR_ERR(res);
> > +
> > +	for (i = 0; i < nr_args; i++) {
> > +		switch (res[i].opcode) {
> > +		case IORING_RESTRICTION_REGISTER_OP:
> > +			if (res[i].register_op >= IORING_REGISTER_LAST) {
> > +				ret = -EINVAL;
> > +				goto out;
> > +			}
> > +
> > +			__set_bit(res[i].register_op,
> > +				  ctx->restrictions.register_op);
> > +			break;
> > +		case IORING_RESTRICTION_SQE_OP:
> > +			if (res[i].sqe_op >= IORING_OP_LAST) {
> > +				ret = -EINVAL;
> > +				goto out;
> > +			}
> > +
> > +			__set_bit(res[i].sqe_op, ctx->restrictions.sqe_op);
> > +			break;
> > +		case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
> > +			ctx->restrictions.sqe_flags_allowed = res[i].sqe_flags;
> > +			break;
> > +		case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
> > +			ctx->restrictions.sqe_flags_required = res[i].sqe_flags;
> > +			break;
> > +		default:
> > +			ret = -EINVAL;
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	ctx->restricted = 1;
> > +
> > +	ret = 0;
> 
> I'd set ret = 0 above the switch, that's the usual idiom - start at
> zero, have someone set it to -ERROR if something fails.

Yes, it is better. I'll fix it.

Thanks,
Stefano

