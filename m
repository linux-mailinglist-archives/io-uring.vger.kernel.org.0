Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377BE6F2948
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 16:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjD3OiE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 10:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjD3OiC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 10:38:02 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1996101;
        Sun, 30 Apr 2023 07:38:01 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-3f1738d0d4cso8668525e9.1;
        Sun, 30 Apr 2023 07:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682865480; x=1685457480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pjAcu4IcSQRiDt8dUv43LgZPu6LvertkuJ0LwpP92lY=;
        b=AwXeeTCvJBDGZrjiIWMTewLQ4Yw6eDrYUWQdc+8D4Y0Zs0pFLk5pZ9KqT2bwNn1vbB
         0hLxi+2mKxFbi7bgm+HiNptCqecFwVSJFkLDKoDaUxImXjo/HjEiSK15tPgaskf85FL9
         s/8KRzBoJjaM9mkLQ+rW1k1lIj/jOAPdo9IJ3ORuFGlC2jwnadh9wFM3MmFMERPlNFW3
         6dAeXzhWDjQIbSWNeEMNprJnYYwiF2F6O9qBsaLhqzhKEBTGAATOrsviacSOC0GEb3cw
         tDU9AzPyPbxlB5sh7gV1DLU+jzSPVg0Ldei7svgmYQ7LUWJUO2RAjewgQUyH/zpVt1Se
         0nag==
X-Gm-Message-State: AC+VfDzDafdcBe5M1LmwXg8cBgVU5+dYUyNCvE5YWXykfliFESTidgpF
        FvUY+qYcgw1xYulqVbVbqnc=
X-Google-Smtp-Source: ACHHUZ5MAoJuX2opkQ1iG5lqU3GmlotVF/8I1OK08Oa68jNWUln3SI3TGJBlTblGXSKtA1vu+wOMHA==
X-Received: by 2002:a05:600c:b45:b0:3f2:5922:d955 with SMTP id k5-20020a05600c0b4500b003f25922d955mr9291474wmr.8.1682865480436;
        Sun, 30 Apr 2023 07:38:00 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-013.fbsv.net. [2a03:2880:31ff:d::face:b00c])
        by smtp.gmail.com with ESMTPSA id j32-20020a05600c1c2000b003f173987ec2sm33667582wms.22.2023.04.30.07.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 07:37:59 -0700 (PDT)
Date:   Sun, 30 Apr 2023 07:37:58 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, leit@fb.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        sagi@grimberg.me, kbusch@kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH 1/2] io_uring: Pass whole sqe to commands
Message-ID: <ZE59RGJZd8DyDQaX@gmail.com>
References: <20230419102930.2979231-1-leitao@debian.org>
 <20230419102930.2979231-2-leitao@debian.org>
 <20230420045712.GA4239@lst.de>
 <ZEEwHk32Y8IcT20n@gmail.com>
 <20230420123139.GA32030@lst.de>
 <ZEEyKolzQgfkEOwv@gmail.com>
 <20230420124615.GA733@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420124615.GA733@lst.de>
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 20, 2023 at 02:46:15PM +0200, Christoph Hellwig wrote:
> On Thu, Apr 20, 2023 at 05:38:02AM -0700, Breno Leitao wrote:
> > Since we are not coping the payload anymore, this is not necessary. Now
> > we are copying 64 bytes for the single SQE or 128 bytes for double SQE.
> > 
> > Do you prefer I create a helper that returns the SQE size, instead of
> > doing the left shift?
> 
> I think a helper would be nice.  And adding another sizeof(sqe) seems
> more self documenting then the shift, but if you really prefer the
> shift at least write a good comment explaining it.

Agree, this is a good idea. I've fixed it in the nvme code by creating a
function helper.
The same problem happen on the ublkd_drv, and I've also fixed it there
in a new patch.

	https://lkml.org/lkml/2023/4/30/94

Thanks for the review.
