Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7B4E44C8
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 18:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbiCVRMY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 13:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236376AbiCVRMY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 13:12:24 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A845189CF4;
        Tue, 22 Mar 2022 10:10:55 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id u3so24938289ljd.0;
        Tue, 22 Mar 2022 10:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DjMPQuRgSqtggQih30jd9BA8LLZ+Br+5GjfemEGTtt0=;
        b=E7cDRaZRUBAhq0mF0x/5leAbAfq9Y0seSKmP4gYSckQ64vJxUvLCxQJhfqoesl/amX
         5U38gpi4dJIXYBjT/j2k7AP+hGurmVeTFxJu2a4lCGXFFUP1f1lTYwzpNdV3mRPPdtLu
         2/Oc5i8i0Yv5OMjXy5P4Jlf+25scC/jQtW32/oQJUWfGyq2UImFu9TMfgvA6qQGsxhjs
         1WDmJ91t5lyjRz2wtsggZXFhLmxV3EExdwZzanRvgL2HXw6v6smjMW/0cPt799Lo7SLS
         rKYU2xCQv51pTBNnTBnFHKDNkW3Vzyoc0baoGJb7Lv2qA40raaTElHVoEKl7BQJNNdOz
         ddzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DjMPQuRgSqtggQih30jd9BA8LLZ+Br+5GjfemEGTtt0=;
        b=XSusNMwjicMGnZVQzsof/4YVAdaur3zucfI/YafH86CEJMp08CgiIkmRv+SVEkVfQ3
         w2P1Icwj5FGOaxJ6tyqH7QYUzx/saUQ5YuaGbILKSylST1hgDU3QvJ9jWRFq37SFWPhX
         cOTzjMo9AJLqwXS91yxWkVFyLJx+CclAUGi06CxzxG2IDuFcFYIvZ+1hSRfotTnrLWFf
         LpjRFLwDB2cZv0ETtwnshNBOzcLZ225tcRguPFi5A1RlkdIJ4crRn4osAGaXDFgeWLrc
         Fs3HC/D+Q7VsPlzDTPEpgInazGhh3+++GiBa60r6P8T4+68NJgpiewWDsU2imrRbH81c
         qhdA==
X-Gm-Message-State: AOAM532oqO6gpaZh9of1PxnBHDUicqLpbHKATNlh3JYOt1t+XUI4M90l
        2liKSg/90f1b84ZZnRucS9a8euUjImr0MVXMzkQ=
X-Google-Smtp-Source: ABdhPJwtGnaC9zO93M2q8sI0Kc9qeume6nrAuEkn++6FTTxjwDL9+DZYrRj1rED9VvFBUf11TkY5zTG1JwTkR0wUMAA=
X-Received: by 2002:a2e:3004:0:b0:223:c126:5d1a with SMTP id
 w4-20020a2e3004000000b00223c1265d1amr19224954ljw.408.1647969052469; Tue, 22
 Mar 2022 10:10:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com> <20220310083652.GF26614@lst.de>
 <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
 <20220310141945.GA890@lst.de> <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
 <20220311062710.GA17232@lst.de>
In-Reply-To: <20220311062710.GA17232@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 22 Mar 2022 22:40:27 +0530
Message-ID: <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
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

On Fri, Mar 11, 2022 at 11:57 AM Christoph Hellwig <hch@lst.de> wrote:
> > And that's because this ioctl requires additional "__u64 result;" to
> > be updated within "struct nvme_passthru_cmd64".
> > To update that during completion, we need, at the least, the result
> > field to be a pointer "__u64 result_ptr" inside the struct
> > nvme_passthru_cmd64.
> > Do you see that is possible without adding a new passthru ioctl in nvme?
>
> We don't need a new passthrough ioctl in nvme.
Right. Maybe it is easier for applications if they get to use the same
ioctl opcode/structure that they know well already.

> We need to decouple the
> uring cmd properly.  And properly in this case means not to add a
> result pointer, but to drop the result from the _input_ structure
> entirely, and instead optionally support a larger CQ entry that contains
> it, just like the first patch does for the SQ.

Creating a large CQE was my thought too. Gave that another stab.
Dealing with two types of CQE felt nasty to fit in liburing's api-set
(which is cqe-heavy).

Jens: Do you already have thoughts (go/no-go) for this route?

From all that we discussed, maybe the path forward could be this:
- inline-cmd/big-sqe is useful if paired with big-cqe. Drop big-sqe
for now if we cannot go the big-cqe route.
- use only indirect-cmd as this requires nothing special, just regular
sqe and cqe. We can support all passthru commands with a lot less
code. No new ioctl in nvme, so same semantics. For common commands
(i.e. read/write) we can still avoid updating the result (put_user
cost will go).

Please suggest if we should approach this any differently in v2.

Thanks,
-- 
Kanchan
