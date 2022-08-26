Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF8B5A2C4C
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 18:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbiHZQ1z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 12:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiHZQ1y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 12:27:54 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6031DF671
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 09:27:52 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 92-20020a9d0be5000000b0063946111607so1327903oth.10
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 09:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=47LwKtGNYlWQtvjArJ9MTlK2TLiKWMwqH2B+EdD3Yxg=;
        b=tK4EUedtQOYlUbQ9rz8qZEWcPQfNuVKnEVcWSbjTZd+bSTZpYK6/V0nBX8U4y2Xx7D
         tJ32A90gQvwji8I7cCfc7OOv/J1+FyQT5i9YPR02szHEivROhzf3e+2Sr0zI5GvqE39T
         39kEPb6qX4NQ9XoXraVX8oEdfm8wATVbKxkDvrUsUDFUuJOElVoBDPLYceAphjjQVaqm
         ahP+xIeyJapQkG1p+2OIfslb3zt7mIyC004jePjvQU/VMe/drS6Nc6nWSJfNpGRKPTTX
         M+43a4AaciJ0YJAiYY66porxUXUTy1VFYubb2DO9ORNLpABv01tOiQlOOd5O70YqU7Eu
         qjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=47LwKtGNYlWQtvjArJ9MTlK2TLiKWMwqH2B+EdD3Yxg=;
        b=IdikiDTL5Vk7mElFMFvofnTM7rrdr4fo7SeD4+++kxvPeT9gPG3kJt8FBgFwiOWQ9p
         Zh5funD2F3l5NLwRS/h4euUqrBlpVIRmmfbiIGscFD203CoS7QRmsl1Mo880W7NuCSMM
         1iDrUrQr5bJbp9BxbWMUj3S/GWnCPCS4hSHQzW/GHGuOFSiwDl/vi0fql1mrnd5Alzou
         eM25Cv0eoC+yE1Fkjg1ahdMVsIudd7UboKoPf3eT7QtA6a9HuF8utlmAZLf9KdxkUDUh
         8UTG9a+VQqMylzZhr1Qfh76/WvgECnOUUy7UW3toBlWN1mbe3Ihf2an17WFPErA6JCaq
         hNqw==
X-Gm-Message-State: ACgBeo0FwpLP574UcbL+VdQuBrk+rGCNq9S2s8ZcOBSqs6OyHP57EqLb
        3JZukCVy0a9YEq3jCTXa+6XWmwEAFdZ08WuMS4qMpBMKGQ==
X-Google-Smtp-Source: AA6agR56wZjfLf4m3YYmXcc8h3RgFUmmJx5HKVS0cMVPJ5sAurta2N4ICkrCM6pnK6862M1r3F1DuF3Y72PkxTaVwFc=
X-Received: by 2002:a9d:2de3:0:b0:638:e210:c9da with SMTP id
 g90-20020a9d2de3000000b00638e210c9damr1643453otb.69.1661531272188; Fri, 26
 Aug 2022 09:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <166120321387.369593.7400426327771894334.stgit@olly>
In-Reply-To: <166120321387.369593.7400426327771894334.stgit@olly>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 26 Aug 2022 12:27:41 -0400
Message-ID: <CAHC9VhRJXxx9LwQyapdW=cDioCcjdHpx4EEuiNC2SJVTz9Z7DA@mail.gmail.com>
Subject: Re: [PATCH 0/3] LSM hooks for IORING_OP_URING_CMD
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 22, 2022 at 5:21 PM Paul Moore <paul@paul-moore.com> wrote:
>
> This patchset includes three patches: one to add a new LSM hook for
> the IORING_OP_URING_CMD operation, one to add the SELinux
> implementation for the new hook, and one to enable
> IORING_OP_URING_CMD for /dev/null.  The last patch, the /dev/null
> support, is obviously not critical but it makes testing so much
> easier and I believe is in keeping with the general motivation behind
> /dev/null.
>
> Luis' patch has already been vetted by Jens and the io_uring folks,
> so the only new bits are the SELinux implementation and the trivial
> /dev/null implementation of IORING_OP_URING_CMD.  Assuming no one
> has any objections over the next few days, I'll plan on sending this
> up to Linus during the v6.0-rcX cycle.
>
> I believe Casey is also currently working on Smack support for the
> IORING_OP_URING_CMD hook, and as soon as he is ready I can add it
> to this patchset (or Casey can send it up himself).
>
> -Paul
>
> ---
>
> Luis Chamberlain (1):
>       lsm,io_uring: add LSM hooks for the new uring_cmd file op
>
> Paul Moore (2):
>       selinux: implement the security_uring_cmd() LSM hook
>       /dev/null: add IORING_OP_URING_CMD support
>
>
>  drivers/char/mem.c                  |  6 ++++++
>  include/linux/lsm_hook_defs.h       |  1 +
>  include/linux/lsm_hooks.h           |  3 +++
>  include/linux/security.h            |  5 +++++
>  io_uring/uring_cmd.c                |  5 +++++
>  security/security.c                 |  4 ++++
>  security/selinux/hooks.c            | 24 ++++++++++++++++++++++++
>  security/selinux/include/classmap.h |  2 +-
>  8 files changed, 49 insertions(+), 1 deletion(-)

FYI, I just merged this into lsm/stable-6.0 and once the automated
testing completes and we sort out the Smack patch I'll send this up to
Linus.

-- 
paul-moore.com
