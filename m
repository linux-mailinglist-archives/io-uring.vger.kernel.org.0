Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A736D8576
	for <lists+io-uring@lfdr.de>; Wed,  5 Apr 2023 20:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjDESBY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Apr 2023 14:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDESBX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Apr 2023 14:01:23 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB9935B1
        for <io-uring@vger.kernel.org>; Wed,  5 Apr 2023 11:01:22 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q19so33984026wrc.5
        for <io-uring@vger.kernel.org>; Wed, 05 Apr 2023 11:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680717681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLrEf9a2wNEZEPGINOMaNjvjW0v/rp3UWSqS8/lvsbE=;
        b=h0xU4ooZavGh6cLeHUds7oKPsvNT5HoDZLgr9TvSSJ6kKSPwxTJpJbjch626U6nLwK
         87raSHWgtPpfaDUDNc6A6T+M1oVqQQ7i5UwbM/DyfJoCg8mCli1VswJBLWma9J5v8Wmg
         5eLdTa/SmhRgMkR+73YDK/T/BtRQKUzsoN50oQQcaYrXw2n5jihEqKyb7AINYcQg9i+4
         gvfPRRH6ggLuz9G7dyzBtMlYpqFcgFB6dBFdkRtCcvDMe/UjH5dqjHY/AxesF8ikcxmZ
         fPC5WV7ZCSm6qIM32euxYoAo2c7+T+ETI1wK20x8YSP0Ghnxi6ks2RQHiJLfesoOmzHk
         Wh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680717681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hLrEf9a2wNEZEPGINOMaNjvjW0v/rp3UWSqS8/lvsbE=;
        b=ZcMOnmbVVkgqgiWmEXH0oJ74g+eFPNG80C7F5jK74rj+iolPP2mWz4boJbsVfGOD4d
         F7SaRCOLl7VT/HXUjtaF0Tr4rMAEn8RrFzPnx+MOSu5w4JfHw5EJeq6WDeDo8D8lTPlV
         szzBYkABa/5wFuf2cmNMsEB5SuLvqNbaIA69oVUiu+ub3XiCzXHZO9HjCwSib7Wp4ALI
         5VZPwgpjE6ExpfDGZqITD06OhOweoMQqGliqYWLBHFZu7zAWDmLFmKvy6WnABGS0NV49
         QRjwqcdUqDBIUcCJnAP0Svw+ri7ZK2JarutYmXitEOL7QAMpSaxmIHwfyFavv/bpEYD3
         +Dyw==
X-Gm-Message-State: AAQBX9dOeuiLccVbVaTl3n2+tGNuYZhomzktAEEX+fBPNwjUOqvZcWHm
        93aalPKhR63LQxFu32fsV5VRVFT2WeX45e/uGpM=
X-Google-Smtp-Source: AKy350bM4Fy2aB6iPKsY5YMI4/ffSxIzZmxd6ccKfjhWjma/QgFGZhiqPG9Gvcto1+8MDTZLylbig9eRAMvr6tVmyGE=
X-Received: by 2002:a5d:680d:0:b0:2e4:bfa0:8c28 with SMTP id
 w13-20020a5d680d000000b002e4bfa08c28mr1331093wru.14.1680717681057; Wed, 05
 Apr 2023 11:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <863daab3-c397-85fc-4db5-b61e02ced047@kernel.dk>
In-Reply-To: <863daab3-c397-85fc-4db5-b61e02ced047@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 5 Apr 2023 23:30:55 +0530
Message-ID: <CA+1E3rLQ77RUaPgMzT_vB7oUqOWOakv7-GkXW0cFWfy49M5JAA@mail.gmail.com>
Subject: Re: [PATCH] io_uring/uring_cmd: assign ioucmd->cmd at async prep time
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 5, 2023 at 7:54=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Rather than check this in the fast path issue, it makes more sense to
> just assign the copy of the data when we're setting it up anyway. This
> makes the code a bit cleaner, and removes the need for this check in
> the issue path.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
