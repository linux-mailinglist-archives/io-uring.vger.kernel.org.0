Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412904D8B8E
	for <lists+io-uring@lfdr.de>; Mon, 14 Mar 2022 19:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241484AbiCNSUW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Mar 2022 14:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238339AbiCNSUV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Mar 2022 14:20:21 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FA8340F7;
        Mon, 14 Mar 2022 11:19:10 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id h11so23189699ljb.2;
        Mon, 14 Mar 2022 11:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7fVndOlXJqJd979kieplvxiXM/JaHGBg6vQFdeCNUz8=;
        b=BagW69PkeXTRL6hqswtUtlLfYVJLt+XItvKTC2u5jVa5FnN23pO/GEQj4BkxUpwpPF
         H9eMkQBImNLuy3zQVapLBfqxVVIOAodw/zKSahmsURAiWyLkcjMjsj9h+Xuky8LGvoDf
         kXVhHHRwykJDUB2Sno8FQLYWPE4SwC/vH5kOTQlI/U8+Dj8kZP5cMyQxdAizy7Z+40JI
         cE73atXBfyEzaluc+37TVW+ss+pt6osXH4yFQG92yzd8Eui1fws1rnoiIRpMLeYsxyOX
         M+nbMscPgY2x4bXSOzRJEpsoBvvIqe2TU48LyBLNPwnE1JxvR/PnU7YZUwKGww0nKAPD
         EdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7fVndOlXJqJd979kieplvxiXM/JaHGBg6vQFdeCNUz8=;
        b=lbd/jdON0DKy3gzYN1VY8+gRbQyW0VRi/pAjZ/hWhd7Q0eGHMPWreuElfTnV3QuZww
         T4ckEMWW3JW1jPpdYxqIOPp+FdRsUPOeJWwAzCfmfG2xpztNFJ56ofZzpL7kI8JFWwXK
         dRLm6eXzvHvZZHPxpcNxX0f41yakHp5L/u/bTnFx4yMCnK84J6l77IWpgMn77lhPxk0V
         DlVuR7H4m/aWUJqgmzOWmcUpzun+4VzPASPuAr6aoXxmIxaVvnhxe8BqkGu/QpuyYQTj
         iD8LjLF45oJ3V82/ShyXe8wfoOq/tNW/yLxkS/YspxC9Egplg71uyocIpOVHdPhVZvpu
         L+MQ==
X-Gm-Message-State: AOAM532hxc2Sm4FlmqGtSMpRFqNjI3j16blfeCvch57xUvAQxBh6VMAD
        X/STIOqDEtlb9ViNQ7KnGXWuhnVpdf/umqqnS9M=
X-Google-Smtp-Source: ABdhPJyV9Q/Oyg2T1KbYTiQ1l2Nl9hOAFzmuE2Vay8VGsiTVI+nXxEk2zzSRNFXp41eOl7Rdlpa6NXuZbJ3vaiqrPIo=
X-Received: by 2002:a2e:3004:0:b0:223:c126:5d1a with SMTP id
 w4-20020a2e3004000000b00223c1265d1amr15017686ljw.408.1647281949100; Mon, 14
 Mar 2022 11:19:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152718epcas5p3afd2c8a628f4e9733572cbb39270989d@epcas5p3.samsung.com>
 <20220308152105.309618-13-joshi.k@samsung.com> <20220311064847.GA17728@lst.de>
In-Reply-To: <20220311064847.GA17728@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 14 Mar 2022 23:48:43 +0530
Message-ID: <CA+1E3rJshMVkLwpAQwM1L6L_xcrK9drKP+rpcrfizYuFsQOGjA@mail.gmail.com>
Subject: Re: [PATCH 12/17] nvme: enable bio-cache for fixed-buffer passthru
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
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

On Fri, Mar 11, 2022 at 12:18 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Mar 08, 2022 at 08:51:00PM +0530, Kanchan Joshi wrote:
> > Since we do submission/completion in task, we can have this up.
> > Add a bio-set for nvme as we need that for bio-cache.
>
> Well, passthrough I/O should just use kmalloced bios anyway, as there
> is no need for the mempool to start with.  Take a look at the existing
> code in blk-map.c.

Yes, the only reason to switch from kmalloc to bio-set was being able
to use bio-cache.
Towards the goal of matching peak perf of io_uring's block io path.
Is it too bad to go down this route; Is there any different way to
enable bio-cache for passthru.

-- 
Kanchan
