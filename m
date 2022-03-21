Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88074E34BD
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 00:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiCUXsy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 19:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiCUXsx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 19:48:53 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958C31890D9
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 16:47:26 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id h7so9665994lfl.2
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 16:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WXgWyp4Um3StwShymSK+s9+iMp7Pr8uzLZsD+EflGPM=;
        b=P45BR3xuiRSoedW8haJjsNx4hmUVitDZGbtShFVyQlOoStCJ0MWeqwYDjCIdCNByBi
         ax4UawZVvZZ8onSffdFCjnu4lySW6OTnI/luDqVOkks1dWhmHytFf8eVJ532KYOviCFt
         ylvChZ1iyoqK0MEu81vBEyfvl8rYa7BuVJ/yI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WXgWyp4Um3StwShymSK+s9+iMp7Pr8uzLZsD+EflGPM=;
        b=cgN6nfltPEkJyXkxI59pMI9OvctOQEImPTseqC5LCjhko2ZC5SfXubJGSM5FCi+qp4
         PIPDm6lYwBSd9MuHcZHBYZ/1/F9RTNCRG8KMUg03ddnwHAmYlO/xzzGsWKAaA+wVupPG
         ofpfktsFh0cKPjrYVO7d47gFGS6rAMQA1VRF6lCV+Rtq2jXBo/vy3AG5MG6EK9c4dmoA
         v6augRFhJh7ob66j/2pmX6KpcXwbs1zn0GgFqSROn0/Dx/2sejweRvMeJALXrUzQD3ju
         YgbNnp9hy1nYcEV2Ft/LbZzbFolUjwZfjlxh1eLzUmXWQLVxkN05GS0alsgtSOshog1x
         B9xQ==
X-Gm-Message-State: AOAM531rceiibmaWENsAl0W8gU2R0UF6IFN6BF71Tiga8VIk0ZMm+axv
        aHbREBRQwLUGTJFON4LQ+C18s+oPk+FN5zwd99I=
X-Google-Smtp-Source: ABdhPJzZei/kLTSFD+y6SFtxqmTDWJXLTt0SeKLZGuX5do5vIR0ZLtPRwU5kpDqyiDSWrXPh1GlnWA==
X-Received: by 2002:a05:6512:3c92:b0:448:5062:268 with SMTP id h18-20020a0565123c9200b0044850620268mr16791704lfv.84.1647906444644;
        Mon, 21 Mar 2022 16:47:24 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id be17-20020a05651c171100b00247eaff0ff0sm2251374ljb.7.2022.03.21.16.47.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 16:47:24 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id w27so27129238lfa.5
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 16:47:23 -0700 (PDT)
X-Received: by 2002:ac2:4f92:0:b0:448:7eab:c004 with SMTP id
 z18-20020ac24f92000000b004487eabc004mr16006296lfs.27.1647906443612; Mon, 21
 Mar 2022 16:47:23 -0700 (PDT)
MIME-Version: 1.0
References: <1fbbd612-79bd-8a7b-8021-b8d46c3b8ac7@kernel.dk>
In-Reply-To: <1fbbd612-79bd-8a7b-8021-b8d46c3b8ac7@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Mar 2022 16:47:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgLwrtFeJ-sitq6f162v1st3GPF7x5BOWJFcn_OHyMYpA@mail.gmail.com>
Message-ID: <CAHk-=wgLwrtFeJ-sitq6f162v1st3GPF7x5BOWJFcn_OHyMYpA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring statx fix for 5.18-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 18, 2022 at 2:59 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On top of the main io_uring branch, this pull request is for ensuring
> that the filename component of statx is stable after submit. That
> requires a few VFS related changes.

Ugh, I've pulled this, but I hate how it does that

    int getname_statx_lookup_flags(int);

thing with 'int' for both the incoming and outgoing flags.

And I don't say that just because the existing path lookup functions
actually use 'unsigned int', and the code strives to do things like

        unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;

So 'int' is ugly, but the _really_ ugly part is how we should have a
separate type for the LOOKUP_xyz flags.

That part isn't new to this change, but this change really highlights
how lacking in type safety that thing is.

The vfs code has a huge pile of different types of 'flags'. Half of
them are various variations of mount flags, I feel, with the whole
MS_xyz -> MNT_xyz thing going on. This is more of that horrid pattern.

At least the mnt code tried to call the variables that keep MNT_xyz
flags 'mnt_flags'. I'm not sure how consistent the code is about it,
but there's _some_ attempt at it.

I do wonder if we should at least try to have a special integer type
for these things that could be checked with sparse (which nobody does)
or at least used as documentation in the function prototypes to show
"this returns a flag of type 'lookup_flag_t' rather than just
'unsigned int' (or worse yet, 'int').

Anyway, I've pulled it, I just wanted to make my reaction to it public
in the hope that some bored vfs person goes "yeah, we should do that"
and works on it.

                Linus
