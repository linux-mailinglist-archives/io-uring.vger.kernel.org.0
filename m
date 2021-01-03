Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2A72E8C9B
	for <lists+io-uring@lfdr.de>; Sun,  3 Jan 2021 15:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbhACO1e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 09:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbhACO1d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 09:27:33 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51457C0613C1
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 06:26:53 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id c133so14829278wme.4
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 06:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daurnimator.com; s=daurnimator;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cdyQdxurFTWyieFqx40CmBAoJaRWHmu1pRJJqDh4s5U=;
        b=JHNprKCEMlJgPWrm5Lf8OKHrWDbu4cEkVI6wyETQU0N7Fi8v5Ypp/+nkY/AH2GR/xs
         03HCcW+FEV5VDByHaCH5AKFMjTu24gF7Gq4q8kPosYWDGBO0gm97o3VYffDbTGaInjOZ
         Sa8FL0FLEOy5wkVQ2SJe2vxdz1vPL9rcg8DYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cdyQdxurFTWyieFqx40CmBAoJaRWHmu1pRJJqDh4s5U=;
        b=cj+woPDW/5SAVer6zpsLSF10HDA+cdy1OyzaAB0haDii2QlgRvqgHUTpj2IEBq+VI5
         saePV4EVjyqT9zDR3lk7eZHduEc1g/t1mYU5A2IjQHKgrcRcGuhMmVf0fLy/DDo+1mrc
         GXo7FsauJe4VN8uXPwg9mA4Xn6oCg7B/zp58/QKFkPlRFWCtBuumuN7mrVEeu+H0JGoM
         2h6JoVXP9itSXDpeydvOC6oeUC+6PBygpXxMbyDLHwI4ISgDYYpOIHW7iQkepBXJ6o0E
         YraWrBFCEEBz8eG/YsB2BmNctGH8sgz1yGWKcjR5FYqhiNVNbcV6ERND5TMq1MLG6sTW
         FmsQ==
X-Gm-Message-State: AOAM533Pr4YWdtvF73gSQc2EFhaTlsULXYsgvIRJccKvZ6uSuJW7TlDc
        ks54+8AzljWv81CziyjZjvufKgN30+LXEAJzTVZxmg==
X-Google-Smtp-Source: ABdhPJwFlghKT98/Z0lh6E4GwRePMZJ+jb52otf0aNEGyGaXkWUSRiOfpQxV7ZsIBGH2niNmnsTYvIahv/eJODbOWn0=
X-Received: by 2002:a7b:c8da:: with SMTP id f26mr23264936wml.50.1609684012066;
 Sun, 03 Jan 2021 06:26:52 -0800 (PST)
MIME-Version: 1.0
References: <20200827145831.95189-1-sgarzare@redhat.com> <20200827145831.95189-3-sgarzare@redhat.com>
In-Reply-To: <20200827145831.95189-3-sgarzare@redhat.com>
From:   Daurnimator <quae@daurnimator.com>
Date:   Mon, 4 Jan 2021 01:26:41 +1100
Message-ID: <CAEnbY+fS8FXVeouOxN3uohTvo7fBi5r7TQCGBZUmG3MGJhBrYg@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        Aleksa Sarai <asarai@suse.de>,
        Sargun Dhillon <sargun@sargun.me>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 28 Aug 2020 at 00:59, Stefano Garzarella <sgarzare@redhat.com> wrote:
> +               __u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */

Can you confirm that this intentionally limited the future range of
IORING_REGISTER opcodes to 0-255?
