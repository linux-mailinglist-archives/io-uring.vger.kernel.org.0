Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C2634FE33
	for <lists+io-uring@lfdr.de>; Wed, 31 Mar 2021 12:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbhCaKis (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Mar 2021 06:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbhCaKip (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Mar 2021 06:38:45 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48A5C061574;
        Wed, 31 Mar 2021 03:38:44 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 8so20624164ybc.13;
        Wed, 31 Mar 2021 03:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gwFWiAAo/CecaCtDMzpur7T6aDGvM/jPW87E1cydXFk=;
        b=XVOhfxbq3nx/uzDm2FqCjeqii8oCTYYevIGGayQHXSkQQRkHgGiIpj66zecZk8S2Ll
         SiV5yA/VgDku3elcXawY/Wzagnf+paaIAZG3qB0/qx3mVvJLm+gEd0dkjDuKPoxacQx3
         2DxtuGubLgbOdsMoARCtTvKaq1eioIPYBenqPqCUGn7ZxIL3MZ3UcpvCHz1qVLcGyWfC
         s7FQ6RPMkJCOWfNmGIo9yFz2k3ANSsUnZwcQ/mZlIGRkof70kzFMqulKVHaUzvedU+4A
         idR/7QzoLC4CQcyDHEEDTNWyNZqUsDSqQgpLHEetXu89tuHtZgp5/SVqwN/kklMXQes0
         XaMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gwFWiAAo/CecaCtDMzpur7T6aDGvM/jPW87E1cydXFk=;
        b=OOID70N4BgKKQ/uEtIUg5g/QgEGEyeZMIjU7PbxavJA7saSoqBAuB/qthipdZW1AVV
         TytZ6pjDN3wJcb5Ra7g5r2+IoLilvubJKKhjXYRbttQnY+NPFkF7ESKUgOw2HouLXmQA
         xDkVfkqkkb1uD/koeOgvBUY2L/vhSvysrN9m2pL3OI4gOeUx8hGJC+4i5z8M3bHmaGC1
         6zCO0oxG7+rW3QfNe0lnZsQ38Bv8Myn0Vl0pRSWDlwwVgX4nRkpXS98wcIZecHNHjC8k
         zD4cHNd71fzuuU66kUqeDeI7N505ULTzKmPauIxa+78nEj92oY/5ZnRO2AVrwzxU5mc3
         6cPg==
X-Gm-Message-State: AOAM531uVkMpV9x6QrVcTDjo2VwZcNZxXq6UB1xlgHMk0FZHI9MCypU2
        ooO6hHYbo7RDVOq1GR+Velqp0+Msr7OvngmnBXQ=
X-Google-Smtp-Source: ABdhPJy4qcW/OU6viSzbLHrEQGcIB14rZ6fT/yOABp2fYuMtIY1Sbgz+O70ehDRP6JdPHt14yGIG+YiwxVETEC+kkPQ=
X-Received: by 2002:a25:d0c7:: with SMTP id h190mr3984375ybg.428.1617187124194;
 Wed, 31 Mar 2021 03:38:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210330055957.3684579-1-dkadashev@gmail.com> <20210330055957.3684579-3-dkadashev@gmail.com>
 <YGPRCeimsXXaoCGZ@zeniv-ca.linux.org.uk>
In-Reply-To: <YGPRCeimsXXaoCGZ@zeniv-ca.linux.org.uk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 31 Mar 2021 17:38:33 +0700
Message-ID: <CAOKbgA5C7u9imkbFOovD9Vyh3QojmdSFea1asPKjkiw5gB6zLg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] io_uring: add support for IORING_OP_MKDIRAT
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 31, 2021 at 8:32 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
> had the questions about interplay with audit been resolved?

Not to my knowledge. It's just Jens asked to rebase on for-5.13. I'll defer to
Jens to discuss / decide whether adding new ops before the audit side is fixed
worth it or not.

-- 
Dmitry Kadashev
