Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66E44F51E3
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 04:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443843AbiDFCVI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Apr 2022 22:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457317AbiDEQDF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Apr 2022 12:03:05 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE24BCA3
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 08:37:41 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id k10so13818619oia.0
        for <io-uring@vger.kernel.org>; Tue, 05 Apr 2022 08:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lWlq9ObQo4afnrXzQf/uD0TPv521LBO3Zl1osjpId+M=;
        b=f9t+P/0nnhMmwaImxBnMDduZ729xpNc/xBpvNileyrBxML8g4Moo3kndoU5jpmb2a5
         4fh5FoXwB7HD6uwV93e9N9r1wH5Jy0DdigdXnGrlFvHn7O/9E/dOvkSflgR1rMwwflFj
         mD8VWY4BqPEKWEOitvCFG9m9aoNlRuZ1vcwC04WwCwyrwFUAGRQr2YNEJy6tdmzbbkvn
         QrUKWj8qc6TTnXw8HSOEaEN98XpplACtEKRh/Jf3TR52nfTuqcpr+WLfpiRHDzEvsYKX
         wtpG0L/MTzDys2y/bE46rldPEvoDPMcHP0skYAdlheG8AgmWPQyhy5/zgWiTQofyT+9v
         VGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lWlq9ObQo4afnrXzQf/uD0TPv521LBO3Zl1osjpId+M=;
        b=o12I8U0IfhJhqLKt4WoAZCpRHi6gD3q5eG5YJbJ9YormgczM/2IlI4eibO7QXvBRP2
         pbUXDNMdZWaNe85TXwuRg+GoPyXndnl1ZzouvQHdz5asR8FqJ4ENYiS2LGVD+Wj+JhSx
         gZWDS8ZwKzT18ilwac9wZQWFuB2dkcgrt6KqGEHLFoHhH1PRD2qSj4qpUamySQbQqiy/
         FS8fTUbmOUD794sWcN+woFttSwdMSc5jXS/KEp/PmjId1QEk3sy+wsQFab7GJs+KIILs
         527Nl3UDHFgMexxQeZQJNwf8YZ3o0PhZiv1AAYeVnVytus31wiQ3prR5PRXV7T00O/79
         IGNQ==
X-Gm-Message-State: AOAM5316Ee3ceNujSzohTAcKccj8AdKGS7HiYjl1uP2rZNuVgAMZ6AKE
        vCDecEDH2MMPZthyJERCSjmKxrkQOc+dTwypAqs=
X-Google-Smtp-Source: ABdhPJyOL6K6/rY7/NDmVIcAfJC8BhiebWpoBwDifTDaHUjUpPI1/7KVLBonGcmGfLfXSSX6WKnLdXdduFVvCgpq4us=
X-Received: by 2002:a05:6808:17a2:b0:2f9:27da:923e with SMTP id
 bg34-20020a05680817a200b002f927da923emr1673063oib.15.1649173061240; Tue, 05
 Apr 2022 08:37:41 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220401110829epcas5p39f3cf4d3f6eb8a5c59794787a2b72b15@epcas5p3.samsung.com>
 <20220401110310.611869-1-joshi.k@samsung.com> <20220404072152.GE444@lst.de>
In-Reply-To: <20220404072152.GE444@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 5 Apr 2022 21:07:15 +0530
Message-ID: <CA+1E3rJhw4gL_z8hk7a-4wuZ4a8C-_V8V8dX0c17ivOW2VEt=w@mail.gmail.com>
Subject: Re: [RFC 0/5] big-cqe based uring-passthru
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 4, 2022 at 12:51 PM Christoph Hellwig <hch@lst.de> wrote:
>
> I really can't get excited about the pdu thingy.  Here is a patch
> (on top of the series and the patch sent in reply to patch 4) that
> does away with it and just adds a oob_user field to struct io_uring_cmd
> to simplify the handling a fair bit:

Fine. We discussed the tradeoff before, and the concern was
generic-space reduction for other use-cases.
But this is kernel-only change, so we can alter this if/when a new
usecase requires more space.
It seems fine to move ahead with what you proposed.
