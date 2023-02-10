Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FBC69286E
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 21:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbjBJUhX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 15:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbjBJUhW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 15:37:22 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3518B5A9E0
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 12:37:19 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ud5so18913166ejc.4
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 12:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V5hbvtyrVhBU5KLvd4luM4pmIGBHWSgPPjkAzLVdXdc=;
        b=XJVb1xKfBvelCl8Xuh4Bkq319Cx2dxwUHidMnSfKqGDU/b9SmTwk9u5Vp4ORhPDBNt
         uLp+1raScNofpejxVBGtMzdmvBtnEGPM6qvYjZcLw/dIFGbo6cMI3yaedOJppVXrhg5I
         8ihrf6+ZhqT/79pvdvMQsBrrZs8E6lxb26z2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V5hbvtyrVhBU5KLvd4luM4pmIGBHWSgPPjkAzLVdXdc=;
        b=OATQmfv84BijrbtwZQlRsJobAA/xkPD+prKn/iUp3JPdjUXB6lklRepDmjVvB/Pg5b
         g9odQbQbPINqPKrgirRYiN2y3dK0qfZrO+ulvPh33g3HqnzaWoKDrZ4krY52UmnQ3gCM
         rUESvPkbEJyKKqnmg6GCY/53J+bT2VLmd3hKaK6PpgMtMAv5iSYAZy8SlTIicoKEFybk
         V4qyFPzeyWUaL3KwRqgV+tNLjgdv7DhDcmD03hxFJ5XbfLXjMVPg7mrXBP5HezBQz+L6
         6MhY4CKlv7szLwLg4b/++pMF7Qh3geSdVCJM2T1BlsUzsBHGkbBHk/4S2ce0/FPf5kvs
         NtzA==
X-Gm-Message-State: AO0yUKU14nbKUI+3Rq/5GI4ckEyKM7oTZCSB5KPXD6lp3A+p/3EGXY7K
        rfFv1PC+cOoSQm53u8dv5c5NkBp9j9yUBpG8ATQ=
X-Google-Smtp-Source: AK7set8o2BVOzVlcE6yLS3C3SvgYeo9XyEmsjXoiGRZPQR5w3lw/REueqTGwAlzZ85oQil2qL+gsug==
X-Received: by 2002:a17:907:6d94:b0:8ae:e724:ea15 with SMTP id sb20-20020a1709076d9400b008aee724ea15mr14086673ejc.76.1676061437414;
        Fri, 10 Feb 2023 12:37:17 -0800 (PST)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id kg12-20020a17090776ec00b008710789d85fsm2825935ejc.156.2023.02.10.12.37.16
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 12:37:16 -0800 (PST)
Received: by mail-ej1-f48.google.com with SMTP id p26so18814548ejx.13
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 12:37:16 -0800 (PST)
X-Received: by 2002:a17:906:f749:b0:8af:2ad9:9a1d with SMTP id
 jp9-20020a170906f74900b008af2ad99a1dmr1552969ejb.0.1676061435878; Fri, 10 Feb
 2023 12:37:15 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area> <20230210040626.GB2825702@dread.disaster.area>
 <Y+XLuYh+kC+4wTRi@casper.infradead.org> <20230210065747.GD2825702@dread.disaster.area>
 <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
 <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
 <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com>
 <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
 <CALCETrUXYts5BRZKb25MVaWPk2mz34fKSqCR++SM382kSYLnJw@mail.gmail.com>
 <CAHk-=wgA=rB=7M_Fe3n9UkoW_7dqdUT2D=yb94=6GiGXEuAHDA@mail.gmail.com> <1dd85095-c18c-ed3e-38b7-02f4d13d9bd6@kernel.dk>
In-Reply-To: <1dd85095-c18c-ed3e-38b7-02f4d13d9bd6@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Feb 2023 12:36:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
Message-ID: <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Jens Axboe <axboe@kernel.dk>
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

On Fri, Feb 10, 2023 at 12:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> No, we very much do have that for io_uring zerocopy sends, which was in
> the bit below you snipped from the reply. It'll tell you when data has
> been sent out, and when the data has been acked.

Hmm. splice() itself definitely doesn't have that data - there's no
"io context" for it.

There is only the pipe buffers, and they are released when the data
has been accepted - which is not the same as used (eg the networking
layer just takes another ref to the page and says "I'm done").

Maybe adding some io context to the pipe buffer would be possible, but
it's certainly not obvious how, without changing splice() semantics
completely.

             Linus
