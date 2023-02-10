Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5E66929F0
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 23:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbjBJWSS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 17:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjBJWSR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 17:18:17 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5AA4FC1E
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:18:16 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lu11so19409504ejb.3
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N+TOeH19iOq0vdQyV1Prof3NpM6QGVmHTyGEbxYTvX8=;
        b=TFoinpe3pITLVHtLti947pihmGAzoNViv44DXoHnGTTszOCmnwyESdP0lt/lbOrP7t
         8YDtBz+IGoaYOl0Ob5HxjVWGYnebyxpw932EfN70qrgWIPO+7+T6hBCeJjUjrPieoXRM
         laPRsn73b5fpWuslCZ6zcJBfNorWMVHntxmcc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N+TOeH19iOq0vdQyV1Prof3NpM6QGVmHTyGEbxYTvX8=;
        b=2JiftSYvuHwm98eOojJ1p+0iyCwbeVAXdHU8QNfYGGb78r32IQTOqqMqDsupRf7a/5
         ujlP6ZMi3ON2Lp3Cjaj2LFYKrgd8S8m3WnhrDTPGYbujEwRhdIxbw01YG/dk+UEAZuDJ
         TtFfi+uiJZ/zYmhgZBECyEzB2yFFdZKOyRliNmsTst3tEBm0t1UXR4y9BprdcrZ1xj8k
         46bObZ2aMU9CqUV5LQQAc3f+USOx21Iqdy8glJH0XTxDxQSCGs4XOM/GyuAgSMjybVEd
         0/XTYAYEJ3/JweU72U0JEoGfmWlH1OeXuROgkGSZeGGkWePqVgfNpH0bIw+1hkShYXjY
         AcxQ==
X-Gm-Message-State: AO0yUKX8eKKTARU0S5RIT4Ve4QnEUt6ffWy4sSOInEB1XZe98X16Pfkp
        ngLsb6khyewavKmVXGrS90MKFOLI6cuzwbqw1ic=
X-Google-Smtp-Source: AK7set+GnlYhiP4vEWefZTcwOAZV78xpp5w60xLHEhFDDFFqprkY9qa6wWyX9Uhjns6PB6xZdtrLqg==
X-Received: by 2002:a17:907:7da8:b0:8ad:531d:3606 with SMTP id oz40-20020a1709077da800b008ad531d3606mr14288778ejc.35.1676067494487;
        Fri, 10 Feb 2023 14:18:14 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id lr21-20020a170906fb9500b008af0a1f9596sm2928408ejb.218.2023.02.10.14.18.12
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 14:18:12 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id eq11so6082268edb.6
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:18:12 -0800 (PST)
X-Received: by 2002:a50:f603:0:b0:49d:ec5e:1e98 with SMTP id
 c3-20020a50f603000000b0049dec5e1e98mr3399923edn.5.1676067492117; Fri, 10 Feb
 2023 14:18:12 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
 <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
 <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com>
 <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
 <CALCETrUXYts5BRZKb25MVaWPk2mz34fKSqCR++SM382kSYLnJw@mail.gmail.com>
 <CAHk-=wgA=rB=7M_Fe3n9UkoW_7dqdUT2D=yb94=6GiGXEuAHDA@mail.gmail.com>
 <1dd85095-c18c-ed3e-38b7-02f4d13d9bd6@kernel.dk> <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk> <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
 <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk> <CALCETrVx4cj7KrhaevtFN19rf=A6kauFTr7UPzQVage0MsBLrg@mail.gmail.com>
 <b44783e6-3da2-85dd-a482-5d9aeb018e9c@kernel.dk> <2bb12591-9d24-6b26-178f-05e939bf3251@kernel.dk>
 <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Feb 2023 14:17:55 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjUjtLjLbdTz=AzvGekyU1xiSL-wAAb7_j_XoT9t4o1vQ@mail.gmail.com>
Message-ID: <CAHk-=wjUjtLjLbdTz=AzvGekyU1xiSL-wAAb7_j_XoT9t4o1vQ@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 2:08 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  (a) the first one is to protect from endless loops

Just to clarify: they're not "endless loops" per se, but we have
splice sources and destinations that always succeed, like /dev/zero
and /dev/null.

So things like "sendfile()" that are happy to just repeat until done
do need to have some kind of signal handling even for the case when
we're not actually waiting for data. That's what that whole

        /*
         * Check for signal early to make process killable when there are
         * always buffers available
         */

this is all about. See commit c725bfce7968 ("vfs: Make sendfile(2)
killable even better") for a less obvious example than that
"zero->null" kind of thing.

(I actually suspect that /dev/zero no longer works as a splice source,
since we disabled the whole "fall back to regular IO" that Christoph
did in 36e2c7421f02 "fs: don't allow splice read/write without
explicit ops").

            Linus
