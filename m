Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6335AA7CE
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 08:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235363AbiIBGJC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 02:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbiIBGJB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 02:09:01 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC43B9F9B
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 23:09:00 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
        by gnuweeb.org (Postfix) with ESMTPSA id EA50680C44
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 06:08:59 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662098939;
        bh=PiaEYF9V4R1/VV1YtAFSzk79pFqLN+y5TIiv+FSE56s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FoxacsGyRqlOMscLly2xCJoUqIOP6vmlo0jDryUQ7Er8OYVgk962JXQwI1YiNMyYF
         zixVTcaRCxub5w98y1jVoMinf8SUghThkEHncbazlUDfyyCLLlI98PjwH3qNqNfy2C
         VG/qK+gzqyev/TiwjWKcI0F2cYtjQ2J+8+OIAAujDDAn6+PEvy7Xyjhh51AvqDWsy9
         kIGW2Zb5IfwhkGaudqOLeh7H9dU2AP1uxbl8Jssys5Si1s5QRQz8Z1I3pKNXqhXzl+
         rW8ivJHwyh+3fbn/OYuTqpC/indagkYGopIQ7HxHbYDfu0pKHHoVxJvHGnuWZ/3BT4
         CHZPgEeVu5DKg==
Received: by mail-lj1-f175.google.com with SMTP id k22so1248532ljg.2
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 23:08:59 -0700 (PDT)
X-Gm-Message-State: ACgBeo2tNesjZ8pEGr2IUiegYsGmMCaMoRNjlugEsojDgbGkk6bKsOzX
        GjcG0nzrI+8BNhY7xcz3kki+wIVHpOR0NWU5yrg=
X-Google-Smtp-Source: AA6agR57RRvbPcbubO/dVy33aUkXLDWqXt/0LwfbblGLuGTqWtIXf30RJIz9/yGOjHtxdQ8W1W7lexTMnPpw0XkDiC0=
X-Received: by 2002:a05:651c:1110:b0:268:982a:8805 with SMTP id
 e16-20020a05651c111000b00268982a8805mr3014608ljo.394.1662098938087; Thu, 01
 Sep 2022 23:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220902011548.2506938-1-ammar.faizi@intel.com> <20220902011548.2506938-5-ammar.faizi@intel.com>
In-Reply-To: <20220902011548.2506938-5-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Fri, 2 Sep 2022 13:08:46 +0700
X-Gmail-Original-Message-ID: <CAOG64qODh4hQ_KMuVXFjxM70Cbm+Ph3h=Y9NsnZa+bNBG4ukDg@mail.gmail.com>
Message-ID: <CAOG64qODh4hQ_KMuVXFjxM70Cbm+Ph3h=Y9NsnZa+bNBG4ukDg@mail.gmail.com>
Subject: Re: [RESEND PATCH liburing v1 04/12] t/socket-rw-eagain: Don't brute
 force the port number
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 2, 2022 at 8:18 AM Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
> Don't brute force the port number, use `t_bind_ephemeral_port()`,
> much simpler and reliable for choosing a port number that is not
> in use.
>
> Cc: Dylan Yudaken <dylany@fb.com>
> Cc: Facebook Kernel Team <kernel-team@fb.com>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
