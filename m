Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197A6402CD9
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 18:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245139AbhIGQb3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 12:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbhIGQb1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 12:31:27 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E1EC061575
        for <io-uring@vger.kernel.org>; Tue,  7 Sep 2021 09:30:20 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id e26so7313739wmk.2
        for <io-uring@vger.kernel.org>; Tue, 07 Sep 2021 09:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iILwEWNPAP/ZwzA04gTn2kFE9oHphWElVaxSzMMP9v4=;
        b=UDrYa861nkB/ZsRK8DEngNt+FAbwyMTVy3rYAmn/PPMFVPouOriYX9KlIJhbyKrrnu
         /mCeNUmcBO3PTFojO1v1SUAJovrugPYTWU/Kt5cdJ8nYDWwXGBQrKqye/EIMO4LhjHLH
         I3+FgV7gsBora+P4l+3Mp3zkGq/9SpKVSq/Gkl6y0B55YF94X3oY8Dh3/PZRnhpm/SNR
         2xJaIPgflaE9PehodgbztWweUdrLRFqq8dm3YgeCHiHhO8obwhqsUMdQHP/rAOjMezVG
         J1bziQW9j67D66SdtbxbAJE4vo4CEHcypaNkMBSf8uc/UbuL9kq5Rnqp9xAsq+yzv8Ny
         L+DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iILwEWNPAP/ZwzA04gTn2kFE9oHphWElVaxSzMMP9v4=;
        b=qhxnt/3T4RE4gnHvsMF28S0wY9HQ6PbkygXTTynjAcSiVZIY6LhrcmAec4pg6Vjlk4
         /dnTEM0VPdR6SqnEeLT7JInO+u5qGVrb+gGWSeUOvbWL3uliTgDiMvUyhPLBKi426nSe
         3iSn6ZUTZcedC1etFafp8+mCqUYmZUmMsuyGMzw2lZn75QQKPcrvsB9AiEiQgsgKso4o
         LxuxiexZp2vHteZctAUDviCtWM2IiYww2zavvj6SorFj++8Adg0GakCI63EU6JGczHyg
         cyBFatG67YUghbGRGFDeFDxtIfFp/X60tiVkywZr3f4QbMpu/R1rnLBQXPFGkUsIAjFv
         uR3Q==
X-Gm-Message-State: AOAM531ZzZdvqdalpHiFuPjQaCiZjH8y6amSoi5TtN8ZRxdBKvWNz+vG
        qUQc1bcXW/IHct1zeHwg/tC9h6J6Kk8Byh1M79A=
X-Google-Smtp-Source: ABdhPJwsAN5ZQnfv2NSJOfIp1C9kkC4d1zK1l/YcYuUFsialKipA1F/hycv9qPZuHS3QfUGcqAgp4GiGLVZwK2cZgAM=
X-Received: by 2002:a05:600c:3588:: with SMTP id p8mr4906167wmq.0.1631032219438;
 Tue, 07 Sep 2021 09:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210805125539.66958-1-joshi.k@samsung.com> <CGME20210805125934epcas5p4ff88e95d558ad9f65d77a888a4211b18@epcas5p4.samsung.com>
 <20210805125539.66958-6-joshi.k@samsung.com> <20210907074844.GD29874@lst.de>
In-Reply-To: <20210907074844.GD29874@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 7 Sep 2021 21:59:53 +0530
Message-ID: <CA+1E3rLpe7EoY1dbpH=rfVMFv9XXz1T47GO9xRFEujyZBthTow@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] io_uring: add support for uring_cmd with fixed-buffer
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, anuj20.g@samsung.com,
        Javier Gonzalez <javier.gonz@samsung.com>, hare@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 7, 2021 at 1:19 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Aug 05, 2021 at 06:25:38PM +0530, Kanchan Joshi wrote:
> > From: Anuj Gupta <anuj20.g@samsung.com>
> >
> > Add IORING_OP_URING_CMD_FIXED opcode that enables performing the
> > operation with previously registered buffers.
>
> We should also pass this information on into ->uring_cmd instead of
> needing two ioctl_cmd opcodes.

Indeed. We now (in internal version) switch between fixed/regular
ioctl by looking at io-uring opcode which will be different anyway.

-- 
Kanchan
