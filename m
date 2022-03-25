Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5077A4E6CCF
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 04:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358211AbiCYDSE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 23:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358194AbiCYDR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 23:17:57 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F465C358
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 20:16:24 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id bg31-20020a05600c3c9f00b00381590dbb33so3641834wmb.3
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 20:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XhwospLDNZoWv1ozyZrEwFjaShOt1DJ6enXrgYdGjrI=;
        b=Pz/qXpmcyci8PHxBo6SmVVVAviMLwEQ4z3tJVAwBxx18v8apNFjKn8ww6itFvL9jpH
         mpetVEBUsX0DDm8N3tScEbghx5O4fah3by3wIyKN9qN7U801WblVhpGQTQuRo0rgmv4n
         cWrv2nOdE9qLYjIhEMvylMTC6d9qcCy4dCe36YKxG0QNUQRz/udOUYExh9+xjQZESMXn
         2+TjEceJz680nzqdaaj/ZvDSHKP7nf1j0/s8p3FHYtddAygdY4sv280xOmz0D5PXjzjw
         lNjRhhSs1TA8GwUmIy+sikMh0wXYKbXTL9TfkcXcAL3mAmS9cmklZRu52yfNBIuXeUAD
         CmHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XhwospLDNZoWv1ozyZrEwFjaShOt1DJ6enXrgYdGjrI=;
        b=onM871ZMW4xAcFbLBaTGTlfnePPr231132BpIN/64eg4sObBXwivw6LeL4Pi0ro64R
         pr7+COd+C6z1G8KxEncKPbcwPisknCXtnKU8nLbQ0cxorVeSsQWGWaoScM4iUAZlOcUH
         zWXY6XKz1TggbYJNTSkHntqrBFVtshQTwAVqI8OiDgX+jVHX+ygeHU3sXqZRM3GwUJWe
         1UjdsL95nFOMy6Rk/2XReVu9BWGM2UHAmgURkiJ22cWHSQOrtyzJj4mfkv2GSVuu0egJ
         YIPo5l0FqbVRCyKx8PaFSp2TeHUqbEpm6gKmcaZI4NUHDAIlBQztwPlQPPcolyXBNpiT
         dbBg==
X-Gm-Message-State: AOAM531Jobk+Oi2QZn+YYvSSZ2ce6a5luUfx6OMm3ZBLeomcKgYdM6ol
        /ladIpL/0vhLbbxg/sD1DOPYtxl+5qatyRh918Oy4DG0
X-Google-Smtp-Source: ABdhPJwpoVAOccQfc8htJlS3EgNQfwjdBjSRDEsux21fcmY9XrOawaUw/ZdTE1B12Qoap/d7f4T+HZuKk52kKPnF8qo=
X-Received: by 2002:a05:600c:1d81:b0:38c:c1f:16a6 with SMTP id
 p1-20020a05600c1d8100b0038c0c1f16a6mr16983459wms.15.1648178182519; Thu, 24
 Mar 2022 20:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220323224131.370674-1-axboe@kernel.dk>
In-Reply-To: <20220323224131.370674-1-axboe@kernel.dk>
From:   Constantine Gavrilov <constantine.gavrilov@gmail.com>
Date:   Fri, 25 Mar 2022 06:16:11 +0300
Message-ID: <CAAL3td3smVV+J3167qT5ZX7aKT1JXe4u3_vitk9CFq61giquwA@mail.gmail.com>
Subject: Re: [PATCHSET v2 0/2] Fix MSG_WAITALL for IORING_OP_RECV/RECVMSG
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
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

On Thu, Mar 24, 2022 at 12:41 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Hi,
>
> If we get a partial receive, we don't retry even if MSG_WAITALL is set.
> Ensure that we retry for the remainder in that case.
>
> The ordering of patches may look a bit odd here, but it's done this way
> to make it easier to handle for the stable backport.
>
> v2:
> - Only do it for SOCK_STREAM/SOCK_SEQPACKET
>
> --
> Jens Axboe
>
>

Jens:

I was able to test the patch, after making some minor changes to apply
to Fedora kernel. I confirm that the patch works.

-- 
----------------------------------------
Constantine Gavrilov
Storage Architect
Master Inventor
Tel-Aviv IBM Storage Lab
1 Azrieli Center, Tel-Aviv
----------------------------------------
