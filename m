Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B4B4B9538
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 02:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiBQBEA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 20:04:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiBQBEA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 20:04:00 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73ED82819BC
        for <io-uring@vger.kernel.org>; Wed, 16 Feb 2022 17:03:47 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id u12so3331258plf.13
        for <io-uring@vger.kernel.org>; Wed, 16 Feb 2022 17:03:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cK/B5LPhFrjMxTQlkSj0W2EXcO7lXH9qkZ05XTZiSUQ=;
        b=xbJqpTev7D2kANmTC5bIdEZhdAqeIE+KvCXbGvs7vwIn/ixIJJzlV/8Pf1rX/prZYL
         DW5BVUzQ3S6n8yKTepwHJ3bjtbhB1SidRFWOdM0Cjs9ajGTy57orhJK66TvU4/VmHl2F
         xN7D7GWwD+MhoFlbFI+FAsSS0xIOe/2D6k2U26gPbElBD1EsNILBcPGa1fmjbQA6vDno
         emuVFdO801heAWjWkg7smOYqQpNlVGiV0PMdColyIg5U658+S9JH01HT3foJUDNJ0lQp
         rqmVua+276fYXT9Y2CdI2HY5nmF1FTljdHytKEzDNEcrJPozbYM4iFJN87ypKzYVhPfD
         9fpA==
X-Gm-Message-State: AOAM5334qoQ0K/9DcrM8yvk6K61Mwwvfa2zpdIjrHuZjd1qexO/IH5PO
        2GCIvCpw81q21ez9H1stwVc=
X-Google-Smtp-Source: ABdhPJylnnnC1an21rCotApMu7vno6eYEiR9q1Ke7wjlxLuxciJNGuYt+VE13QbaH8O2YwI7zRn/9Q==
X-Received: by 2002:a17:90b:33c9:b0:1b9:15d9:4968 with SMTP id lk9-20020a17090b33c900b001b915d94968mr4787847pjb.214.1645059826890;
        Wed, 16 Feb 2022 17:03:46 -0800 (PST)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
        by smtp.gmail.com with ESMTPSA id w23sm6546635pgm.14.2022.02.16.17.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 17:03:45 -0800 (PST)
Date:   Wed, 16 Feb 2022 17:03:43 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, hch@lst.de,
        kbusch@kernel.org, linux-nvme@lists.infradead.org, metze@samba.org,
        mcgrof@kernel.org
Subject: Re: [PATCH 7/8] net: wire up support for file_operations->uring_cmd()
Message-ID: <20220217010343.uvw2yuanqo2viv3a@garbanzo>
References: <20210317221027.366780-1-axboe@kernel.dk>
 <20210317221027.366780-8-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317221027.366780-8-axboe@kernel.dk>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 17, 2021 at 04:10:26PM -0600, Jens Axboe wrote:
> Pass it through the proto_ops->uring_cmd() handler, so we can plumb it
> through all the way to the proto->uring_cmd() handler.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Without a user I think this is just a distraction for now, although a
nice proof of concept.

metze,

do we have a user lined up yet? :)

  Luis
