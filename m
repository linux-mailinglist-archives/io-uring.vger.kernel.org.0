Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2125A2B06
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 17:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiHZPWa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 11:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344576AbiHZPWI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 11:22:08 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DAF7C527
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 08:15:53 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id w196so2320637oiw.10
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 08:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ShbxCkrGW9DfdQVLrPQRJ9UfGCb7QUf2OMEdTXmy04Y=;
        b=giojp+OWiqrhpRDZ5dvyQ2zLFVlgc8lXEoGBEtPyAoQ5+8Y/nSv3DJnXPxsJ7aBTMp
         O3JxDHCEKrxf2S77NuVyQbe8DqfTAO02cgquSD+3qYaVTmCXQLhHpTotbKcRVulu0ckt
         vtpg9TkGBEgJ75n3sC2Hulewzklsgt3OntGNdYVZKsDgP+R+xlqtJUtrdv6+SPaKxjsP
         VvDFdGN3dN2vfFkZ7zF9wdc4EWKQYx7tsIEI20yaxTm573ydtNBlNf2sRaeqBG53/MSm
         OInUk8eQfQ6F1KlaKXAt3Zln4yL9/QqTV27npCAtWHRbEhSiOKQJnhJG0BROjYyDYlB8
         lFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ShbxCkrGW9DfdQVLrPQRJ9UfGCb7QUf2OMEdTXmy04Y=;
        b=U7TiTo6utJPU2HUNL9amU+WpfcKrwYL2WTN0Qx+YzBWG+vT0UumsqbMWvS41uX0oI6
         z6dh2QUqJiHQszDmSX2C6Ku48tnWtUfSyC2ZT93j2eXtbmq/d4fpAuejcGrBoqnunSHK
         9xdkjilR8P/P8NoyOxS69E233JFCE0enmnevTHtXtCwj2fzyuAC9PdpJVdNYLE2SgEZe
         6vPzlZqaL+968iptAgFqEuWkQBGkPDNJfSUFwaN/QseF8wxd8JIBRDgcbbZ8Qs2orxTo
         0VNOQFHmUo5up/k4UhPcrMcyP1Ss0rzXi9nGd96U6BPcYdzQQn4chKj+lSXvw+yshDL1
         86tA==
X-Gm-Message-State: ACgBeo0ldnUu8cEbRIFELHwjlXi0Dth7B4KiM/zaOZRHFHVesZppnJL4
        GM30YoK1KAJ7yaCMe71SHs/K7mnmViatK/gYRZ4gIIGrTQ==
X-Google-Smtp-Source: AA6agR46baW+w3Hw2OG0Ht2oaQK0LzlK8MO6J5K2QCqjWRuCavQasLOKr3UF4b59yAtTQd8beIaZO4uuf+Ot3yBoPg4=
X-Received: by 2002:aca:b7d5:0:b0:343:c478:91c6 with SMTP id
 h204-20020acab7d5000000b00343c47891c6mr1869336oif.136.1661526952167; Fri, 26
 Aug 2022 08:15:52 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com> <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk> <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
 <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com> <CAHC9VhQStPdfWwTKwqfz67hr3PErHmdu+s_3mAfATb0mu7MD2w@mail.gmail.com>
 <2e6b56cf-d04b-6537-62f4-a4cb0191172a@kernel.dk>
In-Reply-To: <2e6b56cf-d04b-6537-62f4-a4cb0191172a@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 26 Aug 2022 11:15:41 -0400
Message-ID: <CAHC9VhQ2gVEuHe_mhkv7=Ju8co1L+aQ7=WAR_CpmJ7wS8=0+0g@mail.gmail.com>
Subject: Re: [PATCH] Smack: Provide read control for io_uring_cmd
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Ankit Kumar <ankit.kumar@samsung.com>,
        io-uring@vger.kernel.org, joshi.k@samsung.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 23, 2022 at 8:07 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 8/23/22 6:05 PM, Paul Moore wrote:
> > On Tue, Aug 23, 2022 at 7:46 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>
> >> Limit io_uring "cmd" options to files for which the caller has
> >> Smack read access. There may be cases where the cmd option may
> >> be closer to a write access than a read, but there is no way
> >> to make that determination.
> >>
> >> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> >> --
> >>  security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
> >>  1 file changed, 32 insertions(+)
> >>
> >> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> >> index 001831458fa2..bffccdc494cb 100644
> >> --- a/security/smack/smack_lsm.c
> >> +++ b/security/smack/smack_lsm.c
> >
> > ...
> >
> >> @@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
> >>         return -EPERM;
> >>  }
> >>
> >> +/**
> >> + * smack_uring_cmd - check on file operations for io_uring
> >> + * @ioucmd: the command in question
> >> + *
> >> + * Make a best guess about whether a io_uring "command" should
> >> + * be allowed. Use the same logic used for determining if the
> >> + * file could be opened for read in the absence of better criteria.
> >> + */
> >> +static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
> >> +{
> >> +       struct file *file = ioucmd->file;
> >> +       struct smk_audit_info ad;
> >> +       struct task_smack *tsp;
> >> +       struct inode *inode;
> >> +       int rc;
> >> +
> >> +       if (!file)
> >> +               return -EINVAL;
> >
> > Perhaps this is a better question for Jens, but ioucmd->file is always
> > going to be valid when the LSM hook is called, yes?
>
> file will always be valid for uring commands, as they are marked as
> requiring a file. If no valid fd is given for it, it would've been
> errored early on, before reaching f_op->uring_cmd().

Hey Casey, where do things stand with this patch?  To be specific, did
you want me to include this in the lsm/stable-6.0 PR for Linus or are
you planning to send it separately?  If you want me to send it up, are
you planning another revision?

There is no right or wrong answer here as far as I'm concerned, I'm
just trying to make sure we are all on the same page.

-- 
paul-moore.com
