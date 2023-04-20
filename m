Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151906E943D
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 14:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjDTM3Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 08:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjDTM3Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 08:29:24 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333625BAD;
        Thu, 20 Apr 2023 05:29:22 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id bi21-20020a05600c3d9500b003f17a8eaedbso2993246wmb.1;
        Thu, 20 Apr 2023 05:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681993760; x=1684585760;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTcuP2C+AJHG/nFwJnZGd+3L+CfBLV6Vu/A/V4+9EqA=;
        b=Bzs4hIlK+NWIiwvwAKXTNutwQZjfCcoTpmRSYsfZRvzigTUCmy/jgjXmxz7yCocTag
         DjpOh0ByVhML3Vgz3PAHIM7akKRY1wQ8LoPBks65Pu0+jbF2z9YiwQgfzPSgxYLFjLvB
         rr//rAgOqhvht4gWh6PAtbhcUrx7onWaVqoWwmdHJuUDKk2nZ+Eo8ujcJ1LHRuam3PZf
         u2idENlQgn+02e0AHLRy1LJ0MvbZt4seatLEDzDXRamEXDMOzHeuWlM/QIvmvoUc3BUu
         8OijfS4FsOu2SqinzwQjb0vHJjPBrLTKRoyYIFER2+xn5qV68GT3xIBSKjZrXdNXYX2f
         HaCA==
X-Gm-Message-State: AAQBX9duh8PxvrgHh7LC+cfEEF7S+sE9BOJUoqt/I8UesiHbGYtPaYcU
        Z82Xi5WH5tZJGIUgyKOq4IE=
X-Google-Smtp-Source: AKy350aaCNOtF1Dp5FVmsyixW1o7a582KZIzbTA6bAcNcvBvAfmJ9yC1qp5VWWLw8itQjbmItpc17w==
X-Received: by 2002:a1c:6a02:0:b0:3ee:3e07:5d26 with SMTP id f2-20020a1c6a02000000b003ee3e075d26mr1076568wmc.24.1681993760341;
        Thu, 20 Apr 2023 05:29:20 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-015.fbsv.net. [2a03:2880:31ff:f::face:b00c])
        by smtp.gmail.com with ESMTPSA id o2-20020a05600c4fc200b003f1738e64c0sm5317875wmq.20.2023.04.20.05.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 05:29:19 -0700 (PDT)
Date:   Thu, 20 Apr 2023 05:29:18 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, leit@fb.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        sagi@grimberg.me, kbusch@kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH 1/2] io_uring: Pass whole sqe to commands
Message-ID: <ZEEwHk32Y8IcT20n@gmail.com>
References: <20230419102930.2979231-1-leitao@debian.org>
 <20230419102930.2979231-2-leitao@debian.org>
 <20230420045712.GA4239@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420045712.GA4239@lst.de>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Christoph,

On Thu, Apr 20, 2023 at 06:57:12AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 19, 2023 at 03:29:29AM -0700, Breno Leitao wrote:
> >  	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> > -	const struct nvme_uring_cmd *cmd = ioucmd->cmd;
> > +	const struct nvme_uring_cmd *cmd = (struct nvme_uring_cmd *)ioucmd->sqe->cmd;
> 
> Please don't add the pointless cast.  And in general avoid the overly
> long lines.

Ack!

> 
> I suspect most other users should just also defined their structures
> const instead of adding all theses casts thare are a sign of problems,
> but that's a pre-existing issue.
> >  	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> > -	size_t cmd_size;
> > +	size_t size = sizeof(struct io_uring_sqe);
> >  
> >  	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
> >  	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
> >  
> > -	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
> > +	if (req->ctx->flags & IORING_SETUP_SQE128)
> > +		size <<= 1;
> 
> 
> Why does this stop using uring_cmd_pdu_size()?

Before, only the cmd payload (sqe->cmd) was being copied to the async
structure. We are copying over the whole sqe now, since we can use SQE
fields inside the ioctl callbacks (instead of only cmd fields). So, the
copy now is 64 bytes for single SQE or 128 for double SQEs.

This has two major advantages:
 * It is not necessary to create a cmd structure for every command
   operations (which will be mapped in sqe->cmd) to pass arguments. The
   arguments could be passed as fields in SQE.

 * sqe->cmd is 16 bytes on single SQEs. Passing the whole SQE to cmd
   will reduce the necessity to use double SQE for operations that
   require large fields, such as {g,s}etsockopt().

There are some discussions about it also at
https://lkml.org/lkml/2023/4/6/786

Thanks for the review!
