Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7914D4726
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 13:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237246AbiCJMlf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 07:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239897AbiCJMlf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 07:41:35 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA775148909;
        Thu, 10 Mar 2022 04:40:34 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id o6so7526850ljp.3;
        Thu, 10 Mar 2022 04:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DAtfKJxhTlUfLfh7FDdHLWXEZv3s/cYhD3RWZTonYVc=;
        b=CNx5wp3+3lfwtIyoCM9pRl1cXVqdYbE6/d4Op9YI4mLz2vYcAduj4xLyqq95HxWX8Y
         /UqkC3O3uouwq15gtsKUA6ISPm+F1W/NRnQEkLSibFQOOlM9Ou0pWViE0PSFvdm+i6hE
         cVbSFHOo87qTdoL+ls2yBlZrEyEryORUwE8MY9mVRruJmSXBKW5MO0pjMPclHlgbe35v
         vv73luUALWmVAxQhjuYyrg1o3+DZ5JaBwo7pgQE7XuCtVhXNxaEdVMhp+gJpOh3jpDla
         hYADDMd0nJAtdtyPxuB/9RzMmIl5x5EZmsyiZDBHc7/PTZkR5jNUByZbxz54s09DOrJC
         evqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DAtfKJxhTlUfLfh7FDdHLWXEZv3s/cYhD3RWZTonYVc=;
        b=NDluLH0wklj+oY8FpnZswnnJ6vVfQxwBfNokY/zYVlLAenwrGPY2CgW4ZX3ytnMbQ3
         52znFy539AqKtxqJ899L5S8MpCWKsVrxyP7IKppso8+9g49/Q7tJp/Jszn/sAIQAnA5v
         z26moadzY13YhApQ+aAFQ3rfaeNPZ2gtEMeoy1ycrOHtw2Rf4HbFfwaoCPv+EY3dwDb5
         G1FNSYJ1VLj8AKqAxFdJ5KFb7NMezMuRd6nYBdrGJ89cunhYZLxcWky0Tr5gs43/uUoh
         pkJsnwguGKfznYbpXt90gxnx8By9bv29u8EeEje8A2D/gmL/sdnDmRvXBLKBB2tlROnp
         +BcQ==
X-Gm-Message-State: AOAM531KzQ+R3siFeV/PO/RJOpGGwCb0PA8LvSL0K79zpD/MvVO1rzkt
        ZfPVH2w1uQjKdJ4e8svTBzURmsbxVp/mnw6UTIc=
X-Google-Smtp-Source: ABdhPJyOXMDOJXEweNjgQ/Heimakq+LFmrhTTQqxKwAXvx1dEWUO11jTrEOo7xbbSHGosGfV5AfpN6e8NUahPBFVAbw=
X-Received: by 2002:a2e:3004:0:b0:223:c126:5d1a with SMTP id
 w4-20020a2e3004000000b00223c1265d1amr2931647ljw.408.1646916033166; Thu, 10
 Mar 2022 04:40:33 -0800 (PST)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152714epcas5p4c5a0d16512fd7054c9a713ee28ede492@epcas5p4.samsung.com>
 <20220308152105.309618-11-joshi.k@samsung.com> <20220310083400.GD26614@lst.de>
In-Reply-To: <20220310083400.GD26614@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 10 Mar 2022 18:10:08 +0530
Message-ID: <CA+1E3rJMSc33tkpXUdnftSuxE5yZ8kXpAi+czSNhM74gQgk_Ag@mail.gmail.com>
Subject: Re: [PATCH 10/17] block: wire-up support for plugging
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

On Thu, Mar 10, 2022 at 2:04 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Mar 08, 2022 at 08:50:58PM +0530, Kanchan Joshi wrote:
> > From: Jens Axboe <axboe@kernel.dk>
> >
> > Add support to use plugging if it is enabled, else use default path.
>
> The subject and this comment don't really explain what is done, and
> also don't mention at all why it is done.

Missed out, will fix up. But plugging gave a very good hike to IOPS.
Especially while comparing this with io-uring's block-io path that
keeps .plug enabled. Patch 9 (that enables .plug for uring-cmd) and
this goes hand in hand.
