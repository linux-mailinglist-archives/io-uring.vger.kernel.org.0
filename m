Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50223F6D18
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 03:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhHYB2s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 21:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbhHYB2r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 21:28:47 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEDEC061757
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 18:28:02 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id h9so48166494ejs.4
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 18:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=lWknN5d/AnWyVKyY+XkPZYRAoX0q0YlQkvzP4svLWfo=;
        b=ExazGXzmaKWT75mrVofaUnDTme0XuZhGcgbrUstI2kBza786uw4cJJ44XPTdeZR0/K
         sYqe7WF4Nnn++/zFosbKNDirOH3EFmiMKC0gQBkMFf2QMp6vpLLpQaoYGHqShqryxbKV
         hMJGod66sGJmJayAP7Ug1Hj7bk1q34KHOoyeUkEcbYfQPZy4K8UZVtC5T31Yyluy9MuT
         mxahKamItUuLlyKCfOWbwITzP7egH6cCizTnhpmLuOXmBjxwsG5yFT3YghAWRPskbU6b
         EUDuFMV0vORQ7pIXQAExazQjO4gjFBdlPH1Zg1KPE+Y/Fql4+W6eFh6UKYz49gMZI/3o
         oiCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=lWknN5d/AnWyVKyY+XkPZYRAoX0q0YlQkvzP4svLWfo=;
        b=eyVQqo0q0it+2YFDZA2j1UEJOO8Tb14Qv4kmpvDeXLAvoIgs/IJc5km9sw31OXm2OK
         39ZuSzkvz4XbGYA+yscA0EXtnbP2HCMxdpXXdF+elXDuxmIicQT2v2FLT7rGKcPc0xoI
         rWOQ+pEpk0C78W6IiMnPr2cxfMvjwe/Ph8TEKeDTl0r6CT9d1rT7QGCUc/M4j2hJYNXI
         oJw3cLn3dQb1sbNOP2NFbU1FeY4c4MsofqAlPA0asyIXYqlSOmOLOVH/QGXevUfStNus
         OtPC0QhJTA3+Ob71fuXrAy0OzAXpvdQY7U7ah4POCB4GZuJy2Y6T2rcOoIyAMWTQ2fx4
         28HQ==
X-Gm-Message-State: AOAM530e8ntYtRRYKz14DcDqW1EsijZEc6GHv9W+J919M4GYbFS4Wik0
        ds2CGGmfSCFkETiyeEC09JJff2OQKx0TcshEMcmEPrnSvizY+y7gwAo=
X-Google-Smtp-Source: ABdhPJwq+p22LzmuPvZcEDGGz0N9PWaIPcx9bmFvjFBlo0B9G5qIS2J/OmR/np8Ko1q4EUV2++GncHQqJl+danWtDSk=
X-Received: by 2002:a17:906:374e:: with SMTP id e14mr22227838ejc.161.1629854881246;
 Tue, 24 Aug 2021 18:28:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAM1kxwhHOt1Ni==4Qr6c+qGzQQ2R9SQR4COkG2MXn_SUzEG-cg@mail.gmail.com>
In-Reply-To: <CAM1kxwhHOt1Ni==4Qr6c+qGzQQ2R9SQR4COkG2MXn_SUzEG-cg@mail.gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Wed, 25 Aug 2021 02:27:50 +0100
Message-ID: <CAM1kxwi83=Q1Br46=_3DH46Ep2XoxbRX5hOVwFs7ze87Osx_eg@mail.gmail.com>
Subject: Re: io_uring_prep_timeout_update on linked timeouts
To:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 24, 2021 at 11:43 PM Victor Stewart <v@nametag.social> wrote:
>
> we're able to update timeouts with io_uring_prep_timeout_update
> without having to cancel
> and resubmit, has it ever been considered adding this ability to
> linked timeouts?

whoops turns out this does work. just tested it.

well i guess it's documented now!
