Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA70521D40
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 16:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345257AbiEJPAm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 11:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345175AbiEJPAe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 11:00:34 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B1F120F51
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 07:22:06 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id a23-20020a4ad5d7000000b0035ee70da7a9so3141679oot.1
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 07:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UYTEN9JBCbSYZtYrxEfKSYcmjKROaJRwEA+42gL1fX0=;
        b=HlqckSy7O2WA9Nbjzc8ISiEjP/qp6WObJIYl1g8P467kHBSrHlD9R7y5nafUttXi/4
         y1PDSx59/7dYzMSX9OY9xbYT4dWYynH0Uoqsp7hSditGeYQdVfTWaGnlav4dFQ0+vGfE
         1PekGYB+THwtm3Rlp9rTjQs6ANaLBAfDo+yp/Zu4JCI1BvaBUWzUViVAjWnGrZ1lTNzP
         j0IhRlVTcqSa3jO557Gnj3c7W/mpANUMjL6Dw5W488rYTEuJsUIDZiI18Tww6lNn3pGr
         6Q9jpyYsARZjhgaaUGhodeSVJcQ+tBdOO90qbqpp7w9WsKl5SSL7Q89JKOefw/16VG0O
         sdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UYTEN9JBCbSYZtYrxEfKSYcmjKROaJRwEA+42gL1fX0=;
        b=X+nBnesmQmORwQXiE49dJuGAwaGDDs/c3Nh07mHoXU3Imnx8v/HRWGuKDvR65TN3YY
         qx/zL5ii5uprTeY+IwyleB2CyLJFkcxJlk/DxbNbBoeGQKFlbKxreLcg5Y//J5V0bFLq
         cl7pjqAyGqPU9GBT4BzRCZiDM5H92fbQRVCU1iawBunTSwrZXIyszRcihyf26Np/vph8
         vTEpGwkehA4y+GrIREWjN8gcg8XQXBP9SU3YCZABBMREXvNm528bAzjMhCnGaQLq2fhp
         mBXFo/83sQ731kk78wD9qgkr6zF2BtEc2wK7gP8MK0/p2SIIORG516iZpW7vO8X86N4O
         I+JQ==
X-Gm-Message-State: AOAM532dhQirV6ETBvmWhepjtngfnk49f+PRZahjyVwQqkmWnSkbvVdn
        IHl4VeMqLB+YQlj2hTankqagVtM/fkHgFdaVfCM=
X-Google-Smtp-Source: ABdhPJx+sB9EBiYJ3sTd3m1OfaATJn0Js6Kmgz8hanKpfau1B3v+UfLUb1XkaORm2q4oDz67a8VzaKhIYR/0q3j1hLY=
X-Received: by 2002:a4a:2cd3:0:b0:35e:99e3:a497 with SMTP id
 o202-20020a4a2cd3000000b0035e99e3a497mr8182960ooo.86.1652192526127; Tue, 10
 May 2022 07:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220505061142epcas5p2c943572766bfd5088138fe0f7873c96c@epcas5p2.samsung.com>
 <20220505060616.803816-1-joshi.k@samsung.com> <d99a828b-94ed-97a0-8430-cfb49dd56b74@kernel.dk>
 <20220510072011.GA11929@lst.de> <2a09399d-480e-8b03-8303-57287f7b5c64@kernel.dk>
In-Reply-To: <2a09399d-480e-8b03-8303-57287f7b5c64@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 10 May 2022 19:51:40 +0530
Message-ID: <CA+1E3rKGZ_XfwtO_NLFd15RiY8ZYzeaKAJHppOwaEwy5eAeecw@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] io_uring passthrough for nvme
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Stefan Roesch <shr@fb.com>, Anuj Gupta <anuj20.g@samsung.com>,
        gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 10, 2022 at 5:59 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/10/22 1:20 AM, Christoph Hellwig wrote:
> > On Thu, May 05, 2022 at 12:20:37PM -0600, Jens Axboe wrote:
> >> On 5/5/22 12:06 AM, Kanchan Joshi wrote:
> >>> This iteration is against io_uring-big-sqe brach (linux-block).
> >>> On top of a739b2354 ("io_uring: enable CQE32").
> >>>
> >>> fio testing branch:
> >>> https://github.com/joshkan/fio/tree/big-cqe-pt.v4
> >>
> >> I folded in the suggested changes, the branch is here:
> >>
> >> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-passthrough
> >>
> >> I'll try and run the fio test branch, but please take a look and see what
> >> you think.
> >
> > I think what is in the branch now looks pretty good.  Can either of you
> > two send it out to the lists for a final review pass?
>
> Kanchan, do you want to do this?

Sure, will do that.
Looking more into cases when cmd needs deferral. We need a few changes there.
I will put those in the other email (for better context). Please take
a look. If you are fine with that, will fold those in the newer
version.
