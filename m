Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6884B02FA
	for <lists+io-uring@lfdr.de>; Thu, 10 Feb 2022 03:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiBJCFR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Feb 2022 21:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbiBJCDq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Feb 2022 21:03:46 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4206A22BF3
        for <io-uring@vger.kernel.org>; Wed,  9 Feb 2022 17:59:34 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id f41so454869lfv.12
        for <io-uring@vger.kernel.org>; Wed, 09 Feb 2022 17:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mariadb.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XK1Fcm8QsAbqPpLUwHWjIW72BEP8rPvQLIr/1eRroVo=;
        b=feBai/B80giR/IJ/IyaYtsoGyAS/sLGjBRnpCcsjjktBWtzBuZZwaj9QIL0RgeKF/p
         YHJAUxP+ntPRTfT14BlXRWXr/4pjuzn4JGDji99PV3dfiYxnvkHU2X0xif941ZVsN9O+
         NhgF482F7uItXxZsQRY8pkNyNYvhqwVoueOwD6JbXW3rOYYoPhqcot9oNpYjl2NAWfI0
         ChiKiRFlQAKvhsfkbrxa12NakYz2XwltqGUwSjF4+8KaoMoQSq/uSnKr4nCliVJZ4hXi
         iABgna0GhBmj7Rxvw7AXbjMsEkUaO7zny7JOwZYRhoyUksDVhtr3YOEBHbSzaGf5Pgnt
         Vx2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XK1Fcm8QsAbqPpLUwHWjIW72BEP8rPvQLIr/1eRroVo=;
        b=LBFe0nNpHhzumGIOoig0/bgvFkI8nqhrCh/abxbl3Y2dAHCj4g4k6W0qMxKinYvaj5
         uSz/8fatLbFJboMliYGOfp9pK7nPKrqb8ZoO7Vz/IpoF/8gnpph+V3CdUI6ZYypYLwUu
         PWSE3+qhMG6+MGINmIsfR7BrvYvsFvMSdGp7QM6h/vUOe5l2qy4Lb6edDtNQB3yPFNn7
         tCNPmS1aV8uyGIeKjBuCqlP0lWOQ/Kx1jK1iDedJNq/7axVd99Hle7rXQPLVBbikyTre
         9gBipjMOF40YxmSHrLTk2ebPwDEb4HOAncjfS6Zg2WHVcg9QqGwGZs4CXUcUgSf9QJIv
         0UWg==
X-Gm-Message-State: AOAM532XcKTI6CINjjqbOm2te9Ov4llRftx4GiFF1UoiDzoWoZ5GGOUq
        7rUKXiyM8LKajvUcpPWrjFLGuoULVtQfxt51ww3yJfWWbmwOQg==
X-Google-Smtp-Source: ABdhPJyoAFcb8E7+XIloPv4XqKHv0vNXpsM8DnBsoxiJmlOt3AxuuOft0mSvpArDrS/Ib0IC+JuK5hT72iKzODtnK44=
X-Received: by 2002:a17:907:3e8a:: with SMTP id hs10mr4269721ejc.767.1644451857209;
 Wed, 09 Feb 2022 16:10:57 -0800 (PST)
MIME-Version: 1.0
References: <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk>
 <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk> <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk>
 <281147cc-7da4-8e45-2d6f-3f7c2a2ca229@kernel.dk> <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk>
 <CABVffEN0LzLyrHifysGNJKpc_Szn7qPO4xy7aKvg7LTNc-Fpng@mail.gmail.com>
 <00d6e7ad-5430-4fca-7e26-0774c302be57@kernel.dk> <CABVffEM79CZ+4SW0+yP0+NioMX=sHhooBCEfbhqs6G6hex2YwQ@mail.gmail.com>
 <3aaac8b2-e2f6-6a84-1321-67409b2a3dce@kernel.dk> <98f8a00f-c634-4a1a-4eba-f97be5b2e801@kernel.dk>
 <YZ5lvtfqsZEllUJq@kroah.com> <c0a7ac89-2a8c-b1e3-00c2-96ee259582b4@kernel.dk>
 <96d6241f-7bf0-cefe-947e-ee03d83fb828@samba.org> <6d6fc76f-880a-938d-64dd-527e6be3009e@kernel.dk>
 <5217de38-d166-de32-c115-fd34399eb234@samba.org> <e5171c3d-4df7-1e70-ce3e-badcd6ea855d@samba.org>
In-Reply-To: <e5171c3d-4df7-1e70-ce3e-badcd6ea855d@samba.org>
From:   Daniel Black <daniel@mariadb.org>
Date:   Thu, 10 Feb 2022 11:10:46 +1100
Message-ID: <CABVffENhu8iRtXf5VZowrshpEuvt5OLaDYi+468vKHWeByAsZg@mail.gmail.com>
Subject: Re: uring regression - lost write request
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Stefan,

On Thu, Feb 10, 2022 at 10:01 AM Stefan Metzmacher <metze@samba.org> wrote:
> > Ok, I've created https://bugs.launchpad.net/bugs/1952222
>
> At least for 5.14 the patch is included in
>
> https://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-oem/+git/focal/log/?h=Ubuntu-oem-5.14-5.14.0-1023.25
>
> https://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-oem/+git/focal/commit/?h=Ubuntu-oem-5.14-5.14.0-1023.25&id=9e2b95e7c9dd103297e6a3ccd98a7bf11ef66921
>
> apt-get install -V -t focal-proposed linux-oem-20.04d linux-tools-oem-20.04d
> installs linux-image-5.14.0-1023-oem (5.14.0-1023.25)

Thanks!

> Do we have any reproducer I can use to reproduce the problem
> and demonstrate the bug if fixed?
>

The original container and test from
https://lore.kernel.org/linux-block/CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com/
will be sufficient.
