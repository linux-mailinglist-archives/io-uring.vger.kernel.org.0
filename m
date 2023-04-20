Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA706E94A3
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 14:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjDTMiQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 08:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbjDTMiP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 08:38:15 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BAD65B5;
        Thu, 20 Apr 2023 05:38:06 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id q5so1151712wmo.4;
        Thu, 20 Apr 2023 05:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681994285; x=1684586285;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MN0ovZHpN8SCVLE+Wi4d2r6KhQWAauDovMf24m5eUIY=;
        b=N74jg6edLWNWqRnRCTo+kiTTgaFV6STLW4THCDfIb5vJgiZ4bPV6EspPaYdrPQN94u
         93M+wBajuMWkemQUkO9iL2ZMNyW/iFxR6g9OBvgqsb5xvVQqHVj+vKbWMF7VTBhUYWVy
         TKK3v5rN2fbBEls40FQ4BwdmzC3+VF6exiDAxavGfqLZY8QFkxRDO6zk2w68PdMchXsR
         G9WvqB3OO1yz8S3UQvH7hKV/2D8/PZdnhgWZZmVsxn6ohwcw7kkXrgZdx6CbRh6Q0mAR
         FM1XjAfvdMfyvHypYtgHF7Gsap1apY4uRfkf3s/hmazgPMCDwyHMk/Y4Ho2lm2crepgf
         ZOAQ==
X-Gm-Message-State: AAQBX9dZRAOP2vE2GUBwLFtPjqrAsrJJpjVfhExyLD4VEjsodf7J0H1p
        dF1mgYVpBEInWzTlortlNHk=
X-Google-Smtp-Source: AKy350bQ9708hbMQVHk61xT3LFrYNHvJx32Hxxd71tA4xcWwGK3ktp6cb2BZ2HZNpKUoffYiRNK5uQ==
X-Received: by 2002:a1c:f202:0:b0:3ed:f5b5:37fc with SMTP id s2-20020a1cf202000000b003edf5b537fcmr1132978wmc.1.1681994284901;
        Thu, 20 Apr 2023 05:38:04 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-014.fbsv.net. [2a03:2880:31ff:e::face:b00c])
        by smtp.gmail.com with ESMTPSA id m36-20020a05600c3b2400b003edc4788fa0sm5413733wms.2.2023.04.20.05.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 05:38:04 -0700 (PDT)
Date:   Thu, 20 Apr 2023 05:38:02 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, leit@fb.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        sagi@grimberg.me, kbusch@kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH 1/2] io_uring: Pass whole sqe to commands
Message-ID: <ZEEyKolzQgfkEOwv@gmail.com>
References: <20230419102930.2979231-1-leitao@debian.org>
 <20230419102930.2979231-2-leitao@debian.org>
 <20230420045712.GA4239@lst.de>
 <ZEEwHk32Y8IcT20n@gmail.com>
 <20230420123139.GA32030@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420123139.GA32030@lst.de>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 20, 2023 at 02:31:39PM +0200, Christoph Hellwig wrote:
> On Thu, Apr 20, 2023 at 05:29:18AM -0700, Breno Leitao wrote:
> > > > -	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
> > > > +	if (req->ctx->flags & IORING_SETUP_SQE128)
> > > > +		size <<= 1;
> > > 
> > > 
> > > Why does this stop using uring_cmd_pdu_size()?
> > 
> > Before, only the cmd payload (sqe->cmd) was being copied to the async
> > structure. We are copying over the whole sqe now, since we can use SQE
> > fields inside the ioctl callbacks (instead of only cmd fields). So, the
> > copy now is 64 bytes for single SQE or 128 for double SQEs.
> 
> That's the point of this series and I get it.  But why do we remove
> the nice and self-documenting helper that returns once or twice
> the sizeof of the SQE structure and instead add a magic open coded
> left shift?

uring_cmd_pdu_size() returns the size of the payload, not the size of
the SQE structure. Basically it returns 16 bytes or single SQE or 80
for double SQE.

Since we are not coping the payload anymore, this is not necessary. Now
we are copying 64 bytes for the single SQE or 128 bytes for double SQE.

Do you prefer I create a helper that returns the SQE size, instead of
doing the left shift?

Thank you!
