Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20E21B5816
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 11:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgDWJZK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Apr 2020 05:25:10 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:40865 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbgDWJZJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Apr 2020 05:25:09 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1M4roN-1jSv120psd-0020KI; Thu, 23 Apr 2020 11:25:07 +0200
Received: by mail-qk1-f170.google.com with SMTP id t3so5686261qkg.1;
        Thu, 23 Apr 2020 02:25:06 -0700 (PDT)
X-Gm-Message-State: AGi0PubPju4TS9vqFIy5fUpPQXhorHWEfCTMOmWy9O+uzLsr19DU4U0c
        kbcUSai7neEsPCcvYaur2DGy6nKnjCrmZIZgJh0=
X-Google-Smtp-Source: APiQypL+w45VTBoxMvprVb6NEGdgZyNyPMU0dKAvD2rTXgVRLwfn3/Y7HWt6ZXTYoBoj1KPld4qOl8X+Utd6NzHUvt8=
X-Received: by 2002:a37:63d0:: with SMTP id x199mr2439571qkb.3.1587633905619;
 Thu, 23 Apr 2020 02:25:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587531463.git.josh@joshtriplett.org> <05c9a6725490c5a5c4ee71be73326c2fedf35ba5.1587531463.git.josh@joshtriplett.org>
In-Reply-To: <05c9a6725490c5a5c4ee71be73326c2fedf35ba5.1587531463.git.josh@joshtriplett.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 23 Apr 2020 11:24:49 +0200
X-Gmail-Original-Message-ID: <CAK8P3a09h4jhJWckxVUMYLoUp8=vAJ5NXuMTzSmghRxuk2_PTQ@mail.gmail.com>
Message-ID: <CAK8P3a09h4jhJWckxVUMYLoUp8=vAJ5NXuMTzSmghRxuk2_PTQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] fs: Support setting a minimum fd for "lowest
 available fd" allocation
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Aleksa Sarai <cyphar@cyphar.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:e6+fXZCzbNUcGueHZi0BR8/JFqXLu3ow8UkwsShEw/fDTsxMjHo
 Qt1mAwe83HkCU+qPttGnY+0+8e3ZAHvsTa02Fukov2D2leInYAI/HO06d2FyAdvYk3pgoIh
 89W3fIgoQ6/p4NNtT/BtKzw5jAz2+rRJy2GeWnBok4QDe/DCzXnyOn+APqk5xJG0Kx4aAp2
 vy+iKbATk+5JtgOy4odVQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:V3w25P3eXTE=:ThBWKENYGuaDDbCgV64qnP
 bkbRgl8/B2JfJMnqoS0JcufoLCvJqQNpdxz+pX4XaXGGEokkLU9t8l4Ha1MlAHOFKG/8K6FXI
 MYgyZ0j2vV5S0xR09xlGrx+I3Lfoa56k4t6h6pX0LTYtAUgK2cIJMjm4eOc6jQdXBEAiaDdE4
 KylyazTM42OhTMoN6Qw1U1rlngh6GgVM9AT90hM/XVLp5mEfR6nldUdSReMlKQmPSYSOq+0Pz
 aD7MXXCwbVwbu1VX3wHVgAp+JhwDrK/Bbr6svVTCIR4MqTy7I503erAZvZtqm+7y6HsS9/SwK
 C6131GSKb579dphRwUOY76Eh+oBlIZgjwNopQS/eDDIBqpswCUTpCF4McxzZ1auDrOMA68/X8
 tP2KlKWOvFCG80DicrkpzLNXqQVippZPOgPqkVs5AqvEqwQG6+tdQu82gRBMUtEMrJgADgtH5
 7ezukIAhwBbMBSGDPAb6F84UR9oixi2YEnHSK93vq69kT65uLfVEZdbaazznxZzq3EUmTLniB
 q3r8wazivQU22HEn79g0Jal+QVdPnEQM41vBpJ/6hZBe/T9+PAwFpec/re6J5FIemCkKHzUpO
 2ras1d3DBNePUpsWkCX8uW69oIsM7wWleraqMomlc9EUebhOa3Hu3RnEWjywuu0uo449qjD9t
 yHWhG+k50RrPr9MhcRvBxlifJIcFlP69epb+U4BuIgglulInbGMZvYyxlj/XjySxeQZItuhLp
 3Ymw+EJwVAIu3LOp1e92ImKesomN3PC4JP3/s0b8LQ9vGHci3Z1z7rjfVhyEZtHub3Pa4wpLM
 M4OEPdbG01a3cYWIZvLOQG5wmdOIKX8dOZZX7tg6VELwG4fFbI=
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 22, 2020 at 7:19 AM Josh Triplett <josh@joshtriplett.org> wrote:
>
> Some applications want to prevent the usual "lowest available fd"
> allocation from allocating certain file descriptors. For instance, they
> may want to prevent allocation of a closed fd 0, 1, or 2 other than via
> dup2/dup3, or reserve some low file descriptors for other purposes.
>
> Add a prctl to increase the minimum fd and return the previous minimum.
>
> System calls that allocate a specific file descriptor, such as
> dup2/dup3, ignore this minimum.
>
> exec resets the minimum fd, to prevent one program from interfering with
> another program's expectations about fd allocation.

Have you considered making this a separate system call rather than
a part of prctl()?

At the moment, there are certain classes of things controlled by prctl,
e.g. capabilities, floating point handling and timer behavior, but nothing
that relates to file descriptors as such, so it's not an obvious decision.

Another option would be prlimit(), as it already controls the maximum
file descriptor number with RLIMIT_NOFILE, and adding a minimum
there would let you set min/max atomically.

     Arnd
