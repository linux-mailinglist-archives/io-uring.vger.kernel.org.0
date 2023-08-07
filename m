Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C641772FF8
	for <lists+io-uring@lfdr.de>; Mon,  7 Aug 2023 21:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjHGTzp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Aug 2023 15:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjHGTzo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Aug 2023 15:55:44 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501A6171E
        for <io-uring@vger.kernel.org>; Mon,  7 Aug 2023 12:55:42 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-26890669c8eso1035305a91.1
        for <io-uring@vger.kernel.org>; Mon, 07 Aug 2023 12:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691438141; x=1692042941;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z1rlE6Lbiv7v87LfVDVV0XlxtwZt5i61uL3L217w1W8=;
        b=32kDFJr8AELTQzL2AyHx+hW0q6+fKxiKNuP8qcYmDwfEHqhAEFqcI4Q6xJDtB10q8F
         DRcDafxU8NN+xZ1ah+TZ/DvfUyJlb7FzCIeG6CNzKwckKOHi2ydiferKCg4ZkXJWTFIp
         lc58kb/qpln9Sha/ITdnbEGIuaKiT4cKIScOGhdvoeJMNKq3lj/RiDqOJn+yi7onJr5E
         9zx8ozwewXoBh3UrNVBSkvzV+yxdU60s6hD+FRPGepT3mJuDmyNnwfpAcF1hWJ+Aw8DN
         rZS6OlRYzUZl6h0Z/zn7pdhaexu/xjmFh/7KiKQ56ulXy/qCDvwl4N0dHxaTDWzAgMyo
         9pnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691438141; x=1692042941;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z1rlE6Lbiv7v87LfVDVV0XlxtwZt5i61uL3L217w1W8=;
        b=VpYnf3TOrcu/FW+2l0jnmcYJ5+tDjrdoEnULi0lbKezwneqXqQ73eF5rIXLMQdKNVb
         Zp+lihQYWjeKYLfkMLW11uiAvoBqxWpsxb+u34QXGRMBW6VvL+rEQn8UhHhOGMh/LTel
         AiynCnzgQg8TjaLnnzA9SvcZXytFBcAXOdVwkQSAOJ+S1saLCaURthG5PE2uUE4XhXCb
         DxmacuZiqEWGgTM7j55ofjd0dM5vNwkW6D5Z8j7usO4wbb9klruv4h9M7SIg/Uyu+Wt2
         2y25P3JVWcuah/QMCZjFbE1GGnhw83IQCWuk7+0Qtect+QjkzZLHTtIuBV6gw7wI2yEa
         YqFA==
X-Gm-Message-State: ABy/qLYtU3fSm72T9IcGUkKBN5iKjOxommFg/4sMuBCcq3T5+/+peHOw
        a6CYgmw57Y5q1Nz9aU2cQpgtqg==
X-Google-Smtp-Source: APBJJlEV4LiHr2iZGniWZnrPrKUlkJEOO1G+DqlAphV01toEwgcnPPpcc8wxa/99L7mKzBGG4BVN2Q==
X-Received: by 2002:a17:90a:1f83:b0:268:3dc6:f0c5 with SMTP id x3-20020a17090a1f8300b002683dc6f0c5mr26242828pja.0.1691438141323;
        Mon, 07 Aug 2023 12:55:41 -0700 (PDT)
Received: from smtpclient.apple ([206.181.83.18])
        by smtp.gmail.com with ESMTPSA id 23-20020a17090a19d700b0025645ce761dsm9672791pjj.35.2023.08.07.12.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Aug 2023 12:55:40 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Jens Axboe <axboe@kernel.dk>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] io_uring/parisc: Adjust pgoff in io_uring mmap() for parisc
Date:   Mon, 7 Aug 2023 12:55:28 -0700
Message-Id: <94C6EF57-1E8C-449E-BE34-96FFF42B4AB5@kernel.dk>
References: <1eb94cc3-1286-4e30-f891-a6b6dfa11ba9@gmx.de>
Cc:     Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-parisc@vger.kernel.org, io-uring@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <1eb94cc3-1286-4e30-f891-a6b6dfa11ba9@gmx.de>
To:     Helge Deller <deller@gmx.de>
X-Mailer: iPhone Mail (20F75)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Aug 7, 2023, at 12:33 PM, Helge Deller <deller@gmx.de> wrote:
>=20
> =EF=BB=BFOn 8/7/23 20:34, Jens Axboe wrote:
>>=20
>>> On Mon, 07 Aug 2023 20:04:09 +0200, Helge Deller wrote:
>>> The changes from commit 32832a407a71 ("io_uring: Fix io_uring mmap() by
>>> using architecture-provided get_unmapped_area()") to the parisc
>>> implementation of get_unmapped_area() broke glibc's locale-gen
>>> executable when running on parisc.
>>>=20
>>> This patch reverts those architecture-specific changes, and instead
>>> adjusts in io_uring_mmu_get_unmapped_area() the pgoff offset which is
>>> then given to parisc's get_unmapped_area() function.  This is much
>>> cleaner than the previous approach, and we still will get a coherent
>>> addresss.
>>>=20
>>> [...]
>>=20
>> Applied, thanks!
>=20
> That was fast :-)
> Actually I had hoped for some more testing from Christoph and other
> parisc guys first.
> Anyway, since you have a parisc machine in your test ring, you will
> notice if something breaks,
>=20
> What's important:
> Please add to the patch:
> Cc: stable@vger.kernel.org # 6.4

It=E2=80=99s not going upstream just yet, just easiser to apply for testing o=
n my end. I will test it locally too.

=E2=80=94=20
Jens Axboe

