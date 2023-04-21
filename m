Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A456EADC9
	for <lists+io-uring@lfdr.de>; Fri, 21 Apr 2023 17:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjDUPLo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 11:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjDUPLo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 11:11:44 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CD9125A9;
        Fri, 21 Apr 2023 08:11:35 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-3f178da219bso18928115e9.1;
        Fri, 21 Apr 2023 08:11:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682089894; x=1684681894;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o/1bU+3yxMOBZJYn8hiebgLUc19mnJbyR5cgTJ3rOoE=;
        b=JqQ0U0B62sc1MttFb74RoR1NEOA/uQT/JGtPmDFOhqZaA4BiEmvBpUn0uWZhxC60q+
         HGbSL5T33VFVfuoQlKhbEER6d0cadcxi7ZZ6sT79sl8a8BwPBLevsFk5dmwPwbvJIJJ7
         R3Y5vGXbBzsA/EmgvP2YUF6M8x+navM/pu0XvCBWywU8ww1CSzQ7SOxGAgC+ySvvqkTR
         2F+XcmSqAh8FxGV7d4Bw667xL0gLjw0u4lL/PAe7R+bMVV/9M/uMQ2ewiHp3MDLtG9ag
         FgIZ14+aG14ctdlsrHYmMtda5U5+Dwr/acJW3QRMw5i6d8Tw5bov/BLzhU5gHzSk2/EC
         duwA==
X-Gm-Message-State: AAQBX9dMcTZazM21+BMI2+FTi4xTWUaWrbG80layV2s8lcFjz6SGpuJV
        nIR61M3qiKAEl87qH7xUChw=
X-Google-Smtp-Source: AKy350YDSzZrIvT5JL0AAWk8219k6NeLFDVD+qfQEpr4w7Xa0eQOblolNTj8eRXWplZdeZgdYRBmEg==
X-Received: by 2002:a1c:c906:0:b0:3f1:6ec5:3105 with SMTP id f6-20020a1cc906000000b003f16ec53105mr2233609wmb.20.1682089893877;
        Fri, 21 Apr 2023 08:11:33 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-011.fbsv.net. [2a03:2880:31ff:b::face:b00c])
        by smtp.gmail.com with ESMTPSA id c21-20020a7bc855000000b003f17300c7dcsm4990006wml.48.2023.04.21.08.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 08:11:33 -0700 (PDT)
Date:   Fri, 21 Apr 2023 08:11:31 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, leit@fb.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        sagi@grimberg.me, kbusch@kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH 1/2] io_uring: Pass whole sqe to commands
Message-ID: <ZEKno++WWPauufw0@gmail.com>
References: <20230419102930.2979231-1-leitao@debian.org>
 <20230419102930.2979231-2-leitao@debian.org>
 <20230420045712.GA4239@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

On Thu, Apr 20, 2023 at 06:57:12AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 19, 2023 at 03:29:29AM -0700, Breno Leitao wrote:
> >  	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> > -	const struct nvme_uring_cmd *cmd = ioucmd->cmd;
> > +	const struct nvme_uring_cmd *cmd = (struct nvme_uring_cmd *)ioucmd->sqe->cmd;
> 
> Please don't add the pointless cast.  And in general avoid the overly
> long lines.

If I don't add this cast, the compiler complains with the follow error:

	drivers/nvme/host/ioctl.c: In function ‘nvme_uring_cmd_io’:
	drivers/nvme/host/ioctl.c:555:37: error: initialization of ‘const struct nvme_uring_cmd *’ from incompatible pointer type ‘const __u8 *’ {aka ‘const unsigned char *’} [-Werror=incompatible-pointer-types]
	  const struct nvme_uring_cmd *cmd = ioucmd->sqe->cmd;
