Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AC74F51BF
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 04:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbiDFCNk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Apr 2022 22:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457664AbiDEQaX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Apr 2022 12:30:23 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C357D7C166
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 09:28:25 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 88-20020a9d0ee1000000b005d0ae4e126fso7728182otj.5
        for <io-uring@vger.kernel.org>; Tue, 05 Apr 2022 09:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=74fq+cSNE2UwX6pLlf26dcG+/mwze9tFZ1WcAEZygc8=;
        b=LpAFkybGhasHbCt7KixDHViit9dUHGlwfjDSlx6pX0JwmHWsv3Gxx8/Qo/O5eZ9Hs+
         jrGe48NAH0Elud+crOnB5a9pJ9RUT75IdLc5HClO4+NWQ/SzA+zh3Y9wn4lLchO8eBV/
         qfE1OqIRNl2FWbgtPpHHPwNJmkK0nJYYrV20DNWtWt1uS3N0px62Rb+FBQYvrfan4PWY
         p7cg3kZMeazd9zW5zDrAuKskTuIkn6x6199o9AnXE4V9jN653fYqjZy84LjDW20HdNQc
         fUa8DJuMZMHvafLQgtZQ6M8gQ0fvrfQD+JzCH7i6NM/2+ZcKub7AGb0UH5/3oMWq7nSk
         XC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=74fq+cSNE2UwX6pLlf26dcG+/mwze9tFZ1WcAEZygc8=;
        b=E7B/nEWFHQSL74m/JqoXHz8YLZLnVU6M1mSBYEUgc3zHdeZvhkC7Cml8tnju+Idc81
         a/ga2cVlKg7c/zRk7btJ3AhkzYsCaPkBU6DzsvbAGF16C6TQGcplmKQ5pLGShTcvH54L
         eTi1VGg8xmT8t3r+i43xIyG564hQVYHDjGqLng8DRbtvkcvS8LTpfARSBzNLTKp+MuoI
         zz5fk2pob4n1GKtP3VXAcpnRR+H2EmRcWtmsYEeATu3Sxp0BOE0fMlFjkGvAJXcMP9S3
         EngWjJJPcIxA4syDRhMwsI8QcIi1eJKV6aLrJ3g/36PliQdwfTY1TExQs2JxcxvR+Fvj
         IcKQ==
X-Gm-Message-State: AOAM5339j0VZ8bYTsVwkrxO6/zXyncea8e96tQVtUI/Mwi4A3F0QGeVq
        vfr20zluFEWiJJ7ag7gS5LZjO6G4HXoSRsT5ufs=
X-Google-Smtp-Source: ABdhPJx/xEqaSnm7xNLv/pKl+niTBDY4r88roIh4NAZzAyZwCI1PpgUtucZrmyHVtyBF5CIbZYjKV4FFaMoyQixjxiE=
X-Received: by 2002:a9d:eef:0:b0:5d2:8e2f:6729 with SMTP id
 102-20020a9d0eef000000b005d28e2f6729mr1556194otj.86.1649176105139; Tue, 05
 Apr 2022 09:28:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110834epcas5p4d1e5e8d1beb1a6205d670bbcb932bf77@epcas5p4.samsung.com>
 <20220401110310.611869-4-joshi.k@samsung.com> <20220404071656.GC444@lst.de>
 <CA+1E3r+nHBace_K1Zt-FrOgGF5d0=TDoNtU65bFuWX8R7p8+DQ@mail.gmail.com> <20220405060023.GD23698@lst.de>
In-Reply-To: <20220405060023.GD23698@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 5 Apr 2022 21:57:59 +0530
Message-ID: <CA+1E3r+HAGsXeBY7e-r0bXn2N-yP9B4631gwXRwUJM-PU2YqZg@mail.gmail.com>
Subject: Re: [RFC 3/5] io_uring: add infra and support for IORING_OP_URING_CMD
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

On Tue, Apr 5, 2022 at 11:30 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Apr 04, 2022 at 08:44:20PM +0530, Kanchan Joshi wrote:
> > Another stuff that got left out from the previous series :-(
> > Using this field for a bit of sanity checking at the moment. Like this in nvme:
> >
> > + if (ioucmd->cmd_len != sizeof(struct nvme_passthru_cmd64))
> > + return -EINVAL;
> > + cptr = (struct nvme_passthru_cmd64 *)ioucmd->cmd;
>
> Do we actually need that sanity checking?  Each command should have
> a known length bound by the SQE size, right?

Right, and that check can go in io_uring without needing this field
(as we keep cmd_len in sqe already).
Will remove this from io_uring_cmd struct.
