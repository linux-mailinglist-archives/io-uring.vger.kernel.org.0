Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FE625387C
	for <lists+io-uring@lfdr.de>; Wed, 26 Aug 2020 21:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgHZTq3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Aug 2020 15:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgHZTq1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Aug 2020 15:46:27 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05D2C061756
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 12:46:26 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 67so1608973pgd.12
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 12:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lIC466wcHw5fR4eYEVc57sBZjLUX/gzzPPg8yLp1ZZU=;
        b=WFkrzFpr1SUiFaPbGhhpAKHAmVxv3wzkj4tDR+4PHOR9/MlIRPYJGnmI664QGeO/Cx
         jh56BsF4d4+yUYLb3tteEQtrETtrsW7Vukw+0hQQ46Y1kVm7YzGQ12QR8x1BVWPj5ZyL
         5rDrqojD9sPXkIKEP7O2wCAa1fCxfWjqV9Rc4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lIC466wcHw5fR4eYEVc57sBZjLUX/gzzPPg8yLp1ZZU=;
        b=BKDAI66siV/Jb5UQFP+YXVuL6QgSXf5pSgN4fSbSTmIMn0byfYZu1yOgD/XsNydMHG
         2KnAX5tAmiWrzRMQMIvV9lMPhH7eiQBc3Y1b8RUSMWJUkIhjYPgW5OY+Soqe9cuJVoIp
         ePSqQlVzFooAfnzeBz046/Dquv0EhxzKryMjvbAOLO+f1akuwcfRN/blL0bWi3GBatRF
         K26fw4hdF/iYqPAyNKBNAggjqrExV/ricNs4GACXgkJrr+IL42veYmYfFaE9TubT8x3Q
         cWnHZ9FJ2FZ5dBfZazyqIBNhKisSG+0pzGBbXdnppwUI51Bi8/q2Al+V3nnYU//wqMzG
         AB6w==
X-Gm-Message-State: AOAM533djbmgrdIkqriIe2SQUDSVzgFuVOTIrgkWa72CVlrk25aCXNon
        YqKLfw1AXAjMQtoQQMNYl/E5sw==
X-Google-Smtp-Source: ABdhPJzfdv5XUXwJl1UOhKF/pH+9I5ADCLKzvf0FKe3PbEuFazJPlW1HymFX95ObV8KRL+rwcPkouA==
X-Received: by 2002:a62:5212:: with SMTP id g18mr8576508pfb.8.1598471186120;
        Wed, 26 Aug 2020 12:46:26 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ds19sm2262912pjb.43.2020.08.26.12.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 12:46:25 -0700 (PDT)
Date:   Wed, 26 Aug 2020 12:46:24 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Aleksa Sarai <asarai@suse.de>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Message-ID: <202008261245.245E36654@keescook>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-3-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813153254.93731-3-sgarzare@redhat.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 13, 2020 at 05:32:53PM +0200, Stefano Garzarella wrote:
> +/*
> + * io_uring_restriction->opcode values
> + */
> +enum {
> +	/* Allow an io_uring_register(2) opcode */
> +	IORING_RESTRICTION_REGISTER_OP,
> +
> +	/* Allow an sqe opcode */
> +	IORING_RESTRICTION_SQE_OP,
> +
> +	/* Allow sqe flags */
> +	IORING_RESTRICTION_SQE_FLAGS_ALLOWED,
> +
> +	/* Require sqe flags (these flags must be set on each submission) */
> +	IORING_RESTRICTION_SQE_FLAGS_REQUIRED,
> +
> +	IORING_RESTRICTION_LAST
> +};

Same thought on enum literals, but otherwise, looks good:

Reviewed-by: Kees Cook <keescook@chromium.org>


-- 
Kees Cook
