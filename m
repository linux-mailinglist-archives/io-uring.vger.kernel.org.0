Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F4E61746F
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 03:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiKCCun (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 22:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKCCui (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 22:50:38 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5E613EAE;
        Wed,  2 Nov 2022 19:50:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y4so671003plb.2;
        Wed, 02 Nov 2022 19:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:in-reply-to:references
         :thread-topic:message-id:cc:to:from:subject:date:user-agent:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X6vZTH9YFEkVYVkeuyJWD2sRIO9E7ggdkdZcNa+H/Tc=;
        b=Yozn1sDz07BRRgoQcnrv4hJarubPzCRuY9xQy/9Enyikd7gxMXK6AI6Oy3zuM0qgZq
         n/Y3K+M/yGBofk+6jPq1hGxuhJ7s0f5vfs50rv75f32u2K7CSfY0QAT1e6CmdDGzOLRL
         EqIF8IcW1KZp80kfTdTdjViakhwbHTa9NaeVikDr7GhZNNN/dzxRF7R/G1ofuCJ5swdq
         st7UxgC4S8fJlorY3bar8+NOrgvVKGTs7Yb8N/XXp+q28MgtutJYSMK1IG27DopkjmzA
         lqFPpTaOb+e+wlYeM3pWPx1g4F67Av/ajuKE+7tmbApCT4z7SdeR0/1eROIo7UZJKHHQ
         H4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:in-reply-to:references
         :thread-topic:message-id:cc:to:from:subject:date:user-agent
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X6vZTH9YFEkVYVkeuyJWD2sRIO9E7ggdkdZcNa+H/Tc=;
        b=l/EbFx1ISnCWUhZFWEFFcuClKjyNiweOtbsN6Ngmrvnh9WTzn0X8KmCSVieGpAB8P/
         RcWwzrv8l/73RfKSHEezDQqnUcfIkqFsgdk7bNupvcSsE2Q0v4EsV71taheUrtietnX0
         R72gSF4vJ/VGbE5Ei6os4K8bNjc87d0adDFDuO6DkvNsbK7QVRNa/yf3cvGS46bEi2OE
         1Vtxlwlla9rlddHACYvLH/bEQydc3TGivk1R1HvyX+VTc6PcYJRUB/6IJOiptL0DWEG/
         7CzCpZjnSVApGAY1u8ti4ScGLMm9wluviLBbgWqtZDQCe9phfBDxn9TTf93/hGgUCwM5
         cDug==
X-Gm-Message-State: ACrzQf1vKjOX5CWig32NmhBG0isVjJ7sBdC/VpPJgL+ZL06q/LiGXQBf
        oc62jwK45CUOUwcqXD6495U=
X-Google-Smtp-Source: AMsMyM7f6wWzbZo6cDTlq3Yz8BBuqY/S4z1RKQ9fl1u+bQHfhHPL623EffNYuhVHqhnqtoYPeY6tQQ==
X-Received: by 2002:a17:902:ef47:b0:179:d18e:4262 with SMTP id e7-20020a170902ef4700b00179d18e4262mr27428896plx.22.1667443834863;
        Wed, 02 Nov 2022 19:50:34 -0700 (PDT)
Received: from [30.20.53.44] ([43.132.98.47])
        by smtp.gmail.com with ESMTPSA id v185-20020a6261c2000000b0056c2a85c097sm9084608pfb.20.2022.11.02.19.50.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Nov 2022 19:50:34 -0700 (PDT)
User-Agent: Microsoft-MacOutlook/16.66.22102801
Date:   Thu, 03 Nov 2022 10:50:32 +0800
Subject: Re: [PATCH v2] io_uring: fix two assignments in if conditions
From:   Xinghui Li <korantwork@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>,
        Xinghui Li <korantli@tencent.com>,
        kernel test robot <lkp@intel.com>
Message-ID: <EF99381C-E842-49AE-A683-B8EABD1612A0@gmail.com>
Thread-Topic: [PATCH v2] io_uring: fix two assignments in if conditions
References: <20221102082503.32236-1-korantwork@gmail.com>
 <630269a9-29a3-6b75-0a67-449ec36e7e5e@kernel.dk>
In-Reply-To: <630269a9-29a3-6b75-0a67-449ec36e7e5e@kernel.dk>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MIME_QP_LONG_LINE,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



=EF=BB=BF=E5=9C=A8 2022/11/2 22:19=EF=BC=8C=E2=80=9CJens Axboe=E2=80=9D<axboe@kernel.dk> =E5=86=99=E5=85=A5:

>    On 11/2/22 2:25 AM, korantwork@gmail.com wrote:
>    > From: Xinghui Li <korantli@tencent.com>
>    >=20
>    > Fixs two error:
>    >=20
>    > "ERROR: do not use assignment in if condition
>    > 130: FILE: io_uring/net.c:130:
>    > +       if (!(issue_flags & IO_URING_F_UNLOCKED) &&
>    >=20
>    > ERROR: do not use assignment in if condition
>    > 599: FILE: io_uring/poll.c:599:
>    > +       } else if (!(issue_flags & IO_URING_F_UNLOCKED) &&"
>    > reported by checkpatch.pl in net.c and poll.c .=20
>
>    I'm not super excited about this patch as the previous one
>    wasn't even compiled? Did you test this one, compile and runtime?
>

First of all, I'm really really really SORRY for the last stupid warning an=
d my careless.=20
But I did make kernel and install it in my device. Also, I did the fio test=
 with polling. However, there is no warning be reported by 'make' command.=20
But when I check the patch code with 'smatch', I did find that warning. I r=
ealized how stupid that mistake was....=20
So, in addition to compiling and installing this kernel, I also checked the=
 code using the static analysis tool this time. There is no new error or war=
ning.
"
make -j64 CHECK=3D"~/workspace/smatch/smatch" C=3D1
  DESCEND objtool
  CALL    scripts/checksyscalls.sh
  CC      io_uring/net.o
  CC      io_uring/poll.o
  CHECK   io_uring/poll.c
io_uring/poll.c: note: in included file (through io_uring/io_uring.h):
io_uring/slist.h:138:29: warning: no newline at end of file
  CHECK   io_uring/net.c
io_uring/poll.c: note: in included file (through include/trace/events/io_ur=
ing.h):
./include/linux/io_uring_types.h:151:37: warning: array of flexible structu=
res
io_uring/net.c: note: in included file (through io_uring/io_uring.h):
io_uring/slist.h:138:29: warning: no newline at end of file
io_uring/net.c: note: in included file (through io_uring/io_uring.h):
./include/linux/io_uring_types.h:151:37: warning: array of flexible structu=
res
...
  BUILD   arch/x86/boot/bzImage
Kernel: arch/x86/boot/bzImage is ready  (#10)
"=20

Again, I am ashamed of the previous mistake. And I totally understand if yo=
u reject this one.


