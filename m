Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333B04D4434
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 11:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbiCJKGa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 05:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239862AbiCJKG3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 05:06:29 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F8213D578;
        Thu, 10 Mar 2022 02:05:28 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id s25so8464987lfs.10;
        Thu, 10 Mar 2022 02:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g1v6ovUNSf+kFskR5R+v2NInQ6xsMS01QhfDEC1m/98=;
        b=ns33X3mSvUp/dV4LlGedMNO7aMi7dLjkJEUK4S+oJGMyRCgCRbpIY/bN1lKR7coIXt
         fgnlmrPnvIUWbzXLZXsahgLPJJhWkeuczEbUHP5ElqKexNzJYP0gAxHjGPJX/CqPQ8QH
         kpmjVHzhjJ7tMioIgTAfkNZ4h0efJFIsYgBVKYRvA4/s8c3a3BH+AEJgU8qpbf+bbY2g
         uXSUBVqregysJ4ss/HApTFtigwZZsAH+zVvVgLhTS54BwnE+AcGY/PjPVE3mFH+r28D8
         p/MNit5koONLvhhlYyCG0wohubRoqL2ukmTOS7AqUs+r4XjBh3AtK8PrI0HUlMBfQFsM
         zNaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g1v6ovUNSf+kFskR5R+v2NInQ6xsMS01QhfDEC1m/98=;
        b=6fzY7q3np4SYhAlcXyg4nAaT33aMFOC2EidjgQ73GORPPT3b3xwZdZpjXTznCjuJk8
         c1rTNfJtMW/xtjHD+NTl2Ox78krv6wi2YwILPqPV/QS6PzyGeJfJ63ydeWmBoBHTcESQ
         PQ5gEDlOJ+10nk0uo+zPhprVgUoyZEHEqFlWoIvHHwMTaP1mUm6g71vYHxICH+QwUzj4
         cBu0O3rR2Q45NYNSvOvFwFlAR/6W6zB8KLTNm3R7G5hIS71QxOTYCueOwRViusxmk75T
         9SMpd0QTJBpSfkLK6TXzGDWiXJz/dt6xyfWpZ3jQvxYCvGHnAsyqFQIzRHWtzI+JjGZK
         xPdw==
X-Gm-Message-State: AOAM531UD7kX93AdyvngN6V/FCCwv2ZcsF4f/DyImpS/ik/pAtGqd1jh
        whYdZSTF32EY3itf6ZlAGk2vih1OTxiQ+r7IKno=
X-Google-Smtp-Source: ABdhPJwDzqA1hnug0wbCxuMMC9bwFUJgrX7k50AuAyOlBBQCCbHd+EQ98+xL/K6bjR+dxXF673VzxbFS2cGid0d5Jgc=
X-Received: by 2002:a05:6512:2208:b0:448:5c7a:6dd9 with SMTP id
 h8-20020a056512220800b004485c7a6dd9mr2577551lfu.334.1646906726687; Thu, 10
 Mar 2022 02:05:26 -0800 (PST)
MIME-Version: 1.0
References: <CGME20220308152651epcas5p1ebd2dc7fa01db43dd587c228a3695696@epcas5p1.samsung.com>
 <20220308152105.309618-1-joshi.k@samsung.com> <20220310082926.GA26614@lst.de>
In-Reply-To: <20220310082926.GA26614@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 10 Mar 2022 15:35:02 +0530
Message-ID: <CA+1E3rJ17F0Rz5UKUnW-LPkWDfPHXG5aeq-ocgNxHfGrxYtAuw@mail.gmail.com>
Subject: Re: [PATCH 00/17] io_uring passthru over nvme
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

On Thu, Mar 10, 2022 at 1:59 PM Christoph Hellwig <hch@lst.de> wrote:
>
> What branch is this against?
Sorry I missed that in the cover.
Two options -
(a) https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-big-sqe
first patch ("128 byte sqe support") is already there.
(b) for-next (linux-block), series will fit on top of commit 9e9d83faa
("io_uring: Remove unneeded test in io_run_task_work_sig")

> Do you have a git tree available?
Not at the moment.

@Jens: Please see if it is possible to move patches to your
io_uring-big-sqe branch (and maybe rename that to big-sqe-pt.v1).

Thanks.
