Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CC3508C1B
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 17:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343516AbiDTPcM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 11:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbiDTPcL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 11:32:11 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A96A45AD3;
        Wed, 20 Apr 2022 08:29:25 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-e604f712ecso2282984fac.9;
        Wed, 20 Apr 2022 08:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=61FWMBiIp/oHQjo9zys3+M0sljyptQ7R0Qf5Z5MBknc=;
        b=qfNMbgXhys2URznuKviywGFhiZ668686N57iwamEyUpsg6K+8Akv9WmUP8JSXHvMeq
         yR2RgAVUH7lz2laj04BwucqPLvDlwoozfqrU+X65v0XJDcqHLYN1CbhKEqmchJSECnf+
         bsc+AUzGz3Izx86rlagi0hkmDCCf1rc9h666nI3ifRO8yPETkeaa/AvqYkODLvVPtJMB
         fhoDHF7Ptx5FQxTxBOasz4txQWj2g8CwXR95cjqxFrpKPAQVQalmKEu3LEumbvWZcQ3E
         XUtN5b+KljnfaLAJJ4mbWA+msrFfSGYMoSlAicfOMN6CmLxdSOWNyRnYD+D92OiftegJ
         ilMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=61FWMBiIp/oHQjo9zys3+M0sljyptQ7R0Qf5Z5MBknc=;
        b=yiVbvRe0c5Pxyvdomzoa7m7IZwmdvFdWBElXN224pTVXijYzDbxXM51nYCfKAD9ky/
         sUhV/FBTRux0JhCVepL+INrq9in9+RAWvgZRNUL0lU7b9raI7kZ/7QBLbVKMx+3yWPux
         SGVRkZpczk1J5StIoa4hjqVvJYVymbQ6Sk4QnAMdTT74v9ACP4TGP/iDzE33R2n/ueKp
         Cj2qDgcTDpD+0tow1+bM/XAqxjc+0AieOb0dDH4N679THwPO7+sH0yjruDld7UfZ3Jhn
         7Yj0+9CV6M59wbtfS2gZRf4v3FHoTneEBajZq2B459eCzNT5Hnh0T/pXpRWLzA0iG6l+
         fl6Q==
X-Gm-Message-State: AOAM531BXMGgRzWX3fHZQwR2jidJpQBE06nGaYMR8VngU8zkU3361r9M
        kRdSvLrjee0PJUKwkXY2j34HlrFVoAPV48Cb3QI=
X-Google-Smtp-Source: ABdhPJyJir+zz5lALNTrCHI37Thw0c7JMdw6PttB1W2T0kT7Nu7IbPDTjNIPoeyBZNpGwUGQL9JrhoOXBbLRAf86Kvw=
X-Received: by 2002:a05:6870:2190:b0:e6:26d2:abe0 with SMTP id
 l16-20020a056870219000b000e626d2abe0mr1750858oae.15.1650468564716; Wed, 20
 Apr 2022 08:29:24 -0700 (PDT)
MIME-Version: 1.0
References: <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
 <20220324063218.GC12660@lst.de> <20220325133921.GA13818@test-zns>
 <20220330130219.GB1938@lst.de> <CA+1E3r+Z9UyiNjmb-DzOpNrcbCO_nNFYUD5L5xJJCisx_D=wPQ@mail.gmail.com>
 <a44e38d6-54b4-0d17-c274-b7d46f60a0cf@kernel.dk> <CA+1E3r+CSC6jaDBXpxQUDnk8G=RuQaa=DPJ=tt9O9qydH5B9SQ@mail.gmail.com>
 <f3923d64-4f84-143b-cce2-fcf8366da0e6@kernel.dk> <CA+1E3rJHgEan2yiVS882XouHgKNP4Rn6G2LrXyFu-0kgyu27=Q@mail.gmail.com>
 <CGME20220420152003epcas5p3991e6941773690bcb425fd9d817105c3@epcas5p3.samsung.com>
 <586ec702-fcaa-f12c-1752-bf262242a751@kernel.dk> <20220420151454.GA30119@test-zns>
In-Reply-To: <20220420151454.GA30119@test-zns>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 20 Apr 2022 20:58:57 +0530
Message-ID: <CA+1E3rKYapc2_un9F4MNB5Zf7KfRr9=ATqonGnvcuvThLFX2vg@mail.gmail.com>
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> >Just still grab the 16 bytes, we don't care about addr3 for passthrough.
> >Should be no changes required there.
> I was thinking of uring-cmd in general, but then also it does not seem
> to collide with xattr. Got your point.
> Measure was removing 8b "result" field from passthru-cmd, since 32b CQE
> makes that part useless, and we are adding new opcode in nvme
> anyway. Maybe we should still reduce passthu-cmd to 64b (rather than 72),
> not very sure.
Correction above: reduce passthru-cmd to 72b (rather than 80b).



-- 
Joshi
