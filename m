Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74309561947
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 13:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbiF3Lbo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 07:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiF3Lbn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 07:31:43 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EE6523B3
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 04:31:29 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q18so16740220pld.13
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 04:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aQuRZYIz9QunG3INUJqeHn04NNvKE3NAELMTnwVzTXs=;
        b=DSg2NVBTdwTOVurkEj4cKRcWG/roGQGvcT5SVcbBvl7ZK3qjK/KcIxhVNdjq4NLE0L
         YNkQnJgqxny+EFV2Hjfoz5G+jEif/Fy/LoE31RrZJAkHmmlZTSDc3LnkcGxXgKMIyR9/
         vsfBCi88LtMYRjPNRCBEkw/BC1A2hV2c+xeTNMXKxi4U3e5uaJVE/cwvfe+4oG2yoxDe
         UIBKB5y+CFxiNS2hC0m6pvBVxz5NFtHGe6w+ZwOKTNoIQygf3+bv2wq4vWlaExc0YuQJ
         U1JtRgqWQPLGyiigCre9JgTStcqVi3NYOKsCgY3yFUcm3xj/Znn/A+VyHO8AgEi8Tw8w
         R1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aQuRZYIz9QunG3INUJqeHn04NNvKE3NAELMTnwVzTXs=;
        b=ALqqDyFKki42+QkHEMifpdO1MvwbpkSoHNarBsiKuzZmgOz9msWGL5eSbmtHM7OTeq
         97dS+MQJKpZ/H0fnb+hIqEziGbcaIFYMOqh7bOU9wQOgW3DZ2fI611ACF2nNEJosEMDJ
         gvlcvyyUVKi0ZtZkXgLvCbyrH18cTajbdxFJmLDEJmEifx/duxmCi3VXoTgt5MDJY5r7
         FHjRHQoPoBgcDm8uYxhY+8Fw20jTi6ze78gBB1TetFMfM79oHRHikGAw4qjqO3E0o1dF
         lSAdHqkQ6Tzyy2rYHy6aeTpKF8XwfgIaBnulQ0y1jvdr6GLxmGufWoI0DOCs7dawtMRV
         OemA==
X-Gm-Message-State: AJIora9rsFE2gWxqZkKEjsvDq4vGUBY9q2QFmrpohth1yHU0I+CAe/y2
        IsTFIEPIVedJqxpoaCfL45Uv71lY7Nq7Boeb4AWUWMZ/OHk=
X-Google-Smtp-Source: AGRyM1t0xenqiXHeVj7aSSLxV9upQOQWXSpBwzSxsee0ppPp8t7g5lnobAgLtmJRyKSp0VzSx33fdfXk6OyFLpZnxGM=
X-Received: by 2002:a17:90a:410a:b0:1ec:7fc8:6d15 with SMTP id
 u10-20020a17090a410a00b001ec7fc86d15mr9802530pjf.236.1656588688678; Thu, 30
 Jun 2022 04:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220630091422.1463570-1-dylany@fb.com> <20220630091422.1463570-2-dylany@fb.com>
In-Reply-To: <20220630091422.1463570-2-dylany@fb.com>
From:   Ammar Faizi <ammarfaizi2@gmail.com>
Date:   Thu, 30 Jun 2022 18:31:12 +0700
Message-ID: <CAFBCWQL38oChF7juHKUv4i4zF0je+98uWkXYhckJAmr89G=ncw@mail.gmail.com>
Subject: Re: [PATCH v2 liburing 1/7] add t_create_socket_pair
To:     Dylan Yudaken <dylany@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 30, 2022 at 4:19 PM Dylan Yudaken <dylany@fb.com> wrote:
> +int t_create_socket_pair(int fd[2], bool stream)
> +{
[ snip... ]
> +       if (!stream) {
> +               /* connect the other udp side */
> +               if (getsockname(fd[1], &serv_addr, (socklen_t *)&paddrlen)) {
> +                       fprintf(stderr, "getsockname failed\n");
> +                       goto errno_cleanup;
> +               }
> +               inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr);
> +
> +               if (connect(fd[0], &serv_addr, paddrlen)) {
> +                       fprintf(stderr, "connect failed\n");
> +                       goto errno_cleanup;
> +               }
> +               return 0;
> +       }
> +
> +       /* for stream case we must accept and cleanup the listen socket */
> +
> +       ret = accept(fd[0], NULL, NULL);
> +       if (ret < 0)
> +               goto errno_cleanup;
> +
> +       close(fd[0]);
> +       fd[0] = ret;
> +
> +       val = 1;
> +       if (stream && setsockopt(fd[0], SOL_TCP, TCP_NODELAY, &val, sizeof(val)))
> +               goto errno_cleanup;
> +       val = 1;
> +       if (stream && setsockopt(fd[1], SOL_TCP, TCP_NODELAY, &val, sizeof(val)))
> +               goto errno_cleanup;

If we reach here, the @stream is always true, because when it's false,
we early return from the `if (!stream)` above. So these two @stream
checks for setsockopt() are not needed.

> +       return 0;
> +
> +errno_cleanup:
> +       ret = errno;
> +       close(fd[0]);
> +       close(fd[1]);
> +       return ret;
> +}

-- 
Ammar Faizi
