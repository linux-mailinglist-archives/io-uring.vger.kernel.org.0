Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8646F294B
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 16:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjD3OjQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 10:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjD3OjQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 10:39:16 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E78101;
        Sun, 30 Apr 2023 07:39:14 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-2f95231618aso895659f8f.1;
        Sun, 30 Apr 2023 07:39:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682865553; x=1685457553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bysX9DvlsnqvSlQ+lvvjW3IO/Dqv4OjYEOFaq+KP4D8=;
        b=Sb0L0kEqSpAHXhwPpscznp5A+Q+GcM6h2D0X4eg7VM3rmaMiTzpjTBRm5TKNiaSDFy
         57mZspyPgoq33ZLef2hx7KZmqZ2hiWtTcg/rAePyWlUEdyb7mccOonuLbSJwxE0IsBkh
         voxaI5j7PWxk80qj56TC+OFoxzL0UfcKZIGX8MgxsTqGPIFRNjGFn0B0gXJPwCgzdP5U
         wD83dGykPELgx2trxK7FTcSV5TWkIctekvPilZiHzbiZitJNl6efL7B2By2bqi5hl7dr
         ZBmj6LLyImZjSSahUrQUQe4ApRu8uYnTW0cTJzZclM6eMXJpQC1l/Vyl5F1go5ShaTdW
         SeQg==
X-Gm-Message-State: AC+VfDw7QxAa3Ackom6fpiN62ZfBUni2zpJRNQnUWMxie/S1COXAiAfV
        aMIg1SPwmhhhLiMGRV/wkmc=
X-Google-Smtp-Source: ACHHUZ5e0OtY5poBCehPnKMc5JRRNVd8ObeMJIGKcedG4iBnL2UBvGjYpiHz/JTGG1hUh7v+tsBQFA==
X-Received: by 2002:adf:ec09:0:b0:2d5:39d:514f with SMTP id x9-20020adfec09000000b002d5039d514fmr8504393wrn.65.1682865553131;
        Sun, 30 Apr 2023 07:39:13 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-004.fbsv.net. [2a03:2880:31ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id d15-20020adfe84f000000b002fb60c7995esm26272127wrn.8.2023.04.30.07.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 07:39:12 -0700 (PDT)
Date:   Sun, 30 Apr 2023 07:39:10 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, hch@lst.de,
        kbusch@kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH v2 0/3] io_uring: Pass the whole sqe to commands
Message-ID: <ZE59jseq/BwR7Ac5@gmail.com>
References: <20230421114440.3343473-1-leitao@debian.org>
 <678232fa-fd02-37b7-3048-a124c4ffdc71@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <678232fa-fd02-37b7-3048-a124c4ffdc71@kernel.dk>
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

Hello Jens,

On Fri, Apr 28, 2023 at 11:28:14AM -0600, Jens Axboe wrote:
> On 4/21/23 5:44?AM, Breno Leitao wrote:
> > These three patches prepare for the sock support in the io_uring cmd, as
> > described in the following RFC:
> > 
> > 	https://lore.kernel.org/lkml/20230406144330.1932798-1-leitao@debian.org/
> > 
> > Since the support linked above depends on other refactors, such as the sock
> > ioctl() sock refactor[1], I would like to start integrating patches that have
> > consensus and can bring value right now.  This will also reduce the patchset
> > size later.
> > 
> > Regarding to these three patches, they are simple changes that turn
> > io_uring cmd subsystem more flexible (by passing the whole SQE to the
> > command), and cleaning up an unnecessary compile check.
> > 
> > These patches were tested by creating a file system and mounting an NVME disk
> > using ubdsrv/ublkb0.
> 
> Looks mostly good to me, do agree with Christoph's comments on the two
> patches. Can you spin a v3? Would be annoying to miss 6.4 with this, as
> other things will be built on top of it.

Sure. I've just sent V3 with all the fixes discussed in this email
thread.

Here is the link: https://lkml.org/lkml/2023/4/30/91
